package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.dashboard.*;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.repository.MaestroRepository;
import com.sigre.asistencia.repository.TicketAsistenciaRepository;
import com.sigre.asistencia.repository.RacionesSeleccionadasRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Servicio para generar datos del dashboard de asistencia
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class DashboardService {
    
    private final AsistenciaHt580Repository asistenciaRepository;
    private final TicketAsistenciaRepository ticketRepository;
    private final MaestroRepository maestroRepository;
    private final RacionesSeleccionadasRepository racionesRepository;
    
    /**
     * Obtener todas las estadísticas generales CON DATOS REALES
     */
    public EstadisticasGeneralesDto obtenerEstadisticasGenerales() {
        log.info("Obteniendo estadísticas generales del dashboard");
        
        Long registrosHoy = asistenciaRepository.countRegistrosHoy();
        Long registrosSincronizados = asistenciaRepository.countRegistrosSincronizados();
        Long registrosPendientes = asistenciaRepository.countRegistrosPendientesSincronizacion();
        
        // DATOS REALES: Trabajadores únicos que han marcado hoy (usado en frontend por separado)
        // Long trabajadoresUnicosHoy = asistenciaRepository.countTrabajadoresUnicosHoy();
        
        Long ticketsPendientes = ticketRepository.countByEstadoProcesamiento("P");
        Long ticketsProcessed = ticketRepository.countByEstadoProcesamiento("C");
        Long ticketsError = ticketRepository.countByEstadoProcesamiento("E");
        
        String estadoSincronizacion = determinarEstadoSincronizacion(registrosSincronizados, registrosPendientes);
        
        return EstadisticasGeneralesDto.builder()
                .totalRegistrosHoy(registrosHoy)
                .totalRegistrosDbLocal(registrosPendientes)
                .totalRegistrosDbRemoto(registrosSincronizados)
                .ticketsPendientes(ticketsPendientes)
                .ticketsProcessed(ticketsProcessed)
                .ticketsError(ticketsError)
                .ultimaActualizacion(LocalDateTime.now())
                .estadoSincronizacion(estadoSincronizacion)
                .build();
    }
    
    /**
     * Obtener conteo REAL de raciones por tipo del día actual
     */
    public RacionesPorTipoDto obtenerRacionesPorTipo() {
        log.info("Obteniendo conteo real de raciones por tipo");
        
        LocalDate hoy = LocalDate.now();
        
        Long desayunos = racionesRepository.countRacionesByFechaAndTipo(hoy, "D");
        Long almuerzos = racionesRepository.countRacionesByFechaAndTipo(hoy, "A"); 
        Long cenas = racionesRepository.countRacionesByFechaAndTipo(hoy, "C");
        Long total = desayunos + almuerzos + cenas;
        
        log.info("Raciones del día {}: Desayunos={}, Almuerzos={}, Cenas={}, Total={}", 
                hoy, desayunos, almuerzos, cenas, total);
        
        return RacionesPorTipoDto.builder()
                .desayunos(desayunos)
                .almuerzos(almuerzos)
                .cenas(cenas)
                .totalRaciones(total)
                .fecha(hoy.format(DateTimeFormatter.ISO_LOCAL_DATE))
                .build();
    }
    
    /**
     * Obtener total REAL de trabajadores únicos que han marcado hoy
     */
    public Long obtenerTrabajadoresUnicosHoy() {
        log.info("Obteniendo total real de trabajadores únicos que han marcado hoy");
        
        Long trabajadoresUnicos = asistenciaRepository.countTrabajadoresUnicosHoy();
        log.info("Trabajadores únicos que han marcado hoy: {}", trabajadoresUnicos);
        
        return trabajadoresUnicos;
    }
    
    /**
     * Obtener marcajes por hora de las ÚLTIMAS 24 HORAS (no acumulado)
     * Igual que tendencia pero sin acumular - para ver tráfico por hora
     */
    public MarcajesPorHoraDto obtenerMarcajesDelDia() {
        log.info("Obteniendo marcajes por hora de las ÚLTIMAS 24 HORAS (no acumulado)");
        
        LocalDateTime inicio = LocalDateTime.now().minusHours(24);
        log.info("📅 Consultando últimas 24h: desde {} hasta ahora", inicio);
        
        // MISMA CONSULTA que el gráfico de tendencia
        List<Object[]> resultadosDetallados = asistenciaRepository.countMarcajesDetalladoUltimas24h(inicio);
        
        return procesarMarcajesUltimas24HorasSinAcumular(resultadosDetallados);
    }
    
    /**
     * Obtener marcajes por hora de las últimas 24 horas CORREGIDO
     * Distingue entre horas del día anterior (negativas) y día actual (positivas)
     */
    public MarcajesPorHoraDto obtenerMarcajesUltimas24Horas() {
        log.info("Obteniendo marcajes por hora de las últimas 24 horas CORREGIDO");
        
        LocalDateTime inicio = LocalDateTime.now().minusHours(24);
        List<Object[]> resultadosDetallados = asistenciaRepository.countMarcajesDetalladoUltimas24h(inicio);
        return procesarMarcajesUltimas24HorasCorregido(resultadosDetallados);
    }
    
    /**
     * Obtener listado completo de marcajes del día
     */
    public List<MarcajeDelDiaDto> obtenerListadoMarcajesHoy() {
        log.info("Obteniendo listado de marcajes del día");
        
        List<AsistenciaHt580> marcajes = asistenciaRepository.findMarcajesDelDia();
        
        return marcajes.stream()
                .map(this::convertirAMarcajeDelDia)
                .collect(Collectors.toList());
    }
    
    /**
     * Obtener resumen de marcajes por centro de costo
     */
    public List<MarcajesPorCentroCostoDto.ResumenCentroCosto> obtenerResumenPorCentroCosto() {
        log.info("Obteniendo resumen por centro de costo");
        
        List<Object[]> resultados = asistenciaRepository.countMarcajesPorCentroCostoHoy();
        
        return resultados.stream()
                .map(resultado -> {
                    String centroCosto = (String) resultado[0];
                    Long cantidad = ((Number) resultado[1]).longValue();
                    
                    // Contar trabajadores únicos por centro de costo
                    Long cantidadTrabajadores = contarTrabajadoresPorCentroCosto(centroCosto);
                    
                    return MarcajesPorCentroCostoDto.ResumenCentroCosto.builder()
                            .centroCosto(centroCosto)
                            .descripcionCentroCosto(obtenerDescripcionCentroCosto(centroCosto))
                            .cantidadMarcajes(cantidad)
                            .cantidadTrabajadores(cantidadTrabajadores)
                            .build();
                })
                .collect(Collectors.toList());
    }
    
    /**
     * Obtener marcajes detallados por centro de costo específico
     */
    public MarcajesPorCentroCostoDto obtenerMarcajesPorCentroCosto(String centroCosto) {
        log.info("Obteniendo marcajes detallados para centro de costo: {}", centroCosto);
        
        List<AsistenciaHt580> marcajes = asistenciaRepository.findMarcajesDelDia()
                .stream()
                .filter(m -> m.getCodigo().startsWith(centroCosto))
                .collect(Collectors.toList());
        
        List<MarcajeDelDiaDto> marcajesDto = marcajes.stream()
                .map(this::convertirAMarcajeDelDia)
                .collect(Collectors.toList());
        
        return MarcajesPorCentroCostoDto.builder()
                .centroCosto(centroCosto)
                .descripcionCentroCosto(obtenerDescripcionCentroCosto(centroCosto))
                .cantidadMarcajes((long) marcajes.size())
                .marcajes(marcajesDto)
                .build();
    }
    
    /**
     * Obtener dashboard completo
     */
    public DashboardResponseDto obtenerDashboardCompleto() {
        log.info("Generando dashboard completo");
        
        return DashboardResponseDto.builder()
                .estadisticasGenerales(obtenerEstadisticasGenerales())
                .marcajesDelDia(obtenerMarcajesDelDia())
                .marcajesUltimas24Horas(obtenerMarcajesUltimas24Horas())
                .listadoMarcajesHoy(obtenerListadoMarcajesHoy())
                .resumenPorCentroCosto(obtenerResumenPorCentroCosto())
                .build();
    }
    
    // ===== MÉTODOS PRIVADOS =====
    
    // Métodos legacy removidos para limpiar código
    
    /**
     * Procesar marcajes de las últimas 24 horas CORREGIDO
     * Horas del día anterior en negativo, horas del día actual en positivo
     */
    private MarcajesPorHoraDto procesarMarcajesUltimas24HorasCorregido(List<Object[]> resultados) {
        LocalDate hoy = LocalDate.now();
        LocalDate ayer = hoy.minusDays(1);
        LocalDateTime ahora = LocalDateTime.now();
        int horaActual = ahora.getHour();
        
        log.info("🕐 Procesando últimas 24h: Desde {}:00 ayer hasta {}:00 hoy", horaActual, horaActual);
        
        // Mapas para organizar datos
        Map<Integer, Long> marcajesAyer = new HashMap<>(); // Horas de ayer
        Map<Integer, Long> marcajesHoy = new HashMap<>();  // Horas de hoy
        
        // Procesar resultados de la query
        for (Object[] resultado : resultados) {
            LocalDate fecha = ((java.sql.Date) resultado[0]).toLocalDate();
            Integer hora = ((Number) resultado[1]).intValue();
            Long cantidad = ((Number) resultado[2]).longValue();
            
            if (fecha.equals(ayer)) {
                marcajesAyer.put(hora, cantidad);
            } else if (fecha.equals(hoy)) {
                marcajesHoy.put(hora, cantidad);
            }
        }
        
        // Construir arrays para las últimas 24 horas con horas negativas/positivas
        List<Integer> horas = new ArrayList<>();
        List<Long> cantidadPorHora = new ArrayList<>();
        List<Long> cantidadAcumulada = new ArrayList<>();
        
        Long acumulado = 0L;
        Long totalMarcajes = 0L;
        
        // PARTE 1: Horas del día anterior (de horaActual hasta 23) - CON VALORES NEGATIVOS
        for (int h = horaActual; h <= 23; h++) {
            horas.add(-h); // NEGATIVO para distinguir del día anterior
            Long cantidad = marcajesAyer.getOrDefault(h, 0L);
            cantidadPorHora.add(cantidad);
            acumulado += cantidad;
            cantidadAcumulada.add(acumulado);
            totalMarcajes += cantidad;
        }
        
        // PARTE 2: Horas del día actual (de 0 hasta horaActual) - CON VALORES POSITIVOS
        for (int h = 0; h <= horaActual; h++) {
            horas.add(h); // POSITIVO para el día actual
            Long cantidad = marcajesHoy.getOrDefault(h, 0L);
            cantidadPorHora.add(cantidad);
            acumulado += cantidad;
            cantidadAcumulada.add(acumulado);
            totalMarcajes += cantidad;
        }
        
        log.info("📊 Últimas 24h procesadas: {} horas de ayer (negativas), {} horas de hoy (positivas)", 
                (24 - horaActual), (horaActual + 1));
        log.info("📊 Total marcajes últimas 24h: {}", totalMarcajes);
        
        return MarcajesPorHoraDto.builder()
                .horas(horas)
                .cantidadPorHora(cantidadPorHora)
                .cantidadAcumulada(cantidadAcumulada)
                .totalMarcajes(totalMarcajes)
                .fecha("24h-hasta-" + hoy.format(DateTimeFormatter.ISO_LOCAL_DATE))
                .build();
    }
    
    /**
     * Procesar marcajes de las últimas 24 horas SIN ACUMULAR
     * Idéntico al método que funciona, pero sin acumulación
     */
    private MarcajesPorHoraDto procesarMarcajesUltimas24HorasSinAcumular(List<Object[]> resultados) {
        LocalDate hoy = LocalDate.now();
        LocalDate ayer = hoy.minusDays(1);
        LocalDateTime ahora = LocalDateTime.now();
        int horaActual = ahora.getHour();
        
        log.info("🕐 Procesando últimas 24h SIN ACUMULAR: Desde {}:00 ayer hasta {}:00 hoy", horaActual, horaActual);
        
        // Mapas para organizar datos (IGUAL que el método que funciona)
        Map<Integer, Long> marcajesAyer = new HashMap<>(); // Horas de ayer
        Map<Integer, Long> marcajesHoy = new HashMap<>();  // Horas de hoy
        
        // Procesar resultados de la query (IDÉNTICO al método exitoso)
        for (Object[] resultado : resultados) {
            LocalDate fecha = ((java.sql.Date) resultado[0]).toLocalDate();
            Integer hora = ((Number) resultado[1]).intValue();
            Long cantidad = ((Number) resultado[2]).longValue();
            
            if (fecha.equals(ayer)) {
                marcajesAyer.put(hora, cantidad);
            } else if (fecha.equals(hoy)) {
                marcajesHoy.put(hora, cantidad);
            }
        }
        
        // Construir arrays para las últimas 24 horas (IGUAL que método exitoso)
        List<Integer> horas = new ArrayList<>();
        List<Long> cantidadPorHora = new ArrayList<>();
        List<Long> cantidadAcumulada = new ArrayList<>(); // Mantengo para compatibilidad
        
        Long totalMarcajes = 0L;
        
        // PARTE 1: Horas del día anterior (de horaActual hasta 23) - CON VALORES NEGATIVOS
        for (int h = horaActual; h <= 23; h++) {
            horas.add(-h); // NEGATIVO para distinguir del día anterior
            Long cantidad = marcajesAyer.getOrDefault(h, 0L);
            cantidadPorHora.add(cantidad);
            cantidadAcumulada.add(cantidad); // SIN ACUMULAR - solo la cantidad de esa hora
            totalMarcajes += cantidad;
        }
        
        // PARTE 2: Horas del día actual (de 0 hasta horaActual) - CON VALORES POSITIVOS
        for (int h = 0; h <= horaActual; h++) {
            horas.add(h); // POSITIVO para el día actual
            Long cantidad = marcajesHoy.getOrDefault(h, 0L);
            cantidadPorHora.add(cantidad);
            cantidadAcumulada.add(cantidad); // SIN ACUMULAR - solo la cantidad de esa hora
            totalMarcajes += cantidad;
        }
        
        log.info("📊 Últimas 24h SIN ACUMULAR procesadas: {} horas de ayer (negativas), {} horas de hoy (positivas)", 
                (24 - horaActual), (horaActual + 1));
        log.info("📊 Total marcajes últimas 24h: {}", totalMarcajes);
        
        return MarcajesPorHoraDto.builder()
                .horas(horas)
                .cantidadPorHora(cantidadPorHora)
                .cantidadAcumulada(cantidadAcumulada) // Igual que cantidadPorHora (sin acumular)
                .totalMarcajes(totalMarcajes)
                .fecha("24h-hasta-" + hoy.format(DateTimeFormatter.ISO_LOCAL_DATE))
                .build();
    }
    
    private MarcajeDelDiaDto convertirAMarcajeDelDia(AsistenciaHt580 asistencia) {
        String nombreTrabajador = obtenerNombreTrabajador(asistencia.getCodigo());
        String centroCosto = asistencia.getCodigo().length() >= 2 ? 
                asistencia.getCodigo().substring(0, 2) : "XX";
        
        return MarcajeDelDiaDto.builder()
                .reckey(asistencia.getReckey())
                .codigoTrabajador(asistencia.getCodigo())
                .nombreTrabajador(nombreTrabajador)
                .tipoMarcaje(asistencia.getTipoMarcacion())
                .tipoMovimiento(asistencia.getFlagInOut())
                .descripcionMovimiento(obtenerDescripcionMovimiento(asistencia.getFlagInOut()))
                .fechaMovimiento(asistencia.getFechaMovimiento())
                .centroCosto(centroCosto)
                .turno(asistencia.getTurno())
                .direccionIp(asistencia.getDireccionIp())
                .estadoSincronizacion(asistencia.getFechaSync() != null ? "SINCRONIZADO" : "PENDIENTE")
                .build();
    }
    
    private String obtenerNombreTrabajador(String codigoTrabajador) {
        return maestroRepository.findById(codigoTrabajador)
                .map(Maestro::getNombreCompleto)
                .orElse("Trabajador no encontrado");
    }
    
    private String obtenerDescripcionMovimiento(String flagInOut) {
        Map<String, String> descripciones = Map.of(
                "1", "INGRESO",
                "2", "SALIDA", 
                "3", "INGRESO ALMUERZO",
                "4", "SALIDA ALMUERZO",
                "5", "INGRESO ESPECIAL",
                "6", "SALIDA ESPECIAL"
        );
        return descripciones.getOrDefault(flagInOut, "MOVIMIENTO DESCONOCIDO");
    }
    
    private String obtenerDescripcionCentroCosto(String centroCosto) {
        Map<String, String> centrosCosto = Map.of(
                "PR", "PRODUCCIÓN",
                "AD", "ADMINISTRACIÓN",
                "MA", "MANTENIMIENTO",
                "SE", "SEGURIDAD",
                "LO", "LOGÍSTICA",
                "CO", "COMEDOR",
                "TR", "TRANSPORTE"
        );
        return centrosCosto.getOrDefault(centroCosto, "ÁREA DESCONOCIDA");
    }
    
    private Long contarTrabajadoresPorCentroCosto(String centroCosto) {
        // Contar trabajadores únicos que han marcado hoy para este centro de costo
        return asistenciaRepository.findMarcajesDelDia()
                .stream()
                .filter(m -> m.getCodigo().startsWith(centroCosto))
                .map(AsistenciaHt580::getCodigo)
                .distinct()
                .count();
    }
    
    private String determinarEstadoSincronizacion(Long sincronizados, Long pendientes) {
        if (pendientes == 0) {
            return "SINCRONIZADO";
        } else if (sincronizados > pendientes) {
            return "PARCIAL";
        } else {
            return "PENDIENTE";
        }
    }
}
