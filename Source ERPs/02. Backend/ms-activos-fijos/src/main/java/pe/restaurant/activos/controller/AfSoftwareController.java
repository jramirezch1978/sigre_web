package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfSoftwareRequest;
import pe.restaurant.activos.dto.AfSoftwareResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.entity.AfSoftware;
import pe.restaurant.activos.service.AfSoftwareService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/software")
@RequiredArgsConstructor
public class AfSoftwareController {

    private final AfSoftwareService service;

    @GetMapping
    public ApiResponse<PageData<AfSoftwareResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(this::toResponse).toList()));
    }

    @GetMapping("/maestro/{maestroId}")
    public ApiResponse<List<AfSoftwareResponse>> listarPorMaestro(@PathVariable Long maestroId) {
        return ApiResponse.ok(service.findByMaestro(maestroId).stream().map(this::toResponse).toList());
    }

    @GetMapping("/{id}")
    public ApiResponse<AfSoftwareResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfSoftwareResponse> crear(@Valid @RequestBody AfSoftwareRequest request) {
        AfSoftware e = new AfSoftware();
        e.setAfMaestroId(request.getAfMaestroId());
        e.setLicencia(request.getLicencia());
        e.setProveedorSoftware(request.getProveedorSoftware());
        e.setFechaVigenciaIni(request.getFechaVigenciaIni());
        e.setFechaVigenciaFin(request.getFechaVigenciaFin());
        e.setSoporte(request.getSoporte());
        return ApiResponse.ok(toResponse(service.create(e)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfSoftwareResponse> actualizar(@PathVariable Long id,
                                                      @Valid @RequestBody AfSoftwareRequest request) {
        AfSoftware e = new AfSoftware();
        e.setLicencia(request.getLicencia());
        e.setProveedorSoftware(request.getProveedorSoftware());
        e.setFechaVigenciaIni(request.getFechaVigenciaIni());
        e.setFechaVigenciaFin(request.getFechaVigenciaFin());
        e.setSoporte(request.getSoporte());
        return ApiResponse.ok(toResponse(service.update(id, e)));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true);
    }

    private AfSoftwareResponse toResponse(AfSoftware e) {
        AfSoftwareResponse r = new AfSoftwareResponse();
        r.setId(e.getId());
        r.setAfMaestroId(e.getAfMaestroId());
        r.setLicencia(e.getLicencia());
        r.setProveedorSoftware(e.getProveedorSoftware());
        r.setFechaVigenciaIni(e.getFechaVigenciaIni());
        r.setFechaVigenciaFin(e.getFechaVigenciaFin());
        r.setSoporte(e.getSoporte());
        r.setFlagEstado(e.getFlagEstado());
        return r;
    }
}
