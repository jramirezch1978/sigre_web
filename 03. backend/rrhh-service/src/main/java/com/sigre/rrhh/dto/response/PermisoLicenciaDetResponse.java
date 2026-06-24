package com.sigre.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class PermisoLicenciaDetResponse {

    private Long id;
    private Integer item;
    private Long tipoSuspensionLaboralId;
    private Long tipoDocIdentidadId;
    private String numeroDocumento;
    private Integer periodoInicio;
    private Integer mesPeriodo;
    private LocalDate fechaSolicitud;
    private LocalDate fechaMovimiento;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private BigDecimal dias;
}
