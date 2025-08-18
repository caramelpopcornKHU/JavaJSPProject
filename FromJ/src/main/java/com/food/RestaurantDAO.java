package com.food;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.board.util.DBConnection;

public class RestaurantDAO { //데이터 베이스 연결 내장 함수 및 변수 선언
    
	DBConnection dbconn = new DBConnection();
	
    // 모든 맛집 정보 조회
    public List<RestaurantDTO> getAllRestaurants() {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM seoul_restaurants ORDER BY rating DESC";
        
        try (Connection conn = dbconn.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) { // 데이터 베이스 컬럼 조회
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
        List<RestaurantDTO> restaurants = new ArrayList<>(); // 리스트에 닮고 어떠한 타입으로
        String sql = "SELECT * FROM seoul_restaurants WHERE district = ? ORDER BY rating DESC";
        
        try (Connection conn = dbconn.getConnection();
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
        
        try (Connection conn = dbconn.getConnection();
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
        
        try (Connection conn = dbconn.getConnection();
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
        
        try (Connection conn = dbconn.getConnection();
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
        
        try (Connection conn = dbconn.getConnection();
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
        
        try (Connection conn = dbconn.getConnection();
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