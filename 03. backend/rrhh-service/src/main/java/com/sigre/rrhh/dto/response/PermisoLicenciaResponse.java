package com.sigre.rrhh.dto.response;

import lombok.Data;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

@Data
public class PermisoLicenciaResponse {

    /** Identificador de la cabecera ({@code permiso_licencia.id}). */
    private Long id;
    private Long trabajadorId;
    /** Cabecera: concepto de planilla. */
    private Long conceptoPlanillaId;
    /** Cabecera: periodo laboral y saldo. */
    private Integer periodoInicio;
    private Integer periodoFin;
    private Integer diasTotales;
    private Integer diasGozados;
    /** Detalle: tipo RTPS del primer tramo (conveniencia API). */
    private Long tipoSuspensionLaboralId;
    /** Detalle: fechas/días del primer tramo (conveniencia API). */
    private LocalDate fechaSolicitud;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer dias;
    private String sustento;
    private String flagEstado;
    /** Tramos completos del permiso (cabecera + detalle). */
    private List<PermisoLicenciaDetResponse> detalles;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
