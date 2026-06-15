package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.CntasPagarRequest;
import com.sigre.finanzas.dto.response.PendientesPagarResponse;
import com.sigre.finanzas.dto.response.PendientesPagarSimpleResponse;
import com.sigre.finanzas.entity.CntasPagar;

import java.time.LocalDate;

public interface CntasPagarService {
    
    Page<CntasPagar> listar(Long proveedorId, Long docTipoId, String estado, 
                           LocalDate fechaDesde, LocalDate fechaHasta, 
                           LocalDate fechaVencimientoDesde, LocalDate fechaVencimientoHasta, 
                           Pageable pageable);
    
    CntasPagar obtenerPorId(Long id);
    
    CntasPagar crear(CntasPagarRequest request);
    
    CntasPagar actualizar(Long id, CntasPagarRequest request);
    
    CntasPagar anular(Long id);

    /**
     * Lista todos los documentos pendientes por pagar agrupados por tipo.
     * Incluye: Cuentas por Pagar, Órdenes de Giro, Liquidaciones, Retenciones y Detracciones.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Respuesta agrupada con totales por tipo
     */
    PendientesPagarResponse listarPendientesPorPagarAgrupado(
            Long sucursalId, Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta);

    /**
     * Lista todos los documentos pendientes por pagar en formato simple unificado.
     * Retorna una lista plana con todos los documentos pendientes.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista simple unificada de pendientes
     */
    PendientesPagarSimpleResponse listarPendientesPorPagarSimple(
            Long sucursalId, Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta);
}
