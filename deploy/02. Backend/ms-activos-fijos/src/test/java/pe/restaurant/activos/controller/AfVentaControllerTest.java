package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfVentaRequest;
import pe.restaurant.activos.dto.AfVentaResponse;
import pe.restaurant.activos.entity.AfVenta;
import pe.restaurant.activos.mapper.AfVentaMapper;
import pe.restaurant.activos.service.AfVentaService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfVentaControllerTest {

    @Mock private AfVentaService service;
    @Mock private AfVentaMapper mapper;
    @InjectMocks private AfVentaController controller;

    private AfVenta entity;
    private AfVentaResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setFechaBaja(LocalDate.now());
        entity.setMotivo("Venta");
        entity.setValorVenta(new BigDecimal("10000.00"));
        entity.setComprador("Comprador Test");

        response = new AfVentaResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setValorVenta(new BigDecimal("10000.00"));
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
        when(mapper.toEntity(any(AfVentaRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfVentaRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.actualizar(1L, new AfVentaRequest());
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
    void aprobar() {
        when(service.aprobar(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.aprobar(1L);
        assertThat(result.getMessage()).contains("aprobada");
    }

    @Test
    void reportePorAnio() {
        when(service.findByAnio(2024)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.reportePorAnio(2024);
        assertThat(result.getData()).hasSize(1);
    }
}
