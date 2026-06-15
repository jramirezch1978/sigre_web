package com.sigre.almacen.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sigre.almacen.config.FeignConfig;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.event.PreAsientoEvent;

/**
 * Cliente HTTP almacen-service → contabilidad-service para registrar pre-asientos de inventario
 * (ingreso/consumo y costeo de producción). La emisión es best-effort: si contabilidad-service
 * aún no expone el endpoint, el publisher captura la excepción y solo registra una advertencia.
 */
@FeignClient(
        name = "contabilidad-service-pre-asiento",
        url = "${client.contabilidad-service.url:${api.gateway.url}}",
        path = "/api/contabilidad",
        configuration = FeignConfig.class
)
public interface ContabilidadPreAsientoClient {

    @PostMapping("/integraciones/almacen/pre-asiento")
    ApiResponse<Void> registrarPreAsiento(@RequestBody PreAsientoEvent request);
}
