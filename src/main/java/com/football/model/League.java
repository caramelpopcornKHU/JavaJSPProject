package com.football.model;

import java.sql.Timestamp;

public class League {
    private int id;
    private String leagueName;
    private String teamName;
    private int position;
    private Timestamp updatedAt;
    
    public League() {}
    
    public League(String leagueName, String teamName, int position) {
        this.leagueName = leagueName;
        this.teamName = teamName;
        this.position = position;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getLeagueName() { return leagueName; }
    public void setLeagueName(String leagueName) { this.leagueName = leagueName; }
    
    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }
    
    public int getPosition() { return position; }
    public void setPosition(int position) { this.position = position; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}