<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Sellers - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #d63384, #a0195e);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .seller-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .seller-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        .rank-badge {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .rank-1 { background-color: #ffd700; color: #212529; }
        .rank-2 { background-color: #c0c0c0; color: #212529; }
        .rank-3 { background-color: #cd7f32; color: white; }
        .rank-other {
            background-color: #e9ecef;
            color: #6c757d;
        }
        .seller-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background-color: #d63384;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .stars-display {
            color: #ffc107;
            font-size: 15px;
            letter-spacing: 1px;
        }
        .rating-number {
            font-size: 22px;
            font-weight: 700;
            color: #d63384;
        }
        .review-count {
            font-size: 13px;
            color: #6c757d;
        }
        .btn-view-profile {
            background-color: #d63384;
            color: white;
            border-radius: 8px;
            padding: 6px 18px;
            font-size: 13px;
        }
        .btn-view-profile:hover {
            background-color: #a0195e;
            color: white;
        }
        .no-rating {
            color: #adb5bd;
            font-size: 13px;
        }
        .top-badge {
            background-color: #fff3cd;
            color: #856404;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
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
        <h2 class="fw-bold mb-1">⭐ Top Sellers</h2>
        <p class="mb-0">
            Sellers ranked by buyer ratings
        </p>
    </div>
</div>

<div class="container pb-5">

    <c:choose>
        <c:when test="${not empty topSellers}">

            <p class="text-muted mb-4"
               style="font-size:14px;">
                <strong>${topSellers.size()}</strong>
                verified seller(s) on the platform
            </p>

            <c:forEach var="seller"
                       items="${topSellers}"
                       varStatus="loop">
                <div class="card seller-card">
                    <div class="card-body p-4">
                        <div class="d-flex
                                    align-items-center
                                    gap-3">

                            <!-- Rank Badge -->
                            <div class="rank-badge
                                 ${loop.index == 0 ? 'rank-1' :
                                   loop.index == 1 ? 'rank-2' :
                                   loop.index == 2 ? 'rank-3' :
                                   'rank-other'}">
                                ${loop.index == 0 ? '🥇' :
                                  loop.index == 1 ? '🥈' :
                                  loop.index == 2 ? '🥉' :
                                  loop.index + 1}
                            </div>

                            <!-- Seller Avatar -->
                            <div class="seller-avatar">
                                <c:out value="${seller.fullName.substring(0,1).toUpperCase()}"/>
                            </div>

                            <!-- Seller Info -->
                            <div class="flex-grow-1">
                                <div class="d-flex
                                            justify-content-between
                                            align-items-center
                                            flex-wrap gap-2">
                                    <div>
                                        <h5 class="fw-bold mb-0">
                                            <c:out value="${seller.fullName}"/>
                                        </h5>
                                        <p class="text-muted mb-1"
                                           style="font-size:13px;">
                                            📞
                                            <c:out value="${seller.phone}"/>
                                        </p>
                                        <c:choose>
                                            <c:when test="${seller.reviewCount > 0}">
                                                <div class="d-flex
                                                            align-items-center
                                                            gap-2">
                                                    <span class="stars-display">
                                                        &#9733;&#9733;&#9733;&#9733;&#9733;
                                                    </span>
                                                    <span class="rating-number">
                                                        <c:out value="${seller.avgRating}"/>
                                                    </span>
                                                    <span class="review-count">
                                                        (<c:out value="${seller.reviewCount}"/>
                                                        review(s))
                                                    </span>
                                                    <c:if test="${loop.index == 0}">
                                                        <span class="top-badge">
                                                            ⭐ Top Rated
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="no-rating mb-0">
                                                    No reviews yet
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="d-flex gap-2">
                                        <a href="/reviews?sellerId=${seller.id}"
                                           class="btn btn-view-profile btn-sm">
                                            ⭐ View Reviews
                                        </a>
                                        <a href="/car-list"
                                           class="btn btn-outline-secondary btn-sm"
                                           style="border-radius:8px;
                                                  font-size:13px;">
                                            🚗 Browse Cars
                                        </a>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </c:forEach>

        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <div style="font-size:80px;">⭐</div>
                <h4 class="mt-3 text-muted">
                    No sellers yet
                </h4>
                <p class="text-muted">
                    Sellers will appear here once
                    they join the platform
                </p>
                <a href="/car-list"
                   class="btn btn-primary mt-2">
                    Browse Cars
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>