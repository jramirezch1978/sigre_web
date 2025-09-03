package com.sigre.sync.service;

import com.sigre.sync.entity.local.AsistenciaHt580Local;
import com.sigre.sync.entity.remote.AsistenciaHt580Remote;
import com.sigre.sync.repository.local.AsistenciaHt580LocalRepository;
import com.sigre.sync.repository.remote.AsistenciaHt580RemoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocalToRemoteSyncService {
    
    private final AsistenciaHt580LocalRepository asistenciaLocalRepository;
    private final AsistenciaHt580RemoteRepository asistenciaRemoteRepository;
    
    private final List<String> erroresSincronizacion = new ArrayList<>();
    private int registrosInsertados = 0;
    private int registrosActualizados = 0;
    private int registrosEliminados = 0;
    private int registrosErrores = 0;
    
    /**
     * Sincronizar tabla asistencia_ht580 de PostgreSQL → Oracle
     */
    @Transactional("remoteTransactionManager")
    public boolean sincronizarAsistencia() {
        log.info("📤 Iniciando sincronización de tabla ASISTENCIA_HT580 (Local → Remote)");
        
        try {
            // Resetear contadores
            resetearContadores();
            
            // Obtener registros pendientes de sincronización
            List<AsistenciaHt580Local> asistenciasPendientes = asistenciaLocalRepository.findByEstadoSyncOrEstadoSyncIsNull("P");
            log.info("📊 Encontrados {} registros de asistencia pendientes", asistenciasPendientes.size());
            
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
            
            log.info("✅ Sincronización ASISTENCIA_HT580 completada - Insertados: {} | Errores: {}", 
                    registrosInsertados, registrosErrores);
            
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
        String reckey = asistenciaLocal.getReckey();
        
        try {
            // Verificar si ya existe en Oracle
            boolean existeEnRemote = asistenciaRemoteRepository.existsById(reckey);
            
            if (!existeEnRemote) {
                // INSERTAR en Oracle
                AsistenciaHt580Remote asistenciaRemote = convertirLocalToRemote(asistenciaLocal);
                asistenciaRemoteRepository.save(asistenciaRemote);
                
                // Marcar como sincronizado en local
                asistenciaLocal.setEstadoSync("S");
                asistenciaLocal.setFechaSync(LocalDateTime.now());
                asistenciaLocalRepository.save(asistenciaLocal);
                
                registrosInsertados++;
                log.debug("➕ Insertada asistencia en Oracle: {}", reckey);
                
            } else {
                // Ya existe, marcar como sincronizado
                asistenciaLocal.setEstadoSync("S");
                asistenciaLocal.setFechaSync(LocalDateTime.now());
                asistenciaLocalRepository.save(asistenciaLocal);
                log.debug("⏭️ Asistencia ya existe en Oracle: {}", reckey);
            }
            
        } catch (Exception e) {
            // ✅ CAPTURAR ERROR ESPECÍFICO para notificación
            registrosErrores++;
            
            String errorDetallado = String.format(
                "Error sincronizando asistencia RECKEY=%s, COD_ORIGEN=%s, CODIGO=%s: %s", 
                reckey, asistenciaLocal.getCodOrigen(), asistenciaLocal.getCodigo(), e.getMessage()
            );
            
            erroresSincronizacion.add(errorDetallado);
            
            log.error("❌ Error procesando asistencia {} (COD_ORIGEN={}): {}", 
                     reckey, asistenciaLocal.getCodOrigen(), e.getMessage());
            
            // Marcar registro como error en local para reintento
            asistenciaLocal.setEstadoSync("E"); // E = Error
            asistenciaLocal.setIntentosSync(asistenciaLocal.getIntentosSync() + 1);
            asistenciaLocalRepository.save(asistenciaLocal);
            
            log.info("🔄 Registro marcado como ERROR para reintento | RECKEY: {} | Intento: {}", 
                    reckey, asistenciaLocal.getIntentosSync());
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
     * Resetear contadores para nueva sincronización
     */
    private void resetearContadores() {
        registrosInsertados = 0;
        registrosActualizados = 0;
        registrosEliminados = 0;
        registrosErrores = 0;
        erroresSincronizacion.clear();
    }
    
    // Getters para estadísticas
    public int getRegistrosInsertados() { return registrosInsertados; }
    public int getRegistrosActualizados() { return registrosActualizados; }
    public int getRegistrosEliminados() { return registrosEliminados; }
    public int getRegistrosErrores() { return registrosErrores; }
    public List<String> getErrores() { return new ArrayList<>(erroresSincronizacion); }
}
