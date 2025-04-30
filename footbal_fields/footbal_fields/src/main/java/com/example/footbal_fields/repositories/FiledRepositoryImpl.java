package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Field;
import com.example.footbal_fields.models.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
@Repository
public class FiledRepositoryImpl implements FieldRepository{
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Override
    public Field getField(int id) {
        String query = "select * from field where global_id = "+id+";";
        return jdbcTemplate.queryForObject(query, new RowMapper<Field>() {
            @Override
            public Field mapRow(ResultSet rs, int rowNum) throws SQLException {
                Field field= new Field();
                field.setName(rs.getString("name"));
                field.setId(rs.getInt("global_id"));
                field.setAddress(rs.getString("address"));
                return field;
            }
        });
    }

    @Override
    public List<Field> getFields() {

        String query = "SELECT *, ST_X(geo_data) as longitude, ST_Y(geo_data) as latitude FROM field WHERE name LIKE '%футбол%' OR nameWinter LIKE '%футбол%';";
        return jdbcTemplate.query(query, new RowMapper<Field>() {
            @Override
            public Field mapRow(ResultSet rs, int rowNum) throws SQLException {
                Field field = new Field();
                field.setId(rs.getInt("global_id"));
                field.setAddress(rs.getString("address"));
                field.setName(rs.getString("name"));

                // Извлекаем координаты из geo_data
                field.setY(rs.getDouble("longitude"));  // долгота (X)
                field.setX(rs.getDouble("latitude"));   // широта (Y)

                List<Service> services = getServicesByField(rs.getInt("global_id"));
                field.setServices(services);
                field.setDisability(rs.getString("disability_friendly"));
                field.setIs_paid(rs.getString("is_paid"));
                field.setLighting(rs.getString("lighting"));
                field.setSeats(rs.getInt("seats"));
                field.setPhone(getPhone(rs.getInt("global_id")));
                field.setEmail(getEmail(rs.getInt("global_id")));
                return field;
            }
        });
    }
    @Override
    public String getPhone(int id){
        String query = "select phone from contacts where field_id = "+id+";";
        return jdbcTemplate.queryForObject(query, new RowMapper<String>() {
            @Override
            public String mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getString("phone");
            }
        });
    }
    @Override
    public String getEmail(int id){
        String query = "select email from contacts where field_id = "+id+";";
        return jdbcTemplate.queryForObject(query, new RowMapper<String>() {
            @Override
            public String mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getString("email");
            }
        });
    }

    @Override
    public List<Field> getFavorites(int id) {
        return null;
    }
    @Override
    public List<Service> getServices(){
        String query = "select * from services";
        return jdbcTemplate.query(query, new RowMapper<Service>() {
            @Override
            public Service mapRow(ResultSet rs, int rowNum) throws SQLException {
                Service service=new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setDescription(rs.getString("description"));
                return service;
            }
        });
    }
    @Override
    public List<Service> getServicesByField(int id){
        String query = "SELECT s.id AS service_id, s.name AS service_name, fs.service_value AS service_detail FROM facilityservices fs JOIN services s ON fs.service_id = s.id WHERE fs.field_id = ? -- Подставьте нужный ID площадки ORDER BY s.name;";
        return jdbcTemplate.query(query, new RowMapper<Service>() {
            @Override
            public Service mapRow(ResultSet rs, int rowNum) throws SQLException {
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                service.setName(rs.getString("service_name"));
                return service;
            }
        }, id);
    }
}
