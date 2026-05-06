package com.carplatform.Second_Hand_Car_sales;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(
            ResourceHandlerRegistry registry) {

        // Handle uploaded car images
        Path uploadDir = Paths.get("uploads/cars/");
        String uploadPath = uploadDir.toFile()
                .getAbsolutePath();

        registry.addResourceHandler("/uploads/cars/**")
                .addResourceLocations(
                        "file:" + uploadPath + "/");

        // Handle static resources
        registry.addResourceHandler("/static/**")
                .addResourceLocations(
                        "classpath:/static/");
    }
}