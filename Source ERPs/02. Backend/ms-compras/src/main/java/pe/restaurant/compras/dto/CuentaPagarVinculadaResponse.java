package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaPagarVinculadaResponse {
    private Long id;
    private String codRelacion;
    private String tipoDoc;
    private String nroDoc;
    private LocalDate fecha;
    private BigDecimal montoTotal;
    private String flagEstado;
}
