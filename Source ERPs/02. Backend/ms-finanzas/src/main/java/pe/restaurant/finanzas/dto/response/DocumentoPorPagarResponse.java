package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoPorPagarResponse {

    private Long id;

    private String tipoDocumento;

    private String numeroDocumento;

    private LocalDate fecha;

    private BigDecimal montoOriginal;

    private BigDecimal montoLiquidado;

    private BigDecimal saldo;

    private String tipoSaldo;

    private Long proveedorId;

    private String proveedorRazonSocial;

    private String flagEstado;

    private String observacion;
}
