package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenResponse {

    private Long id;
    private Long sucursalId;
    private String sucursalNombre;
    private Long almacenTipoId;
    private String almacenTipoNombre;
    private String codigo;
    private String nombre;
    private String flagEstado;
    private Long createdBy;
    private UsuarioResumenDto createdByUsuario;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private UsuarioResumenDto updatedByUsuario;
    private OffsetDateTime fecModificacion;
}
