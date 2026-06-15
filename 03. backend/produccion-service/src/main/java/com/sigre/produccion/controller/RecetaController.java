package com.sigre.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.dto.request.RecetaRequest;
import com.sigre.produccion.dto.response.PageData;
import com.sigre.produccion.dto.response.RecetaConsumibleResponse;
import com.sigre.produccion.dto.response.RecetaLaborResponse;
import com.sigre.produccion.dto.response.RecetaResponse;
import com.sigre.produccion.entity.FichaTecnica;
import com.sigre.produccion.entity.RecetaLabor;
import com.sigre.produccion.entity.RecetaLaborConsumible;
import com.sigre.produccion.mapper.FichaTecnicaMapper;
import com.sigre.produccion.mapper.RecetaConsumibleMapper;
import com.sigre.produccion.mapper.RecetaLaborMapper;
import com.sigre.produccion.mapper.RecetaMapper;
import com.sigre.produccion.service.RecetaService;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/produccion/recetas")
@RequiredArgsConstructor
public class RecetaController {

    private final RecetaService recetaService;
    private final RecetaMapper recetaMapper;
    private final RecetaLaborMapper laborMapper;
    private final RecetaConsumibleMapper consumibleMapper;
    private final FichaTecnicaMapper fichaTecnicaMapper;

    @GetMapping
    public ApiResponse<PageData<RecetaResponse>> findAll(
            @RequestParam(required = false) String nroReceta,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagTipoReceta,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) Long articuloProducidoId,
            Pageable pageable) {
        var page = recetaService.findAll(nroReceta, nombre, flagTipoReceta, flagEstado, articuloProducidoId, pageable);
        var responses = recetaMapper.toResponseList(page.getContent());
        recetaService.enrichRecetaResponses(responses);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<RecetaResponse> findById(@PathVariable Long id) {
        var entity = recetaService.findById(id);
        var labores = recetaService.findLabores(id);
        var consumibles = recetaService.findConsumibles(id);
        var fichaTecnica = recetaService.findFichaTecnica(id);

        var response = recetaMapper.toResponse(entity);
        var laborResponses = laborMapper.toResponseList(labores);
        var consumibleResponses = consumibleMapper.toResponseList(consumibles);
        response.setLabores(laborResponses);
        response.setConsumibles(consumibleResponses);
        response.setFichaTecnica(fichaTecnica != null ? fichaTecnicaMapper.toResponse(fichaTecnica) : null);

        recetaService.enrichRecetaResponses(List.of(response));
        recetaService.enrichLaborResponses(laborResponses);
        recetaService.enrichConsumibleResponses(consumibleResponses);

        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<RecetaResponse> create(@Valid @RequestBody RecetaRequest request) {
        var receta = recetaMapper.toEntity(request);
        List<RecetaLabor> labores = new ArrayList<>();
        if (request.getLabores() != null) {
            labores = request.getLabores().stream().map(laborMapper::toEntity).toList();
        }
        List<RecetaLaborConsumible> consumibles = new ArrayList<>();
        if (request.getConsumibles() != null) {
            consumibles = request.getConsumibles().stream().map(consumibleMapper::toEntity).toList();
        }
        var fichaTecnica = request.getFichaTecnica() != null
                ? fichaTecnicaMapper.toEntity(request.getFichaTecnica())
                : null;

        var saved = recetaService.create(receta, labores, consumibles, fichaTecnica);
        var response = recetaMapper.toResponse(saved);
        var savedLabores = recetaService.findLabores(saved.getId());
        var savedConsumibles = recetaService.findConsumibles(saved.getId());
        var savedFichaTecnica = recetaService.findFichaTecnica(saved.getId());
        var laborResponses = laborMapper.toResponseList(savedLabores);
        var consumibleResponses = consumibleMapper.toResponseList(savedConsumibles);
        response.setLabores(laborResponses);
        response.setConsumibles(consumibleResponses);
        response.setFichaTecnica(savedFichaTecnica != null ? fichaTecnicaMapper.toResponse(savedFichaTecnica) : null);
        recetaService.enrichRecetaResponses(List.of(response));
        recetaService.enrichLaborResponses(laborResponses);
        recetaService.enrichConsumibleResponses(consumibleResponses);
        return ApiResponse.ok(response, "Receta creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<RecetaResponse> update(@PathVariable Long id,
                                              @Valid @RequestBody RecetaRequest request) {
        var receta = recetaMapper.toEntity(request);
        List<RecetaLabor> labores = new ArrayList<>();
        if (request.getLabores() != null) {
            labores = request.getLabores().stream().map(laborMapper::toEntity).toList();
        }
        List<RecetaLaborConsumible> consumibles = new ArrayList<>();
        if (request.getConsumibles() != null) {
            consumibles = request.getConsumibles().stream().map(consumibleMapper::toEntity).toList();
        }
        var fichaTecnica = request.getFichaTecnica() != null
                ? fichaTecnicaMapper.toEntity(request.getFichaTecnica())
                : null;

        var updated = recetaService.update(id, receta, labores, consumibles, fichaTecnica);
        var response = recetaMapper.toResponse(updated);
        var updatedLabores = recetaService.findLabores(updated.getId());
        var updatedConsumibles = recetaService.findConsumibles(updated.getId());
        var updatedFichaTecnica = recetaService.findFichaTecnica(updated.getId());
        var laborResponses = laborMapper.toResponseList(updatedLabores);
        var consumibleResponses = consumibleMapper.toResponseList(updatedConsumibles);
        response.setLabores(laborResponses);
        response.setConsumibles(consumibleResponses);
        response.setFichaTecnica(updatedFichaTecnica != null ? fichaTecnicaMapper.toResponse(updatedFichaTecnica) : null);
        recetaService.enrichRecetaResponses(List.of(response));
        recetaService.enrichLaborResponses(laborResponses);
        recetaService.enrichConsumibleResponses(consumibleResponses);
        return ApiResponse.ok(response, "Receta actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<RecetaResponse> activate(@PathVariable Long id) {
        var response = recetaMapper.toResponse(recetaService.activate(id));
        recetaService.enrichRecetaResponses(List.of(response));
        return ApiResponse.ok(response, "Receta activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<RecetaResponse> deactivate(@PathVariable Long id) {
        var response = recetaMapper.toResponse(recetaService.deactivate(id));
        recetaService.enrichRecetaResponses(List.of(response));
        return ApiResponse.ok(response, "Receta desactivada");
    }

}
