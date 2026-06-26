package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CierreCajaResponse {
    private Long id;
    private Long turnoId;
    private BigDecimal ventasEfectivo;
    private BigDecimal ventasTarjeta;
    private BigDecimal ventasDigital;
    private BigDecimal ventasTotal;
    private BigDecimal propinasTotal;
    private BigDecimal fondoInicial;
    private BigDecimal fondoFinal;
    private BigDecimal diferencia;
    private String observaciones;
    private Instant fechaCierre;
    private String estadoCierre;
    private String flagEstado;
}
