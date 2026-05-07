<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Negotiation - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #fd7e14, #e8590c);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
        }
        .chat-container {
            max-width: 750px;
            margin: 0 auto;
        }
        .car-summary {
            background-color: #fff8f0;
            border: 1px solid #ffd8a8;
            border-radius: 12px;
            padding: 16px 20px;
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
        .chat-box {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 24px;
            margin-bottom: 20px;
            min-height: 300px;
            max-height: 500px;
            overflow-y: auto;
        }
        .message-bubble {
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
        }
        .message-bubble.sent {
            align-items: flex-end;
        }
        .message-bubble.received {
            align-items: flex-start;
        }
        .bubble {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.5;
        }
        .bubble.sent {
            background-color: #fd7e14;
            color: white;
            border-bottom-right-radius: 4px;
        }
        .bubble.received {
            background-color: #f0f0f0;
            color: #212529;
            border-bottom-left-radius: 4px;
        }
        .bubble-offer {
            background-color: #d1fae5;
            border: 1px solid #a7f3d0;
            border-radius: 12px;
            padding: 10px 16px;
            font-size: 14px;
            max-width: 70%;
            margin-bottom: 4px;
        }
        .sender-name {
            font-size: 11px;
            color: #6c757d;
            margin-bottom: 4px;
            padding: 0 4px;
        }
        .message-time {
            font-size: 11px;
            color: #6c757d;
            margin-top: 4px;
            padding: 0 4px;
        }
        .reply-box {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 24px;
        }
        .btn-send {
            background-color: #fd7e14;
            color: white;
            border-radius: 10px;
            padding: 10px 28px;
            font-weight: 600;
        }
        .btn-send:hover {
            background-color: #e8590c;
            color: white;
        }
        .quick-reply-btn {
            background-color: #fff8f0;
            border: 1px solid #ffd8a8;
            color: #fd7e14;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 12px;
            cursor: pointer;
            margin-right: 6px;
            margin-bottom: 6px;
        }
        .quick-reply-btn:hover {
            background-color: #ffd8a8;
        }
        .status-badge {
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-accepted {
            background-color: #d1fae5;
            color: #198754;
        }
        .status-declined {
            background-color: #fee2e2;
            color: #dc3545;
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
            <a href="/inbox"
               class="btn btn-outline-light btn-sm">
                My Inbox
            </a>
            <a href="/car-list"
               class="btn btn-outline-light btn-sm">
                Browse Cars
            </a>
            <% if(session.getAttribute("userId") != null) { %>
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

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="fw-bold mb-1">Negotiation Thread</h2>
        <p class="mb-0">
            Chat with the other party about this car
        </p>
    </div>
</div>

<div class="container pb-5">
    <div class="chat-container">

        <!-- Back Button -->
        <a href="/inbox"
           class="btn btn-outline-secondary btn-sm mb-3">
            &larr; Back to Inbox
        </a>

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

        <c:if test="${not empty inquiry}">

            <!-- Car Summary -->
            <div class="car-summary">
                <div class="d-flex justify-content-between
                            align-items-center">
                    <div>
                        <h6 class="fw-bold mb-1">
                            <c:out value="${inquiry.carBrand}"/>
                            <c:out value="${inquiry.carModel}"/>
                        </h6>
                        <p class="text-muted mb-0"
                           style="font-size:13px;">
                            Listed price:
                            <strong>
                                LKR
                                <c:out value="${inquiry.carPrice}"/>
                            </strong>
                        </p>
                    </div>
                    <div class="text-end">
                        <c:choose>
                            <c:when test="${inquiry.status == 'PENDING'}">
                                <span class="status-badge status-pending">
                                    Pending
                                </span>
                            </c:when>
                            <c:when test="${inquiry.status == 'ACCEPTED'}">
                                <span class="status-badge status-accepted">
                                    Accepted
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-declined">
                                    Declined
                                </span>
                            </c:otherwise>
                        </c:choose>
                        <br>
                        <a href="/carDetail?id=${inquiry.carId}"
                           class="btn btn-outline-secondary btn-sm mt-1"
                           style="font-size:12px;">
                            View Car
                        </a>
                    </div>
                </div>
            </div>

            <!-- Chat Box -->
            <div class="chat-box" id="chatBox">

                <!-- Original Inquiry -->
                <div class="message-bubble received">
                    <span class="sender-name">
                        <c:out value="${inquiry.senderName}"/>
                        (Original Inquiry)
                    </span>
                    <c:choose>
                        <c:when test="${inquiry.offerPrice > 0}">
                            <div class="bubble-offer">
                                <p class="fw-bold mb-1"
                                   style="font-size:13px;">
                                    Price Offer
                                </p>
                                <p class="mb-1">
                                    LKR
                                    <strong>
                                        <c:out value="${inquiry.offerPrice}"/>
                                    </strong>
                                </p>
                                <p class="mb-0"
                                   style="font-size:13px;">
                                    <c:out value="${inquiry.message}"/>
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="bubble received">
                                <c:out value="${inquiry.message}"/>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <span class="message-time">
                        <c:out value="${inquiry.sentDate}"/>
                    </span>
                </div>

                <!-- Replies -->
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach var="msg"
                                   items="${messages}">
                            <c:choose>
                                <c:when test="${msg.senderId == sessionScope.userId}">
                                    <!-- Sent by current user -->
                                    <div class="message-bubble sent">
                                        <c:choose>
                                            <c:when test="${msg.offerPrice > 0}">
                                                <div class="bubble-offer">
                                                    <p class="fw-bold mb-1"
                                                       style="font-size:13px;">
                                                        Counter Offer
                                                    </p>
                                                    <p class="mb-1">
                                                        LKR
                                                        <strong>
                                                            <c:out value="${msg.offerPrice}"/>
                                                        </strong>
                                                    </p>
                                                    <p class="mb-0"
                                                       style="font-size:13px;">
                                                        <c:out value="${msg.message}"/>
                                                    </p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bubble sent">
                                                    <c:out value="${msg.message}"/>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="message-time">
                                            You ·
                                            <c:out value="${msg.sentDate}"/>
                                        </span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Received -->
                                    <div class="message-bubble received">
                                        <span class="sender-name">
                                            <c:out value="${msg.senderName}"/>
                                        </span>
                                        <c:choose>
                                            <c:when test="${msg.offerPrice > 0}">
                                                <div class="bubble-offer">
                                                    <p class="fw-bold mb-1"
                                                       style="font-size:13px;">
                                                        Counter Offer
                                                    </p>
                                                    <p class="mb-1">
                                                        LKR
                                                        <strong>
                                                            <c:out value="${msg.offerPrice}"/>
                                                        </strong>
                                                    </p>
                                                    <p class="mb-0"
                                                       style="font-size:13px;">
                                                        <c:out value="${msg.message}"/>
                                                    </p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bubble received">
                                                    <c:out value="${msg.message}"/>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="message-time">
                                            <c:out value="${msg.sentDate}"/>
                                        </span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-3
                                    text-muted">
                            <p style="font-size:14px;">
                                No replies yet.
                                Start the conversation!
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- Reply Box -->
            <div class="reply-box">
                <h6 class="fw-bold mb-3">Reply</h6>

                <!-- Quick Replies -->
                <div class="mb-3">
                    <button type="button"
                            class="quick-reply-btn"
                            onclick="setReply('Yes, the car is still available.')">
                        Still available
                    </button>
                    <button type="button"
                            class="quick-reply-btn"
                            onclick="setReply('Sorry, the car has already been sold.')">
                        Already sold
                    </button>
                    <button type="button"
                            class="quick-reply-btn"
                            onclick="setReply('The price is negotiable. Please make an offer.')">
                        Price negotiable
                    </button>
                    <button type="button"
                            class="quick-reply-btn"
                            onclick="setReply('You can come for a test drive this weekend.')">
                        Test drive available
                    </button>
                </div>

                <form action="/replyInquiry" method="post">
                    <input type="hidden"
                           name="inquiryId"
                           value="${inquiry.id}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">
                            Message
                        </label>
                        <textarea name="message"
                                  id="replyBox"
                                  class="form-control"
                                  rows="3"
                                  placeholder="Type your reply here..."
                                  required></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">
                            Counter Offer (LKR)
                            <span class="text-muted fw-normal">
                                (optional)
                            </span>
                        </label>
                        <input type="number"
                               name="offerPrice"
                               class="form-control"
                               placeholder="Enter a counter offer price if needed">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit"
                                class="btn btn-send">
                            Send Reply
                        </button>
                        <a href="/inbox"
                           class="btn btn-outline-secondary"
                           style="border-radius:10px;">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>

        </c:if>

        <c:if test="${empty inquiry}">
            <div class="text-center py-5">
                <div style="font-size:64px;">💬</div>
                <h5 class="mt-3 text-muted">
                    No inquiry selected
                </h5>
                <a href="/inbox"
                   class="btn btn-primary mt-2">
                    Go to Inbox
                </a>
            </div>
        </c:if>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function setReply(msg) {
        document.getElementById('replyBox').value = msg;
    }

    // Auto scroll chat to bottom
    window.onload = function() {
        var chatBox = document.getElementById('chatBox');
        if (chatBox) {
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    }
</script>
</body>
</html>