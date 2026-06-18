package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.CargoConstants;
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.repository.CargoRepository;

import java.math.BigDecimal;

/**
 * Validador de reglas de negocio para el módulo de Cargos.
 * Implementa las validaciones definidas en el contrato de API y la HU.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CargoValidator {
    
    private final CargoRepository repository;
    
    /**
     * Valida que el nombre no esté duplicado.
     * RH-CG-002: Ya existe un cargo con ese nombre.
     * 
     * @param nombre Nombre del cargo a validar
     * @param excludeId ID del cargo a excluir de la validación (null para creación)
     * @throws BusinessException si existe un cargo con el mismo nombre
     */
    public void validarNombreUnico(String nombre, Long excludeId) {
        log.debug("Validando nombre único: nombre={}, excludeId={}", nombre, excludeId);
        
        boolean exists = (excludeId == null)
            ? repository.existsByNombreIgnoreCase(nombre)
            : repository.existsByNombreIgnoreCaseAndIdNot(nombre, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar nombre de cargo: {}", nombre);
            throw new BusinessException(
                CargoConstants.MSG_NOMBRE_DUPLICADO,
                HttpStatus.CONFLICT,
                CargoConstants.ERROR_NOMBRE_DUPLICADO
            );
        }
    }
    
    /**
     * Valida que la banda salarial sea coherente.
     * RH-CG-003: El sueldo mínimo no puede ser mayor al sueldo máximo.
     * 
     * @param request DTO con los datos del cargo
     * @throws BusinessException si el sueldo mínimo es mayor al sueldo máximo
     */
    public void validarBandaSalarial(CargoRequest request) {
        BigDecimal sueldoMinimo = request.getSueldoMinimo();
        BigDecimal sueldoMaximo = request.getSueldoMaximo();
        
        if (sueldoMinimo == null || sueldoMaximo == null) {
            return;
        }
        
        log.debug("Validando banda salarial: min={}, max={}", sueldoMinimo, sueldoMaximo);
        
        if (sueldoMinimo.compareTo(sueldoMaximo) > 0) {
            log.warn("Banda salarial incoherente: min={} > max={}", sueldoMinimo, sueldoMaximo);
            throw new BusinessException(
                CargoConstants.MSG_BANDA_SALARIAL_INCOHERENTE,
                HttpStatus.BAD_REQUEST,
                CargoConstants.ERROR_BANDA_SALARIAL_INCOHERENTE
            );
        }
    }
    
    /**
     * Valida que el cargo no tenga trabajadores asignados antes de eliminar.
     * RH-CG-004: No se puede eliminar un cargo con colaboradores asignados.
     * 
     * @param cargoId ID del cargo a validar
     * @throws BusinessException si el cargo tiene trabajadores asignados
     */
    public void validarSinTrabajadoresAsignados(Long cargoId) {
        log.debug("Validando que cargo no tenga trabajadores asignados: cargoId={}", cargoId);
        
        long countTrabajadores = repository.countTrabajadoresByCargoId(cargoId);
        
        if (countTrabajadores > 0) {
            log.warn("Intento de eliminar cargo con {} trabajadores asignados: cargoId={}", 
                countTrabajadores, cargoId);
            throw new BusinessException(
                CargoConstants.MSG_ELIMINACION_CON_ASIGNADOS,
                HttpStatus.BAD_REQUEST,
                CargoConstants.ERROR_ELIMINACION_CON_ASIGNADOS
            );
        }
        
        log.debug("Validación de trabajadores asignados exitosa: cargoId={}", cargoId);
    }
}
