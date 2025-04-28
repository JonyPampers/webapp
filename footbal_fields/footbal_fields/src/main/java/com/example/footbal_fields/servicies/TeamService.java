package com.example.footbal_fields.servicies;

import com.example.footbal_fields.models.Team;
import com.example.footbal_fields.repositories.TeamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
