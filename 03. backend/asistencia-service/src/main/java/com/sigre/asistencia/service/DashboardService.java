package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.dashboard.*;
import com.sigre.asistencia.dto.ReporteAsistenciaDto;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.entity.Area;
import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.entity.Seccion;
import com.sigre.asistencia.entity.SeccionId;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.repository.AreaRepository;
import com.sigre.asistencia.repository.MaestroRepository;
import com.sigre.asistencia.repository.SeccionRepository;
import com.sigre.asistencia.repository.TicketAsistenciaRepository;
import com.sigre.asistencia.repository.RacionesSeleccionadasRepository;
import org.springframework.data.repository.query.Param;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
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
    private final AreaRepository areaRepository;
    private final SeccionRepository seccionRepository;
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
        log.info("Obteniendo resumen por centro de costo con tipo de trabajador");
        
        // Usar la consulta que trae tipo_trabajador, desc_tipo_tra y desc_cencos
        List<Object[]> resultados = asistenciaRepository.findIndicadoresCentrosCostoPorFecha(LocalDate.now());
        
        // Agrupar por tipo_trabajador + desc_cencos
        Map<String, ResumenData> resumenMap = new HashMap<>();
        
        for (Object[] resultado : resultados) {
            String tipoTrabajador = (String) resultado[0];
            String descTipoTrabajador = (String) resultado[1];
            String descCencos = (String) resultado[6]; // desc_cencos está en posición 6
            Long cantidad = ((Number) resultado[8]).longValue();
            
            String clave = tipoTrabajador + "|" + (descCencos != null ? descCencos : "SIN CENTRO COSTO");
            
            if (!resumenMap.containsKey(clave)) {
                ResumenData data = new ResumenData();
                data.tipoTrabajador = tipoTrabajador;
                data.descTipoTrabajador = descTipoTrabajador != null ? descTipoTrabajador : tipoTrabajador;
                data.descCencos = descCencos != null ? descCencos : "SIN CENTRO COSTO";
                data.cantidadMarcajes = 0L;
                resumenMap.put(clave, data);
            }
            
            resumenMap.get(clave).cantidadMarcajes += cantidad;
        }
        
        return resumenMap.values().stream()
                .map(data -> MarcajesPorCentroCostoDto.ResumenCentroCosto.builder()
                        .centroCosto(data.tipoTrabajador)
                        .descripcionCentroCosto(data.descTipoTrabajador + " - " + data.descCencos)
                        .cantidadMarcajes(data.cantidadMarcajes)
                        .cantidadTrabajadores(0L) // TODO: calcular si es necesario
                        .build())
                .collect(Collectors.toList());
    }
    
    // Clase auxiliar para agrupar datos
    private static class ResumenData {
        String tipoTrabajador;
        String descTipoTrabajador;
        String descCencos;
        Long cantidadMarcajes;
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
     * Obtener indicadores de centros de costo con movimientos pivoteados
     */
    public List<MarcajesPorCentroCostoDto.IndicadorCentroCosto> obtenerIndicadoresCentrosCosto() {
        return obtenerIndicadoresCentrosCosto(LocalDate.now());
    }

    /**
     * Obtener indicadores de centros de costo con movimientos pivoteados por fecha
     */
    public List<MarcajesPorCentroCostoDto.IndicadorCentroCosto> obtenerIndicadoresCentrosCosto(LocalDate fecha) {
        log.info("Obteniendo indicadores de centros de costo para fecha: {}", fecha);

        List<Object[]> resultados = asistenciaRepository.findIndicadoresCentrosCostoPorFecha(fecha);

        // Procesar resultados y pivotear por tipo de movimiento
        Map<String, Map<String, Long>> pivoteoMap = new HashMap<>();

        // Mapa para almacenar descripciones
        Map<String, String[]> descripcionesMap = new HashMap<>();

        for (Object[] resultado : resultados) {
            String tipoTrabajador = (String) resultado[0];
            String descTipoTrabajador = (String) resultado[1];
            String codArea = (String) resultado[2];
            String descArea = (String) resultado[3];
            String codSeccion = (String) resultado[4];
            String descSeccion = (String) resultado[5];
            String descCentroCosto = (String) resultado[6];
            String flagInOut = (String) resultado[7];
            Long cantidad = ((Number) resultado[8]).longValue();

            String clave = tipoTrabajador + "|" + codArea + "|" + codSeccion;
            
            // Trim del flagInOut porque viene de CHAR(2) con espacios
            String flagInOutTrimmed = flagInOut != null ? flagInOut.trim() : "";

            // Guardar descripciones
            descripcionesMap.putIfAbsent(clave, new String[]{
                    descTipoTrabajador != null ? descTipoTrabajador : "SIN TIPO",
                    descArea != null ? descArea : "ÁREA DESCONOCIDA",
                    descSeccion != null ? descSeccion : "SECCIÓN DESCONOCIDA",
                    descCentroCosto != null ? descCentroCosto : "CENTRO COSTO DESCONOCIDO"
            });

            pivoteoMap.computeIfAbsent(clave, k -> new HashMap<>()).put(flagInOutTrimmed, cantidad);
        }

        return pivoteoMap.entrySet().stream()
                .map(entry -> {
                    String[] partes = entry.getKey().split("\\|");
                    String tipoTrabajador = partes[0];
                    String codArea = partes[1];
                    String codSeccion = partes[2];
                    String clave = entry.getKey();

                    String[] descripciones = descripcionesMap.get(clave);
                    Map<String, Long> movimientos = entry.getValue();

                    // Calcular total
                    Long total = movimientos.values().stream().mapToLong(Long::longValue).sum();

                    return MarcajesPorCentroCostoDto.IndicadorCentroCosto.builder()
                            .tipoTrabajador(tipoTrabajador)
                            .descTipoTrabajador(descripciones[0])
                            .codArea(codArea)
                            .descArea(descripciones[1])
                            .codSeccion(codSeccion)
                            .descSeccion(descripciones[2])
                            .descCentroCosto(descripciones[3])
                            .ingresoPlanta(movimientos.getOrDefault("1", 0L))
                            .salidaPlanta(movimientos.getOrDefault("2", 0L))
                            .salidaAlmorzar(movimientos.getOrDefault("3", 0L))
                            .regresoAlmorzar(movimientos.getOrDefault("4", 0L))
                            .salidaComision(movimientos.getOrDefault("5", 0L))
                            .retornoComision(movimientos.getOrDefault("6", 0L))
                            .ingresoProduccion(movimientos.getOrDefault("7", 0L))
                            .salidaProduccion(movimientos.getOrDefault("8", 0L))
                            .salidaCenar(movimientos.getOrDefault("9", 0L))
                            .regresoCenar(movimientos.getOrDefault("10", 0L))
                            .total(total)
                            .build();
                })
                .collect(Collectors.toList());
    }

    /**
     * Obtener indicadores de áreas con movimientos pivoteados
     */
    public List<IndicadoresAreaDto> obtenerIndicadoresAreas() {
        return obtenerIndicadoresAreas(LocalDate.now());
    }

    /**
     * Obtener indicadores de áreas con movimientos pivoteados por fecha
     */
    public List<IndicadoresAreaDto> obtenerIndicadoresAreas(LocalDate fecha) {
        log.info("Obteniendo indicadores de áreas para fecha: {}", fecha);

        List<Object[]> resultados = asistenciaRepository.findIndicadoresAreasPorFecha(fecha);

        // Procesar resultados y pivotear por tipo de movimiento
        Map<String, Map<String, Long>> pivoteoMap = new HashMap<>();
        Map<String, String[]> descripcionesMap = new HashMap<>();

        for (Object[] resultado : resultados) {
            String tipoTrabajador = (String) resultado[0];
            String descTipoTrabajador = (String) resultado[1];
            String codArea = (String) resultado[2];
            String descArea = (String) resultado[3];
            String descCentroCosto = (String) resultado[4];
            String flagInOut = (String) resultado[5];
            Long cantidad = ((Number) resultado[6]).longValue();

            String clave = tipoTrabajador + "|" + codArea;
            
            // Trim del flagInOut porque viene de CHAR(2) con espacios
            String flagInOutTrimmed = flagInOut != null ? flagInOut.trim() : "";

            // Guardar descripciones
            descripcionesMap.putIfAbsent(clave, new String[]{
                    descTipoTrabajador != null ? descTipoTrabajador : "SIN TIPO",
                    descArea != null ? descArea : "ÁREA DESCONOCIDA",
                    descCentroCosto != null ? descCentroCosto : "CENTRO COSTO DESCONOCIDO"
            });

            pivoteoMap.computeIfAbsent(clave, k -> new HashMap<>()).put(flagInOutTrimmed, cantidad);
        }

        return pivoteoMap.entrySet().stream()
                .map(entry -> {
                    String[] partes = entry.getKey().split("\\|");
                    String tipoTrabajador = partes[0];
                    String codArea = partes[1];
                    String clave = entry.getKey();

                    String[] descripciones = descripcionesMap.get(clave);
                    Map<String, Long> movimientos = entry.getValue();

                    // Calcular total
                    Long total = movimientos.values().stream().mapToLong(Long::longValue).sum();

                    return IndicadoresAreaDto.builder()
                            .tipoTrabajador(tipoTrabajador)
                            .descTipoTrabajador(descripciones[0])
                            .codArea(codArea)
                            .descArea(descripciones[1])
                            .descCentroCosto(descripciones[2])
                            .ingresoPlanta(movimientos.getOrDefault("1", 0L))
                            .salidaPlanta(movimientos.getOrDefault("2", 0L))
                            .salidaAlmorzar(movimientos.getOrDefault("3", 0L))
                            .regresoAlmorzar(movimientos.getOrDefault("4", 0L))
                            .salidaComision(movimientos.getOrDefault("5", 0L))
                            .retornoComision(movimientos.getOrDefault("6", 0L))
                            .ingresoProduccion(movimientos.getOrDefault("7", 0L))
                            .salidaProduccion(movimientos.getOrDefault("8", 0L))
                            .salidaCenar(movimientos.getOrDefault("9", 0L))
                            .regresoCenar(movimientos.getOrDefault("10", 0L))
                            .total(total)
                            .build();
                })
                .collect(Collectors.toList());
    }

    /**
     * Obtener indicadores de secciones con movimientos pivoteados
     */
    public List<IndicadoresSeccionDto> obtenerIndicadoresSecciones() {
        return obtenerIndicadoresSecciones(LocalDate.now());
    }

    /**
     * Obtener indicadores de secciones con movimientos pivoteados por fecha
     */
    public List<IndicadoresSeccionDto> obtenerIndicadoresSecciones(LocalDate fecha) {
        log.info("Obteniendo indicadores de secciones para fecha: {}", fecha);

        List<Object[]> resultados = asistenciaRepository.findIndicadoresSeccionesPorFecha(fecha);

        // Procesar resultados y pivotear por tipo de movimiento
        Map<String, Map<String, Long>> pivoteoMap = new HashMap<>();
        Map<String, String[]> descripcionesMap = new HashMap<>();

        for (Object[] resultado : resultados) {
            String tipoTrabajador = (String) resultado[0];
            String descTipoTrabajador = (String) resultado[1];
            String codArea = (String) resultado[2];
            String descArea = (String) resultado[3];
            String codSeccion = (String) resultado[4];
            String descSeccion = (String) resultado[5];
            String descCentroCosto = (String) resultado[6];
            String flagInOut = (String) resultado[7];
            Long cantidad = ((Number) resultado[8]).longValue();

            String clave = tipoTrabajador + "|" + codArea + "|" + codSeccion;
            
            // Trim del flagInOut porque viene de CHAR(2) con espacios
            String flagInOutTrimmed = flagInOut != null ? flagInOut.trim() : "";

            // Guardar descripciones
            descripcionesMap.putIfAbsent(clave, new String[]{
                    descTipoTrabajador != null ? descTipoTrabajador : "SIN TIPO",
                    descArea != null ? descArea : "ÁREA DESCONOCIDA",
                    descSeccion != null ? descSeccion : "SECCIÓN DESCONOCIDA",
                    descCentroCosto != null ? descCentroCosto : "CENTRO COSTO DESCONOCIDO"
            });

            pivoteoMap.computeIfAbsent(clave, k -> new HashMap<>()).put(flagInOutTrimmed, cantidad);
        }

        return pivoteoMap.entrySet().stream()
                .map(entry -> {
                    String[] partes = entry.getKey().split("\\|");
                    String tipoTrabajador = partes[0];
                    String codArea = partes[1];
                    String codSeccion = partes[2];
                    String clave = entry.getKey();

                    String[] descripciones = descripcionesMap.get(clave);
                    Map<String, Long> movimientos = entry.getValue();

                    // Calcular total
                    Long total = movimientos.values().stream().mapToLong(Long::longValue).sum();

                    return IndicadoresSeccionDto.builder()
                            .tipoTrabajador(tipoTrabajador)
                            .descTipoTrabajador(descripciones[0])
                            .codArea(codArea)
                            .descArea(descripciones[1])
                            .codSeccion(codSeccion)
                            .descSeccion(descripciones[2])
                            .descCentroCosto(descripciones[3])
                            .ingresoPlanta(movimientos.getOrDefault("1", 0L))
                            .salidaPlanta(movimientos.getOrDefault("2", 0L))
                            .salidaAlmorzar(movimientos.getOrDefault("3", 0L))
                            .regresoAlmorzar(movimientos.getOrDefault("4", 0L))
                            .salidaComision(movimientos.getOrDefault("5", 0L))
                            .retornoComision(movimientos.getOrDefault("6", 0L))
                            .ingresoProduccion(movimientos.getOrDefault("7", 0L))
                            .salidaProduccion(movimientos.getOrDefault("8", 0L))
                            .salidaCenar(movimientos.getOrDefault("9", 0L))
                            .regresoCenar(movimientos.getOrDefault("10", 0L))
                            .total(total)
                            .build();
                })
                .collect(Collectors.toList());
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
            LocalDate fecha = (LocalDate) resultado[0]; // fechaMovimiento ya es LocalDate
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
            LocalDate fecha = (LocalDate) resultado[0]; // fechaMovimiento ya es LocalDate
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
                .fechaMovimiento(asistencia.getFechaMovimiento().atStartOfDay())  // ✅ Convertir LocalDate a LocalDateTime
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
        // Hacer trim porque el campo FLAG_IN_OUT es CHAR(2) y viene con espacios
        String codigo = flagInOut != null ? flagInOut.trim() : "";
        
        Map<String, String> descripciones = Map.of(
                "1", "INGRESO A PLANTA",
                "2", "SALIDA DE PLANTA", 
                "3", "SALIDA A ALMORZAR",
                "4", "REGRESO DE ALMORZAR",
                "5", "SALIDA DE COMISIÓN",
                "6", "RETORNO DE COMISIÓN",
                "7", "INGRESO A PRODUCCIÓN",
                "8", "SALIDA DE PRODUCCIÓN",
                "9", "SALIDA A CENAR",
                "10", "REGRESO DE CENAR"
        );
        return descripciones.getOrDefault(codigo, "MOVIMIENTO DESCONOCIDO");
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

    private String obtenerDescTipoTrabajador(String tipoTrabajador) {
        Map<String, String> descripciones = Map.of(
                "O", "OBRERO",
                "E", "EMPLEADO",
                "C", "CONTRATISTA",
                "P", "PRACTICANTE"
        );
        return descripciones.getOrDefault(tipoTrabajador, "DESCONOCIDO");
    }

    private String obtenerDescAreaDesdeBD(String codArea) {
        return areaRepository.findById(codArea)
                .map(Area::getDescripcionArea)
                .orElse("ÁREA DESCONOCIDA");
    }

    private String obtenerDescSeccionDesdeBD(String codArea, String codSeccion) {
        SeccionId seccionId = new SeccionId(codArea, codSeccion);
        return seccionRepository.findById(seccionId)
                .map(Seccion::getDescripcionSeccion)
                .orElse("SECCIÓN DESCONOCIDA");
    }

    private String obtenerDescCentroCostoDesdeCodArea(String codArea) {
        // Mapear área a centro de costo usando la descripción del área
        return obtenerDescAreaDesdeBD(codArea);
    }

    // Mantenemos los métodos legacy por compatibilidad
    private String obtenerDescArea(String codArea) {
        Map<String, String> descripciones = Map.of(
                "1", "PRODUCCIÓN",
                "2", "ADMINISTRACIÓN",
                "3", "LOGÍSTICA",
                "4", "MANTENIMIENTO",
                "5", "SEGURIDAD",
                "6", "COMEDOR",
                "7", "TRANSPORTE"
        );
        return descripciones.getOrDefault(codArea, "ÁREA DESCONOCIDA");
    }

    private String obtenerDescSeccion(String codArea, String codSeccion) {
        // Aquí podríamos implementar lógica más compleja si hay secciones específicas por área
        // Por ahora devolvemos una descripción genérica
        return "SECCIÓN " + codSeccion;
    }
    
    /**
     * Generar reporte de asistencia con cálculo de horas trabajadas
     */
    public List<ReporteAsistenciaDto> generarReporteAsistencia(String codOrigen, LocalDate fechaInicio, LocalDate fechaFin) {
        log.info("Generando reporte de asistencia | Origen: {} | Rango: {} a {}", 
                codOrigen, fechaInicio, fechaFin);
        
        List<Object[]> resultados = asistenciaRepository.generarReporteAsistencia(codOrigen, fechaInicio, fechaFin);
        
        log.info("Reporte generado: {} registros", resultados.size());
        
        return resultados.stream()
                .map(this::convertirAReporteDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Convertir Object[] a ReporteAsistenciaDto
     */
    private ReporteAsistenciaDto convertirAReporteDto(Object[] row) {
        return ReporteAsistenciaDto.builder()
                .nro(((Number) row[0]).intValue())
                .tipoTrabajador((String) row[1])
                .codigoTrabajador((String) row[2])
                .dni((String) row[3])
                .apellidosNombres((String) row[4])
                .area((String) row[5])
                .cargoPuesto((String) row[6])
                .turno((String) row[7])
                .fecha(convertirALocalDate(row[8]))
                .horaIngreso(convertirALocalDateTime(row[9]))
                .horaSalida(convertirALocalDateTime(row[10]))
                .horasTrabajadas((String) row[11])
                .horasExtras(convertirADouble(row[12]))
                .tardanzaMin(convertirAInteger(row[13]))
                .totalHorasTrabajadasSemana(convertirADouble(row[14]))
                .totalHorasExtrasSemana(convertirADouble(row[15]))
                .totalDiasAsistidos(convertirAInteger(row[16]))
                .totalFaltas(convertirAInteger(row[17]))
                .porcAsistencia(convertirADouble(row[18]))
                .porcAusentismo(convertirADouble(row[19]))
                .build();
    }
    
    private LocalDate convertirALocalDate(Object obj) {
        if (obj == null) return null;
        if (obj instanceof LocalDate) return (LocalDate) obj;
        if (obj instanceof java.sql.Date) return ((java.sql.Date) obj).toLocalDate();
        return null;
    }
    
    private LocalDateTime convertirALocalDateTime(Object obj) {
        if (obj == null) return null;
        if (obj instanceof LocalDateTime) return (LocalDateTime) obj;
        if (obj instanceof java.sql.Timestamp) return ((java.sql.Timestamp) obj).toLocalDateTime();
        return null;
    }
    
    private Double convertirADouble(Object obj) {
        if (obj == null) return 0.0;
        if (obj instanceof Number) return ((Number) obj).doubleValue();
        return 0.0;
    }
    
    private Integer convertirAInteger(Object obj) {
        if (obj == null) return 0;
        if (obj instanceof Number) return ((Number) obj).intValue();
        return 0;
    }
}
