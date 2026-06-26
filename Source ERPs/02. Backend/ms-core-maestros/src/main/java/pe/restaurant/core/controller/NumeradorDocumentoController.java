package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.NumeradorDocumentoRequest;
import pe.restaurant.core.dto.NumeradorDocumentoResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.entity.NumeradorDocumento;
import pe.restaurant.core.mapper.NumeradorDocumentoMapper;
import pe.restaurant.core.service.NumeradorDocumentoService;

@RestController
@RequestMapping("/api/core/numerador-documentos")
@RequiredArgsConstructor
public class NumeradorDocumentoController {

    private final NumeradorDocumentoService service;
    private final NumeradorDocumentoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<NumeradorDocumentoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/buscar")
    public ApiResponse<NumeradorDocumentoResponse> findById(@RequestParam String nombreTabla,
                                                            @RequestParam Long sucursalId,
                                                            @RequestParam Short ano) {
        return ApiResponse.ok(mapper.toResponse(service.findById(buildId(nombreTabla, sucursalId, ano))));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NumeradorDocumentoResponse> create(@Valid @RequestBody NumeradorDocumentoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/buscar")
    public ApiResponse<NumeradorDocumentoResponse> update(@RequestParam String nombreTabla,
                                                          @RequestParam Long sucursalId,
                                                          @RequestParam Short ano,
                                                          @Valid @RequestBody NumeradorDocumentoRequest request) {
        var existing = service.findById(buildId(nombreTabla, sucursalId, ano));
        existing.setUltNro(request.getUltNro());
        existing.setFlagEstado(request.getFlagEstado());
        return ApiResponse.ok(mapper.toResponse(service.update(existing)), "Registro actualizado");
    }

    @DeleteMapping("/buscar")
    public ApiResponse<Boolean> delete(@RequestParam String nombreTabla,
                                       @RequestParam Long sucursalId,
                                       @RequestParam Short ano) {
        service.delete(buildId(nombreTabla, sucursalId, ano));
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/buscar/activar")
    public ApiResponse<NumeradorDocumentoResponse> activate(@RequestParam String nombreTabla,
                                                            @RequestParam Long sucursalId,
                                                            @RequestParam Short ano) {
        return ApiResponse.ok(mapper.toResponse(service.activate(buildId(nombreTabla, sucursalId, ano))), "Registro activado");
    }

    @PatchMapping("/buscar/desactivar")
    public ApiResponse<NumeradorDocumentoResponse> deactivate(@RequestParam String nombreTabla,
                                                              @RequestParam Long sucursalId,
                                                              @RequestParam Short ano) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(buildId(nombreTabla, sucursalId, ano))), "Registro desactivado");
    }

    private NumeradorDocumento.NumeradorDocumentoId buildId(String nombreTabla, Long sucursalId, Short ano) {
        NumeradorDocumento.NumeradorDocumentoId id = new NumeradorDocumento.NumeradorDocumentoId();
        id.setNombreTabla(nombreTabla);
        id.setSucursalId(sucursalId);
        id.setAno(ano);
        return id;
    }
}
