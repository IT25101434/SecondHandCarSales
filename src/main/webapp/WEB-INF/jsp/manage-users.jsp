<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Second Hand Car Sales</title>
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
        .user-table-card {
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
        .avatar-sm {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #0d6efd;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .badge-buyer {
            background-color: #e7f1ff;
            color: #0d6efd;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-seller {
            background-color: #fff3cd;
            color: #856404;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-admin {
            background-color: #f3e8ff;
            color: #6f42c1;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-active {
            background-color: #d1fae5;
            color: #198754;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-suspended {
            background-color: #fee2e2;
            color: #dc3545;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <span class="sidebar-brand">🚗 CarSales Admin</span>
    <a href="/dashboard" class="sidebar-link">Dashboard</a>
    <a href="/manage-users" class="sidebar-link active">Manage Users</a>
    <a href="/manage-listings" class="sidebar-link">Manage Listings</a>
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
                <h3 class="fw-bold mb-0">Manage Users</h3>
                <p class="text-muted mb-0" style="font-size:14px;">
                    View, suspend, or delete user accounts
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
            <form action="/manage-users" method="get">
                <div class="row g-2 align-items-end">
                    <div class="col-md-5">
                        <input type="text" name="search"
                               class="form-control form-control-sm"
                               placeholder="Search by name or email..."
                               value="${param.search}">
                    </div>
                    <div class="col-md-3">
                        <select name="role" class="form-select form-select-sm">
                            <option value="">All Roles</option>
                            <option value="BUYER" ${param.role == 'BUYER' ? 'selected' : ''}>Buyer</option>
                            <option value="SELLER" ${param.role == 'SELLER' ? 'selected' : ''}>Seller</option>
                            <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select form-select-sm">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="SUSPENDED" ${param.status == 'SUSPENDED' ? 'selected' : ''}>Suspended</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-sm w-100">Search</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="card user-table-card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <c:forEach var="user" items="${userList}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-sm">
                                                    <c:out value="${user.fullName.substring(0,1).toUpperCase()}"/>
                                                </div>
                                                <div>
                                                    <p class="fw-semibold mb-0" style="font-size:13px;">
                                                        <c:out value="${user.fullName}"/>
                                                    </p>
                                                    <p class="text-muted mb-0" style="font-size:11px;">
                                                        <c:out value="${user.email}"/>
                                                    </p>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="font-size:13px;"><c:out value="${user.phone}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.role == 'BUYER'}">
                                                    <span class="badge-buyer">Buyer</span>
                                                </c:when>
                                                <c:when test="${user.role == 'SELLER'}">
                                                    <span class="badge-seller">Seller</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-admin">Admin</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.status == 'ACTIVE'}">
                                                    <span class="badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-suspended">Suspended</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-1 flex-wrap">
                                                <c:choose>
                                                    <c:when test="${user.status == 'ACTIVE'}">
                                                        <form action="/suspendUser" method="post">
                                                            <input type="hidden" name="userId" value="${user.id}">
                                                            <button type="submit"
                                                                    class="btn btn-warning btn-sm"
                                                                    style="font-size:12px; border-radius:6px;">
                                                                Suspend
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="/activateUser" method="post">
                                                            <input type="hidden" name="userId" value="${user.id}">
                                                            <button type="submit"
                                                                    class="btn btn-success btn-sm"
                                                                    style="font-size:12px; border-radius:6px;">
                                                                Activate
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                                <form action="/deleteUser" method="post"
                                                      onsubmit="return confirm('Delete this user?');">
                                                    <input type="hidden" name="userId" value="${user.id}">
                                                    <button type="submit"
                                                            class="btn btn-outline-danger btn-sm"
                                                            style="font-size:12px; border-radius:6px;">
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        No users found
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