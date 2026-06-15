package com.sigre.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.CargoRequest;
import com.sigre.rrhh.repository.CargoRepository;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

/**
 * Tests unitarios para CargoValidator.
 * Valida las reglas de negocio RH-CG-002, RH-CG-003 y RH-CG-004.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("CargoValidator — Pruebas Unitarias")
class CargoValidatorTest {

    @Mock
    private CargoRepository repository;
    
    private CargoValidator validator;
    
    @BeforeEach
    void setUp() {
        validator = new CargoValidator(repository);
    }
    
    // ══════════════════════════════════════════════════════════════
    // validarNombreUnico - RH-CG-002
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("validarNombreUnico() con nombre duplicado en creación -> lanza BusinessException")
    void validarNombreUnico_nombreDuplicadoCreacion_lanzaBusinessException() {
        when(repository.existsByNombreIgnoreCase("Chef Ejecutivo")).thenReturn(true);
        
        assertThatThrownBy(() -> validator.validarNombreUnico("Chef Ejecutivo", null))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un cargo con ese nombre");
    }
    
    @Test
    @DisplayName("validarNombreUnico() con nombre único en creación -> no lanza excepción")
    void validarNombreUnico_nombreUnicoCreacion_noLanzaExcepcion() {
        when(repository.existsByNombreIgnoreCase("Chef Ejecutivo")).thenReturn(false);
        
        validator.validarNombreUnico("Chef Ejecutivo", null);
    }
    
    @Test
    @DisplayName("validarNombreUnico() con nombre duplicado en actualización -> lanza BusinessException")
    void validarNombreUnico_nombreDuplicadoActualizacion_lanzaBusinessException() {
        when(repository.existsByNombreIgnoreCaseAndIdNot("Chef Ejecutivo", 2L)).thenReturn(true);
        
        assertThatThrownBy(() -> validator.validarNombreUnico("Chef Ejecutivo", 2L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un cargo con ese nombre");
    }
    
    @Test
    @DisplayName("validarNombreUnico() con nombre único en actualización -> no lanza excepción")
    void validarNombreUnico_nombreUnicoActualizacion_noLanzaExcepcion() {
        when(repository.existsByNombreIgnoreCaseAndIdNot("Chef Ejecutivo", 2L)).thenReturn(false);
        
        validator.validarNombreUnico("Chef Ejecutivo", 2L);
    }
    
    // ══════════════════════════════════════════════════════════════
    // validarBandaSalarial - RH-CG-003
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("validarBandaSalarial() con mínimo > máximo -> lanza BusinessException")
    void validarBandaSalarial_minimoMayorQueMaximo_lanzaBusinessException() {
        CargoRequest request = RrhhTestFixtures.cargoRequest(
            "Chef Ejecutivo", 
            "TÁCTICO",
            new BigDecimal("6000.0000"),
            new BigDecimal("4000.0000")
        );
        
        assertThatThrownBy(() -> validator.validarBandaSalarial(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El sueldo mínimo no puede ser mayor al sueldo máximo");
    }
    
    @Test
    @DisplayName("validarBandaSalarial() con mínimo = máximo -> no lanza excepción")
    void validarBandaSalarial_minimoIgualMaximo_noLanzaExcepcion() {
        CargoRequest request = RrhhTestFixtures.cargoRequest(
            "Chef Ejecutivo",
            "TÁCTICO",
            new BigDecimal("5000.0000"),
            new BigDecimal("5000.0000")
        );
        
        validator.validarBandaSalarial(request);
    }
    
    @Test
    @DisplayName("validarBandaSalarial() con mínimo < máximo -> no lanza excepción")
    void validarBandaSalarial_minimoMenorQueMaximo_noLanzaExcepcion() {
        CargoRequest request = RrhhTestFixtures.cargoRequest(
            "Chef Ejecutivo",
            "TÁCTICO",
            new BigDecimal("4000.0000"),
            new BigDecimal("6000.0000")
        );
        
        validator.validarBandaSalarial(request);
    }
    
    @Test
    @DisplayName("validarBandaSalarial() con mínimo null -> no lanza excepción")
    void validarBandaSalarial_minimoNull_noLanzaExcepcion() {
        CargoRequest request = new CargoRequest();
        request.setNombre("Chef Ejecutivo");
        request.setNivel("TÁCTICO");
        request.setSueldoMinimo(null);
        request.setSueldoMaximo(new BigDecimal("6000.0000"));
        
        validator.validarBandaSalarial(request);
    }
    
    @Test
    @DisplayName("validarBandaSalarial() con máximo null -> no lanza excepción")
    void validarBandaSalarial_maximoNull_noLanzaExcepcion() {
        CargoRequest request = new CargoRequest();
        request.setNombre("Chef Ejecutivo");
        request.setNivel("TÁCTICO");
        request.setSueldoMinimo(new BigDecimal("4000.0000"));
        request.setSueldoMaximo(null);
        
        validator.validarBandaSalarial(request);
    }
    
    @Test
    @DisplayName("validarBandaSalarial() con ambos null -> no lanza excepción")
    void validarBandaSalarial_ambosNull_noLanzaExcepcion() {
        CargoRequest request = new CargoRequest();
        request.setNombre("Chef Ejecutivo");
        request.setNivel("TÁCTICO");
        request.setSueldoMinimo(null);
        request.setSueldoMaximo(null);
        
        validator.validarBandaSalarial(request);
    }
    
    // ══════════════════════════════════════════════════════════════
    // validarSinTrabajadoresAsignados - RH-CG-004
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("validarSinTrabajadoresAsignados() con trabajadores asignados -> lanza BusinessException")
    void validarSinTrabajadoresAsignados_conTrabajadores_lanzaBusinessException() {
        when(repository.countTrabajadoresByCargoId(1L)).thenReturn(5L);
        
        assertThatThrownBy(() -> validator.validarSinTrabajadoresAsignados(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede eliminar un cargo con colaboradores asignados");
    }
    
    @Test
    @DisplayName("validarSinTrabajadoresAsignados() sin trabajadores -> no lanza excepción")
    void validarSinTrabajadoresAsignados_sinTrabajadores_noLanzaExcepcion() {
        when(repository.countTrabajadoresByCargoId(1L)).thenReturn(0L);
        
        validator.validarSinTrabajadoresAsignados(1L);
    }
}
