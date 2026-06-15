package com.sigre.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TenantConnectionInfoResponse {

    private Long empresaId;
    private String codigo;
    private String ruc;
    private String razonSocial;
    private String dbHost;
    private Integer dbPort;
    private String dbName;
    private String jdbcUrl;
    private String username;
    private String password;
    private Boolean activo;
}
