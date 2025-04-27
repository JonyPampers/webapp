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
        return null;
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
    public class EntityNotFoundException extends RuntimeException {
        public EntityNotFoundException(String message) {
            super(message);
        }
    }
}
