package com.carplatform.Second_Hand_Car_sales.servlet;

import com.carplatform.Second_Hand_Car_sales.dao.CarDAO;
import com.carplatform.Second_Hand_Car_sales.model.Car;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;


@Controller
public class CarServlet {

    private CarDAO carDAO = new CarDAO();


    @GetMapping("/car-list")
    public String carList(Model model) {
        List<Car> cars = carDAO.getAllCars();
        model.addAttribute("carList", cars);
        return "car-list";
    }


    @GetMapping("/carDetail")
    public String carDetail(
            @RequestParam int id,
            Model model) {
        Car car = carDAO.getCarById(id);
        model.addAttribute("car", car);
        return "car-detail";
    }


    @PostMapping("/addCar")
    public String addCar(
            @RequestParam String brand,
            @RequestParam("model") String carModel,
            @RequestParam int year,
            @RequestParam int mileage,
            @RequestParam String fuelType,
            @RequestParam String transmission,
            @RequestParam double price,
            @RequestParam String location,
            @RequestParam String description,
            @RequestParam int sellerId,
            @RequestParam(required = false)
            MultipartFile carImage,
            HttpSession session,
            Model model) {


        String role = (String) session
                .getAttribute("userRole");
        if (role == null || !role.equals("SELLER")) {
            model.addAttribute("error",
                    "Only sellers can post cars!");
            List<Car> cars = carDAO.getAllCars();
            model.addAttribute("carList", cars);
            return "car-list";
        }

        String imagePath = "default-car.png";
        if (carImage != null && !carImage.isEmpty()) {
            try {
                String projectDir =
                        System.getProperty("user.dir");
                String uploadDir =
                        projectDir + "/uploads/cars/";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                String fileName =
                        System.currentTimeMillis() + "_"
                                + carImage.getOriginalFilename()
                                .replaceAll("\\s+", "_");
                Path filePath =
                        Paths.get(uploadDir + fileName);
                Files.write(filePath, carImage.getBytes());
                imagePath = fileName;
                System.out.println("Image saved: "
                        + filePath.toString());
            } catch (IOException e) {
                System.out.println("Image upload error: "
                        + e.getMessage());
            }
        }

        Car car = new Car(brand, carModel, year,
                mileage, fuelType, transmission,
                price, location, description, sellerId);
        car.setImagePath(imagePath);

        boolean success = carDAO.addCar(car);
        if (success) {
            model.addAttribute("success",
                    "Car listed successfully!");
            List<Car> cars = carDAO.getAllCars();
            model.addAttribute("carList", cars);
            return "car-list";
        } else {
            model.addAttribute("error",
                    "Failed to add car! Please try again.");
            return "car-add";
        }
    }


    @GetMapping("/editCar")
    public String editCar(
            @RequestParam int id,
            Model model) {
        Car car = carDAO.getCarById(id);
        model.addAttribute("car", car);
        return "car-add";
    }


    @PostMapping("/updateCar")
    public String updateCar(
            @RequestParam int id,
            @RequestParam String brand,
            @RequestParam("model") String carModel,
            @RequestParam int year,
            @RequestParam int mileage,
            @RequestParam String fuelType,
            @RequestParam String transmission,
            @RequestParam double price,
            @RequestParam String location,
            @RequestParam String description,
            @RequestParam(required = false)
            MultipartFile carImage,
            HttpSession session,
            Model model) {

        Car car = carDAO.getCarById(id);
        if (car != null) {
            car.setBrand(brand);
            car.setModel(carModel);
            car.setYear(year);
            car.setMileage(mileage);
            car.setFuelType(fuelType);
            car.setTransmission(transmission);
            car.setPrice(price);
            car.setLocation(location);
            car.setDescription(description);


            if (carImage != null && !carImage.isEmpty()) {
                try {
                    String projectDir =
                            System.getProperty("user.dir");
                    String uploadDir =
                            projectDir + "/uploads/cars/";
                    File dir = new File(uploadDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    String fileName =
                            System.currentTimeMillis() + "_"
                                    + carImage.getOriginalFilename()
                                    .replaceAll("\\s+", "_");
                    Path filePath =
                            Paths.get(uploadDir + fileName);
                    Files.write(filePath,
                            carImage.getBytes());
                    car.setImagePath(fileName);
                } catch (IOException e) {
                    System.out.println("Image error: "
                            + e.getMessage());
                }
            }

            carDAO.updateCar(car);
        }


        String role = (String) session
                .getAttribute("userRole");
        if ("ADMIN".equals(role)) {
            List<Car> cars = carDAO.getAllCars();
            model.addAttribute("carList", cars);
            return "car-list";
        }
        return "redirect:/my-listings";
    }


    @PostMapping("/deleteCar")
    public String deleteCar(
            @RequestParam int carId,
            HttpSession session,
            Model model) {
        carDAO.deleteCar(carId);
        String role = (String) session
                .getAttribute("userRole");
        if ("ADMIN".equals(role)) {
            List<Car> cars = carDAO.getAllCars();
            model.addAttribute("carList", cars);
            return "car-list";
        }
        return "redirect:/my-listings";
    }


    @PostMapping("/markSold")
    public String markSold(
            @RequestParam int carId,
            HttpSession session) {
        carDAO.markAsSold(carId);
        String role = (String) session
                .getAttribute("userRole");
        if ("ADMIN".equals(role)) {
            return "redirect:/manage-listings";
        }
        return "redirect:/my-listings";
    }


}
