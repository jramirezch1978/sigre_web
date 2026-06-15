package com.sigre.almacen.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedConstruction;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.mockConstruction;

@ExtendWith(MockitoExtension.class)
class TestDataSeedServiceTest {

    @Mock
    private DataSource dataSource;

    @InjectMocks
    private TestDataSeedService service;

    @Test
    void seedAlmacenDemoData_devuelveContadoresPorTabla() {
        try (MockedConstruction<JdbcTemplate> construction = mockConstruction(JdbcTemplate.class,
                (mock, context) -> {
                    lenient().when(mock.update(anyString())).thenReturn(5);
                    lenient().when(mock.update(anyString(), any(Object[].class))).thenReturn(5);
                })) {

            Map<String, Integer> result = service.seedAlmacenDemoData();

            assertThat(construction.constructed()).hasSize(1);
            assertThat(result).containsKeys(
                    "core.articulo",
                    "almacen.vale_mov + det",
                    "almacen.guia + det",
                    "almacen.orden_traslado + det",
                    "almacen.articulo_saldo_mensual");
            assertThat(result.get("core.articulo")).isEqualTo(5);
            assertThat(result.get("almacen.ubicacion_almacen")).isEqualTo(5);
        }
    }
}
