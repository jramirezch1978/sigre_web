package pe.restaurant.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class CntaCrrteResponse {
    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private Long docTipoId;
    private String nroDoc;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private Long conceptoPlanillaId;
    private LocalDate fecPrestamo;
    private LocalDate fechaInicioDescuento;
    private Short nroCuotas;
    private BigDecimal montoOriginal;
    private BigDecimal montoCuota;
    private BigDecimal saldoPrestamo;
    private Long monedaId;
    private Long entidadContribuyenteId;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
