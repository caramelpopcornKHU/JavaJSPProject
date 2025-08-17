package com.food;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.food.RestaurantDAO;
import com.food.RestaurantDTO;
import com.google.gson.Gson;

@WebServlet("/getRestaurants")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 'search' 파라미터 값을 가져옵니다.
        String keyword = request.getParameter("search");
        
        RestaurantDAO dao = new RestaurantDAO();
        List<RestaurantDTO> restaurantList;
        
        // 검색어가 있는지 없는지에 따라 다른 DAO 메서드를 호출합니다.
        if (keyword != null && !keyword.trim().isEmpty()) {
            restaurantList = dao.searchRestaurants(keyword); // 검색어가 있으면 검색 메서드 호출
        } else {
            restaurantList = dao.getAllRestaurants(); // 검색어가 없으면 전체 목록 메서드 호출
        }
        
        Gson gson = new Gson();
        String json = gson.toJson(restaurantList);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}