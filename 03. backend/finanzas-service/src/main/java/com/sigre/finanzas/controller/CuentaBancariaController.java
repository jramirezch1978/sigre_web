package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.finanzas.dto.request.CuentaBancariaRequest;
import com.sigre.finanzas.dto.response.CuentaBancariaResponse;
import com.sigre.finanzas.entity.BancoCnta;
import com.sigre.finanzas.mapper.CuentaBancariaMapper;
import com.sigre.finanzas.service.CuentaBancariaService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.response.PageData;

import java.math.BigDecimal;

@RestController
@RequestMapping("/api/finanzas/cuentas-bancarias")
@RequiredArgsConstructor
@Tag(name = "Cuentas Bancarias", description = "Gestión del catálogo de cuentas bancarias")
public class CuentaBancariaController {

    private final CuentaBancariaService service;
    private final CuentaBancariaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CuentaBancariaResponse>> findAll(Pageable pageable) {
        Page<BancoCnta> page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CuentaBancariaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CuentaBancariaResponse> create(@Valid @RequestBody CuentaBancariaRequest request) {
        BancoCnta entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CuentaBancariaResponse> update(@PathVariable Long id,
                                                   @Valid @RequestBody CuentaBancariaRequest request) {
        BancoCnta existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CuentaBancariaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CuentaBancariaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @GetMapping("/{id}/saldo")
    public ApiResponse<BigDecimal> getSaldo(@PathVariable Long id) {
        BigDecimal saldo = service.getSaldoActual(id);
        return ApiResponse.ok(saldo);
    }
}
