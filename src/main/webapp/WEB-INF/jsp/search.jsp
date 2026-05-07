<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Cars - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .hero {
            background: linear-gradient(135deg, #6f42c1, #533098);
            color: white;
            padding: 50px 0 40px 0;
            margin-bottom: 40px;
        }
        .filter-card {
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            padding: 28px;
            margin-bottom: 30px;
        }
        .section-title {
            font-size: 13px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 14px;
            padding-bottom: 8px;
            border-bottom: 1px solid #dee2e6;
        }
        .btn-search {
            background-color: #6f42c1;
            color: white;
            width: 100%;
            padding: 10px;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-search:hover {
            background-color: #533098;
            color: white;
        }
        .btn-clear {
            width: 100%;
            border-radius: 10px;
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
            border-radius: 12px 12px 0 0;
            height: 160px;
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
            width: 100%;
            border-radius: 8px;
        }
        .btn-view:hover {
            background-color: #533098;
            color: white;
        }
        .saved-search-btn {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffc107;
            border-radius: 8px;
            width: 100%;
            padding: 8px;
            font-size: 14px;
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

<!-- Hero -->
<div class="hero">
    <div class="container text-center">
        <h1 class="fw-bold">Search Cars</h1>
        <p class="mb-0">Filter by brand, price, fuel type and more</p>
    </div>
</div>

<div class="container">
    <div class="row g-4">

        <!-- Left: Filter Panel -->
        <div class="col-md-3">
            <div class="card filter-card">
                <form action="/searchCars" method="get" id="searchForm">

                    <p class="section-title">Brand</p>
                    <div class="mb-3">
                        <select name="brand" class="form-select form-select-sm">
                            <option value="">All Brands</option>
                            <option value="Toyota" ${param.brand == 'Toyota' ? 'selected' : ''}>Toyota</option>
                            <option value="Honda" ${param.brand == 'Honda' ? 'selected' : ''}>Honda</option>
                            <option value="Nissan" ${param.brand == 'Nissan' ? 'selected' : ''}>Nissan</option>
                            <option value="Suzuki" ${param.brand == 'Suzuki' ? 'selected' : ''}>Suzuki</option>
                            <option value="Mitsubishi" ${param.brand == 'Mitsubishi' ? 'selected' : ''}>Mitsubishi</option>
                            <option value="BMW" ${param.brand == 'BMW' ? 'selected' : ''}>BMW</option>
                            <option value="Mercedes" ${param.brand == 'Mercedes' ? 'selected' : ''}>Mercedes</option>
                            <option value="Audi" ${param.brand == 'Audi' ? 'selected' : ''}>Audi</option>
                        </select>
                    </div>

                    <p class="section-title">Price Range (LKR)</p>
                    <div class="mb-2">
                        <input type="number" name="minPrice" class="form-control form-control-sm"
                               placeholder="Min price"
                               value="${param.minPrice}">
                    </div>
                    <div class="mb-3">
                        <input type="number" name="maxPrice" class="form-control form-control-sm"
                               placeholder="Max price"
                               value="${param.maxPrice}">
                    </div>

                    <p class="section-title">Year</p>
                    <div class="row g-1 mb-3">
                        <div class="col-6">
                            <input type="number" name="minYear" class="form-control form-control-sm"
                                   placeholder="From" min="1990" max="2025"
                                   value="${param.minYear}">
                        </div>
                        <div class="col-6">
                            <input type="number" name="maxYear" class="form-control form-control-sm"
                                   placeholder="To" min="1990" max="2025"
                                   value="${param.maxYear}">
                        </div>
                    </div>

                    <p class="section-title">Fuel Type</p>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="fuelType"
                                   value="Petrol" id="petrol"
                                   ${param.fuelType == 'Petrol' ? 'checked' : ''}>
                            <label class="form-check-label" for="petrol">Petrol</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="fuelType"
                                   value="Diesel" id="diesel"
                                   ${param.fuelType == 'Diesel' ? 'checked' : ''}>
                            <label class="form-check-label" for="diesel">Diesel</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="fuelType"
                                   value="Hybrid" id="hybrid"
                                   ${param.fuelType == 'Hybrid' ? 'checked' : ''}>
                            <label class="form-check-label" for="hybrid">Hybrid</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="fuelType"
                                   value="Electric" id="electric"
                                   ${param.fuelType == 'Electric' ? 'checked' : ''}>
                            <label class="form-check-label" for="electric">Electric</label>
                        </div>
                    </div>

                    <p class="section-title">Transmission</p>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="transmission"
                                   value="" id="transAll" checked>
                            <label class="form-check-label" for="transAll">All</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="transmission"
                                   value="Automatic" id="auto"
                                   ${param.transmission == 'Automatic' ? 'checked' : ''}>
                            <label class="form-check-label" for="auto">Automatic</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="transmission"
                                   value="Manual" id="manual"
                                   ${param.transmission == 'Manual' ? 'checked' : ''}>
                            <label class="form-check-label" for="manual">Manual</label>
                        </div>
                    </div>

                    <p class="section-title">Location</p>
                    <div class="mb-4">
                        <select name="location" class="form-select form-select-sm">
                            <option value="">All Cities</option>
                            <option value="Colombo" ${param.location == 'Colombo' ? 'selected' : ''}>Colombo</option>
                            <option value="Kandy" ${param.location == 'Kandy' ? 'selected' : ''}>Kandy</option>
                            <option value="Galle" ${param.location == 'Galle' ? 'selected' : ''}>Galle</option>
                            <option value="Negombo" ${param.location == 'Negombo' ? 'selected' : ''}>Negombo</option>
                            <option value="Matara" ${param.location == 'Matara' ? 'selected' : ''}>Matara</option>
                            <option value="Jaffna" ${param.location == 'Jaffna' ? 'selected' : ''}>Jaffna</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-search mb-2">Apply Filters</button>
                    <a href="/search" class="btn btn-outline-secondary btn-clear">Clear Filters</a>

                </form>



            </div>
        </div>

        <!-- Right: Results -->
        <div class="col-md-9">

            <!-- Results Count -->
            <p class="text-muted mb-3" style="font-size:14px;">
                Showing <strong>${not empty carList ? carList.size() : 0}</strong> results
            </p>

            <div class="row">
                <c:choose>
                    <c:when test="${not empty carList}">
                        <c:forEach var="car" items="${carList}">
                            <div class="col-md-4">
                                <div class="card car-card">
                                    <div class="car-img-box">🚗</div>
                                    <div class="card-body p-3">
                                        <h6 class="fw-bold mb-1">
                                            <c:out value="${car.brand} ${car.model}"/>
                                        </h6>
                                        <p class="text-muted mb-2" style="font-size:12px;">
                                            📍 <c:out value="${car.location}"/>
                                        </p>
                                        <div class="mb-2">
                                            <span class="spec-badge"><c:out value="${car.year}"/></span>
                                            <span class="spec-badge"><c:out value="${car.fuelType}"/></span>
                                            <span class="spec-badge"><c:out value="${car.mileage}"/> km</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="price-badge">LKR <c:out value="${car.price}"/></span>
                                        </div>
                                        <a href="/carDetail?id=${car.id}" class="btn btn-view btn-sm">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <div style="font-size:64px;">🔍</div>
                            <h5 class="mt-3 text-muted">No cars found</h5>
                            <p class="text-muted">Try adjusting your filters</p>
                            <a href="/search" class="btn btn-outline-secondary btn-sm">
                                Clear All Filters
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>