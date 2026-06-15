package com.sigre.comercializacion.service;

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
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.mockConstruction;

@ExtendWith(MockitoExtension.class)
class TestDataSeedServiceTest {

    @Mock
    private DataSource dataSource;

    @InjectMocks
    private TestDataSeedService service;

    @Test
    void seedVentasDemoData_devuelveContadores() {
        try (MockedConstruction<JdbcTemplate> construction = mockConstruction(JdbcTemplate.class,
                (mock, context) -> {
                    lenient().when(mock.update(anyString())).thenReturn(3);
                    lenient().when(mock.update(anyString(), any(Object[].class))).thenReturn(3);
                    lenient().when(mock.queryForObject(anyString(), eq(Long.class))).thenReturn(1L);
                })) {

            Map<String, Integer> result = service.seedVentasDemoData();

            assertThat(construction.constructed()).hasSize(1);
            assertThat(result).isNotEmpty();
            assertThat(result.values().stream().mapToInt(Integer::intValue).sum()).isGreaterThan(0);
        }
    }
}
