package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RetencionResponse {

    private Long id;
    private Long cntasPagarId;
    private String nroCertificado;
    private LocalDate fechaEmision;
    private Long sucursalId;
    private Long proveedorId;
    private Long nroRegCajaBan;
    private String flagTabla;
    private BigDecimal saldoSol;
    private BigDecimal saldoDol;
    private BigDecimal importeDoc;
    private LocalDate fecPago;
    private BigDecimal tasaCambio;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
