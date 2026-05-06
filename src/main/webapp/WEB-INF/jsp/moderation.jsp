<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Management - Second Hand Car Sales</title>
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
        .review-card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
            margin-bottom: 16px;
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
        .stars-display {
            color: #ffc107;
            font-size: 14px;
            letter-spacing: 1px;
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
        .badge-published {
            background-color: #d1fae5;
            color: #198754;
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

<div class="sidebar">
    <span class="sidebar-brand">🚗 CarSales Admin</span>
    <a href="/dashboard" class="sidebar-link">Dashboard</a>
    <a href="/manage-users" class="sidebar-link">Manage Users</a>
    <a href="/manage-listings" class="sidebar-link">Manage Listings</a>
    <a href="/moderation" class="sidebar-link active">
        Review Management
    </a>
    <hr style="border-color:#343a40; margin: 16px 0;">
    <a href="/logout" class="sidebar-link"
       style="color:#dc3545;">Logout</a>
</div>

<div class="main-content">

    <% if(session.getAttribute("userRole") == null ||
          !session.getAttribute("userRole").equals("ADMIN")) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">
                Access denied — Admins only
            </h5>
            <a href="/login" class="btn btn-primary mt-2">
                Login as Admin
            </a>
        </div>
    <% } else { %>

        <!-- Header -->
        <div class="d-flex justify-content-between
                    align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-0">
                    Review Management
                </h3>
                <p class="text-muted mb-0"
                   style="font-size:14px;">
                    View and remove user submitted reviews
                </p>
            </div>
        </div>

        <!-- Success Message -->
        <% if(request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <!-- Reviews List -->
        <c:choose>
            <c:when test="${not empty reviewList}">

                <p class="text-muted mb-3"
                   style="font-size:14px;">
                    <strong>${reviewList.size()}</strong>
                    review(s) found
                </p>

                <c:forEach var="review" items="${reviewList}">
                    <div class="card review-card">
                        <div class="card-body p-4">
                            <div class="d-flex
                                        align-items-start
                                        gap-3">

                                <!-- Avatar -->
                                <div class="reviewer-avatar">
                                    <c:out value="${review.reviewerName.substring(0,1).toUpperCase()}"/>
                                </div>

                                <div class="flex-grow-1">
                                    <div class="d-flex
                                                justify-content-between
                                                align-items-start
                                                flex-wrap gap-2">
                                        <div>
                                            <p class="fw-bold mb-0">
                                                <c:out value="${review.reviewerName}"/>
                                            </p>
                                            <p class="text-muted mb-1"
                                               style="font-size:12px;">
                                                About:
                                                <c:out value="${review.sellerName}"/>
                                            </p>
                                            <div class="d-flex
                                                        align-items-center
                                                        gap-2 mb-2">
                                                <span class="stars-display">
                                                    <c:forEach begin="1"
                                                               end="5"
                                                               var="s">
                                                        <c:choose>
                                                            <c:when test="${s <= review.rating}">
                                                                &#9733;
                                                            </c:when>
                                                            <c:otherwise>
                                                                &#9734;
                                                            </c:otherwise>
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
                                                        <span class="badge-public">
                                                            Public
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="badge-published">
                                                    ✓ Published
                                                </span>
                                            </div>
                                        </div>
                                        <p class="text-muted mb-0"
                                           style="font-size:12px;">
                                            <c:out value="${review.reviewDate}"/>
                                        </p>
                                    </div>

                                    <!-- Review Title -->
                                    <h6 class="fw-bold mb-1">
                                        <c:out value="${review.title}"/>
                                    </h6>

                                    <!-- Review Text -->
                                    <p class="mb-2"
                                       style="font-size:14px;
                                              color:#444;
                                              line-height:1.7;">
                                        <c:out value="${review.reviewText}"/>
                                    </p>

                                    <!-- Recommend -->
                                    <c:choose>
                                        <c:when test="${review.recommend == 'YES'}">
                                            <p class="recommend-yes mb-3">
                                                &#10003; Recommends this seller
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="recommend-no mb-3">
                                                &#10007; Does not recommend
                                            </p>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Delete Button -->
                                    <form action="/deleteReview"
                                          method="post"
                                          onsubmit="return confirm(
                                            'Are you sure you want to delete this review?');">
                                        <input type="hidden"
                                               name="reviewId"
                                               value="${review.id}">
                                        <button type="submit"
                                                class="btn btn-outline-danger btn-sm"
                                                style="border-radius:8px;
                                                       font-size:13px;">
                                            🗑️ Delete Review
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <div style="font-size:64px;">⭐</div>
                    <h5 class="mt-3 text-muted">
                        No reviews yet
                    </h5>
                    <p class="text-muted">
                        Reviews submitted by users
                        will appear here
                    </p>
                </div>
            </c:otherwise>
        </c:choose>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>