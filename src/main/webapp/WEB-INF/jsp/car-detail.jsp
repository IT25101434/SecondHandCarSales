<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${car.brand} ${car.model} - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .car-image-box {
            background-color: #e9ecef;
            border-radius: 16px;
            height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 100px;
        }
        .detail-card {
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
        }
        .price-tag {
            background-color: #198754;
            color: white;
            font-size: 24px;
            font-weight: 700;
            padding: 10px 24px;
            border-radius: 12px;
            display: inline-block;
        }
        .spec-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 15px;
        }
        .spec-row:last-child { border-bottom: none; }
        .spec-label {
            color: #6c757d;
            font-weight: 500;
        }
        .spec-value {
            font-weight: 600;
            color: #212529;
        }
        .seller-card {
            background-color: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #dee2e6;
        }
        .seller-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #0d6efd;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
        }
        .btn-inquiry {
            background-color: #0d6efd;
            color: white;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-size: 16px;
        }
        .btn-inquiry:hover {
            background-color: #0b5ed7;
            color: white;
        }
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
            width: 100%;
            border-radius: 10px;
        }
        .btn-delete { width: 100%; border-radius: 10px; }
        .badge-fuel {
            background-color: #e7f1ff;
            color: #0d6efd;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .badge-trans {
            background-color: #fff3cd;
            color: #856404;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
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
            <% } %>
        </div>
    </div>
</nav>

<div class="container py-4">

    <a href="/car-list"
       class="btn btn-outline-secondary btn-sm mb-3">
        &larr; Back to Listings
    </a>

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

    <div class="row g-4">

        <!-- Left Column -->
        <div class="col-md-8">

            <!-- Car Image -->
            <c:choose>
                <c:when test="${not empty car.imagePath
                        and car.imagePath != 'default-car.png'}">
                    <img src="/uploads/cars/${car.imagePath}"
                         style="width:100%; height:320px;
                                object-fit:cover;
                                border-radius:16px;"
                         alt="${car.brand} ${car.model}"
                         class="mb-4">
                </c:when>
                <c:otherwise>
                    <div class="car-image-box mb-4">🚗</div>
                </c:otherwise>
            </c:choose>

            <!-- Title & Price -->
            <div class="d-flex justify-content-between
                        align-items-start mb-3">
                <div>
                    <h2 class="fw-bold mb-1">
                        <c:out value="${car.brand} ${car.model}"/>
                    </h2>
                    <p class="text-muted mb-0">
                        📍 <c:out value="${car.location}"/>
                    </p>
                </div>
                <span class="price-tag">
                    LKR <c:out value="${car.price}"/>
                </span>
            </div>

            <!-- Badges -->
            <div class="mb-4">
                <span class="badge-fuel me-2">
                    <c:out value="${car.fuelType}"/>
                </span>
                <span class="badge-trans">
                    <c:out value="${car.transmission}"/>
                </span>
            </div>

            <!-- Specs -->
            <div class="card detail-card p-4 mb-4">
                <h5 class="fw-bold mb-3">
                    Car Specifications
                </h5>
                <div class="spec-row">
                    <span class="spec-label">Brand</span>
                    <span class="spec-value">
                        <c:out value="${car.brand}"/>
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Model</span>
                    <span class="spec-value">
                        <c:out value="${car.model}"/>
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Year</span>
                    <span class="spec-value">
                        <c:out value="${car.year}"/>
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Mileage</span>
                    <span class="spec-value">
                        <c:out value="${car.mileage}"/> km
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Fuel Type</span>
                    <span class="spec-value">
                        <c:out value="${car.fuelType}"/>
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">
                        Transmission
                    </span>
                    <span class="spec-value">
                        <c:out value="${car.transmission}"/>
                    </span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Location</span>
                    <span class="spec-value">
                        <c:out value="${car.location}"/>
                    </span>
                </div>
            </div>

            <!-- Description -->
            <div class="card detail-card p-4">
                <h5 class="fw-bold mb-3">Description</h5>
                <p class="text-muted mb-0"
                   style="line-height:1.8;">
                    <c:out value="${car.description}"/>
                </p>
            </div>

        </div>

        <!-- Right Column -->
        <div class="col-md-4">

            <!-- Seller Info -->
            <div class="card detail-card p-4 mb-3">
                <h5 class="fw-bold mb-3">
                    Seller Information
                </h5>
                <div class="seller-card">
                    <div class="d-flex align-items-center
                                gap-3 mb-3">
                        <div class="seller-avatar">
                            <c:out value="${car.sellerName != null
                                ? car.sellerName.substring(0,1).toUpperCase()
                                : 'S'}"/>
                        </div>
                        <div>
                            <p class="fw-bold mb-0">
                                <c:out value="${car.sellerName}"/>
                            </p>
                            <p class="text-muted mb-0"
                               style="font-size:13px;">
                                Verified Seller
                            </p>
                        </div>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">Phone</span>
                        <span class="spec-value">
                            <c:out value="${car.sellerPhone}"/>
                        </span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">
                            Location
                        </span>
                        <span class="spec-value">
                            <c:out value="${car.location}"/>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="card detail-card p-4">

                <% if(session.getAttribute("userId")
                        != null) { %>

                    <%
                    com.carplatform.Second_Hand_Car_sales
                        .dao.FavouriteDAO favDAO =
                        new com.carplatform
                        .Second_Hand_Car_sales.dao
                        .FavouriteDAO();
                    Object userIdObj =
                        session.getAttribute("userId");
                    int currentUserId =
                        userIdObj instanceof Integer
                        ? (Integer) userIdObj
                        : Integer.parseInt(
                            userIdObj.toString());
                    boolean isFav = false;
                    if(request.getAttribute("car") != null) {
                        isFav = favDAO.isFavourite(
                            currentUserId,
                            ((com.carplatform
                            .Second_Hand_Car_sales
                            .model.Car) request
                            .getAttribute("car")).getId());
                    }
                    %>

                    <!-- Favourite Button -->
                    <% if(isFav) { %>
                        <form action="/removeFavourite"
                              method="post" class="mb-2">
                            <input type="hidden"
                                   name="carId"
                                   value="${car.id}">
                            <button type="submit"
                                    class="btn btn-warning w-100"
                                    style="border-radius:10px;
                                           padding:10px;">
                                ❤️ Remove from Favourites
                            </button>
                        </form>
                    <% } else { %>
                        <form action="/addFavourite"
                              method="post" class="mb-2">
                            <input type="hidden"
                                   name="carId"
                                   value="${car.id}">
                            <button type="submit"
                                    class="btn btn-outline-danger w-100"
                                    style="border-radius:10px;
                                           padding:10px;">
                                🤍 Save to Favourites
                            </button>
                        </form>
                    <% } %>

                    <!-- Send Inquiry -->
                    <a href="/inquiry?carId=${car.id}"
                       class="btn btn-inquiry mb-2">
                        Send Inquiry
                    </a>

                    <!-- Write a Review (only for buyers) -->
                    <% if("BUYER".equals(
                            session.getAttribute("userRole"))) { %>
                        <a href="/add-review?sellerId=${car.sellerId}"
                           class="btn btn-success w-100 mb-2"
                           style="border-radius:10px; padding:12px;">
                            ⭐ Write a Review
                        </a>
                    <% } %>

                    <!-- Edit/Delete for seller -->
                    <c:if test="${car.sellerId == sessionScope.userId}">
                        <a href="/editCar?id=${car.id}"
                           class="btn btn-edit mb-2">
                            Edit Listing
                        </a>
                        <form action="/deleteCar"
                              method="post"
                              onsubmit="return confirm(
                                'Delete this listing?');">
                            <input type="hidden"
                                   name="carId"
                                   value="${car.id}">
                            <button type="submit"
                                    class="btn btn-outline-danger btn-delete">
                                Delete Listing
                            </button>
                        </form>
                    </c:if>

                <% } else { %>
                    <p class="text-muted text-center mb-3"
                       style="font-size:14px;">
                        Login to contact the seller
                    </p>
                    <a href="/login"
                       class="btn btn-inquiry">
                        Login to Send Inquiry
                    </a>
                <% } %>

            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>