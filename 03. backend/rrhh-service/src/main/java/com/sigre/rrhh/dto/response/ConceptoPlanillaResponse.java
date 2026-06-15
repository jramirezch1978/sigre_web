package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

/**
 * DTO de respuesta para un concepto de planilla.
 * Incluye todos los campos de la entidad más los campos de auditoría.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoPlanillaResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String tipo;
    private String formula;
    private BigDecimal valorFijo;
    private Boolean afectoQuinta;
    private Boolean afectoEssalud;
    private Boolean aplicaTodos;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
