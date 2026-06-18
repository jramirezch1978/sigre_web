package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.DespachoOvRequest;
import pe.restaurant.ventas.dto.request.OrdenVentaRequest;
import pe.restaurant.ventas.dto.response.DespachoOvResponse;
import pe.restaurant.ventas.dto.response.OrdenVentaResponse;
import pe.restaurant.ventas.entity.OrdenVenta;
import pe.restaurant.ventas.mapper.VentasResponseMapper;
import pe.restaurant.ventas.service.OrdenVentaService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrdenVentaControllerTest {

    @Mock
    private OrdenVentaService service;
    @Mock
    private VentasResponseMapper mapper;
    @InjectMocks
    private OrdenVentaController controller;

    @Test
    void list() {
        when(service.findAll(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new OrdenVenta())));
        when(mapper.toOrdenVentaResponse(any())).thenReturn(OrdenVentaResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void getById() {
        when(service.findById(1L)).thenReturn(new OrdenVenta());
        when(mapper.toOrdenVentaResponse(any())).thenReturn(OrdenVentaResponse.builder().id(1L).build());
        assertThat(controller.get(1L).isSuccess()).isTrue();
    }

    @Test
    void confirmar() {
        when(service.confirmar(2L)).thenReturn(new OrdenVenta());
        when(mapper.toOrdenVentaResponse(any())).thenReturn(OrdenVentaResponse.builder().id(2L).build());
        assertThat(controller.confirmar(2L).isSuccess()).isTrue();
    }

    @Test
    void create() {
        var req = OrdenVentaRequest.builder()
                .sucursalId(1L)
                .fechaEmision(LocalDate.now())
                .build();
        when(service.create(any())).thenReturn(new OrdenVenta());
        when(mapper.toOrdenVentaResponse(any())).thenReturn(OrdenVentaResponse.builder().id(3L).build());
        assertThat(controller.create(req).isSuccess()).isTrue();
    }

    @Test
    void despachar() {
        var req = DespachoOvRequest.builder()
                .articuloMovTipoId(2L)
                .almacenId(3L)
                .fechaMov(LocalDate.now())
                .build();
        var resp = DespachoOvResponse.builder()
                .ordenVentaId(5L)
                .nroOrdenVenta("OV-TEST")
                .build();
        when(service.despacharEnAlmacen(anyLong(), any())).thenReturn(resp);
        assertThat(controller.despachar(5L, req).isSuccess()).isTrue();
    }
}
