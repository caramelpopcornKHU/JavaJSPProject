package com.food;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/seoul_eats?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DB_USER = "root"; // 본인의 DB 사용자명으로 변경
    private static final String DB_PASSWORD = "rootroot"; // 본인의 DB 비밀번호로 변경
    
    // 데이터베이스 연결
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }
    
    // 모든 맛집 정보 조회
    public List<RestaurantDTO> getAllRestaurants() {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM seoul_restaurants ORDER BY rating DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                RestaurantDTO restaurant = new RestaurantDTO();
                restaurant.setId(rs.getInt("id"));
                restaurant.setDistrict(rs.getString("district"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setFoodType(rs.getString("food_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setLatitude(rs.getDouble("latitude"));
                restaurant.setLongitude(rs.getDouble("longitude"));
                restaurant.setNearbyStation(rs.getString("nearby_station"));
                restaurant.setOpeningHours(rs.getString("opening_hours"));
                restaurant.setTags(rs.getString("tags"));
                
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return restaurants;
    }
    
    // 구별로 맛집 조회
    public List<RestaurantDTO> getRestaurantsByDistrict(String district) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM seoul_restaurants WHERE district = ? ORDER BY rating DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, district);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RestaurantDTO restaurant = new RestaurantDTO();
                restaurant.setId(rs.getInt("id"));
                restaurant.setDistrict(rs.getString("district"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setFoodType(rs.getString("food_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setLatitude(rs.getDouble("latitude"));
                restaurant.setLongitude(rs.getDouble("longitude"));
                restaurant.setNearbyStation(rs.getString("nearby_station"));
                restaurant.setOpeningHours(rs.getString("opening_hours"));
                restaurant.setTags(rs.getString("tags"));
                
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return restaurants;
    }
    
    // 음식 종류별로 맛집 조회
    public List<RestaurantDTO> getRestaurantsByFoodType(String foodType) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM seoul_restaurants WHERE food_type = ? ORDER BY rating DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, foodType);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RestaurantDTO restaurant = new RestaurantDTO();
                restaurant.setId(rs.getInt("id"));
                restaurant.setDistrict(rs.getString("district"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setFoodType(rs.getString("food_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setLatitude(rs.getDouble("latitude"));
                restaurant.setLongitude(rs.getDouble("longitude"));
                restaurant.setNearbyStation(rs.getString("nearby_station"));
                restaurant.setOpeningHours(rs.getString("opening_hours"));
                restaurant.setTags(rs.getString("tags"));
                
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return restaurants;
    }
    
    // 검색 기능
    public List<RestaurantDTO> searchRestaurants(String keyword) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM seoul_restaurants WHERE " +
                    "restaurant_name LIKE ? OR food_type LIKE ? OR tags LIKE ? OR district LIKE ? " +
                    "ORDER BY rating DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                RestaurantDTO restaurant = new RestaurantDTO();
                restaurant.setId(rs.getInt("id"));
                restaurant.setDistrict(rs.getString("district"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setFoodType(rs.getString("food_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setLatitude(rs.getDouble("latitude"));
                restaurant.setLongitude(rs.getDouble("longitude"));
                restaurant.setNearbyStation(rs.getString("nearby_station"));
                restaurant.setOpeningHours(rs.getString("opening_hours"));
                restaurant.setTags(rs.getString("tags"));
                
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return restaurants;
    }
    
    // ID로 특정 맛집 조회
    public RestaurantDTO getRestaurantById(int id) {
        String sql = "SELECT * FROM seoul_restaurants WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                RestaurantDTO restaurant = new RestaurantDTO();
                restaurant.setId(rs.getInt("id"));
                restaurant.setDistrict(rs.getString("district"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setFoodType(rs.getString("food_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setLatitude(rs.getDouble("latitude"));
                restaurant.setLongitude(rs.getDouble("longitude"));
                restaurant.setNearbyStation(rs.getString("nearby_station"));
                restaurant.setOpeningHours(rs.getString("opening_hours"));
                restaurant.setTags(rs.getString("tags"));
                
                return restaurant;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // 모든 구 목록 조회
    public List<String> getAllDistricts() {
        List<String> districts = new ArrayList<>();
        String sql = "SELECT DISTINCT district FROM seoul_restaurants ORDER BY district";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                districts.add(rs.getString("district"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return districts;
    }
    
    // 모든 음식 종류 목록 조회
    public List<String> getAllFoodTypes() {
        List<String> foodTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT food_type FROM seoul_restaurants ORDER BY food_type";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                foodTypes.add(rs.getString("food_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return foodTypes;
    }
}