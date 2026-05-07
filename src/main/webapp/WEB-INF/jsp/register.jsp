<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Second Hand Car Sales</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .register-card {
            max-width: 500px;
            margin: 60px auto;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #198754;
            color: white;
            border-radius: 16px 16px 0 0 !important;
            text-align: center;
            padding: 24px;
        }
        .btn-register {
            background-color: #198754;
            color: white;
            width: 100%;
        }
        .btn-register:hover {
            background-color: #157347;
            color: white;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">🚗 CarSales LK</a>
        <div class="ms-auto">
             <a class="btn btn-outline-light btn-sm" href="/login">Login</a>
        </div>
    </div>
</nav>

<!-- Register Form -->
<div class="container">
    <div class="card register-card">
        <div class="card-header">
            <h4 class="mb-0">Create Your Account</h4>
            <p class="mb-0 mt-1" style="font-size:14px;">Join thousands of car buyers and sellers</p>
        </div>
        <div class="card-body p-4">

            <!-- Error/Success Message -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="/register" method="post">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Full Name</label>
                    <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Phone Number</label>
                    <input type="text" name="phone" class="form-control" placeholder="07X XXX XXXX" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">I want to</label>
                    <select name="role" class="form-select" required>
                        <option value="">-- Select Role --</option>
                        <option value="BUYER">Buy a Car</option>
                        <option value="SELLER">Sell a Car</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Create a password" required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
                </div>

                <button type="submit" class="btn btn-register">Create Account</button>

            </form>

            <p class="text-center mt-3 mb-0">
                Already have an account? <a href="/login" class="text-success fw-semibold">Login here</a>
            </p>

        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>