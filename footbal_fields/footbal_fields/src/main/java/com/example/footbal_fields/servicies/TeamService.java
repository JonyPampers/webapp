package com.example.footbal_fields.servicies;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import com.example.footbal_fields.repositories.TeamRepository;
import com.example.footbal_fields.repositories.TeamRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.rmi.AlreadyBoundException;
import java.sql.Date;
import java.util.List;

@Service
public class TeamService {
    @Autowired
    private TeamRepository teamRepository;
    public void createTeam(Team team){
        teamRepository.createTeam(team);
    }
    public List<Team> getTeamsByCreator(int id){
        return teamRepository.getTeamsForCreator(id);
    }
    public Team updateTeam(Team team){teamRepository.updateTeam(team); return team;}
    public void deleteTeam(int id){teamRepository.deleteTeam(id);}
    public List<Team> getTeamsByDate(Date date){return teamRepository.getTeamsByDate(date);}
    public List<Player> getPlayersByTeam(int id){return teamRepository.getPlayersByTeam(id);}
    public void joinTeam(int plid, int id){
        try {
            teamRepository.joinTeam(plid, id);
        }catch (TeamRepositoryImpl.AlreadyJoinedException e){
            throw e;
        } catch (AlreadyBoundException e) {
            throw new RuntimeException(e);
        }
    }
    public List<Team> getTeams(){return teamRepository.getTeams();}
    public List<Team> apoints(int id){return teamRepository.getTeamsByAppointment(id);}
}
