package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConfigSucursalSaveRequest {
    @NotNull
    private Long empresaId;
    @NotNull
    private Long sucursalId;
    @NotNull
    private Map<String, Object> valores;
}
