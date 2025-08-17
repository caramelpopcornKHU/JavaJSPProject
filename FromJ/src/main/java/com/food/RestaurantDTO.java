package com.food;

public class RestaurantDTO {
    private String restaurantName;
    private String address;
    private double latitude;
    private double longitude;
    private String tags;
    private double rating;
    private String foodType;
    private String nearbyStation; // ⭐ 역 정보 변수 추가

    // Getters and Setters
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public String getFoodType() { return foodType; }
    public void setFoodType(String foodType) { this.foodType = foodType; }
    public String getNearbyStation() { return nearbyStation; } // ⭐ Getter/Setter 추가
    public void setNearbyStation(String nearbyStation) { this.nearbyStation = nearbyStation; }
}