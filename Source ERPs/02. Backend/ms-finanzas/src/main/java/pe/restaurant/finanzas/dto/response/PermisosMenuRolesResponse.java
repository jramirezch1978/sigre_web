package pe.restaurant.finanzas.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.util.List;

/**
 * Vista mínima de la respuesta de
 * {@code GET /api/auth/seguridad/empresas/{empresaId}/usuarios/{usuarioId}/permisos-menu-roles}.
 * Solo se mapean los campos necesarios para autorizar acciones (rol admin y
 * acciones permitidas por opción de menú); el resto se ignora.
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class PermisosMenuRolesResponse {

    private List<Rol> roles;
    private List<OpcionMenuPermiso> opcionesMenu;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Rol {
        private String codigo;
        private Boolean esAdmin;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class OpcionMenuPermiso {
        private OpcionMenu opcionMenu;
        private List<AccionPermiso> acciones;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class OpcionMenu {
        private String codigo;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class AccionPermiso {
        private Accion accion;
        private Boolean permitido;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Accion {
        private String codigo;
    }
}
