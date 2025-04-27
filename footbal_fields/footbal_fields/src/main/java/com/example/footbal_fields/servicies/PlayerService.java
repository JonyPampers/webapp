package com.example.footbal_fields.servicies;

import com.example.footbal_fields.models.Player;
import com.example.footbal_fields.repositories.PlayerRepository;
import com.example.footbal_fields.repositories.PlayerRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class PlayerService {
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public void createPlayer(String name, int age, String username, String password){

        /*if ((playerRepository.getPlayer(username)).getUsername() !=null){
            throw new UsernameAlreadyExistsException("Пользователь с таким логином уже существует");
        }
        
         */
        Player player = new Player();
        player.setName(name);
        player.setAge(age);
        player.setUsername(username);
        player.setPasswordHash(encoder.encode(password));

            playerRepository.createPlayer(player);

    }
    public boolean login(String username, String password){
        Player player = playerRepository.login(username);
        try {
            if (encoder.matches(password, player.getPasswordHash())) {
                return true;
            } else return false;
        }catch (PlayerRepositoryImpl.EntityNotFoundException e){
            throw e;
        }
    }
    public Player getPlayer(String username){
        return playerRepository.getPlayer(username);
    }
    public Player updatePersonalInfo(Player player){
        return playerRepository.updatePlayer(player);

    }
    public class UsernameAlreadyExistsException extends RuntimeException {
        public UsernameAlreadyExistsException(String message) {
            super(message);
        }
    }
    public class UserNotFoundException extends RuntimeException{
        public UserNotFoundException(String message){
            super(message);
        }
    }
}

