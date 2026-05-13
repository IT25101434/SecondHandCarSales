package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.CarDAO;
import com.carplatform.Second_Hand_Car_sales.dao.InquiryDAO;
import com.carplatform.Second_Hand_Car_sales.model.Car;
import com.carplatform.Second_Hand_Car_sales.model.Inquiry;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class InquiryServlet {

    private InquiryDAO inquiryDAO = new InquiryDAO();
    private CarDAO carDAO = new CarDAO();


    @GetMapping("/inquiry")
    public String showInquiry(
            @RequestParam(required = false)
            Integer carId,
            Model model) {
        if (carId != null) {
            Car car = carDAO.getCarById(carId);
            model.addAttribute("car", car);
        } else {
            model.addAttribute("car", null);
        }
        return "inquiry";
    }


    @PostMapping("/sendInquiry")
    public String sendInquiry(
            @RequestParam int carId,
            @RequestParam int buyerId,
            @RequestParam int sellerId,
            @RequestParam String inquiryType,
            @RequestParam String message,
            @RequestParam(required = false,
                    defaultValue = "0")
            double offerPrice,
            Model model) {

        System.out.println("Sending inquiry - carId: "
                + carId + " buyerId: " + buyerId
                + " sellerId: " + sellerId);

        Inquiry inquiry = new Inquiry(carId, buyerId,
                sellerId, inquiryType,
                message, offerPrice);

        boolean success =
                inquiryDAO.sendInquiry(inquiry);
        Car car = carDAO.getCarById(carId);
        model.addAttribute("car", car);

        if (success) {
            model.addAttribute("success",
                    "Inquiry sent successfully! " +
                            "Check your inbox for replies.");
        } else {
            model.addAttribute("error",
                    "Failed to send inquiry! " +
                            "Please try again.");
        }
        return "inquiry";
    }


    @GetMapping("/inbox")
    public String showInbox(
            @RequestParam(required = false,
                    defaultValue = "received") String tab,
            HttpSession session,
            Model model) {

        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        try {
            Object userIdObj =
                    session.getAttribute("userId");
            int userId;
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else {
                userId = Integer.parseInt(
                        userIdObj.toString());
            }

            String userRole = (String)
                    session.getAttribute("userRole");

            System.out.println("Inbox - userId: "
                    + userId + " role: " + userRole
                    + " tab: " + tab);

            List<Inquiry> inquiries;

            if ("BUYER".equals(userRole)) {
                inquiries = inquiryDAO
                        .getSentInquiries(userId);
            } else if ("SELLER".equals(userRole)) {
                if (tab.equals("sent")) {
                    inquiries = inquiryDAO
                            .getSentInquiries(userId);
                } else {
                    inquiries = inquiryDAO
                            .getReceivedInquiries(userId);
                }
            } else {
                inquiries = inquiryDAO
                        .getAllInquiriesForUser(userId);
            }

            int unreadCount =
                    inquiryDAO.countUnread(userId);
            model.addAttribute("inquiryList",
                    inquiries);
            model.addAttribute("unreadCount",
                    unreadCount);

        } catch (Exception e) {
            System.out.println("Inbox error: "
                    + e.getMessage());
            e.printStackTrace();
            model.addAttribute("inquiryList", null);
            model.addAttribute("unreadCount", 0);
        }

        return "inbox";
    }


    @GetMapping("/negotiation")
    public String showNegotiation(
            @RequestParam(required = false)
            Integer inquiryId,
            HttpSession session,
            Model model) {

        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        if (inquiryId != null) {
            Inquiry inquiry =
                    inquiryDAO.getInquiryById(inquiryId);
            inquiryDAO.markAsRead(inquiryId);
            model.addAttribute("inquiry", inquiry);

            List<Map<String, Object>> replies =
                    inquiryDAO.getReplies(inquiryId);
            model.addAttribute("messages", replies);
        } else {
            model.addAttribute("inquiry", null);
            model.addAttribute("messages", null);
        }
        return "negotiation";
    }


    @PostMapping("/replyInquiry")
    public String replyInquiry(
            @RequestParam int inquiryId,
            @RequestParam String message,
            @RequestParam(required = false,
                    defaultValue = "0")
            double offerPrice,
            HttpSession session,
            Model model) {

        Object userIdObj =
                session.getAttribute("userId");
        int senderId;
        if (userIdObj instanceof Integer) {
            senderId = (Integer) userIdObj;
        } else {
            senderId = Integer.parseInt(
                    userIdObj.toString());
        }

        boolean success = inquiryDAO.saveReply(
                inquiryId, senderId,
                message, offerPrice);

        Inquiry inquiry =
                inquiryDAO.getInquiryById(inquiryId);
        List<Map<String, Object>> replies =
                inquiryDAO.getReplies(inquiryId);

        model.addAttribute("inquiry", inquiry);
        model.addAttribute("messages", replies);

        if (success) {
            model.addAttribute("success",
                    "Reply sent successfully!");
        } else {
            model.addAttribute("error",
                    "Failed to send reply!");
        }
        return "negotiation";
    }


    @PostMapping("/respondOffer")
    public String respondOffer(
            @RequestParam int inquiryId,
            @RequestParam String response) {
        inquiryDAO.updateStatus(inquiryId, response);
        return "redirect:/negotiation?inquiryId="
                + inquiryId;
    }


    @PostMapping("/deleteInquiry")
    public String deleteInquiry(
            @RequestParam int inquiryId) {
        inquiryDAO.deleteInquiry(inquiryId);
        return "redirect:/inbox";
    }
}