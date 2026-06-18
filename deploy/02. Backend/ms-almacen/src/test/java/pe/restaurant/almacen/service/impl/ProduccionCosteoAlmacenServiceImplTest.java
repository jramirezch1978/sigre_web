package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.almacen.event.CosteoPeriodoProcesadoEvent;
import pe.restaurant.almacen.event.publisher.AlmacenPreAsientoPublisher;
import pe.restaurant.common.security.TenantContext;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ProduccionCosteoAlmacenServiceImplTest {

    @Mock
    private JdbcTemplate jdbcTemplate;
    @Mock
    private AlmacenPreAsientoPublisher preAsientoPublisher;

    private ProduccionCosteoAlmacenServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new ProduccionCosteoAlmacenServiceImpl(jdbcTemplate, preAsientoPublisher);
        TenantContext.setUsuarioId(99L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void aplicarCosteoEnAlmacen_sinCosteos_retornaCero() {
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class),
                ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any()))
                .thenReturn(0);

        var evento = CosteoPeriodoProcesadoEvent.builder()
                .anio(2026)
                .mes(5)
                .empresaId(1L)
                .build();

        var out = service.aplicarCosteoEnAlmacen(evento);

        assertThat(out.getCosteosEnPeriodo()).isZero();
        assertThat(out.getLineasValeActualizadas()).isZero();
        assertThat(out.getArticulosAlmacenActualizados()).isZero();
    }

    @Test
    void aplicarCosteoEnAlmacen_actualizaValesYArticulos() {
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class),
                ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any()))
                .thenReturn(3);
        when(jdbcTemplate.update(anyString(),
                ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any(),
                ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any(),
                ArgumentMatchers.any(), ArgumentMatchers.any(), ArgumentMatchers.any(),
                ArgumentMatchers.any(), ArgumentMatchers.any()))
                .thenReturn(5, 4);

        var evento = CosteoPeriodoProcesadoEvent.builder()
                .anio(2026)
                .mes(5)
                .empresaId(1L)
                .sucursalFiltroId(2L)
                .usuarioId(10L)
                .build();

        var out = service.aplicarCosteoEnAlmacen(evento);

        assertThat(out.getCosteosEnPeriodo()).isEqualTo(3);
        assertThat(out.getLineasValeActualizadas()).isEqualTo(5);
        assertThat(out.getArticulosAlmacenActualizados()).isEqualTo(4);
        verify(preAsientoPublisher).publicarCosteoProduccion(evento, 3, 5);
    }
}
