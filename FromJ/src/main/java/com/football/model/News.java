package com.football.model;

import java.sql.Timestamp;

public class News {
	private int id;
	private String title;
	private String summary;
	private String imageUrl;
	private String category;
	private Timestamp createdAt;
	private int commentCount;
	
	public News() {}

	public News(String title, String summary, String imageUrl, String category, int commentCount) {
		this.title = title;
		this.summary = summary;
		this.imageUrl = imageUrl;
		this.category = category;
		this.commentCount = commentCount;
	}

	 public int getId() { return id; }
	    public void setId(int id) { this.id = id; }
	    
	    public String getTitle() { return title; }
	    public void setTitle(String title) { this.title = title; }
	    
	    public String getSummary() { return summary; }
	    public void setSummary(String summary) { this.summary = summary; }
	    
	    public String getImageUrl() { return imageUrl; }
	    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
	    
	    public String getCategory() { return category; }
	    public void setCategory(String category) { this.category = category; }
	    
	    public Timestamp getCreatedAt() { return createdAt; }
	    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
	    
	    public int getCommentCount() { return commentCount; }
	    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
	
	
}


