package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.Inquiry;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InquiryDAO {

    private Connection conn;

    public InquiryDAO() {
        this.conn = DBConnection.getConnection();
    }

    // CREATE
    public boolean sendInquiry(Inquiry inquiry) {
        String sql = "INSERT INTO inquiries (car_id, " +
                "buyer_id, seller_id, " +
                "inquiry_type, message, " +
                "offer_price, status, is_read) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, inquiry.getCarId());
            ps.setInt(2, inquiry.getBuyerId());
            ps.setInt(3, inquiry.getSellerId());
            ps.setString(4, inquiry.getInquiryType());
            ps.setString(5, inquiry.getMessage());
            ps.setDouble(6, inquiry.getOfferPrice());
            ps.setString(7, "PENDING");
            ps.setBoolean(8, false);
            int rows = ps.executeUpdate();
            System.out.println("Inquiry saved: "
                    + rows + " rows affected");
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Send inquiry error: "
                    + e.getMessage());
            return false;
        }
    }
    // READ
    public List<Inquiry> getReceivedInquiries(
            int sellerId) {
        List<Inquiry> list = new ArrayList<>();
        String sql = "SELECT i.*, " +
                "u.full_name as sender_name, " +
                "c.brand as car_brand, " +
                "c.model as car_model, " +
                "c.price as car_price " +
                "FROM inquiries i " +
                "JOIN users u ON i.buyer_id = u.id " +
                "JOIN cars c ON i.car_id = c.id " +
                "WHERE i.seller_id = ? " +
                "ORDER BY i.id DESC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapInquiry(rs));
            }
            System.out.println(
                    "Received inquiries for "
                            + sellerId + ": " + list.size());
        } catch (SQLException e) {
            System.out.println(
                    "Get received inquiries error: "
                            + e.getMessage());
        }
        return list;
    }

    // READ
    public List<Inquiry> getSentInquiries(
            int buyerId) {
        List<Inquiry> list = new ArrayList<>();
        String sql = "SELECT i.*, " +
                "u.full_name as sender_name, " +
                "c.brand as car_brand, " +
                "c.model as car_model, " +
                "c.price as car_price " +
                "FROM inquiries i " +
                "JOIN users u ON i.buyer_id = u.id " +
                "JOIN cars c ON i.car_id = c.id " +
                "WHERE i.buyer_id = ? " +
                "ORDER BY i.id DESC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, buyerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapInquiry(rs));
            }
            System.out.println(
                    "Sent inquiries for "
                            + buyerId + ": " + list.size());
        } catch (SQLException e) {
            System.out.println(
                    "Get sent inquiries error: "
                            + e.getMessage());
        }
        return list;
    }

    // READ
    public Inquiry getInquiryById(int id) {
        String sql = "SELECT i.*, " +
                "u.full_name as sender_name, " +
                "c.brand as car_brand, " +
                "c.model as car_model, " +
                "c.price as car_price " +
                "FROM inquiries i " +
                "JOIN users u ON i.buyer_id = u.id " +
                "JOIN cars c ON i.car_id = c.id " +
                "WHERE i.id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapInquiry(rs);
            }
        } catch (SQLException e) {
            System.out.println("Get inquiry error: "
                    + e.getMessage());
        }
        return null;
    }

    // READ
    public List<Inquiry> getAllInquiriesForUser(
            int userId) {
        List<Inquiry> list = new ArrayList<>();
        String sql = "SELECT i.*, " +
                "u.full_name as sender_name, " +
                "c.brand as car_brand, " +
                "c.model as car_model, " +
                "c.price as car_price " +
                "FROM inquiries i " +
                "JOIN users u ON i.buyer_id = u.id " +
                "JOIN cars c ON i.car_id = c.id " +
                "WHERE i.buyer_id = ? " +
                "OR i.seller_id = ? " +
                "ORDER BY i.id DESC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapInquiry(rs));
            }
        } catch (SQLException e) {
            System.out.println(
                    "Get all inquiries error: "
                            + e.getMessage());
        }
        return list;
    }

    // CREATE
    public boolean saveReply(int inquiryId,
                             int senderId, String message,
                             double offerPrice) {
        String sql = "INSERT INTO messages " +
                "(inquiry_id, sender_id, " +
                "message, offer_price) " +
                "VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, inquiryId);
            ps.setInt(2, senderId);
            ps.setString(3, message);
            ps.setDouble(4, offerPrice);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Save reply error: "
                    + e.getMessage());
            return false;
        }
    }

    // READ
    public List<Map<String, Object>> getReplies(
            int inquiryId) {
        List<Map<String, Object>> replies =
                new ArrayList<>();
        String sql = "SELECT m.*, " +
                "u.full_name as sender_name " +
                "FROM messages m " +
                "JOIN users u " +
                "ON m.sender_id = u.id " +
                "WHERE m.inquiry_id = ? " +
                "ORDER BY m.id ASC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, inquiryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> reply =
                        new HashMap<>();
                reply.put("id", rs.getInt("id"));
                reply.put("senderId",
                        rs.getInt("sender_id"));
                reply.put("senderName",
                        rs.getString("sender_name"));
                reply.put("message",
                        rs.getString("message"));
                reply.put("offerPrice",
                        rs.getDouble("offer_price"));
                reply.put("sentDate",
                        rs.getString("sent_date"));
                replies.add(reply);
            }
        } catch (SQLException e) {
            System.out.println("Get replies error: "
                    + e.getMessage());
        }
        return replies;
    }

    // UPDATE
    public boolean markAsRead(int inquiryId) {
        String sql = "UPDATE inquiries " +
                "SET is_read = TRUE " +
                "WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Mark read error: "
                    + e.getMessage());
            return false;
        }
    }

    // UPDATE
    public boolean updateStatus(int inquiryId,
                                String status) {
        String sql = "UPDATE inquiries " +
                "SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(
                    "Update status error: "
                            + e.getMessage());
            return false;
        }
    }

    // DELETE
    public boolean deleteInquiry(int inquiryId) {
        String sql = "DELETE FROM inquiries " +
                "WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(
                    "Delete inquiry error: "
                            + e.getMessage());
            return false;
        }
    }

    // Count unread
    public int countUnread(int sellerId) {
        String sql = "SELECT COUNT(*) " +
                "FROM inquiries " +
                "WHERE seller_id = ? " +
                "AND is_read = FALSE";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println(
                    "Count unread error: "
                            + e.getMessage());
        }
        return 0;
    }

    // Count total inquiries
    public int countInquiries() {
        String sql = "SELECT COUNT(*) " +
                "FROM inquiries";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Count error: "
                    + e.getMessage());
        }
        return 0;
    }

    // Helper
    private Inquiry mapInquiry(ResultSet rs)
            throws SQLException {
        Inquiry inquiry = new Inquiry();
        inquiry.setId(rs.getInt("id"));
        inquiry.setCarId(rs.getInt("car_id"));
        inquiry.setBuyerId(rs.getInt("buyer_id"));
        inquiry.setSellerId(rs.getInt("seller_id"));
        inquiry.setInquiryType(
                rs.getString("inquiry_type"));
        inquiry.setMessage(rs.getString("message"));
        inquiry.setOfferPrice(
                rs.getDouble("offer_price"));
        inquiry.setStatus(rs.getString("status"));
        inquiry.setRead(rs.getBoolean("is_read"));
        try {
            inquiry.setSenderName(
                    rs.getString("sender_name"));
            inquiry.setCarBrand(
                    rs.getString("car_brand"));
            inquiry.setCarModel(
                    rs.getString("car_model"));
            inquiry.setCarPrice(
                    rs.getDouble("car_price"));
        } catch (SQLException e) {
            // join fields not available
        }
        return inquiry;
    }
}