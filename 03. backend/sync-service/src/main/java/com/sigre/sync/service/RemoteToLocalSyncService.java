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
import java.time.LocalDateTime;
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
    private final TurnoRemoteRepository turnoRemoteRepository;
    private final TurnoLocalRepository turnoLocalRepository;
    
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
    /**
     * Sincronizar tabla turno de Oracle → PostgreSQL
     */
    @Transactional("localTransactionManager")
    public boolean sincronizarTurno() {
        log.info("🔥 Iniciando sincronización de tabla TURNO (Remote → Local)");
        String tabla = "turno";
        resetearContadores(tabla);
        
        try {
            // PASO 0: DIAGNÓSTICO COMPLETO - Verificar TODOS los turnos en Oracle
            log.info("🔍 DIAGNÓSTICO: Consultando TODOS los turnos en bd_remota...");
            List<Object[]> todosTurnos = turnoRemoteRepository.findAllTurnosParaDiagnostico();
            log.info("📊 DIAGNÓSTICO - Encontrados {} turnos TOTALES en Oracle:", todosTurnos.size());
            
            for (Object[] row : todosTurnos) {
                log.info("   🔍 Turno: {} | {} | Estado: {} | Horario: {} - {}", 
                        row[0], row[1], row[2], row[3], row[4]);
            }
            
            // Verificar solo turnos activos con detalle completo
            log.info("🔍 Verificando turnos ACTIVOS en bd_remota...");
            List<Object[]> verificacionTurnos = turnoRemoteRepository.findTurnosConHorarios();
            log.info("📊 Verificación de turnos activos - Encontrados {} registros:", verificacionTurnos.size());
            
            for (Object[] row : verificacionTurnos) {
                log.info("═══ TURNO ORACLE RAW: {} ═══", row[0]);
                log.info("   📅 NORMAL    - Inicio: {} | Final: {}", row[1], row[2]);
                log.info("   📅 REFRIGERIO - Inicio: {} | Final: {}", row[3], row[4]);
                log.info("   📅 SÁBADO    - Inicio: {} | Final: {}", row[5], row[6]);
                log.info("   📅 REFRIG SAB - Inicio: {} | Final: {}", row[7], row[8]);
                log.info("   📅 DOMINGO   - Inicio: {} | Final: {}", row[9], row[10]);
                log.info("   📅 COMPENS   - Norm: {} - {} | Sab: {} - {} | Dom: {} - {}", 
                        row[11], row[12], row[13], row[14], row[15], row[16]);
                log.info("   📋 MARCACIONES - Normal: {} | Sáb: {} | Dom: {}", row[17], row[18], row[19]);
                log.info("   📋 CONTROL - Tolerancia: {} | Tipo: {} | Estado: {} | Usuario: {}", 
                        row[20], row[21], row[22], row[24]);
                log.info("   📋 Descripción: {} | Replicación: {}", row[23], row[25]);
                log.info("═══════════════════════════════════════");
            }
            
            // USAR CONSULTA SQL NATIVA DIRECTAMENTE para sincronización
            log.info("🔄 Usando consulta SQL nativa para sincronización completa");
            List<Object[]> turnosRaw = turnoRemoteRepository.findTurnosConHorarios();
            log.info("📊 Encontrados {} turnos RAW para sincronización", turnosRaw.size());
            
            // Obtener turnos locales existentes
            List<TurnoLocal> turnosLocales = turnoLocalRepository.findByFlagEstadoOrderByTurno("1");
            Map<String, TurnoLocal> turnosLocalesMap = turnosLocales.stream()
                    .collect(Collectors.toMap(TurnoLocal::getTurno, t -> t));
            log.info("📊 Encontrados {} turnos en bd_local", turnosLocales.size());
            
            // Procesar cada turno de Oracle: INSERTAR o ACTUALIZAR
            for (Object[] row : turnosRaw) {
                try {
                    String codigoTurno = (String) row[0];
                    log.info("🔄 Procesando turno RAW: {} - {}", codigoTurno, row[23]); // descripcion en posición 23
                    
                    // Mapear TODOS los campos manualmente desde Object[]
                    TurnoLocal turnoLocal = mapearTurnoDesdeRaw(row);
                    
                    // Verificar si existe en BD local
                    TurnoLocal turnoExistente = turnosLocalesMap.get(codigoTurno);
                    
                    if (turnoExistente == null) {
                        // INSERTAR nuevo turno
                        turnoLocalRepository.save(turnoLocal);
                        insertados.merge(tabla, 1, Integer::sum);
                        log.info("➕ INSERTADO turno: {} - {} completamente", codigoTurno, turnoLocal.getDescripcion());
                    } else {
                        // ACTUALIZAR turno existente
                        actualizarTurnoLocal(turnoExistente, turnoLocal);
                        turnoLocalRepository.save(turnoExistente);
                        actualizados.merge(tabla, 1, Integer::sum);
                        log.info("🔄 ACTUALIZADO turno: {} - {} completamente", codigoTurno, turnoLocal.getDescripcion());
                    }
                    
                } catch (Exception e) {
                    String codigoTurno = row.length > 0 ? (String) row[0] : "UNKNOWN";
                    errores.merge(tabla, 1, Integer::sum);
                    erroresSincronizacion.add("Error procesando turno " + codigoTurno + ": " + e.getMessage());
                    log.error("❌ Error procesando turno: {} | Error: {}", codigoTurno, e.getMessage(), e);
                }
            }
            
            // PASO FINAL: Verificar datos en BD local después de sincronización
            List<TurnoLocal> turnosLocal = turnoLocalRepository.findByFlagEstadoOrderByTurno("1");
            log.info("📊 Verificación BD local - {} turnos sincronizados:", turnosLocal.size());
            
            for (TurnoLocal turno : turnosLocal) {
                log.info("   ✅ Turno local: {} | {} | Inicio: {} | Final: {}", 
                        turno.getTurno(), turno.getDescripcion(), 
                        turno.getHoraInicioNorm(), turno.getHoraFinalNorm());
            }
            
            log.info("✅ Sincronización de TURNO completada: {} insertados, {} errores", 
                    getInsertados(tabla), getErrores(tabla));
            
            return getErrores(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de TURNO", e);
            erroresSincronizacion.add("Error crítico en sincronización de TURNO: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Mapear turno desde Object[] (consulta SQL nativa) a TurnoLocal
     * TODOS los 26 campos mapeados exactamente como vienen de Oracle
     */
    private TurnoLocal mapearTurnoDesdeRaw(Object[] row) {
        // Helper para convertir Oracle DATE a LocalDateTime
        java.util.function.Function<Object, LocalDateTime> convertirFecha = (obj) -> {
            if (obj == null) return null;
            if (obj instanceof java.sql.Timestamp) {
                return ((java.sql.Timestamp) obj).toLocalDateTime();
            }
            if (obj instanceof java.util.Date) {
                return new java.sql.Timestamp(((java.util.Date) obj).getTime()).toLocalDateTime();
            }
            return null;
        };
        
        // Helper para convertir NUMBER a Integer
        java.util.function.Function<Object, Integer> convertirEntero = (obj) -> {
            if (obj == null) return null;
            if (obj instanceof Number) {
                return ((Number) obj).intValue();
            }
            return null;
        };
        
        // Helper para convertir CHAR a String (Oracle CHAR puede venir como Character)
        java.util.function.Function<Object, String> convertirTexto = (obj) -> {
            if (obj == null) return null;
            if (obj instanceof String) return (String) obj;
            if (obj instanceof Character) return obj.toString();
            return obj.toString();
        };
        
        return TurnoLocal.builder()
                .turno(convertirTexto.apply(row[0]))                       // TURNO
                .horaInicioNorm(convertirFecha.apply(row[1]))              // HORA_INICIO_NORM
                .horaFinalNorm(convertirFecha.apply(row[2]))               // HORA_FINAL_NORM
                .refrigInicioNorm(convertirFecha.apply(row[3]))            // REFRIG_INICIO_NORM
                .refrigFinalNorm(convertirFecha.apply(row[4]))             // REFRIG_FINAL_NORM
                .horaInicioSab(convertirFecha.apply(row[5]))               // HORA_INICIO_SAB
                .horaFinalSab(convertirFecha.apply(row[6]))                // HORA_FINAL_SAB
                .refrigInicioSab(convertirFecha.apply(row[7]))             // REFRIG_INICIO_SAB
                .refrigFinalSab(convertirFecha.apply(row[8]))              // REFRIG_FINAL_SAB
                .horaInicioDom(convertirFecha.apply(row[9]))               // HORA_INICIO_DOM
                .horaFinalDom(convertirFecha.apply(row[10]))               // HORA_FINAL_DOM
                .horaIniCmpsNorm(convertirFecha.apply(row[11]))            // HORA_INI_CMPS_NORM
                .horaFinCmpsNorm(convertirFecha.apply(row[12]))            // HORA_FIN_CMPS_NORM
                .horaIniCmpsSab(convertirFecha.apply(row[13]))             // HORA_INI_CMPS_SAB
                .horaFinCmpsSab(convertirFecha.apply(row[14]))             // HORA_FIN_CMPS_SAB
                .horaIniCmpsDom(convertirFecha.apply(row[15]))             // HORA_INI_CMPS_DOM
                .horaFinCmpsDom(convertirFecha.apply(row[16]))             // HORA_FIN_CMPS_DOM
                .marcDiariaNorm(convertirEntero.apply(row[17]))            // MARC_DIARIA_NORM
                .marcDiariaSab(convertirEntero.apply(row[18]))             // MARC_DIARIA_SAB
                .marcDiariaDom(convertirEntero.apply(row[19]))             // MARC_DIARIA_DOM
                .tolerancia(convertirEntero.apply(row[20]))                // TOLERANCIA
                .tipoTurno(convertirTexto.apply(row[21]))                  // TIPO_TURNO
                .flagEstado(convertirTexto.apply(row[22]))                 // FLAG_ESTADO
                .descripcion(convertirTexto.apply(row[23]))                // DESCRIPCION
                .codUsuario(convertirTexto.apply(row[24]))                 // COD_USR
                .flagReplicacion(convertirTexto.apply(row[25]))            // FLAG_REPLICACION
                .fechaSync(LocalDateTime.now())                            // Control de sync
                .estadoSync("S")                                           // S = Sincronizado
                .intentosSync(0)                                           // Intentos
                .build();
    }
    
    /**
     * Obtener nombre del campo según índice del Object[] de consulta SQL
     */
    private String obtenerNombreCampo(int index) {
        String[] campos = {
            "turno", "hora_inicio_norm", "hora_final_norm", 
            "refrig_inicio_norm", "refrig_final_norm",
            "hora_inicio_sab", "hora_final_sab", 
            "refrig_inicio_sab", "refrig_final_sab",
            "hora_inicio_dom", "hora_final_dom",
            "hora_ini_cmps_norm", "hora_fin_cmps_norm",
            "hora_ini_cmps_sab", "hora_fin_cmps_sab",
            "hora_ini_cmps_dom", "hora_fin_cmps_dom",
            "marc_diaria_norm", "marc_diaria_sab", "marc_diaria_dom",
            "tolerancia", "tipo_turno", "flag_estado", 
            "descripcion", "cod_usr", "flag_replicacion"
        };
        return index < campos.length ? campos[index] : "campo_" + index;
    }
    
    /**
     * Actualizar TODOS los campos del turno local con datos del remoto
     */
    private void actualizarTurnoLocal(TurnoLocal existente, TurnoLocal nuevo) {
        existente.setHoraInicioNorm(nuevo.getHoraInicioNorm());
        existente.setHoraFinalNorm(nuevo.getHoraFinalNorm());
        existente.setRefrigInicioNorm(nuevo.getRefrigInicioNorm());
        existente.setRefrigFinalNorm(nuevo.getRefrigFinalNorm());
        existente.setHoraInicioSab(nuevo.getHoraInicioSab());
        existente.setHoraFinalSab(nuevo.getHoraFinalSab());
        existente.setRefrigInicioSab(nuevo.getRefrigInicioSab());
        existente.setRefrigFinalSab(nuevo.getRefrigFinalSab());
        existente.setHoraInicioDom(nuevo.getHoraInicioDom());
        existente.setHoraFinalDom(nuevo.getHoraFinalDom());
        existente.setHoraIniCmpsNorm(nuevo.getHoraIniCmpsNorm());
        existente.setHoraFinCmpsNorm(nuevo.getHoraFinCmpsNorm());
        existente.setHoraIniCmpsSab(nuevo.getHoraIniCmpsSab());
        existente.setHoraFinCmpsSab(nuevo.getHoraFinCmpsSab());
        existente.setHoraIniCmpsDom(nuevo.getHoraIniCmpsDom());
        existente.setHoraFinCmpsDom(nuevo.getHoraFinCmpsDom());
        existente.setMarcDiariaNorm(nuevo.getMarcDiariaNorm());
        existente.setMarcDiariaSab(nuevo.getMarcDiariaSab());
        existente.setMarcDiariaDom(nuevo.getMarcDiariaDom());
        existente.setTolerancia(nuevo.getTolerancia());
        existente.setTipoTurno(nuevo.getTipoTurno());
        existente.setFlagEstado(nuevo.getFlagEstado());
        existente.setDescripcion(nuevo.getDescripcion());
        existente.setCodUsuario(nuevo.getCodUsuario());
        existente.setFlagReplicacion(nuevo.getFlagReplicacion());
        // Actualizar control de sync
        existente.setFechaSync(LocalDateTime.now());
        existente.setEstadoSync("S");
        
        log.info("📋 Campos actualizados: TODOS los 26 campos copiados desde Oracle");
    }
    
    /**
     * Convertir TurnoRemote a TurnoLocal (método legacy - ya no se usa)
     */
    private TurnoLocal convertirTurnoRemoteToLocal(TurnoRemote remote) {
        return TurnoLocal.builder()
                .turno(remote.getTurno())
                .horaInicioNorm(remote.getHoraInicioNorm())
                .horaFinalNorm(remote.getHoraFinalNorm())
                .refrigInicioNorm(remote.getRefrigInicioNorm())
                .refrigFinalNorm(remote.getRefrigFinalNorm())
                .horaInicioSab(remote.getHoraInicioSab())
                .horaFinalSab(remote.getHoraFinalSab())
                .refrigInicioSab(remote.getRefrigInicioSab())
                .refrigFinalSab(remote.getRefrigFinalSab())
                .horaInicioDom(remote.getHoraInicioDom())
                .horaFinalDom(remote.getHoraFinalDom())
                .horaIniCmpsNorm(remote.getHoraIniCmpsNorm())
                .horaFinCmpsNorm(remote.getHoraFinCmpsNorm())
                .horaIniCmpsSab(remote.getHoraIniCmpsSab())
                .horaFinCmpsSab(remote.getHoraFinCmpsSab())
                .horaIniCmpsDom(remote.getHoraIniCmpsDom())
                .horaFinCmpsDom(remote.getHoraFinCmpsDom())
                .marcDiariaNorm(remote.getMarcDiariaNorm())
                .marcDiariaSab(remote.getMarcDiariaSab())
                .marcDiariaDom(remote.getMarcDiariaDom())
                .tolerancia(remote.getTolerancia())
                .tipoTurno(remote.getTipoTurno())
                .flagEstado(remote.getFlagEstado())
                .descripcion(remote.getDescripcion())
                .codUsuario(remote.getCodUsuario())
                .flagReplicacion(remote.getFlagReplicacion())
                .fechaSync(java.time.LocalDateTime.now())
                .estadoSync("S") // S = Sincronizado
                .intentosSync(0)
                .build();
    }
    
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