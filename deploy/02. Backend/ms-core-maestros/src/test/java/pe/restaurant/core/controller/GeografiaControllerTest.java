package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Departamento;
import pe.restaurant.core.entity.Distrito;
import pe.restaurant.core.entity.Pais;
import pe.restaurant.core.entity.Provincia;
import pe.restaurant.core.mapper.GeografiaMapper;
import pe.restaurant.core.service.GeografiaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GeografiaControllerTest {

    @Mock private GeografiaService service;
    @Mock private GeografiaMapper mapper;
    @InjectMocks private GeografiaController controller;

    private final Pais pais = new Pais("PE", "Peru", null, null, null);
    private final PaisResponse paisResp = new PaisResponse(1L, "PE", "Peru", null, null, null, "1");
    private final Departamento depto = new Departamento();
    private final DepartamentoResponse deptoResp = new DepartamentoResponse();
    private final Provincia prov = new Provincia();
    private final ProvinciaResponse provResp = new ProvinciaResponse();
    private final Distrito dist = new Distrito();
    private final DistritoResponse distResp = new DistritoResponse();

    @BeforeEach
    void setUp() {
        depto.setId(1L);
        deptoResp.setId(1L);
        prov.setId(1L);
        provResp.setId(1L);
        dist.setId(1L);
        distResp.setId(1L);
    }

    // ── Pais ──────────────────────────────────────────────────────────────

    @Test void listPaises() {
        var pageable = PageRequest.of(0, 50);
        when(service.findAllPaises(pageable)).thenReturn(new PageImpl<>(List.of(pais)));
        when(mapper.toPaisResponseList(any())).thenReturn(List.of(paisResp));
        assertThat(controller.listPaises(pageable).isSuccess()).isTrue();
    }

    @Test void findPaisById() {
        when(service.findPaisById(1L)).thenReturn(pais);
        when(mapper.toResponse(pais)).thenReturn(paisResp);
        var result = controller.findPaisById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test void createPais() {
        var request = new PaisRequest("PE", "Peru", null, null, null);
        when(mapper.toEntity(request)).thenReturn(pais);
        when(service.createPais(pais)).thenReturn(pais);
        when(mapper.toResponse(pais)).thenReturn(paisResp);
        var result = controller.createPais(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro creado");
    }

    @Test void updatePais() {
        var request = new PaisRequest("PE", "Peru Upd", null, null, null);
        when(service.findPaisById(1L)).thenReturn(pais);
        when(service.updatePais(eq(1L), any())).thenReturn(pais);
        when(mapper.toResponse(any(Pais.class))).thenReturn(paisResp);
        var result = controller.updatePais(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro actualizado");
        verify(mapper).updateEntity(eq(request), any(Pais.class));
    }

    @Test void activatePais() {
        when(service.activatePais(1L)).thenReturn(pais);
        when(mapper.toResponse(pais)).thenReturn(paisResp);
        var result = controller.activatePais(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro activado");
    }

    @Test void deactivatePais() {
        when(service.deactivatePais(1L)).thenReturn(pais);
        when(mapper.toResponse(pais)).thenReturn(paisResp);
        var result = controller.deactivatePais(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro desactivado");
    }

    @Test void deletePais() {
        var result = controller.deletePais(1L);
        verify(service).deletePais(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    // ── Departamento ──────────────────────────────────────────────────────

    @Test void listDepartamentos_withPaisId() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllDepartamentos(1L, pageable)).thenReturn(new PageImpl<>(List.of(depto), pageable, 1));
        when(mapper.toDepartamentoResponseList(any())).thenReturn(List.of(deptoResp));
        assertThat(controller.listDepartamentos(1L, pageable).getData().getContent()).hasSize(1);
    }

    @Test void listDepartamentos_withoutFilter() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllDepartamentos(null, pageable)).thenReturn(new PageImpl<>(List.of(depto), pageable, 1));
        when(mapper.toDepartamentoResponseList(any())).thenReturn(List.of(deptoResp));
        assertThat(controller.listDepartamentos(null, pageable).getData().getContent()).hasSize(1);
    }

    @Test void findDepartamentoById() {
        when(service.findDepartamentoById(1L)).thenReturn(depto);
        when(mapper.toResponse(depto)).thenReturn(deptoResp);
        var result = controller.findDepartamentoById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test void createDepartamento() {
        var request = new DepartamentoRequest(1L, "LIM", "Lima");
        when(mapper.toEntity(request)).thenReturn(depto);
        when(service.createDepartamento(depto)).thenReturn(depto);
        when(mapper.toResponse(depto)).thenReturn(deptoResp);
        var result = controller.createDepartamento(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro creado");
    }

    @Test void updateDepartamento() {
        var request = new DepartamentoRequest(1L, "LIM", "Lima Upd");
        when(service.findDepartamentoById(1L)).thenReturn(depto);
        when(service.updateDepartamento(eq(1L), any())).thenReturn(depto);
        when(mapper.toResponse(any(Departamento.class))).thenReturn(deptoResp);
        var result = controller.updateDepartamento(1L, request);
        assertThat(result.isSuccess()).isTrue();
        verify(mapper).updateEntity(eq(request), any(Departamento.class));
    }

    @Test void activateDepartamento() {
        when(service.activateDepartamento(1L)).thenReturn(depto);
        when(mapper.toResponse(depto)).thenReturn(deptoResp);
        assertThat(controller.activateDepartamento(1L).isSuccess()).isTrue();
    }

    @Test void deactivateDepartamento() {
        when(service.deactivateDepartamento(1L)).thenReturn(depto);
        when(mapper.toResponse(depto)).thenReturn(deptoResp);
        assertThat(controller.deactivateDepartamento(1L).isSuccess()).isTrue();
    }

    @Test void deleteDepartamento() {
        var result = controller.deleteDepartamento(1L);
        verify(service).deleteDepartamento(1L);
        assertThat(result.getData()).isTrue();
    }

    // ── Provincia ─────────────────────────────────────────────────────────

    @Test void listProvincias_withDepartamentoId() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllProvincias(1L, pageable)).thenReturn(new PageImpl<>(List.of(prov), pageable, 1));
        when(mapper.toProvinciaResponseList(any())).thenReturn(List.of(provResp));
        assertThat(controller.listProvincias(1L, pageable).getData().getContent()).hasSize(1);
    }

    @Test void listProvincias_withoutFilter() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllProvincias(null, pageable)).thenReturn(new PageImpl<>(List.of(prov), pageable, 1));
        when(mapper.toProvinciaResponseList(any())).thenReturn(List.of(provResp));
        assertThat(controller.listProvincias(null, pageable).getData().getContent()).hasSize(1);
    }

    @Test void findProvinciaById() {
        when(service.findProvinciaById(1L)).thenReturn(prov);
        when(mapper.toResponse(prov)).thenReturn(provResp);
        var result = controller.findProvinciaById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test void createProvincia() {
        var request = new ProvinciaRequest(1L, "LIM", "Lima");
        when(mapper.toEntity(request)).thenReturn(prov);
        when(service.createProvincia(prov)).thenReturn(prov);
        when(mapper.toResponse(prov)).thenReturn(provResp);
        var result = controller.createProvincia(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro creado");
    }

    @Test void updateProvincia() {
        var request = new ProvinciaRequest(1L, "LIM", "Lima Upd");
        when(service.findProvinciaById(1L)).thenReturn(prov);
        when(service.updateProvincia(eq(1L), any())).thenReturn(prov);
        when(mapper.toResponse(any(Provincia.class))).thenReturn(provResp);
        var result = controller.updateProvincia(1L, request);
        assertThat(result.isSuccess()).isTrue();
        verify(mapper).updateEntity(eq(request), any(Provincia.class));
    }

    @Test void activateProvincia() {
        when(service.activateProvincia(1L)).thenReturn(prov);
        when(mapper.toResponse(prov)).thenReturn(provResp);
        assertThat(controller.activateProvincia(1L).isSuccess()).isTrue();
    }

    @Test void deactivateProvincia() {
        when(service.deactivateProvincia(1L)).thenReturn(prov);
        when(mapper.toResponse(prov)).thenReturn(provResp);
        assertThat(controller.deactivateProvincia(1L).isSuccess()).isTrue();
    }

    @Test void deleteProvincia() {
        var result = controller.deleteProvincia(1L);
        verify(service).deleteProvincia(1L);
        assertThat(result.getData()).isTrue();
    }

    // ── Distrito ──────────────────────────────────────────────────────────

    @Test void listDistritos_withProvinciaId() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllDistritos(1L, pageable)).thenReturn(new PageImpl<>(List.of(dist), pageable, 1));
        when(mapper.toDistritoResponseList(any())).thenReturn(List.of(distResp));
        assertThat(controller.listDistritos(1L, pageable).getData().getContent()).hasSize(1);
    }

    @Test void listDistritos_withoutFilter() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAllDistritos(null, pageable)).thenReturn(new PageImpl<>(List.of(dist), pageable, 1));
        when(mapper.toDistritoResponseList(any())).thenReturn(List.of(distResp));
        assertThat(controller.listDistritos(null, pageable).getData().getContent()).hasSize(1);
    }

    @Test void findDistritoById() {
        when(service.findDistritoById(1L)).thenReturn(dist);
        when(mapper.toResponse(dist)).thenReturn(distResp);
        var result = controller.findDistritoById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test void createDistrito() {
        var request = new DistritoRequest(1L, "LIM", "Lima Cercado");
        when(mapper.toEntity(request)).thenReturn(dist);
        when(service.createDistrito(dist)).thenReturn(dist);
        when(mapper.toResponse(dist)).thenReturn(distResp);
        var result = controller.createDistrito(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro creado");
    }

    @Test void updateDistrito() {
        var request = new DistritoRequest(1L, "LIM", "Lima Upd");
        when(service.findDistritoById(1L)).thenReturn(dist);
        when(service.updateDistrito(eq(1L), any())).thenReturn(dist);
        when(mapper.toResponse(any(Distrito.class))).thenReturn(distResp);
        var result = controller.updateDistrito(1L, request);
        assertThat(result.isSuccess()).isTrue();
        verify(mapper).updateEntity(eq(request), any(Distrito.class));
    }

    @Test void activateDistrito() {
        when(service.activateDistrito(1L)).thenReturn(dist);
        when(mapper.toResponse(dist)).thenReturn(distResp);
        assertThat(controller.activateDistrito(1L).isSuccess()).isTrue();
    }

    @Test void deactivateDistrito() {
        when(service.deactivateDistrito(1L)).thenReturn(dist);
        when(mapper.toResponse(dist)).thenReturn(distResp);
        assertThat(controller.deactivateDistrito(1L).isSuccess()).isTrue();
    }

    @Test void deleteDistrito() {
        var result = controller.deleteDistrito(1L);
        verify(service).deleteDistrito(1L);
        assertThat(result.getData()).isTrue();
    }
}
