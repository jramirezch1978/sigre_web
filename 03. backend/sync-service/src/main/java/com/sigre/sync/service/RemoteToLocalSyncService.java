package com.sigre.sync.service;

import com.sigre.sync.entity.local.MaestroLocal;
import com.sigre.sync.entity.remote.MaestroRemote;
import com.sigre.sync.repository.local.MaestroLocalRepository;
import com.sigre.sync.repository.remote.MaestroRemoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class RemoteToLocalSyncService {
    
    private final MaestroRemoteRepository maestroRemoteRepository;
    private final MaestroLocalRepository maestroLocalRepository;
    
    private final List<String> erroresSincronizacion = new ArrayList<>();
    private int registrosInsertados = 0;
    private int registrosActualizados = 0;
    private int registrosErrores = 0;
    
    /**
     * Sincronizar tabla maestro de Oracle → PostgreSQL
     */
    @Transactional("localTransactionManager")
    public boolean sincronizarMaestro() {
        log.info("📥 Iniciando sincronización de tabla MAESTRO (Remote → Local)");
        
        try {
            // Resetear contadores
            resetearContadores();
            
            // Obtener todos los trabajadores de Oracle
            List<MaestroRemote> trabajadoresRemote = maestroRemoteRepository.findAllByOrderByCodTrabajador();
            log.info("📊 Encontrados {} trabajadores en bd_remota", trabajadoresRemote.size());
            
            // Procesar cada trabajador
            for (MaestroRemote trabajadorRemote : trabajadoresRemote) {
                try {
                    procesarTrabajador(trabajadorRemote);
                } catch (Exception e) {
                    registrosErrores++;
                    String error = String.format("Error en trabajador %s: %s", 
                            trabajadorRemote.getCodTrabajador(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }
            
            log.info("✅ Sincronización MAESTRO completada - Insertados: {} | Actualizados: {} | Errores: {}", 
                    registrosInsertados, registrosActualizados, registrosErrores);
            
            return registrosErrores == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de MAESTRO", e);
            erroresSincronizacion.add("Error crítico en tabla maestro: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Procesar un trabajador individual
     */
    private void procesarTrabajador(MaestroRemote trabajadorRemote) {
        String codTrabajador = trabajadorRemote.getCodTrabajador();
        
        // Verificar si existe en local
        Optional<MaestroLocal> trabajadorLocalOpt = maestroLocalRepository.findById(codTrabajador);
        
        if (trabajadorLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            MaestroLocal nuevoTrabajador = convertirRemoteToLocal(trabajadorRemote);
            maestroLocalRepository.save(nuevoTrabajador);
            registrosInsertados++;
            log.debug("➕ Insertado trabajador: {}", codTrabajador);
            
        } else {
            // ACTUALIZAR si hay cambios
            MaestroLocal trabajadorLocal = trabajadorLocalOpt.get();
            
            if (hayDiferencias(trabajadorRemote, trabajadorLocal)) {
                actualizarTrabajadorLocal(trabajadorLocal, trabajadorRemote);
                maestroLocalRepository.save(trabajadorLocal);
                registrosActualizados++;
                log.debug("🔄 Actualizado trabajador: {}", codTrabajador);
            } else {
                log.debug("⏭️ Sin cambios trabajador: {}", codTrabajador);
            }
        }
    }
    
    /**
     * Convertir entidad remota a local
     */
    private MaestroLocal convertirRemoteToLocal(MaestroRemote remote) {
        return MaestroLocal.builder()
                .codTrabajador(remote.getCodTrabajador())
                .codTrabAntiguo(remote.getCodTrabAntiguo())
                .fotoTrabaj(remote.getFotoTrabaj())
                .apellidoPaterno(remote.getApellidoPaterno())
                .apellidoMaterno(remote.getApellidoMaterno())
                .nombre1(remote.getNombre1())
                .nombre2(remote.getNombre2())
                .flagEstado(remote.getFlagEstado())
                .fechaIngreso(remote.getFechaIngreso())
                .fechaNacimiento(remote.getFechaNacimiento())
                .fechaCese(remote.getFechaCese())
                .direccion(remote.getDireccion())
                .telefono1(remote.getTelefono1())
                .dni(remote.getDni())
                .email(remote.getEmail())
                .codEmpresa(remote.getCodEmpresa())
                .centroCosto(remote.getCentroCosto())
                .flagMarcaReloj(remote.getFlagMarcaReloj())
                .flagEstadoCivil(remote.getFlagEstadoCivil())
                .flagSexo(remote.getFlagSexo())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }
    
    /**
     * Verificar si hay diferencias entre registros remote y local
     */
    private boolean hayDiferencias(MaestroRemote remote, MaestroLocal local) {
        return !equals(remote.getApellidoPaterno(), local.getApellidoPaterno()) ||
               !equals(remote.getApellidoMaterno(), local.getApellidoMaterno()) ||
               !equals(remote.getNombre1(), local.getNombre1()) ||
               !equals(remote.getNombre2(), local.getNombre2()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado()) ||
               !equals(remote.getDireccion(), local.getDireccion()) ||
               !equals(remote.getTelefono1(), local.getTelefono1()) ||
               !equals(remote.getEmail(), local.getEmail()) ||
               !equals(remote.getFlagMarcaReloj(), local.getFlagMarcaReloj());
    }
    
    /**
     * Actualizar trabajador local con datos remotos
     */
    private void actualizarTrabajadorLocal(MaestroLocal local, MaestroRemote remote) {
        local.setApellidoPaterno(remote.getApellidoPaterno());
        local.setApellidoMaterno(remote.getApellidoMaterno());
        local.setNombre1(remote.getNombre1());
        local.setNombre2(remote.getNombre2());
        local.setFlagEstado(remote.getFlagEstado());
        local.setFechaIngreso(remote.getFechaIngreso());
        local.setFechaNacimiento(remote.getFechaNacimiento());
        local.setFechaCese(remote.getFechaCese());
        local.setDireccion(remote.getDireccion());
        local.setTelefono1(remote.getTelefono1());
        local.setEmail(remote.getEmail());
        local.setFlagMarcaReloj(remote.getFlagMarcaReloj());
        local.setFlagEstadoCivil(remote.getFlagEstadoCivil());
        local.setFlagSexo(remote.getFlagSexo());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
    }
    
    /**
     * Comparar strings manejando nulls
     */
    private boolean equals(String str1, String str2) {
        if (str1 == null && str2 == null) return true;
        if (str1 == null || str2 == null) return false;
        return str1.equals(str2);
    }
    
    /**
     * Resetear contadores para nueva sincronización
     */
    private void resetearContadores() {
        registrosInsertados = 0;
        registrosActualizados = 0;
        registrosErrores = 0;
        erroresSincronizacion.clear();
    }
    
    /**
     * Sincronizar centros de costo (stub)
     */
    public boolean sincronizarCentrosCosto() {
        log.info("📥 Sincronizando CENTROS_COSTO (Remote → Local)");
        // TODO: Implementar sincronización de centros de costo
        return true;
    }
    
    /**
     * Sincronizar tarjetas de reloj (stub)
     */
    public boolean sincronizarTarjetasReloj() {
        log.info("📥 Sincronizando RRHH_ASIGNA_TRJT_RELOJ (Remote → Local)");
        // TODO: Implementar sincronización de tarjetas
        return true;
    }
    
    // Getters para estadísticas
    public int getRegistrosInsertados() { return registrosInsertados; }
    public int getRegistrosActualizados() { return registrosActualizados; }
    public int getRegistrosErrores() { return registrosErrores; }
    public List<String> getErrores() { return new ArrayList<>(erroresSincronizacion); }
}
