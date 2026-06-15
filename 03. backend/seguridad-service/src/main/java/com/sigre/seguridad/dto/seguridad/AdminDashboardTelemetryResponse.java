package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdminDashboardTelemetryResponse {

    @Builder.Default
    private List<EmpresaTamanoItemDto> empresasBd = new ArrayList<>();
    private long totalUsuariosPlataforma;
    @Builder.Default
    private List<UsuariosPorEmpresaItemDto> usuariosPorEmpresa = new ArrayList<>();
    @Builder.Default
    private List<SesionHistogramaItemDto> histogramaSesionesPorEmpresa = new ArrayList<>();
    /** Intentos de acceso con exito = false (últimos 30 días). */
    private long sesionesIncorrectasUltimos30Dias;
    /** Usuarios con bloqueo activo o ventana bloqueado_hasta vigente. */
    private long usuariosBloqueadosPorSeguridad;
    /**
     * Usuarios en ventana de bloqueo por login fallido ({@code intentos_fallidos >= 3} y {@code bloqueado_hasta} futuro).
     * Coherente con el umbral de bloqueo del servicio de autenticación (3 intentos).
     */
    private long usuariosBloqueadosPorIntentosLogin;
    /**
     * Subconjunto de los anteriores cuyo {@code bloqueado_hasta} cae en las próximas horas (desbloqueo automático cercano).
     */
    private long usuariosProximosDesbloqueoAutomatico;
    /** Muestreo pg_stat_activity por BD seguridad y por cada tenant. */
    @Builder.Default
    private List<SesionesBloqueoDbItemDto> sesionesBloqueoPorBaseDatos = new ArrayList<>();
    /** Promedio de duracion_ms en token_uso_log (últimas 24 h); null si no hay datos. */
    private Long latenciaPromedioMsUltimas24h;
    @Builder.Default
    private List<UsuariosConectadosItemDto> usuariosConectadosPorEmpresa = new ArrayList<>();
}
