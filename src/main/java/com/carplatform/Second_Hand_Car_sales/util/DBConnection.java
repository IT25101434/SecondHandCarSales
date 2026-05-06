package com.carplatform.Second_Hand_Car_sales.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/carsales_db";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "1234";

    private static Connection connection = null;

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(
                        URL, USERNAME, PASSWORD
                );
            }
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found: "
                    + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Database connection failed: "
                    + e.getMessage());
        }
        return connection;
    }
}