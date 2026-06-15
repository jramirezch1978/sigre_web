package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.ReservacionCancelRequest;
import com.sigre.comercializacion.dto.request.ReservacionRequest;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.dto.response.ReservacionResponse;
import com.sigre.comercializacion.mapper.VentasIssue5DtoMapper;
import com.sigre.comercializacion.service.ReservacionService;

import java.time.LocalDate;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/reservaciones")
@RequiredArgsConstructor
@Tag(name = "Reservaciones", description = "Reservas de mesa con detalle opcional")
public class ReservacionController {

    private final ReservacionService service;
    private final VentasIssue5DtoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar reservaciones")
    public ApiResponse<PageData<ReservacionResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) Long mesaId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta) {
        var page = service.findAll(sucursalId, clienteId, mesaId, estado, fechaDesde, fechaHasta, pageable);
        var content = page.getContent().stream().map(mapper::toReservacionListItem).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener reservación con ítems")
    public ApiResponse<ReservacionResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.getById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear reservación")
    public ApiResponse<ReservacionResponse> create(@Valid @RequestBody ReservacionRequest request) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.create(request)), "Reservación creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar reservación (solo CONFIRMADA)")
    public ApiResponse<ReservacionResponse> update(@PathVariable Long id, @Valid @RequestBody ReservacionRequest request) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.update(id, request)), "Reservación actualizada");
    }

    @PostMapping("/{id}/confirmar")
    @Operation(summary = "Confirmar reservación")
    public ApiResponse<ReservacionResponse> confirmar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.confirmar(id)), "Reservación confirmada");
    }

    @PostMapping("/{id}/cancelar")
    @Operation(summary = "Cancelar reservación")
    public ApiResponse<ReservacionResponse> cancelar(
            @PathVariable Long id,
            @RequestBody(required = false) ReservacionCancelRequest request) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.cancelar(id, request)), "Reservación cancelada");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar registro")
    public ApiResponse<ReservacionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.activar(id)), "Activada");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar registro")
    public ApiResponse<ReservacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toReservacionResponse(service.desactivar(id)), "Desactivada");
    }
}
