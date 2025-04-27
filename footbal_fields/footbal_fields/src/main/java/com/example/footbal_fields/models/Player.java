package com.example.footbal_fields.models;
import lombok.Data;

import java.util.List;
@Data
public class Player {
    private int id;
    private String name;
    private int age;
    private String experience;
    private String contact;
    private List<Field> favorites;
    private String username;
    private String passwordHash;

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public int getAge() {
        return age;
    }

    public List<Field> getFavorites() {
        return favorites;
    }

    public String getExperience() {
        return experience;
    }

    public String getContact() {
        return contact;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getUsername() {
        return username;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public void setFavorites(List<Field> favorites) {
        this.favorites = favorites;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
