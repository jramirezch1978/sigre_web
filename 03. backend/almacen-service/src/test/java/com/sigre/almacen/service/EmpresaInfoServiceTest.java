package com.sigre.almacen.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;

import java.sql.ResultSet;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class EmpresaInfoServiceTest {

    @Mock
    private JdbcTemplate securityJdbcTemplate;
    @InjectMocks
    private EmpresaInfoService service;

    @Test
    void obtener_sinFilas_devuelveVacio() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(false);
        when(securityJdbcTemplate.query(
                eq("SELECT razon_social, ruc, direccion_fiscal, logo FROM master.empresa WHERE id = ?"),
                any(ResultSetExtractor.class),
                eq(1L)))
                .thenAnswer(inv -> {
                    ResultSetExtractor<?> extractor = inv.getArgument(1);
                    return extractor.extractData(rs);
                });

        EmpresaInfoService.EmpresaInfo info = service.obtener(1L);

        assertThat(info.razonSocial()).isEmpty();
        assertThat(info.logoInputStream()).isNull();
    }

    @Test
    void obtener_conLogo_devuelveStreamYBase64() throws Exception {
        byte[] logo = new byte[]{(byte) 0x89, 0x50};
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getString("razon_social")).thenReturn("ACME SAC");
        when(rs.getString("ruc")).thenReturn("20123456789");
        when(rs.getString("direccion_fiscal")).thenReturn("Av. Test 1");
        when(rs.getBytes("logo")).thenReturn(logo);
        when(securityJdbcTemplate.query(
                eq("SELECT razon_social, ruc, direccion_fiscal, logo FROM master.empresa WHERE id = ?"),
                any(ResultSetExtractor.class),
                eq(2L)))
                .thenAnswer(inv -> {
                    ResultSetExtractor<?> extractor = inv.getArgument(1);
                    return extractor.extractData(rs);
                });

        EmpresaInfoService.EmpresaInfo info = service.obtener(2L);

        assertThat(info.razonSocial()).isEqualTo("ACME SAC");
        assertThat(info.ruc()).isEqualTo("20123456789");
        assertThat(info.direccion()).isEqualTo("Av. Test 1");
        assertThat(info.logoBase64()).startsWith("data:image/png;base64,");
        assertThat(info.logoInputStream()).isNotNull();
    }

    @Test
    void obtener_nulosEnColumnas_usaVacio() throws Exception {
        ResultSet rs = mock(ResultSet.class);
        when(rs.next()).thenReturn(true);
        when(rs.getString("razon_social")).thenReturn(null);
        when(rs.getString("ruc")).thenReturn(null);
        when(rs.getString("direccion_fiscal")).thenReturn(null);
        when(rs.getBytes("logo")).thenReturn(null);
        when(securityJdbcTemplate.query(
                eq("SELECT razon_social, ruc, direccion_fiscal, logo FROM master.empresa WHERE id = ?"),
                any(ResultSetExtractor.class),
                eq(3L)))
                .thenAnswer(inv -> {
                    ResultSetExtractor<?> extractor = inv.getArgument(1);
                    return extractor.extractData(rs);
                });

        EmpresaInfoService.EmpresaInfo info = service.obtener(3L);

        assertThat(info.razonSocial()).isEmpty();
        assertThat(info.logoBase64()).isNull();
    }
}
