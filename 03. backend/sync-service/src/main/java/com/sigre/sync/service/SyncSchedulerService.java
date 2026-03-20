package com.sigre.sync.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;

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
    private final ActivityDetectionService activityDetectionService;
    
    @Value("${sync.config.interval-minutes:5}")
    private int intervalMinutes;
    
    @Value("${sync.config.retry-delay-seconds:30}")
    private int retryDelaySeconds;
    
    @Value("${sync.config.max-retries:1}")
    private int maxRetries;
    
    @Value("${sync.config.initial-sync-on-startup:true}")
    private boolean initialSyncOnStartup;
    
    // Variable eliminada: Ya no necesitamos syncInProgress porque ejecutamos secuencialmente
    private LocalDateTime lastSyncTime;
    private boolean initialSyncCompleted = false;
    
    // Executor service para manejar los hilos
    private final ExecutorService executorService = Executors.newFixedThreadPool(2, r -> {
        Thread t = new Thread(r);
        t.setDaemon(false);  // ✅ CORREGIDO: No daemon para mantener viva la JVM
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
            
            log.info("🔄 Ejecutando sincronización inicial...");
            try {
                ejecutarSincronizacionCompleta();
                log.info("🔄 Sincronización inicial terminada exitosamente");
            } catch (Exception syncException) {
                log.error("❌ Error durante sincronización inicial", syncException);
            }
            
            log.info("🔄 Marcando sincronización inicial como completada...");
            initialSyncCompleted = true;
            log.info("✅ Sincronización inicial completada");
            log.info("🔄 Iniciando ciclo de sincronización recurrente cada {} minutos", intervalMinutes);
            
            // Iniciar el ciclo recurrente SIEMPRE, incluso si hubo errores en la sincronización inicial
            log.info("🔄 Llamando a iniciarCicloSincronizacionRecurrente()...");
            try {
                iniciarCicloSincronizacionRecurrente();
                log.info("🔄 iniciarCicloSincronizacionRecurrente() ejecutado exitosamente");
            } catch (Exception cycleException) {
                log.error("❌ Error al iniciar ciclo recurrente", cycleException);
            }
            
            // MECANISMO DE RESPALDO: Verificar después de 30 segundos si el ciclo se inició
            CompletableFuture.delayedExecutor(30, TimeUnit.SECONDS).execute(() -> {
                log.info("🔍 VERIFICACIÓN DE RESPALDO: Comprobando si el ciclo recurrente está activo...");
                if (!Thread.getAllStackTraces().keySet().stream()
                        .anyMatch(t -> "SyncCycle-Thread".equals(t.getName()))) {
                    log.warn("⚠️ RESPALDO ACTIVADO: El ciclo recurrente no está activo. Reintentando...");
                    iniciarCicloSincronizacionRecurrente();
                } else {
                    log.info("✅ VERIFICACIÓN OK: El ciclo recurrente está activo");
                }
            });
            
        } catch (Exception e) {
            log.error("❌ ERROR CRÍTICO en sincronización inicial", e);
            // Aún así marcar como completado e iniciar el ciclo recurrente
            initialSyncCompleted = true;
            log.info("🔄 Iniciando ciclo de sincronización recurrente a pesar del error inicial");
            try {
                iniciarCicloSincronizacionRecurrente();
            } catch (Exception fallbackException) {
                log.error("❌ Error incluso en el respaldo del ciclo recurrente", fallbackException);
            }
        }
        
        log.info("🏁 Método ejecutarSincronizacionInicial() terminado completamente");
    }
    
    /**
     * Iniciar el ciclo de sincronización recurrente después de la sincronización inicial
     */
    private void iniciarCicloSincronizacionRecurrente() {
        log.info("🚀 INICIANDO MÉTODO iniciarCicloSincronizacionRecurrente()");
        
        // Crear un hilo dedicado para el ciclo recurrente
        Thread ciclicThread = new Thread(() -> {
            log.info("🧵 HILO DEL CICLO RECURRENTE INICIADO");
            try {
                int ciclo = 1;
                while (true) {
                    // Esperar el intervalo configurado
                    log.info("⏰ [CICLO {}] Esperando {} minutos antes de la próxima sincronización...", ciclo, intervalMinutes);
                    long sleepMs = intervalMinutes * 60 * 1000L;
                    log.info("⏰ [CICLO {}] Durmiendo por {} milisegundos...", ciclo, sleepMs);
                    Thread.sleep(sleepMs);
                    
                    // Ejecutar sincronización
                    log.info("🔔 [CICLO {}] INICIANDO CICLO DE SINCRONIZACIÓN PROGRAMADA", ciclo);
                    ejecutarSincronizacionCompleta();
                    log.info("✅ [CICLO {}] Ciclo de sincronización completado", ciclo);
                    ciclo++;
                }
            } catch (InterruptedException e) {
                log.warn("⚠️ Ciclo de sincronización interrumpido", e);
                Thread.currentThread().interrupt();
            } catch (Exception e) {
                log.error("❌ Error crítico en ciclo de sincronización", e);
                // Reiniciar el ciclo después de un error
                log.info("🔄 Reiniciando ciclo de sincronización...");
                iniciarCicloSincronizacionRecurrente();
            }
        }, "SyncCycle-Thread");
        
        ciclicThread.setDaemon(false); // No es daemon para que mantenga viva la JVM
        ciclicThread.start();
        log.info("🧵 Thread SyncCycle-Thread iniciado: {}", ciclicThread.getName());
        
        log.info("🚀 Método iniciarCicloSincronizacionRecurrente() completado");
    }
    
    private void ejecutarSincronizacionCompleta() {
        log.info("╔════════════════════════════════════════════════════════════╗");
        log.info("║     INICIANDO PROCESO DE SINCRONIZACIÓN BIDIRECCIONAL     ║");
        log.info("╠════════════════════════════════════════════════════════════╣");
        log.info("║ HILO 1: Remote → Local (centros, maestro, area, seccion, tipo_trabajador, tarjetas, turno) ║");
        log.info("║ HILO 2: Local → Remote (asistencia_ht580)                 ║");
        log.info("╚════════════════════════════════════════════════════════════╝");
        
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
                    log.info("🧵 [{}] INICIADO - Orden: 1°centros_costo, 2°maestro, 3°area, 4°seccion, 5°tipo_trabajador, 6°tarjetas, 7°turno", threadName);
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
            
            // SINCRONIZADOR: Esperar a que AMBOS hilos terminen (SIN TIMEOUT)
            log.info("⏳ SINCRONIZADOR: Esperando que AMBOS HILOS terminen su ejecución...");
            log.info("⏳ (Sin timeout - los hilos pueden tomar el tiempo que necesiten)");
            latch.await(); // Espera indefinidamente hasta que ambos hilos terminen
            
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
            
            // Generar y enviar reporte SOLO SI HA HABIDO ACTIVIDAD
            generarYEnviarReporteCondicional(inicioSync, finSync, resultadoRemoteToLocal, resultadoLocalToRemote);
            
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
            log.info("╔════════════════════════════════════════════════════════════╗");
            log.info("║   PROCESO DE SINCRONIZACIÓN FINALIZADO                    ║");
            log.info("║   Próxima ejecución en: {} minutos                        ║", intervalMinutes);
            log.info("╚════════════════════════════════════════════════════════════╝");
        }
    }
    
    /**
     * Ejecutar sincronización de Remote → Local CON ORDEN CORRECTO
     * IMPORTANTE: Orden específico - centros_costo, maestro, area, seccion, tipo_trabajador, tarjetas, turno
     */
    private boolean ejecutarSyncRemoteToLocalConOrden() {
        log.info("🔥 [HILO 1] Iniciando sincronización Remote → Local con ORDEN CORRECTO");
        
        try {
            // PASO -1: Sincronizar CONFIGURACION primero (parámetros del sistema, usados por todos los microservicios via sigre-config-common)
            log.info("📍 [HILO 1] PASO -1: Sincronizando CONFIGURACION...");
            boolean configOk = remoteToLocalSync.sincronizarConfiguracion();
            if (!configOk && maxRetries > 0) {
                configOk = manejarErrorConReintento("configuracion", () -> remoteToLocalSync.sincronizarConfiguracion());
            }
            
            if (!configOk) {
                log.warn("⚠️ [HILO 1] Fallo en CONFIGURACION - No es crítico, continuando");
            }
            
            // PASO 0: Sincronizar ORIGEN (no tiene dependencias, tabla de configuración)
            log.info("📍 [HILO 1] PASO 0/9: Sincronizando ORIGEN...");
            boolean origenOk = remoteToLocalSync.sincronizarOrigen();
            if (!origenOk && maxRetries > 0) {
                origenOk = manejarErrorConReintento("origen", () -> remoteToLocalSync.sincronizarOrigen());
            }
            
            if (!origenOk) {
                log.warn("⚠️ [HILO 1] Fallo en ORIGEN - No es crítico, continuando");
            }
            
            // PASO 0.5: Sincronizar CARGO (no tiene dependencias, catálogo)
            log.info("📍 [HILO 1] PASO 0.5/9: Sincronizando CARGO...");
            boolean cargoOk = remoteToLocalSync.sincronizarCargo();
            if (!cargoOk && maxRetries > 0) {
                cargoOk = manejarErrorConReintento("cargo", () -> remoteToLocalSync.sincronizarCargo());
            }
            
            if (!cargoOk) {
                log.warn("⚠️ [HILO 1] Fallo en CARGO - No es crítico, continuando");
            }
            
            // PASO 1: Sincronizar CENTROS DE COSTO (no tiene dependencias)
            log.info("📍 [HILO 1] PASO 1/9: Sincronizando CENTROS_COSTO...");
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
                log.error("❌ [HILO 1] Fallo en MAESTRO - Continuando con tipo_trabajador");
            }

            // PASO 3: Sincronizar AREA (base para secciones)
            log.info("📍 [HILO 1] PASO 3/6: Sincronizando AREA...");
            boolean areaOk = remoteToLocalSync.sincronizarArea();
            if (!areaOk && maxRetries > 0) {
                areaOk = manejarErrorConReintento("area", () -> remoteToLocalSync.sincronizarArea());
            }

            if (!areaOk) {
                log.error("❌ [HILO 1] Fallo en AREA - Continuando con secciones");
            }

            // PASO 4: Sincronizar SECCION (depende de area)
            log.info("📍 [HILO 1] PASO 4/6: Sincronizando SECCION...");
            boolean seccionOk = remoteToLocalSync.sincronizarSeccion();
            if (!seccionOk && maxRetries > 0) {
                seccionOk = manejarErrorConReintento("seccion", () -> remoteToLocalSync.sincronizarSeccion());
            }

            if (!seccionOk) {
                log.error("❌ [HILO 1] Fallo en SECCION - Continuando con tipo_trabajador");
            }

            // PASO 5: Sincronizar TIPO_TRABAJADOR (independiente)
            log.info("📍 [HILO 1] PASO 5/6: Sincronizando TIPO_TRABAJADOR...");
            boolean tipoTrabajadorOk = remoteToLocalSync.sincronizarTipoTrabajador();
            if (!tipoTrabajadorOk && maxRetries > 0) {
                tipoTrabajadorOk = manejarErrorConReintento("tipo_trabajador", () -> remoteToLocalSync.sincronizarTipoTrabajador());
            }

            if (!tipoTrabajadorOk) {
                log.error("❌ [HILO 1] Fallo en TIPO_TRABAJADOR - Continuando con tarjetas");
            }

            // PASO 6: Sincronizar TARJETAS DE RELOJ (depende de maestro)
            log.info("📍 [HILO 1] PASO 6/7: Sincronizando RRHH_ASIGNA_TRJT_RELOJ...");
            boolean tarjetasOk = remoteToLocalSync.sincronizarTarjetasReloj();
            if (!tarjetasOk && maxRetries > 0) {
                tarjetasOk = manejarErrorConReintento("tarjetas", () -> remoteToLocalSync.sincronizarTarjetasReloj());
            }
            
            if (!tarjetasOk) {
                log.error("❌ [HILO 1] Fallo en TARJETAS - Continuando con turno");
            }
            
            // PASO 7: Sincronizar TURNO (independiente - para consultas rápidas de asistencia)
            log.info("📍 [HILO 1] PASO 7/7: Sincronizando TURNO...");
            boolean turnoOk = remoteToLocalSync.sincronizarTurno();
            if (!turnoOk && maxRetries > 0) {
                turnoOk = manejarErrorConReintento("turno", () -> remoteToLocalSync.sincronizarTurno());
            }
            
            if (!turnoOk) {
                log.error("❌ [HILO 1] Fallo en TURNO - No crítico para asistencia");
            }
            
            boolean todoOk = origenOk && cargoOk && centrosOk && maestroOk && areaOk && seccionOk && tipoTrabajadorOk && tarjetasOk && turnoOk;
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
            
            // Sincronizar parámetros nuevos de CONFIGURACION (solo INSERT de parámetros que no existen en Oracle)
            log.info("📍 [HILO 2] Sincronizando CONFIGURACION nuevos parámetros (Local → Remote)...");
            boolean configOk = localToRemoteSync.sincronizarConfiguracionNuevosParametros();
            if (!configOk && maxRetries > 0) {
                configOk = manejarErrorConReintento("configuracion_local_to_remote", () -> localToRemoteSync.sincronizarConfiguracionNuevosParametros());
            }
            
            if (!configOk) {
                log.warn("⚠️ [HILO 2] Fallo en CONFIGURACION Local → Remote - No es crítico, continuando");
            }

            boolean resultadoFinal = asistenciaOk && configOk;
            log.info("✅ [HILO 2] Sincronización Local → Remote completada - Resultado: {}", resultadoFinal ? "ÉXITO" : "CON ERRORES");
            return resultadoFinal;
            
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
    
    /**
     * Generar y enviar reporte SOLO SI ha habido actividad en el sistema
     */
    private void generarYEnviarReporteCondicional(LocalDateTime inicioSync, LocalDateTime finSync, 
                                                 boolean resultadoRemoteToLocal, boolean resultadoLocalToRemote) {
        try {
            // Solo enviar reportes entre 6:00 AM y 8:00 PM
            int horaActual = LocalDateTime.now().getHour();
            if (horaActual < 6 || horaActual >= 20) {
                log.info("😴 Fuera de horario de envío de reportes (6:00-20:00). Hora actual: {}:00", horaActual);
                return;
            }

            log.info("🔍 Verificando si se debe enviar reporte de sincronización...");
            
            boolean hayActividad = activityDetectionService.hayActividadReciente(intervalMinutes);
            String resumenActividad = activityDetectionService.getResumenActividad(intervalMinutes);
            
            // ✅ VERIFICAR si hubo operaciones específicas en Oracle (FASE 2A/2B/3)
            boolean huboCambiosOracle = (localToRemoteSync.getOracleInsertados() > 0 || 
                                       localToRemoteSync.getOracleActualizados() > 0 || 
                                       localToRemoteSync.getOracleEliminados() > 0);
            
            // CONDICIONES PARA ENVIAR REPORTE:
            // 1. Ha habido nuevas marcas de asistencia
            // 2. Ha ocurrido sincronización de alguna tabla
            // 3. Ha habido errores
            // 4. La sincronización falló (para reportar el problema)
            // 5. 🆕 Hubo operaciones en Oracle (INSERT/UPDATE/DELETE en FASE 2A/2B/3)
            boolean debeEnviarReporte = hayActividad || !resultadoRemoteToLocal || !resultadoLocalToRemote || huboCambiosOracle;
            
            if (!debeEnviarReporte) {
                log.info("😴 SIN ACTIVIDAD Y SIN ERRORES - Omitiendo envío de reporte");
                log.info("📊 {}", resumenActividad);
                log.info("📊 Oracle: {} insertados, {} actualizados, {} eliminados", 
                        localToRemoteSync.getOracleInsertados(),
                        localToRemoteSync.getOracleActualizados(), 
                        localToRemoteSync.getOracleEliminados());
                log.info("🔔 Próximo reporte programado para: {}", finSync.plusMinutes(intervalMinutes));
                return; // ⚡ SALIR SIN ENVIAR REPORTE
            }
            
            if (hayActividad) {
                log.info("✅ ACTIVIDAD DETECTADA - Procediendo con envío de reporte");
                log.info("📊 {}", resumenActividad);
            } else if (huboCambiosOracle) {
                log.info("🔄 CAMBIOS EN ORACLE DETECTADOS - Procediendo con envío de reporte");
                log.info("📊 Oracle: {} insertados, {} actualizados, {} eliminados", 
                        localToRemoteSync.getOracleInsertados(),
                        localToRemoteSync.getOracleActualizados(), 
                        localToRemoteSync.getOracleEliminados());
            } else {
                log.warn("⚠️ SIN ACTIVIDAD PERO CON ERRORES - Enviando reporte de errores");
            }
            
            // Continuar con generación de reporte normal (mismo contenido)
            generarYEnviarReporte(inicioSync, finSync, resultadoRemoteToLocal, resultadoLocalToRemote);
            
        } catch (Exception e) {
            log.error("❌ Error al verificar actividad para reporte", e);
            // En caso de error, enviar reporte de todas formas para no perder información crítica
            log.info("🚨 Por error en detección, enviando reporte como medida de seguridad");
            generarYEnviarReporte(inicioSync, finSync, resultadoRemoteToLocal, resultadoLocalToRemote);
        }
    }
    
    private void generarYEnviarReporte(LocalDateTime inicioSync, LocalDateTime finSync, 
                                       boolean resultadoRemoteToLocal, boolean resultadoLocalToRemote) {
        try {
            log.info("📧 Generando reporte de sincronización para envío por email...");
            
            long duracionMinutos = Duration.between(inicioSync, finSync).toMinutes();
            
            Map<String, EmailNotificationServiceHTML.SyncTableStats> estadisticasDetalladas = new HashMap<>();
            
            // Estadísticas de Remote → Local
            estadisticasDetalladas.put("origen", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("origen")
                    .registrosInsertados(remoteToLocalSync.getInsertados("origen"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("origen"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("origen"))
                    .registrosErrores(remoteToLocalSync.getErrores("origen"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("origen") == 0)
                    .build());
            
            estadisticasDetalladas.put("cargo", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("cargo")
                    .registrosInsertados(remoteToLocalSync.getInsertados("cargo"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("cargo"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("cargo"))
                    .registrosErrores(remoteToLocalSync.getErrores("cargo"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("cargo") == 0)
                    .build());
            
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

            estadisticasDetalladas.put("area", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("area")
                    .registrosInsertados(remoteToLocalSync.getInsertados("area"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("area"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("area"))
                    .registrosErrores(remoteToLocalSync.getErrores("area"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("area") == 0)
                    .build());

            estadisticasDetalladas.put("seccion", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("seccion")
                    .registrosInsertados(remoteToLocalSync.getInsertados("seccion"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("seccion"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("seccion"))
                    .registrosErrores(remoteToLocalSync.getErrores("seccion"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("seccion") == 0)
                    .build());

            estadisticasDetalladas.put("tipo_trabajador", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("tipo_trabajador")
                    .registrosInsertados(remoteToLocalSync.getInsertados("tipo_trabajador"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("tipo_trabajador"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("tipo_trabajador"))
                    .registrosErrores(remoteToLocalSync.getErrores("tipo_trabajador"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("tipo_trabajador") == 0)
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
                    
            estadisticasDetalladas.put("turno", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("turno")
                    .registrosInsertados(remoteToLocalSync.getInsertados("turno"))
                    .registrosActualizados(remoteToLocalSync.getActualizados("turno"))
                    .registrosEliminados(remoteToLocalSync.getEliminados("turno"))
                    .registrosErrores(remoteToLocalSync.getErrores("turno"))
                    .direccion("REMOTE_TO_LOCAL")
                    .baseOrigen("bd_remota")
                    .baseDestino("bd_local")
                    .exitoso(remoteToLocalSync.getErrores("turno") == 0)
                    .build());
            
            // Estadísticas de Local → Remote (mostrando operaciones específicas en Oracle)
            estadisticasDetalladas.put("asistencia_ht580", EmailNotificationServiceHTML.SyncTableStats.builder()
                    .nombreTabla("asistencia_ht580")
                    .registrosInsertados(localToRemoteSync.getOracleInsertados()) // 📊 Oracle específico
                    .registrosActualizados(localToRemoteSync.getOracleActualizados()) // 📊 Oracle específico
                    .registrosEliminados(localToRemoteSync.getOracleEliminados()) // 📊 Oracle específico
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
                .syncInProgress(false) // Con el nuevo diseño secuencial, no rastreamos este estado
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