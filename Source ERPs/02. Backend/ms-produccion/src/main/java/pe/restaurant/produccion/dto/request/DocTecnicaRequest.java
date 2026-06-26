package pe.restaurant.produccion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocTecnicaRequest {

    @NotNull(message = "El artículo es requerido")
    private Long articuloId;

    @NotNull(message = "El tipo de documento es requerido")
    private Long docTipoId;

    @NotBlank(message = "El nombre del documento es requerido")
    @Size(max = 200, message = "El nombre no debe exceder 200 caracteres")
    private String nombreDocumento;

    @Size(max = 10, message = "La extensión no debe exceder 10 caracteres")
    private String documentoExtension;

    @Size(max = 3000, message = "La URL no debe exceder 3000 caracteres")
    private String archivoUrl;

    @Size(max = 3000, message = "La observación no debe exceder 3000 caracteres")
    private String observacion;

    @Valid
    private List<CaractDetRequest> caracteristicas;
}
