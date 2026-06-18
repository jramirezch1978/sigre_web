package pe.restaurant.rrhh.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;
import java.util.List;

@Data
public class AsistenciaImportRequest {
    @Valid @NotEmpty
    private List<AsistenciaRequest> registros;
}
