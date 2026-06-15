package com.sigre.almacen.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Base64;

@Service
public class EmpresaInfoService {

    private final JdbcTemplate securityJdbcTemplate;

    public EmpresaInfoService(@Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    public EmpresaInfo obtener(Long empresaId) {
        return securityJdbcTemplate.query(
                "SELECT razon_social, ruc, direccion_fiscal, logo FROM master.empresa WHERE id = ?",
                rs -> {
                    if (!rs.next()) return new EmpresaInfo("", "", "", null, null);
                    String razon = rs.getString("razon_social");
                    String ruc = rs.getString("ruc");
                    String dir = rs.getString("direccion_fiscal");
                    byte[] logoBytes = rs.getBytes("logo");
                    String logoBase64 = null;
                    InputStream logoStream = null;
                    if (logoBytes != null && logoBytes.length > 0) {
                        logoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(logoBytes);
                        logoStream = new ByteArrayInputStream(logoBytes);
                    }
                    return new EmpresaInfo(
                            razon != null ? razon : "",
                            ruc != null ? ruc : "",
                            dir != null ? dir : "",
                            logoBase64,
                            logoStream);
                },
                empresaId);
    }

    public record EmpresaInfo(String razonSocial, String ruc, String direccion,
                              String logoBase64, InputStream logoInputStream) {}
}
