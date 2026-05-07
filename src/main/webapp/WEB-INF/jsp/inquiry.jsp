<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Inquiry - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #fd7e14, #e8590c);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .inquiry-card {
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
        }
        .car-summary {
            background-color: #fff8f0;
            border: 1px solid #ffd8a8;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
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
            margin-right: 4px;
        }
        .btn-send {
            background-color: #fd7e14;
            color: white;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
        }
        .btn-send:hover {
            background-color: #e8590c;
            color: white;
        }
        .quick-msg-btn {
            background-color: #fff8f0;
            border: 1px solid #ffd8a8;
            color: #fd7e14;
            border-radius: 20px;
            padding: 5px 14px;
            font-size: 13px;
            cursor: pointer;
            margin-right: 6px;
            margin-bottom: 8px;
        }
        .quick-msg-btn:hover {
            background-color: #ffd8a8;
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

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">Send an Inquiry</h2>
        <p class="mb-0">Contact the seller and ask about this car</p>
    </div>
</div>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <!-- Check if logged in -->
            <% if(session.getAttribute("userId") == null) { %>
                <div class="text-center py-5">
                    <div style="font-size:64px;">🔒</div>
                    <h5 class="mt-3 text-muted">Please login to send an inquiry</h5>
                    <a href="/login" class="btn btn-primary mt-2">Login</a>
                </div>
            <% } else { %>

                <!-- Car Summary Box -->
                <div class="car-summary">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h5 class="fw-bold mb-1">
                                <c:out value="${car.brand} ${car.model}"/>
                            </h5>
                            <p class="text-muted mb-2" style="font-size:13px;">
                                📍 <c:out value="${car.location}"/>
                            </p>
                            <div>
                                <span class="spec-badge"><c:out value="${car.year}"/></span>
                                <span class="spec-badge"><c:out value="${car.fuelType}"/></span>
                                <span class="spec-badge"><c:out value="${car.mileage}"/> km</span>
                            </div>
                        </div>
                        <span class="price-badge">
                            LKR <c:out value="${car.price}"/>
                        </span>
                    </div>
                </div>

                <!-- Success/Error -->
                <% if(request.getAttribute("success") != null) { %>
                    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
                <% } %>
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                <% } %>

                <!-- Inquiry Form -->
                <div class="card inquiry-card">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3">Your Message</h5>

                        <!-- Quick Message Buttons -->
                        <p class="text-muted mb-2" style="font-size:13px;">
                            Quick messages:
                        </p>
                        <div class="mb-3">
                            <button type="button" class="quick-msg-btn"
                                    onclick="setMessage('Is this car still available?')">
                                Still available?
                            </button>
                            <button type="button" class="quick-msg-btn"
                                    onclick="setMessage('Can you negotiate on the price?')">
                                Negotiate price?
                            </button>
                            <button type="button" class="quick-msg-btn"
                                    onclick="setMessage('Can I schedule a test drive?')">
                                Test drive?
                            </button>
                            <button type="button" class="quick-msg-btn"
                                    onclick="setMessage('What is the condition of the vehicle?')">
                                Condition?
                            </button>
                        </div>

                        <form action="/sendInquiry" method="post">
                            <input type="hidden" name="carId" value="${car.id}">
                            <input type="hidden" name="sellerId" value="${car.sellerId}">
                            <input type="hidden" name="buyerId"
                                   value="<%= session.getAttribute("userId") %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Inquiry Type</label>
                                <select name="inquiryType" class="form-select" required>
                                    <option value="">-- Select Type --</option>
                                    <option value="QUESTION">General Question</option>
                                    <option value="PRICE_OFFER">Price Offer</option>
                                    <option value="TEST_DRIVE">Test Drive Request</option>
                                    <option value="AVAILABILITY">Availability Check</option>
                                </select>
                            </div>

                            <div class="mb-3" id="offerSection" style="display:none;">
                                <label class="form-label fw-semibold">
                                    Your Offer (LKR)
                                </label>
                                <input type="number" name="offerPrice"
                                       class="form-control"
                                       placeholder="Enter your offer price">
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Message</label>
                                <textarea name="message" id="messageBox"
                                          class="form-control" rows="5"
                                          placeholder="Write your message to the seller..."
                                          required></textarea>
                            </div>

                            <button type="submit" class="btn btn-send">
                                Send Inquiry
                            </button>
                        </form>
                    </div>
                </div>

            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function setMessage(msg) {
        document.getElementById('messageBox').value = msg;
    }

    document.addEventListener('DOMContentLoaded', function() {
        const inquiryType = document.querySelector('select[name="inquiryType"]');
        const offerSection = document.getElementById('offerSection');
        if(inquiryType) {
            inquiryType.addEventListener('change', function() {
                if(this.value === 'PRICE_OFFER') {
                    offerSection.style.display = 'block';
                } else {
                    offerSection.style.display = 'none';
                }
            });
        }
    });
</script>
</body>
</html>