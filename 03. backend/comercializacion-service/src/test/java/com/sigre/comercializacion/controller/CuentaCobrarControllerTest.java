package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.CuentaCobrarAnularRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarMovimientoRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarRequest;
import com.sigre.comercializacion.dto.response.CuentaCobrarResponse;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.service.CuentaCobrarService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CuentaCobrarControllerTest {

    @Mock
    private CuentaCobrarService cuentaCobrarService;
    @Mock
    private com.sigre.comercializacion.mapper.CuentaCobrarMapper mapper;
    @InjectMocks
    private CuentaCobrarController controller;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void findAll() {
        CuentaCobrar cc = CuentaCobrar.builder().id(1L).serie("F001").build();
        when(cuentaCobrarService.findAllWithFilters(
                isNull(), isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(cc)));
        when(mapper.toListItemResponseList(anyList()))
                .thenReturn(List.of(CuentaCobrarResponse.CuentaCobrarListItemResponse.builder().id(1L).build()));
        var r = controller.findAll(0, 20, "fechaEmision,desc", null, null, null, null, null, null);
        assertThat(r.getStatusCode().is2xxSuccessful()).isTrue();
        assertThat(r.getBody()).isNotNull();
        assertThat(r.getBody().isSuccess()).isTrue();
    }

    @Test
    void findById() {
        CuentaCobrar cc = new CuentaCobrar();
        cc.setId(1L);
        when(cuentaCobrarService.findByIdWithMovimientos(1L)).thenReturn(cc);
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(1L)).thenReturn(Collections.emptyList());
        when(mapper.toResponse(eq(cc), anyList()))
                .thenReturn(com.sigre.comercializacion.dto.response.CuentaCobrarResponse.builder().id(1L).build());
        var r = controller.findById(1L);
        assertThat(r.getStatusCode().is2xxSuccessful()).isTrue();
        assertThat(r.getBody().getData().getId()).isEqualTo(1L);
    }

    @Test
    void findMovimientos() {
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(1L)).thenReturn(List.of(
                CuentaCobrarDet.builder()
                        .id(10L)
                        .fechaMov(LocalDate.of(2026, 5, 1))
                        .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                        .monto(new java.math.BigDecimal("10.00"))
                        .build()
        ));
        var r = controller.findMovimientos(1L);
        assertThat(r.getStatusCode().is2xxSuccessful()).isTrue();
        assertThat(r.getBody()).isNotNull();
        assertThat(r.getBody().getData()).hasSize(1);
    }

    @Test
    void create_update_activar_desactivar_delete_movimiento_anular() {
        CuentaCobrarRequest req = CuentaCobrarRequest.builder()
                .sucursalId(1L)
                .clienteId(2L)
                .docTipoId(1L)
                .serie("F001")
                .numero("00001")
                .fechaEmision(LocalDate.now())
                .total(new BigDecimal("100"))
                .saldo(new BigDecimal("100"))
                .build();

        CuentaCobrar saved = CuentaCobrar.builder().id(5L).serie("F001").build();
        CuentaCobrarResponse resp = CuentaCobrarResponse.builder().id(5L).build();

        when(cuentaCobrarService.create(any(), any(), eq(1L))).thenReturn(saved);
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(5L)).thenReturn(List.of());
        when(mapper.toResponse(eq(saved), anyList())).thenReturn(resp);

        assertThat(controller.create(req).getStatusCode().value()).isEqualTo(201);

        when(cuentaCobrarService.update(eq(5L), any(), eq(1L))).thenReturn(saved);
        assertThat(controller.update(5L, req).getBody().isSuccess()).isTrue();

        when(cuentaCobrarService.activar(5L, 1L)).thenReturn(saved);
        assertThat(controller.activar(5L).getBody().isSuccess()).isTrue();

        when(cuentaCobrarService.desactivar(5L, 1L)).thenReturn(saved);
        assertThat(controller.desactivar(5L).getBody().isSuccess()).isTrue();

        assertThat(controller.delete(5L).getBody().isSuccess()).isTrue();
        verify(cuentaCobrarService).delete(5L, 1L);

        CuentaCobrarMovimientoRequest movReq = CuentaCobrarMovimientoRequest.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(1L)
                .build();
        when(cuentaCobrarService.registrarMovimiento(eq(5L), any(), eq(1L))).thenReturn(saved);
        assertThat(controller.registrarMovimiento(5L, movReq).getBody().isSuccess()).isTrue();

        when(cuentaCobrarService.anular(eq(5L), eq("motivo"), eq(1L))).thenReturn(saved);
        assertThat(controller.anular(5L, CuentaCobrarAnularRequest.builder().motivo("motivo").build())
                .getBody().isSuccess()).isTrue();
    }

    @Test
    void findAll_sinDireccionSort() {
        CuentaCobrar cc = CuentaCobrar.builder().id(2L).serie("F002").build();
        when(cuentaCobrarService.findAllWithFilters(
                isNull(), isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(cc)));
        when(mapper.toListItemResponseList(anyList()))
                .thenReturn(List.of(CuentaCobrarResponse.CuentaCobrarListItemResponse.builder().id(2L).build()));
        var r = controller.findAll(0, 20, "fechaEmision", null, null, null, null, null, null);
        assertThat(r.getStatusCode().is2xxSuccessful()).isTrue();
    }

    @Test
    void findAll_conAscSort() {
        CuentaCobrar cc = CuentaCobrar.builder().id(3L).serie("F003").build();
        when(cuentaCobrarService.findAllWithFilters(
                isNull(), isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(cc)));
        when(mapper.toListItemResponseList(anyList()))
                .thenReturn(List.of(CuentaCobrarResponse.CuentaCobrarListItemResponse.builder().id(3L).build()));
        var r = controller.findAll(0, 20, "fechaEmision,asc", null, null, null, null, null, null);
        assertThat(r.getStatusCode().is2xxSuccessful()).isTrue();
    }

    @Test
    void create_conMovimientos() {
        CuentaCobrarMovimientoRequest mov = CuentaCobrarMovimientoRequest.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("50"))
                .conceptoFinancieroId(1L)
                .build();
        CuentaCobrarRequest req = CuentaCobrarRequest.builder()
                .sucursalId(1L).clienteId(2L).docTipoId(1L)
                .serie("F001").numero("00002")
                .fechaEmision(LocalDate.now())
                .total(new BigDecimal("50")).saldo(new BigDecimal("50"))
                .movimientos(List.of(mov))
                .build();

        CuentaCobrar saved = CuentaCobrar.builder().id(6L).serie("F001").build();
        when(cuentaCobrarService.create(any(), argThat(list -> list != null && !list.isEmpty()), eq(1L)))
                .thenReturn(saved);
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(6L)).thenReturn(List.of());
        when(mapper.toResponse(eq(saved), anyList()))
                .thenReturn(CuentaCobrarResponse.builder().id(6L).build());

        var r = controller.create(req);
        assertThat(r.getStatusCode().value()).isEqualTo(201);
    }

    @Test
    void create_conMovimientosVacio() {
        CuentaCobrarRequest req = CuentaCobrarRequest.builder()
                .sucursalId(1L).clienteId(2L).docTipoId(1L)
                .serie("F001").numero("00003")
                .fechaEmision(LocalDate.now())
                .total(new BigDecimal("100")).saldo(new BigDecimal("100"))
                .movimientos(List.of())
                .build();

        CuentaCobrar saved = CuentaCobrar.builder().id(7L).serie("F001").build();
        when(cuentaCobrarService.create(any(), isNull(), eq(1L)))
                .thenReturn(saved);
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(7L)).thenReturn(List.of());
        when(mapper.toResponse(eq(saved), anyList()))
                .thenReturn(CuentaCobrarResponse.builder().id(7L).build());

        var r = controller.create(req);
        assertThat(r.getStatusCode().value()).isEqualTo(201);
    }

    @Test
    void anular_sinRequestBody() {
        CuentaCobrar saved = CuentaCobrar.builder().id(8L).serie("F001").build();
        when(cuentaCobrarService.anular(eq(8L), isNull(), eq(1L))).thenReturn(saved);
        when(cuentaCobrarService.findMovimientosByCuentaCobrarId(8L)).thenReturn(List.of());
        when(mapper.toResponse(eq(saved), anyList()))
                .thenReturn(CuentaCobrarResponse.builder().id(8L).build());

        var r = controller.anular(8L, null);
        assertThat(r.getBody().isSuccess()).isTrue();
    }
}
