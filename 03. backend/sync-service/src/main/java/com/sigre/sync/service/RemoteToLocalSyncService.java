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
    private final TipoTrabajadorRemoteRepository tipoTrabajadorRemoteRepository;
    private final TipoTrabajadorLocalRepository tipoTrabajadorLocalRepository;
    private final AreaRemoteRepository areaRemoteRepository;
    private final AreaLocalRepository areaLocalRepository;
    private final SeccionRemoteRepository seccionRemoteRepository;
    private final SeccionLocalRepository seccionLocalRepository;
    private final RrhhAsignaTrjtRelojRemoteRepository rrhhAsignaTrjtRelojRemoteRepository;
    private final RrhhAsignaTrjtRelojLocalRepository rrhhAsignaTrjtRelojLocalRepository;
    private final TurnoRemoteRepository turnoRemoteRepository;
    private final TurnoLocalRepository turnoLocalRepository;
    private final OrigenRemoteRepository origenRemoteRepository;
    private final OrigenLocalRepository origenLocalRepository;
    private final CargoRemoteRepository cargoRemoteRepository;
    private final CargoLocalRepository cargoLocalRepository;
    
    // Contadores para cada tabla
    private final Map<String, Integer> insertados = new HashMap<>();
    private final Map<String, Integer> actualizados = new HashMap<>();
    private final Map<String, Integer> eliminados = new HashMap<>();
    private final Map<String, Integer> errores = new HashMap<>();
    private final List<String> erroresSincronizacion = new ArrayList<>();
    
    /**
     * Sincronizar tabla maestro de Oracle → PostgreSQL
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
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
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
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
     * Sincronizar tabla tipo_trabajador de Oracle → PostgreSQL
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public boolean sincronizarTipoTrabajador() {
        log.info("🔥 Iniciando sincronización de tabla TIPO_TRABAJADOR (Remote → Local)");
        String tabla = "tipo_trabajador";
        resetearContadores(tabla);

        try {
            // Obtener todos los tipos de trabajador de Oracle
            List<TipoTrabajadorRemote> tiposRemote = tipoTrabajadorRemoteRepository.findAll();
            Set<String> tiposRemoteKeys = tiposRemote.stream()
                    .map(TipoTrabajadorRemote::getTipoTrabajador)
                    .collect(Collectors.toSet());
            log.info("📊 Encontrados {} tipos de trabajador en bd_remota", tiposRemote.size());

            // Obtener todos los tipos locales
            List<TipoTrabajadorLocal> tiposLocal = tipoTrabajadorLocalRepository.findAll();
            log.info("📊 Encontrados {} tipos de trabajador en bd_local", tiposLocal.size());

            // PASO 1: Eliminar registros que no existen en remoto
            for (TipoTrabajadorLocal tipoLocal : tiposLocal) {
                if (!tiposRemoteKeys.contains(tipoLocal.getTipoTrabajador())) {
                    tipoTrabajadorLocalRepository.delete(tipoLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminado tipo de trabajador local que no existe en remoto: {}",
                            tipoLocal.getTipoTrabajador());
                }
            }

            // PASO 2: Insertar o actualizar registros desde remoto
            for (TipoTrabajadorRemote tipoRemote : tiposRemote) {
                try {
                    procesarTipoTrabajador(tipoRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en tipo de trabajador %s: %s",
                            tipoRemote.getTipoTrabajador(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }

            // Verificar cantidades
            long totalRemoto = tipoTrabajadorRemoteRepository.count();
            long totalLocal = tipoTrabajadorLocalRepository.count();

            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }

            log.info("✅ Sincronización TIPO_TRABAJADOR completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}",
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));

            return errores.get(tabla) == 0;

        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de TIPO_TRABAJADOR", e);
            erroresSincronizacion.add("Error crítico en tabla tipo_trabajador: " + e.getMessage());
            return false;
        }
    }

    /**
     * Sincronizar tabla area de Oracle → PostgreSQL
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public boolean sincronizarArea() {
        log.info("🔥 Iniciando sincronización de tabla AREA (Remote → Local)");
        String tabla = "area";
        resetearContadores(tabla);

        try {
            // Obtener todos las áreas de Oracle
            List<AreaRemote> areasRemote = areaRemoteRepository.findAll();
            Set<String> codigosRemote = areasRemote.stream()
                    .map(AreaRemote::getCodArea)
                    .collect(Collectors.toSet());
            log.info("📊 Encontradas {} áreas en bd_remota", areasRemote.size());

            // Obtener todos las áreas locales
            List<AreaLocal> areasLocal = areaLocalRepository.findAll();
            log.info("📊 Encontradas {} áreas en bd_local", areasLocal.size());

            // PASO 1: Eliminar registros que no existen en remoto
            for (AreaLocal areaLocal : areasLocal) {
                if (!codigosRemote.contains(areaLocal.getCodArea())) {
                    areaLocalRepository.delete(areaLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminada área local que no existe en remoto: {}",
                            areaLocal.getCodArea());
                }
            }

            // PASO 2: Insertar o actualizar registros desde remoto
            for (AreaRemote areaRemote : areasRemote) {
                try {
                    procesarArea(areaRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en área %s: %s",
                            areaRemote.getCodArea(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }

            // Verificar cantidades
            long totalRemoto = areaRemoteRepository.count();
            long totalLocal = areaLocalRepository.count();

            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }

            log.info("✅ Sincronización AREA completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}",
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));

            return errores.get(tabla) == 0;

        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de AREA", e);
            erroresSincronizacion.add("Error crítico en tabla area: " + e.getMessage());
            return false;
        }
    }

    /**
     * Sincronizar tabla seccion de Oracle → PostgreSQL
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public boolean sincronizarSeccion() {
        log.info("🔥 Iniciando sincronización de tabla SECCION (Remote → Local)");
        String tabla = "seccion";
        resetearContadores(tabla);

        try {
            // Obtener todas las secciones de Oracle
            List<SeccionRemote> seccionesRemote = seccionRemoteRepository.findAll();
            // Crear Set con las claves (codArea, codSeccion) con trim aplicado
            Set<String> keysRemote = seccionesRemote.stream()
                    .map(seccion -> {
                        String codArea = seccion.getCodArea() != null ? seccion.getCodArea().trim() : "";
                        String codSeccion = seccion.getCodSeccion() != null ? seccion.getCodSeccion().trim() : "";
                        return codArea + "|" + codSeccion;
                    })
                    .collect(Collectors.toSet());
            log.info("📊 Encontradas {} secciones en bd_remota", seccionesRemote.size());

            // Obtener todas las secciones locales
            List<SeccionLocal> seccionesLocal = seccionLocalRepository.findAll();
            log.info("📊 Encontradas {} secciones en bd_local", seccionesLocal.size());

            // Debug: Mostrar algunos IDs para verificar
            if (!seccionesRemote.isEmpty()) {
                SeccionRemote primera = seccionesRemote.get(0);
                log.debug("📊 Ejemplo ID remoto: '{}' - '{}' (con espacios: '{}')",
                    primera.getCodArea(), primera.getCodSeccion(),
                    primera.getCodArea() + "|" + primera.getCodSeccion());
                log.debug("📊 ID remoto después de trim: '{}' - '{}'",
                    primera.getCodArea() != null ? primera.getCodArea().trim() : null,
                    primera.getCodSeccion() != null ? primera.getCodSeccion().trim() : null);
            }
            if (!seccionesLocal.isEmpty()) {
                SeccionLocal primeraLocal = seccionesLocal.get(0);
                log.debug("📊 Ejemplo ID local: '{}' - '{}' (con espacios: '{}')",
                    primeraLocal.getCodArea(), primeraLocal.getCodSeccion(),
                    primeraLocal.getCodArea() + "|" + primeraLocal.getCodSeccion());
                log.debug("📊 ID local después de trim: '{}' - '{}'",
                    primeraLocal.getCodArea() != null ? primeraLocal.getCodArea().trim() : null,
                    primeraLocal.getCodSeccion() != null ? primeraLocal.getCodSeccion().trim() : null);
            }

            // PASO 1: Eliminar registros que no existen en remoto
            for (SeccionLocal seccionLocal : seccionesLocal) {
                // Crear clave con trim para comparar
                String codAreaLocal = seccionLocal.getCodArea() != null ? seccionLocal.getCodArea().trim() : "";
                String codSeccionLocal = seccionLocal.getCodSeccion() != null ? seccionLocal.getCodSeccion().trim() : "";
                String keyLocal = codAreaLocal + "|" + codSeccionLocal;
                
                if (!keysRemote.contains(keyLocal)) {
                    seccionLocalRepository.delete(seccionLocal);
                    eliminados.merge(tabla, 1, Integer::sum);
                    log.debug("🗑️ Eliminada sección local que no existe en remoto: {} - {}",
                            seccionLocal.getCodArea(), seccionLocal.getCodSeccion());
                }
            }

            // PASO 2: Insertar o actualizar registros desde remoto
            for (SeccionRemote seccionRemote : seccionesRemote) {
                try {
                    procesarSeccion(seccionRemote, tabla);
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    String error = String.format("Error en sección %s-%s: %s",
                            seccionRemote.getCodArea(), seccionRemote.getCodSeccion(), e.getMessage());
                    erroresSincronizacion.add(error);
                    log.error("❌ {}", error, e);
                }
            }

            // Verificar cantidades
            long totalRemoto = seccionRemoteRepository.count();
            long totalLocal = seccionLocalRepository.count();

            if (totalRemoto != totalLocal) {
                log.warn("⚠️ Discrepancia en cantidades - Remoto: {} | Local: {}", totalRemoto, totalLocal);
            } else {
                log.info("✅ Cantidades sincronizadas - Total: {} registros", totalLocal);
            }

            log.info("✅ Sincronización SECCION completada - Insertados: {} | Actualizados: {} | Eliminados: {} | Errores: {}",
                    insertados.get(tabla), actualizados.get(tabla), eliminados.get(tabla), errores.get(tabla));

            return errores.get(tabla) == 0;

        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de SECCION", e);
            erroresSincronizacion.add("Error crítico en tabla seccion: " + e.getMessage());
            return false;
        }
    }

    /**
     * Sincronizar tarjetas de reloj
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
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
                .codCargo(remote.getCodCargo())
                .tipoTrabajador(remote.getTipoTrabajador())
                .codSeccion(remote.getCodSeccion())
                .codArea(remote.getCodArea())
                .tipoDocIdentRtps(remote.getTipoDocIdentRtps())
                .nroDocIdentRtps(remote.getNroDocIdentRtps())
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
               !equals(remote.getFechaCese(), local.getFechaCese()) ||
               !equals(remote.getTipoTrabajador(), local.getTipoTrabajador()) ||
               !equals(remote.getCodSeccion(), local.getCodSeccion()) ||
               !equals(remote.getCodArea(), local.getCodArea()) ||
               !equals(remote.getCodCargo(), local.getCodCargo()) ||
               !equals(remote.getTipoDocIdentRtps(), local.getTipoDocIdentRtps()) ||
               !equals(remote.getNroDocIdentRtps(), local.getNroDocIdentRtps());
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
        local.setCodCargo(remote.getCodCargo());
        local.setTipoTrabajador(remote.getTipoTrabajador());
        local.setCodSeccion(remote.getCodSeccion());
        local.setCodArea(remote.getCodArea());
        local.setTipoDocIdentRtps(remote.getTipoDocIdentRtps());
        local.setNroDocIdentRtps(remote.getNroDocIdentRtps());
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
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
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

    private void procesarTipoTrabajador(TipoTrabajadorRemote tipoRemote, String tabla) {
        String tipoTrabajador = tipoRemote.getTipoTrabajador();

        Optional<TipoTrabajadorLocal> tipoLocalOpt = tipoTrabajadorLocalRepository.findById(tipoTrabajador);

        if (tipoLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            TipoTrabajadorLocal nuevoTipo = convertirTipoTrabajadorRemoteToLocal(tipoRemote);
            tipoTrabajadorLocalRepository.save(nuevoTipo);
            insertados.merge(tabla, 1, Integer::sum);
            log.debug("➕ Insertado tipo de trabajador: {}", tipoTrabajador);

        } else {
            // ACTUALIZAR si hay cambios reales
            TipoTrabajadorLocal tipoLocal = tipoLocalOpt.get();

            if (hayDiferenciasTipoTrabajador(tipoRemote, tipoLocal)) {
                actualizarTipoTrabajadorLocal(tipoLocal, tipoRemote);
                tipoTrabajadorLocalRepository.save(tipoLocal);
                actualizados.merge(tabla, 1, Integer::sum);
                log.debug("🔄 Actualizado tipo de trabajador: {}", tipoTrabajador);
            }
        }
    }

    private TipoTrabajadorLocal convertirTipoTrabajadorRemoteToLocal(TipoTrabajadorRemote remote) {
        return TipoTrabajadorLocal.builder()
                .tipoTrabajador(remote.getTipoTrabajador())
                .descripcionTipoTrabajador(remote.getDescripcionTipoTrabajador())
                .flagEmisionBoleta(remote.getFlagEmisionBoleta())
                .flagEstado(remote.getFlagEstado())
                .libroPlanilla(remote.getLibroPlanilla())
                .libroIntGrati(remote.getLibroIntGrati())
                .libroIntRemun(remote.getLibroIntRemun())
                .libroIntPagoGrati(remote.getLibroIntPagoGrati())
                .libroIntPagoRemun(remote.getLibroIntPagoRemun())
                .libroProvCts(remote.getLibroProvCts())
                .libroProvGrati(remote.getLibroProvGrati())
                .flagReplicacion(remote.getFlagReplicacion())
                .diaMinDescanso(remote.getDiaMinDescanso())
                .diasTrabHabFijo(remote.getDiasTrabHabFijo())
                .factorCostoHr(remote.getFactorCostoHr())
                .cuentaContableCtsCargo(remote.getCuentaContableCtsCargo())
                .cuentaContableCtsAbono(remote.getCuentaContableCtsAbono())
                .flagTablaOrigen(remote.getFlagTablaOrigen())
                .documentoAfectaPresupuesto(remote.getDocumentoAfectaPresupuesto())
                .cuentaPresupAfectaCts(remote.getCuentaPresupAfectaCts())
                .documentoAfectaPresupCts(remote.getDocumentoAfectaPresupCts())
                .flagDestajoJornal(remote.getFlagDestajoJornal())
                .libroProvVacac(remote.getLibroProvVacac())
                .flagIngresoBoleta(remote.getFlagIngresoBoleta())
                .cuentaPresupLbs(remote.getCuentaPresupLbs())
                .flagSectorAgrario(remote.getFlagSectorAgrario())
                .periodoBoleta(remote.getPeriodoBoleta())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }

    private boolean hayDiferenciasTipoTrabajador(TipoTrabajadorRemote remote, TipoTrabajadorLocal local) {
        return !equals(remote.getDescripcionTipoTrabajador(), local.getDescripcionTipoTrabajador()) ||
               !equals(remote.getFlagEmisionBoleta(), local.getFlagEmisionBoleta()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado()) ||
               !equals(remote.getLibroPlanilla(), local.getLibroPlanilla()) ||
               !equals(remote.getLibroIntGrati(), local.getLibroIntGrati()) ||
               !equals(remote.getLibroIntRemun(), local.getLibroIntRemun()) ||
               !equals(remote.getLibroIntPagoGrati(), local.getLibroIntPagoGrati()) ||
               !equals(remote.getLibroIntPagoRemun(), local.getLibroIntPagoRemun()) ||
               !equals(remote.getLibroProvCts(), local.getLibroProvCts()) ||
               !equals(remote.getLibroProvGrati(), local.getLibroProvGrati()) ||
               !equals(remote.getFlagReplicacion(), local.getFlagReplicacion()) ||
               !equals(remote.getDiaMinDescanso(), local.getDiaMinDescanso()) ||
               !equals(remote.getDiasTrabHabFijo(), local.getDiasTrabHabFijo()) ||
               !equals(remote.getFactorCostoHr(), local.getFactorCostoHr()) ||
               !equals(remote.getCuentaContableCtsCargo(), local.getCuentaContableCtsCargo()) ||
               !equals(remote.getCuentaContableCtsAbono(), local.getCuentaContableCtsAbono()) ||
               !equals(remote.getFlagTablaOrigen(), local.getFlagTablaOrigen()) ||
               !equals(remote.getDocumentoAfectaPresupuesto(), local.getDocumentoAfectaPresupuesto()) ||
               !equals(remote.getCuentaPresupAfectaCts(), local.getCuentaPresupAfectaCts()) ||
               !equals(remote.getDocumentoAfectaPresupCts(), local.getDocumentoAfectaPresupCts()) ||
               !equals(remote.getFlagDestajoJornal(), local.getFlagDestajoJornal()) ||
               !equals(remote.getLibroProvVacac(), local.getLibroProvVacac()) ||
               !equals(remote.getFlagIngresoBoleta(), local.getFlagIngresoBoleta()) ||
               !equals(remote.getCuentaPresupLbs(), local.getCuentaPresupLbs()) ||
               !equals(remote.getFlagSectorAgrario(), local.getFlagSectorAgrario()) ||
               !equals(remote.getPeriodoBoleta(), local.getPeriodoBoleta());
    }

    private void actualizarTipoTrabajadorLocal(TipoTrabajadorLocal local, TipoTrabajadorRemote remote) {
        local.setDescripcionTipoTrabajador(remote.getDescripcionTipoTrabajador());
        local.setFlagEmisionBoleta(remote.getFlagEmisionBoleta());
        local.setFlagEstado(remote.getFlagEstado());
        local.setLibroPlanilla(remote.getLibroPlanilla());
        local.setLibroIntGrati(remote.getLibroIntGrati());
        local.setLibroIntRemun(remote.getLibroIntRemun());
        local.setLibroIntPagoGrati(remote.getLibroIntPagoGrati());
        local.setLibroIntPagoRemun(remote.getLibroIntPagoRemun());
        local.setLibroProvCts(remote.getLibroProvCts());
        local.setLibroProvGrati(remote.getLibroProvGrati());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setDiaMinDescanso(remote.getDiaMinDescanso());
        local.setDiasTrabHabFijo(remote.getDiasTrabHabFijo());
        local.setFactorCostoHr(remote.getFactorCostoHr());
        local.setCuentaContableCtsCargo(remote.getCuentaContableCtsCargo());
        local.setCuentaContableCtsAbono(remote.getCuentaContableCtsAbono());
        local.setFlagTablaOrigen(remote.getFlagTablaOrigen());
        local.setDocumentoAfectaPresupuesto(remote.getDocumentoAfectaPresupuesto());
        local.setCuentaPresupAfectaCts(remote.getCuentaPresupAfectaCts());
        local.setDocumentoAfectaPresupCts(remote.getDocumentoAfectaPresupCts());
        local.setFlagDestajoJornal(remote.getFlagDestajoJornal());
        local.setLibroProvVacac(remote.getLibroProvVacac());
        local.setFlagIngresoBoleta(remote.getFlagIngresoBoleta());
        local.setCuentaPresupLbs(remote.getCuentaPresupLbs());
        local.setFlagSectorAgrario(remote.getFlagSectorAgrario());
        local.setPeriodoBoleta(remote.getPeriodoBoleta());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
        log.info("📋 Campos actualizados: TODOS los 27 campos copiados desde Oracle");
    }

    private void procesarArea(AreaRemote areaRemote, String tabla) {
        String codArea = areaRemote.getCodArea();

        Optional<AreaLocal> areaLocalOpt = areaLocalRepository.findById(codArea);

        if (areaLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            AreaLocal nuevaArea = convertirAreaRemoteToLocal(areaRemote);
            areaLocalRepository.save(nuevaArea);
            insertados.merge(tabla, 1, Integer::sum);
            log.debug("➕ Insertada área: {}", codArea);

        } else {
            // ACTUALIZAR si hay cambios reales
            AreaLocal areaLocal = areaLocalOpt.get();

            if (hayDiferenciasArea(areaRemote, areaLocal)) {
                actualizarAreaLocal(areaLocal, areaRemote);
                areaLocalRepository.save(areaLocal);
                actualizados.merge(tabla, 1, Integer::sum);
                log.debug("🔄 Actualizada área: {}", codArea);
            }
        }
    }

    private AreaLocal convertirAreaRemoteToLocal(AreaRemote remote) {
        return AreaLocal.builder()
                .codArea(remote.getCodArea())
                .codJefeArea(remote.getCodJefeArea())
                .descripcionArea(remote.getDescripcionArea())
                .flagReplicacion(remote.getFlagReplicacion())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }

    private boolean hayDiferenciasArea(AreaRemote remote, AreaLocal local) {
        return !equals(remote.getCodJefeArea(), local.getCodJefeArea()) ||
               !equals(remote.getDescripcionArea(), local.getDescripcionArea()) ||
               !equals(remote.getFlagReplicacion(), local.getFlagReplicacion());
    }

    private void actualizarAreaLocal(AreaLocal local, AreaRemote remote) {
        local.setCodJefeArea(remote.getCodJefeArea());
        local.setDescripcionArea(remote.getDescripcionArea());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
        log.info("📋 Campos actualizados: Área {} actualizada desde Oracle", remote.getCodArea());
    }

    private void procesarSeccion(SeccionRemote seccionRemote, String tabla) {
        SeccionRemoteId remoteId = seccionRemote.getId();
        // Aplicar trim para evitar problemas con espacios en blanco en la comparación
        String codAreaTrim = remoteId.getCodArea() != null ? remoteId.getCodArea().trim() : null;
        String codSeccionTrim = remoteId.getCodSeccion() != null ? remoteId.getCodSeccion().trim() : null;
        SeccionLocalId localId = new SeccionLocalId(codAreaTrim, codSeccionTrim);

        Optional<SeccionLocal> seccionLocalOpt = seccionLocalRepository.findById(localId);

        if (seccionLocalOpt.isEmpty()) {
            // INSERTAR nuevo registro
            SeccionLocal nuevaSeccion = convertirSeccionRemoteToLocal(seccionRemote);
            seccionLocalRepository.save(nuevaSeccion);
            insertados.merge(tabla, 1, Integer::sum);

        } else {
            // ACTUALIZAR si hay cambios reales
            SeccionLocal seccionLocal = seccionLocalOpt.get();

            if (hayDiferenciasSeccion(seccionRemote, seccionLocal)) {
                actualizarSeccionLocal(seccionLocal, seccionRemote);
                seccionLocalRepository.save(seccionLocal);
                actualizados.merge(tabla, 1, Integer::sum);
            }
        }
    }

    private SeccionLocal convertirSeccionRemoteToLocal(SeccionRemote remote) {
        // Aplicar trim para evitar problemas con espacios en blanco
        String codAreaTrim = remote.getCodArea() != null ? remote.getCodArea().trim() : null;
        String codSeccionTrim = remote.getCodSeccion() != null ? remote.getCodSeccion().trim() : null;
        
        return SeccionLocal.builder()
                .id(new SeccionLocalId(codAreaTrim, codSeccionTrim))
                .codJefeSeccion(remote.getCodJefeSeccion())
                .descripcionSeccion(remote.getDescripcionSeccion())
                .porcentajeSctrIpss(remote.getPorcentajeSctrIpss())
                .porcentajeSctrOnp(remote.getPorcentajeSctrOnp())
                .flagReplicacion(remote.getFlagReplicacion())
                .flagEstado(remote.getFlagEstado())
                .fechaSync(LocalDate.now())
                .estadoSync("S")
                .build();
    }

    private boolean hayDiferenciasSeccion(SeccionRemote remote, SeccionLocal local) {
        return !equals(remote.getCodJefeSeccion(), local.getCodJefeSeccion()) ||
               !equals(remote.getDescripcionSeccion(), local.getDescripcionSeccion()) ||
               !equals(remote.getPorcentajeSctrIpss(), local.getPorcentajeSctrIpss()) ||
               !equals(remote.getPorcentajeSctrOnp(), local.getPorcentajeSctrOnp()) ||
               !equals(remote.getFlagReplicacion(), local.getFlagReplicacion()) ||
               !equals(remote.getFlagEstado(), local.getFlagEstado());
    }

    private void actualizarSeccionLocal(SeccionLocal local, SeccionRemote remote) {
        local.setCodJefeSeccion(remote.getCodJefeSeccion());
        local.setDescripcionSeccion(remote.getDescripcionSeccion());
        local.setPorcentajeSctrIpss(remote.getPorcentajeSctrIpss());
        local.setPorcentajeSctrOnp(remote.getPorcentajeSctrOnp());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setFlagEstado(remote.getFlagEstado());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S");
    }

    /**
     * Sincronizar tabla origen de Oracle → PostgreSQL
     * Tabla de solo lectura: solo sincronización remota → local
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public boolean sincronizarOrigen() {
        log.info("🔥 Iniciando sincronización de tabla ORIGEN (Remote → Local)");
        String tabla = "origen";
        resetearContadores(tabla);
        
        try {
            // Obtener todos los orígenes de la base remota
            List<OrigenRemote> origenesRemote = origenRemoteRepository.findAll();
            log.info("📊 Encontrados {} orígenes en bd_remota", origenesRemote.size());
            
            // Obtener orígenes locales existentes
            List<OrigenLocal> origenesLocal = origenLocalRepository.findAll();
            Map<String, OrigenLocal> origenesLocalMap = origenesLocal.stream()
                    .collect(Collectors.toMap(OrigenLocal::getCodOrigen, o -> o));
            log.info("📊 Encontrados {} orígenes en bd_local", origenesLocal.size());
            
            // Procesar cada origen remoto
            for (OrigenRemote remote : origenesRemote) {
                try {
                    OrigenLocal local = origenesLocalMap.get(remote.getCodOrigen());
                    
                    if (local == null) {
                        // INSERTAR nuevo origen
                        local = mapearOrigenRemoteALocal(remote);
                        origenLocalRepository.save(local);
                        insertados.merge(tabla, 1, Integer::sum);
                        log.info("➕ INSERTADO origen: {} - {}", remote.getCodOrigen(), remote.getNombre());
                    } else {
                        // ACTUALIZAR origen existente
                        actualizarOrigenLocal(local, remote);
                        origenLocalRepository.save(local);
                        actualizados.merge(tabla, 1, Integer::sum);
                        log.info("🔄 ACTUALIZADO origen: {} - {}", remote.getCodOrigen(), remote.getNombre());
                    }
                    
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    erroresSincronizacion.add("Error procesando origen " + remote.getCodOrigen() + ": " + e.getMessage());
                    log.error("❌ Error procesando origen: {}", remote.getCodOrigen(), e);
                }
            }
            
            log.info("✅ Sincronización de ORIGEN completada: {} insertados, {} actualizados, {} errores", 
                    getInsertados(tabla), getActualizados(tabla), getErrores(tabla));
            
            return getErrores(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de ORIGEN", e);
            erroresSincronizacion.add("Error crítico en sincronización de ORIGEN: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Mapear OrigenRemote a OrigenLocal
     */
    private OrigenLocal mapearOrigenRemoteALocal(OrigenRemote remote) {
        return OrigenLocal.builder()
                .codOrigen(remote.getCodOrigen())
                .nombre(remote.getNombre())
                .dirCalle(remote.getDirCalle())
                .dirNumero(remote.getDirNumero())
                .dirLote(remote.getDirLote())
                .dirMnz(remote.getDirMnz())
                .dirUrbanizacion(remote.getDirUrbanizacion())
                .dirDistrito(remote.getDirDistrito())
                .dirDepartamento(remote.getDirDepartamento())
                .dirProvincia(remote.getDirProvincia())
                .dirCodPostal(remote.getDirCodPostal())
                .telefono(remote.getTelefono())
                .fax(remote.getFax())
                .email(remote.getEmail())
                .flagReplicacion(remote.getFlagReplicacion())
                .flagEstado(remote.getFlagEstado())
                .cenBefGenOc(remote.getCenBefGenOc())
                .cenBefGenVtas(remote.getCenBefGenVtas())
                .cencosOc(remote.getCencosOc())
                .cntaPrspOc(remote.getCntaPrspOc())
                .cencosIgv(remote.getCencosIgv())
                .cntaPrspIgv(remote.getCntaPrspIgv())
                .flagPrspIgv(remote.getFlagPrspIgv())
                .fechaSync(LocalDate.now())
                .estadoSync("S") // S=Sincronizado
                .build();
    }
    
    /**
     * Actualizar OrigenLocal con datos de OrigenRemote
     */
    private void actualizarOrigenLocal(OrigenLocal local, OrigenRemote remote) {
        local.setNombre(remote.getNombre());
        local.setDirCalle(remote.getDirCalle());
        local.setDirNumero(remote.getDirNumero());
        local.setDirLote(remote.getDirLote());
        local.setDirMnz(remote.getDirMnz());
        local.setDirUrbanizacion(remote.getDirUrbanizacion());
        local.setDirDistrito(remote.getDirDistrito());
        local.setDirDepartamento(remote.getDirDepartamento());
        local.setDirProvincia(remote.getDirProvincia());
        local.setDirCodPostal(remote.getDirCodPostal());
        local.setTelefono(remote.getTelefono());
        local.setFax(remote.getFax());
        local.setEmail(remote.getEmail());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setFlagEstado(remote.getFlagEstado());
        local.setCenBefGenOc(remote.getCenBefGenOc());
        local.setCenBefGenVtas(remote.getCenBefGenVtas());
        local.setCencosOc(remote.getCencosOc());
        local.setCntaPrspOc(remote.getCntaPrspOc());
        local.setCencosIgv(remote.getCencosIgv());
        local.setCntaPrspIgv(remote.getCntaPrspIgv());
        local.setFlagPrspIgv(remote.getFlagPrspIgv());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S"); // S=Sincronizado
    }
    
    /**
     * Sincronizar tabla cargo de Oracle → PostgreSQL
     * Tabla de solo lectura: solo sincronización remota → local
     */
    @Transactional(value = "localTransactionManager", propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public boolean sincronizarCargo() {
        log.info("🔥 Iniciando sincronización de tabla CARGO (Remote → Local)");
        String tabla = "cargo";
        resetearContadores(tabla);
        
        try {
            // Obtener todos los cargos de la base remota
            List<CargoRemote> cargosRemote = cargoRemoteRepository.findAll();
            log.info("📊 Encontrados {} cargos en bd_remota", cargosRemote.size());
            
            // Obtener cargos locales existentes
            List<CargoLocal> cargosLocal = cargoLocalRepository.findAll();
            Map<String, CargoLocal> cargosLocalMap = cargosLocal.stream()
                    .collect(Collectors.toMap(CargoLocal::getCodCargo, c -> c));
            log.info("📊 Encontrados {} cargos en bd_local", cargosLocal.size());
            
            // Procesar cada cargo remoto
            for (CargoRemote remote : cargosRemote) {
                try {
                    CargoLocal local = cargosLocalMap.get(remote.getCodCargo());
                    
                    if (local == null) {
                        // INSERTAR nuevo cargo
                        local = mapearCargoRemoteALocal(remote);
                        cargoLocalRepository.save(local);
                        insertados.merge(tabla, 1, Integer::sum);
                        log.info("➕ INSERTADO cargo: {} - {}", remote.getCodCargo(), remote.getDescCargo());
                    } else {
                        // ACTUALIZAR cargo existente
                        actualizarCargoLocal(local, remote);
                        cargoLocalRepository.save(local);
                        actualizados.merge(tabla, 1, Integer::sum);
                        log.info("🔄 ACTUALIZADO cargo: {} - {}", remote.getCodCargo(), remote.getDescCargo());
                    }
                    
                } catch (Exception e) {
                    errores.merge(tabla, 1, Integer::sum);
                    erroresSincronizacion.add("Error procesando cargo " + remote.getCodCargo() + ": " + e.getMessage());
                    log.error("❌ Error procesando cargo: {}", remote.getCodCargo(), e);
                }
            }
            
            log.info("✅ Sincronización de CARGO completada: {} insertados, {} actualizados, {} errores", 
                    getInsertados(tabla), getActualizados(tabla), getErrores(tabla));
            
            return getErrores(tabla) == 0;
            
        } catch (Exception e) {
            log.error("❌ Error crítico en sincronización de CARGO", e);
            erroresSincronizacion.add("Error crítico en sincronización de CARGO: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Mapear CargoRemote a CargoLocal
     */
    private CargoLocal mapearCargoRemoteALocal(CargoRemote remote) {
        return CargoLocal.builder()
                .codCargo(remote.getCodCargo())
                .descCargo(remote.getDescCargo())
                .categoria(remote.getCategoria())
                .flagReplicacion(remote.getFlagReplicacion())
                .perfilRuta(remote.getPerfilRuta())
                .flagEstado(remote.getFlagEstado())
                .nivel(remote.getNivel())
                .codOcupacionRtps(remote.getCodOcupacionRtps())
                .manualMof(remote.getManualMof())
                .fechaSync(LocalDate.now())
                .estadoSync("S") // S=Sincronizado
                .build();
    }
    
    /**
     * Actualizar CargoLocal con datos de CargoRemote
     */
    private void actualizarCargoLocal(CargoLocal local, CargoRemote remote) {
        local.setDescCargo(remote.getDescCargo());
        local.setCategoria(remote.getCategoria());
        local.setFlagReplicacion(remote.getFlagReplicacion());
        local.setPerfilRuta(remote.getPerfilRuta());
        local.setFlagEstado(remote.getFlagEstado());
        local.setNivel(remote.getNivel());
        local.setCodOcupacionRtps(remote.getCodOcupacionRtps());
        local.setManualMof(remote.getManualMof());
        local.setFechaSync(LocalDate.now());
        local.setEstadoSync("S"); // S=Sincronizado
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