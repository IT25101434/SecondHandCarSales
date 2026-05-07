<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inbox - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #fd7e14, #e8590c);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .inbox-tabs .nav-link {
            color: #6c757d;
            font-weight: 500;
            border-radius: 8px 8px 0 0;
        }
        .inbox-tabs .nav-link.active {
            color: #fd7e14;
            border-bottom: 3px solid #fd7e14;
            background: none;
        }
        .message-card {
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            border: none;
            margin-bottom: 16px;
            transition: transform 0.2s;
            cursor: pointer;
            border-left: 4px solid #dee2e6;
        }
        .message-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background-color: #fd7e14;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .badge-type {
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-question {
            background-color: #e7f1ff;
            color: #0d6efd;
        }
        .badge-offer {
            background-color: #d1fae5;
            color: #198754;
        }
        .badge-testdrive {
            background-color: #fff3cd;
            color: #856404;
        }
        .badge-availability {
            background-color: #f3e8ff;
            color: #6f42c1;
        }
        .badge-new {
            background-color: #fd7e14;
            color: white;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 11px;
        }
        .time-text {
            font-size: 12px;
            color: #6c757d;
        }
        .empty-state {
            text-align: center;
            padding: 60px 0;
        }
        .btn-reply {
            background-color: #fd7e14;
            color: white;
            border-radius: 8px;
            padding: 5px 16px;
            font-size: 13px;
        }
        .btn-reply:hover {
            background-color: #e8590c;
            color: white;
        }
    </style>
</head>
<body>

<%-- Get user role for tab labels --%>
<% String userRole =
    (String) session.getAttribute("userRole"); %>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/car-list">
            🚗 CarSales LK
        </a>
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
        <h2 class="fw-bold mb-1">My Inbox</h2>
        <p class="mb-0">
            Manage your inquiries and messages
        </p>
    </div>
</div>

<div class="container">

    <% if(session.getAttribute("userId") == null) { %>
        <div class="text-center py-5">
            <div style="font-size:64px;">🔒</div>
            <h5 class="mt-3 text-muted">
                Please login to view your inbox
            </h5>
            <a href="/login" class="btn btn-primary mt-2">
                Login
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

        <!-- Tabs -->
        <ul class="nav inbox-tabs border-bottom mb-4">
            <% if("BUYER".equals(userRole)) { %>
                <!-- Buyer sees My Inquiries tab -->
                <li class="nav-item">
                    <a class="nav-link
                       <%= (request.getParameter("tab") == null
                           || request.getParameter("tab")
                               .equals("received"))
                           ? "active" : "" %>"
                       href="/inbox?tab=received">
                        My Inquiries
                    </a>
                </li>
            <% } else { %>
                <!-- Seller sees Received and Sent tabs -->
                <li class="nav-item">
                    <a class="nav-link
                       <%= (request.getParameter("tab") == null
                           || request.getParameter("tab")
                               .equals("received"))
                           ? "active" : "" %>"
                       href="/inbox?tab=received">
                        Received
                        <c:if test="${unreadCount > 0}">
                            <span class="badge-new ms-1">
                                ${unreadCount}
                            </span>
                        </c:if>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link
                       <%= "sent".equals(
                           request.getParameter("tab"))
                           ? "active" : "" %>"
                       href="/inbox?tab=sent">
                        Sent
                    </a>
                </li>
            <% } %>
        </ul>

        <!-- Message List -->
        <c:choose>
            <c:when test="${not empty inquiryList}">
                <p class="text-muted mb-3"
                   style="font-size:14px;">
                    <strong>${inquiryList.size()}</strong>
                    message(s)
                </p>

                <c:forEach var="inquiry"
                           items="${inquiryList}">
                    <div class="card message-card">
                        <div class="card-body p-3">
                            <div class="d-flex
                                        align-items-start
                                        gap-3">

                                <!-- Avatar -->
                                <div class="avatar">
                                    <c:out value="${inquiry.senderName.substring(0,1).toUpperCase()}"/>
                                </div>

                                <!-- Message Content -->
                                <div class="flex-grow-1">
                                    <div class="d-flex
                                                justify-content-between
                                                align-items-start">
                                        <div>
                                            <p class="fw-bold mb-0">
                                                <c:out value="${inquiry.senderName}"/>
                                            </p>
                                            <p class="text-muted mb-1"
                                               style="font-size:13px;">
                                                Re:
                                                <c:out value="${inquiry.carBrand}"/>
                                                <c:out value="${inquiry.carModel}"/>
                                            </p>
                                        </div>
                                        <div class="text-end">
                                            <p class="time-text mb-1">
                                                <c:out value="${inquiry.sentDate}"/>
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Inquiry Type Badge -->
                                    <div class="mb-2">
                                        <c:choose>
                                            <c:when test="${inquiry.inquiryType == 'QUESTION'}">
                                                <span class="badge-type badge-question">
                                                    General Question
                                                </span>
                                            </c:when>
                                            <c:when test="${inquiry.inquiryType == 'PRICE_OFFER'}">
                                                <span class="badge-type badge-offer">
                                                    Price Offer
                                                </span>
                                            </c:when>
                                            <c:when test="${inquiry.inquiryType == 'TEST_DRIVE'}">
                                                <span class="badge-type badge-testdrive">
                                                    Test Drive
                                                </span>
                                            </c:when>
                                            <c:when test="${inquiry.inquiryType == 'AVAILABILITY'}">
                                                <span class="badge-type badge-availability">
                                                    Availability
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <!-- Message -->
                                    <p class="mb-2"
                                       style="font-size:14px;
                                              color:#444;">
                                        <c:out value="${inquiry.message}"/>
                                    </p>

                                    <!-- Offer Price -->
                                    <c:if test="${inquiry.offerPrice > 0}">
                                        <p class="mb-2"
                                           style="font-size:13px;">
                                            Offer:
                                            <strong class="text-success">
                                                LKR
                                                <c:out value="${inquiry.offerPrice}"/>
                                            </strong>
                                        </p>
                                    </c:if>

                                    <!-- Action Buttons -->
                                    <div class="d-flex gap-2 mt-2">
                                        <a href="/negotiation?inquiryId=${inquiry.id}"
                                           class="btn btn-reply btn-sm">
                                            View Thread
                                        </a>
                                        <a href="/carDetail?id=${inquiry.carId}"
                                           class="btn btn-outline-secondary btn-sm"
                                           style="font-size:13px;
                                                  border-radius:8px;">
                                            View Car
                                        </a>
                                        <form action="/deleteInquiry"
                                              method="post"
                                              onsubmit="return confirm(
                                                'Delete this message?');">
                                            <input type="hidden"
                                                   name="inquiryId"
                                                   value="${inquiry.id}">
                                            <button type="submit"
                                                    class="btn btn-outline-danger btn-sm"
                                                    style="font-size:13px;
                                                           border-radius:8px;">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </c:forEach>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div style="font-size:64px;">📭</div>
                    <h5 class="mt-3 text-muted">
                        No messages yet
                    </h5>
                    <p class="text-muted">
                        <% if("BUYER".equals(userRole)) { %>
                            Send an inquiry on a car
                            to start a conversation
                        <% } else { %>
                            When someone sends you
                            an inquiry it will appear here
                        <% } %>
                    </p>
                    <a href="/car-list"
                       class="btn btn-primary mt-2">
                        Browse Cars
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>