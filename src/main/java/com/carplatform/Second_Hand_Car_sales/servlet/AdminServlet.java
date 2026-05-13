package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.AdminDAO;
import com.carplatform.Second_Hand_Car_sales.dao.CarDAO;
import com.carplatform.Second_Hand_Car_sales.dao.InquiryDAO;
import com.carplatform.Second_Hand_Car_sales.dao.ReviewDAO;
import com.carplatform.Second_Hand_Car_sales.model.Car;
import com.carplatform.Second_Hand_Car_sales.model.Review;
import com.carplatform.Second_Hand_Car_sales.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class AdminServlet {

    private AdminDAO adminDAO = new AdminDAO();
    private CarDAO carDAO = new CarDAO();
    private InquiryDAO inquiryDAO = new InquiryDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    @GetMapping("/dashboard")
    public String dashboard(Model model) {

        model.addAttribute("totalUsers",
                adminDAO.countUsers());
        model.addAttribute("totalListings",
                carDAO.countListings());
        model.addAttribute("totalInquiries",
                inquiryDAO.countInquiries());
        model.addAttribute("totalReviews",
                reviewDAO.getAllReviews(null).size());

        model.addAttribute("recentUsers",
                adminDAO.getRecentUsers(5));
        model.addAttribute("recentListings",
                carDAO.getAllCars()
                        .stream().limit(5).toList());

        return "dashboard";
    }

    @GetMapping("/manage-users")
    public String manageUsers(
            @RequestParam(required = false,
                    defaultValue = "") String search,
            @RequestParam(required = false,
                    defaultValue = "") String role,
            @RequestParam(required = false,
                    defaultValue = "") String status,
            Model model) {

        List<User> users;
        if (search.isEmpty() && role.isEmpty()
                && status.isEmpty()) {
            users = adminDAO.getAllUsers();
        } else {
            users = adminDAO.searchUsers(search, role, status);
        }

        model.addAttribute("userList", users);
        model.addAttribute("totalUsers", adminDAO.countUsers());
        return "manage-users";
    }

    @GetMapping("/manage-listings")
    public String manageListings(
            @RequestParam(required = false,
                    defaultValue = "") String brand,
            @RequestParam(required = false,
                    defaultValue = "") String location,
            Model model) {

        List<Car> cars = carDAO.searchCars(
                brand.isEmpty() ? null : brand,
                0, 0,
                null, null,
                location.isEmpty() ? null : location,
                null
        );
        model.addAttribute("carList", cars);
        model.addAttribute("totalListings",
                carDAO.countListings());
        return "manage-listings";
    }


    @GetMapping("/moderation")
    public String moderation(
            @RequestParam(required = false,
                    defaultValue = "all") String filter,
            Model model) {

        List<Review> reviews =
                reviewDAO.getAllReviews(null);

        if (filter.equals("verified")) {
            reviews = reviews.stream()
                    .filter(r -> r.getReviewType()
                            .equals("VERIFIED"))
                    .toList();
        } else if (filter.equals("public")) {
            reviews = reviews.stream()
                    .filter(r -> r.getReviewType()
                            .equals("PUBLIC"))
                    .toList();
        }

        model.addAttribute("reviewList", reviews);
        model.addAttribute("totalReviews",
                reviewDAO.getAllReviews(null).size());
        return "moderation";
    }


    @PostMapping("/suspendUser")
    public String suspendUser(
            @RequestParam int userId) {
        adminDAO.suspendUser(userId);
        return "redirect:/manage-users";
    }

    @PostMapping("/activateUser")
    public String activateUser(
            @RequestParam int userId) {
        adminDAO.activateUser(userId);
        return "redirect:/manage-users";
    }

    @PostMapping("/deleteUser")
    public String deleteUser(
            @RequestParam int userId) {
        adminDAO.deleteUser(userId);
        return "redirect:/manage-users";
    }
}