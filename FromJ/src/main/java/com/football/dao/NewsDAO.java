package com.football.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.football.model.News;


public class NewsDAO {
    
    // JNDI를 통한 데이터베이스 연결
    Connection getConnection() throws Exception {
        Context initContext = new InitialContext();
        Context envContext = (Context) initContext.lookup("java:comp/env");
        DataSource dataSource = (DataSource) envContext.lookup("jdbc/FromJ");
        return dataSource.getConnection();
    }
    
    // 최신 뉴스 목록 가져오기
    public List<News> getLatestNews(int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT id, title, summary, image_url, category, created_at, comment_count " +
                    "FROM news ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = getConnection();
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
    
    //뉴스 추가
    public boolean insertNews(News news) throws Exception {
		Connection connection = null;
		String sql = "INSERT INTO news(title, summary, image_url, category, comment_count) VALUES(?,?,?,?,?)";
		
		
		
		 try {
	            connection = getConnection();
	            PreparedStatement pstmt = connection.prepareStatement(sql);
	            
	            pstmt.setString(1, news.getTitle());
	            pstmt.setString(2, news.getSummary());
	            pstmt.setString(3, news.getImageUrl());
	            pstmt.setString(4, news.getCategory());
	            pstmt.setInt(5, news.getCommentCount());
	            
	            int result = pstmt.executeUpdate();
	            return result > 0;
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        } finally {
	            if (connection != null) {
	                connection.close();
	            }
	        }
	    }
}
