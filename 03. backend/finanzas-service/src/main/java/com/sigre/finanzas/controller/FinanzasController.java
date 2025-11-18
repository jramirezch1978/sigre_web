package com.sigre.finanzas.controller;

import com.sigre.finanzas.model.entity.DocXPagar;
import com.sigre.finanzas.repository.DocXPagarRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@RestController
@RequestMapping
@RequiredArgsConstructor
@Tag(name = "Finanzas", description = "APIs para cuentas por pagar y cobrar")
public class FinanzasController {

    private final DocXPagarRepository docXPagarRepository;

    @GetMapping("/cuentas-pagar/pendientes")
    @Operation(summary = "Obtener documentos por pagar pendientes")
    public ResponseEntity<List<DocXPagar>> obtenerPendientes(
            @RequestParam String empresa,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta) {
        
        log.info("GET /cuentas-pagar/pendientes - Empresa: {}, Hasta: {}", empresa, hasta);
        List<DocXPagar> pendientes = docXPagarRepository.findPendientesPorVencer(empresa, hasta);
        return ResponseEntity.ok(pendientes);
    }

    @GetMapping("/cuentas-pagar/proveedor/{proveedor}")
    @Operation(summary = "Obtener documentos pendientes de un proveedor")
    public ResponseEntity<List<DocXPagar>> obtenerPorProveedor(
            @RequestParam String empresa,
            @PathVariable String proveedor) {
        
        log.info("GET /cuentas-pagar/proveedor/{} - Empresa: {}", proveedor, empresa);
        List<DocXPagar> docs = docXPagarRepository.findPendientesByProveedor(empresa, proveedor);
        return ResponseEntity.ok(docs);
    }
}

