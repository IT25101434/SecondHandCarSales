package com.carplatform.Second_Hand_Car_sales.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reviews")
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "reviewer_id")
    private int reviewerId;

    @Column(name = "seller_id")
    private int sellerId;

    @Column(name = "rating", nullable = false)
    private int rating;

    @Column(name = "title")
    private String title;

    @Column(name = "review_text", columnDefinition = "TEXT")
    private String reviewText;

    @Column(name = "review_type")
    private String reviewType = "PUBLIC";

    @Column(name = "recommend")
    private String recommend = "YES";

    @Column(name = "status")
    private String status = "APPROVED";

    @Column(name = "review_date")
    private LocalDateTime reviewDate;


    @Transient private String reviewerName;
    @Transient private String sellerName;


    public Review() {
        this.reviewDate = LocalDateTime.now();
    }

    public Review(int reviewerId, int sellerId, int rating,
                  String title, String reviewText,
                  String reviewType, String recommend) {
        this.reviewerId = reviewerId;
        this.sellerId = sellerId;
        this.rating = rating;
        this.title = title;
        this.reviewText = reviewText;
        this.reviewType = reviewType;
        this.recommend = recommend;
        this.status = "PENDING";
        this.reviewDate = LocalDateTime.now();
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReviewerId() { return reviewerId; }
    public void setReviewerId(int reviewerId) {
        this.reviewerId = reviewerId;
    }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public String getReviewType() { return reviewType; }
    public void setReviewType(String reviewType) {
        this.reviewType = reviewType;
    }

    public String getRecommend() { return recommend; }
    public void setRecommend(String recommend) { this.recommend = recommend; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getReviewDate() { return reviewDate; }
    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    @Override
    public String toString() {
        return "Review{id=" + id +
                ", rating=" + rating +
                ", status='" + status + "'}";
    }
}