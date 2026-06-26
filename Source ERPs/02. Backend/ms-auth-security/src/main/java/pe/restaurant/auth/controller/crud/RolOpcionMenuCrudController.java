package pe.restaurant.auth.controller.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.auth.dto.PageData;
import pe.restaurant.auth.entity.RolOpcionMenu;
import pe.restaurant.auth.service.SeguridadService;
import pe.restaurant.auth.service.crud.RolOpcionMenuCrudService;
import pe.restaurant.auth.support.SeguridadContextHelper;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/auth/rol-opcion-menu")
@RequiredArgsConstructor
public class RolOpcionMenuCrudController {

    private final RolOpcionMenuCrudService service;
    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;

    @GetMapping
    public ApiResponse<PageData<RolOpcionMenu>> listar(@RequestHeader("Authorization") String auth, Pageable pageable) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(PageData.of(service.listar(pageable)));
    }

    @GetMapping("/{id}")
    public ApiResponse<RolOpcionMenu> obtener(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    public ApiResponse<RolOpcionMenu> crear(@RequestHeader("Authorization") String auth, @RequestBody RolOpcionMenu body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.crear(body), "RolOpcionMenu creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<RolOpcionMenu> actualizar(@RequestHeader("Authorization") String auth, @PathVariable Long id, @RequestBody RolOpcionMenu body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.actualizar(id, body), "RolOpcionMenu actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> eliminar(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        service.eliminar(id);
        return ApiResponse.ok(null, "RolOpcionMenu eliminado");
    }
}
