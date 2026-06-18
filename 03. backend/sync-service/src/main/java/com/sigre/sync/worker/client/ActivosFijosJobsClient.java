package com.sigre.sync.worker.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import com.sigre.common.dto.ApiResponse;
import com.sigre.sync.worker.client.dto.ActivosDepreciacionJobRequest;
import com.sigre.sync.worker.client.dto.ActivosJobEjecucionResponse;
import com.sigre.sync.worker.config.ActivosJobsFeignConfig;

@FeignClient(
        name = "activo-fijo-service",
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
