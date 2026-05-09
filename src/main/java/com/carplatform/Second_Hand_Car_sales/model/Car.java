package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;

@Entity
@Table(name = "cars")
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "image_path")
    private String imagePath;

    @Column(name = "brand", nullable = false)
    private String brand;

    @Column(name = "model", nullable = false)
    private String model;

    @Column(name = "year", nullable = false)
    private int year;

    @Column(name = "mileage")
    private int mileage;

    @Column(name = "fuel_type")
    private String fuelType;

    @Column(name = "transmission")
    private String transmission;

    @Column(name = "price", nullable = false)
    private double price;

    @Column(name = "location")
    private String location;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "status")
    private String status = "ACTIVE";

    @Column(name = "seller_id")
    private int sellerId;


    @Transient
    private String sellerName;

    @Transient
    private String sellerPhone;


    public Car() {}

    public Car(String brand, String model, int year,
               int mileage, String fuelType, String transmission,
               double price, String location,
               String description, int sellerId) {
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.mileage = mileage;
        this.fuelType = fuelType;
        this.transmission = transmission;
        this.price = price;
        this.location = location;
        this.description = description;
        this.sellerId = sellerId;
        this.status = "ACTIVE";
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getMileage() { return mileage; }
    public void setMileage(int mileage) { this.mileage = mileage; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public String getTransmission() { return transmission; }
    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public String getSellerPhone() { return sellerPhone; }
    public void setSellerPhone(String sellerPhone) {
        this.sellerPhone = sellerPhone;
    }


    public String getShortDescription() {
        if(description != null && description.length() > 100) {
            return description.substring(0, 100) + "...";
        }
        return description;
    }

    @Override
    public String toString() {
        return "Car{id=" + id +
                ", brand='" + brand + "'" +
                ", model='" + model + "'" +
                ", price=" + price + "}";
    }
}