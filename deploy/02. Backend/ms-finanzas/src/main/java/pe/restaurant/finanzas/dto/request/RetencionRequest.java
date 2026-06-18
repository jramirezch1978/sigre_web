package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RetencionRequest {

    private Long cntasPagarId;

    @Size(max = 15, message = "El número de certificado no puede exceder 15 caracteres")
    private String nroCertificado;

    private LocalDate fechaEmision;

    @NotNull(message = "El proveedor es obligatorio")
    private Long proveedorId;

    @NotNull(message = "El importe del documento es obligatorio")
    @Positive(message = "El importe debe ser mayor a cero")
    private BigDecimal importeDoc;

    private BigDecimal saldoSol = BigDecimal.ZERO;
    private BigDecimal saldoDol = BigDecimal.ZERO;

    @NotNull(message = "El movimiento de caja/bancos es obligatorio")
    private Long nroRegCajaBan;

    private LocalDate fecPago;
}
