<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.carplatform.Second_Hand_Car_sales.model.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .profile-card {
            max-width: 600px;
            margin: 40px auto;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .profile-header {
            background-color: #198754;
            color: white;
            border-radius: 16px 16px 0 0 !important;
            padding: 30px;
            text-align: center;
        }
        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: white;
            color: #198754;
            font-size: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px auto;
            font-weight: bold;
        }
        .badge-role {
            background-color: white;
            color: #198754;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .btn-update {
            background-color: #198754;
            color: white;
            width: 100%;
        }
        .btn-update:hover {
            background-color: #157347;
            color: white;
        }
        .btn-delete { width: 100%; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/car-list">
            🚗 CarSales LK
        </a>
        <div class="ms-auto d-flex gap-2">
            <a href="/car-list"
               class="btn btn-outline-light btn-sm">
                Browse Cars
            </a>

            <!-- Seller buttons -->
            <% if("SELLER".equals(
                    session.getAttribute("userRole"))) { %>
                <a href="/car-add"
                   class="btn btn-success btn-sm">
                    + Post a Car
                </a>
                <a href="/my-listings"
                   class="btn btn-outline-light btn-sm">
                    📋 My Listings
                </a>
                <a href="/reviews?sellerId=<%= session.getAttribute("userId") %>"
                   class="btn btn-outline-light btn-sm">
                    ⭐ My Reviews
                </a>
            <% } %>

            <!-- Buyer buttons -->
            <% if("BUYER".equals(
                    session.getAttribute("userRole"))) { %>
                <a href="/favourites"
                   class="btn btn-outline-light btn-sm">
                    ❤️ Favourites
                </a>
            <% } %>

            <a href="/inbox"
               class="btn btn-outline-light btn-sm">
                📬 Inbox
            </a>
            <a href="/logout"
               class="btn btn-danger btn-sm">
                Logout
            </a>
        </div>
    </div>
</nav>

<!-- Profile Section -->
<div class="container">
    <div class="card profile-card">

        <!-- Profile Header -->
        <div class="profile-header">
            <div class="avatar">
                <%= session.getAttribute("userName") != null ?
                    session.getAttribute("userName")
                        .toString().substring(0,1)
                        .toUpperCase() : "U" %>
            </div>
            <h4 class="mb-1">
                <%= session.getAttribute("userName") != null
                    ? session.getAttribute("userName")
                    : "User" %>
            </h4>
            <span class="badge-role">
                <%= session.getAttribute("userRole") != null
                    ? session.getAttribute("userRole")
                    : "USER" %>
            </span>
        </div>

        <div class="card-body p-4">

            <!-- Error/Success Message -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <!-- Update Profile Form -->
            <h5 class="mb-3 fw-semibold">
                Update Your Details
            </h5>
            <form action="/updateProfile" method="post">

                <input type="hidden" name="id"
                       value="<%= session.getAttribute("userId") %>">

                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Full Name
                    </label>
                    <input type="text" name="fullName"
                           class="form-control"
                           value="<%= session.getAttribute("userName") != null ?
                                  session.getAttribute("userName") : "" %>"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Email Address
                    </label>
                    <input type="email" name="email"
                           class="form-control"
                           value="<%= session.getAttribute("userEmail") != null ?
                                  session.getAttribute("userEmail") : "" %>"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Phone Number
                    </label>
                    <input type="text" name="phone"
                           class="form-control"
                           value="<%= session.getAttribute("userPhone") != null ?
                                  session.getAttribute("userPhone") : "" %>">
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">
                        New Password
                        <span class="text-muted fw-normal">
                            (leave blank to keep current)
                        </span>
                    </label>
                    <input type="password" name="password"
                           class="form-control"
                           placeholder="Enter new password">
                </div>

                <button type="submit"
                        class="btn btn-update mb-3">
                    Update Profile
                </button>

            </form>

            <hr>

            <!-- Seller quick links -->
            <% if("SELLER".equals(
                    session.getAttribute("userRole"))) { %>
                <h5 class="mb-3 fw-semibold">
                    Seller Actions
                </h5>
                <div class="d-flex gap-2 mb-4">
                    <a href="/car-add"
                       class="btn btn-success flex-grow-1">
                        + Post a Car
                    </a>
                    <a href="/reviews?sellerId=<%= session.getAttribute("userId") %>"
                       class="btn btn-outline-warning flex-grow-1">
                        ⭐ View My Reviews
                    </a>
                    <a href="/inbox"
                       class="btn btn-outline-primary flex-grow-1">
                        📬 My Inbox
                    </a>
                </div>
                <hr>
            <% } %>

            <!-- Buyer quick links -->
            <% if("BUYER".equals(
                    session.getAttribute("userRole"))) { %>
                <h5 class="mb-3 fw-semibold">
                    Buyer Actions
                </h5>
                <div class="d-flex gap-2 mb-4">
                    <a href="/favourites"
                       class="btn btn-outline-danger flex-grow-1">
                        ❤️ My Favourites
                    </a>
                    <a href="/inbox"
                       class="btn btn-outline-primary flex-grow-1">
                        📬 My Inbox
                    </a>
                    <a href="/search"
                       class="btn btn-outline-secondary flex-grow-1">
                        🔍 Search Cars
                    </a>
                </div>
                <hr>
            <% } %>

            <!-- Delete Account -->
            <h5 class="mb-3 fw-semibold text-danger">
                Danger Zone
            </h5>
            <form action="/deleteAccount" method="post"
                  onsubmit="return confirm(
                    'Are you sure you want to delete your account? This cannot be undone.');">
                <input type="hidden" name="id"
                       value="<%= session.getAttribute("userId") %>">
                <button type="submit"
                        class="btn btn-outline-danger btn-delete">
                    Delete My Account
                </button>
            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>