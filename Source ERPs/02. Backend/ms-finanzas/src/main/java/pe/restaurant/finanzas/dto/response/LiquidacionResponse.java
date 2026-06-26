package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionResponse {

    private Long id;

    private Long solicitudGiroId;

    private String nroLiquidacion;

    private Long sucursalId;

    private Long docTipoId;

    private String docTipoCodigo;

    private Long proveedorId;

    private String proveedorRazonSocial;

    private String proveedorNroDocumento;

    private LocalDate fechaRegistro;

    private LocalDate fechaLiquidacion;

    private String tipoLiquidacion;

    private Long monedaId;

    private String monedaCodigo;

    private Long conceptoFinancieroId;

    private BigDecimal importeNeto;

    private BigDecimal saldo;

    private BigDecimal tasaCambio;

    private Integer anio;

    private Integer mes;

    private Long cntblLibroId;

    private Long cntblAsientoId;

    private Long usuarioId;

    private String observacion;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
