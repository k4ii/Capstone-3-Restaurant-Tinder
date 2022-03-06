package com.techelevator.dao;

import com.techelevator.model.GroupMembers;
import com.techelevator.model.Restaurant;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcGroupMembersDao implements GroupMembersDao{

        private final JdbcTemplate jdbcTemplate;

        public JdbcGroupMembersDao(JdbcTemplate jdbcTemplate) {
            this.jdbcTemplate = jdbcTemplate;
        }


        private GroupMembers mapRowToGroupMembers(SqlRowSet rs) {
            GroupMembers groupMembers = new GroupMembers();
            groupMembers.setMember_id(rs.getInt("member_id"));
            groupMembers.setMember_name(rs.getString("member_name"));
            groupMembers.setMember_url(rs.getString("member_url"));
            groupMembers.setGroup_id(rs.getInt("group_id"));

            return groupMembers;
        }

    @Override
    public List<GroupMembers> findByGroupId(int groupId) {
        return null;
    }

    @Override
    public GroupMembers createVote(int member_id, String member_name, String member_url, int group_id, int user_vote) {
        return null;
    }

    @Override
    public List<Restaurant> sendListToGroupByGroupId(int groupId) {
        return null;
    }
}

