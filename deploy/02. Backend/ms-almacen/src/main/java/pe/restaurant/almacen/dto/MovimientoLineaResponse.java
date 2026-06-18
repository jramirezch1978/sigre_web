package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MovimientoLineaResponse {

    private Long id;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private BigDecimal cantProcesada;
    private BigDecimal costoUnitario;
    private Long matrizContableId;
    private Long lotePalletId;
    private Long ubicacionAlmacenId;
    private Long centrosCostoId;
    private Long monedaId;
    private BigDecimal pesoNetoTm;
    private BigDecimal precioUnitAnt;
    private String flagEstado;
    private Long ocDetId;
    private Long ordenTrasladoDetId;
    private Long ordenVentaDetId;
    private Long operacionesDetId;
    private Long createdBy;
    private UsuarioResumenDto createdByUsuario;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private UsuarioResumenDto updatedByUsuario;
    private OffsetDateTime fecModificacion;
}
