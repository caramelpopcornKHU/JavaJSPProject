package com.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.board.util.DBConnection;
import com.board.vo.BoardVO;

public class BoardDAO {
    
    public List<BoardVO> selectList(String category, int offset, int limit) {
        List<BoardVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            if (category == null || "all".equals(category)) {
                sql = "SELECT * FROM board ORDER BY id DESC LIMIT ?, ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, offset);
                pstmt.setInt(2, limit);
            } else {
                sql = "SELECT * FROM board WHERE category = ? ORDER BY id DESC LIMIT ?, ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, category);
                pstmt.setInt(2, offset);
                pstmt.setInt(3, limit);
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BoardVO board = new BoardVO();
                board.setId(rs.getInt("id"));
                board.setCategory(rs.getString("category"));
                board.setTitle(rs.getString("title"));
                board.setAuthor(rs.getString("author"));
                board.setPassword(rs.getString("password"));
                board.setContent(rs.getString("content"));
                board.setRegDate(rs.getTimestamp("reg_date"));
                board.setViews(rs.getInt("views"));
                board.setImageFiles(rs.getString("image_files"));
                list.add(board);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return list;
    }
    
    public int getTotalCount(String category) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            if (category == null || "all".equals(category)) {
                sql = "SELECT COUNT(*) FROM board";
                pstmt = conn.prepareStatement(sql);
            } else {
                sql = "SELECT COUNT(*) FROM board WHERE category = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, category);
            }
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return count;
    }
    
    public BoardVO selectOne(int id) {
        BoardVO board = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM board WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                board = new BoardVO();
                board.setId(rs.getInt("id"));
                board.setCategory(rs.getString("category"));
                board.setTitle(rs.getString("title"));
                board.setAuthor(rs.getString("author"));
                board.setPassword(rs.getString("password"));
                board.setContent(rs.getString("content"));
                board.setRegDate(rs.getTimestamp("reg_date"));
                board.setViews(rs.getInt("views"));
                board.setImageFiles(rs.getString("image_files"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return board;
    }
    
    public int insert(BoardVO board) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO board (category, title, author, password, content, reg_date, views, image_files) " +
                        "VALUES (?, ?, ?, ?, ?, NOW(), 0, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board.getCategory());
            pstmt.setString(2, board.getTitle());
            pstmt.setString(3, board.getAuthor());
            pstmt.setString(4, board.getPassword());
            pstmt.setString(5, board.getContent());
            pstmt.setString(6, board.getImageFiles());
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, pstmt, conn);
        }
        
        return result;
    }
    
    public int update(BoardVO board) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE board SET category=?, title=?, author=?, password=?, content=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board.getCategory());
            pstmt.setString(2, board.getTitle());
            pstmt.setString(3, board.getAuthor());
            pstmt.setString(4, board.getPassword());
            pstmt.setString(5, board.getContent());
            pstmt.setInt(6, board.getId());
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, pstmt, conn);
        }
        
        return result;
    }
    
    public int updateWithImages(BoardVO board) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE board SET category=?, title=?, author=?, password=?, content=?, image_files=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, board.getCategory());
            pstmt.setString(2, board.getTitle());
            pstmt.setString(3, board.getAuthor());
            pstmt.setString(4, board.getPassword());
            pstmt.setString(5, board.getContent());
            pstmt.setString(6, board.getImageFiles());
            pstmt.setInt(7, board.getId());
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, pstmt, conn);
        }
        
        return result;
    }
    
    public int delete(int id) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM board WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, pstmt, conn);
        }
        
        return result;
    }
    
    public int updateViews(int id) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE board SET views = views + 1 WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, pstmt, conn);
        }
        
        return result;
    }
    
    // 검색 기능 추가
    public List<BoardVO> searchPosts(String keyword, String category, int offset, int limit) {
        List<BoardVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            if (category == null || "all".equals(category)) {
                sql = "SELECT * FROM board WHERE (title LIKE ? OR content LIKE ? OR author LIKE ?) " +
                      "ORDER BY id DESC LIMIT ?, ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
                pstmt.setString(3, "%" + keyword + "%");
                pstmt.setInt(4, offset);
                pstmt.setInt(5, limit);
            } else {
                sql = "SELECT * FROM board WHERE category = ? AND (title LIKE ? OR content LIKE ? OR author LIKE ?) " +
                      "ORDER BY id DESC LIMIT ?, ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, category);
                pstmt.setString(2, "%" + keyword + "%");
                pstmt.setString(3, "%" + keyword + "%");
                pstmt.setString(4, "%" + keyword + "%");
                pstmt.setInt(5, offset);
                pstmt.setInt(6, limit);
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BoardVO board = new BoardVO();
                board.setId(rs.getInt("id"));
                board.setCategory(rs.getString("category"));
                board.setTitle(rs.getString("title"));
                board.setAuthor(rs.getString("author"));
                board.setPassword(rs.getString("password"));
                board.setContent(rs.getString("content"));
                board.setRegDate(rs.getTimestamp("reg_date"));
                board.setViews(rs.getInt("views"));
                board.setImageFiles(rs.getString("image_files"));
                list.add(board);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return list;
    }
    
    public int getSearchCount(String keyword, String category) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            if (category == null || "all".equals(category)) {
                sql = "SELECT COUNT(*) FROM board WHERE (title LIKE ? OR content LIKE ? OR author LIKE ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
                pstmt.setString(3, "%" + keyword + "%");
            } else {
                sql = "SELECT COUNT(*) FROM board WHERE category = ? AND (title LIKE ? OR content LIKE ? OR author LIKE ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, category);
                pstmt.setString(2, "%" + keyword + "%");
                pstmt.setString(3, "%" + keyword + "%");
                pstmt.setString(4, "%" + keyword + "%");
            }
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, pstmt, conn);
        }
        
        return count;
    }
}