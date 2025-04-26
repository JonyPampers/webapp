package com.example.footbal_fields.models;

import lombok.Data;

import java.sql.Time;
import java.util.Date;
import java.util.List;
@Data
public class Team {
    private int id;
    private List<User> players;
    private int fieldId;
    private Date gameDate;
    private Time gameTime;
    private int amount;

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

    public List<User> getPlayers() {
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

    public void setPlayers(List<User> players) {
        this.players = players;
    }

    public void setGameDate(Date gameDate) {
        this.gameDate = gameDate;
    }

    public void setGameTime(Time gameTime) {
        this.gameTime = gameTime;
    }

}
