<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favourites - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #d63384, #a0195e);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .car-card {
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 24px;
            transition: transform 0.2s;
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
            font-size: 14px;
        }
        .spec-badge {
            background-color: #f0f0f0;
            color: #444;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 12px;
            margin-right: 3px;
        }
        .btn-view {
            background-color: #d63384;
            color: white;
            width: 100%;
            border-radius: 8px;
        }
        .btn-view:hover {
            background-color: #a0195e;
            color: white;
        }
        .empty-state {
            text-align: center;
            padding: 80px 0;
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
            <a href="/car-list"
               class="btn btn-outline-light btn-sm">
                Browse Cars
            </a>
            <% if(session.getAttribute("userId") != null) { %>
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

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">❤️ My Favourites</h2>
        <p class="mb-0">Cars you have saved for later</p>
    </div>
</div>

<div class="container pb-5">

    <% if(session.getAttribute("userId") == null) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">
                Please login to view your favourites
            </h5>
            <a href="/login" class="btn btn-primary mt-2">
                Login
            </a>
        </div>
    <% } else { %>

        <c:choose>
            <c:when test="${not empty favouriteList}">
                <p class="text-muted mb-4"
                   style="font-size:14px;">
                    You have
                    <strong>${favouriteList.size()}</strong>
                    saved car(s)
                </p>
                <div class="row">
                    <c:forEach var="car"
                               items="${favouriteList}">
                        <div class="col-md-4">
                            <div class="card car-card">
                                <c:choose>
                                    <c:when test="${not empty car.imagePath
                                            and car.imagePath != 'default-car.png'}">
                                        <img src="/uploads/cars/${car.imagePath}"
                                             class="car-img-real"
                                             alt="${car.brand} ${car.model}"
                                             onerror="this.style.display='none'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="car-img-placeholder">🚗</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body p-3">
                                    <h5 class="fw-bold mb-1">
                                        <c:out value="${car.brand} ${car.model}"/>
                                    </h5>
                                    <p class="text-muted mb-2"
                                       style="font-size:13px;">
                                        📍 <c:out value="${car.location}"/>
                                    </p>
                                    <div class="mb-2">
                                        <span class="spec-badge">
                                            <c:out value="${car.year}"/>
                                        </span>
                                        <span class="spec-badge">
                                            <c:out value="${car.fuelType}"/>
                                        </span>
                                        <span class="spec-badge">
                                            <c:out value="${car.mileage}"/> km
                                        </span>
                                    </div>
                                    <div class="d-flex justify-content-between
                                                align-items-center mb-3">
                                        <span class="price-badge">
                                            LKR <c:out value="${car.price}"/>
                                        </span>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <a href="/carDetail?id=${car.id}"
                                           class="btn btn-view btn-sm flex-grow-1">
                                            View Details
                                        </a>
                                        <form action="/removeFavourite"
                                              method="post">
                                            <input type="hidden"
                                                   name="carId"
                                                   value="${car.id}">
                                            <button type="submit"
                                                    class="btn btn-outline-danger btn-sm"
                                                    onclick="return confirm(
                                                        'Remove from favourites?')">
                                                ❤️
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div style="font-size:80px;">🤍</div>
                    <h4 class="mt-3 text-muted">
                        No favourites yet
                    </h4>
                    <p class="text-muted">
                        Browse cars and click
                        "Save to Favourites" to save them here
                    </p>
                    <a href="/car-list"
                       class="btn btn-primary mt-2">
                        Browse Cars
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>