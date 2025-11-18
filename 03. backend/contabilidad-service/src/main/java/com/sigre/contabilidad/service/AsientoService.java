package com.sigre.contabilidad.service;

import com.sigre.contabilidad.model.entity.AsientoContable;
import com.sigre.contabilidad.model.entity.AsientoContableId;
import com.sigre.contabilidad.repository.AsientoContableRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servicio para gestión de Asientos Contables
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AsientoService {

    private final AsientoContableRepository asientoRepository;
    private static final DateTimeFormatter PERIODO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMM");

    /**
     * Obtiene asientos por empresa, libro y periodo
     */
    @Transactional(readOnly = true)
    public List<AsientoContable> obtenerAsientosPorPeriodo(String empresa, String libro, String periodo) {
        log.info("Obteniendo asientos - Empresa: {}, Libro: {}, Periodo: {}", empresa, libro, periodo);
        return asientoRepository.findByEmpresaLibroPeriodo(empresa, libro, periodo);
    }

    /**
     * Obtiene asientos por rango de fechas
     */
    @Transactional(readOnly = true)
    public List<AsientoContable> obtenerAsientosPorRangoFechas(String empresa, LocalDate fechaInicio, LocalDate fechaFin) {
        log.info("Obteniendo asientos por rango - Empresa: {}, Desde: {}, Hasta: {}", 
                 empresa, fechaInicio, fechaFin);
        return asientoRepository.findByRangoFechas(empresa, fechaInicio, fechaFin);
    }

    /**
     * Crea un nuevo asiento contable
     */
    @Transactional
    public AsientoContable crearAsiento(AsientoContable asiento) {
        log.info("Creando asiento contable - Libro: {}, Origen: {}", 
                 asiento.getId().getLibro(), asiento.getId().getOrigen());

        // Generar número de asiento automáticamente
        if (asiento.getId().getNroAsiento() == null) {
            Long ultimoNro = asientoRepository.findUltimoNroAsiento(
                asiento.getId().getEmpresa(),
                asiento.getId().getLibro(),
                asiento.getId().getOrigen(),
                asiento.getId().getPeriodo()
            );
            asiento.getId().setNroAsiento(ultimoNro + 1);
        }

        // Validar que el periodo corresponda a la fecha del asiento
        String periodoCalculado = asiento.getFechaAsiento().format(PERIODO_FORMATTER);
        asiento.getId().setPeriodo(periodoCalculado);

        // Establecer estado inicial
        if (asiento.getFlagEstado() == null) {
            asiento.setFlagEstado("1"); // Activo
        }
        if (asiento.getFlagTransferido() == null) {
            asiento.setFlagTransferido("S"); // Ya transferido (es un asiento directo)
        }

        AsientoContable saved = asientoRepository.save(asiento);
        log.info("Asiento creado exitosamente - Nro: {}", saved.getId().getNroAsiento());
        
        return saved;
    }

    /**
     * Anula un asiento contable
     */
    @Transactional
    public void anularAsiento(AsientoContableId asientoId) {
        log.info("Anulando asiento - Nro: {}", asientoId.getNroAsiento());
        
        AsientoContable asiento = asientoRepository.findById(asientoId)
            .orElseThrow(() -> new RuntimeException("Asiento no encontrado"));
        
        asiento.setFlagEstado("0");
        asientoRepository.save(asiento);
        
        log.info("Asiento anulado exitosamente");
    }

    /**
     * Obtiene asientos pendientes de transferir desde otro módulo
     */
    @Transactional(readOnly = true)
    public List<AsientoContable> obtenerAsientosPendientes(String empresa, String origenIntegracion) {
        log.info("Obteniendo asientos pendientes - Empresa: {}, Origen: {}", empresa, origenIntegracion);
        return asientoRepository.findPendientesTransferir(empresa, origenIntegracion);
    }

    /**
     * Marca asientos como transferidos
     */
    @Transactional
    public void marcarComoTransferido(List<AsientoContableId> asientos) {
        log.info("Marcando {} asientos como transferidos", asientos.size());
        
        asientos.forEach(id -> {
            asientoRepository.findById(id).ifPresent(asiento -> {
                asiento.setFlagTransferido("S");
                asientoRepository.save(asiento);
            });
        });
        
        log.info("Asientos marcados como transferidos exitosamente");
    }
}

