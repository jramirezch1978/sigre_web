package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.AlmacenRequest;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.dto.AlmacenTipoMovAsignarRequest;
import com.sigre.almacen.dto.AlmacenTipoMovResponse;
import com.sigre.almacen.dto.AlmacenUsuarioAsignarRequest;
import com.sigre.almacen.dto.AlmacenUsuarioResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.dto.UbicacionAlmacenRequest;
import com.sigre.almacen.dto.UbicacionAlmacenResponse;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.mapper.AlmacenMapper;
import com.sigre.almacen.mapper.UbicacionAlmacenMapper;
import com.sigre.almacen.service.AlmacenService;
import com.sigre.almacen.service.AlmacenTipoMovService;
import com.sigre.almacen.service.AlmacenUserService;
import com.sigre.almacen.service.UbicacionAlmacenService;
import com.sigre.almacen.support.AlmacenResponseEnricher;
import com.sigre.almacen.support.AlmacenUsuarioResponseAssembler;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/almacen/almacenes")
@RequiredArgsConstructor
public class AlmacenController {

    private final AlmacenService almacenService;
    private final AlmacenMapper almacenMapper;
    private final AlmacenResponseEnricher almacenResponseEnricher;
    private final AlmacenUserService almacenUserService;
    private final AlmacenUsuarioResponseAssembler almacenUsuarioResponseAssembler;
    private final AlmacenTipoMovService almacenTipoMovService;
    private final UbicacionAlmacenService ubicacionAlmacenService;
    private final UbicacionAlmacenMapper ubicacionAlmacenMapper;

    @GetMapping
    public ApiResponse<PageData<AlmacenResponse>> findAll(
            Pageable pageable) {
        var page = almacenService.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(this::toResponseEnriched).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<AlmacenResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(almacenService.findById(id)));
    }

    /** Almacenes activos asignados al usuario actual (almacen.almacen_user). */
    @GetMapping("/mis-almacenes")
    public ApiResponse<List<AlmacenResponse>> misAlmacenes() {
        return ApiResponse.ok(
                almacenService.findMisAlmacenes().stream().map(this::toResponseEnriched).toList());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AlmacenResponse> create(@Valid @RequestBody AlmacenRequest request) {
        var entity = almacenMapper.toEntity(request);
        return ApiResponse.ok(toResponseEnriched(almacenService.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AlmacenResponse> update(@PathVariable Long id,
                                               @Valid @RequestBody AlmacenRequest request) {
        var existing = almacenService.findById(id);
        almacenMapper.updateEntity(request, existing);
        return ApiResponse.ok(toResponseEnriched(almacenService.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AlmacenResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(almacenService.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AlmacenResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(almacenService.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        almacenService.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    // ── Usuarios asignados al almacén (almacen.almacen_user) ──

    @GetMapping("/{almacenId}/usuarios")
    public ApiResponse<List<AlmacenUsuarioResponse>> listarUsuarios(
            @PathVariable Long almacenId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) Long usuarioId) {
        return ApiResponse.ok(almacenUsuarioResponseAssembler.toResponseList(
                almacenUserService.listarPorAlmacenId(almacenId, flagEstado, usuarioId)));
    }

    @PostMapping("/{almacenId}/usuarios")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AlmacenUsuarioResponse> asignarUsuario(
            @PathVariable Long almacenId, @Valid @RequestBody AlmacenUsuarioAsignarRequest request) {
        return ApiResponse.ok(
                almacenUsuarioResponseAssembler.toResponse(almacenUserService.asignar(almacenId, request.getUsuarioId())),
                "Usuario asignado al almacén");
    }

    @DeleteMapping("/{almacenId}/usuarios/{usuarioId}")
    public ApiResponse<AlmacenUsuarioResponse> desasignarUsuario(
            @PathVariable Long almacenId, @PathVariable Long usuarioId) {
        return ApiResponse.ok(
                almacenUsuarioResponseAssembler.toResponse(almacenUserService.desasignar(almacenId, usuarioId)),
                "Usuario desasignado del almacén");
    }


    // Tipos de movimiento permitidos para el almacen (almacen.almacen_tipo_mov)
    @GetMapping("/{almacenId}/tipos-movimiento")
    public ApiResponse<PageData<AlmacenTipoMovResponse>> listarTiposMovPermitidos(
            @PathVariable Long almacenId,
            Pageable pageable,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String tipoMov) {
        var page = almacenTipoMovService.listarPorAlmacen(almacenId, pageable, flagEstado, tipoMov);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }
    @PostMapping("/{almacenId}/tipos-movimiento")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AlmacenTipoMovResponse> asignarTipoMov(
            @PathVariable Long almacenId, @Valid @RequestBody AlmacenTipoMovAsignarRequest request) {
        return ApiResponse.ok(
                almacenTipoMovService.asignar(almacenId, request.getArticuloMovTipoId()),
                "Tipo de movimiento asignado al almacen");
    }
    @DeleteMapping("/{almacenId}/tipos-movimiento/{articuloMovTipoId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void desasignarTipoMov(
            @PathVariable Long almacenId, @PathVariable Long articuloMovTipoId) {
        almacenTipoMovService.desasignar(almacenId, articuloMovTipoId);
    }
    // ── UbicacionAlmacen sub-resource endpoints ──

    @GetMapping("/{almacenId}/ubicaciones")
    public ApiResponse<List<UbicacionAlmacenResponse>> findUbicaciones(@PathVariable Long almacenId) {
        almacenService.findById(almacenId);
        return ApiResponse.ok(ubicacionAlmacenMapper.toResponseList(ubicacionAlmacenService.findByAlmacenId(almacenId)));
    }

    @PostMapping("/{almacenId}/ubicaciones")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<UbicacionAlmacenResponse> createUbicacion(@PathVariable Long almacenId,
                                                                  @Valid @RequestBody UbicacionAlmacenRequest request) {
        almacenService.findById(almacenId);
        var entity = ubicacionAlmacenMapper.toEntity(request);
        entity.setAlmacenId(almacenId);
        return ApiResponse.ok(ubicacionAlmacenMapper.toResponse(ubicacionAlmacenService.create(entity)), "Registro creado");
    }

    private AlmacenResponse toResponseEnriched(Almacen entity) {
        AlmacenResponse dto = almacenMapper.toResponse(entity);
        almacenResponseEnricher.enrich(entity, dto);
        return dto;
    }
}
