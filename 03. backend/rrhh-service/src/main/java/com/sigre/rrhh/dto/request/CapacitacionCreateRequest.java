package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CapacitacionCreateRequest {

    @NotBlank @Size(max = 200)
    private String nombre;

    private String descripcion;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer horas;
    private String proveedor;
    private BigDecimal costo;
}
