package com.football.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.football.model.League;

public class LeagueDAO {
    
    // 데이터베이스 연결 (NewsDAO와 동일한 방식)
    Connection getConnection() throws Exception {
        Context initContext = new InitialContext();
        Context envContext = (Context) initContext.lookup("java:comp/env");
        DataSource dataSource = (DataSource) envContext.lookup("jdbc/FromJ");
        return dataSource.getConnection();
    }
    
    // 특정 리그의 순위 가져오기
    public List<League> getLeagueStandings(String leagueName) {
        List<League> standings = new ArrayList<>();
        String sql = "SELECT id, league_name, team_name, position, updated_at " +
                    "FROM league_standings WHERE league_name = ? ORDER BY position ASC";
        
        try (Connection conn = getConnection();
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
    
    // 순위 업데이트 (관리자용)
    public boolean updateStandings(List<League> standings) {
        String sql = "UPDATE league_standings SET position = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (League league : standings) {
                pstmt.setInt(1, league.getPosition());
                pstmt.setInt(2, league.getId());
                pstmt.addBatch();
            }
            
            int[] results = pstmt.executeBatch();
            return results.length > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}