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
public class DevolvibleResponse {

    private Long valeMovId;
    private String nroVale;
    private Long almacenId;
    private Long articuloMovTipoId;
    private LocalDate fechaMov;
    private String tipoMovDevolucion;
    private List<DevolvibleLineaResponse> lineas;
}
