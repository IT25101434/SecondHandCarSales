package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.Review;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewDAO {

    private Connection conn;

    public ReviewDAO() {
        this.conn = DBConnection.getConnection();
    }

    // CREATE
    public boolean submitReview(Review review) {
        String sql = "INSERT INTO reviews (reviewer_id, seller_id, " +
                "rating, title, review_text, review_type, " +
                "recommend, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getReviewerId());
            ps.setInt(2, review.getSellerId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getTitle());
            ps.setString(5, review.getReviewText());
            ps.setString(6, review.getReviewType());
            ps.setString(7, review.getRecommend());
            ps.setString(8, review.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Submit review error: "
                    + e.getMessage());
            return false;
        }
    }

    // READ
    public List<Review> getReviewsBySeller(int sellerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as reviewer_name " +
                "FROM reviews r " +
                "JOIN users u ON r.reviewer_id = u.id " +
                "WHERE r.seller_id = ? AND r.status = 'APPROVED' " +
                "ORDER BY r.id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapReview(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get reviews error: "
                    + e.getMessage());
        }
        return list;
    }

    // READ
    public List<Review> getAllReviews(String status) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as reviewer_name, " +
                "s.full_name as seller_name FROM reviews r " +
                "JOIN users u ON r.reviewer_id = u.id " +
                "JOIN users s ON r.seller_id = s.id";
        if (status != null && !status.isEmpty()
                && !status.equals("all")) {
            sql += " WHERE r.status = '" + status + "'";
        }
        sql += " ORDER BY r.id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapReview(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get all reviews error: "
                    + e.getMessage());
        }
        return list;
    }

    // READ
    public Review getReviewById(int id) {
        String sql = "SELECT r.*, u.full_name as reviewer_name " +
                "FROM reviews r " +
                "JOIN users u ON r.reviewer_id = u.id " +
                "WHERE r.id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapReview(rs);
        } catch (SQLException e) {
            System.out.println("Get review error: "
                    + e.getMessage());
        }
        return null;
    }

    // READ
    public double getAverageRating(int sellerId) {
        String sql = "SELECT AVG(rating) FROM reviews " +
                "WHERE seller_id = ? AND status = 'APPROVED'";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return Math.round(avg * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            System.out.println("Average rating error: "
                    + e.getMessage());
        }
        return 0.0;
    }

    // READ
    public List<Map<String, Object>> getTopSellers() {
        List<Map<String, Object>> sellers = new ArrayList<>();
        String sql = "SELECT u.id, u.full_name, u.phone, " +
                "COUNT(r.id) as review_count, " +
                "COALESCE(AVG(r.rating), 0) as avg_rating " +
                "FROM users u " +
                "LEFT JOIN reviews r ON u.id = r.seller_id " +
                "WHERE u.role = 'SELLER' " +
                "AND u.status = 'ACTIVE' " +
                "GROUP BY u.id, u.full_name, u.phone " +
                "ORDER BY avg_rating DESC, review_count DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> seller = new HashMap<>();
                seller.put("id", rs.getInt("id"));
                seller.put("fullName",
                        rs.getString("full_name"));
                seller.put("phone",
                        rs.getString("phone"));
                seller.put("reviewCount",
                        rs.getInt("review_count"));
                seller.put("avgRating",
                        String.format("%.1f",
                                rs.getDouble("avg_rating")));
                sellers.add(seller);
            }
        } catch (SQLException e) {
            System.out.println("Get top sellers error: "
                    + e.getMessage());
        }
        return sellers;
    }

    // UPDATE
    public boolean moderateReview(int reviewId, String status) {
        String sql = "UPDATE reviews SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Moderate error: "
                    + e.getMessage());
            return false;
        }
    }

    // DELETE
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM reviews WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Delete review error: "
                    + e.getMessage());
            return false;
        }
    }


    private Review mapReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setReviewerId(rs.getInt("reviewer_id"));
        review.setSellerId(rs.getInt("seller_id"));
        review.setRating(rs.getInt("rating"));
        review.setTitle(rs.getString("title"));
        review.setReviewText(rs.getString("review_text"));
        review.setReviewType(rs.getString("review_type"));
        review.setRecommend(rs.getString("recommend"));
        review.setStatus(rs.getString("status"));
        try {
            review.setReviewerName(
                    rs.getString("reviewer_name"));
        } catch (SQLException e) {
            // join field not available
        }
        try {
            review.setSellerName(
                    rs.getString("seller_name"));
        } catch (SQLException e) {
            // join field not available
        }
        return review;
    }
}