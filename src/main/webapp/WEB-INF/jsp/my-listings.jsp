<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Listings - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #198754, #146c43);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .listing-card {
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .listing-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        .car-img-placeholder {
            height: 160px;
            background-color: #e9ecef;
            border-radius: 12px 12px 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
        }
        .car-img-real {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 12px 12px 0 0;
        }
        .price-badge {
            background-color: #198754;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
        }
        .spec-badge {
            background-color: #f0f0f0;
            color: #444;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 11px;
            margin-right: 3px;
        }
        .status-active {
            background-color: #d1fae5;
            color: #198754;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .status-sold {
            background-color: #fee2e2;
            color: #dc3545;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
            border-radius: 8px;
            font-size: 12px;
            padding: 5px 12px;
        }
        .btn-edit:hover {
            background-color: #ffca2c;
            color: #212529;
        }
        .btn-sold {
            background-color: #6c757d;
            color: white;
            border-radius: 8px;
            font-size: 12px;
            padding: 5px 12px;
        }
        .btn-sold:hover {
            background-color: #5c636a;
            color: white;
        }
        .stats-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
            padding: 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        .stats-number {
            font-size: 36px;
            font-weight: 700;
            color: #198754;
        }
        .empty-state {
            text-align: center;
            padding: 60px 0;
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
        </div>
    </div>
</nav>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">📋 My Listings</h2>
        <p class="mb-0">
            Manage all your car listings
        </p>
    </div>
</div>

<div class="container pb-5">

    <% if(session.getAttribute("userId") == null ||
          !"SELLER".equals(
              session.getAttribute("userRole"))) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">
                Only sellers can view this page
            </h5>
            <a href="/login"
               class="btn btn-primary mt-2">
                Login as Seller
            </a>
        </div>
    <% } else { %>

        <!-- Success/Error -->
        <% if(request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Stats Row -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card stats-card">
                    <div class="stats-number">
                        ${not empty myListings ? myListings.size() : 0}
                    </div>
                    <p class="text-muted mb-0"
                       style="font-size:13px;">
                        Total Listings
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stats-card">
                    <div class="stats-number text-success">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="car" items="${myListings}">
                            <c:if test="${car.status == 'ACTIVE'}">
                                <c:set var="activeCount"
                                       value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <p class="text-muted mb-0"
                       style="font-size:13px;">
                        Active
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stats-card">
                    <div class="stats-number text-danger">
                        <c:set var="soldCount" value="0"/>
                        <c:forEach var="car" items="${myListings}">
                            <c:if test="${car.status == 'SOLD'}">
                                <c:set var="soldCount"
                                       value="${soldCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${soldCount}
                    </div>
                    <p class="text-muted mb-0"
                       style="font-size:13px;">
                        Sold
                    </p>
                </div>
            </div>
        </div>

        <!-- Post New Car Button -->
        <div class="d-flex justify-content-between
                    align-items-center mb-4">
            <h5 class="fw-bold mb-0">All My Listings</h5>
            <a href="/car-add"
               class="btn btn-success"
               style="border-radius:10px;">
                + Post New Car
            </a>
        </div>

        <!-- Listings -->
        <c:choose>
            <c:when test="${not empty myListings}">
                <div class="row">
                    <c:forEach var="car"
                               items="${myListings}">
                        <div class="col-md-4">
                            <div class="card listing-card">

                                <!-- Car Image -->
                                <c:choose>
                                    <c:when test="${not empty car.imagePath
                                            and car.imagePath != 'default-car.png'}">
                                        <img src="/uploads/cars/${car.imagePath}"
                                             class="car-img-real"
                                             alt="${car.brand} ${car.model}"
                                             onerror="this.style.display='none'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="car-img-placeholder">
                                            🚗
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="card-body p-3">
                                    <!-- Title and Status -->
                                    <div class="d-flex
                                                justify-content-between
                                                align-items-start mb-2">
                                        <h6 class="fw-bold mb-0">
                                            <c:out value="${car.brand} ${car.model}"/>
                                        </h6>
                                        <c:choose>
                                            <c:when test="${car.status == 'SOLD'}">
                                                <span class="status-sold">
                                                    Sold
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-active">
                                                    Active
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <p class="text-muted mb-2"
                                       style="font-size:12px;">
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

                                    <div class="mb-3">
                                        <span class="price-badge">
                                            LKR <c:out value="${car.price}"/>
                                        </span>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="d-flex gap-2 flex-wrap">
                                        <a href="/carDetail?id=${car.id}"
                                           class="btn btn-outline-secondary btn-sm"
                                           style="border-radius:8px;
                                                  font-size:12px;">
                                            View
                                        </a>
                                        <a href="/editCar?id=${car.id}"
                                           class="btn btn-edit btn-sm">
                                            ✏️ Edit
                                        </a>
                                        <c:if test="${car.status != 'SOLD'}">
                                            <form action="/markSold"
                                                  method="post"
                                                  onsubmit="return confirm(
                                                    'Mark this car as sold?');">
                                                <input type="hidden"
                                                       name="carId"
                                                       value="${car.id}">
                                                <button type="submit"
                                                        class="btn btn-sold btn-sm">
                                                    ✅ Mark Sold
                                                </button>
                                            </form>
                                        </c:if>
                                        <form action="/deleteCar"
                                              method="post"
                                              onsubmit="return confirm(
                                                'Delete this listing permanently?');">
                                            <input type="hidden"
                                                   name="carId"
                                                   value="${car.id}">
                                            <button type="submit"
                                                    class="btn btn-outline-danger btn-sm"
                                                    style="border-radius:8px;
                                                           font-size:12px;">
                                                🗑️ Delete
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
                    <div style="font-size:80px;">🚗</div>
                    <h4 class="mt-3 text-muted">
                        No listings yet
                    </h4>
                    <p class="text-muted">
                        Post your first car for sale!
                    </p>
                    <a href="/car-add"
                       class="btn btn-success mt-2"
                       style="border-radius:10px;
                              padding:10px 24px;">
                        + Post a Car
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>