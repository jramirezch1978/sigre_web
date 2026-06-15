package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import com.sigre.seguridad.dto.TenantConnectionInfoResponse;
import com.sigre.seguridad.entity.master.EmpresaMaster;
import com.sigre.seguridad.repository.EmpresaMasterRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.util.AesEncryptor;

import java.util.Locale;

@Service
@RequiredArgsConstructor
public class TenantConnectionService {

    private final EmpresaMasterRepository empresaMasterRepository;
    private final AesEncryptor aesEncryptor;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    public TenantConnectionInfoResponse getTenantConnection(Long empresaId) {
        EmpresaMaster empresa = empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException(
                        "No existe empresa con id " + empresaId,
                        HttpStatus.NOT_FOUND,
                        "EMPRESA_NO_ENCONTRADA"));

        // La contraseña en master.empresa va cifrada; debe coincidir con la del rol en PostgreSQL tras desencriptar.
        return TenantConnectionInfoResponse.builder()
                .empresaId(empresa.getId())
                .codigo(empresa.getCodigo())
                .ruc(empresa.getRuc())
                .razonSocial(empresa.getRazonSocial())
                .dbHost(empresa.getDbHost())
                .dbPort(empresa.getDbPort())
                .dbName(empresa.getDbName())
                .jdbcUrl(buildJdbcUrl(empresa))
                .username(empresa.getDbUser())
                .password(aesEncryptor.decrypt(empresa.getDbPasswordEncrypted()))
                .activo(empresa.getActivo())
                .build();
    }

    private String buildJdbcUrl(EmpresaMaster empresa) {
        return String.format(
                Locale.ROOT,
                "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                empresa.getDbHost(),
                empresa.getDbPort(),
                empresa.getDbName(),
                jdbcSslMode
        );
    }
}
