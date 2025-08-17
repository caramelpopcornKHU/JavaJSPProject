

public class Snippet {
	public List<BreakingNews> getBreakingNewsTitles(int limit) {
	        List<BreakingNews> list = new ArrayList<>();
	        String sql = "SELECT title FROM breaking_news LIMIT ?";
	        try (Connection conn = getConnection();
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
	
	    private Connection getConnection() throws Exception {
	        // 기존 NewsDAO와 같은 커넥션 로직 사용
	    }
}