package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.*;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class AdminDAO {

    private Connection conn;

    public AdminDAO() {
        this.conn = DBConnection.getConnection();
    }

    // READ
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("AdminDAO - getAllUsers error: "
                    + e.getMessage());
        }
        return users;
    }

    // READ
    public List<User> searchUsers(String keyword,
                                  String role,
                                  String status) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE " +
                "(full_name LIKE ? OR email LIKE ?)";

        if (role != null && !role.isEmpty()) {
            sql += " AND role = ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        sql += " ORDER BY id DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            int idx = 3;
            if (role != null && !role.isEmpty()) {
                ps.setString(idx++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("AdminDAO - searchUsers error: "
                    + e.getMessage());
        }
        return users;
    }

    // READ
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("AdminDAO - countUsers error: "
                    + e.getMessage());
        }
        return 0;
    }

    // READ
    public List<User> getRecentUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC LIMIT ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("AdminDAO - getRecentUsers error: "
                    + e.getMessage());
        }
        return users;
    }

    // UPDATE
    public boolean suspendUser(int userId) {
        String sql = "UPDATE users SET status = 'SUSPENDED' " +
                "WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminDAO - suspendUser error: "
                    + e.getMessage());
            return false;
        }
    }

    // UPDATE
    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET status = 'ACTIVE' " +
                "WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminDAO - activateUser error: "
                    + e.getMessage());
            return false;
        }
    }


    // DELETE
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminDAO - deleteUser error: "
                    + e.getMessage());
            return false;
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        User user;
        switch (role) {
            case "BUYER":
                user = new Buyer();
                break;
            case "SELLER":
                user = new Seller();
                break;
            case "ADMIN":
                user = new Admin();
                break;
            default:
                user = new User();
        }
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setStatus(rs.getString("status"));
        return user;
    }
}