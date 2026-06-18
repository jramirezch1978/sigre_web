package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.CierreCajaCerrarRequest;
import pe.restaurant.ventas.dto.request.CierreCajaRequest;
import pe.restaurant.ventas.dto.response.CierreCajaResponse;
import pe.restaurant.ventas.entity.CierreCaja;
import pe.restaurant.ventas.mapper.VentasResponseMapper;
import pe.restaurant.ventas.service.CierreCajaService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CierreCajaControllerTest {

    @Mock
    private CierreCajaService service;
    @Mock
    private VentasResponseMapper mapper;
    @InjectMocks
    private CierreCajaController controller;

    @Test
    void list() {
        when(service.findAll(any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new CierreCaja())));
        when(mapper.toCierreCajaResponse(any())).thenReturn(CierreCajaResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null).isSuccess()).isTrue();
    }

    @Test
    void getById() {
        when(service.findById(1L)).thenReturn(new CierreCaja());
        when(mapper.toCierreCajaResponse(any())).thenReturn(CierreCajaResponse.builder().id(1L).build());
        assertThat(controller.get(1L).isSuccess()).isTrue();
    }

    @Test
    void create() {
        var req = CierreCajaRequest.builder().turnoId(10L).build();
        when(service.create(any())).thenReturn(new CierreCaja());
        when(mapper.toCierreCajaResponse(any())).thenReturn(CierreCajaResponse.builder().id(2L).estadoCierre("OPEN").build());
        assertThat(controller.create(req).isSuccess()).isTrue();
    }

    @Test
    void cerrar() {
        var req = CierreCajaCerrarRequest.builder().fondoFinal(BigDecimal.TEN).build();
        when(service.cerrar(3L, req)).thenReturn(new CierreCaja());
        when(mapper.toCierreCajaResponse(any())).thenReturn(CierreCajaResponse.builder().id(3L).estadoCierre("CLOSED").build());
        assertThat(controller.cerrar(3L, req).isSuccess()).isTrue();
    }
}
