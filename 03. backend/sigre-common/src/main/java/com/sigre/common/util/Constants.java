package com.sigre.common.util;

/**
 * Constantes globales de la aplicación.
 */
public final class Constants {

    private Constants() {}

    // ── Exchanges RabbitMQ ──
    public static final String EXCHANGE_PRE_ASIENTOS = "pre-asientos";
    public static final String EXCHANGE_AUDITORIA = "auditoria";
    public static final String EXCHANGE_NOTIFICACIONES = "notificaciones";
    public static final String EXCHANGE_TENANT = "tenant-exchange";

    // ── Colas RabbitMQ ──
    public static final String QUEUE_CONTABILIDAD_PRE_ASIENTOS = "q.contabilidad.pre-asientos";
    public static final String QUEUE_AUDITORIA_LOGS = "q.auditoria.logs";
    public static final String QUEUE_NOTIFICACIONES_EMAIL = "q.notificaciones.email";
    public static final String QUEUE_NOTIFICACIONES_PUSH = "q.notificaciones.push";

    // ── Headers HTTP ──
    public static final String HEADER_EMPRESA_ID = "X-Empresa-Id";
    public static final String HEADER_SUCURSAL_ID = "X-Sucursal-Id";
    public static final String HEADER_AUTHORIZATION = "Authorization";
    public static final String TOKEN_PREFIX = "Bearer ";

    // ── Módulos ──
    public static final String MODULO_GENERAL = "GENERAL";
    public static final String MODULO_ALMACEN = "ALMACEN";
    public static final String MODULO_COMPRAS = "COMPRAS";
    public static final String MODULO_VENTAS = "VENTAS";
    public static final String MODULO_FINANZAS = "FINANZAS";
    public static final String MODULO_CONTABILIDAD = "CONTABILIDAD";
    public static final String MODULO_RRHH = "RRHH";
    public static final String MODULO_ACTIVOS = "ACTIVOS";
    public static final String MODULO_PRODUCCION = "PRODUCCION";

    // ── Acciones de auditoría ──
    public static final String ACCION_CREAR = "CREAR";
    public static final String ACCION_EDITAR = "EDITAR";
    public static final String ACCION_ELIMINAR = "ELIMINAR";
    public static final String ACCION_APROBAR = "APROBAR";
    public static final String ACCION_ANULAR = "ANULAR";
}
