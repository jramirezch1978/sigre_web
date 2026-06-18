package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.AreaConstants;
import pe.restaurant.rrhh.entity.Area;
import pe.restaurant.rrhh.repository.AreaRepository;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

/**
 * Validador de reglas de negocio para el módulo de Áreas.
 * Implementa las validaciones definidas en el contrato de API.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AreaValidator {
    
    private final AreaRepository repository;
    
    /**
     * Valida que el nombre no esté duplicado en el mismo nivel jerárquico.
     * RH-AR-002: Ya existe un área con ese nombre en el mismo nivel.
     * 
     * @param nombre Nombre del área a validar
     * @param padreId ID del área padre (null para áreas raíz)
     * @param excludeId ID del área a excluir de la validación (null para creación)
     * @throws BusinessException si existe un área con el mismo nombre en el mismo nivel
     */
    public void validarNombreUnico(String nombre, Long padreId, Long excludeId) {
        log.debug("Validando nombre único: nombre={}, padreId={}, excludeId={}", nombre, padreId, excludeId);
        
        boolean exists = (excludeId == null)
            ? repository.existsByNombreIgnoreCaseAndPadreId(nombre, padreId)
            : repository.existsByNombreIgnoreCaseAndPadreIdAndIdNot(nombre, padreId, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar nombre de área: {} en nivel padre: {}", nombre, padreId);
            throw new BusinessException(
                AreaConstants.MSG_NOMBRE_DUPLICADO,
                HttpStatus.CONFLICT,
                AreaConstants.ERROR_NOMBRE_DUPLICADO
            );
        }
    }
    
    /**
     * Valida que no se forme un ciclo en la jerarquía al asignar padre.
     * RH-AR-003: La asignación de padre genera un ciclo en la jerarquía.
     * 
     * Verifica que:
     * 1. Un área no sea su propio padre
     * 2. No se forme un ciclo indirecto (A -> B -> C -> A)
     * 
     * @param areaId ID del área que se está modificando
     * @param padreId ID del área padre a asignar
     * @throws BusinessException si se detecta un ciclo en la jerarquía
     */
    public void validarSinCiclos(Long areaId, Long padreId) {
        if (padreId == null || areaId == null) {
            return;
        }
        
        log.debug("Validando ciclos: areaId={}, padreId={}", areaId, padreId);
        
        // Validación 1: Un área no puede ser su propio padre
        if (areaId.equals(padreId)) {
            log.warn("Intento de asignar área como su propio padre: areaId={}", areaId);
            throw new BusinessException(
                AreaConstants.MSG_AREA_NO_PUEDE_SER_PROPIO_PADRE,
                HttpStatus.BAD_REQUEST,
                AreaConstants.ERROR_CICLO_JERARQUIA
            );
        }
        
        // Validación 2: Detectar ciclos indirectos
        Long currentPadreId = padreId;
        Set<Long> visited = new HashSet<>();
        visited.add(areaId);
        
        while (currentPadreId != null) {
            if (visited.contains(currentPadreId)) {
                log.warn("Ciclo detectado en jerarquía: areaId={}, padreId={}, visited={}", 
                    areaId, padreId, visited);
                throw new BusinessException(
                    AreaConstants.MSG_CICLO_JERARQUIA,
                    HttpStatus.BAD_REQUEST,
                    AreaConstants.ERROR_CICLO_JERARQUIA
                );
            }
            visited.add(currentPadreId);
            
            Optional<Area> padre = repository.findById(currentPadreId);
            currentPadreId = padre.map(Area::getPadreId).orElse(null);
        }
        
        log.debug("Validación de ciclos exitosa: areaId={}, padreId={}", areaId, padreId);
    }
    
    /**
     * Valida que el área no tenga sub-áreas antes de eliminar.
     * RH-AR-004: No se puede eliminar un área que tiene sub-áreas asignadas.
     * 
     * @param areaId ID del área a validar
     * @throws BusinessException si el área tiene sub-áreas asignadas
     */
    public void validarSinHijos(Long areaId) {
        log.debug("Validando que área no tenga hijos: areaId={}", areaId);
        
        long countHijos = repository.countByPadreId(areaId);
        
        if (countHijos > 0) {
            log.warn("Intento de eliminar área con {} sub-áreas: areaId={}", countHijos, areaId);
            throw new BusinessException(
                AreaConstants.MSG_ELIMINACION_CON_HIJOS,
                HttpStatus.BAD_REQUEST,
                AreaConstants.ERROR_ELIMINACION_CON_HIJOS
            );
        }
        
        log.debug("Validación de hijos exitosa: areaId={}", areaId);
    }
}
