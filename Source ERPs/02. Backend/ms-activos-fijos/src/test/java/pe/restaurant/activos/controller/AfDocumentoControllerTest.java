package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfDocumentoRequest;
import pe.restaurant.activos.dto.AfDocumentoResponse;
import pe.restaurant.activos.entity.AfDocumento;
import pe.restaurant.activos.mapper.AfDocumentoMapper;
import pe.restaurant.activos.service.AfDocumentoService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfDocumentoControllerTest {

    @Mock private AfDocumentoService service;
    @Mock private AfDocumentoMapper mapper;
    @InjectMocks private AfDocumentoController controller;

    private AfDocumento entity;
    private AfDocumentoResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfDocumento();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoDocumento("PDF");
        entity.setNombreArchivo("documento.pdf");
        entity.setRutaArchivo("/ruta/documento.pdf");
        entity.setDescripcion("Documento de prueba");
        entity.setFechaCarga(LocalDate.now());
        entity.setTamanioBytes(1024L);
        entity.setExtension("pdf");
        entity.setUsuarioCargaId(1L);

        response = new AfDocumentoResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setTipoDocumento("PDF");
        response.setNombreArchivo("documento.pdf");
    }

    @Test
    void listar() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listar(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void obtenerPorId() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.obtenerPorId(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void crear() {
        when(mapper.toEntity(any(AfDocumentoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfDocumentoRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.actualizar(1L, new AfDocumentoRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    void eliminar() {
        doNothing().when(service).delete(1L);
        var result = controller.eliminar(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }

    @Test
    void listarPorActivo() {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorActivo(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void listarPorTipo() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findByTipo(eq("PDF"), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorTipo("PDF", Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

}
