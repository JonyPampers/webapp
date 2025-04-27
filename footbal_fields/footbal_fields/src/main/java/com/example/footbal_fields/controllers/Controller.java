package com.example.footbal_fields.controllers;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import com.example.footbal_fields.repositories.PlayerRepositoryImpl;
import com.example.footbal_fields.servicies.FieldService;
import com.example.footbal_fields.servicies.PlayerService;
import com.example.footbal_fields.servicies.TeamService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.Date;
import java.sql.Time;

@org.springframework.stereotype.Controller
public class Controller {
    @Autowired
    private FieldService fieldService;
    @Autowired
    private PlayerService playerService;
    @Autowired
    private TeamService teamService;
    @GetMapping("/registerPage")
    public String showRegistration(Model model){
        return "register";
    }
    @PostMapping("/registerPlayer")
    public String registerPlayer(@RequestParam String username,
                                 @RequestParam int age,
                                 @RequestParam String password,
                                 @RequestParam(required = false) String fullName,
                                 RedirectAttributes redirectAttributes){
        try {
            playerService.createPlayer(fullName, age, username, password);
            redirectAttributes.addFlashAttribute("success", "Регистрация успешна");
            return "redirect:loginPage";
        }catch (PlayerService.UsernameAlreadyExistsException e){
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:registerPage";
        }

    }
    @GetMapping("/loginPage")
    public String showLogin(){
        return "login";
    }
    @PostMapping("/loginPlayer")
    public String login(Model model, @RequestParam String username, @RequestParam String password, RedirectAttributes redirectAttributes, HttpSession session){
        try{
            if (playerService.login(username, password)){
                session.setAttribute("player", playerService.getPlayer(username));
                return "redirect:profile";
            }else {
                redirectAttributes.addFlashAttribute("error", "Неверный пароль");
                return "redirect:loginPage";
            }

        }catch (PlayerRepositoryImpl.EntityNotFoundException e){
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:loginPage";
        }
    }
    @GetMapping("/profile")
    public String showProfile(Model model, HttpSession session){
        model.addAttribute("player", session.getAttribute("player"));
        if (session.getAttribute("player")==null)
            return "redirect:loginPage";
        return "profile";
    }
    @PostMapping("/updatePersonalInfo")
    public String updatePersonalInfo(@RequestParam String name, @RequestParam int age, @RequestParam String gender, @RequestParam String status, HttpSession session, RedirectAttributes redirectAttributes){
        System.out.println("Session ID: " + session.getId());
        System.out.println("Player in session: " + session.getAttribute("player"));
        Player player = (Player) session.getAttribute("player");
        System.out.println(player.getId());
        player.setName(name);
        player.setAge(age);
        player.setGender(gender);
        player.setExperience(status);
        session.setAttribute("player", playerService.updatePersonalInfo(player));
        System.out.println(player.getName());
        System.out.println(player.getId());
        return "redirect:/profile";

    }
    @GetMapping("/myteams")
    public String showMyTeams(Model model, HttpSession session){
        Player player = (Player) session.getAttribute("player");
        model.addAttribute("teams", teamService.getTeamsByCreator(player.getId()));
        model.addAttribute("fields", fieldService.getFields());
        return "myteams";
    }
    @GetMapping("/logout")
    public String logout(){
        return "main";
    }
    @PostMapping("/create-team")
    public String createTeam(@RequestParam String name, @RequestParam Date gameDate, @RequestParam String gameTime, HttpSession session, @RequestParam int amount, @RequestParam String fieldId){
        Player player = (Player) session.getAttribute("player");
        Team team = new Team();
        team.setName(name);
        team.setAmount(amount);
        team.setGameDate(gameDate);
        if (gameTime == null || gameTime.isEmpty()) {
            throw new IllegalArgumentException("Время игры не может быть пустым");
        }

        // Преобразование с обработкой ошибок
        try {
            Time gameTime1 = Time.valueOf(gameTime + ":00"); // Добавляем секунды
            team.setGameTime(gameTime1);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Неверный формат времени. Используйте HH:mm");
        }
        team.setCreator(player.getId());
        int field = Integer.parseInt(fieldId.replaceAll(" ", ""));
        System.out.println(field);
        team.setFieldId(field);
        teamService.createTeam(team);
        return "redirect:myteams";
    }

}
