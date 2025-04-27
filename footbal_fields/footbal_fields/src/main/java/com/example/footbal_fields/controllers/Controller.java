package com.example.footbal_fields.controllers;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.repositories.PlayerRepositoryImpl;
import com.example.footbal_fields.servicies.PlayerService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@org.springframework.stereotype.Controller
public class Controller {
    @Autowired
    private PlayerService playerService;
    @GetMapping("/registerPage")
    public String showRegistration(Model model){
        return "register";
    }
    @PostMapping("/registerPlayer")
    public String registerPlayer(@RequestParam String username,
                                 @RequestParam int age,
                                 @RequestParam String password,
                                 @RequestParam(required = false) String fullName,
                                 RedirectAttributes redirectAttributes,
                                 HttpServletRequest request){
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
}
