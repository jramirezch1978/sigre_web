package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionAnualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;

import java.math.BigDecimal;
import java.time.LocalDate;

public interface AfReporteService {

    AfReporteLibroResponse libroActivos(LocalDate fechaCorte, Long afSubClaseId, Long afUbicacionId,
                                        String flagEstado, String estadoActivo, BigDecimal valorMin, BigDecimal valorMax);

    AfReporteDepreciacionAnualResponse depreciacionAnual(Long afMaestroId, Integer anio);

    AfReporteLibroResponse consolidado(LocalDate fechaCorte, Long afClaseId);
}
