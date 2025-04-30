package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.rmi.AlreadyBoundException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
    @Override
    public Team updateTeam(Team team){
        String query = "update team set name=?, field_id=?, game_date=?, game_time=?, amount=? where id =?;";
        jdbcTemplate.update(query, team.getName(), team.getFieldId(), team.getGameDate(), team.getGameTime(), team.getAmount(), team.getId());
        return team;
    }
    @Override
    public void deleteTeam(int id){
        String query =  "DELETE FROM team \n" +
                "WHERE id = ?;";
        jdbcTemplate.update(query, id);
    }
    @Override
    public List<Team> getTeamsByDate(Date date){
        String query = "select * from team where DATE(game_date)="+"'"+date+"'"+";";
        return jdbcTemplate.query(query, new RowMapper<Team>() {
            @Override
            public Team mapRow(ResultSet rs, int rowNum) throws SQLException {
                Team team = new Team();
                team.setId(rs.getInt("id"));
                team.setName(rs.getString("name"));
                team.setGameDate(rs.getDate("game_date"));
                team.setGameTime(rs.getTime("game_time"));
                team.setCreator(rs.getInt("created_by"));
                team.setAmount(rs.getInt("amount"));
                team.setPlayers(getPlayersByTeam(rs.getInt("id")));
                team.setPlayers(getPlayersByTeam(rs.getInt("id")));
                return team;
            }
        });
    }
    @Override
    public List<Player> getPlayersByTeam(int id){
        String query = "SELECT p.*\n" +
                "FROM player p\n" +
                "JOIN teammembers tm ON p.id = tm.player_id\n" +
                "WHERE tm.team_id = "+id+";";
        return jdbcTemplate.query(query, new RowMapper<Player>() {
            @Override
            public Player mapRow(ResultSet rs, int rowNum) throws SQLException {
                Player player = new Player();
                player.setId(rs.getInt("id"));
                player.setName(rs.getString("full_name"));
                player.setContact(rs.getString("contact_info"));
                return player;
            }
        });
    }

    @Override
    public void joinTeam(int playerId, int id) throws AlreadyBoundException {
        String query = "insert into teammembers (player_id, team_id) values (?, ?);";
        try{
            jdbcTemplate.update(query, playerId, id);
        }catch (AlreadyJoinedException e){
            throw new AlreadyBoundException("Вы уже записались в клманду!");
        }
    }
    @Override
    public List<Team> getTeams(){
        String query = "select * from team";
        return jdbcTemplate.query(query, new RowMapper<Team>() {
            @Override
            public Team mapRow(ResultSet rs, int rowNum) throws SQLException {
                Team team = new Team();
                team.setId(rs.getInt("id"));
                team.setName(rs.getString("name"));
                team.setAmount(rs.getInt("amount"));
                team.setGameTime(rs.getTime("game_time"));
                team.setGameDate(rs.getTime("game_date"));
                team.setCreator(rs.getInt("created_by"));
                List<Player> players = getPlayersByTeam(rs.getInt("id"));
                Player player = new Player();
                player.setId(rs.getInt("created_by"));
                players.add(player);
                team.setPlayers(players);
                return team;
            }
        });
    }
    public class AlreadyJoinedException extends RuntimeException {
        public AlreadyJoinedException(String message) {
            super(message);
        }
    }
}
