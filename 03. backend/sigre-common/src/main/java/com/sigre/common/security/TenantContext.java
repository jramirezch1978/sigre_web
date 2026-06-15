package com.sigre.common.security;

/**
 * Contexto del tenant (empresa) actual — ThreadLocal.
 * Se establece en el filtro JWT y se usa por TenantRoutingDataSource
 * para rutear a la BD correcta.
 */
public final class TenantContext {

    private static final ThreadLocal<Long> EMPRESA_ID = new ThreadLocal<>();
    private static final ThreadLocal<Long> SUCURSAL_ID = new ThreadLocal<>();
    private static final ThreadLocal<Long> USUARIO_ID = new ThreadLocal<>();

    private TenantContext() {}

    public static void setEmpresaId(Long empresaId) {
        EMPRESA_ID.set(empresaId);
    }

    public static Long getEmpresaId() {
        return EMPRESA_ID.get();
    }

    public static void setSucursalId(Long sucursalId) {
        SUCURSAL_ID.set(sucursalId);
    }

    public static Long getSucursalId() {
        return SUCURSAL_ID.get();
    }

    public static void setUsuarioId(Long usuarioId) {
        USUARIO_ID.set(usuarioId);
    }

    public static Long getUsuarioId() {
        return USUARIO_ID.get();
    }

    public static void clear() {
        EMPRESA_ID.remove();
        SUCURSAL_ID.remove();
        USUARIO_ID.remove();
    }
}
