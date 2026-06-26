package pe.restaurant.core.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.Authentication;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.DefinitiveTokenClaims;
import pe.restaurant.common.security.JwtDefinitiveTokenResolver;
import pe.restaurant.core.dto.SucursalDto;
import pe.restaurant.core.dto.UsuarioSucursalSyncResponse;
import pe.restaurant.core.service.SucursalMaestroService;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EmpresaSucursalControllerTest {

    @Mock private SucursalMaestroService sucursalMaestroService;
    @Mock private JwtDefinitiveTokenResolver tokenResolver;
    @InjectMocks private EmpresaSucursalController controller;

    private static final String SECRET = "test-secret-123";

    @BeforeEach
    void setUp() throws Exception {
        Field f = EmpresaSucursalController.class.getDeclaredField("provisionSecret");
        f.setAccessible(true);
        f.set(controller, SECRET);
    }

    private HttpServletRequest mockRequestWithSecret(String secret) {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(secret);
        return req;
    }

    private Authentication mockAuthAdminEmpresa(long userId, long empresaId) {
        Authentication auth = mock(Authentication.class);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.isTemporal()).thenReturn(false);
        when(claims.getUserId()).thenReturn(userId);
        when(claims.getEmpresaId()).thenReturn(empresaId);
        when(auth.getDetails()).thenReturn(claims);
        return auth;
    }

    @Test
    void listarSucursalesCompletas_conSecretValido_retornaLista() {
        HttpServletRequest req = mockRequestWithSecret(SECRET);
        var sucursal = SucursalDto.builder().id(1L).codigo("LM").nombre("Central").build();
        when(sucursalMaestroService.listarSucursalesCompletasPorEmpresa(1L))
                .thenReturn(List.of(sucursal));

        var result = controller.listarSucursalesCompletas(req, null, 1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getCodigo()).isEqualTo("LM");
        verify(sucursalMaestroService, never()).requireUsuarioEsAdminEmpresa(anyLong(), anyLong());
    }

    @Test
    void listarSucursalesCompletas_sinSecret_sinAuth_lanzaExcepcion() {
        HttpServletRequest req = mockRequestWithSecret(null);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());
        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conJwtAdmin_ok() {
        HttpServletRequest req = mockRequestWithSecret(null);
        Authentication auth = mockAuthAdminEmpresa(10L, 1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());
        var sucursal = SucursalDto.builder().id(1L).codigo("LM").nombre("Central").build();
        when(sucursalMaestroService.listarSucursalesCompletasPorEmpresa(1L))
                .thenReturn(List.of(sucursal));
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);

        var result = controller.listarSucursalesCompletas(req, auth, 1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
        verify(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);
    }

    @Test
    void listarSucursalesCompletas_secretInvalido_lanzaExcepcion() {
        HttpServletRequest req = mockRequestWithSecret("wrong-secret");
        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesAsignadasUsuario_sinSecret_conJwtAdmin_ok() {
        HttpServletRequest req = mockRequestWithSecret(null);
        Authentication auth = mockAuthAdminEmpresa(10L, 1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());
        var sucursal = SucursalDto.builder().id(2L).codigo("PI").nombre("Norte").build();
        when(sucursalMaestroService.listarSucursalesPorUsuario(5L, 1L))
                .thenReturn(List.of(sucursal));
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);

        var result = controller.listarSucursalesAsignadasAUsuario(req, auth, 1L, 5L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
        verify(sucursalMaestroService).listarSucursalesPorUsuario(5L, 1L);
    }

    @Test
    void listarSucursalesDelUsuario_retornaListaDelUsuario() {
        Authentication auth = mock(Authentication.class);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.getUserId()).thenReturn(5L);
        when(auth.getDetails()).thenReturn(claims);
        var sucursal = SucursalDto.builder().id(2L).codigo("PI").nombre("Norte").build();
        when(sucursalMaestroService.listarSucursalesPorUsuario(5L, 1L))
                .thenReturn(List.of(sucursal));

        var result = controller.listarSucursalesDelUsuario(auth, 1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
        verify(sucursalMaestroService).listarSucursalesPorUsuario(5L, 1L);
    }

    @Test
    void listarSucursalesDelUsuario_sinAuth_lanzaExcepcion() {
        assertThatThrownBy(() -> controller.listarSucursalesDelUsuario(null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void asociarUsuarioASucursal_conSecretValido_retornaOk() {
        HttpServletRequest req = mockRequestWithSecret(SECRET);
        var resp = UsuarioSucursalSyncResponse.builder()
                .usuarioId(5L).sucursalId(2L).flagEstado("1")
                .mensaje("Sucursal 2 asignada").build();
        when(sucursalMaestroService.asociarUsuarioASucursal(1L, 5L, 2L)).thenReturn(resp);

        var result = controller.asociarUsuarioASucursal(req, null, 1L, 5L, 2L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getFlagEstado()).isEqualTo("1");
    }

    @Test
    void retirarUsuarioDeSucursal_conSecretValido_retornaOk() {
        HttpServletRequest req = mockRequestWithSecret(SECRET);
        var resp = UsuarioSucursalSyncResponse.builder()
                .usuarioId(5L).sucursalId(2L).flagEstado("0")
                .mensaje("Sucursal 2 retirada").build();
        when(sucursalMaestroService.retirarUsuarioDeSucursal(1L, 5L, 2L)).thenReturn(resp);

        var result = controller.retirarUsuarioDeSucursal(req, null, 1L, 5L, 2L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getFlagEstado()).isEqualTo("0");
    }

    @Test
    void asociarUsuarioASucursal_sinSecret_conJwtAdmin_llamaServicio() {
        HttpServletRequest req = mockRequestWithSecret(null);
        Authentication auth = mockAuthAdminEmpresa(10L, 1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());
        var resp = UsuarioSucursalSyncResponse.builder()
                .usuarioId(5L).sucursalId(2L).flagEstado("1")
                .mensaje("ok").build();
        when(sucursalMaestroService.asociarUsuarioASucursal(1L, 5L, 2L)).thenReturn(resp);
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);

        var result = controller.asociarUsuarioASucursal(req, auth, 1L, 5L, 2L);

        assertThat(result.isSuccess()).isTrue();
        verify(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conTokenResolverDefinitivo_noAdmin_ok() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.isTemporal()).thenReturn(false);
        when(claims.getUserId()).thenReturn(10L);
        when(claims.getEmpresaId()).thenReturn(1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.of(claims));
        when(sucursalMaestroService.isAdminSistema(10L)).thenReturn(false);
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);
        when(sucursalMaestroService.listarSucursalesCompletasPorEmpresa(1L))
                .thenReturn(List.of());

        var result = controller.listarSucursalesCompletas(req, null, 1L);

        assertThat(result.isSuccess()).isTrue();
        verify(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conTokenResolverDefinitivo_adminSistema_ok() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.getUserId()).thenReturn(10L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.of(claims));
        when(sucursalMaestroService.isAdminSistema(10L)).thenReturn(true);
        when(sucursalMaestroService.listarSucursalesCompletasPorEmpresa(1L))
                .thenReturn(List.of());

        var result = controller.listarSucursalesCompletas(req, null, 1L);

        assertThat(result.isSuccess()).isTrue();
        verify(sucursalMaestroService, never()).requireUsuarioEsAdminEmpresa(anyLong(), anyLong());
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conTokenResolverTemporal_lanzaExcepcion() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.getUserId()).thenReturn(10L);
        when(claims.isTemporal()).thenReturn(true);
        when(tokenResolver.resolve(any())).thenReturn(Optional.of(claims));
        when(sucursalMaestroService.isAdminSistema(10L)).thenReturn(false);

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conTokenResolverDefinitivo_empresaMismatch_lanzaExcepcion() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.isTemporal()).thenReturn(false);
        when(claims.getUserId()).thenReturn(10L);
        when(claims.getEmpresaId()).thenReturn(99L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.of(claims));
        when(sucursalMaestroService.isAdminSistema(10L)).thenReturn(false);

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesDelUsuario_conDetailsNumber_retornaUserId() {
        Authentication auth = mock(Authentication.class);
        when(auth.getDetails()).thenReturn(42L);
        when(sucursalMaestroService.listarSucursalesPorUsuario(42L, 1L))
                .thenReturn(List.of());

        var result = controller.listarSucursalesDelUsuario(auth, 1L);

        assertThat(result.isSuccess()).isTrue();
        verify(sucursalMaestroService).listarSucursalesPorUsuario(42L, 1L);
    }

    @Test
    void listarSucursalesDelUsuario_conDetailsNoValido_lanzaExcepcion() {
        Authentication auth = mock(Authentication.class);
        when(auth.getDetails()).thenReturn("not-a-claims-or-number");

        assertThatThrownBy(() -> controller.listarSucursalesDelUsuario(auth, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesDelUsuario_conDetailsNull_lanzaExcepcion() {
        Authentication auth = mock(Authentication.class);
        when(auth.getDetails()).thenReturn(null);

        assertThatThrownBy(() -> controller.listarSucursalesDelUsuario(auth, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void resolveProvisionOrJwtAdmin_secretBlank_usaFallbackAuth() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn("   ");
        when(req.getHeader("Authorization")).thenReturn(null);
        when(tokenResolver.resolve(null)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, null, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void retirarUsuarioDeSucursal_sinSecret_conJwtAdmin_llamaServicio() {
        HttpServletRequest req = mockRequestWithSecret(null);
        Authentication auth = mockAuthAdminEmpresa(10L, 1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());
        var resp = UsuarioSucursalSyncResponse.builder()
                .usuarioId(5L).sucursalId(2L).flagEstado("0")
                .mensaje("ok").build();
        when(sucursalMaestroService.retirarUsuarioDeSucursal(1L, 5L, 2L)).thenReturn(resp);
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(10L, 1L);

        var result = controller.retirarUsuarioDeSucursal(req, auth, 1L, 5L, 2L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getFlagEstado()).isEqualTo("0");
    }

    @Test
    void listarSucursalesCompletas_sinSecret_sinAuth_conTokenDefinitoNull_lanzaExcepcion() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        when(req.getHeader("Authorization")).thenReturn("Bearer something");
        when(tokenResolver.resolve("Bearer something")).thenReturn(Optional.empty());

        Authentication auth = mock(Authentication.class);
        when(auth.getDetails()).thenReturn("invalid");

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, auth, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_sinAuth_fallback_temporal_lanzaExcepcion() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());

        Authentication auth = mock(Authentication.class);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.isTemporal()).thenReturn(true);
        when(auth.getDetails()).thenReturn(claims);

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, auth, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_sinAuth_fallback_empresaNull_lanzaExcepcion() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        when(tokenResolver.resolve(any())).thenReturn(Optional.empty());

        Authentication auth = mock(Authentication.class);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.isTemporal()).thenReturn(false);
        when(claims.getEmpresaId()).thenReturn(null);
        when(auth.getDetails()).thenReturn(claims);

        assertThatThrownBy(() -> controller.listarSucursalesCompletas(req, auth, 1L))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    void listarSucursalesCompletas_sinSecret_conTokenResolverDefinitivo_userIdNull_validaAdmin() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Provision-Secret")).thenReturn(null);
        DefinitiveTokenClaims claims = mock(DefinitiveTokenClaims.class);
        when(claims.getUserId()).thenReturn(null);
        when(claims.isTemporal()).thenReturn(false);
        when(claims.getEmpresaId()).thenReturn(1L);
        when(tokenResolver.resolve(any())).thenReturn(Optional.of(claims));
        doNothing().when(sucursalMaestroService).requireUsuarioEsAdminEmpresa(null, 1L);
        when(sucursalMaestroService.listarSucursalesCompletasPorEmpresa(1L))
                .thenReturn(List.of());

        var result = controller.listarSucursalesCompletas(req, null, 1L);

        assertThat(result.isSuccess()).isTrue();
    }
}
