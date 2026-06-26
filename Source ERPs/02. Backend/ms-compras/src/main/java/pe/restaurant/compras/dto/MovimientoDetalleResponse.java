package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MovimientoDetalleResponse {

    private Long id;
    private Long sucursalId;
    private Long almacenId;
    private Long articuloMovTipoId;
    private String nroVale;
    private LocalDate fechaMov;
    private Long proveedorId;
    private String tipoReferenciaOrigen;
    private Long ordenCompraId;
    private String observaciones;
    private Long valeMovOrigId;
    private String flagEstadoCabecera;
    private String flagEstado;
    private List<MovimientoLineaResponse> lineas;
}
