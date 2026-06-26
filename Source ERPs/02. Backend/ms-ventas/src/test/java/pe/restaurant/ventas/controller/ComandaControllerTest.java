package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ComandaCabeceraRequest;
import pe.restaurant.ventas.dto.request.ComandaEstadoRequest;
import pe.restaurant.ventas.dto.request.ComandaItemRequest;
import pe.restaurant.ventas.dto.request.ComandaItemsAppendRequest;
import pe.restaurant.ventas.dto.response.ComandaResponse;
import pe.restaurant.ventas.entity.Comanda;
import pe.restaurant.ventas.service.ComandaService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ComandaControllerTest {

    @Mock
    private ComandaService comandaService;
    @InjectMocks
    private ComandaController controller;

    private Comanda entity;
    private ComandaResponse response;

    @BeforeEach
    void setUp() {
        entity = new Comanda();
        entity.setId(1L);
        entity.setSucursalId(10L);
        entity.setFlagEstado("1");

        response = ComandaResponse.builder().id(1L).sucursalId(10L).items(List.of()).build();
    }

    @Test
    void findAll() {
        when(comandaService.findAll(any(), any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        var r = controller.findAll(Pageable.unpaged(), null, null, null, null, null, null);
        assertThat(r.isSuccess()).isTrue();
        assertThat(r.getData().getContent()).hasSize(1);
    }

    @Test
    void findById() {
        when(comandaService.getById(1L)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void create() {
        ComandaCabeceraRequest req = new ComandaCabeceraRequest();
        req.setSucursalId(1L);
        ComandaItemRequest line = new ComandaItemRequest();
        line.setArticuloId(1L);
        line.setCantidad(BigDecimal.ONE);
        line.setPrecioUnitario(BigDecimal.TEN);
        req.setItems(List.of(line));
        when(comandaService.create(any())).thenReturn(response);
        var r = controller.create(req);
        assertThat(r.isSuccess()).isTrue();
        assertThat(r.getMessage()).contains("creada");
    }

    @Test
    void update() {
        ComandaCabeceraRequest req = new ComandaCabeceraRequest();
        req.setSucursalId(1L);
        ComandaItemRequest line = new ComandaItemRequest();
        line.setArticuloId(1L);
        line.setCantidad(BigDecimal.ONE);
        line.setPrecioUnitario(BigDecimal.TEN);
        req.setItems(List.of(line));
        when(comandaService.update(eq(1L), any())).thenReturn(response);
        assertThat(controller.update(1L, req).isSuccess()).isTrue();
    }

    @Test
    void addItems() {
        ComandaItemsAppendRequest req = new ComandaItemsAppendRequest();
        ComandaItemRequest line = new ComandaItemRequest();
        line.setArticuloId(2L);
        line.setCantidad(BigDecimal.ONE);
        line.setPrecioUnitario(BigDecimal.ONE);
        req.setItems(List.of(line));
        when(comandaService.addItems(eq(1L), any())).thenReturn(response);
        assertThat(controller.addItems(1L, req).isSuccess()).isTrue();
    }

    @Test
    void patchEstado() {
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("3");
        when(comandaService.patchEstado(eq(1L), any())).thenReturn(response);
        assertThat(controller.patchEstado(1L, req).isSuccess()).isTrue();
    }

    @Test
    void anular() {
        when(comandaService.anular(1L)).thenReturn(response);
        assertThat(controller.anular(1L).isSuccess()).isTrue();
    }

    @Test
    void activateDeactivateDelete() {
        when(comandaService.activate(1L)).thenReturn(response);
        when(comandaService.deactivate(1L)).thenReturn(response);
        assertThat(controller.activate(1L).isSuccess()).isTrue();
        assertThat(controller.deactivate(1L).isSuccess()).isTrue();
        controller.delete(1L);
        verify(comandaService).delete(1L);
    }
}
