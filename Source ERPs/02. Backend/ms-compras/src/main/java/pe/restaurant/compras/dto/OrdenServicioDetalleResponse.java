package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenServicioDetalleResponse {

    private Long id;
    private Long sucursalId;
    private String codOrigen;
    private String nroOs;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private String proveedorRuc;
    private String nomVendedor;
    private Long docTipoId;
    private LocalDate fecRegistro;
    private Long monedaId;
    private String monedaCodigo;
    private BigDecimal tipoCambio;
    private Long formaPagoId;
    private String flagReqServ;
    private String flagSolicitaActa;
    private Long ordenTrabajoId;
    private Long bancoId;
    private String nroCuenta;
    private BigDecimal montoTotal;
    private String descripcion;
    private String flagEstado;
    private Long compradorId;
    private String compradorNombre;
    private Long aprobadorId;
    private String aprobadorNombre;
    private LocalDateTime fechaAprob;
    private String motivoAnulacion;
    private List<OrdenServicioLineaResponse> lineas;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
