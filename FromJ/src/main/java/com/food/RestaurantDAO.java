package com.food;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    private final String URL = "jdbc:mysql://localhost:3306/seoul_eats?serverTimezone=UTC";
    private final String USER = "root"; // ⚠️ 본인 DB 아이디
    private final String PASSWORD = "rootroot"; // ⚠️ 본인 DB 비밀번호

    // 공통 DB 조회 로직
    private List<RestaurantDTO> fetchRestaurants(String sql, String keyword) {
        List<RestaurantDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            pstmt = conn.prepareStatement(sql);

            // 검색어가 있을 경우, 6개의 ?에 모두 값을 설정합니다.
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchKeyword = "%" + keyword.trim() + "%";
                pstmt.setString(1, searchKeyword);
                pstmt.setString(2, searchKeyword);
                pstmt.setString(3, searchKeyword);
                pstmt.setString(4, searchKeyword);
                pstmt.setString(5, searchKeyword);
                pstmt.setString(6, searchKeyword);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                RestaurantDTO dto = new RestaurantDTO();
                dto.setRestaurantName(rs.getString("restaurant_name"));
                dto.setAddress(rs.getString("address"));
                dto.setLatitude(rs.getDouble("latitude"));
                dto.setLongitude(rs.getDouble("longitude"));
                dto.setTags(rs.getString("tags"));
                dto.setRating(rs.getDouble("rating"));
                dto.setFoodType(rs.getString("food_type"));
                dto.setNearbyStation(rs.getString("nearby_station")); // 역 정보 추가
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    // 모든 맛집 정보 가져오기
    public List<RestaurantDTO> getAllRestaurants() {
        String sql = "SELECT * FROM seoul_restaurants";
        return fetchRestaurants(sql, null);
    }

    // ⭐ 더 강력해진 통합 검색 메소드
    public List<RestaurantDTO> searchRestaurants(String keyword) {
        String sql = "SELECT * FROM seoul_restaurants WHERE "
                   + "restaurant_name LIKE ? OR "
                   + "tags LIKE ? OR "
                   + "nearby_station LIKE ? OR "
                   + "district LIKE ? OR "
                   + "food_type LIKE ? OR "
                   + "address LIKE ?";
        return fetchRestaurants(sql, keyword);
    }
}