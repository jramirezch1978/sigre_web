package pe.restaurant.core.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.tenant.EmpresaTenantConnectionService;
import pe.restaurant.common.tenant.TenantConnectionInfo;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SucursalMaestroServiceTest {

    @Mock
    private EmpresaTenantConnectionService tenantConnectionService;

    @Mock
    private JdbcTemplate securityJdbcTemplate;

    private SucursalMaestroService service;

    private TenantConnectionInfo fakeConnInfo;

    @BeforeEach
    void setUp() {
        service = new SucursalMaestroService(tenantConnectionService, securityJdbcTemplate);
        fakeConnInfo = TenantConnectionInfo.builder()
                .empresaId(1L).codigo("E01")
                .jdbcUrl("jdbc:postgresql://fakehost:5432/fakedb")
                .username("user").password("pass").build();
    }

    @Nested
    class IsAdminSistema {

        @Test
        void returnsTrue_whenCountGreaterThanZero() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            assertThat(service.isAdminSistema(10L)).isTrue();
        }

        @Test
        void returnsFalse_whenCountIsZero() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L)))
                    .thenReturn(0);
            assertThat(service.isAdminSistema(10L)).isFalse();
        }

        @Test
        void returnsFalse_whenCountIsNull() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L)))
                    .thenReturn(null);
            assertThat(service.isAdminSistema(10L)).isFalse();
        }
    }

    @Nested
    class RequireUsuarioEsAdminEmpresa {

        @Test
        void throws_whenUsuarioNotInEmpresa() {
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.requireUsuarioEsAdminEmpresa(5L, 1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.BAD_REQUEST);
                        assertThat(be.getErrorCode()).isEqualTo("EMPRESA_NO_ASIGNADA");
                    });
        }

        @Test
        void throws_whenUsuarioNotInEmpresaNull() {
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(null);

            assertThatThrownBy(() -> service.requireUsuarioEsAdminEmpresa(5L, 1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("EMPRESA_NO_ASIGNADA");
                    });
        }

        @Test
        void throws_whenUsuarioNotAdmin() {
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(1);
            when(securityJdbcTemplate.queryForObject(
                    contains("rol_usuario"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.requireUsuarioEsAdminEmpresa(5L, 1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.FORBIDDEN);
                        assertThat(be.getErrorCode()).isEqualTo("SEGURIDAD_ADMIN_REQUERIDO");
                    });
        }

        @Test
        void throws_whenAdminCountNull() {
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(1);
            when(securityJdbcTemplate.queryForObject(
                    contains("rol_usuario"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(null);

            assertThatThrownBy(() -> service.requireUsuarioEsAdminEmpresa(5L, 1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("SEGURIDAD_ADMIN_REQUERIDO");
                    });
        }

        @Test
        void doesNotThrow_whenUsuarioIsAdmin() {
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(1);
            when(securityJdbcTemplate.queryForObject(
                    contains("rol_usuario"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(1);

            service.requireUsuarioEsAdminEmpresa(5L, 1L);
        }
    }

    @Nested
    class ListarSucursalesCompletasPorEmpresa {

        @Test
        void throwsBusinessException_whenConnectionFails() {
            when(tenantConnectionService.getTenantConnection(1L)).thenReturn(fakeConnInfo);

            assertThatThrownBy(() -> service.listarSucursalesCompletasPorEmpresa(1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.INTERNAL_SERVER_ERROR);
                        assertThat(be.getErrorCode()).isEqualTo("SUCURSALES_ERROR");
                    });
        }
    }

    @Nested
    class ListarSucursalesPorUsuario {

        @Test
        void throwsBusinessException_whenConnectionFails() {
            when(tenantConnectionService.getTenantConnection(1L)).thenReturn(fakeConnInfo);

            assertThatThrownBy(() -> service.listarSucursalesPorUsuario(99L, 1L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("SUCURSALES_ERROR");
                    });
        }
    }

    @Nested
    class AsociarUsuarioASucursal {

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenUsuarioNotFound() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(99L)))
                    .thenReturn(Collections.emptyList());

            assertThatThrownBy(() -> service.asociarUsuarioASucursal(1L, 99L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                        assertThat(be.getErrorCode()).isEqualTo("USUARIO_NO_ENCONTRADO");
                    });
        }

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenEmpresaNotFound() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(5L)))
                    .thenReturn(List.of("admin"));
            when(securityJdbcTemplate.query(contains("master.empresa"), any(RowMapper.class), eq(99L)))
                    .thenReturn(Collections.emptyList());

            assertThatThrownBy(() -> service.asociarUsuarioASucursal(99L, 5L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                        assertThat(be.getErrorCode()).isEqualTo("EMPRESA_NO_ENCONTRADA");
                    });
        }

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenUsuarioNotAssignedToEmpresa() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(5L)))
                    .thenReturn(List.of("admin"));
            when(securityJdbcTemplate.query(contains("master.empresa"), any(RowMapper.class), eq(1L)))
                    .thenAnswer(invocation -> {
                        RowMapper<?> rm = invocation.getArgument(1);
                        var mockRs = mock(java.sql.ResultSet.class);
                        when(mockRs.getLong("id")).thenReturn(1L);
                        when(mockRs.getString("codigo")).thenReturn("E01");
                        return List.of(rm.mapRow(mockRs, 0));
                    });
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.asociarUsuarioASucursal(1L, 5L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("EMPRESA_NO_ASIGNADA");
                    });
        }

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenSucursalValidationFails() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(5L)))
                    .thenReturn(List.of("admin"));
            when(securityJdbcTemplate.query(contains("master.empresa"), any(RowMapper.class), eq(1L)))
                    .thenAnswer(invocation -> {
                        RowMapper<?> rm = invocation.getArgument(1);
                        var mockRs = mock(java.sql.ResultSet.class);
                        when(mockRs.getLong("id")).thenReturn(1L);
                        when(mockRs.getString("codigo")).thenReturn("E01");
                        return List.of(rm.mapRow(mockRs, 0));
                    });
            when(securityJdbcTemplate.queryForObject(
                    contains("usuario_empresa"), eq(Integer.class), eq(5L), eq(1L)))
                    .thenReturn(1);
            when(tenantConnectionService.getTenantConnection(1L)).thenReturn(fakeConnInfo);

            assertThatThrownBy(() -> service.asociarUsuarioASucursal(1L, 5L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("SUCURSALES_ERROR");
                    });
        }
    }

    @Nested
    class RetirarUsuarioDeSucursal {

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenUsuarioNotFound() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(99L)))
                    .thenReturn(Collections.emptyList());

            assertThatThrownBy(() -> service.retirarUsuarioDeSucursal(1L, 99L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                        assertThat(be.getErrorCode()).isEqualTo("USUARIO_NO_ENCONTRADO");
                    });
        }

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenEmpresaNotFound() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(5L)))
                    .thenReturn(List.of("admin"));
            when(securityJdbcTemplate.query(contains("master.empresa"), any(RowMapper.class), eq(99L)))
                    .thenReturn(Collections.emptyList());

            assertThatThrownBy(() -> service.retirarUsuarioDeSucursal(99L, 5L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getStatus()).isEqualTo(HttpStatus.NOT_FOUND);
                        assertThat(be.getErrorCode()).isEqualTo("EMPRESA_NO_ENCONTRADA");
                    });
        }

        @Test
        @SuppressWarnings("unchecked")
        void throws_whenTenantConnectionFails() {
            when(securityJdbcTemplate.query(contains("auth.usuario"), any(RowMapper.class), eq(5L)))
                    .thenReturn(List.of("admin"));
            when(securityJdbcTemplate.query(contains("master.empresa"), any(RowMapper.class), eq(1L)))
                    .thenAnswer(invocation -> {
                        RowMapper<?> rm = invocation.getArgument(1);
                        var mockRs = mock(java.sql.ResultSet.class);
                        when(mockRs.getLong("id")).thenReturn(1L);
                        when(mockRs.getString("codigo")).thenReturn("E01");
                        return List.of(rm.mapRow(mockRs, 0));
                    });
            when(tenantConnectionService.getTenantConnection(1L)).thenReturn(fakeConnInfo);

            assertThatThrownBy(() -> service.retirarUsuarioDeSucursal(1L, 5L, 10L))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo("USUARIO_SUCURSAL_ERROR");
                    });
        }
    }
}
