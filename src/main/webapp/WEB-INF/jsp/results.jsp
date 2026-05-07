<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .results-header {
            background: linear-gradient(135deg, #6f42c1, #533098);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        .filter-summary {
            background-color: white;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            margin-bottom: 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
        }
        .filter-tag {
            background-color: #ede9fb;
            color: #6f42c1;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }
        .car-card {
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s;
            border: none;
            margin-bottom: 20px;
        }
        .car-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .car-img-box {
            background-color: #e9ecef;
            border-radius: 12px 0 0 12px;
            min-height: 160px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
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
            background-color: #6f42c1;
            color: white;
            border-radius: 8px;
            padding: 8px 20px;
        }
        .btn-view:hover {
            background-color: #533098;
            color: white;
        }
        .sort-bar {
            background-color: white;
            border-radius: 10px;
            padding: 10px 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">🚗 CarSales LK</a>
        <div class="ms-auto d-flex gap-2">
            <a href="/car-list"
               class="btn btn-outline-light btn-sm">
                All Cars
            </a>
            <% if(session.getAttribute("userId") != null) { %>
                <% if("SELLER".equals(
                        session.getAttribute("userRole"))) { %>
                    <a href="/car-add"
                       class="btn btn-success btn-sm">
                        + Post a Car
                    </a>
                <% } %>
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

<!-- Results Header -->
<div class="results-header">
    <div class="container">
        <h2 class="fw-bold mb-1">Search Results</h2>
        <p class="mb-0">
            Found <strong>${not empty carList ? carList.size() : 0}</strong> cars
            matching your search
        </p>
    </div>
</div>

<div class="container">

    <!-- Active Filter Tags -->
    <div class="filter-summary">
        <span style="font-size:13px; font-weight:600; color:#6c757d;">Active filters:</span>
        <c:if test="${not empty param.brand}">
            <span class="filter-tag">Brand: <c:out value="${param.brand}"/></span>
        </c:if>
        <c:if test="${not empty param.minPrice}">
            <span class="filter-tag">Min: LKR <c:out value="${param.minPrice}"/></span>
        </c:if>
        <c:if test="${not empty param.maxPrice}">
            <span class="filter-tag">Max: LKR <c:out value="${param.maxPrice}"/></span>
        </c:if>
        <c:if test="${not empty param.fuelType}">
            <span class="filter-tag">Fuel: <c:out value="${param.fuelType}"/></span>
        </c:if>
        <c:if test="${not empty param.transmission}">
            <span class="filter-tag">Transmission: <c:out value="${param.transmission}"/></span>
        </c:if>
        <c:if test="${not empty param.location}">
            <span class="filter-tag">Location: <c:out value="${param.location}"/></span>
        </c:if>
        <a href="/search" class="btn btn-outline-secondary btn-sm ms-auto">
            Clear All
        </a>
    </div>

    <!-- Sort Bar -->
    <div class="sort-bar">
        <span style="font-size:14px; font-weight:600; color:#6c757d;">Sort by:</span>
        <form action="/searchCars" method="get" id="sortForm">
            <input type="hidden" name="brand" value="${param.brand}">
            <input type="hidden" name="minPrice" value="${param.minPrice}">
            <input type="hidden" name="maxPrice" value="${param.maxPrice}">
            <input type="hidden" name="fuelType" value="${param.fuelType}">
            <input type="hidden" name="location" value="${param.location}">
            <select name="sortBy" class="form-select form-select-sm"
                    style="width:200px;"
                    onchange="document.getElementById('sortForm').submit()">
                <option value="newest" ${param.sortBy == 'newest' ? 'selected' : ''}>
                    Newest First
                </option>
                <option value="priceLow" ${param.sortBy == 'priceLow' ? 'selected' : ''}>
                    Price: Low to High
                </option>
                <option value="priceHigh" ${param.sortBy == 'priceHigh' ? 'selected' : ''}>
                    Price: High to Low
                </option>
                <option value="mileage" ${param.sortBy == 'mileage' ? 'selected' : ''}>
                    Lowest Mileage
                </option>
            </select>
        </form>
        <span class="ms-auto" style="font-size:13px; color:#6c757d;">
            ${not empty carList ? carList.size() : 0} results found
        </span>
    </div>

    <!-- Results List -->
    <c:choose>
        <c:when test="${not empty carList}">
            <c:forEach var="car" items="${carList}">
                <div class="card car-card">
                    <div class="row g-0">

                        <!-- Car Image -->
                        <div class="col-md-3">
                            <div class="car-img-box h-100">🚗</div>
                        </div>

                        <!-- Car Details -->
                        <div class="col-md-9">
                            <div class="card-body p-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="fw-bold mb-1">
                                            <c:out value="${car.brand} ${car.model}"/>
                                        </h5>
                                        <p class="text-muted mb-2" style="font-size:13px;">
                                            📍 <c:out value="${car.location}"/>
                                        </p>
                                    </div>
                                    <span class="price-badge">
                                        LKR <c:out value="${car.price}"/>
                                    </span>
                                </div>

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

                                <p class="text-muted mb-3" style="font-size:13px;">
                                    <c:out value="${car.description}"/>
                                </p>

                                <div class="d-flex gap-2">
                                    <a href="/carDetail?id=${car.id}"
                                       class="btn btn-view btn-sm">
                                        View Details
                                    </a>
                                    <% if(session.getAttribute("userId") != null) { %>
                                        <a href="/inquiry?carId=${car.id}"
                                           class="btn btn-outline-secondary btn-sm">
                                            Send Inquiry
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <div style="font-size:64px;">🔍</div>
                <h5 class="mt-3 text-muted">No cars found</h5>
                <p class="text-muted">Try adjusting or clearing your filters</p>
                <a href="/search" class="btn btn-outline-secondary me-2">
                    Modify Search
                </a>
                <a href="/car-list" class="btn btn-primary">
                    Browse All Cars
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>