package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MovimientoListItemResponse {

    private Long id;
    private Long sucursalId;
    private Long almacenId;
    private Long articuloMovTipoId;
    private String nroVale;
    private String tipoReferenciaOrigen;
    private Long ordenCompraId;
    private Long ordenVentaId;
    private LocalDate fechaMov;
    private LocalDate fecProduccion;
    private String flagEstado;
}
