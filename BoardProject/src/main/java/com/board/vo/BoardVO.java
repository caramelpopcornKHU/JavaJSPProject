package com.board.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class BoardVO {
    private int id;
    private String category;
    private String title;
    private String author;
    private String password;
    private String content;
    private Timestamp regDate;
    private int views;
    private String imageFiles;
    
    public BoardVO() {}
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public Timestamp getRegDate() { return regDate; }
    public void setRegDate(Timestamp regDate) { this.regDate = regDate; }
    
    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
    
    public String getImageFiles() { return imageFiles; }
    public void setImageFiles(String imageFiles) { this.imageFiles = imageFiles; }
    
    // 추가 메서드
    public String getCategoryName() {
        switch(this.category) {
            case "politics": return "정치";
            case "economy": return "경제";
            case "society": return "사회";
            case "culture": return "문화";
            default: return this.category;
        }
    }
    
    public String getFormattedDate() {
        if (regDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            return sdf.format(regDate);
        }
        return "";
    }
    
    public boolean getHasImage() {
        return imageFiles != null && !imageFiles.trim().isEmpty();
    }
}