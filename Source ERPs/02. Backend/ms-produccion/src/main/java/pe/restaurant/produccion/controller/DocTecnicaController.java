package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.CaractDetRequest;
import pe.restaurant.produccion.dto.request.DocTecnicaRequest;
import pe.restaurant.produccion.dto.response.CaractDetResponse;
import pe.restaurant.produccion.dto.response.DocTecnicaResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.entity.ArticuloDocTecnica;
import pe.restaurant.produccion.entity.ArticuloDocTecnicaCaractDet;
import pe.restaurant.produccion.mapper.ArticuloDocTecnicaMapper;
import pe.restaurant.produccion.mapper.CaractDetMapper;
import pe.restaurant.produccion.service.ArticuloDocTecnicaService;

import java.util.List;

@RestController
@RequestMapping("/api/produccion/documentacion-tecnica")
@RequiredArgsConstructor
public class DocTecnicaController {

    private final ArticuloDocTecnicaService service;
    private final ArticuloDocTecnicaMapper mapper;
    private final CaractDetMapper caractDetMapper;

    @GetMapping
    public ApiResponse<PageData<DocTecnicaResponse>> findAll(
            @RequestParam(required = false) Long docTipoId,
            @RequestParam(required = false) String nombreDocumento,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = service.findAll(docTipoId, nombreDocumento, flagEstado, articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<DocTecnicaResponse> findById(@PathVariable Long id) {
        var entity = service.findById(id);
        var response = mapper.toResponse(entity);
        var caractResps = caractDetMapper.toResponseList(service.findCaracteristicas(id));
        service.enrichCaractDetResponses(caractResps);
        response.setCaracteristicas(caractResps);
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DocTecnicaResponse> create(@Valid @RequestBody DocTecnicaRequest request) {
        var entity = mapper.toEntity(request);
        var caracteristicas = toCaractDetEntityList(request.getCaracteristicas());
        var saved = service.create(entity, caracteristicas);
        var response = mapper.toResponse(saved);
        var caractResps = caractDetMapper.toResponseList(service.findCaracteristicas(saved.getId()));
        service.enrichCaractDetResponses(caractResps);
        response.setCaracteristicas(caractResps);
        return ApiResponse.ok(response, "Documento técnico creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<DocTecnicaResponse> update(@PathVariable Long id,
                                                   @Valid @RequestBody DocTecnicaRequest request) {
        var entity = mapper.toEntity(request);
        var caracteristicas = toCaractDetEntityList(request.getCaracteristicas());
        var updated = service.update(id, entity, caracteristicas);
        var response = mapper.toResponse(updated);
        var caractResps = caractDetMapper.toResponseList(service.findCaracteristicas(updated.getId()));
        service.enrichCaractDetResponses(caractResps);
        response.setCaracteristicas(caractResps);
        return ApiResponse.ok(response, "Documento técnico actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<DocTecnicaResponse> activate(@PathVariable Long id) {
        var updated = service.activate(id);
        return ApiResponse.ok(mapper.toResponse(updated), "Documento técnico activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<DocTecnicaResponse> deactivate(@PathVariable Long id) {
        var updated = service.deactivate(id);
        return ApiResponse.ok(mapper.toResponse(updated), "Documento técnico desactivado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Documento técnico eliminado");
    }

    @GetMapping("/{id}/caracteristicas")
    public ApiResponse<List<CaractDetResponse>> findCaracteristicas(@PathVariable Long id) {
        var resps = caractDetMapper.toResponseList(service.findCaracteristicas(id));
        service.enrichCaractDetResponses(resps);
        return ApiResponse.ok(resps);
    }

    private List<ArticuloDocTecnicaCaractDet> toCaractDetEntityList(List<CaractDetRequest> requests) {
        if (requests == null) return null;
        return requests.stream().map(caractDetMapper::toEntity).toList();
    }
}
