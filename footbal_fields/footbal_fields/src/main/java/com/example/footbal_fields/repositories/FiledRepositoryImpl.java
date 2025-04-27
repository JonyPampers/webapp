package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Field;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
@Repository
public class FiledRepositoryImpl implements FieldRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Override
    public Field getField(int id) {
        return null;
    }

    @Override
    public List<Field> getFields() {
        String query = "select * from field";
        return jdbcTemplate.query(query, new RowMapper<Field>() {
            @Override
            public Field mapRow(ResultSet rs, int rowNum) throws SQLException {
                Field field = new Field();
                field.setId(rs.getInt("global_id"));
                field.setAddress(rs.getString("address"));
                field.setName(rs.getString("name"));
                return field;

            }
        });
    }

    @Override
    public List<Field> getFavorites(int id) {
        return null;
    }
}
