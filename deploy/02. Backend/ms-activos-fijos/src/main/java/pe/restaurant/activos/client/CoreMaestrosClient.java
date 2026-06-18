package pe.restaurant.activos.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.activos.dto.EntidadContribuyenteResponse;
import pe.restaurant.activos.dto.SucursalResponse;
import pe.restaurant.common.dto.ApiResponse;

@FeignClient(
    name = "ms-core-maestros",
    url = "${feign.client.config.ms-core-maestros.url:http://localhost:9002}",
    path = "/api/core",
    configuration = pe.restaurant.activos.config.FeignConfig.class
)
public interface CoreMaestrosClient {
    
    // ========================================
    // SUCURSALES
    // ========================================
    @GetMapping("/sucursales/{id}")
    ApiResponse<SucursalResponse> obtenerSucursalPorId(@PathVariable("id") Long id);
    
    // ========================================
    // ENTIDADES CONTRIBUYENTES
    // ========================================
    @GetMapping("/relaciones-comerciales/{id}")
    ApiResponse<EntidadContribuyenteResponse> obtenerEntidadPorId(@PathVariable("id") Long id);
}
