package com.football.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


import com.board.util.DBConnection;
import com.football.model.League;

public class LeagueDAO {
    
    
	// com.board.util 패키지의 DBConnection 클래스의 인스턴스를 통하여 DB연결
    DBConnection dbConn = new DBConnection();
    
    // 특정 리그의 순위 가져오기
    public List<League> getLeagueStandings(String leagueName) {
        List<League> standings = new ArrayList<>();
        String sql = "SELECT id, league_name, team_name, position, updated_at " +
                    "FROM league_standings WHERE league_name = ? ORDER BY position ASC";
        
        try (Connection conn = dbConn.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, leagueName);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                League league = new League();
                league.setId(rs.getInt("id"));
                league.setLeagueName(rs.getString("league_name"));
                league.setTeamName(rs.getString("team_name"));
                league.setPosition(rs.getInt("position"));
                league.setUpdatedAt(rs.getTimestamp("updated_at"));
                standings.add(league);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return standings;
    }
   
}