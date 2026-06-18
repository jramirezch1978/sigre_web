package pe.restaurant.activos.dto.reporte;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfReporteLibroLineaResponse {
    private Long afMaestroId;
    private String codigo;
    private String nombre;
    private Long afSubClaseId;
    private Long afUbicacionId;
    private Long centroCostoId;
    private LocalDate fechaAdquisicion;
    private BigDecimal valorAdquisicion;
    private BigDecimal depreciacionAcumulada;
    private BigDecimal valorNeto;
    private String flagEstado;
    private String estadoActivo;

    /** HU-AF-REP-001: descripción legible clase / subclase. */
    private String claseSubclase;
    /** HU-AF-REP-001: ubicación física (código — nombre). */
    private String ubicacionFisica;
    /** Primera depreciación registrada o fecha de adquisición si no hay cálculo. */
    private LocalDate fechaInicioDepreciacion;
    /** Código moneda (ej. PEN). */
    private String moneda;
    /** Centro de costo (código — descripción). */
    private String centroCosto;
}
