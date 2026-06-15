package com.sigre.rrhh.dto.request;

import lombok.Data;
import java.time.LocalDate;

@Data
public class SancionAmonestacionUpdateRequest {
    private Long tipoSancionId;
    private LocalDate fecha;
    private String motivo;
    private String documento;
    private String flagEstado;
}
