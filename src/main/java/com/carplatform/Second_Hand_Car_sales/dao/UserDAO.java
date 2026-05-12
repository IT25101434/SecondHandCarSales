package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.*;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn;

    public UserDAO() {
        this.conn = DBConnection.getConnection();
    }

    // CREATE
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users " +
                "(full_name, email, password, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Register error: " + e.getMessage());
            return false;
        }
    }

    // READ
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? " +
                "AND password = ? AND status = 'ACTIVE'";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return null;
    }

    // READ
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.out.println("Get user error: " + e.getMessage());
        }
        return null;
    }

    // READ
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Email check error: " + e.getMessage());
        }
        return false;
    }

    // UPDATE
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, " +
                "email = ?, phone = ? WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Update user error: " + e.getMessage());
            return false;
        }
    }

    // UPDATE
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Update password error: " + e.getMessage());
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
            System.out.println("Delete user error: " + e.getMessage());
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
