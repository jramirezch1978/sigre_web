package com.sigre.almacen.controller;

import com.sigre.almacen.model.entity.Articulo;
import com.sigre.almacen.repository.ArticuloRepository;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Slf4j
@RestController
@RequestMapping
@RequiredArgsConstructor
@Tag(name = "Almacén", description = "APIs para gestión de inventarios")
public class AlmacenController {

    private final ArticuloRepository articuloRepository;

    @GetMapping("/articulos")
    public ResponseEntity<List<Articulo>> obtenerArticulos() {
        log.info("GET /articulos");
        return ResponseEntity.ok(articuloRepository.findByFlagEstado("1"));
    }

    @GetMapping("/articulos/{codigo}")
    public ResponseEntity<Articulo> obtenerArticulo(@PathVariable String codigo) {
        log.info("GET /articulos/{}", codigo);
        return articuloRepository.findById(codigo)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
}

