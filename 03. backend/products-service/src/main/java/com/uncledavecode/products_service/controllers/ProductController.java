package com.uncledavecode.products_service.controllers;

import com.uncledavecode.products_service.model.dtos.ProductRequest;
import com.uncledavecode.products_service.model.dtos.ProductResponse;
import com.uncledavecode.products_service.services.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
// import org.springframework.security.access.prepost.PreAuthorize; // Seguridad deshabilitada
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    // @PreAuthorize("hasRole('ROLE_ADMIN')") // Seguridad deshabilitada
    public void addProduct(@RequestBody ProductRequest productRequest) {
        this.productService.addProduct(productRequest);
    }

    // AGREGAR ESTOS ENDPOINTS PARA MANEJAR AMBAS RUTAS
    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    // @PreAuthorize("hasRole('ROLE_USER')") // Seguridad deshabilitada
    public List<ProductResponse> getAllProducts() {
        return this.productService.getAllProducts();
    }

    @GetMapping("/")
    @ResponseStatus(HttpStatus.OK)
    // @PreAuthorize("hasRole('ROLE_USER')") // Seguridad deshabilitada
    public List<ProductResponse> getAllProductsWithSlash() {
        return this.productService.getAllProducts();
    }

    // ENDPOINT DE PRUEBA PÚBLICO
    @GetMapping("/health")
    @ResponseStatus(HttpStatus.OK)
    public String health() {
        return "Products Service is UP!";
    }
}