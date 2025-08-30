package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.RacionResponse;
import com.sigre.asistencia.dto.RacionSelectionRequest;
import com.sigre.asistencia.service.RacionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/raciones")
@RequiredArgsConstructor
public class RacionController {

    private final RacionService racionService;

    @GetMapping("/disponibles")
    public ResponseEntity<List<RacionResponse>> getRacionesDisponibles() {
        List<RacionResponse> raciones = racionService.getRacionesDisponibles();
        return ResponseEntity.ok(raciones);
    }

    @PostMapping("/seleccionar")
    public ResponseEntity<String> seleccionarRacion(@RequestBody RacionSelectionRequest request) {
        String resultado = racionService.seleccionarRacion(request);
        return ResponseEntity.ok(resultado);
    }

    @GetMapping("/horario-info")
    public ResponseEntity<String> getHorarioInfo() {
        String info = racionService.getHorarioDisponible();
        return ResponseEntity.ok(info);
    }
}
