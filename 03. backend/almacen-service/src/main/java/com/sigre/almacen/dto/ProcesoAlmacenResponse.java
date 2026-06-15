package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProcesoAlmacenResponse {
    /** Registros o filas afectadas por el proceso batch. */
    private int procesados;
    /** Registros evaluados antes de aplicar cambios. */
    private Integer registrosEsperados;
    /** true cuando el resultado coincide con la validación esperada del proceso. */
    private Boolean validacionOk;
    /** Detalle de validación para auditoría operativa. */
    private String detalleValidacion;
    private String mensaje;
    private String codigoMenu;
}
