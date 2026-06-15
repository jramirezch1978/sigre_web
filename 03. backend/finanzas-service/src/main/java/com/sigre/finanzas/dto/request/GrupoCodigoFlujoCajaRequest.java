package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GrupoCodigoFlujoCajaRequest {

    @NotBlank(message = "El código es obligatorio")
    @Size(max = 20, message = "El código no puede exceder 20 caracteres")
    private String codigo;

    @Size(max = 150, message = "El nombre no puede exceder 150 caracteres")
    private String nombre;

    @Size(max = 1, message = "El flag reporte no puede exceder 1 caracter")
    private String flagReporte;

    @Size(max = 1, message = "El factor no puede exceder 1 caracter")
    private String factor;

    @NotNull(message = "El orden es obligatorio")
    private Integer orden;

    @NotNull(message = "La actividad de flujo de caja es obligatoria")
    private Long actividadFlujoCajaId;

    @Size(max = 1, message = "El flag estado no puede exceder 1 caracter")
    private String flagEstado;
}
