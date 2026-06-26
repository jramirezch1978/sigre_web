package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.EntidadCreditosCxcRequest;
import pe.restaurant.ventas.dto.response.EntidadCreditosCxcResponse;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.mapper.VentasIssue5DtoMapper;
import pe.restaurant.ventas.service.EntidadCreditosCxcService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EntidadCreditosCxcControllerTest {

    @Mock
    private EntidadCreditosCxcService service;
    @Mock
    private VentasIssue5DtoMapper mapper;
    @InjectMocks
    private EntidadCreditosCxcController controller;

    @Test
    void list() {
        EntidadCreditosCxc entity = new EntidadCreditosCxc();
        entity.setId(1L);
        when(service.findAll(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toCreditosResponse(entity)).thenReturn(EntidadCreditosCxcResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void get() {
        EntidadCreditosCxc entity = new EntidadCreditosCxc();
        entity.setId(2L);
        when(service.findById(2L)).thenReturn(entity);
        when(mapper.toCreditosResponse(entity)).thenReturn(EntidadCreditosCxcResponse.builder().id(2L).build());
        assertThat(controller.get(2L).getData().getId()).isEqualTo(2L);
    }

    @Test
    void create_update_activar_desactivar_delete() {
        EntidadCreditosCxcRequest req = new EntidadCreditosCxcRequest();
        EntidadCreditosCxc entity = new EntidadCreditosCxc();
        entity.setId(3L);
        EntidadCreditosCxcResponse resp = EntidadCreditosCxcResponse.builder().id(3L).build();

        when(service.create(req)).thenReturn(entity);
        when(mapper.toCreditosResponse(entity)).thenReturn(resp);
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.update(eq(3L), eq(req))).thenReturn(entity);
        assertThat(controller.update(3L, req).isSuccess()).isTrue();

        when(service.activar(3L)).thenReturn(entity);
        assertThat(controller.activar(3L).isSuccess()).isTrue();

        when(service.desactivar(3L)).thenReturn(entity);
        assertThat(controller.desactivar(3L).isSuccess()).isTrue();

        assertThat(controller.delete(3L).isSuccess()).isTrue();
        verify(service).delete(3L);

    }

    @Test
    void create() {
        EntidadCreditosCxcRequest request = new EntidadCreditosCxcRequest();
        request.setEntidadContribuyenteId(1L);
        request.setMonedaId(1L);
        request.setLimiteCredito(new BigDecimal("5000.00"));
        request.setDiasCredito(30);
        
        when(service.create(any())).thenReturn(new EntidadCreditosCxc());
        when(mapper.toCreditosResponse(any())).thenReturn(EntidadCreditosCxcResponse.builder().id(1L).build());
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test
    void update() {
        EntidadCreditosCxcRequest request = new EntidadCreditosCxcRequest();
        request.setEntidadContribuyenteId(1L);
        request.setMonedaId(1L);
        request.setLimiteCredito(new BigDecimal("10000.00"));
        request.setDiasCredito(45);
        
        when(service.update(anyLong(), any())).thenReturn(new EntidadCreditosCxc());
        when(mapper.toCreditosResponse(any())).thenReturn(EntidadCreditosCxcResponse.builder().id(1L).build());
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }

    @Test
    void activar() {
        when(service.activar(anyLong())).thenReturn(new EntidadCreditosCxc());
        when(mapper.toCreditosResponse(any())).thenReturn(EntidadCreditosCxcResponse.builder().id(1L).build());
        assertThat(controller.activar(1L).isSuccess()).isTrue();
    }

    @Test
    void desactivar() {
        when(service.desactivar(anyLong())).thenReturn(new EntidadCreditosCxc());
        when(mapper.toCreditosResponse(any())).thenReturn(EntidadCreditosCxcResponse.builder().id(1L).build());
        assertThat(controller.desactivar(1L).isSuccess()).isTrue();
    }

    @Test
    void delete() {
        doNothing().when(service).delete(anyLong());
        assertThat(controller.delete(1L).isSuccess()).isTrue();
    }
}
