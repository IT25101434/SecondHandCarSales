package com.carplatform.Second_Hand_Car_sales.dao;

import com.carplatform.Second_Hand_Car_sales.model.Car;
import com.carplatform.Second_Hand_Car_sales.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {

    private Connection conn;

    public CarDAO() {
        this.conn = DBConnection.getConnection();
    }

    public boolean addCar(Car car) {
        String sql = "INSERT INTO cars (brand, model, " +
                "year, mileage, fuel_type, " +
                "transmission, price, location, " +
                "description, status, seller_id, " +
                "image_path) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, " +
                "?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setString(1, car.getBrand());
            ps.setString(2, car.getModel());
            ps.setInt(3, car.getYear());
            ps.setInt(4, car.getMileage());
            ps.setString(5, car.getFuelType());
            ps.setString(6, car.getTransmission());
            ps.setDouble(7, car.getPrice());
            ps.setString(8, car.getLocation());
            ps.setString(9, car.getDescription());
            ps.setString(10, car.getStatus());
            ps.setInt(11, car.getSellerId());
            ps.setString(12, car.getImagePath());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Add car error: "
                    + e.getMessage());
            return false;
        }
    }

    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.*, " +
                "u.full_name as seller_name, " +
                "u.phone as seller_phone " +
                "FROM cars c " +
                "JOIN users u ON c.seller_id = u.id " +
                "WHERE c.status = 'ACTIVE' " +
                "ORDER BY c.id DESC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cars.add(mapCar(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get cars error: "
                    + e.getMessage());
        }
        return cars;
    }

    public Car getCarById(int id) {
        String sql = "SELECT c.*, " +
                "u.full_name as seller_name, " +
                "u.phone as seller_phone " +
                "FROM cars c " +
                "JOIN users u ON c.seller_id = u.id " +
                "WHERE c.id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCar(rs);
            }
        } catch (SQLException e) {
            System.out.println("Get car error: "
                    + e.getMessage());
        }
        return null;
    }

    public List<Car> getCarsBySeller(int sellerId) {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.*, " +
                "u.full_name as seller_name, " +
                "u.phone as seller_phone " +
                "FROM cars c " +
                "JOIN users u ON c.seller_id = u.id " +
                "WHERE c.seller_id = ? " +
                "ORDER BY c.id DESC";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cars.add(mapCar(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get seller cars: "
                    + e.getMessage());
        }
        return cars;
    }

    public List<Car> searchCars(String brand,
                                double minPrice, double maxPrice,
                                String fuelType, String transmission,
                                String location, String sortBy) {

        List<Car> cars = new ArrayList<>();
        String sql = "SELECT c.*, " +
                "u.full_name as seller_name, " +
                "u.phone as seller_phone " +
                "FROM cars c " +
                "JOIN users u ON c.seller_id = u.id " +
                "WHERE c.status = 'ACTIVE'";

        if (brand != null && !brand.isEmpty())
            sql += " AND c.brand = '" + brand + "'";
        if (minPrice > 0)
            sql += " AND c.price >= " + minPrice;
        if (maxPrice > 0)
            sql += " AND c.price <= " + maxPrice;
        if (fuelType != null && !fuelType.isEmpty())
            sql += " AND c.fuel_type = '"
                    + fuelType + "'";
        if (transmission != null
                && !transmission.isEmpty())
            sql += " AND c.transmission = '"
                    + transmission + "'";
        if (location != null && !location.isEmpty())
            sql += " AND c.location = '"
                    + location + "'";

        if (sortBy != null) {
            switch (sortBy) {
                case "priceLow":
                    sql += " ORDER BY c.price ASC";
                    break;
                case "priceHigh":
                    sql += " ORDER BY c.price DESC";
                    break;
                case "mileage":
                    sql += " ORDER BY c.mileage ASC";
                    break;
                default:
                    sql += " ORDER BY c.id DESC";
            }
        } else {
            sql += " ORDER BY c.id DESC";
        }

        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cars.add(mapCar(rs));
            }
        } catch (SQLException e) {
            System.out.println("Search cars error: "
                    + e.getMessage());
        }
        return cars;
    }

    public boolean updateCar(Car car) {
        String sql = "UPDATE cars SET brand = ?, " +
                "model = ?, year = ?, " +
                "mileage = ?, fuel_type = ?, " +
                "transmission = ?, price = ?, " +
                "location = ?, description = ?, " +
                "image_path = ? WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setString(1, car.getBrand());
            ps.setString(2, car.getModel());
            ps.setInt(3, car.getYear());
            ps.setInt(4, car.getMileage());
            ps.setString(5, car.getFuelType());
            ps.setString(6, car.getTransmission());
            ps.setDouble(7, car.getPrice());
            ps.setString(8, car.getLocation());
            ps.setString(9, car.getDescription());
            ps.setString(10, car.getImagePath());
            ps.setInt(11, car.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Update car error: "
                    + e.getMessage());
            return false;
        }
    }

    public boolean markAsSold(int carId) {
        String sql = "UPDATE cars SET status = 'SOLD' " +
                "WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Mark sold error: "
                    + e.getMessage());
            return false;
        }
    }

    public boolean removeListing(int carId) {
        String sql = "UPDATE cars SET " +
                "status = 'REMOVED' WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Remove error: "
                    + e.getMessage());
            return false;
        }
    }

    public boolean deleteCar(int carId) {
        String sql = "DELETE FROM cars WHERE id = ?";
        try {
            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Delete car error: "
                    + e.getMessage());
            return false;
        }
    }

    public int countListings() {
        String sql = "SELECT COUNT(*) FROM cars " +
                "WHERE status = 'ACTIVE'";
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

    private Car mapCar(ResultSet rs)
            throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("id"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car.setYear(rs.getInt("year"));
        car.setMileage(rs.getInt("mileage"));
        car.setFuelType(rs.getString("fuel_type"));
        car.setTransmission(rs.getString("transmission"));
        car.setPrice(rs.getDouble("price"));
        car.setLocation(rs.getString("location"));
        car.setDescription(rs.getString("description"));
        car.setStatus(rs.getString("status"));
        car.setSellerId(rs.getInt("seller_id"));
        try {
            car.setImagePath(rs.getString("image_path"));
        } catch (SQLException e) {
            car.setImagePath("default-car.png");
        }
        try {
            car.setSellerName(
                    rs.getString("seller_name"));
            car.setSellerPhone(
                    rs.getString("seller_phone"));
        } catch (SQLException e) {
            // join fields not available
        }
        return car;
    }
}