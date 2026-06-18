package pe.restaurant.compras.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("EmpresaInfoService — Pruebas Unitarias")
class EmpresaInfoServiceTest {

    @Mock
    private JdbcTemplate securityJdbcTemplate;

    @InjectMocks
    private EmpresaInfoService service;

    @Test
    @DisplayName("obtener() con datos completos -> retorna info con logo")
    void obtener_conDatosCompletos_retornaInfoConLogo() {
        EmpresaInfoService.EmpresaInfo expected = new EmpresaInfoService.EmpresaInfo(
                "Mi Restaurante S.A.C.", "20123456789", "Av. Lima 123", "data:image/png;base64,AAAA", null);

        when(securityJdbcTemplate.query(anyString(), any(ResultSetExtractor.class), eq(1L)))
                .thenReturn(expected);

        EmpresaInfoService.EmpresaInfo result = service.obtener(1L);

        assertThat(result.razonSocial()).isEqualTo("Mi Restaurante S.A.C.");
        assertThat(result.ruc()).isEqualTo("20123456789");
        assertThat(result.direccion()).isEqualTo("Av. Lima 123");
        assertThat(result.logoBase64()).startsWith("data:image/png;base64,");
    }

    @Test
    @DisplayName("obtener() sin datos -> retorna info vacia")
    void obtener_sinDatos_retornaInfoVacia() {
        EmpresaInfoService.EmpresaInfo empty = new EmpresaInfoService.EmpresaInfo("", "", "", null, null);

        when(securityJdbcTemplate.query(anyString(), any(ResultSetExtractor.class), eq(99L)))
                .thenReturn(empty);

        EmpresaInfoService.EmpresaInfo result = service.obtener(99L);

        assertThat(result.razonSocial()).isEmpty();
        assertThat(result.ruc()).isEmpty();
        assertThat(result.direccion()).isEmpty();
        assertThat(result.logoBase64()).isNull();
        assertThat(result.logoInputStream()).isNull();
    }

    @Test
    @DisplayName("obtener() sin logo -> retorna logo null")
    void obtener_sinLogo_retornaLogoNull() {
        EmpresaInfoService.EmpresaInfo noLogo = new EmpresaInfoService.EmpresaInfo(
                "Empresa", "20111111111", "Calle 1", null, null);

        when(securityJdbcTemplate.query(anyString(), any(ResultSetExtractor.class), eq(2L)))
                .thenReturn(noLogo);

        EmpresaInfoService.EmpresaInfo result = service.obtener(2L);

        assertThat(result.razonSocial()).isEqualTo("Empresa");
        assertThat(result.logoBase64()).isNull();
        assertThat(result.logoInputStream()).isNull();
    }
}
