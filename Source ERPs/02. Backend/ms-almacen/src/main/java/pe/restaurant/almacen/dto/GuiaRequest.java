package pe.restaurant.almacen.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class GuiaRequest {
    @NotNull
    private Long sucursalId;
    @NotBlank
    private String serie;
    @NotBlank
    private String numero;
    @NotNull
    private LocalDate fechaEmision;
    private LocalDate fechaTraslado;
    private Long motivoTrasladoId;
    @NotNull
    private Long destinatarioId;
    private String direccionPartida;
    private String direccionLlegada;
    private Long transportistaId;
    private Long valeMovId;
    @NotEmpty
    @Valid
    private List<GuiaLineaRequest> lineas;
}
