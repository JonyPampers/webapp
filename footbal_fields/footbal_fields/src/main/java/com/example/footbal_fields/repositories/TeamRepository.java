package com.example.footbal_fields.repositories;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;

import java.rmi.AlreadyBoundException;
import java.sql.Date;
import java.util.List;

public interface TeamRepository {
    public Team getTeam(int id);
    public List<Team> getTeamsForCreator(int id);
    public void createTeam(Team team);
    public Team updateTeam(Team team);
    public void deleteTeam(int id);
    public List<Team> getTeamsByDate(Date date);
    public List<Player> getPlayersByTeam(int id);
    public void joinTeam(int playerId, int id) throws AlreadyBoundException;
    public List<Team> getTeams();


}
