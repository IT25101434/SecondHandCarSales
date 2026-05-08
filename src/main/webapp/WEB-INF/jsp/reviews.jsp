<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews - Second Hand Car Sales</title>
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
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            padding: 24px;
            margin-bottom: 30px;
        }
        .seller-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: #d63384;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
        }
        .rating-big {
            font-size: 48px;
            font-weight: 700;
            color: #d63384;
            line-height: 1;
        }
        .stars-display {
            color: #ffc107;
            font-size: 20px;
            letter-spacing: 2px;
        }
        .stars-display.small {
            font-size: 14px;
            letter-spacing: 1px;
        }
        .rating-bar {
            height: 8px;
            border-radius: 4px;
            background-color: #ffc107;
        }
        .rating-bar-bg {
            height: 8px;
            border-radius: 4px;
            background-color: #f0f0f0;
            flex: 1;
        }
        .review-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .reviewer-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background-color: #6c757d;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .badge-verified {
            background-color: #d1fae5;
            color: #198754;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-public {
            background-color: #e7f1ff;
            color: #0d6efd;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .recommend-yes {
            color: #198754;
            font-size: 13px;
            font-weight: 500;
        }
        .recommend-no {
            color: #dc3545;
            font-size: 13px;
            font-weight: 500;
        }

    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/">🚗 CarSales LK</a>
        <div class="ms-auto d-flex gap-2">
            <a href="/car-list" class="btn btn-outline-light btn-sm">Browse Cars</a>
            <% if(session.getAttribute("userId") != null) { %>
                <a href="/profile" class="btn btn-outline-light btn-sm">My Profile</a>
                <a href="/logout" class="btn btn-danger btn-sm">Logout</a>
            <% } else { %>
                <a href="/login" class="btn btn-outline-light btn-sm">Login</a>
                <a href="/register" class="btn btn-success btn-sm">Register</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">Seller Reviews</h2>
        <p class="mb-0">See what buyers say about this seller</p>
    </div>
</div>

<div class="container pb-5">

    <!-- Success/Error -->
    <% if(request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <!-- Seller Summary Card -->
    <div class="card seller-card">
        <div class="row align-items-center g-4">

            <!-- Seller Info -->
            <div class="col-md-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="seller-avatar">
                        <c:out value="${seller.fullName.substring(0,1).toUpperCase()}"/>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0">
                            <c:out value="${seller.fullName}"/>
                        </h5>
                        <p class="text-muted mb-0" style="font-size:13px;">Verified Seller</p>
                        <p class="text-muted mb-0" style="font-size:12px;">
                            <c:out value="${totalReviews}"/> reviews
                        </p>
                    </div>
                </div>
            </div>

            <!-- Overall Rating -->
            <div class="col-md-3 text-center">
                <div class="rating-big">${averageRating}</div>
                <div class="stars-display">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= averageRating}">&#9733;</c:when>
                            <c:otherwise>&#9734;</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <p class="text-muted mt-1 mb-0" style="font-size:13px;">
                    Average rating
                </p>
            </div>

            <!-- Rating Breakdown -->
            <div class="col-md-5">
                <c:forEach begin="1" end="5" var="i" varStatus="loop">
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span style="font-size:12px; width:14px; text-align:right;">
                            ${6 - i}
                        </span>
                        <span style="color:#ffc107; font-size:12px;">&#9733;</span>
                        <div class="rating-bar-bg">
                            <div class="rating-bar"
                                 style="width:${ratingBreakdown[6-i]}%">
                            </div>
                        </div>
                        <span style="font-size:12px; color:#6c757d; width:28px;">
                            ${ratingBreakdown[6-i]}%
                        </span>
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>



    <!-- Reviews List -->
    <c:choose>
        <c:when test="${not empty reviewList}">
            <p class="text-muted mb-3" style="font-size:14px;">
                Showing <strong>${reviewList.size()}</strong> review(s)
            </p>

            <c:forEach var="review" items="${reviewList}">
                <div class="card review-card">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-start gap-3">

                            <!-- Reviewer Avatar -->
                            <div class="reviewer-avatar">
                                <c:out value="${review.reviewerName.substring(0,1).toUpperCase()}"/>
                            </div>

                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between
                                            align-items-start flex-wrap gap-2">
                                    <div>
                                        <p class="fw-bold mb-0">
                                            <c:out value="${review.reviewerName}"/>
                                        </p>
                                        <div class="d-flex align-items-center gap-2 mt-1">
                                            <span class="stars-display small">
                                                <c:forEach begin="1" end="5" var="s">
                                                    <c:choose>
                                                        <c:when test="${s <= review.rating}">
                                                            &#9733;
                                                        </c:when>
                                                        <c:otherwise>&#9734;</c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                            <c:choose>
                                                <c:when test="${review.reviewType == 'VERIFIED'}">
                                                    <span class="badge-verified">
                                                        Verified
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-public">Public</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <p class="text-muted mb-0" style="font-size:12px;">
                                        <c:out value="${review.reviewDate}"/>
                                    </p>
                                </div>

                                <!-- Review Title -->
                                <h6 class="fw-bold mt-2 mb-1">
                                    <c:out value="${review.title}"/>
                                </h6>

                                <!-- Review Text -->
                                <p class="mb-2" style="font-size:14px; color:#444;
                                           line-height:1.7;">
                                    <c:out value="${review.reviewText}"/>
                                </p>

                                <!-- Recommend -->
                                <c:choose>
                                    <c:when test="${review.recommend == 'YES'}">
                                        <p class="recommend-yes mb-0">
                                            &#10003; Recommends this seller
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="recommend-no mb-0">
                                            &#10007; Does not recommend this seller
                                        </p>
                                    </c:otherwise>
                                </c:choose>



                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <div style="font-size:64px;">⭐</div>
                <h5 class="mt-3 text-muted">No reviews yet</h5>
                <p class="text-muted">Be the first to review this seller</p>
                <% if(session.getAttribute("userId") != null) { %>
                    <a href="/add-review?sellerId=${seller.id}"
                       class="btn btn-write mt-2">
                        Write First Review
                    </a>
                <% } else { %>
                    <a href="/login" class="btn btn-primary mt-2">
                        Login to Review
                    </a>
                <% } %>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>