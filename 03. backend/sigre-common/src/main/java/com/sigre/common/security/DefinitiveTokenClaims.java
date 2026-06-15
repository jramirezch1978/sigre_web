package com.sigre.common.security;

import lombok.Builder;
import lombok.Getter;

/**
 * Claims tipados extraídos del JWT definitivo (post seleccionar-empresa).
 * Inmutable: se construye una vez por request al validar el token.
 */
@Getter
@Builder
public class DefinitiveTokenClaims {

    private final Long userId;
    private final String username;
    private final String email;
    private final String nombres;
    private final String apellidos;
    private final String nombreCompleto;

    private final Long empresaId;
    private final String empresaCodigo;
    private final String empresaNombre;
    private final String empresaRuc;
    private final String dbName;

    private final Long sucursalId;
    private final String sucursalNombre;

    private final Long tokensSessionId;
    private final boolean temporal;
}
