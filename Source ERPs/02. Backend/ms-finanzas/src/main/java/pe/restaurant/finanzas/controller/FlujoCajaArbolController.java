package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.FlujoCajaNodo;
import pe.restaurant.finanzas.service.FlujoCajaArbolService;

import java.util.List;

@RestController
@RequestMapping("/api/finanzas/flujo-caja")
@RequiredArgsConstructor
@Tag(name = "Árbol de Flujo de Caja",
        description = "API unificada para gestionar los 3 niveles como un árbol: ACTIVIDAD → GRUPO → CODIGO")
public class FlujoCajaArbolController {

    private final FlujoCajaArbolService arbolService;

    @Operation(summary = "Obtener árbol completo de flujo de caja",
            description = "Retorna la jerarquía completa: actividades con sus grupos y códigos anidados")
    @GetMapping("/arbol")
    public ApiResponse<List<FlujoCajaNodo>> obtenerArbol() {
        List<FlujoCajaNodo> arbol = arbolService.obtenerArbol();
        return ApiResponse.ok(arbol, "Árbol de flujo de caja obtenido exitosamente");
    }

    @Operation(summary = "Guardar árbol completo de flujo de caja",
            description = "Recibe el árbol completo y realiza reconciliación: crea, actualiza, reordena o elimina nodos según el estado enviado")
    @PutMapping(value = "/arbol", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ApiResponse<List<FlujoCajaNodo>> guardarArbol(
            @Valid @RequestBody List<FlujoCajaNodo> arbolRequest) {
        List<FlujoCajaNodo> arbolActualizado = arbolService.guardarArbol(arbolRequest);
        return ApiResponse.ok(arbolActualizado, "Árbol de flujo de caja guardado exitosamente");
    }
}
