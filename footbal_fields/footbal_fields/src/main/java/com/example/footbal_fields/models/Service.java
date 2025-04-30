package com.example.footbal_fields.models;

import lombok.Data;

@Data
public class Service {
    private int id;
    private String name;
    private String description;
    public String getDescription(){return description;}
    public void setDescription(String description){this.description=description;}

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
