package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConfigResolverContext {
    private Long empresaId;
    private Long paisId;
    private Long sucursalId;
    private Long usuarioId;
}
