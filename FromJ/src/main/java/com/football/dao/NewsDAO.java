package com.football.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.board.util.DBConnection;
import com.football.model.BreakingNews;
import com.football.model.News;


public class NewsDAO {
	
	// com.board.util 패키지의 DBConnection 클래스의 인스턴스를 통하여 DB연결
    DBConnection dbConn = new DBConnection();
    
    // 최신 뉴스 목록 가져오기
    public List<News> getLatestNews(int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = dbConn.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setSummary(rs.getString("summary"));
                news.setImageUrl(rs.getString("image_url"));
                news.setCategory(rs.getString("category"));
                news.setCreatedAt(rs.getTimestamp("created_at"));
                news.setCommentCount(rs.getInt("comment_count"));
                
                newsList.add(news);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return newsList;
    }
    
    // 랜덤 뉴스 목록 가져오기 (새로 추가)
    public List<News> getRandomNews(int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY RAND() LIMIT ?"; 
        
        try (Connection conn = dbConn.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            System.out.println("랜덤 소식 조회");
            int count = 0;
            while (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setSummary(rs.getString("summary"));
                news.setImageUrl(rs.getString("image_url"));
                news.setCategory(rs.getString("category"));
                news.setCreatedAt(rs.getTimestamp("created_at"));
                news.setCommentCount(rs.getInt("comment_count"));
                
                newsList.add(news);
                count++;
                System.out.println(count + "번째: " + news.getTitle());
            }
            
        } catch (Exception e) {
            System.out.println("getRandomNews에러");
            e.printStackTrace();
        }
        
        return newsList;
    }
    
    //브레이킹 뉴스바
    public List<BreakingNews> getBreakingNewsTitles(int limit) {
        List<BreakingNews> list = new ArrayList<>();
        String sql = "SELECT title FROM breaking_news LIMIT ?";
        try (Connection conn = dbConn.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(new BreakingNews(rs.getString("title")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
