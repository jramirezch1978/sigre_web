package pe.restaurant.auth.controller.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.auth.dto.PageData;
import pe.restaurant.auth.entity.UsuarioOpcionMenu;
import pe.restaurant.auth.service.SeguridadService;
import pe.restaurant.auth.service.crud.UsuarioOpcionMenuCrudService;
import pe.restaurant.auth.support.SeguridadContextHelper;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/auth/usuario-opcion-menu")
@RequiredArgsConstructor
public class UsuarioOpcionMenuCrudController {

    private final UsuarioOpcionMenuCrudService service;
    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;

    @GetMapping
    public ApiResponse<PageData<UsuarioOpcionMenu>> listar(@RequestHeader("Authorization") String auth, Pageable pageable) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(PageData.of(service.listar(pageable)));
    }

    @GetMapping("/{id}")
    public ApiResponse<UsuarioOpcionMenu> obtener(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    public ApiResponse<UsuarioOpcionMenu> crear(@RequestHeader("Authorization") String auth, @RequestBody UsuarioOpcionMenu body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.crear(body), "UsuarioOpcionMenu creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<UsuarioOpcionMenu> actualizar(@RequestHeader("Authorization") String auth, @PathVariable Long id, @RequestBody UsuarioOpcionMenu body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.actualizar(id, body), "UsuarioOpcionMenu actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> eliminar(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        service.eliminar(id);
        return ApiResponse.ok(null, "UsuarioOpcionMenu eliminado");
    }
}
