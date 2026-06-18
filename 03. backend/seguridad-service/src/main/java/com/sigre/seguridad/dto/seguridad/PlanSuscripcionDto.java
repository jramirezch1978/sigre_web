package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlanSuscripcionDto {
    private Long id;
    private String codigo;
    private String nombre;
    private BigDecimal precio;
    private String descripcion;
    private String edicionCodigo;
    private String color;
    private Boolean destacado;
    private Integer diasDemo;
    private Integer maxUsuarios;
    private Integer orden;
    private List<String> caracteristicas;
    private Boolean activo;
}
