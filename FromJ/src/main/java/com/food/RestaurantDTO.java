package com.food;

public class RestaurantDTO {
    private int id;
    private String district;
    private String restaurantName;
    private double rating;
    private String foodType;
    private String address;
    private double latitude;
    private double longitude;
    private String nearbyStation;
    private String openingHours;
    private String tags;
    
    // 기본 생성자
    public RestaurantDTO() {}
    
    // 모든 필드를 포함한 생성자
    public RestaurantDTO(int id, String district, String restaurantName, double rating, 
                        String foodType, String address, double latitude, double longitude,
                        String nearbyStation, String openingHours, String tags) {
        this.id = id;
        this.district = district;
        this.restaurantName = restaurantName;
        this.rating = rating;
        this.foodType = foodType;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.nearbyStation = nearbyStation;
        this.openingHours = openingHours;
        this.tags = tags;
    }
    
    // Getter와 Setter 메소드들
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    
    public String getFoodType() { return foodType; }
    public void setFoodType(String foodType) { this.foodType = foodType; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    
    public String getNearbyStation() { return nearbyStation; }
    public void setNearbyStation(String nearbyStation) { this.nearbyStation = nearbyStation; }
    
    public String getOpeningHours() { return openingHours; }
    public void setOpeningHours(String openingHours) { this.openingHours = openingHours; }
    
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
    
    @Override
    public String toString() {
        return "RestaurantDTO{" +
                "id=" + id +
                ", district='" + district + '\'' +
                ", restaurantName='" + restaurantName + '\'' +
                ", rating=" + rating +
                ", foodType='" + foodType + '\'' +
                ", address='" + address + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", nearbyStation='" + nearbyStation + '\'' +
                ", openingHours='" + openingHours + '\'' +
                ", tags='" + tags + '\'' +
                '}';
    }
}