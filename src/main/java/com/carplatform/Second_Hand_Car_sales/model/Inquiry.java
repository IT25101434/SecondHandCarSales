package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "inquiries")
public class Inquiry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "car_id")
    private int carId;

    @Column(name = "buyer_id")
    private int buyerId;

    @Column(name = "seller_id")
    private int sellerId;

    @Column(name = "inquiry_type")
    private String inquiryType;

    @Column(name = "message", columnDefinition = "TEXT")
    private String message;

    @Column(name = "offer_price")
    private double offerPrice;

    @Column(name = "status")
    private String status = "PENDING";

    @Column(name = "is_read")
    private boolean isRead = false;

    @Column(name = "sent_date")
    private LocalDateTime sentDate;

    // Transient fields filled from joins
    @Transient private String senderName;
    @Transient private String carBrand;
    @Transient private String carModel;
    @Transient private double carPrice;

    // Constructor
    public Inquiry() {
        this.sentDate = LocalDateTime.now();
    }

    public Inquiry(int carId, int buyerId, int sellerId,
                   String inquiryType, String message,
                   double offerPrice) {
        this.carId = carId;
        this.buyerId = buyerId;
        this.sellerId = sellerId;
        this.inquiryType = inquiryType;
        this.message = message;
        this.offerPrice = offerPrice;
        this.status = "PENDING";
        this.isRead = false;
        this.sentDate = LocalDateTime.now();
    }

    // Getters and Setters — Encapsulation
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }

    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public String getInquiryType() { return inquiryType; }
    public void setInquiryType(String inquiryType) {
        this.inquiryType = inquiryType;
    }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public double getOfferPrice() { return offerPrice; }
    public void setOfferPrice(double offerPrice) {
        this.offerPrice = offerPrice;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public LocalDateTime getSentDate() { return sentDate; }
    public void setSentDate(LocalDateTime sentDate) {
        this.sentDate = sentDate;
    }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getCarBrand() { return carBrand; }
    public void setCarBrand(String carBrand) { this.carBrand = carBrand; }

    public String getCarModel() { return carModel; }
    public void setCarModel(String carModel) { this.carModel = carModel; }

    public double getCarPrice() { return carPrice; }
    public void setCarPrice(double carPrice) { this.carPrice = carPrice; }

    @Override
    public String toString() {
        return "Inquiry{id=" + id +
                ", type='" + inquiryType + "'" +
                ", status='" + status + "'}";
    }
}