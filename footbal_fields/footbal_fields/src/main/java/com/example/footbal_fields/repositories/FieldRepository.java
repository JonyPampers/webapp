package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Field;

import java.util.List;

public interface FieldRepository {
    public Field getField(int id);
    public List<Field> getFields();
    public List<Field> getFavorites(int id);
    //+методы для поиска
}
