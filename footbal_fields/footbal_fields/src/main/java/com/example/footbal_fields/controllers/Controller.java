package com.example.footbal_fields.controllers;
import com.example.footbal_fields.models.Field;
import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.models.Team;
import com.example.footbal_fields.repositories.PlayerRepositoryImpl;
import com.example.footbal_fields.servicies.FieldService;
import com.example.footbal_fields.servicies.PlayerService;
import com.example.footbal_fields.servicies.TeamService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;

@org.springframework.stereotype.Controller
public class Controller {
    @Autowired
    private FieldService fieldService;
    @Autowired
    private PlayerService playerService;
    @Autowired
    private TeamService teamService;
    @GetMapping("/")
    public String showMain(Model model) {
        model.addAttribute("fields", fieldService.getFields());
        model.addAttribute("services", fieldService.getServices());
        return "main";
    }
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
        Player player = (Player) session.getAttribute("player");
        player.setName(name);
        player.setAge(age);
        player.setGender(gender);
        player.setExperience(status);
        session.setAttribute("player", playerService.updatePersonalInfo(player));
        return "redirect:/profile";
    }
    @PostMapping("/update-contacts")
    public String updateContacts(@RequestParam String contact, HttpSession session){
        Player player = (Player) session.getAttribute("player");
        player.setContact(contact);
        playerService.updateContacts(player);
        session.setAttribute("player", player);
        return "redirect:profile";
    }
    @GetMapping("/myteams")
    public String showMyTeams(Model model, HttpSession session){
        if (session.getAttribute("player")==null){
            return "redirect:loginPage";
        }
        Player player = (Player) session.getAttribute("player");
        model.addAttribute("teams", teamService.getTeamsByCreator(player.getId()));
        model.addAttribute("fields", fieldService.getFields());
        model.addAttribute("appointments", teamService.apoints(((Player) session.getAttribute("player")).getId()));
        return "myteams";
    }
    @GetMapping("/logoutPage")
    public String logout(HttpSession session){
        session.removeAttribute("player");
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
        String cleanNumber = fieldId
                .replace("\u00A0", "")  // Неразрывный пробел
                .replace("\u202F", "")   // Тонкий пробел (в некоторых локалях)
                .replace(" ", "");       // Обычный пробел
        team.setFieldId(Integer.parseInt(cleanNumber));
        teamService.createTeam(team);

        return "redirect:myteams";
    }
    @PostMapping("/update-team")
    public String updateTeam(@RequestParam String name, @RequestParam Date date, @RequestParam String time, @RequestParam int amount, @RequestParam String fieldId, @RequestParam int teamId){
        Team team = new Team();
        team.setName(name);
        team.setGameDate(date);
        if (time == null || time.isEmpty()) {
            throw new IllegalArgumentException("Время игры не может быть пустым");
        }

        // Преобразование с обработкой ошибок
        try {
            Time gameTime1 = Time.valueOf(time + ":00"); // Добавляем секунды
            team.setGameTime(gameTime1);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Неверный формат времени. Используйте HH:mm");
        }
        team.setAmount(amount);
        String cleanNumber = fieldId
                .replace("\u00A0", "")  // Неразрывный пробел
                .replace("\u202F", "")   // Тонкий пробел (в некоторых локалях)
                .replace(" ", "");       // Обычный пробел
        team.setFieldId(Integer.parseInt(cleanNumber));
        team.setId(teamId);
        teamService.updateTeam(team);
        return "redirect:myteams";

    }
    @PostMapping("/delete-team")
    public String deleteTeam(@RequestParam int teamId){
        teamService.deleteTeam(teamId);
        return "redirect:myteams";
    }
    @GetMapping("/teams")
    public String teams(Model model) throws JsonProcessingException {
        model.addAttribute("games", teamService.getTeams());
        model.addAttribute("fields", fieldService.getFields());
        List<Team> games = teamService.getTeamsByDate(Date.valueOf(LocalDate.now()));
        ObjectMapper mapper = new ObjectMapper();
        String gamesJson = mapper.writeValueAsString(games);
        model.addAttribute("gamesJson", gamesJson);
        return "teams";
    }
    @PostMapping("join-team")
    public String joinTeam(@RequestParam("gameId") int gameId, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("player") == null) {
            return "redirect:loginPage";
        }
        Player player = (Player) session.getAttribute("player");
        teamService.joinTeam(player.getId(), gameId);
        return "redirect:teams";
    }
    @PostMapping("/getCreator")
    public Player getCreator(@RequestParam int creator){
        return playerService.getPlayer(creator);
    }
    @PostMapping("/get-field")
    public Field getField(@RequestParam int id){
        return fieldService.getField(id);
    }

}