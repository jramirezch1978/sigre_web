package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.seguridad.dto.ConsultaRucDto;
import com.sigre.seguridad.service.SunatRucService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth/seguridad/ruc")
@RequiredArgsConstructor
public class ConsultaRucController {

    private final SunatRucService sunatRucService;

    @GetMapping("/{ruc}")
    public ApiResponse<ConsultaRucDto> consultar(@PathVariable String ruc) {
        return ApiResponse.ok(sunatRucService.consultar(ruc), "Consulta RUC exitosa");
    }
}
