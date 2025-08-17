package com.football.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.football.dao.LeagueDAO;
import com.football.dao.NewsDAO;
import com.football.model.League;
import com.football.model.News;

@WebServlet("/footballMain")
public class FootballServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NewsDAO newsDAO;
    private LeagueDAO leagueDAO;  // 추가
    
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        
        System.out.println("FootballServlet service 실행됨");
        
        try {
            // 최신 뉴스 4개 가져오기
            List<News> newsList = newsDAO.getLatestNews(6);
            
            // 리그 순위 가져오기 (추가)
            List<League> premierLeague = leagueDAO.getLeagueStandings("Premier League");
            List<League> laLiga = leagueDAO.getLeagueStandings("La Liga");
            
            System.out.println("가져온 뉴스 개수: " + newsList.size());
            System.out.println("프리미어리그 팀 수: " + premierLeague.size());  // 추가
            System.out.println("라리가 팀 수: " + laLiga.size());  // 추가
            
            req.setAttribute("newsList", newsList);
            req.setAttribute("premierLeague", premierLeague);  // 추가
            req.setAttribute("laLiga", laLiga);  // 추가
            req.getRequestDispatcher("/footballMain.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.out.println("FootballServlet에서 에러 발생: " + e.getMessage());
            e.printStackTrace();
            
            req.setAttribute("newsList", new java.util.ArrayList<News>());
            req.setAttribute("premierLeague", new java.util.ArrayList<League>());  // 추가
            req.setAttribute("laLiga", new java.util.ArrayList<League>());  // 추가
            req.getRequestDispatcher("/footballMain.jsp").forward(req, resp);
        }
    }
    
    @Override
    public void init() throws ServletException {
        super.init();
        newsDAO = new NewsDAO();
        leagueDAO = new LeagueDAO();  // 추가
        System.out.println("FootballServlet이 초기화되었습니다.");
    }
}
