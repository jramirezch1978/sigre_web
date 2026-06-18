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
public class GuiaResponse {
    private Long id;
    private Long sucursalId;
    private String serie;
    private String numero;
    private LocalDate fechaEmision;
    private LocalDate fechaTraslado;
    private Long motivoTrasladoId;
    private Long destinatarioId;
    private String direccionPartida;
    private String direccionLlegada;
    private Long transportistaId;
    private Long valeMovId;
    private String flagEstado;
    private List<GuiaLineaResponse> lineas;
}
