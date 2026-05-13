package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.CarDAO;
import com.carplatform.Second_Hand_Car_sales.dao.UserDAO;
import com.carplatform.Second_Hand_Car_sales.model.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
public class UserServlet {

    private UserDAO userDAO = new UserDAO();


    @PostMapping("/register")
    public String registerUser(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String phone,
            @RequestParam String role,
            Model model) {


        if (!password.equals(confirmPassword)) {
            model.addAttribute("error",
                    "Passwords do not match!");
            return "register";
        }


        if (userDAO.emailExists(email)) {
            model.addAttribute("error",
                    "Email already registered!");
            return "register";
        }


        User user;
        if (role.equals("BUYER")) {
            user = new Buyer(fullName, email, password, phone);
        } else {
            user = new Seller(fullName, email, password, phone);
        }

        boolean success = userDAO.registerUser(user);
        if (success) {
            model.addAttribute("success",
                    "Account created successfully! Please login.");
            return "login";
        } else {
            model.addAttribute("error",
                    "Registration failed! Please try again.");
            return "register";
        }
    }


    @PostMapping("/login")
    public String loginUser(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            // Store user details in session for use across pages
            session.setAttribute("userId",
                    Integer.valueOf(user.getId()));
            session.setAttribute("userName",
                    user.getFullName());
            session.setAttribute("userEmail",
                    user.getEmail());
            session.setAttribute("userPhone",
                    user.getPhone());
            session.setAttribute("userRole",
                    user.getRole());

            // Redirect based on role (Polymorphism via getDashboardUrl)
            if (user.getRole().equals("ADMIN")) {
                return "redirect:/dashboard";
            } else {
                return "redirect:/car-list";
            }
        } else {
            model.addAttribute("error",
                    "Invalid email or password!");
            return "login";
        }
    }


    @GetMapping("/my-listings")
    public String myListings(
            HttpSession session,
            Model model) {

        // Session guard — must be logged in
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        // Role guard — must be a SELLER
        if (!"SELLER".equals(
                session.getAttribute("userRole"))) {
            return "redirect:/car-list";
        }

        Object userIdObj = session.getAttribute("userId");
        int userId = userIdObj instanceof Integer
                ? (Integer) userIdObj
                : Integer.parseInt(userIdObj.toString());

        CarDAO carDAO = new CarDAO();
        List<Car> listings = carDAO.getCarsBySeller(userId);
        model.addAttribute("myListings", listings);
        return "my-listings";
    }


    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam int id,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam(required = false) String password,
            HttpSession session,
            Model model) {

        User user = userDAO.getUserById(id);
        if (user != null) {
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);

            boolean updated = userDAO.updateUser(user);

            // Update password separately if provided
            if (password != null && !password.isEmpty()) {
                userDAO.updatePassword(id, password);
            }

            if (updated) {
                // Refresh session so navbar shows updated name
                session.setAttribute("userName", fullName);
                session.setAttribute("userEmail", email);
                session.setAttribute("userPhone", phone);
                model.addAttribute("success",
                        "Profile updated successfully!");
            } else {
                model.addAttribute("error",
                        "Update failed! Please try again.");
            }
        }
        return "profile";
    }


    @PostMapping("/deleteAccount")
    public String deleteAccount(
            @RequestParam int id,
            HttpSession session) {

        userDAO.deleteUser(id);
        session.invalidate();
        return "redirect:/login";
    }


    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
