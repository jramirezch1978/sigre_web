package pe.restaurant.core.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProvisionSucursalResponse {

    private Long id;
    private Long empresaId;
    private String codigo;
    private String nombre;
    private String direccion;
    private String ciudad;
    private Long monedaDefultId;
    private Long paisId;
    private Long departamentoId;
    private Long provinciaId;
    private Long distritoId;
    private String ubigeo;
    private String flagEstado;
    private Instant fecCreacion;
    private Instant fecModificacion;
}
