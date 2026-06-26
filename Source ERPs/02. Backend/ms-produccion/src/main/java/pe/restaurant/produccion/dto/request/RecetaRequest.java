package pe.restaurant.produccion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecetaRequest {

    @NotNull(message = "El artículo producido es requerido")
    private Long articuloProducidoId;

    @NotBlank(message = "El número de receta es requerido")
    @Size(max = 12, message = "El número de receta no debe exceder 12 caracteres")
    private String nroReceta;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 200, message = "El nombre no debe exceder 200 caracteres")
    private String nombre;

    @NotBlank(message = "El tipo de receta es requerido")
    @Size(max = 1, message = "El tipo de receta debe ser de 1 carácter")
    private String flagTipoReceta;

    private BigDecimal rendimientoEsperado;
    private BigDecimal porcentajeMerma;
    private BigDecimal costoManoObra;
    private BigDecimal costoIndirecto;

    @Valid
    private List<RecetaLaborRequest> labores;

    @Valid
    private List<RecetaConsumibleRequest> consumibles;

    @Valid
    private FichaTecnicaRequest fichaTecnica;
}
