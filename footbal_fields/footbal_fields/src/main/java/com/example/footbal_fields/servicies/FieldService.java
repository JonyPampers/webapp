package com.example.footbal_fields.servicies;

import com.example.footbal_fields.models.Field;
import com.example.footbal_fields.repositories.FieldRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class FieldService {
    @Autowired
    private FieldRepository fieldRepository;
    public List<Field> getFields(){
        return fieldRepository.getFields();
    }
    public Field getField(int id){return fieldRepository.getField(id);}

    public List<com.example.footbal_fields.models.Service> getServices(){return fieldRepository.getServices();}
}
