package pe.restaurant.worker.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.worker.client.dto.ActivosDepreciacionJobRequest;
import pe.restaurant.worker.client.dto.ActivosJobEjecucionResponse;
import pe.restaurant.worker.config.ActivosJobsFeignConfig;

@FeignClient(
        name = "ms-activos-fijos-jobs",
        url = "${app.activos-jobs.base-url:http://localhost:9008}",
        configuration = ActivosJobsFeignConfig.class
)
public interface ActivosFijosJobsClient {

    @PostMapping("/api/activos/jobs/depreciacion-masiva")
    ApiResponse<ActivosJobEjecucionResponse> depreciacionMasiva(
            @RequestBody ActivosDepreciacionJobRequest request,
            @RequestParam("contabilizar") boolean contabilizar);

    @PostMapping("/api/activos/jobs/devengo-prima-masivo")
    ApiResponse<ActivosJobEjecucionResponse> devengoPrimaMasivo(
            @RequestParam("anio") Integer anio,
            @RequestParam("mes") Integer mes,
            @RequestParam("contabilizar") boolean contabilizar);
}
