package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.Favourite;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavouriteDAO {

    private Connection conn;

    public FavouriteDAO() {
        this.conn = DBConnection.getConnection();
    }

    // CREATE
    public boolean addFavourite(int userId, int carId) {
        String sql = "INSERT IGNORE INTO favourites " +
                "(user_id, car_id) VALUES (?, ?)";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Add favourite error: "
                    + e.getMessage());
            return false;
        }
    }

    // READ
    public List<Favourite> getFavouritesByUser(int userId) {
        List<Favourite> favourites = new ArrayList<>();
        String sql = "SELECT f.id, f.user_id, f.car_id, " +
                "f.saved_date, c.brand, c.model, " +
                "c.price, c.image_path, c.location " +
                "FROM favourites f " +
                "JOIN cars c ON f.car_id = c.id " +
                "WHERE f.user_id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Favourite fav = new Favourite();
                fav.setId(rs.getInt("id"));
                fav.setUserId(rs.getInt("user_id"));
                fav.setCarId(rs.getInt("car_id"));
                fav.setSavedDate(
                        rs.getString("saved_date"));
                fav.setCarBrand(rs.getString("brand"));
                fav.setCarModel(rs.getString("model"));
                fav.setCarPrice(rs.getDouble("price"));
                fav.setCarImage(
                        rs.getString("image_path"));
                fav.setCarLocation(
                        rs.getString("location"));
                favourites.add(fav);
            }
        } catch (SQLException e) {
            System.out.println("Get favourites error: "
                    + e.getMessage());
        }
        return favourites;
    }

    // READ
    public boolean isFavourite(int userId, int carId) {
        String sql = "SELECT id FROM favourites " +
                "WHERE user_id = ? AND car_id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println(
                    "Check favourite error: "
                            + e.getMessage());
            return false;
        }
    }

    // DELETE
    public boolean removeFavourite(int userId, int carId) {
        String sql = "DELETE FROM favourites " +
                "WHERE user_id = ? AND car_id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(
                    "Remove favourite error: "
                            + e.getMessage());
            return false;
        }
    }
}
