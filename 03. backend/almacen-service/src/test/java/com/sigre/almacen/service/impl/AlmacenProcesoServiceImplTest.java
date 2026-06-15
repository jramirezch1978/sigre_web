package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.dto.ProcesoAlmacenFiltroRequest;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AlmacenProcesoServiceImplTest {

    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private AlmacenProcesoServiceImpl service;

    @Test
    void recalcularPreciosPromedio_validaEsperadosVsActualizados() {
        ProcesoAlmacenFiltroRequest filtro = new ProcesoAlmacenFiltroRequest();
        filtro.setAlmacenId(10L);

        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object[].class)))
                .thenReturn(5);
        when(jdbcTemplate.update(anyString(), any(Object[].class)))
                .thenReturn(5);

        var out = service.recalcularPreciosPromedio(filtro);

        assertThat(out.getCodigoMenu()).isEqualTo("ALMACEN_PROC_RECALCULO");
        assertThat(out.getProcesados()).isEqualTo(5);
        assertThat(out.getRegistrosEsperados()).isEqualTo(5);
        assertThat(out.getValidacionOk()).isTrue();
    }

    @Test
    void cuadrarStockVsPosiciones_actualizaSoloDiferenciasYValida() {
        ProcesoAlmacenFiltroRequest filtro = new ProcesoAlmacenFiltroRequest();
        filtro.setAlmacenId(3L);

        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object[].class)))
                .thenReturn(10, 4);
        when(jdbcTemplate.update(anyString(), any(Object[].class)))
                .thenReturn(4);

        var out = service.cuadrarStockVsPosiciones(filtro);

        assertThat(out.getCodigoMenu()).isEqualTo("ALMACEN_PROC_CUADRE_STOCK");
        assertThat(out.getProcesados()).isEqualTo(4);
        assertThat(out.getRegistrosEsperados()).isEqualTo(4);
        assertThat(out.getValidacionOk()).isTrue();
        assertThat(out.getDetalleValidacion()).contains("evaluados=10");
    }

    @Test
    void actualizacionAutomatica_agregaResultadosDeAmbosProcesos() {
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object[].class)))
                .thenReturn(8, 3, 6);
        when(jdbcTemplate.update(anyString(), any(Object[].class)))
                .thenReturn(3, 6);

        var out = service.actualizacionAutomatica(null);

        assertThat(out.getCodigoMenu()).isEqualTo("ALMACEN_PROC_ACT_AUTO");
        assertThat(out.getProcesados()).isEqualTo(9);
        assertThat(out.getRegistrosEsperados()).isEqualTo(9);
        assertThat(out.getValidacionOk()).isTrue();
        assertThat(out.getDetalleValidacion()).contains("cuadre={").contains("recalculo={");
    }
}
