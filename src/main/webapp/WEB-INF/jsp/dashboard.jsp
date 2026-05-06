<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar {
            background-color: #212529;
            min-height: 100vh;
            padding: 24px 16px;
            position: fixed;
            width: 220px;
            top: 0; left: 0;
        }
        .sidebar-brand {
            color: white;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 32px;
            display: block;
        }
        .sidebar-link {
            display: block;
            padding: 10px 14px;
            border-radius: 8px;
            color: #adb5bd;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 4px;
        }
        .sidebar-link:hover {
            background-color: #343a40;
            color: white;
        }
        .sidebar-link.active {
            background-color: #0d6efd;
            color: white;
        }
        .main-content {
            margin-left: 220px;
            padding: 30px;
        }
        .stats-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
            padding: 24px;
            margin-bottom: 24px;
        }
        .stats-number {
            font-size: 40px;
            font-weight: 700;
            line-height: 1;
        }
        .stats-icon {
            font-size: 36px;
            opacity: 0.2;
        }
        .recent-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
            margin-bottom: 24px;
        }
        .table th {
            font-size: 13px;
            font-weight: 600;
            color: #6c757d;
            border-bottom: 2px solid #f0f0f0;
        }
        .table td {
            font-size: 14px;
            vertical-align: middle;
        }
        .badge-active {
            background-color: #d1fae5;
            color: #198754;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-suspended {
            background-color: #fee2e2;
            color: #dc3545;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <span class="sidebar-brand">🚗 CarSales Admin</span>
    <a href="/dashboard" class="sidebar-link active">Dashboard</a>
    <a href="/manage-users" class="sidebar-link">Manage Users</a>
    <a href="/manage-listings" class="sidebar-link">Manage Listings</a>
    <a href="/moderation" class="sidebar-link">Review Moderation</a>
    <hr style="border-color:#343a40; margin: 16px 0;">
    <a href="/logout" class="sidebar-link" style="color:#dc3545;">Logout</a>
</div>

<div class="main-content">

    <% if(session.getAttribute("userRole") == null ||
          !session.getAttribute("userRole").equals("ADMIN")) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">Access denied — Admins only</h5>
            <a href="/login" class="btn btn-primary mt-2">Login as Admin</a>
        </div>
    <% } else { %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-0">Dashboard</h3>
                <p class="text-muted mb-0" style="font-size:14px;">
                    Welcome back, <%= session.getAttribute("userName") %>
                </p>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1" style="font-size:13px;">Total Users</p>
                            <div class="stats-number text-primary">${totalUsers}</div>
                        </div>
                        <span class="stats-icon">👥</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1" style="font-size:13px;">Total Listings</p>
                            <div class="stats-number text-success">${totalListings}</div>
                        </div>
                        <span class="stats-icon">🚗</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1" style="font-size:13px;">Total Inquiries</p>
                            <div class="stats-number text-warning">${totalInquiries}</div>
                        </div>
                        <span class="stats-icon">💬</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1" style="font-size:13px;">Total Reviews</p>
                            <div class="stats-number" style="color:#d63384;">
                                ${totalReviews}
                            </div>
                        </div>
                        <span class="stats-icon">⭐</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card recent-card">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between mb-3">
                            <h6 class="fw-bold mb-0">Recent Users</h6>
                            <a href="/manage-users" style="font-size:13px; color:#0d6efd;">View all</a>
                        </div>
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${recentUsers}">
                                    <tr>
                                        <td>
                                            <p class="fw-semibold mb-0" style="font-size:13px;">
                                                <c:out value="${user.fullName}"/>
                                            </p>
                                            <p class="text-muted mb-0" style="font-size:11px;">
                                                <c:out value="${user.email}"/>
                                            </p>
                                        </td>
                                        <td style="font-size:13px;"><c:out value="${user.role}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.status == 'ACTIVE'}">
                                                    <span class="badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-suspended">Suspended</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card recent-card">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between mb-3">
                            <h6 class="fw-bold mb-0">Recent Listings</h6>
                            <a href="/manage-listings" style="font-size:13px; color:#0d6efd;">View all</a>
                        </div>
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Car</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="car" items="${recentListings}">
                                    <tr>
                                        <td>
                                            <p class="fw-semibold mb-0" style="font-size:13px;">
                                                <c:out value="${car.brand} ${car.model}"/>
                                            </p>
                                            <p class="text-muted mb-0" style="font-size:11px;">
                                                <c:out value="${car.location}"/>
                                            </p>
                                        </td>
                                        <td style="font-size:13px;">
                                            LKR <c:out value="${car.price}"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${car.status == 'ACTIVE'}">
                                                    <span class="badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-suspended">Removed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>