package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("SELLER")
public class Seller extends User {

    @Column(name = "total_listings")
    private int totalListings;

    @Column(name = "rating")
    private double rating;


    public Seller() {}

    public Seller(String fullName, String email,
                  String password, String phone) {
        super(fullName, email, password, phone);
        this.totalListings = 0;
        this.rating = 0.0;
    }


    public int getTotalListings() { return totalListings; }
    public void setTotalListings(int totalListings) {
        this.totalListings = totalListings;
    }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }


    @Override
    public String getRole() { return "SELLER"; }

    @Override
    public String getDashboardUrl() { return "/car-add.jsp"; }

    @Override
    public String toString() {
        return "Seller{id=" + getId() +
                ", fullName='" + getFullName() + "'" +
                ", totalListings=" + totalListings + "}";
    }
}