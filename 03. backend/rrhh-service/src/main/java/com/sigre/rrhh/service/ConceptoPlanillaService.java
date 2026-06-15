package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;

import java.util.List;

/**
 * Servicio para la gestión de Conceptos de Planilla.
 * Define las operaciones de negocio disponibles para conceptos de planilla.
 * 
 * @author Equipo de Desarrollo RRHH
 */
public interface ConceptoPlanillaService {

    /**
     * Lista conceptos de planilla con filtros opcionales y paginación.
     * 
     * @param codigo Filtro por código (LIKE, opcional)
     * @param nombre Filtro por nombre (LIKE, opcional)
     * @param tipo Filtro por tipo (INGRESO, DESCUENTO, APORTE, opcional)
     * @param pageable Configuración de paginación
     * @return Página de conceptos que cumplen los filtros
     */
    Page<ConceptoPlanillaResponse> listar(String codigo, String nombre, String tipo, String flagEstado, Pageable pageable);

    /**
     * Obtiene un concepto de planilla por su ID.
     * 
     * @param id ID del concepto a buscar
     * @return DTO con los datos del concepto
     * @throws com.sigre.common.exception.ResourceNotFoundException si no existe el concepto
     */
    ConceptoPlanillaResponse obtenerPorId(Long id);

    /**
     * Crea un nuevo concepto de planilla.
     * Valida que el código sea único y que el tipo sea válido.
     * 
     * @param request DTO con los datos del concepto a crear
     * @return DTO con los datos del concepto creado
     * @throws com.sigre.common.exception.BusinessException si el código ya existe o el tipo es inválido
     */
    ConceptoPlanillaResponse crear(ConceptoPlanillaCreateRequest request);

    /**
     * Actualiza un concepto de planilla existente.
     * El código no puede ser modificado (inmutable).
     * 
     * @param id ID del concepto a actualizar
     * @param request DTO con los nuevos datos del concepto
     * @return DTO con los datos del concepto actualizado
     * @throws com.sigre.common.exception.ResourceNotFoundException si no existe el concepto
     * @throws com.sigre.common.exception.BusinessException si el tipo es inválido
     */
    ConceptoPlanillaResponse actualizar(Long id, ConceptoPlanillaUpdateRequest request);

    /**
     * Elimina un concepto de planilla.
     * Valida que el concepto no esté en uso en planillas procesadas.
     * 
     * @param id ID del concepto a eliminar
     * @throws com.sigre.common.exception.ResourceNotFoundException si no existe el concepto
     * @throws com.sigre.common.exception.BusinessException si el concepto está en uso
     */
    ConceptoPlanillaResponse desactivar(Long id);

    ConceptoPlanillaResponse activar(Long id);

    List<ConceptoPlanillaResponse> listarActivos();
}
