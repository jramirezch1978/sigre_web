package com.sigre.sync.service;

import com.sigre.sync.entity.local.AsistenciaHt580Local;
import com.sigre.sync.entity.remote.AsistenciaHt580Remote;
import com.sigre.sync.repository.local.AsistenciaHt580LocalRepository;
import com.sigre.sync.repository.remote.AsistenciaHt580RemoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocalToRemoteSyncService {
    
    private final AsistenciaHt580LocalRepository asistenciaLocalRepository;
    private final AsistenciaHt580RemoteRepository asistenciaRemoteRepository;
    private final ObjectMapper objectMapper;
    
    @Value("${sync.config.max-retries:1}")
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
    @Transactional("remoteTransactionManager")
    public boolean sincronizarAsistencia() {
        log.info("📤 Iniciando sincronización de tabla ASISTENCIA_HT580 (Local → Remote)");
        
        try {
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
                // Con formato de fecha y TRIM para evitar problemas de precisión/padding
                AsistenciaHt580Remote asistenciaSaved = asistenciaRemoteRepository
                        .findRegistroRecienInsertado(
                                asistenciaRemote.getCodOrigen(),
                                asistenciaRemote.getCodigo(), 
                                asistenciaRemote.getFlagInOut(),
                                asistenciaRemote.getFechaMovimiento(),
                                asistenciaRemote.getCodUsuario(),
                                asistenciaRemote.getDireccionIp(),
                                asistenciaRemote.getTurno(),
                                asistenciaRemote.getLecturaPda()
                        );
                
                String oracleReckey = "";
                if (asistenciaSaved != null) {
                    oracleReckey = asistenciaSaved.getReckey();
                    log.info("🔍 CONSULTA Oracle exitosa - ID real: {} (vs save: {})", oracleReckey, asistenciaSaved.getReckey());
                    
                    // ✅ LOGGING JSON - Objeto real de Oracle
                    try {
                        log.info("🔄 Asistencia Oracle REAL (consultada): {}", objectMapper.writeValueAsString(asistenciaSaved));
                    } catch (Exception e) {
                        log.info("🔄 Asistencia Oracle REAL (consultada): {}", asistenciaSaved.toString());
                    }

                    // ✅ ACTUALIZAR registro con external_id de Oracle (NO eliminar)
                    asistenciaLocal.setExternalId(oracleReckey); // ✅ ID de Oracle en external_id
                    
                
                } else {
                    // Fallback al save response
                    //oracleReckey = asistenciaSaved.getReckey();
                    //log.warn("⚠️ No se encontró registro en Oracle por consulta, usando save response: {}", oracleReckey);
                }
                
                asistenciaLocal.setEstadoSync("S");
                asistenciaLocal.setFechaSync(LocalDateTime.now());
                asistenciaLocalRepository.save(asistenciaLocal);
                
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
     * Convertir entidad local a remota
     */
    private AsistenciaHt580Remote convertirLocalToRemote(AsistenciaHt580Local local) {
        return AsistenciaHt580Remote.builder()
                .reckey(local.getReckey())
                .codOrigen(local.getCodOrigen())
                .codigo(local.getCodigo())
                .flagInOut(local.getFlagInOut())
                .fechaRegistro(local.getFechaRegistro())
                .fechaMovimiento(local.getFechaMovimiento())
                .codUsuario(local.getCodUsuario())
                .direccionIp(local.getDireccionIp())
                .flagVerifyType(local.getFlagVerifyType())
                .turno(local.getTurno())
                .lecturaPda(local.getLecturaPda())
                .build();
    }
    
    /**
     * FASE 2: Sincronizar cambios de registros ya sincronizados
     * PostgreSQL (con external_id) → Comparar Oracle → Actualizar si diferente
     */
    private void sincronizarCambiosRegistrosSincronizados() {
        log.info("🔄 FASE 2: Sincronizando cambios de registros ya sincronizados");
        
        try {
            // ✅ Usar codOrigen de configuración
            String codOrigen = codOrigenConfiguracion;
            
            // Buscar registros PostgreSQL ya sincronizados (con external_id)
            List<AsistenciaHt580Local> registrosSincronizados = asistenciaLocalRepository
                    .findByEstadoSyncAndExternalIdIsNotNullAndCodOrigen("S", codOrigen);
            
            log.info("📊 FASE 2: Encontrados {} registros sincronizados para verificar", registrosSincronizados.size());
            
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
            
            log.info("✅ FASE 2 completada - Actualizados: {}", registrosActualizados);
            
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
            
            // Obtener TODOS los registros de Oracle para este origen (sin filtro de fecha)
            List<AsistenciaHt580Remote> registrosOracle = asistenciaRemoteRepository
                    .findByCodOrigenOrderByFechaRegistroDesc(codOrigen);
            
            log.info("📊 FASE 3: Verificando {} registros Oracle para origen {}", registrosOracle.size(), codOrigen);
            
            for (AsistenciaHt580Remote oracleRecord : registrosOracle) {
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
            
            log.info("✅ FASE 3 completada - Eliminados: {}", registrosEliminados);
            
        } catch (Exception e) {
            log.error("❌ Error en FASE 3: {}", e.getMessage(), e);
            erroresSincronizacion.add("Error en FASE 3: " + e.getMessage());
        }
    }
    
    /**
     * Comparar si dos registros tienen datos diferentes
     */
    private boolean sonDiferentes(AsistenciaHt580Local local, AsistenciaHt580Remote oracle) {
        return !local.getCodigo().equals(oracle.getCodigo()) ||
               !local.getFlagInOut().equals(oracle.getFlagInOut()) ||
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
        oracle.setFechaMovimiento(local.getFechaMovimiento());
        oracle.setCodUsuario(local.getCodUsuario());
        oracle.setDireccionIp(local.getDireccionIp());
        oracle.setFlagVerifyType(local.getFlagVerifyType());
        oracle.setTurno(local.getTurno());
        oracle.setLecturaPda(local.getLecturaPda());
        
        asistenciaRemoteRepository.save(oracle);
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
