package com.football.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.football.dao.NewsDAO;
import com.football.dao.LeagueDAO;

import com.football.model.News;
import com.football.model.League;
import com.football.model.BreakingNews; // ⭐️ 브레이킹뉴스 모델 추가

@WebServlet("/footballMain")
public class FootballServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NewsDAO newsDAO;
    private LeagueDAO leagueDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        newsDAO = new NewsDAO();
        leagueDAO = new LeagueDAO();
        System.out.println("FootballServlet이 초기화되었습니다.");
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");

        System.out.println("FootballServlet service 실행됨");

        try {
            // 1. 최신 뉴스 가져오기
            List<News> newsList = newsDAO.getLatestNews(10);

            // 2. 리그 순위 가져오기
            List<League> premierLeague = leagueDAO.getLeagueStandings("Premier League");
            List<League> laLiga = leagueDAO.getLeagueStandings("La Liga");

            // 3. 브레이킹뉴스 DB에서 제목만 4개 가져오기
            NewsDAO breakingNewsDAO = new NewsDAO();
            List<BreakingNews> breakingNews = breakingNewsDAO.getBreakingNewsTitles(4);

            // JSP에 데이터 전달
            req.setAttribute("newsList", newsList);
            req.setAttribute("premierLeague", premierLeague);
            req.setAttribute("laLiga", laLiga);
            req.setAttribute("breakingNews", breakingNews);

            // 디버그 출력 (필수는 아님)
            System.out.println("가져온 뉴스 개수: " + newsList.size());
            System.out.println("프리미어리그 팀 수: " + premierLeague.size());
            System.out.println("라리가 팀 수: " + laLiga.size());
            System.out.println("브레이킹뉴스 개수: " + breakingNews.size());

            // JSP로 forward
            req.getRequestDispatcher("/footballMain.jsp").forward(req, resp);

        } catch (Exception e) {
            System.out.println("FootballServlet에서 에러 발생: " + e.getMessage());
            e.printStackTrace();

            // 예외시 빈 리스트로 안전하게 전달
            req.setAttribute("newsList", new java.util.ArrayList<News>());
            req.setAttribute("premierLeague", new java.util.ArrayList<League>());
            req.setAttribute("laLiga", new java.util.ArrayList<League>());
            req.setAttribute("breakingNews", new java.util.ArrayList<BreakingNews>());
            req.getRequestDispatcher("/footballMain.jsp").forward(req, resp);
        }
    }
}
