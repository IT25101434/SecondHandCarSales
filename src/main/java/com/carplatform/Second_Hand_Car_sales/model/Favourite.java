package com.carplatform.Second_Hand_Car_sales.model;

public class Favourite {


    private int id;
    private int userId;
    private int carId;
    private String savedDate;


    private String carBrand;
    private String carModel;
    private double carPrice;
    private String carImage;
    private String carLocation;


    public Favourite() {}

    public Favourite(int userId, int carId) {
        this.userId = userId;
        this.carId = carId;
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCarId() { return carId; }
    public void setCarId(int carId) {
        this.carId = carId;
    }

    public String getSavedDate() { return savedDate; }
    public void setSavedDate(String savedDate) {
        this.savedDate = savedDate;
    }

    public String getCarBrand() { return carBrand; }
    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }

    public String getCarModel() { return carModel; }
    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public double getCarPrice() { return carPrice; }
    public void setCarPrice(double carPrice) {
        this.carPrice = carPrice;
    }

    public String getCarImage() { return carImage; }
    public void setCarImage(String carImage) {
        this.carImage = carImage;
    }

    public String getCarLocation() { return carLocation; }
    public void setCarLocation(String carLocation) {
        this.carLocation = carLocation;
    }


    public String getDisplayName() {
        return carBrand + " " + carModel;
    }


    public String getFormattedPrice() {
        return "LKR " + String.format("%.0f", carPrice);
    }

    @Override
    public String toString() {
        return "Favourite{userId=" + userId +
                ", carId=" + carId +
                ", car='" + getDisplayName() + "'}";
    }
}