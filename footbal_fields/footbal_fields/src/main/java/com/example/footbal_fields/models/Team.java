package com.example.footbal_fields.models;

import lombok.Data;

import java.sql.Time;
import java.util.Date;
import java.util.List;
@Data
public class Team {
    private Integer id;
    private List<Player> players;
    private int fieldId;
    private Date gameDate;
    private Time gameTime;
    private int amount;
    private int creator;
    private String name;
    private String creatorName;
    private String creatorContact;

    public String getCreatorContact() {
        return creatorContact;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorContact(String creatorContact) {
        this.creatorContact = creatorContact;
    }

    public void setName(String name){this.name=name;}
    public String getName(){return name;}
    public void setCreator(int id){creator=id;}
    public int getCreator(){return creator;}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFieldId() {
        return fieldId;
    }

    public Date getGameDate() {
        return gameDate;
    }

    public List<Player> getPlayers() {
        return players;
    }

    public int getAmount() {
        return amount;
    }

    public Time getGameTime() {
        return gameTime;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public void setFieldId(int fieldId) {
        this.fieldId = fieldId;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
    }

    public void setGameDate(Date gameDate) {
        this.gameDate = gameDate;
    }

    public void setGameTime(Time gameTime) {
        this.gameTime = gameTime;
    }

}
