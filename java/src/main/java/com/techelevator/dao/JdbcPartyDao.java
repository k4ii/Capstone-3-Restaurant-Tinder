package com.techelevator.dao;

import com.techelevator.controller.RestaurantTinderController;
import com.techelevator.model.Party;
import com.techelevator.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;



@Component
public class JdbcPartyDao implements PartyDao {
    private final Logger log = LoggerFactory.getLogger(JdbcPartyDao.class);

    private final JdbcTemplate jdbcTemplate;

    public JdbcPartyDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Party> findAll(String username){
        log.info("findAll for: " + username);
        List<Party> party = new ArrayList<>();
        String sql = "SELECT * FROM groups WHERE user_id = ?";
        int userId = getIdByUserId(username);
        log.info("found user_id:" + userId);
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
        while(results.next()) {
            log.info("Found Group: " + results.getString("event_name"));
            party.add(mapRowToParty(results));
        }
        return party;
    }

    @Override
    public boolean create(Party party){
        GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
        String id_column = "group_id";
        String insertGroup = "insert into groups (event_name,user_id,end_date,has_ended,location) values(?,?,?,?,?)";
        boolean groupCreated = jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(insertGroup, new String[]{id_column});
            ps.setString(1, party.getName());
            ps.setInt(2, getIdByUserId(party.getUserId()));
            ps.setTimestamp(3, party.getEndDate());
            ps.setBoolean(4, party.isHasEnded());
            ps.setString(5, party.getLocation());
            return ps;
        }
        , keyHolder) == 1;
        return groupCreated;
    }

    private int getIdByUserId(String userId){
        String sql = "SELECT * FROM users WHERE username = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
        if(results.next()){
            return results.getInt("user_id");
        }
        return 0;
    }

    private Party mapRowToParty(SqlRowSet rs) {
        Party party = new Party();
        party.setId(rs.getInt("group_id"));
        party.setName(rs.getString("event_name"));
        party.setHostId(rs.getInt("user_id"));
        party.setEndDate(rs.getTimestamp("end_date"));
        party.setHasEnded(rs.getBoolean("has_ended"));
        party.setLocation(rs.getString("location"));
        return party;
    }


}
