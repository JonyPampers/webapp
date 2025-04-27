package com.example.footbal_fields.repositories;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import com.example.footbal_fields.models.Player;

import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class PlayerRepositoryImpl implements PlayerRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Override
    public Player getPlayer(String username) {
        String query = "select * from player where username = "+"'"+username+"';";
        return jdbcTemplate.queryForObject(query, new RowMapper<Player>() {
            @Override
            public Player mapRow(ResultSet rs, int rowNum) throws SQLException {
                Player player = new Player();
                player.setId(rs.getInt("id"));
                player.setName(rs.getString("full_name"));
                player.setAge(rs.getInt("age"));
                player.setContact(rs.getString("contact_info"));
                player.setExperience(rs.getString("status"));
                player.setUsername(rs.getString("username"));
                player.setPasswordHash(rs.getString("password_hash"));
                player.setRegistrationDate(rs.getDate("created_at"));
                player.setGender(rs.getString("gender"));
                try {
                    setDistrict(player, rs.getInt("district_id"));
                }catch (EmptyResultDataAccessException e){
                    throw e;
                }

                return player;
            }
        });
    }

    @Override
    public void createPlayer(Player player) {
        String query = "insert into player (username, password_hash, full_name, age, status, contact_info) values (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(query, player.getUsername(), player.getPasswordHash(), player.getName(), player.getAge(), player.getExperience(), player.getContact());
    }

    @Override
    public void deletePlayer(Player player) {

    }

    @Override
    public Player updatePlayer(Player player) {
        String query = "UPDATE players\n" +
                "SET \n" +
                "    name = ?,\n" +
                "    gender = ?,\n" +
                "    age = ?,\n" +
                "    status = ?,\n" +
                "    contact = ?,\n" +
                "WHERE \n" +
                "    id = ?;";
        jdbcTemplate.update(query, player.getName(), player.getGender(), player.getAge(), player.getExperience(), player.getContact(), player.getId());
        return player;
    }
    @Override
    public Player login(String username){

            String query = "select username, password_hash from player where username = " + "'" + username + "';";
        try {
            return jdbcTemplate.queryForObject(query, new RowMapper<Player>() {
                @Override
                public Player mapRow(ResultSet rs, int rowNum) throws SQLException {
                    Player player = new Player();
                    player.setUsername(rs.getString("username"));
                    player.setPasswordHash(rs.getString("password_hash"));
                    return player;
                }

                ;
            });
        }catch (EmptyResultDataAccessException e) {
            throw new EntityNotFoundException("Пользователь с логином " + username + " не найден");
        }

    }
    private Player setDistrict(Player player, int id){
        String query = "select name from districts where id = "+"'"+id+"';";
        try{
            return jdbcTemplate.queryForObject(query, new RowMapper<Player>() {
                @Override
                public Player mapRow(ResultSet rs, int rowNum) throws SQLException {
                    player.setDistrict(rs.getString("name"));
                    return player;
                }
            });
        }catch (EmptyResultDataAccessException e){
            player.setDistrict("Не указан");
            return player;
        }
    }
    public class EntityNotFoundException extends RuntimeException {
        public EntityNotFoundException(String message) {
            super(message);
        }
    }
}
