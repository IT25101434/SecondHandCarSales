<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty car ? 'Edit Car' : 'Post a Car'} - Second Hand Car Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .form-card {
            max-width: 680px;
            margin: 40px auto;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #0d6efd;
            color: white;
            border-radius: 16px 16px 0 0 !important;
            padding: 24px;
            text-align: center;
        }
        .btn-post {
            background-color: #0d6efd;
            color: white;
            width: 100%;
        }
        .btn-post:hover {
            background-color: #0b5ed7;
            color: white;
        }
        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 1px solid #dee2e6;
        }
        .image-upload-box {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 24px;
            text-align: center;
            background-color: #f8f9fa;
            transition: border-color 0.2s;
        }
        .image-upload-box:hover {
            border-color: #0d6efd;
        }
        #previewImg {
            width: 100%;
            max-height: 250px;
            object-fit: cover;
            border-radius: 12px;
            margin-top: 12px;
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
                <% if("SELLER".equals(
                        session.getAttribute("userRole"))) { %>
                    <a href="/car-add"
                       class="btn btn-success btn-sm">
                        + Post a Car
                    </a>
                    <a href="/my-listings"
                       class="btn btn-outline-light btn-sm">
                        📋 My Listings
                    </a>
                <% } %>
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

<!-- Role Check -->
<% if(session.getAttribute("userId") == null ||
      !"SELLER".equals(
          session.getAttribute("userRole"))) { %>
    <div class="container text-center py-5">
        <div style="font-size:64px;">🔒</div>
        <h4 class="mt-3 text-muted">
            Only sellers can post cars
        </h4>
        <a href="/register"
           class="btn btn-primary mt-2 me-2">
            Register as Seller
        </a>
        <a href="/car-list"
           class="btn btn-outline-secondary mt-2">
            Browse Cars
        </a>
    </div>
<% } else { %>

<div class="container">
    <div class="card form-card">
        <div class="card-header">
            <h4 class="mb-0">
                ${not empty car ? 'Edit Car Listing' : 'Post Your Car for Sale'}
            </h4>
            <p class="mb-0 mt-1" style="font-size:14px;">
                ${not empty car ? 'Update your car details below' : 'Fill in the details below to list your car'}
            </p>
        </div>
        <div class="card-body p-4">

            <!-- Error/Success -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="${not empty car ? '/updateCar' : '/addCar'}"
                  method="post"
                  enctype="multipart/form-data">

                <!-- Hidden ID for update -->
                <c:if test="${not empty car}">
                    <input type="hidden" name="id"
                           value="${car.id}">
                </c:if>

                <!-- Car Basic Info -->
                <p class="section-title">Car Information</p>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Brand
                        </label>
                        <select name="brand"
                                class="form-select" required>
                            <option value="">
                                -- Select Brand --
                            </option>
                            <option value="Toyota"
                                ${car.brand == 'Toyota' ? 'selected' : ''}>
                                Toyota
                            </option>
                            <option value="Honda"
                                ${car.brand == 'Honda' ? 'selected' : ''}>
                                Honda
                            </option>
                            <option value="Nissan"
                                ${car.brand == 'Nissan' ? 'selected' : ''}>
                                Nissan
                            </option>
                            <option value="Suzuki"
                                ${car.brand == 'Suzuki' ? 'selected' : ''}>
                                Suzuki
                            </option>
                            <option value="Mitsubishi"
                                ${car.brand == 'Mitsubishi' ? 'selected' : ''}>
                                Mitsubishi
                            </option>
                            <option value="BMW"
                                ${car.brand == 'BMW' ? 'selected' : ''}>
                                BMW
                            </option>
                            <option value="Mercedes"
                                ${car.brand == 'Mercedes' ? 'selected' : ''}>
                                Mercedes
                            </option>
                            <option value="Audi"
                                ${car.brand == 'Audi' ? 'selected' : ''}>
                                Audi
                            </option>
                            <option value="Ford"
                                ${car.brand == 'Ford' ? 'selected' : ''}>
                                Ford
                            </option>
                            <option value="Other"
                                ${car.brand == 'Other' ? 'selected' : ''}>
                                Other
                            </option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Model
                        </label>
                        <input type="text" name="model"
                               class="form-control"
                               placeholder="e.g. Corolla, Civic"
                               value="${not empty car ? car.model : ''}"
                               required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Year of Manufacture
                        </label>
                        <input type="number" name="year"
                               class="form-control"
                               placeholder="e.g. 2018"
                               value="${not empty car ? car.year : ''}"
                               min="1990" max="2025" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Mileage (km)
                        </label>
                        <input type="number" name="mileage"
                               class="form-control"
                               placeholder="e.g. 45000"
                               value="${not empty car ? car.mileage : ''}"
                               required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Fuel Type
                        </label>
                        <select name="fuelType"
                                class="form-select" required>
                            <option value="">
                                -- Select Fuel --
                            </option>
                            <option value="Petrol"
                                ${car.fuelType == 'Petrol' ? 'selected' : ''}>
                                Petrol
                            </option>
                            <option value="Diesel"
                                ${car.fuelType == 'Diesel' ? 'selected' : ''}>
                                Diesel
                            </option>
                            <option value="Hybrid"
                                ${car.fuelType == 'Hybrid' ? 'selected' : ''}>
                                Hybrid
                            </option>
                            <option value="Electric"
                                ${car.fuelType == 'Electric' ? 'selected' : ''}>
                                Electric
                            </option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Transmission
                        </label>
                        <select name="transmission"
                                class="form-select" required>
                            <option value="">
                                -- Select --
                            </option>
                            <option value="Automatic"
                                ${car.transmission == 'Automatic' ? 'selected' : ''}>
                                Automatic
                            </option>
                            <option value="Manual"
                                ${car.transmission == 'Manual' ? 'selected' : ''}>
                                Manual
                            </option>
                        </select>
                    </div>
                </div>

                <!-- Pricing & Location -->
                <p class="section-title mt-4">
                    Pricing & Location
                </p>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Asking Price (LKR)
                        </label>
                        <input type="number" name="price"
                               class="form-control"
                               placeholder="e.g. 3500000"
                               value="${not empty car ? car.price : ''}"
                               required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">
                            Location
                        </label>
                        <select name="location"
                                class="form-select" required>
                            <option value="">
                                -- Select City --
                            </option>
                            <option value="Colombo"
                                ${car.location == 'Colombo' ? 'selected' : ''}>
                                Colombo
                            </option>
                            <option value="Kandy"
                                ${car.location == 'Kandy' ? 'selected' : ''}>
                                Kandy
                            </option>
                            <option value="Galle"
                                ${car.location == 'Galle' ? 'selected' : ''}>
                                Galle
                            </option>
                            <option value="Negombo"
                                ${car.location == 'Negombo' ? 'selected' : ''}>
                                Negombo
                            </option>
                            <option value="Matara"
                                ${car.location == 'Matara' ? 'selected' : ''}>
                                Matara
                            </option>
                            <option value="Jaffna"
                                ${car.location == 'Jaffna' ? 'selected' : ''}>
                                Jaffna
                            </option>
                            <option value="Kurunegala"
                                ${car.location == 'Kurunegala' ? 'selected' : ''}>
                                Kurunegala
                            </option>
                            <option value="Other"
                                ${car.location == 'Other' ? 'selected' : ''}>
                                Other
                            </option>
                        </select>
                    </div>
                </div>

                <!-- Description -->
                <p class="section-title mt-4">
                    Description
                </p>

                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        Car Description
                    </label>
                    <textarea name="description"
                              class="form-control"
                              rows="4"
                              placeholder="Describe your car..."><c:out value="${not empty car ? car.description : ''}"/></textarea>
                </div>

                <!-- Image Upload -->
                <p class="section-title mt-4">Car Image</p>

                <!-- Show existing image when editing -->
                <c:if test="${not empty car and not empty car.imagePath
                        and car.imagePath != 'default-car.png'}">
                    <div class="mb-3">
                        <p class="text-muted"
                           style="font-size:13px;">
                            Current image:
                        </p>
                        <img src="/uploads/cars/${car.imagePath}"
                             style="width:100%;
                                    max-height:200px;
                                    object-fit:cover;
                                    border-radius:12px;">
                        <p class="text-muted mt-2"
                           style="font-size:12px;">
                            Upload a new image below
                            to replace the current one
                        </p>
                    </div>
                </c:if>

                <div class="mb-4">
                    <div class="image-upload-box">
                        <div id="uploadPrompt">
                            <p style="font-size:40px;
                                      margin:0;">📷</p>
                            <p class="fw-semibold mb-1">
                                ${not empty car ? 'Upload New Photo (optional)' : 'Upload Car Photo'}
                            </p>
                            <p class="text-muted mb-3"
                               style="font-size:13px;">
                                JPG, PNG or JPEG · Max 10MB
                            </p>
                            <input type="file"
                                   name="carImage"
                                   class="form-control"
                                   accept="image/*"
                                   onchange="previewImage(this)">
                        </div>
                        <img id="previewImg"
                             style="display:none;"
                             src="" alt="Preview">
                    </div>
                </div>

                <!-- Hidden seller ID only for new car -->
                <c:if test="${empty car}">
                    <input type="hidden" name="sellerId"
                           value="<%= session.getAttribute("userId") %>">
                </c:if>

                <div class="d-flex gap-2">
                    <button type="submit"
                            class="btn btn-post">
                        ${not empty car ? '💾 Update Car' : '🚗 Post My Car'}
                    </button>
                    <c:if test="${not empty car}">
                        <a href="/my-listings"
                           class="btn btn-outline-secondary"
                           style="width:100%;
                                  border-radius:8px;">
                            Cancel
                        </a>
                    </c:if>
                </div>

            </form>
        </div>
    </div>
</div>

<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var preview =
                    document.getElementById('previewImg');
                preview.src = e.target.result;
                preview.style.display = 'block';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>