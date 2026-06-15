package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.entity.QuintaCategoria;

import java.util.List;

/**
 * Contrato de servicio para la gestión de retenciones de quinta categoría.
 * Define las operaciones de procesamiento por lotes, listado y detalle.
 */
public interface QuintaCategoriaService {

    /**
     * Ejecuta el proceso por lotes de cálculo de retención de quinta categoría
     * para el período indicado. Es idempotente: reemplaza los registros previos
     * del mismo período.
     *
     * @param anio año del período
     * @param mes  mes del período (1-12)
     * @return lista de registros de quinta categoría generados
     */
    List<QuintaCategoria> procesar(Integer anio, Integer mes);

    /**
     * Lista registros de quinta categoría con filtros opcionales y paginación.
     *
     * @param trabajadorId filtro por trabajador (nullable)
     * @param anio         filtro por año (nullable)
     * @param mes          filtro por mes (nullable)
     * @param pageable     paginación
     * @return página de registros
     */
    Page<QuintaCategoria> listar(Long trabajadorId, Integer anio, Integer mes, Pageable pageable);

    /**
     * Obtiene un registro de quinta categoría por su ID.
     *
     * @param id ID del registro
     * @return registro encontrado
     */
    QuintaCategoria obtenerPorId(Long id);
}
