package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class IntegracionSalidaOvRequest {

    private Long ordenVentaId;
    private Long articuloMovTipoId;
    private Long almacenId;
    private LocalDate fechaMov;
    private String observaciones;
}
