package com.example.footbal_fields.repositories;

import java.util.List;

public interface CommonRepository {
    public List<String> getDistricts();
    public int getIdByNameDistrict(String name);
    public String getNameByIdDistrict(int id);
}
