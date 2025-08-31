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
import java.util.concurrent.*;
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
    private final EmailNotificationServiceHTML emailService;
    
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
    
    // Executor service para manejar los hilos
    private final ExecutorService executorService = Executors.newFixedThreadPool(2, r -> {
        Thread t = new Thread(r);
        t.setDaemon(true);
        return t;
    });
    
    @EventListener(ApplicationReadyEvent.class)
    public void ejecutarSincronizacionInicial() {
        try {
            log.info("================================================================");
            log.info("📋 CONFIGURACIÓN DE SINCRONIZACIÓN OBTENIDA DEL CONFIG-SERVER");
            log.info("================================================================");
            log.info("  ⏱️  Intervalo entre sincronizaciones: {} minutos", intervalMinutes);
            log.info("  🔄 Delay de reintento en caso de error: {} segundos", retryDelaySeconds);
            log.info("  🔢 Máximo número de reintentos: {}", maxRetries);
            log.info("  🚀 Sincronización inicial al arranque: {}", initialSyncOnStartup);
            log.info("================================================================");
            
            if (!initialSyncOnStartup) {
                log.info("⭕ Sincronización inicial deshabilitada por configuración");
                return;
            }
            
            log.info("🚀 INICIANDO SINCRONIZACIÓN INICIAL AL STARTUP DEL MICROSERVICIO");
            
            // Esperar 10 segundos para que todos los servicios estén listos
            log.info("⏳ Esperando 10 segundos para que todos los servicios estén listos...");
            Thread.sleep(10000);
            
            ejecutarSincronizacionCompleta();
            initialSyncCompleted = true;
            
        } catch (Exception e) {
            log.error("❌ ERROR CRÍTICO en sincronización inicial", e);
        }
    }
    
    @Scheduled(fixedDelay = 5, timeUnit = TimeUnit.MINUTES, initialDelay = 60)
    public void ejecutarSincronizacionProgramada() {
        if (syncInProgress) {
            log.warn("⚠️ Sincronización anterior aún en progreso, saltando esta ejecución");
            return;
        }
        
        log.info("⏰ Ejecutando sincronización programada");
        ejecutarSincronizacionCompleta();
    }
    
    private void ejecutarSincronizacionCompleta() {
        log.info("╔════════════════════════════════════════════════════════════╗");
        log.info("║     INICIANDO PROCESO DE SINCRONIZACIÓN BIDIRECCIONAL     ║");
        log.info("╠════════════════════════════════════════════════════════════╣");
        log.info("║ HILO 1: Remote → Local (centros, maestro, tarjetas)       ║");
        log.info("║ HILO 2: Local → Remote (asistencia_ht580)                 ║");
        log.info("╚════════════════════════════════════════════════════════════╝");
        
        syncInProgress = true;
        LocalDateTime inicioSync = LocalDateTime.now();
        lastSyncTime = inicioSync;
        
        CountDownLatch latch = new CountDownLatch(2);
        Map<String, Boolean> resultadosHilos = new ConcurrentHashMap<>();
        Map<String, Exception> erroresHilos = new ConcurrentHashMap<>();
        
        try {
            // HILO 1: Sincronización Remote → Local (CON ORDEN CORRECTO)
            Future<Boolean> futureRemoteToLocal = executorService.submit(() -> {
                String threadName = "HILO-1-Remote-To-Local";
                Thread.currentThread().setName(threadName);
                
                try {
                    log.info("🧵 [{}] INICIADO - Orden: 1°centros_costo, 2°maestro, 3°tarjetas", threadName);
                    boolean resultado = ejecutarSyncRemoteToLocalConOrden();
                    resultadosHilos.put("remoteToLocal", resultado);
                    log.info("🧵 [{}] COMPLETADO - Resultado: {}", threadName, resultado ? "ÉXITO" : "ERROR");
                    return resultado;
                    
                } catch (Exception e) {
                    log.error("🧵 [{}] FALLÓ con excepción", threadName, e);
                    erroresHilos.put("remoteToLocal", e);
                    resultadosHilos.put("remoteToLocal", false);
                    return false;
                    
                } finally {
                    latch.countDown();
                }
            });
            
            // HILO 2: Sincronización Local → Remote
            Future<Boolean> futureLocalToRemote = executorService.submit(() -> {
                String threadName = "HILO-2-Local-To-Remote";
                Thread.currentThread().setName(threadName);
                
                try {
                    log.info("🧵 [{}] INICIADO - Sincronizando: asistencia_ht580", threadName);
                    boolean resultado = ejecutarSyncLocalToRemote();
                    resultadosHilos.put("localToRemote", resultado);
                    log.info("🧵 [{}] COMPLETADO - Resultado: {}", threadName, resultado ? "ÉXITO" : "ERROR");
                    return resultado;
                    
                } catch (Exception e) {
                    log.error("🧵 [{}] FALLÓ con excepción", threadName, e);
                    erroresHilos.put("localToRemote", e);
                    resultadosHilos.put("localToRemote", false);
                    return false;
                    
                } finally {
                    latch.countDown();
                }
            });
            
            // SINCRONIZADOR: Esperar a que AMBOS hilos terminen
            log.info("⏳ SINCRONIZADOR: Esperando que AMBOS HILOS terminen su ejecución...");
            boolean terminoEnTiempo = latch.await(4, TimeUnit.MINUTES);
            
            if (!terminoEnTiempo) {
                log.error("❌ TIMEOUT: Los hilos no terminaron en el tiempo esperado (4 minutos)");
                futureRemoteToLocal.cancel(true);
                futureLocalToRemote.cancel(true);
            }
            
            // AMBOS HILOS HAN TERMINADO
            log.info("═══════════════════════════════════════════════════════════");
            log.info("✅ AMBOS HILOS HAN TERMINADO - Recopilando resultados finales");
            log.info("═══════════════════════════════════════════════════════════");
            
            boolean resultadoRemoteToLocal = resultadosHilos.getOrDefault("remoteToLocal", false);
            boolean resultadoLocalToRemote = resultadosHilos.getOrDefault("localToRemote", false);
            
            log.info("📊 Resultado HILO 1 (Remote → Local): {}", resultadoRemoteToLocal ? "ÉXITO" : "ERROR");
            log.info("📊 Resultado HILO 2 (Local → Remote): {}", resultadoLocalToRemote ? "ÉXITO" : "ERROR");
            
            LocalDateTime finSync = LocalDateTime.now();
            long duracionMinutos = Duration.between(inicioSync, finSync).toMinutes();
            long duracionSegundos = Duration.between(inicioSync, finSync).toSeconds();
            
            log.info("⏱️ Duración total de sincronización: {} minutos ({} segundos)", duracionMinutos, duracionSegundos);
            
            // Generar y enviar reporte SOLO DESPUÉS DE QUE AMBOS HILOS TERMINEN
            generarYEnviarReporte(inicioSync, finSync, resultadoRemoteToLocal, resultadoLocalToRemote);
            
            if (resultadoRemoteToLocal && resultadoLocalToRemote) {
                log.info("✅ SINCRONIZACIÓN BIDIRECCIONAL COMPLETADA EXITOSAMENTE");
            } else {
                log.warn("⚠️ SINCRONIZACIÓN COMPLETADA CON ERRORES");
                log.warn("   - Remote → Local: {}", resultadoRemoteToLocal ? "OK" : "ERROR");
                log.warn("   - Local → Remote: {}", resultadoLocalToRemote ? "OK" : "ERROR");
            }
            
        } catch (Exception e) {
            log.error("❌ ERROR CRÍTICO en el proceso de sincronización", e);
            
        } finally {
            syncInProgress = false;
            log.info("╔════════════════════════════════════════════════════════════╗");
            log.info("║   PROCESO DE SINCRONIZACIÓN FINALIZADO                    ║");
            log.info("║   Próxima ejecución en: {} minutos                        ║", intervalMinutes);
            log.info("╚════════════════════════════════════════════════════════════╝");
        }
    }
    
    /**
     * Ejecutar sincronización de Remote → Local CON ORDEN CORRECTO
     * IMPORTANTE: Primero centros_costo, luego maestro, finalmente tarjetas
     */
    private boolean ejecutarSyncRemoteToLocalConOrden() {
        log.info("🔥 [HILO 1] Iniciando sincronización Remote → Local con ORDEN CORRECTO");
        
        try {
            // PASO 1: Sincronizar CENTROS DE COSTO primero (no tiene dependencias)
            log.info("📍 [HILO 1] PASO 1/3: Sincronizando CENTROS_COSTO...");
            boolean centrosOk = remoteToLocalSync.sincronizarCentrosCosto();
            if (!centrosOk && maxRetries > 0) {
                centrosOk = manejarErrorConReintento("centros_costo", () -> remoteToLocalSync.sincronizarCentrosCosto());
            }
            
            if (!centrosOk) {
                log.error("❌ [HILO 1] Fallo crítico en CENTROS_COSTO - Abortando sincronización");
                return false;
            }
            
            // PASO 2: Sincronizar MAESTRO (depende de centros_costo)
            log.info("📍 [HILO 1] PASO 2/3: Sincronizando MAESTRO...");
            boolean maestroOk = remoteToLocalSync.sincronizarMaestro();
            if (!maestroOk && maxRetries > 0) {
                maestroOk = manejarErrorConReintento("maestro", () -> remoteToLocalSync.sincronizarMaestro());
            }
            
            if (!maestroOk) {
                log.error("❌ [HILO 1] Fallo en MAESTRO - Continuando con tarjetas");
            }
            
            // PASO 3: Sincronizar TARJETAS DE RELOJ (depende de maestro)
            log.info("📍 [HILO 1] PASO 3/3: Sincronizando RRHH_ASIGNA_TRJT_RELOJ...");
            boolean tarjetasOk = remoteToLocalSync.sincronizarTarjetasReloj();
            if (!tarjetasOk && maxRetries > 0) {
                tarjetasOk = manejarErrorConReintento("rrhh_asigna_trjt_reloj", () -> remoteToLocalSync.sincronizarTarjetasReloj());
            }
            
            boolean todoOk = centrosOk && maestroOk && tarjetasOk;
            log.info("✅ [HILO 1] Sincronización Remote → Local completada - Resultado: {}", todoOk ? "ÉXITO TOTAL" : "CON ERRORES");
            return todoOk;
            
        } catch (Exception e) {
            log.error("❌ [HILO 1] Error crítico en sincronización Remote → Local", e);
            return false;
        }
    }
    
    private boolean ejecutarSyncLocalToRemote() {
        log.info("📤 [HILO 2] Iniciando sincronización Local → Remote");
        
        try {
            boolean asistenciaOk = localToRemoteSync.sincronizarAsistencia();
            if (!asistenciaOk && maxRetries > 0) {
                asistenciaOk = manejarErrorConReintento("asistencia_ht580", () -> localToRemoteSync.sincronizarAsistencia());
            }
            
            log.info("✅ [HILO 2] Sincronización Local → Remote completada - Resultado: {}", asistenciaOk ? "ÉXITO" : "CON ERRORES");
            return asistenciaOk;
            
        } catch (Exception e) {
            log.error("❌ [HILO 2] Error en sincronización Local → Remote", e);
            return false;
        }
    }
    
    private boolean manejarErrorConReintento(String tabla, SyncOperation operation) {
        log.warn("⚠️ Error en sincronización de tabla: {}. Reintentando en {} segundos...", tabla, retryDelaySeconds);
        
        try {
            Thread.sleep(retryDelaySeconds * 1000L);
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
    
    private void generarYEnviarReporte(LocalDateTime inicioSync, LocalDateTime finSync, 
                                       boolean resultadoRemoteToLocal, boolean resultadoLocalToRemote) {
        try {
            log.info("📧 Generando reporte de sincronización para envío por email...");
            
            long duracionMinutos = Duration.between(inicioSync, finSync).toMinutes();
            
            Map<String, EmailNotificationServiceHTML.SyncTableStats> estadisticasDetalladas = new HashMap<>();
            
            // Estadísticas de Remote → Local
            estadisticasDetalladas.put("centros_costo", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("centros_costo")
                    .registrosInsertados(remoteToLocalSync.getInsertados("centros_costo"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("centros_costo"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("centros_costo"))
                    .registrosErrores(remoteToLocalSync.getErrores("centros_costo"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("centros_costo") == 0)
                    .build());
                    
            estadisticasDetalladas.put("maestro", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("maestro")
                    .registrosInsertados(remoteToLocalSync.getInsertados("maestro"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("maestro"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("maestro"))
                    .registrosErrores(remoteToLocalSync.getErrores("maestro"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("maestro") == 0)
                    .build());
                    
            estadisticasDetalladas.put("rrhh_asigna_trjt_reloj", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("rrhh_asigna_trjt_reloj")
                    .registrosInsertados(remoteToLocalSync.getInsertados("rrhh_asigna_trjt_reloj"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("rrhh_asigna_trjt_reloj"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("rrhh_asigna_trjt_reloj"))
                    .registrosErrores(remoteToLocalSync.getErrores("rrhh_asigna_trjt_reloj"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("rrhh_asigna_trjt_reloj") == 0)
                    .build());
            
            // Estadísticas de Local → Remote
            estadisticasDetalladas.put("asistencia_ht580", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("asistencia_ht580")
                    .registrosInsertados(localToRemoteSync.getRegistrosInsertados())
                    .registrosActualizados(0)
                    .registrosEliminados(0)
                    .registrosErrores(localToRemoteSync.getRegistrosErrores())
                    .direccion("LOCAL_TO_REMOTE")
                    .baseOrigen("bd_local")
                    .baseDestino("bd_remota")
                    .exitoso(localToRemoteSync.getRegistrosErrores() == 0)
                    .build());
            
            List<String> todosLosErrores = new ArrayList<>();
            todosLosErrores.addAll(remoteToLocalSync.getErroresSincronizacion());
            todosLosErrores.addAll(localToRemoteSync.getErrores());
            
            EmailNotificationServiceHTML.SyncReport report = EmailNotificationServiceHTML.SyncReport.builder()
                    .fechaHora(inicioSync)
                    .duracionMinutos(duracionMinutos)
                    .exitoso(resultadoRemoteToLocal && resultadoLocalToRemote)
                    .remoteToLocalExitoso(resultadoRemoteToLocal)
                    .localToRemoteExitoso(resultadoLocalToRemote)
                    .estadisticasDetalladas(estadisticasDetalladas)
                    .errores(todosLosErrores)
                    .proximaSincronizacion(finSync.plusMinutes(intervalMinutes))
                    .build();
            
            emailService.enviarReporteSincronizacion(report);
            log.info("📧 Reporte de sincronización enviado por email");
            
        } catch (Exception e) {
            log.error("❌ Error al generar/enviar reporte de sincronización", e);
        }
    }
    
    public SyncStatus getSyncStatus() {
        return SyncStatus.builder()
                .syncInProgress(syncInProgress)
                .lastSyncTime(lastSyncTime)
                .nextSyncIn(calcularProximaSincronizacion())
                .initialSyncCompleted(initialSyncCompleted)
                .build();
    }
    
    private String calcularProximaSincronizacion() {
        if (lastSyncTime == null) return "No ejecutado";
        LocalDateTime proximaSync = lastSyncTime.plusMinutes(intervalMinutes);
        Duration duracion = Duration.between(LocalDateTime.now(), proximaSync);
        long minutos = duracion.toMinutes();
        if (minutos > 0) {
            return minutos + " minutos";
        } else {
            return "En proceso o próximamente";
        }
    }
    
    @FunctionalInterface
    private interface SyncOperation {
        boolean execute() throws Exception;
    }
    
    @lombok.Data
    @lombok.Builder
    public static class SyncStatus {
        private boolean syncInProgress;
        private LocalDateTime lastSyncTime;
        private String nextSyncIn;
        private boolean initialSyncCompleted;
    }
}