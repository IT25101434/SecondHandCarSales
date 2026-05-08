package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("ADMIN")
public class Admin extends User {

    @Column(name = "admin_level")
    private String adminLevel;


    public Admin() {}

    public Admin(String fullName, String email,
                 String password, String phone) {
        super(fullName, email, password, phone);
        this.adminLevel = "SUPER";
    }


    public String getAdminLevel() { return adminLevel; }
    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }


    public boolean canDeleteUser() { return true; }
    public boolean canModerateReviews() { return true; }
    public boolean canRemoveListings() { return true; }


    @Override
    public String getRole() { return "ADMIN"; }

    @Override
    public String getDashboardUrl() { return "/dashboard.jsp"; }

    @Override
    public String toString() {
        return "Admin{id=" + getId() +
                ", fullName='" + getFullName() + "'" +
                ", adminLevel='" + adminLevel + "'}";
    }
}