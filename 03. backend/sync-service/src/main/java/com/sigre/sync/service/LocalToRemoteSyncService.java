package com.sigre.sync.service;

import com.sigre.sync.entity.local.AsistenciaHt580Local;
import com.sigre.sync.entity.remote.AsistenciaHt580Remote;
import com.sigre.sync.repository.local.AsistenciaHt580LocalRepository;
import com.sigre.sync.repository.remote.AsistenciaHt580RemoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
@Slf4j
public class LocalToRemoteSyncService {
    
    private final AsistenciaHt580LocalRepository asistenciaLocalRepository;
    private final AsistenciaHt580RemoteRepository asistenciaRemoteRepository;
    private final ObjectMapper objectMapper;
    private final JdbcTemplate jdbcTemplateRemote;
    
    // Constructor para inyectar JdbcTemplate
    public LocalToRemoteSyncService(
            AsistenciaHt580LocalRepository asistenciaLocalRepository,
            AsistenciaHt580RemoteRepository asistenciaRemoteRepository,
            ObjectMapper objectMapper,
            @Qualifier("remoteDataSource") DataSource remoteDataSource) {
        this.asistenciaLocalRepository = asistenciaLocalRepository;
        this.asistenciaRemoteRepository = asistenciaRemoteRepository;
        this.objectMapper = objectMapper;
        this.jdbcTemplateRemote = new JdbcTemplate(remoteDataSource);
    }
    
    @Value("${sync.config.max-retries:5}")
    private int maxRetries;
    
    @Value("${sync.config.cod-origen:SE}")
    private String codOrigenConfiguracion;
    
    private final List<String> erroresSincronizacion = new ArrayList<>();
    private int registrosInsertados = 0;
    private int registrosActualizados = 0;
    private int registrosEliminados = 0;
    private int registrosErrores = 0;
    
    // 📊 Contadores específicos para operaciones en Oracle
    private int oracleInsertados = 0;
    private int oracleActualizados = 0;
    private int oracleEliminados = 0;
    
    /**
     * Sincronizar tabla asistencia_ht580 de PostgreSQL → Oracle
     */
    public boolean sincronizarAsistencia() {
        log.info("📤 Iniciando sincronización de tabla ASISTENCIA_HT580 (Local → Remote)");
        
        try {
            // ✅ PASO 0: Resetear registros bloqueados (PRIMERO, antes de todo)
            resetearRegistrosBloqueados();
            
            // Resetear contadores
            resetearContadores();
            
            // Obtener registros pendientes + errores con reintentos disponibles
            List<AsistenciaHt580Local> asistenciasPendientes = asistenciaLocalRepository.findPendientesParaSincronizacion(maxRetries);
            log.info("📊 Encontrados {} registros de asistencia pendientes (incluyendo {} reintentos)", 
                    asistenciasPendientes.size(), 
                    asistenciasPendientes.stream().mapToInt(a -> "E".equals(a.getEstadoSync()) ? 1 : 0).sum());
            
            // Procesar cada registro de asistencia
            for (AsistenciaHt580Local asistenciaLocal : asistenciasPendientes) {
                try {
                    procesarAsistencia(asistenciaLocal);
                } catch (Exception e) {
                    registrosErrores++;
                    String error = String.format("Error en asistencia %s: %s", 
                            asistenciaLocal.getReckey(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                    
                    // Marcar como error en local
                    asistenciaLocal.setEstadoSync("E");
                    asistenciaLocal.setIntentosSync(asistenciaLocal.getIntentosSync() + 1);
                    asistenciaLocalRepository.save(asistenciaLocal);
                }
            }
            
            log.info("✅ FASE 1 completada - Insertados: {} | Errores: {}", 
                    registrosInsertados, registrosErrores);
            
            // ✅ FASE 2: Sincronizar cambios de registros ya sincronizados
            sincronizarCambiosRegistrosSincronizados();
            
            // ✅ FASE 3: Eliminar registros huérfanos de Oracle
            eliminarRegistrosHuerfanosOracle();
            
            log.info("✅ Sincronización ASISTENCIA_HT580 completada - Insertados: {} | Errores: {}", 
                    registrosInsertados, registrosErrores);
            
            // 📊 Log específico de operaciones en Oracle
            log.info("📊 OPERACIONES EN ORACLE - Insertados: {} | Actualizados: {} | Eliminados: {}", 
                    oracleInsertados, oracleActualizados, oracleEliminados);
            
            if (oracleInsertados > 0) {
                log.info("🆕 Registros RE-INSERTADOS incluyen AUTO_CLOSE y registros sin external_id");
            }
            
            return registrosErrores == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de ASISTENCIA_HT580", e);
            erroresSincronizacion.add("Error crítico en tabla asistencia_ht580: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Procesar un registro de asistencia individual
     */
    @Transactional("remoteTransactionManager")
    private void procesarAsistencia(AsistenciaHt580Local asistenciaLocal) {
        String externalId = asistenciaLocal.getExternalId();
        boolean existeEnRemote = false;

        try {
            // Verificar si ya existe en Oracle
            if (externalId != null) {
                existeEnRemote = asistenciaRemoteRepository.existsById(externalId);
            } else {
                existeEnRemote = false;
            }
            
            if (!existeEnRemote) {
                // INSERTAR en Oracle
                
                // ✅ LOGGING JSON - Objeto local (PostgreSQL)
                try {
                    log.info("🔄 Asistencia Local (PostgreSQL): {}", objectMapper.writeValueAsString(asistenciaLocal));
                } catch (Exception e) {
                    log.info("🔄 Asistencia Local (PostgreSQL): {}", asistenciaLocal.toString());
                }
                
                AsistenciaHt580Remote asistenciaRemote = convertirLocalToRemote(asistenciaLocal);
                
                // ✅ LOGGING JSON - Objeto remoto ANTES del save
                try {
                    log.info("🔄 Asistencia Remota ANTES de Oracle: {}", objectMapper.writeValueAsString(asistenciaRemote));
                } catch (Exception e) {
                    log.info("🔄 Asistencia Remota ANTES de Oracle: {}", asistenciaRemote.toString());
                }

                asistenciaRemoteRepository.save(asistenciaRemote);
                oracleInsertados++; // 📊 Contador Oracle
                
                // ✅ CONSULTAR Oracle para obtener el reckey REAL generado por trigger
                AsistenciaHt580Remote asistenciaSaved = asistenciaRemoteRepository
                        .findRegistroRecienInsertado(
                                asistenciaRemote.getCodOrigen(),
                                asistenciaRemote.getCodigo(), 
                                asistenciaRemote.getFlagInOut(),
                                asistenciaRemote.getFechaMovimiento(),
                                asistenciaRemote.getFecMarcacion(),  // ✅ Agregar fec_marcacion
                                asistenciaRemote.getCodUsuario(),
                                asistenciaRemote.getDireccionIp(),
                                asistenciaRemote.getTurno(),
                                asistenciaRemote.getLecturaPda()
                        );
                
                String oracleReckey = "";
                if (asistenciaSaved != null) {
                    oracleReckey = asistenciaSaved.getReckey();
                    log.info("🔍 CONSULTA Oracle exitosa - ID real: {} (original local: {})", oracleReckey, asistenciaLocal.getReckey());
                    
                    // ✅ LOGGING JSON - Objeto real de Oracle
                    try {
                        log.info("🔄 Asistencia Oracle REAL (consultada): {}", objectMapper.writeValueAsString(asistenciaSaved));
                    } catch (Exception e) {
                        log.info("🔄 Asistencia Oracle REAL (consultada): {}", asistenciaSaved.toString());
                    }

                    // ✅ ACTUALIZAR registro con external_id de Oracle
                    asistenciaLocal.setExternalId(oracleReckey); // ID de Oracle de este registro
                    asistenciaLocal.setFechaUpdate(LocalDateTime.now());
                    
                    // ✅ NUEVA LÓGICA: Si tiene reckey_ref, guardar también el external_id de la referencia
                    if (asistenciaLocal.getReckeyRef() != null && !asistenciaLocal.getReckeyRef().trim().isEmpty()) {
                        Optional<AsistenciaHt580Local> marcacionRef = asistenciaLocalRepository.findById(asistenciaLocal.getReckeyRef());
                        if (marcacionRef.isPresent() && marcacionRef.get().getExternalId() != null) {
                            asistenciaLocal.setExternalIdRef(marcacionRef.get().getExternalId());
                            log.info("🔗 External_id_ref guardado: {} (de reckey_ref={})", 
                                    marcacionRef.get().getExternalId(), asistenciaLocal.getReckeyRef());
                        } else {
                            log.warn("⚠️ No se pudo obtener external_id para reckey_ref={}", asistenciaLocal.getReckeyRef());
                        }
                    }
                    
                    asistenciaLocal.setEstadoSync("S");
                    asistenciaLocal.setFechaSync(LocalDateTime.now());
                    asistenciaLocalRepository.save(asistenciaLocal);
                    
                    log.info("✅ External_id actualizado: {} → {} | External_id_ref: {}", 
                            asistenciaLocal.getReckey(), oracleReckey, asistenciaLocal.getExternalIdRef());
                
                } else {
                    // ❌ NO se encontró registro en Oracle - ERROR crítico
                    log.error("❌ CRÍTICO: No se encontró registro en Oracle después del save - posible fallo en trigger");
                    asistenciaLocal.setEstadoSync("E"); // ✅ Marcar como ERROR (no como sincronizado)
                    asistenciaLocal.setIntentosSync(asistenciaLocal.getIntentosSync() + 1);
                    asistenciaLocalRepository.save(asistenciaLocal);
                    registrosErrores++;
                }
                
                registrosInsertados++;
                log.debug("➕ Insertada asistencia en Oracle: {} con external_id: {}", asistenciaLocal.getReckey(), oracleReckey);
                
            } else {
                // Ya existe, pero tiene la fecha de update entonces lo actualizo
                if (asistenciaLocal.getFechaUpdate() != null && asistenciaLocal.getEstadoSync().equals("N")) {
                    Optional<AsistenciaHt580Remote> asistenciaRemoteOptional = asistenciaRemoteRepository.findById(externalId);

                    if (asistenciaRemoteOptional.isPresent()) {
                        AsistenciaHt580Remote asistenciaRemote = asistenciaRemoteOptional.get();
                        
                        //Actualizo los campos de la asistencia remota
                        asistenciaRemote.setFlagInOut(asistenciaLocal.getFlagInOut());
                        asistenciaRemote.setFecMarcacion(asistenciaLocal.getFecMarcacion());  // ✅ Fecha/hora de marcación
                        asistenciaRemote.setFechaMovimiento(asistenciaLocal.getFechaMovimiento());
                        asistenciaRemote.setCodUsuario(asistenciaLocal.getCodUsuario());
                        asistenciaRemote.setDireccionIp(asistenciaLocal.getDireccionIp());
                        asistenciaRemote.setFlagVerifyType(asistenciaLocal.getFlagVerifyType());
                        asistenciaRemote.setTurno(asistenciaLocal.getTurno());
                        asistenciaRemote.setLecturaPda(asistenciaLocal.getLecturaPda());

                        asistenciaRemoteRepository.save(asistenciaRemote);
                        oracleActualizados++; // 📊 Contador Oracle
                    }
                    
                }

                //Actualizo la sincronizacion en la base de dato slocal
                asistenciaLocal.setEstadoSync("S");
                asistenciaLocal.setFechaSync(LocalDateTime.now());
                asistenciaLocalRepository.save(asistenciaLocal);
                
                log.debug("⏭️ Asistencia ya existe en Oracle: {}", asistenciaLocal.getExternalId());
            }
            
        } catch (Exception e) {
            // ✅ CAPTURAR ERROR ESPECÍFICO para notificación
            registrosErrores++;
            
            String errorDetallado = String.format(
                "Error sincronizando asistencia RECKEY=%s, COD_ORIGEN=%s, CODIGO=%s: %s", 
                asistenciaLocal.getReckey(), asistenciaLocal.getCodOrigen(), asistenciaLocal.getCodigo(), e.getMessage()
            );
            
            erroresSincronizacion.add(errorDetallado);
            
            log.error("❌ Error procesando asistencia {} (COD_ORIGEN={}): {}", 
                     asistenciaLocal.getReckey(), asistenciaLocal.getCodOrigen(), e.getMessage());
            
            // Marcar registro como error en local para reintento
            asistenciaLocal.setEstadoSync("E"); // E = Error
            asistenciaLocal.setIntentosSync(asistenciaLocal.getIntentosSync() + 1);
            asistenciaLocalRepository.save(asistenciaLocal);
            
            log.info("🔄 Registro marcado como ERROR para reintento | RECKEY: {} | Intento: {}", 
                    asistenciaLocal.getReckey(), asistenciaLocal.getIntentosSync());
        }
    }
    
    /**
     * Obtener SYSDATE de Oracle (fecha y hora del servidor Oracle)
     */
    private LocalDateTime getSysdateFromOracle() {
        try {
            return jdbcTemplateRemote.queryForObject("SELECT SYSDATE FROM DUAL", LocalDateTime.class);
        } catch (Exception e) {
            log.warn("⚠️ Error obteniendo SYSDATE de Oracle, usando fecha local: {}", e.getMessage(), e);
            return LocalDateTime.now();
        }
    }
    
    /**
     * Convertir entidad local a remota
     * NUEVA LÓGICA: Si tiene reckey_ref local, buscar su external_id y usarlo como reckey_ref en Oracle
     */
    private AsistenciaHt580Remote convertirLocalToRemote(AsistenciaHt580Local local) {
        String reckeyRefParaOracle = null;
        
        // Si tiene reckey_ref local, buscar el external_id correspondiente
        if (local.getReckeyRef() != null && !local.getReckeyRef().trim().isEmpty()) {
            Optional<AsistenciaHt580Local> marcacionReferencia = asistenciaLocalRepository.findById(local.getReckeyRef());
            
            if (marcacionReferencia.isPresent() && marcacionReferencia.get().getExternalId() != null) {
                // Usar el external_id de la referencia como reckey_ref en Oracle
                reckeyRefParaOracle = marcacionReferencia.get().getExternalId();
                log.debug("🔗 Referencia resuelta: reckey_ref_local={} → external_id={}", 
                        local.getReckeyRef(), reckeyRefParaOracle);
            } else {
                log.warn("⚠️ No se encontró external_id para reckey_ref={}, se enviará NULL a Oracle", 
                        local.getReckeyRef());
            }
        }
        
        // Obtener fecha actual de Oracle
        LocalDateTime fechaRegistroOracle = getSysdateFromOracle();
        
        return AsistenciaHt580Remote.builder()
                .reckey(local.getReckey())
                .codOrigen(local.getCodOrigen())
                .codigo(local.getCodigo())
                .flagInOut(local.getFlagInOut())
                .fechaRegistro(fechaRegistroOracle)  // ✅ SYSDATE de Oracle
                .fecMarcacion(local.getFecMarcacion())  // Fecha y hora exacta de marcación
                .fechaMovimiento(local.getFechaMovimiento())
                .codUsuario(local.getCodUsuario())
                .direccionIp(local.getDireccionIp())
                .flagVerifyType(local.getFlagVerifyType())
                .turno(local.getTurno())
                .lecturaPda(local.getLecturaPda())
                .reckeyRef(reckeyRefParaOracle)  // ID de Oracle de la referencia
                .build();
    }
    
    /**
     * FASE 2: Sincronizar cambios de registros ya sincronizados
     * PostgreSQL (con external_id) → Comparar Oracle → Actualizar si diferente
     */
    @Transactional("remoteTransactionManager")
    private void sincronizarCambiosRegistrosSincronizados() {
        log.info("🔄 FASE 2: Sincronizando cambios de registros ya sincronizados");
        
        try {
            // ✅ Usar codOrigen de configuración
            String codOrigen = codOrigenConfiguracion;
            
            // Buscar registros PostgreSQL ya sincronizados (con external_id)
            List<AsistenciaHt580Local> registrosSincronizados = asistenciaLocalRepository
                    .findByEstadoSyncAndExternalIdIsNotNullAndCodOrigen("S", codOrigen);
            
            // 🆕 BUSCAR registros sincronizados SIN external_id (AUTO_CLOSE y otros)
            List<AsistenciaHt580Local> registrosSinExternalId = asistenciaLocalRepository
                    .findByEstadoSyncAndExternalIdIsNullAndCodOrigen("S", codOrigen);
            
            log.info("📊 FASE 2: Encontrados {} registros sincronizados CON external_id para verificar", registrosSincronizados.size());
            log.info("📊 FASE 2: Encontrados {} registros sincronizados SIN external_id para re-insertar", registrosSinExternalId.size());
            
            for (AsistenciaHt580Local localRecord : registrosSincronizados) {
                // Buscar en Oracle por external_id
                AsistenciaHt580Remote oracleRecord = asistenciaRemoteRepository
                        .findById(localRecord.getExternalId())
                        .orElse(null);
                
                if (oracleRecord == null) {
                    // No existe en Oracle - re-insertar
                    log.warn("🔄 FASE 2: Registro {} no existe en Oracle, re-insertando", localRecord.getExternalId());
                    AsistenciaHt580Remote nuevoRegistro = convertirLocalToRemote(localRecord);
                    asistenciaRemoteRepository.save(nuevoRegistro);
                    
                    // ✅ OBTENER EL NUEVO RECKEY GENERADO POR ORACLE
                    AsistenciaHt580Remote registroConNuevoReckey = asistenciaRemoteRepository
                            .findRegistroRecienInsertado(
                                    nuevoRegistro.getCodOrigen(),
                                    nuevoRegistro.getCodigo(), 
                                    nuevoRegistro.getFlagInOut(),
                                    nuevoRegistro.getFechaMovimiento(),
                                    nuevoRegistro.getFecMarcacion(),  // ✅ Agregar fec_marcacion
                                    nuevoRegistro.getCodUsuario(),
                                    nuevoRegistro.getDireccionIp(),
                                    nuevoRegistro.getTurno(),
                                    nuevoRegistro.getLecturaPda()
                            );
                    
                    if (registroConNuevoReckey != null) {
                        // ✅ ACTUALIZAR EXTERNAL_ID CON EL NUEVO RECKEY DE ORACLE
                        localRecord.setExternalId(registroConNuevoReckey.getReckey());
                        asistenciaLocalRepository.save(localRecord);
                        log.info("✅ FASE 2: External_id actualizado de {} a {}", 
                                localRecord.getExternalId(), registroConNuevoReckey.getReckey());
                    }
                    
                    registrosActualizados++;
                    oracleInsertados++; // 📊 Contador Oracle (re-insert)
                    
                } else {
                    // Comparar datos y actualizar si es diferente
                    if (sonDiferentes(localRecord, oracleRecord)) {
                        log.info("🔄 FASE 2: Actualizando registro {} en Oracle", localRecord.getExternalId());
                        actualizarRegistroOracle(localRecord, oracleRecord);
                        registrosActualizados++;
                        oracleActualizados++; // 📊 Contador Oracle
                    }
                }
            }
            
            // 🆕 PROCESAR registros sincronizados SIN external_id (AUTO_CLOSE y otros)
            log.info("🔄 FASE 2B: Procesando registros sincronizados SIN external_id");
            for (AsistenciaHt580Local recordSinExternalId : registrosSinExternalId) {
                try {
                    log.info("🔄 FASE 2B: Re-insertando registro {} en Oracle (AUTO_CLOSE o similar)", recordSinExternalId.getReckey());
                    
                    // Convertir y re-insertar en Oracle
                    AsistenciaHt580Remote nuevoRegistroOracle = convertirLocalToRemote(recordSinExternalId);
                    
                    // 🔍 LOGGING DETALLADO - Datos que se envían a Oracle
                    log.info("🔍 FASE 2B: Datos enviados a Oracle para {}: COD_ORIGEN={}, CODIGO={}, FLAG_IN_OUT={}, DIRECCION_IP={}, LECTURA_PDA={}", 
                            recordSinExternalId.getReckey(), 
                            nuevoRegistroOracle.getCodOrigen(),
                            nuevoRegistroOracle.getCodigo(),
                            nuevoRegistroOracle.getFlagInOut(),
                            nuevoRegistroOracle.getDireccionIp(),
                            nuevoRegistroOracle.getLecturaPda());
                    
                    asistenciaRemoteRepository.save(nuevoRegistroOracle);
                    oracleInsertados++; // 📊 Contador Oracle
                    
                    // ✅ CONSULTAR Oracle para obtener el reckey REAL generado
                    AsistenciaHt580Remote registroConReckey = asistenciaRemoteRepository
                            .findRegistroRecienInsertado(
                                    nuevoRegistroOracle.getCodOrigen(),
                                    nuevoRegistroOracle.getCodigo(), 
                                    nuevoRegistroOracle.getFlagInOut(),
                                    nuevoRegistroOracle.getFechaMovimiento(),
                                    nuevoRegistroOracle.getFecMarcacion(),  // ✅ Agregar fec_marcacion
                                    nuevoRegistroOracle.getCodUsuario(),
                                    nuevoRegistroOracle.getDireccionIp(),
                                    nuevoRegistroOracle.getTurno(),
                                    nuevoRegistroOracle.getLecturaPda()
                            );
                    
                    // 🔍 LOGGING DETALLADO - Resultado de la consulta
                    if (registroConReckey == null) {
                        log.error("🔍 FASE 2B: CONSULTA ORACLE FALLÓ - Parámetros de búsqueda:");
                        log.error("    COD_ORIGEN: '{}'", nuevoRegistroOracle.getCodOrigen());
                        log.error("    CODIGO: '{}'", nuevoRegistroOracle.getCodigo());
                        log.error("    FLAG_IN_OUT: '{}'", nuevoRegistroOracle.getFlagInOut());
                        log.error("    FECHA_MOVIMIENTO: '{}'", nuevoRegistroOracle.getFechaMovimiento());
                        log.error("    COD_USUARIO: '{}'", nuevoRegistroOracle.getCodUsuario());
                        log.error("    DIRECCION_IP: '{}'", nuevoRegistroOracle.getDireccionIp());
                        log.error("    TURNO: '{}'", nuevoRegistroOracle.getTurno());
                        log.error("    LECTURA_PDA: '{}'", nuevoRegistroOracle.getLecturaPda());
                    }
                    
                    if (registroConReckey != null) {
                        // ✅ ACTUALIZAR con el external_id de Oracle
                        recordSinExternalId.setExternalId(registroConReckey.getReckey());
                        recordSinExternalId.setFechaUpdate(LocalDateTime.now());
                        asistenciaLocalRepository.save(recordSinExternalId);
                        
                        log.info("✅ FASE 2B: External_id poblado: {} → {} ({})", 
                                recordSinExternalId.getReckey(), 
                                registroConReckey.getReckey(),
                                recordSinExternalId.getDireccionIp().contains("AUTO-CLOSE") ? "AUTO-CLOSE" : "NORMAL");
                        
                        registrosActualizados++;
                    } else {
                        log.error("❌ FASE 2B: No se pudo obtener reckey de Oracle para {}", recordSinExternalId.getReckey());
                    }
                    
                } catch (Exception e) {
                    log.error("❌ FASE 2B: Error re-insertando registro {}: {}", 
                            recordSinExternalId.getReckey(), e.getMessage(), e);
                    erroresSincronizacion.add("Error FASE 2B re-insert: " + recordSinExternalId.getReckey() + " - " + e.getMessage());
                    registrosErrores++;
                }
            }
            
            log.info("✅ FASE 2 completada - Actualizados: {} (incluye {} re-inserts)", registrosActualizados, registrosSinExternalId.size());
            
        } catch (Exception e) {
            log.error("❌ Error en FASE 2: {}", e.getMessage(), e);
            erroresSincronizacion.add("Error en FASE 2: " + e.getMessage());
        }
    }
    
    /**
     * FASE 3: Eliminar registros huérfanos de Oracle
     * Oracle (filtro cod_origen) → Buscar PostgreSQL → Eliminar Oracle si no existe
     */
    private void eliminarRegistrosHuerfanosOracle() {
        log.info("🔄 FASE 3: Eliminando registros huérfanos de Oracle");

        try {
            // ✅ Usar codOrigen de configuración
            String codOrigen = codOrigenConfiguracion;

            // Obtener TODOS los registros de Oracle para este origen
            List<AsistenciaHt580Remote> registrosOracle = asistenciaRemoteRepository
                    .findByCodOrigenOrderByFechaRegistroDesc(codOrigen);

            log.info("📊 FASE 3: Verificando {} registros Oracle para origen {}",
                    registrosOracle.size(), codOrigen);

            // Procesar cada registro individualmente con transacción separada
            for (AsistenciaHt580Remote oracleRecord : registrosOracle) {
                try {
                    procesarRegistroHuerfano(oracleRecord);
                } catch (Exception e) {
                    log.warn("⚠️ Error procesando registro {} en FASE 3: {}", oracleRecord.getReckey(), e.getMessage(), e);
                    // Continuar con el siguiente registro en lugar de fallar completamente
                }
            }

            log.info("✅ FASE 3 completada - Eliminados: {}", registrosEliminados);

        } catch (Exception e) {
            log.error("❌ Error crítico en FASE 3: {}", e.getMessage(), e);
            erroresSincronizacion.add("Error crítico en FASE 3: " + e.getMessage());
        }
    }

    @Transactional("remoteTransactionManager")
    private void procesarRegistroHuerfano(AsistenciaHt580Remote oracleRecord) {
        // Buscar en PostgreSQL por external_id
        AsistenciaHt580Local localRecord = asistenciaLocalRepository
                .findByExternalId(oracleRecord.getReckey())
                .orElse(null);

        if (localRecord == null) {
            // No existe en PostgreSQL - eliminar de Oracle
            log.warn("🗑️ FASE 3: Eliminando registro huérfano {} de Oracle", oracleRecord.getReckey());
            asistenciaRemoteRepository.delete(oracleRecord);
            registrosEliminados++;
            oracleEliminados++; // 📊 Contador Oracle
        }
    }
    
    /**
     * Comparar si dos registros tienen datos diferentes
     */
    private boolean sonDiferentes(AsistenciaHt580Local local, AsistenciaHt580Remote oracle) {
        return !local.getCodigo().equals(oracle.getCodigo()) ||
               !local.getFlagInOut().equals(oracle.getFlagInOut()) ||
               !local.getFecMarcacion().equals(oracle.getFecMarcacion()) ||  // ✅ Comparar fec_marcacion
               !local.getFechaMovimiento().equals(oracle.getFechaMovimiento()) ||
               !local.getCodUsuario().trim().equals(oracle.getCodUsuario().trim()) ||
               !local.getDireccionIp().equals(oracle.getDireccionIp());
    }
    
    /**
     * Actualizar registro de Oracle con datos de PostgreSQL
     */
    private void actualizarRegistroOracle(AsistenciaHt580Local local, AsistenciaHt580Remote oracle) {
        oracle.setCodigo(local.getCodigo());
        oracle.setFlagInOut(local.getFlagInOut());
        oracle.setFecMarcacion(local.getFecMarcacion());  // ✅ Actualizar fec_marcacion
        oracle.setFechaMovimiento(local.getFechaMovimiento());
        oracle.setCodUsuario(local.getCodUsuario());
        oracle.setDireccionIp(local.getDireccionIp());
        oracle.setFlagVerifyType(local.getFlagVerifyType());
        oracle.setTurno(local.getTurno());
        oracle.setLecturaPda(local.getLecturaPda());
        
        asistenciaRemoteRepository.save(oracle);
    }
    
    /**
     * ✅ RESETEO AUTOMÁTICO DE REGISTROS BLOQUEADOS
     * Busca registros que agotaron sus reintentos (intentos_sync >= maxRetries)
     * y que llevan más de 3 horas bloqueados, para darles una nueva oportunidad
     */
    @Transactional("localTransactionManager")
    private void resetearRegistrosBloqueados() {
        try {
            log.info("🔄 PASO 0: Verificando registros bloqueados para reseteo automático...");
            
            // Calcular timestamp de hace 3 horas
            LocalDateTime hace3Horas = LocalDateTime.now().minusHours(3);
            
            // Buscar registros que cumplan TODAS estas condiciones:
            // 1. intentos_sync >= maxRetries (agotaron reintentos)
            // 2. (fecha_sync IS NULL O external_id IS NULL) (nunca se sincronizó exitosamente)
            // 3. fecha_registro < hace 3 horas (llevan más de 3 horas bloqueados)
            List<AsistenciaHt580Local> registrosBloqueados = asistenciaLocalRepository.findAll()
                .stream()
                .filter(a -> a.getCodOrigen() != null && a.getCodOrigen().equals(codOrigenConfiguracion))
                .filter(a -> "E".equals(a.getEstadoSync())) // Solo errores
                .filter(a -> a.getIntentosSync() != null && a.getIntentosSync() >= maxRetries) // Agotó reintentos
                .filter(a -> a.getFechaSync() == null || a.getExternalId() == null) // Nunca sincronizó exitosamente
                .filter(a -> a.getFechaRegistro() != null && a.getFechaRegistro().isBefore(hace3Horas)) // Más de 3 horas
                .toList();
            
            if (registrosBloqueados.isEmpty()) {
                log.info("✅ No hay registros bloqueados para resetear");
                return;
            }
            
            log.info("🔄 Encontrados {} registros bloqueados que cumplen condiciones de reseteo:", 
                    registrosBloqueados.size());
            log.info("   - intentos_sync >= {} (maxRetries)", maxRetries);
            log.info("   - fecha_sync IS NULL O external_id IS NULL");
            log.info("   - fecha_registro > 3 horas de antigüedad");
            
            // Resetear cada registro
            int contadorReseteados = 0;
            for (AsistenciaHt580Local registro : registrosBloqueados) {
                try {
                    // Calcular horas transcurridas desde el registro
                    long horasTranscurridas = java.time.Duration.between(
                        registro.getFechaRegistro(), 
                        LocalDateTime.now()
                    ).toHours();
                    
                    log.debug("🔄 Reseteando registro {} - Intentos: {} | Horas bloqueado: {} | Trabajador: {}", 
                            registro.getReckey(), 
                            registro.getIntentosSync(),
                            horasTranscurridas,
                            registro.getCodigo());
                    
                    // Resetear estado
                    registro.setEstadoSync("P");  // Volver a Pendiente
                    registro.setIntentosSync(0);  // Resetear contador
                    registro.setFechaSync(null);  // Limpiar fecha de sincronización
                    
                    asistenciaLocalRepository.save(registro);
                    contadorReseteados++;
                    
                } catch (Exception e) {
                    log.error("❌ Error reseteando registro {}: {}", registro.getReckey(), e.getMessage(), e);
                }
            }
            
            if (contadorReseteados > 0) {
                log.info("✅ RESETEO COMPLETADO: {} registros bloqueados fueron reseteados y estarán disponibles para sincronización", 
                        contadorReseteados);
            }
            
        } catch (Exception e) {
            log.error("❌ Error en proceso de reseteo automático de registros bloqueados: {}", e.getMessage(), e);
            // No detener el proceso de sincronización por este error
        }
    }
    
    /**
     * Resetear contadores para nueva sincronización
     */
    private void resetearContadores() {
        registrosInsertados = 0;
        registrosActualizados = 0;
        registrosEliminados = 0;
        registrosErrores = 0;
        erroresSincronizacion.clear();
        
        // 📊 Resetear contadores Oracle
        oracleInsertados = 0;
        oracleActualizados = 0;
        oracleEliminados = 0;
    }
    
    // Getters para estadísticas
    public int getRegistrosInsertados() { return registrosInsertados; }
    public int getRegistrosActualizados() { return registrosActualizados; }
    public int getRegistrosEliminados() { return registrosEliminados; }
    public int getRegistrosErrores() { return registrosErrores; }
    public List<String> getErrores() { return new ArrayList<>(erroresSincronizacion); }
    
    // 📊 Getters para contadores específicos de Oracle
    public int getOracleInsertados() { return oracleInsertados; }
    public int getOracleActualizados() { return oracleActualizados; }
    public int getOracleEliminados() { return oracleEliminados; }
}
