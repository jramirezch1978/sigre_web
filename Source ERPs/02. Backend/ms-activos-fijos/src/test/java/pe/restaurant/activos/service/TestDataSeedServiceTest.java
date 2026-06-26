package pe.restaurant.activos.service;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import pe.restaurant.common.exception.BusinessException;

import java.sql.SQLException;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TestDataSeedServiceTest {

    @Mock
    private JdbcTemplate jdbcTemplate;
    @InjectMocks
    private TestDataSeedService service;

    @Nested
    class AssertSeedPreconditions {

        @Test
        void failsWhenFirstTableMissing() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), eq("af_clase")))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Falta la tabla")
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.SEED_BD_INCOMPATIBLE);
        }

        @Test
        void failsWhenMiddleTableMissing() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), eq("af_clase")))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), eq("af_sub_clase")))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), eq("af_ubicacion")))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Falta la tabla");
        }
    }

    @Nested
    class ResolveSucursalIdForSeed {

        @Test
        void usesExistingSucursalWhenTableExists() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(42L);
            stubColumnExistsForMaestro(false);
            stubDeletesAndInserts();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result).isNotNull();
            verify(jdbcTemplate, never()).execute(contains("CREATE SCHEMA"));
        }

        @Test
        void createsSucursalTableWhenMissing() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(0);
            doNothing().when(jdbcTemplate).execute(anyString());
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(null);
            when(jdbcTemplate.update(contains("INSERT INTO auth.sucursal"), anyString(), anyString()))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal WHERE codigo"), any(ResultSetExtractor.class), anyString()))
                    .thenReturn(100L);
            stubColumnExistsForMaestro(false);
            stubDeletesAndInserts();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result).isNotNull();
        }

        @Test
        void throwsWhenNoSucursalCanBeCreated() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(0);
            doNothing().when(jdbcTemplate).execute(anyString());
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(null);
            when(jdbcTemplate.update(contains("INSERT INTO auth.sucursal"), anyString(), anyString()))
                    .thenReturn(0);
            when(jdbcTemplate.query(contains("auth.sucursal WHERE codigo"), any(ResultSetExtractor.class), anyString()))
                    .thenReturn(null);

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.SEED_SIN_SUCURSAL);
        }

        @Test
        void fallsBackToFirstSucursalWhenCodigoQueryReturnsNull() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(0);
            doNothing().when(jdbcTemplate).execute(anyString());
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(null)
                    .thenReturn(55L);
            when(jdbcTemplate.update(contains("INSERT INTO auth.sucursal"), anyString(), anyString()))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal WHERE codigo"), any(ResultSetExtractor.class), anyString()))
                    .thenReturn(null);
            stubColumnExistsForMaestro(false);
            stubDeletesAndInserts();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result).isNotNull();
        }
    }

    @Nested
    class ExceptionHandling {

        @Test
        void wrapsDataAccessException() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenThrow(new DataAccessResourceFailureException("connection refused"));

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Fallo al ejecutar seed")
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.SEED_BD_INCOMPATIBLE);
        }

        @Test
        void wrapsSqlExceptionInsideRuntimeException() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            SQLException sqlEx = new SQLException("duplicate key");
            RuntimeException wrapper = new RuntimeException(sqlEx);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenThrow(wrapper);

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Fallo al ejecutar seed");
        }

        @Test
        void rethrowsNonSqlRuntimeException() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenThrow(new IllegalStateException("unexpected"));

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessage("unexpected");
        }
    }

    @Nested
    class ColumnChecks {

        @Test
        void insertsWithUnidadesColumnWhenExists() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(1L);
            stubColumnExistsForMaestro(true);
            stubDeletesAndInserts();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result).containsKey("activos.af_maestro");
        }

        @Test
        void insertsWithoutUnidadesColumnWhenNotExists() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(1L);
            stubColumnExistsForMaestro(false);
            stubDeletesAndInserts();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result).containsKey("activos.af_maestro");
        }
    }

    @Nested
    class TableExistsCheck {

        @Test
        void returnsFalseWhenCountIsNull() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), eq("af_clase")))
                    .thenReturn(null);

            assertThatThrownBy(() -> service.seedActivosDemoData())
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Falta la tabla");
        }
    }

    @Nested
    class Annotations {

        @Test
        void classHasServiceAnnotation() {
            assertThat(TestDataSeedService.class
                    .isAnnotationPresent(org.springframework.stereotype.Service.class))
                    .isTrue();
        }

        @Test
        void classHasTransactionalMethod() throws NoSuchMethodException {
            var method = TestDataSeedService.class.getMethod("seedActivosDemoData");
            assertThat(method.isAnnotationPresent(
                    org.springframework.transaction.annotation.Transactional.class)).isTrue();
        }
    }

    @Nested
    class ValuacionTableCheck {

        @Test
        void skipsValuacionInsertWhenTableNotExists() {
            stubAllActivosTablesExist();
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("auth"), eq("sucursal")))
                    .thenReturn(1);
            when(jdbcTemplate.query(contains("auth.sucursal ORDER BY id"), any(ResultSetExtractor.class)))
                    .thenReturn(1L);
            stubColumnExistsForMaestro(false);
            when(jdbcTemplate.queryForObject(contains("information_schema.tables"),
                    eq(Integer.class), eq("activos"), eq("af_valuacion")))
                    .thenReturn(0);
            stubDeletesAndInsertsNoValuacion();

            Map<String, Integer> result = service.seedActivosDemoData();
            assertThat(result.get("activos.af_valuacion")).isEqualTo(0);
        }
    }

    // --- Helper methods ---

    private void stubAllActivosTablesExist() {
        lenient().when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq("activos"), anyString()))
                .thenReturn(1);
    }

    private void stubColumnExistsForMaestro(boolean exists) {
        lenient().when(jdbcTemplate.queryForObject(contains("information_schema.columns"),
                eq(Integer.class), eq("activos"), eq("af_maestro"), eq("unidades_produccion_totales")))
                .thenReturn(exists ? 1 : 0);
    }

    private void stubDeletesAndInserts() {
        lenient().when(jdbcTemplate.update(anyString(), (Object[]) any())).thenReturn(1);
        lenient().when(jdbcTemplate.update(anyString())).thenReturn(1);
        lenient().when(jdbcTemplate.queryForObject(contains("RETURNING id"), eq(Long.class), (Object[]) any()))
                .thenReturn(1L);
        lenient().when(jdbcTemplate.queryForObject(contains("information_schema.tables"),
                eq(Integer.class), eq("activos"), eq("af_valuacion")))
                .thenReturn(1);
    }

    private void stubDeletesAndInsertsNoValuacion() {
        lenient().when(jdbcTemplate.update(anyString(), (Object[]) any())).thenReturn(1);
        lenient().when(jdbcTemplate.update(anyString())).thenReturn(1);
        lenient().when(jdbcTemplate.queryForObject(contains("RETURNING id"), eq(Long.class), (Object[]) any()))
                .thenReturn(1L);
    }
}
