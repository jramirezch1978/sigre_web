package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.Instant;

@Data
public class PedidoMesaRequest {

    private Long sucursalId;

    @NotBlank
    private String tipo;

    private Long mesaId;

    private Long meseroId;

    private Long turnoId;

    @NotBlank
    private String numero;

    private Integer comensales;

    private Instant apertura;

    private Instant cierre;

    private String observaciones;
}
