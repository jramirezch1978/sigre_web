package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfPolizaActivoResponse {

    private Long id;
    private Long afPolizaSeguroId;
    private Long afMaestroId;
    private BigDecimal valorAsegurado;
    private String flagEstado;
}
