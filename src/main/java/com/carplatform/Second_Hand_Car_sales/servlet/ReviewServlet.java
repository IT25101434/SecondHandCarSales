package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.ReviewDAO;
import com.carplatform.Second_Hand_Car_sales.dao.UserDAO;
import com.carplatform.Second_Hand_Car_sales.model.Review;
import com.carplatform.Second_Hand_Car_sales.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Controller
public class ReviewServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();
    private UserDAO userDAO = new UserDAO();


    @GetMapping("/add-review")
    public String showAddReview(
            @RequestParam int sellerId,
            Model model) {
        User seller = userDAO.getUserById(sellerId);
        model.addAttribute("seller", seller);
        return "add-review";
    }


    @PostMapping("/submitReview")
    public String submitReview(
            @RequestParam int sellerId,
            @RequestParam int reviewerId,
            @RequestParam int rating,
            @RequestParam String title,
            @RequestParam String reviewText,
            @RequestParam String reviewType,
            @RequestParam String recommend,
            Model model) {

        Review review = new Review(reviewerId, sellerId,
                rating, title, reviewText,
                reviewType, recommend);


        review.setStatus("APPROVED");

        boolean success = reviewDAO.submitReview(review);
        User seller = userDAO.getUserById(sellerId);
        model.addAttribute("seller", seller);

        if (success) {
            model.addAttribute("success",
                    "Review submitted successfully!");
        } else {
            model.addAttribute("error",
                    "Failed to submit review!");
        }
        return "add-review";
    }


    @GetMapping("/reviews")
    public String showReviews(
            @RequestParam int sellerId,
            Model model) {
        User seller = userDAO.getUserById(sellerId);
        List<Review> reviews =
                reviewDAO.getReviewsBySeller(sellerId);
        double avgRating =
                reviewDAO.getAverageRating(sellerId);

        model.addAttribute("seller", seller);
        model.addAttribute("reviewList", reviews);
        model.addAttribute("averageRating", avgRating);
        model.addAttribute("totalReviews",
                reviews.size());
        return "reviews";
    }


    @GetMapping("/editReview")
    public String editReview(
            @RequestParam int id,
            Model model) {
        Review review = reviewDAO.getReviewById(id);
        model.addAttribute("review", review);
        return "add-review";
    }


    @PostMapping("/deleteReview")
    public String deleteReview(
            @RequestParam int reviewId,
            @RequestParam(required = false)
            Integer sellerId) {
        reviewDAO.deleteReview(reviewId);
        if (sellerId != null) {
            return "redirect:/reviews?sellerId="
                    + sellerId;
        }
        return "redirect:/moderation";
    }


    @GetMapping("/top-sellers")
    public String topSellers(Model model) {
        model.addAttribute("topSellers",
                reviewDAO.getTopSellers());
        return "top-sellers";
    }
}
