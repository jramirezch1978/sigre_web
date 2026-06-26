package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.DepreciacionMensualRequest;
import pe.restaurant.activos.dto.JobEjecucionResponse;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.service.AfCalculoCntblService;
import pe.restaurant.activos.service.AfPrimaDevengoService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/jobs")
@RequiredArgsConstructor
public class AfJobsController {

    private final AfCalculoCntblService calculoService;
    private final AfPrimaDevengoService primaDevengoService;
    private final ContabilidadIntegracionService contabilidadIntegracionService;

    /**
     * Punto de invocación para ms-worker: depreciación masiva del periodo.
     */
    @PostMapping("/depreciacion-masiva")
    public ApiResponse<JobEjecucionResponse> depreciacionMasiva(
            @Valid @RequestBody DepreciacionMensualRequest request,
            @RequestParam(defaultValue = "false") boolean contabilizar) {
        var calculos = calculoService.calcularDepreciacionMasiva(request.getAnio(), request.getMes());
        int contabilizados = 0;
        if (contabilizar) {
            for (AfCalculoCntbl c : calculos) {
                try {
                    contabilidadIntegracionService.contabilizarDepreciacion(c.getId());
                    contabilizados++;
                } catch (Exception ignored) {
                    // omitir fallos de contabilización en job masivo
                }
            }
        }
        return ApiResponse.ok(new JobEjecucionResponse(
                "DEPRECIACION_MASIVA",
                request.getAnio(),
                request.getMes(),
                calculos.size(),
                contabilizados));
    }

    /**
     * Punto de invocación para ms-worker: devengo de primas de todas las pólizas vigentes.
     */
    @PostMapping("/devengo-prima-masivo")
    public ApiResponse<JobEjecucionResponse> devengoPrimaMasivo(
            @RequestParam Integer anio,
            @RequestParam Integer mes,
            @RequestParam(defaultValue = "false") boolean contabilizar) {
        var devengos = primaDevengoService.registrarDevengoMasivo(anio, mes);
        int contabilizados = 0;
        if (contabilizar) {
            for (AfPrimaDevengo d : devengos) {
                try {
                    contabilidadIntegracionService.contabilizarDevengoPrima(d.getId());
                    contabilizados++;
                } catch (Exception ignored) {
                    // omitir en masivo
                }
            }
        }
        return ApiResponse.ok(new JobEjecucionResponse(
                "DEVENGO_PRIMA_MASIVO", anio, mes, devengos.size(), contabilizados));
    }
}
