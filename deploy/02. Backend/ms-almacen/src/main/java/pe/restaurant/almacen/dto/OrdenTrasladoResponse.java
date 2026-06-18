package pe.restaurant.almacen.dto;

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
public class OrdenTrasladoResponse {
    private Long id;
    private Long almacenOrigenId;
    private Long almacenDestinoId;
    private String numero;
    private LocalDate fecha;
    private String flagEstado;
    private String observacion;
    private Long usuarioId;
    private List<OrdenTrasladoLineaResponse> lineas;
}
