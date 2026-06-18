package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.PedidoMesaRequest;
import pe.restaurant.ventas.dto.response.PedidoMesaResponse;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.entity.PedidoMesa;
import pe.restaurant.ventas.service.PedidoMesaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PedidoMesaControllerTest {

    @Mock
    private PedidoMesaService pedidoMesaService;
    @InjectMocks
    private PedidoMesaController controller;

    private PedidoMesa entity;
    private PedidoMesaResponse response;

    @BeforeEach
    void setUp() {
        Mesa mesa = new Mesa();
        mesa.setId(5L);
        mesa.setNumero("M1");

        entity = new PedidoMesa();
        entity.setId(1L);
        entity.setSucursalId(10L);
        entity.setTipo("SALON");
        entity.setNumero("PM-1");
        entity.setFlagEstado("1");
        entity.setMesa(mesa);

        response = PedidoMesaResponse.builder()
                .id(1L)
                .sucursalId(10L)
                .tipo("SALON")
                .numero("PM-1")
                .mesaId(5L)
                .mesaNumero("M1")
                .build();
    }

    @Test
    void findAll() {
        when(pedidoMesaService.findAll(any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        var r = controller.findAll(Pageable.unpaged(), null, null, null, null, null);
        assertThat(r.isSuccess()).isTrue();
        assertThat(r.getData().getContent()).hasSize(1);
    }

    @Test
    void findById() {
        when(pedidoMesaService.getById(1L)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getNumero()).isEqualTo("PM-1");
    }

    @Test
    void createUpdateCerrarAnular() {
        PedidoMesaRequest req = new PedidoMesaRequest();
        req.setTipo("SALON");
        req.setNumero("PM-1");
        when(pedidoMesaService.create(any())).thenReturn(response);
        when(pedidoMesaService.update(eq(1L), any())).thenReturn(response);
        when(pedidoMesaService.cerrar(1L)).thenReturn(response);
        when(pedidoMesaService.anular(1L)).thenReturn(response);
        assertThat(controller.create(req).isSuccess()).isTrue();
        assertThat(controller.update(1L, req).isSuccess()).isTrue();
        assertThat(controller.cerrar(1L).isSuccess()).isTrue();
        assertThat(controller.anular(1L).isSuccess()).isTrue();
    }

    @Test
    void activateDeactivateDelete() {
        when(pedidoMesaService.activate(1L)).thenReturn(response);
        when(pedidoMesaService.deactivate(1L)).thenReturn(response);
        assertThat(controller.activate(1L).isSuccess()).isTrue();
        assertThat(controller.deactivate(1L).isSuccess()).isTrue();
        controller.delete(1L);
        verify(pedidoMesaService).delete(1L);
    }
}
