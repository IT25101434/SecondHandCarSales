<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Second Hand Car Sales</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #FFFAFA;
        }
        .login-card {
            max-width: 450px;
            margin: 80px auto;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #00BFFF;
            color: black;
            border-radius: 16px 16px 0 0 !important;
            text-align: center;
            padding: 24px;
        }
        .btn-login {
            background-color: #00BFFF;
            color: black;
            width: 100%;
        }
        .btn-login:hover {
            background-color: #0b5ed7;
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
           <a class="btn btn-outline-light btn-sm" href="register">Register</a>
        </div>
    </div>
</nav>

<!-- Login Form -->
<div class="container">
    <div class="card login-card">
        <div class="card-header">
            <h4 class="mb-0">Welcome Back</h4>
            <p class="mb-0 mt-1" style="font-size:14px;">Login to your account</p>
        </div>
        <div class="card-body p-4">

            <!-- Error/Success Message -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="/login" method="post">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email Address</label>
                    <input type="email" name="email" class="form-control"
                           placeholder="Enter your email" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Password</label>
                    <input type="password" name="password" class="form-control"
                           placeholder="Enter your password" required>
                </div>

                <div class="mb-4 d-flex justify-content-between align-items-center">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="remember" id="remember">
                        <label class="form-check-label" for="remember">Remember me</label>
                    </div>
                    <!-- <a href="#" class="text-primary" style="font-size:14px;">Forgot password?</a>-->
                </div>

                <button type="submit" class="btn btn-login">Login</button>

            </form>

            <hr class="my-3">

            <p class="text-center mb-0">
                Don't have an account?
                <a href="/register" class="text-primary fw-semibold">Register here</a>
            </p>

        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>