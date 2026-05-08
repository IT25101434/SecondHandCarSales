<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Review - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #d63384, #a0195e);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .review-card {
            max-width: 650px;
            margin: 0 auto;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
        }
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 6px;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            font-size: 36px;
            color: #dee2e6;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #ffc107;
        }
        .seller-summary {
            background-color: #fdf0f6;
            border: 1px solid #f0a8cc;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
        }
        .seller-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background-color: #d63384;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
        }
        .btn-submit {
            background-color: #d63384;
            color: white;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
        }
        .btn-submit:hover {
            background-color: #a0195e;
            color: white;
        }
        .rating-label {
            font-size: 14px;
            color: #6c757d;
            margin-left: 8px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">🚗 CarSales LK</a>
        <div class="ms-auto d-flex gap-2">
            <a href="/car-list" class="btn btn-outline-light btn-sm">Browse Cars</a>
            <% if(session.getAttribute("userId") != null) { %>
                <a href="/profile" class="btn btn-outline-light btn-sm">My Profile</a>
                <a href="/logout" class="btn btn-danger btn-sm">Logout</a>
            <% } else { %>
                <a href="/login" class="btn btn-outline-light btn-sm">Login</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">Write a Review</h2>
        <p class="mb-0">Share your experience with this seller</p>
    </div>
</div>

<div class="container pb-5">

    <% if(session.getAttribute("userId") == null) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">Please login to write a review</h5>
            <a href="/login" class="btn btn-primary mt-2">Login</a>
        </div>
    <% } else { %>

        <div class="card review-card">
            <div class="card-body p-4">

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

                <!-- Seller Summary -->
                <div class="seller-summary">
                    <div class="d-flex align-items-center gap-3">
                        <div class="seller-avatar">
                            <c:out value="${seller.fullName.substring(0,1).toUpperCase()}"/>
                        </div>
                        <div>
                            <p class="fw-bold mb-0">
                                <c:out value="${seller.fullName}"/>
                            </p>
                            <p class="text-muted mb-0" style="font-size:13px;">
                                Seller · <c:out value="${seller.email}"/>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Review Form -->
                <form action="/submitReview" method="post">
                    <input type="hidden" name="sellerId" value="${seller.id}">
                    <input type="hidden" name="reviewerId"
                           value="<%= session.getAttribute("userId") %>">

                    <!-- Star Rating -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold d-block">
                            Overall Rating
                        </label>
                        <div class="d-flex align-items-center">
                            <div class="star-rating">
                                <input type="radio" name="rating" id="star5" value="5">
                                <label for="star5">&#9733;</label>
                                <input type="radio" name="rating" id="star4" value="4">
                                <label for="star4">&#9733;</label>
                                <input type="radio" name="rating" id="star3" value="3" checked>
                                <label for="star3">&#9733;</label>
                                <input type="radio" name="rating" id="star2" value="2">
                                <label for="star2">&#9733;</label>
                                <input type="radio" name="rating" id="star1" value="1">
                                <label for="star1">&#9733;</label>
                            </div>
                            <span class="rating-label" id="ratingText">3 — Good</span>
                        </div>
                    </div>

                    <!-- Review Type -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Review Type</label>
                        <select name="reviewType" class="form-select" required>
                            <option value="PUBLIC">Public Review</option>
                            <option value="VERIFIED">Verified Purchase Review</option>
                        </select>
                    </div>

                    <!-- Review Title -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Review Title</label>
                        <input type="text" name="title" class="form-control"
                               placeholder="Summarize your experience" required>
                    </div>

                    <!-- Review Body -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Your Review</label>
                        <textarea name="reviewText" class="form-control" rows="5"
                                  placeholder="Tell others about your experience with this seller —
was the car as described? Was the seller honest and responsive?"
                                  required></textarea>
                    </div>

                    <!-- Would Recommend -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold">
                            Would you recommend this seller?
                        </label>
                        <div class="d-flex gap-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio"
                                       name="recommend" value="YES" id="recYes" checked>
                                <label class="form-check-label" for="recYes">
                                    Yes, I recommend
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio"
                                       name="recommend" value="NO" id="recNo">
                                <label class="form-check-label" for="recNo">
                                    No, I don't recommend
                                </label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-submit">
                        Submit Review
                    </button>

                </form>
            </div>
        </div>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const ratingLabels = {
        1: '1 — Poor',
        2: '2 — Fair',
        3: '3 — Good',
        4: '4 — Very Good',
        5: '5 — Excellent'
    };

    document.querySelectorAll('.star-rating input').forEach(function(input) {
        input.addEventListener('change', function() {
            document.getElementById('ratingText').textContent =
                ratingLabels[this.value];
        });
    });
</script>
</body>
</html>