package com.sigre.sync.service;

import com.sigre.sync.entity.local.*;
import com.sigre.sync.entity.remote.*;
import com.sigre.sync.repository.local.*;
import com.sigre.sync.repository.remote.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RemoteToLocalSyncService {
    
    private final MaestroRemoteRepository maestroRemoteRepository;
    private final MaestroLocalRepository maestroLocalRepository;
    private final CentrosCostoRemoteRepository centrosCostoRemoteRepository;
    private final CentrosCostoLocalRepository centrosCostoLocalRepository;
    private final RrhhAsignaTrjtRelojRemoteRepository rrhhAsignaTrjtRelojRemoteRepository;
    private final RrhhAsignaTrjtRelojLocalRepository rrhhAsignaTrjtRelojLocalRepository;
    
    // Contadores para cada tabla
    private final Map<String, Integer> insertados = new HashMap<>();
    private final Map<String, Integer> actualizados = new HashMap<>();
    private final Map<String, Integer> eliminados = new HashMap<>();
    private final Map<String, Integer> errores = new HashMap<>();
    private final List<String> erroresSincronizacion = new ArrayList<>();
    
    /**
     * Sincronizar tabla maestro de Oracle → PostgreSQL
     */
    @Transactional("localTransactionManager")
    public boolean sincronizarMaestro() {
        log.info("🔥 Iniciando sincronización de tabla MAESTRO (Remote → Local)");
        String tabla = "maestro";
        resetearContadores(tabla);
        
        try {
            // Obtener todos los trabajadores de Oracle
            List<MaestroRemote> trabajadoresRemote = maestroRemoteRepository.findAll();
            Set<String> codigosRemote = trabajadoresRemote.stream()
                    .map(MaestroRemote::getCodTrabajador)
                    .collect(Collectors.toSet());
            log.info("📊 Encontrados {} trabajadores en bd_remota", trabajadoresRemote.size());
            
            // Obtener todos los trabajadores locales
            List<MaestroLocal> trabajadoresLocal = maestroLocalRepository.findAll();
            log.info("📊 Encontrados {} trabajadores en bd_local", trabajadoresLocal.size());
            
            // PASO 1: Eliminar registros que no existen en remoto
            for (MaestroLocal trabajadorLocal : trabajadoresLocal) {
                if (!codigosRemote.contains(trabajadorLocal.getCodTrabajador())) {
                    maestroLocalRepository.delete(trabajadorLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminado trabajador local que no existe en remoto: {}", 
                            trabajadorLocal.getCodTrabajador());
                }
            }
            
            // PASO 2: Insertar o actualizar registros desde remoto
            for (MaestroRemote trabajadorRemote : trabajadoresRemote) {
                try {
                    procesarTrabajador(trabajadorRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en trabajador %s: %s", 
                            trabajadorRemote.getCodTrabajador(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }
            
            // Verificar que las cantidades sean iguales
            long totalRemoto = maestroRemoteRepository.count();
            long totalLocal = maestroLocalRepository.count();
            
            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }
            
            log.info("✅ Sincronización MAESTRO completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}", 
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));
            
            return errores.get(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de MAESTRO", e);
            erroresSincronizacion.add("Error crítico en tabla maestro: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Sincronizar centros de costo
     */
    @Transactional("localTransactionManager")
    public boolean sincronizarCentrosCosto() {
        log.info("🔥 Iniciando sincronización de tabla CENTROS_COSTO (Remote → Local)");
        String tabla = "centros_costo";
        resetearContadores(tabla);
        
        try {
            // Obtener todos los centros de costo de Oracle
            List<CentrosCostoRemote> centrosRemote = centrosCostoRemoteRepository.findAll();
            Set<String> cencosRemote = centrosRemote.stream()
                    .map(CentrosCostoRemote::getCencos)
                    .collect(Collectors.toSet());
            log.info("📊 Encontrados {} centros de costo en bd_remota", centrosRemote.size());
            
            // Obtener todos los centros locales
            List<CentrosCostoLocal> centrosLocal = centrosCostoLocalRepository.findAll();
            log.info("📊 Encontrados {} centros de costo en bd_local", centrosLocal.size());
            
            // PASO 1: Eliminar registros que no existen en remoto
            for (CentrosCostoLocal centroLocal : centrosLocal) {
                if (!cencosRemote.contains(centroLocal.getCencos())) {
                    centrosCostoLocalRepository.delete(centroLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminado centro de costo local que no existe en remoto: {}", 
                            centroLocal.getCencos());
                }
            }
            
            // PASO 2: Insertar o actualizar registros desde remoto
            for (CentrosCostoRemote centroRemote : centrosRemote) {
                try {
                    procesarCentroCosto(centroRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en centro de costo %s: %s", 
                            centroRemote.getCencos(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }
            
            // Verificar cantidades
            long totalRemoto = centrosCostoRemoteRepository.count();
            long totalLocal = centrosCostoLocalRepository.count();
            
            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }
            
            log.info("✅ Sincronización CENTROS_COSTO completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}", 
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));
            
            return errores.get(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de CENTROS_COSTO", e);
            erroresSincronizacion.add("Error crítico en tabla centros_costo: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Sincronizar tarjetas de reloj
     */
    @Transactional("localTransactionManager")
    public boolean sincronizarTarjetasReloj() {
        log.info("🔥 Iniciando sincronización de tabla RRHH_ASIGNA_TRJT_RELOJ (Remote → Local)");
        String tabla = "rrhh_asigna_trjt_reloj";
        resetearContadores(tabla);
        
        try {
            // Obtener todas las asignaciones de Oracle
            List<RrhhAsignaTrjtRelojRemote> asignacionesRemote = rrhhAsignaTrjtRelojRemoteRepository.findAll();
            Set<String> keysRemote = asignacionesRemote.stream()
                    .map(a -> a.getCodTrabajador() + "-" + a.getCodTarjeta())
                    .collect(Collectors.toSet());
            log.info("📊 Encontradas {} asignaciones de tarjeta en bd_remota", asignacionesRemote.size());
            
            // Obtener todas las asignaciones locales
            List<RrhhAsignaTrjtRelojLocal> asignacionesLocal = rrhhAsignaTrjtRelojLocalRepository.findAll();
            log.info("📊 Encontradas {} asignaciones de tarjeta en bd_local", asignacionesLocal.size());
            
            // PASO 1: Eliminar registros que no existen en remoto
            for (RrhhAsignaTrjtRelojLocal asignacionLocal : asignacionesLocal) {
                String key = asignacionLocal.getCodTrabajador() + "-" + asignacionLocal.getCodTarjeta();
                if (!keysRemote.contains(key)) {
                    rrhhAsignaTrjtRelojLocalRepository.delete(asignacionLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminada asignación local que no existe en remoto: {}", key);
                }
            }
            
            // PASO 2: Insertar o actualizar registros desde remoto
            for (RrhhAsignaTrjtRelojRemote asignacionRemote : asignacionesRemote) {
                try {
                    procesarAsignacionTarjeta(asignacionRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en asignación %s-%s: %s", 
                            asignacionRemote.getCodTrabajador(), asignacionRemote.getCodTarjeta(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }
            
            // Verificar cantidades
            long totalRemoto = rrhhAsignaTrjtRelojRemoteRepository.count();
            long totalLocal = rrhhAsignaTrjtRelojLocalRepository.count();
            
            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }
            
            log.info("✅ Sincronización RRHH_ASIGNA_TRJT_RELOJ completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}", 
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));
            
            return errores.get(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de RRHH_ASIGNA_TRJT_RELOJ", e);
            erroresSincronizacion.add("Error crítico en tabla rrhh_asigna_trjt_reloj: " + e.getMessage());
            return false;
        }
    }
    
    // Métodos privados de procesamiento
    private void procesarTrabajador(MaestroRemote trabajadorRemote, String tabla) {
        String codTrabajador = trabajadorRemote.getCodTrabajador();
        
        Optional<MaestroLocal> trabajadorLocalOpt = maestroLocalRepository.findById(codTrabajador);
        
        if (trabajadorLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            MaestroLocal nuevoTrabajador = convertirRemoteToLocal(trabajadorRemote);
            maestroLocalRepository.save(nuevoTrabajador);
            insertados.merge(tabla, 1, Integer::sum);
            log.debug("➕ Insertado trabajador: {}", codTrabajador);
            
        } else {
            // ACTUALIZAR si hay cambios reales
            MaestroLocal trabajadorLocal = trabajadorLocalOpt.get();
            
            if (hayDiferencias(trabajadorRemote, trabajadorLocal)) {
                actualizarTrabajadorLocal(trabajadorLocal, trabajadorRemote);
                maestroLocalRepository.save(trabajadorLocal);
                actualizados.merge(tabla, 1, Integer::sum);
                log.debug("🔄 Actualizado trabajador: {}", codTrabajador);
            }
        }
    }
    
    private void procesarCentroCosto(CentrosCostoRemote centroRemote, String tabla) {
        String cencos = centroRemote.getCencos();
        
        Optional<CentrosCostoLocal> centroLocalOpt = centrosCostoLocalRepository.findById(cencos);
        
        if (centroLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            CentrosCostoLocal nuevoCentro = convertirCentroRemoteToLocal(centroRemote);
            centrosCostoLocalRepository.save(nuevoCentro);
            insertados.merge(tabla, 1, Integer::sum);
            log.debug("➕ Insertado centro de costo: {}", cencos);
            
        } else {
            // ACTUALIZAR si hay cambios reales
            CentrosCostoLocal centroLocal = centroLocalOpt.get();
            
            if (hayDiferenciasCentro(centroRemote, centroLocal)) {
                actualizarCentroLocal(centroLocal, centroRemote);
                centrosCostoLocalRepository.save(centroLocal);
                actualizados.merge(tabla, 1, Integer::sum);
                log.debug("🔄 Actualizado centro de costo: {}", cencos);
            }
        }
    }
    
    private void procesarAsignacionTarjeta(RrhhAsignaTrjtRelojRemote asignacionRemote, String tabla) {
        RrhhAsignaTrjtRelojLocalId id = new RrhhAsignaTrjtRelojLocalId(
            asignacionRemote.getCodTrabajador(), 
            asignacionRemote.getCodTarjeta()
        );
        
        Optional<RrhhAsignaTrjtRelojLocal> asignacionLocalOpt = rrhhAsignaTrjtRelojLocalRepository.findById(id);
        
        if (asignacionLocalOpt.isEmpty()) {
            // INSERTAR nueva asignación
            RrhhAsignaTrjtRelojLocal nuevaAsignacion = convertirAsignacionRemoteToLocal(asignacionRemote);
            rrhhAsignaTrjtRelojLocalRepository.save(nuevaAsignacion);
            insertados.merge(tabla, 1, Integer::sum);
            log.debug("➕ Insertada asignación: {}-{}", 
                asignacionRemote.getCodTrabajador(), asignacionRemote.getCodTarjeta());
            
        } else {
            // ACTUALIZAR si hay cambios reales
            RrhhAsignaTrjtRelojLocal asignacionLocal = asignacionLocalOpt.get();
            
            if (hayDiferenciasAsignacion(asignacionRemote, asignacionLocal)) {
                actualizarAsignacionLocal(asignacionLocal, asignacionRemote);
                rrhhAsignaTrjtRelojLocalRepository.save(asignacionLocal);
                actualizados.merge(tabla, 1, Integer::sum);
                log.debug("🔄 Actualizada asignación: {}-{}", 
                    asignacionRemote.getCodTrabajador(), asignacionRemote.getCodTarjeta());
            }
        }
    }
    
    // Métodos de conversión
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
    
    private CentrosCostoLocal convertirCentroRemoteToLocal(CentrosCostoRemote remote) {
        return CentrosCostoLocal.builder()
                .cencos(remote.getCencos())
                .codN1(remote.getCodN1())
                .codN2(remote.getCodN2())
                .codN3(remote.getCodN3())
                .origen(remote.getOrigen())
                .descripcionCencos(remote.getDescripcionCencos())
                .email(remote.getEmail())
                .flagEstado(remote.getFlagEstado())
                .flagTipo(remote.getFlagTipo())
                .flagModPres(remote.getFlagModPres())
                .flagCtaPresup(remote.getFlagCtaPresup())
                .grupoCntbl(remote.getGrupoCntbl())
                .flagReplicacion(remote.getFlagReplicacion())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }
    
    private RrhhAsignaTrjtRelojLocal convertirAsignacionRemoteToLocal(RrhhAsignaTrjtRelojRemote remote) {
        return RrhhAsignaTrjtRelojLocal.builder()
                .codTrabajador(remote.getCodTrabajador())
                .codTarjeta(remote.getCodTarjeta())
                .fechaInicio(remote.getFechaInicio())
                .fechaFin(remote.getFechaFin())
                .flagEstado(remote.getFlagEstado())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }
    
    // Métodos de comparación para detectar cambios reales
    private boolean hayDiferencias(MaestroRemote remote, MaestroLocal local) {
        return !equals(remote.getApellidoPaterno(), local.getApellidoPaterno()) ||
               !equals(remote.getApellidoMaterno(), local.getApellidoMaterno()) ||
               !equals(remote.getNombre1(), local.getNombre1()) ||
               !equals(remote.getNombre2(), local.getNombre2()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado()) ||
               !equals(remote.getDireccion(), local.getDireccion()) ||
               !equals(remote.getTelefono1(), local.getTelefono1()) ||
               !equals(remote.getEmail(), local.getEmail()) ||
               !equals(remote.getCodEmpresa(), local.getCodEmpresa()) ||
               !equals(remote.getCentroCosto(), local.getCentroCosto()) ||
               !equals(remote.getFlagMarcaReloj(), local.getFlagMarcaReloj()) ||
               !equals(remote.getDni(), local.getDni()) ||
               !equals(remote.getFechaIngreso(), local.getFechaIngreso()) ||
               !equals(remote.getFechaNacimiento(), local.getFechaNacimiento()) ||
               !equals(remote.getFechaCese(), local.getFechaCese());
    }
    
    private boolean hayDiferenciasCentro(CentrosCostoRemote remote, CentrosCostoLocal local) {
        return !equals(remote.getDescripcionCencos(), local.getDescripcionCencos()) ||
               !equals(remote.getEmail(), local.getEmail()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado()) ||
               !equals(remote.getCodN1(), local.getCodN1()) ||
               !equals(remote.getCodN2(), local.getCodN2()) ||
               !equals(remote.getCodN3(), local.getCodN3()) ||
               !equals(remote.getOrigen(), local.getOrigen()) ||
               !equals(remote.getFlagTipo(), local.getFlagTipo()) ||
               !equals(remote.getFlagModPres(), local.getFlagModPres()) ||
               !equals(remote.getFlagCtaPresup(), local.getFlagCtaPresup()) ||
               !equals(remote.getGrupoCntbl(), local.getGrupoCntbl()) ||
               !equals(remote.getFlagReplicacion(), local.getFlagReplicacion());
    }
    
    private boolean hayDiferenciasAsignacion(RrhhAsignaTrjtRelojRemote remote, RrhhAsignaTrjtRelojLocal local) {
        return !equals(remote.getFechaInicio(), local.getFechaInicio()) ||
               !equals(remote.getFechaFin(), local.getFechaFin()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado());
    }
    
    // Métodos de actualización
    private void actualizarTrabajadorLocal(MaestroLocal local, MaestroRemote remote) {
        local.setCodTrabAntiguo(remote.getCodTrabAntiguo());
        local.setFotoTrabaj(remote.getFotoTrabaj());
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
        local.setDni(remote.getDni());
        local.setEmail(remote.getEmail());
        local.setCodEmpresa(remote.getCodEmpresa());
        local.setCentroCosto(remote.getCentroCosto());
        local.setFlagMarcaReloj(remote.getFlagMarcaReloj());
        local.setFlagEstadoCivil(remote.getFlagEstadoCivil());
        local.setFlagSexo(remote.getFlagSexo());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
    }
    
    private void actualizarCentroLocal(CentrosCostoLocal local, CentrosCostoRemote remote) {
        local.setCodN1(remote.getCodN1());
        local.setCodN2(remote.getCodN2());
        local.setCodN3(remote.getCodN3());
        local.setOrigen(remote.getOrigen());
        local.setDescripcionCencos(remote.getDescripcionCencos());
        local.setEmail(remote.getEmail());
        local.setFlagEstado(remote.getFlagEstado());
        local.setFlagTipo(remote.getFlagTipo());
        local.setFlagModPres(remote.getFlagModPres());
        local.setFlagCtaPresup(remote.getFlagCtaPresup());
        local.setGrupoCntbl(remote.getGrupoCntbl());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
    }
    
    private void actualizarAsignacionLocal(RrhhAsignaTrjtRelojLocal local, RrhhAsignaTrjtRelojRemote remote) {
        local.setFechaInicio(remote.getFechaInicio());
        local.setFechaFin(remote.getFechaFin());
        local.setFlagEstado(remote.getFlagEstado());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
    }
    
    // Utilidades
    private boolean equals(Object obj1, Object obj2) {
        if (obj1 == null && obj2 == null) return true;
        if (obj1 == null || obj2 == null) return false;
        return obj1.equals(obj2);
    }
    
    private void resetearContadores(String tabla) {
        insertados.put(tabla, 0);
        actualizados.put(tabla, 0);
        eliminados.put(tabla, 0);
        errores.put(tabla, 0);
    }
    
    // Getters para estadísticas
    public int getInsertados(String tabla) {
        return insertados.getOrDefault(tabla, 0);
    }
    
    public int getActualizados(String tabla) {
        return actualizados.getOrDefault(tabla, 0);
    }
    
    public int getEliminados(String tabla) {
        return eliminados.getOrDefault(tabla, 0);
    }
    
    public int getErrores(String tabla) {
        return errores.getOrDefault(tabla, 0);
    }
    
    public List<String> getErroresSincronizacion() {
        return new ArrayList<>(erroresSincronizacion);
    }
}