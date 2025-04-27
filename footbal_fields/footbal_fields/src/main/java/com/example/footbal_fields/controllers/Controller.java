package com.example.footbal_fields.controllers;

import com.example.footbal_fields.repositories.PlayerRepositoryImpl;
import com.example.footbal_fields.servicies.PlayerService;
import jakarta.servlet.http.HttpServletRequest;
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
    public String login(@RequestParam String username, @RequestParam String password, RedirectAttributes redirectAttributes){
        try{
            if (playerService.login(username, password))
                return "redirect:main";
            else {
                redirectAttributes.addFlashAttribute("error", "Неверный пароль");
                return "redirect:LoginPage";
            }

        }catch (PlayerRepositoryImpl.EntityNotFoundException e){
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:loginPage";
        }
    }
}
