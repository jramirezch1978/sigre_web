package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;

import java.math.BigDecimal;
import java.time.LocalDate;

public interface AfReporteExportService {

    byte[] exportarLibroActivos(AfReporteLibroResponse data, String formato);

    AfReporteLibroResponse obtenerLibro(LocalDate fechaCorte, Long afSubClaseId, Long afUbicacionId,
                                        String flagEstado, String estadoActivo,
                                        BigDecimal valorMin, BigDecimal valorMax);
}
