package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.CarDAO;
import com.carplatform.Second_Hand_Car_sales.dao.FavouriteDAO;
import com.carplatform.Second_Hand_Car_sales.model.Car;
import com.carplatform.Second_Hand_Car_sales.model.Favourite;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.List;


@Controller
public class FavouriteServlet {

    private FavouriteDAO favouriteDAO = new FavouriteDAO();
    private CarDAO carDAO = new CarDAO();


    @GetMapping("/search")
    public String search(Model model) {
        List<Car> cars = carDAO.getAllCars();
        model.addAttribute("carList", cars);
        return "search";
    }


    @GetMapping("/results")
    public String results(Model model) {
        List<Car> cars = carDAO.getAllCars();
        model.addAttribute("carList", cars);
        return "results";
    }


    @GetMapping("/searchCars")
    public String searchCars(
            @RequestParam(required = false) String brand,
            @RequestParam(required = false,
                    defaultValue = "0") double minPrice,
            @RequestParam(required = false,
                    defaultValue = "0") double maxPrice,
            @RequestParam(required = false) String fuelType,
            @RequestParam(required = false)
            String transmission,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String sortBy,
            Model model) {


        List<Car> cars = carDAO.searchCars(
                brand, minPrice, maxPrice,
                fuelType, transmission, location, sortBy);
        model.addAttribute("carList", cars);
        return "results";
    }


    @PostMapping("/addFavourite")
    public String addFavourite(
            @RequestParam int carId,
            HttpSession session) {


        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        Object userIdObj = session.getAttribute("userId");
        int userId = userIdObj instanceof Integer
                ? (Integer) userIdObj
                : Integer.parseInt(userIdObj.toString());

        favouriteDAO.addFavourite(userId, carId);
        return "redirect:/carDetail?id=" + carId;
    }


    @PostMapping("/removeFavourite")
    public String removeFavourite(
            @RequestParam int carId,
            HttpSession session) {


        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        Object userIdObj = session.getAttribute("userId");
        int userId = userIdObj instanceof Integer
                ? (Integer) userIdObj
                : Integer.parseInt(userIdObj.toString());

        favouriteDAO.removeFavourite(userId, carId);
        return "redirect:/carDetail?id=" + carId;
    }


    @GetMapping("/favourites")
    public String viewFavourites(
            HttpSession session,
            Model model) {


        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }

        Object userIdObj = session.getAttribute("userId");
        int userId = userIdObj instanceof Integer
                ? (Integer) userIdObj
                : Integer.parseInt(userIdObj.toString());

        List<Favourite> favourites =
                favouriteDAO.getFavouritesByUser(userId);
        model.addAttribute("favouriteList", favourites);
        return "favourites";
    }
}
