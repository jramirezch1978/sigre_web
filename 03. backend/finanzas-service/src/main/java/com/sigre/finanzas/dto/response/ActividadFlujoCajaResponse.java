package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActividadFlujoCajaResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private Integer orden;
    private String flagTipoFlujo;
    private String flagEstado;
    private Boolean activo;
    private String createdBy;
    private String fecCreacion;
    private String updatedBy;
    private String fecModificacion;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
