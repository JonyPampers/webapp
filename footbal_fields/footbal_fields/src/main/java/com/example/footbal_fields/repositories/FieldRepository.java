package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Field;
import com.example.footbal_fields.models.Service;

import java.time.chrono.IsoEra;
import java.util.List;

public interface FieldRepository {
    public Field getField(int id);
    public List<Field> getFields();
    public List<Field> getFavorites(int id);
    //+методы для поиска
    public List<Service> getServices();
    public List<Service> getServicesByField(int id);
    public String getPhone(int id);
    public String getEmail(int id);

}
