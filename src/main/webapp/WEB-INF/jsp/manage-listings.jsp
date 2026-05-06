<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings - Second Hand Car Sales</title>
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
        .search-bar {
            background-color: white;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            margin-bottom: 24px;
        }
        .listing-table-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
        }
        .table th {
            font-size: 13px;
            font-weight: 600;
            color: #6c757d;
            border-bottom: 2px solid #f0f0f0;
            padding: 14px 16px;
        }
        .table td {
            font-size: 14px;
            vertical-align: middle;
            padding: 12px 16px;
        }
        .car-thumb {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }
        .badge-active {
            background-color: #d1fae5;
            color: #198754;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-removed {
            background-color: #fee2e2;
            color: #dc3545;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-sold {
            background-color: #e7f1ff;
            color: #0d6efd;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .price-text {
            font-weight: 600;
            color: #198754;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <span class="sidebar-brand">🚗 CarSales Admin</span>
    <a href="/dashboard" class="sidebar-link">Dashboard</a>
    <a href="/manage-users" class="sidebar-link">Manage Users</a>
    <a href="/manage-listings" class="sidebar-link active">Manage Listings</a>
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
                <h3 class="fw-bold mb-0">Manage Listings</h3>
                <p class="text-muted mb-0" style="font-size:14px;">
                    View, approve, or remove car listings
                </p>
            </div>
        </div>

        <% if(request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="search-bar">
            <form action="/manage-listings" method="get">
                <div class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <input type="text" name="search"
                               class="form-control form-control-sm"
                               placeholder="Search by brand, model..."
                               value="${param.search}">
                    </div>
                    <div class="col-md-2">
                        <select name="brand" class="form-select form-select-sm">
                            <option value="">All Brands</option>
                            <option value="Toyota" ${param.brand == 'Toyota' ? 'selected' : ''}>Toyota</option>
                            <option value="Honda" ${param.brand == 'Honda' ? 'selected' : ''}>Honda</option>
                            <option value="Nissan" ${param.brand == 'Nissan' ? 'selected' : ''}>Nissan</option>
                            <option value="Suzuki" ${param.brand == 'Suzuki' ? 'selected' : ''}>Suzuki</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select form-select-sm">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="SOLD" ${param.status == 'SOLD' ? 'selected' : ''}>Sold</option>
                            <option value="REMOVED" ${param.status == 'REMOVED' ? 'selected' : ''}>Removed</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="location" class="form-select form-select-sm">
                            <option value="">All Cities</option>
                            <option value="Colombo" ${param.location == 'Colombo' ? 'selected' : ''}>Colombo</option>
                            <option value="Kandy" ${param.location == 'Kandy' ? 'selected' : ''}>Kandy</option>
                            <option value="Galle" ${param.location == 'Galle' ? 'selected' : ''}>Galle</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-sm w-100">Search</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="card listing-table-card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Car</th>
                            <th>Seller</th>
                            <th>Price</th>
                            <th>Location</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty carList}">
                                <c:forEach var="car" items="${carList}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="car-thumb">🚗</div>
                                                <div>
                                                    <p class="fw-semibold mb-0" style="font-size:13px;">
                                                        <c:out value="${car.brand} ${car.model}"/>
                                                    </p>
                                                    <p class="text-muted mb-0" style="font-size:11px;">
                                                        <c:out value="${car.year}"/> ·
                                                        <c:out value="${car.fuelType}"/> ·
                                                        <c:out value="${car.mileage}"/> km
                                                    </p>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="font-size:13px;">
                                            <c:out value="${car.sellerName}"/>
                                        </td>
                                        <td class="price-text">
                                            LKR <c:out value="${car.price}"/>
                                        </td>
                                        <td style="font-size:13px;">
                                            <c:out value="${car.location}"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${car.status == 'ACTIVE'}">
                                                    <span class="badge-active">Active</span>
                                                </c:when>
                                                <c:when test="${car.status == 'SOLD'}">
                                                    <span class="badge-sold">Sold</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-removed">Removed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-1 flex-wrap">
                                                <a href="/carDetail?id=${car.id}"
                                                   class="btn btn-outline-secondary btn-sm"
                                                   style="font-size:12px; border-radius:6px;">
                                                    View
                                                </a>
                                                <c:if test="${car.status == 'ACTIVE'}">
                                                    <form action="/markSold" method="post">
                                                        <input type="hidden" name="carId" value="${car.id}">
                                                        <button type="submit"
                                                                class="btn btn-info btn-sm"
                                                                style="font-size:12px; border-radius:6px;">
                                                            Mark Sold
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form action="/removeListing" method="post"
                                                      onsubmit="return confirm('Remove this listing?');">
                                                    <input type="hidden" name="carId" value="${car.id}">
                                                    <button type="submit"
                                                            class="btn btn-outline-danger btn-sm"
                                                            style="font-size:12px; border-radius:6px;">
                                                        Remove
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        No listings found
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>