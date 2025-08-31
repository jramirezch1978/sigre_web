package com.sigre.sync.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Value;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

@Service
@RequiredArgsConstructor
@Slf4j
public class SyncSchedulerService {
    
    private final RemoteToLocalSyncService remoteToLocalSync;
    private final LocalToRemoteSyncService localToRemoteSync;
    private final EmailNotificationService emailService;
    
    @Value("${sync.config.interval-minutes:5}")
    private int intervalMinutes;
    
    @Value("${sync.config.retry-delay-seconds:30}")
    private int retryDelaySeconds;
    
    @Value("${sync.config.max-retries:1}")
    private int maxRetries;
    
    @Value("${sync.config.initial-sync-on-startup:true}")
    private boolean initialSyncOnStartup;
    
    private boolean syncInProgress = false;
    private LocalDateTime lastSyncTime;
    private boolean initialSyncCompleted = false;
    
    /**
     * Ejecutar sincronización inicial al arrancar el microservicio
     */
    @EventListener(ApplicationReadyEvent.class)
    public void ejecutarSincronizacionInicial() {
        try {
            // Log de parámetros obtenidos del config-server
            log.info("📋 Parámetros de sincronización obtenidos del config-server:");
            log.info("  - Intervalo: {} minutos", intervalMinutes);
            log.info("  - Delay de reintento: {} segundos", retryDelaySeconds);
            log.info("  - Máximo reintentos: {}", maxRetries);
            log.info("  - Sync inicial habilitado: {}", initialSyncOnStartup);
            
            if (!initialSyncOnStartup) {
                log.info("⏭️ Sincronización inicial deshabilitada por configuración");
                return;
            }
            
            log.info("🚀 Ejecutando sincronización inicial al startup del microservicio");
            
            // Esperar 10 segundos para que todos los servicios estén listos
            Thread.sleep(10000);
            ejecutarSincronizacionCompleta();
            initialSyncCompleted = true;
            
        } catch (Exception e) {
            log.error("❌ ERROR en sincronización inicial", e);
            log.error("❌ Parámetros de config - Intervalo: {} | Delay: {} | Reintentos: {}", 
                     intervalMinutes, retryDelaySeconds, maxRetries);
        }
    }
    
    /**
     * Sincronización programada cada 5 minutos después de completar la anterior
     */
    @Scheduled(fixedDelay = 5, timeUnit = TimeUnit.MINUTES, initialDelay = 60) // 1 min delay inicial
    public void ejecutarSincronizacion() {
        if (syncInProgress) {
            log.warn("Sincronización anterior aún en progreso, saltando esta ejecución");
            return;
        }
        
        ejecutarSincronizacionCompleta();
    }
    
    /**
     * Método principal de sincronización completa
     */
    private void ejecutarSincronizacionCompleta() {
        log.info("🔄 Iniciando proceso de sincronización bidireccional");
        syncInProgress = true;
        LocalDateTime inicioSync = LocalDateTime.now();
        lastSyncTime = inicioSync;
        
        try {
            // Ejecutar ambas sincronizaciones en paralelo usando CompletableFuture
            CompletableFuture<Boolean> syncRemoteToLocal = CompletableFuture.supplyAsync(() -> {
                try {
                    return ejecutarSyncRemoteToLocal();
                } catch (Exception e) {
                    log.error("Error en sincronización Remote → Local", e);
                    return false;
                }
            });
            
            CompletableFuture<Boolean> syncLocalToRemote = CompletableFuture.supplyAsync(() -> {
                try {
                    return ejecutarSyncLocalToRemote();
                } catch (Exception e) {
                    log.error("Error en sincronización Local → Remote", e);
                    return false;
                }
            });
            
            // Esperar a que ambas tareas terminen
            CompletableFuture<Void> allTasks = CompletableFuture.allOf(syncRemoteToLocal, syncLocalToRemote);
            
            // Timeout de 4 minutos para evitar bloqueos
            allTasks.get(4, TimeUnit.MINUTES);
            
            boolean resultadoRemoteToLocal = syncRemoteToLocal.get();
            boolean resultadoLocalToRemote = syncLocalToRemote.get();
            
            // Generar reporte de sincronización
            LocalDateTime finSync = LocalDateTime.now();
            long duracionMinutos = Duration.between(inicioSync, finSync).toMinutes();
            
            EmailNotificationService.SyncReport report = EmailNotificationService.SyncReport.builder()
                    .fechaHora(inicioSync)
                    .duracionMinutos(duracionMinutos)
                    .exitoso(resultadoRemoteToLocal && resultadoLocalToRemote)
                    .remoteToLocalExitoso(resultadoRemoteToLocal)
                    .localToRemoteExitoso(resultadoLocalToRemote)
                    .tablasSincronizadasRemoteToLocal(obtenerEstadisticasRemoteToLocal())
                    .tablasSincronizadasLocalToRemote(obtenerEstadisticasLocalToRemote())
                    .estadisticasDetalladas(obtenerEstadisticasDetalladas(resultadoRemoteToLocal, resultadoLocalToRemote))
                    .errores(obtenerErroresSincronizacion())
                    .proximaSincronizacion(finSync.plusMinutes(5))
                    .build();
            
            // Enviar reporte por email
            emailService.enviarReporteSincronizacion(report);
            
            if (resultadoRemoteToLocal && resultadoLocalToRemote) {
                log.info("✅ Sincronización bidireccional completada exitosamente");
            } else {
                log.warn("⚠️ Sincronización completada con errores - Remote→Local: {} | Local→Remote: {}", 
                        resultadoRemoteToLocal, resultadoLocalToRemote);
            }
            
        } catch (Exception e) {
            log.error("❌ Error crítico en proceso de sincronización", e);
        } finally {
            syncInProgress = false;
            log.info("🏁 Proceso de sincronización finalizado. Próxima ejecución en 5 minutos.");
        }
    }
    
    /**
     * Ejecutar sincronización de Remote (Oracle) → Local (PostgreSQL)
     */
    private boolean ejecutarSyncRemoteToLocal() {
        log.info("📥 Iniciando sincronización Remote → Local");
        
        try {
            // Sincronizar maestro
            boolean maestroOk = remoteToLocalSync.sincronizarMaestro();
            if (!maestroOk) {
                return manejarErrorConReintento("maestro", () -> remoteToLocalSync.sincronizarMaestro());
            }
            
            // Sincronizar centros de costo
            boolean centrosOk = remoteToLocalSync.sincronizarCentrosCosto();
            if (!centrosOk) {
                return manejarErrorConReintento("centros_costo", () -> remoteToLocalSync.sincronizarCentrosCosto());
            }
            
            // Sincronizar tarjetas de reloj
            boolean tarjetasOk = remoteToLocalSync.sincronizarTarjetasReloj();
            if (!tarjetasOk) {
                return manejarErrorConReintento("rrhh_asigna_trjt_reloj", () -> remoteToLocalSync.sincronizarTarjetasReloj());
            }
            
            log.info("✅ Sincronización Remote → Local completada");
            return true;
            
        } catch (Exception e) {
            log.error("❌ Error en sincronización Remote → Local", e);
            return false;
        }
    }
    
    /**
     * Ejecutar sincronización de Local (PostgreSQL) → Remote (Oracle)
     */
    private boolean ejecutarSyncLocalToRemote() {
        log.info("📤 Iniciando sincronización Local → Remote");
        
        try {
            // Sincronizar asistencia
            boolean asistenciaOk = localToRemoteSync.sincronizarAsistencia();
            if (!asistenciaOk) {
                return manejarErrorConReintento("asistencia_ht580", () -> localToRemoteSync.sincronizarAsistencia());
            }
            
            log.info("✅ Sincronización Local → Remote completada");
            return true;
            
        } catch (Exception e) {
            log.error("❌ Error en sincronización Local → Remote", e);
            return false;
        }
    }
    
    /**
     * Manejar errores con reintento después de 30 segundos
     */
    private boolean manejarErrorConReintento(String tabla, SyncOperation operation) {
        log.warn("⚠️ Error en sincronización de tabla: {}. Reintentando en 30 segundos...", tabla);
        
        try {
            Thread.sleep(30000); // Esperar 30 segundos
            boolean resultado = operation.execute();
            
            if (resultado) {
                log.info("✅ Reintento exitoso para tabla: {}", tabla);
            } else {
                log.error("❌ Reintento fallido para tabla: {}", tabla);
            }
            
            return resultado;
            
        } catch (Exception e) {
            log.error("❌ Error en reintento para tabla: {}", tabla, e);
            return false;
        }
    }
    
    /**
     * Obtener estado de la sincronización
     */
    public SyncStatus getSyncStatus() {
        return SyncStatus.builder()
                .syncInProgress(syncInProgress)
                .lastSyncTime(lastSyncTime)
                .build();
    }
    
    // Interfaz funcional para operaciones de sincronización
    @FunctionalInterface
    private interface SyncOperation {
        boolean execute() throws Exception;
    }
    
    /**
     * Obtener estadísticas de sincronización Remote → Local
     */
    private Map<String, Integer> obtenerEstadisticasRemoteToLocal() {
        Map<String, Integer> stats = new HashMap<>();
        // TODO: Implementar conteo real desde los servicios de sincronización
        stats.put("maestro", 0);
        stats.put("centros_costo", 0);
        stats.put("rrhh_asigna_trjt_reloj", 0);
        return stats;
    }
    
    /**
     * Obtener estadísticas de sincronización Local → Remote
     */
    private Map<String, Integer> obtenerEstadisticasLocalToRemote() {
        Map<String, Integer> stats = new HashMap<>();
        // TODO: Implementar conteo real desde los servicios de sincronización
        stats.put("asistencia_ht580", 0);
        return stats;
    }
    
    /**
     * Obtener estadísticas detalladas por tabla
     */
    private Map<String, EmailNotificationService.SyncTableStats> obtenerEstadisticasDetalladas(boolean remoteToLocalOk, boolean localToRemoteOk) {
        Map<String, EmailNotificationService.SyncTableStats> stats = new HashMap<>();
        
        // Remote → Local
        stats.put("maestro", EmailNotificationService.SyncTableStats.builder()
                .nombreTabla("maestro")
                .registrosInsertados(remoteToLocalSync.getRegistrosInsertados())
                .registrosActualizados(remoteToLocalSync.getRegistrosActualizados())
                .registrosErrores(remoteToLocalSync.getRegistrosErrores())
                .direccion("REMOTE_TO_LOCAL")
                .baseOrigen("bd_remota")
                .baseDestino("bd_local")
                .exitoso(remoteToLocalSync.getRegistrosErrores() == 0)
                .erroresDetallados(remoteToLocalSync.getErrores())
                .build());
                
        stats.put("centros_costo", EmailNotificationService.SyncTableStats.builder()
                .nombreTabla("centros_costo")
                .registrosInsertados(0)
                .registrosActualizados(0)
                .direccion("REMOTE_TO_LOCAL")
                .baseOrigen("bd_remota")
                .baseDestino("bd_local")
                .exitoso(true)
                .build());
                
        stats.put("rrhh_asigna_trjt_reloj", EmailNotificationService.SyncTableStats.builder()
                .nombreTabla("rrhh_asigna_trjt_reloj")
                .registrosInsertados(0)
                .registrosActualizados(0)
                .direccion("REMOTE_TO_LOCAL")
                .baseOrigen("bd_remota")
                .baseDestino("bd_local")
                .exitoso(true)
                .build());
        
        // Local → Remote
        stats.put("asistencia_ht580", EmailNotificationService.SyncTableStats.builder()
                .nombreTabla("asistencia_ht580")
                .registrosInsertados(localToRemoteSync.getRegistrosInsertados())
                .registrosActualizados(localToRemoteSync.getRegistrosActualizados())
                .registrosErrores(localToRemoteSync.getRegistrosErrores())
                .direccion("LOCAL_TO_REMOTE")
                .baseOrigen("bd_local")
                .baseDestino("bd_remota")
                .exitoso(localToRemoteSync.getRegistrosErrores() == 0)
                .erroresDetallados(localToRemoteSync.getErrores())
                .build());
        
        return stats;
    }
    
    /**
     * Obtener lista de errores de sincronización
     */
    private List<String> obtenerErroresSincronizacion() {
        List<String> errores = new ArrayList<>();
        
        // Agregar errores de Remote → Local
        errores.addAll(remoteToLocalSync.getErrores());
        
        // Agregar errores de Local → Remote
        errores.addAll(localToRemoteSync.getErrores());
        
        return errores;
    }
    
    // DTO para estado de sincronización
    @lombok.Data
    @lombok.Builder
    public static class SyncStatus {
        private boolean syncInProgress;
        private LocalDateTime lastSyncTime;
        private String nextSyncIn;
        private boolean initialSyncCompleted;
    }
}
