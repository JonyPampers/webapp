package com.example.footbal_fields.repositories;
import com.example.footbal_fields.models.Player;

public interface PlayerRepository {
    public Player getPlayer(String username);
    public void createPlayer(Player player);
    public void deletePlayer(Player player);
    public Player updatePlayer(Player player);
    public Player login(String username);
}
