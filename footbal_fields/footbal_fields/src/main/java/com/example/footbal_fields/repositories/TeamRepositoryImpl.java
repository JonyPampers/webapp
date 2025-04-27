package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Field;
import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class TeamRepositoryImpl implements TeamRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public Team getTeam(int id) {
        return null;
    }

    @Override
    public List<Team> getTeamsForCreator(int id) {
        String query = "select * from team where created_by="+"'"+id+"';";
        return jdbcTemplate.query(query, new RowMapper<Team>() {
            @Override
            public Team mapRow(ResultSet rs, int rowNum) throws SQLException {
                Team team = new Team();
                team.setId(rs.getInt("id"));
                team.setAmount(rs.getInt("amount"));
                team.setGameDate(rs.getDate("game_date"));
                team.setGameTime(rs.getTime("game_time"));
                team.setName(rs.getString("name"));
                team.setFieldId(rs.getInt("field_id"));
                return team;
            }
        });
    }
    @Override
    public void createTeam(Team team){
        String query = "insert into team (name, amount, game_date, game_time, created_by, field_id) values (?, ?, ?, ?, ?, ?);";
        jdbcTemplate.update(query, team.getName(), team.getAmount(), team.getGameDate(), team.getGameTime(), team.getCreator(), team.getFieldId());
    }
}
