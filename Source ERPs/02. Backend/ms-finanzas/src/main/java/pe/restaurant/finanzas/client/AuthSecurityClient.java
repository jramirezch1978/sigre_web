package pe.restaurant.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.finanzas.dto.response.PermisosMenuRolesResponse;
import pe.restaurant.finanzas.dto.response.UsuarioResponse;
import pe.restaurant.common.dto.ApiResponse;

@FeignClient(
    name = "ms-auth-security",
    url = "${api.gateway.url}",
    path = "/api/auth",
    configuration = pe.restaurant.finanzas.config.FeignConfig.class
)
public interface AuthSecurityClient {
    
    @GetMapping("/usuarios/{id}")
    ApiResponse<UsuarioResponse> obtenerUsuarioPorId(@PathVariable("id") Long id);

    /**
     * Solo lectura: consulta los permisos (roles + opciones de menú con acciones) que el
     * usuario YA tiene en la empresa. No crea ni modifica nada en el RBAC; se usa para
     * autorizar acciones de cierre reutilizando el mismo endpoint que consume el front.
     */
    @GetMapping("/seguridad/empresas/{empresaId}/usuarios/{usuarioId}/permisos-menu-roles")
    ApiResponse<PermisosMenuRolesResponse> obtenerPermisosMenuRoles(
            @PathVariable("empresaId") Long empresaId,
            @PathVariable("usuarioId") Long usuarioId);
}
