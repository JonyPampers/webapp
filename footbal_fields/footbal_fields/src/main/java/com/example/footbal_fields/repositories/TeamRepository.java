package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Team;

import java.util.List;

public interface TeamRepository {
    public Team getTeam(int id);
    public List<Team> getTeamsForCreator(int id);
    public void createTeam(Team team);
}
