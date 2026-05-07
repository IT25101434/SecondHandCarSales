<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.carplatform.Second_Hand_Car_sales.model.Car"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Cars - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .hero {
            background: linear-gradient(135deg, #0d6efd, #0a58ca);
            color: white;
            padding: 50px 0 40px 0;
            margin-bottom: 40px;
        }
        .hero h1 { font-size: 2rem; font-weight: 700; }
        .car-card {
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            margin-bottom: 24px;
        }
        .car-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .car-img-placeholder {
            height: 180px;
            background-color: #e9ecef;
            border-radius: 12px 12px 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
        }
        .car-img-real {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 12px 12px 0 0;
        }
        .price-badge {
            background-color: #198754;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 15px;
        }
        .spec-badge {
            background-color: #f0f0f0;
            color: #444;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            margin-right: 4px;
        }
        .btn-view {
            background-color: #0d6efd;
            color: white;
            width: 100%;
            border-radius: 8px;
        }
        .btn-view:hover {
            background-color: #0b5ed7;
            color: white;
        }
        .results-count {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 16px;
        }
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
<% if(session.getAttribute("userId") != null) { %>
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
    <% } %>
    <% if("BUYER".equals(
            session.getAttribute("userRole"))) { %>
        <a href="/favourites"
           class="btn btn-outline-light btn-sm">
            ❤️ Favourites
        </a>
        <a href="/top-sellers"
           class="btn btn-outline-light btn-sm">
            ⭐ Top Sellers
        </a>
    <% } %>
    <a href="/inbox"
       class="btn btn-outline-light btn-sm">
        📬 Inbox
    </a>
    <a href="/profile"
       class="btn btn-outline-light btn-sm">
        My Profile
    </a>
    <a href="/logout"
       class="btn btn-danger btn-sm">
        Logout
    </a>
<% } else { %>
    <a href="/login"
       class="btn btn-outline-light btn-sm">
        Login
    </a>
    <a href="/register"
       class="btn btn-success btn-sm">
        Register
    </a>
<% } %>
        </div>
    </div>
</nav>

<!-- Hero -->
<div class="hero">
    <div class="container text-center">
        <h1>Find Your Perfect Car</h1>
        <p class="mb-0">
            Browse thousands of second hand cars
            across Sri Lanka
        </p>
    </div>
</div>

<div class="container">

    <!-- Search Button -->
    <div class="mb-4 text-end">
        <a href="/search"
           class="btn btn-primary"
           style="border-radius:10px;
                  padding:10px 24px;">
            🔍 Search & Filter Cars
        </a>
    </div>

    <!-- Results Count -->
    <p class="results-count">
        Showing
        <strong>
            ${not empty carList ? carList.size() : 0}
        </strong>
        cars available
    </p>

    <!-- Car Cards -->
    <div class="row">
        <c:choose>
            <c:when test="${not empty carList}">
                <c:forEach var="car" items="${carList}">
                    <div class="col-md-4">
                        <div class="card car-card">
                            <c:choose>
                                <c:when test="${not empty car.imagePath
                                        and car.imagePath != 'default-car.png'}">
                                    <img src="/uploads/cars/${car.imagePath}"
                                         class="car-img-real"
                                         alt="${car.brand} ${car.model}"
                                         onerror="this.style.display='none';
                                                  document.getElementById('ph-${car.id}')
                                                  .style.display='flex'">
                                    <div id="ph-${car.id}"
                                         class="car-img-placeholder"
                                         style="display:none;">🚗</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="car-img-placeholder">
                                        🚗
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body p-3">
                                <h5 class="fw-bold mb-1">
                                    <c:out value="${car.brand}"/>
                                    <c:out value="${car.model}"/>
                                </h5>
                                <p class="text-muted mb-2"
                                   style="font-size:13px;">
                                    📍
                                    <c:out value="${car.location}"/>
                                </p>
                                <div class="mb-2">
                                    <span class="spec-badge">
                                        <c:out value="${car.year}"/>
                                    </span>
                                    <span class="spec-badge">
                                        <c:out value="${car.fuelType}"/>
                                    </span>
                                    <span class="spec-badge">
                                        <c:out value="${car.transmission}"/>
                                    </span>
                                    <span class="spec-badge">
                                        <c:out value="${car.mileage}"/> km
                                    </span>
                                </div>
                                <div class="d-flex
                                            justify-content-between
                                            align-items-center mb-3">
                                    <span class="price-badge">
                                        LKR
                                        <c:out value="${car.price}"/>
                                    </span>
                                </div>
                                <a href="/carDetail?id=${car.id}"
                                   class="btn btn-view btn-sm">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5">
                    <div style="font-size:64px;">🚗</div>
                    <h4 class="mt-3 text-muted">
                        No cars listed yet
                    </h4>
                    <p class="text-muted">
                        Be the first to post a car for sale!
                    </p>
                    <% if(session.getAttribute("userId")
                            != null) { %>
                        <a href="/car-add"
                           class="btn btn-primary">
                            Post a Car
                        </a>
                    <% } else { %>
                        <a href="/register"
                           class="btn btn-primary">
                            Register to Post
                        </a>
                    <% } %>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>