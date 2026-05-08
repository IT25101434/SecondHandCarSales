package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("BUYER")
public class Buyer extends User {

    @Column(name = "wishlist_count")
    private int wishlistCount;


    public Buyer() {}

    public Buyer(String fullName, String email,
                 String password, String phone) {
        super(fullName, email, password, phone);
        this.wishlistCount = 0;
    }


    public int getWishlistCount() { return wishlistCount; }
    public void setWishlistCount(int wishlistCount) {
        this.wishlistCount = wishlistCount;
    }


    @Override
    public String getRole() { return "BUYER"; }

    @Override
    public String getDashboardUrl() { return "/car-list.jsp"; }

    @Override
    public String toString() {
        return "Buyer{id=" + getId() +
                ", fullName='" + getFullName() + "'" +
                ", email='" + getEmail() + "'}";
    }
}