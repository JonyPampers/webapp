package com.example.footbal_fields.models;

import lombok.Data;

import java.util.List;
@Data
public class Field {
    private int id;
    private String address;
    private int x;
    private int y;
    private int central;
    private List<Service> services;

    public int getId() {
        return id;
    }

    public int getX() {
        return x;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public int getCentral() {
        return central;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setCentral(int central) {
        this.central = central;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }
}
