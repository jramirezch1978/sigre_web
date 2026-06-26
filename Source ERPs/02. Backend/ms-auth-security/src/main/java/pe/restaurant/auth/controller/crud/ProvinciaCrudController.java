package pe.restaurant.auth.controller.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.auth.dto.PageData;
import pe.restaurant.auth.entity.Provincia;
import pe.restaurant.auth.service.SeguridadService;
import pe.restaurant.auth.service.crud.ProvinciaCrudService;
import pe.restaurant.auth.support.SeguridadContextHelper;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/auth/master/provincias")
@RequiredArgsConstructor
public class ProvinciaCrudController {

    private final ProvinciaCrudService service;
    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;

    @GetMapping
    public ApiResponse<PageData<Provincia>> listar(@RequestHeader("Authorization") String auth, Pageable pageable) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(PageData.of(service.listar(pageable)));
    }

    @GetMapping("/{id}")
    public ApiResponse<Provincia> obtener(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireUsuarioEmpresa(uid, emp);
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    public ApiResponse<Provincia> crear(@RequestHeader("Authorization") String auth, @RequestBody Provincia body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.crear(body), "Provincia creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<Provincia> actualizar(@RequestHeader("Authorization") String auth, @PathVariable Long id, @RequestBody Provincia body) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(service.actualizar(id, body), "Provincia actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> eliminar(@RequestHeader("Authorization") String auth, @PathVariable Long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        service.eliminar(id);
        return ApiResponse.ok(null, "Provincia eliminada");
    }
}
