package com.food;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;
    
    public RestaurantServlet() {
        super();
        restaurantDAO = new RestaurantDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        try {
            if (action == null || action.equals("getAllRestaurants")) {
                // 모든 맛집 정보 조회
                List<RestaurantDTO> restaurants = restaurantDAO.getAllRestaurants();
                String json = gson.toJson(restaurants);
                out.print(json);
                
            } else if (action.equals("getByDistrict")) {
                // 구별 맛집 조회
                String district = request.getParameter("district");
                List<RestaurantDTO> restaurants = restaurantDAO.getRestaurantsByDistrict(district);
                String json = gson.toJson(restaurants);
                out.print(json);
                
            } else if (action.equals("getByFoodType")) {
                // 음식 종류별 맛집 조회
                String foodType = request.getParameter("foodType");
                List<RestaurantDTO> restaurants = restaurantDAO.getRestaurantsByFoodType(foodType);
                String json = gson.toJson(restaurants);
                out.print(json);
                
            } else if (action.equals("search")) {
                // 검색
                String keyword = request.getParameter("keyword");
                List<RestaurantDTO> restaurants = restaurantDAO.searchRestaurants(keyword);
                String json = gson.toJson(restaurants);
                out.print(json);
                
            } else if (action.equals("getById")) {
                // ID로 특정 맛집 조회
                int id = Integer.parseInt(request.getParameter("id"));
                RestaurantDTO restaurant = restaurantDAO.getRestaurantById(id);
                String json = gson.toJson(restaurant);
                out.print(json);
                
            } else if (action.equals("getDistricts")) {
                // 모든 구 목록 조회
                List<String> districts = restaurantDAO.getAllDistricts();
                String json = gson.toJson(districts);
                out.print(json);
                
            } else if (action.equals("getFoodTypes")) {
                // 모든 음식 종류 목록 조회
                List<String> foodTypes = restaurantDAO.getAllFoodTypes();
                String json = gson.toJson(foodTypes);
                out.print(json);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}