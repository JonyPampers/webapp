package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.rmi.AlreadyBoundException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
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
    public List<Team> getTeams() {
        String query = "SELECT * FROM team";
        try {
            return jdbcTemplate.query(query, new RowMapper<Team>() {
                @Override
                public Team mapRow(ResultSet rs, int rowNum) throws SQLException {
                    try {
                        Team team = new Team();
                        team.setId(rs.getInt("id"));
                        team.setName(rs.getString("name"));
                        team.setAmount(rs.getInt("amount"));
                        team.setGameTime(rs.getTime("game_time"));
                        team.setGameDate(rs.getDate("game_date")); // Исправил на getDate вместо getTime
                        team.setCreator(rs.getInt("created_by"));

                        // Обработка игроков с обработкой возможных исключений
                        try {
                            List<Player> players = getPlayersByTeam(rs.getInt("id"));
                            Player player = getPlayer(rs.getInt("created_by")); // Исправил на created_by вместо id команды

                            if (player != null) {
                                team.setCreatorName(player.getName());
                                team.setCreatorContact(player.getContact());
                                players.add(player);
                            }
                            team.setPlayers(players);
                        } catch (DataAccessException e) {
                            // Логируем ошибку, но продолжаем работу с пустым списком игроков
                            team.setPlayers(Collections.emptyList());

                        }

                        return team;
                    } catch (SQLException e) {
                        throw new RuntimeException("Ошибка при маппинге данных команды", e);
                    }
                }
            });
        } catch (DataAccessException e) {
            // Логируем ошибку и возвращаем пустой список

            return Collections.emptyList();
        }
    }
    @Override
    public List<Team> getTeamsByAppointment(int id) {
        String sql = "SELECT * FROM team WHERE id IN (SELECT team_id FROM teammembers WHERE player_id = ?)";
        try {
            return jdbcTemplate.query(sql, new RowMapper<Team>() {
                @Override
                public Team mapRow(ResultSet rs, int rowNum) throws SQLException {
                    try {
                        Team team = new Team();
                        team.setId(rs.getInt("id"));
                        team.setName(rs.getString("name"));
                        team.setAmount(rs.getInt("amount"));
                        team.setGameTime(rs.getTime("game_time"));
                        team.setGameDate(rs.getDate("game_date")); // Исправлено на getDate
                        team.setCreator(rs.getInt("created_by"));

                        // Обработка игроков с обработкой возможных исключений
                        try {
                            List<Player> players = getPlayersByTeam(rs.getInt("id"));
                            Player creator = getPlayer(rs.getInt("created_by")); // Получаем создателя по created_by

                            if (creator != null) {
                                team.setCreatorName(creator.getName());
                                team.setCreatorContact(creator.getContact());
                                players.add(creator); // Добавляем создателя в список игроков
                            }
                            team.setPlayers(players);
                        } catch (DataAccessException e) {
                            // Логируем ошибку, но продолжаем работу с пустым списком игроков
                            team.setPlayers(Collections.emptyList());

                        }

                        return team;
                    } catch (SQLException e) {
                        throw new RuntimeException("Ошибка при маппинге данных команды", e);
                    }
                }
            }, id);
        } catch (DataAccessException e) {
            // Логируем ошибку и возвращаем пустой список

            return Collections.emptyList();
        }
    }
    private Player getPlayer(int id){
        String sql = "SELECT * FROM player WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new RowMapper<Player>() {
                @Override
                public Player mapRow(ResultSet rs, int rowNum) throws SQLException {
                    Player player = new Player();
                    player.setId(rs.getInt("id"));
                    player.setContact(rs.getString("contact_info"));
                    player.setName(rs.getString("full_name"));
                    return player;
                }
            }, id);
        } catch (EmptyResultDataAccessException e) {
            // Обработка случая, когда игрок не найден
            return null; // или можно вернуть new Player() с дефолтными значениями
        } catch (DataAccessException e) {
            // Обработка других ошибок доступа к данным
            throw new RuntimeException("Ошибка при получении данных игрока: " + e.getMessage(), e);
        }
    }
    public class AlreadyJoinedException extends RuntimeException {
        public AlreadyJoinedException(String message) {
            super(message);
        }
    }
}
