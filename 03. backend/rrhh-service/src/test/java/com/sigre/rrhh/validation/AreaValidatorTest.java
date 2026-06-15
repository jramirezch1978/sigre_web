package com.sigre.rrhh.validation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.entity.Area;
import com.sigre.rrhh.repository.AreaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("AreaValidator — Pruebas Unitarias")
class AreaValidatorTest {

    @Mock
    private AreaRepository repository;
    
    private AreaValidator validator;
    
    @BeforeEach
    void setUp() {
        validator = new AreaValidator(repository);
    }
    
    @Test
    @DisplayName("validarNombreUnico() con nombre duplicado -> lanza BusinessException")
    void validarNombreUnico_nombreDuplicado_lanzaBusinessException() {
        // Arrange
        when(repository.existsByNombreIgnoreCaseAndPadreId("Finanzas", null)).thenReturn(true);
        
        // Act & Assert
        assertThatThrownBy(() -> validator.validarNombreUnico("Finanzas", null, null))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un área con ese nombre en el mismo nivel");
    }
    
    @Test
    @DisplayName("validarNombreUnico() con nombre único -> no lanza excepción")
    void validarNombreUnico_nombreUnico_noLanzaExcepcion() {
        // Arrange
        when(repository.existsByNombreIgnoreCaseAndPadreId("Finanzas", null)).thenReturn(false);
        
        // Act & Assert - No debe lanzar excepción
        validator.validarNombreUnico("Finanzas", null, null);
    }
    
    @Test
    @DisplayName("validarNombreUnico() en actualización con nombre duplicado -> lanza BusinessException")
    void validarNombreUnico_actualizacionNombreDuplicado_lanzaBusinessException() {
        // Arrange
        when(repository.existsByNombreIgnoreCaseAndPadreIdAndIdNot("Finanzas", 1L, 2L)).thenReturn(true);
        
        // Act & Assert
        assertThatThrownBy(() -> validator.validarNombreUnico("Finanzas", 1L, 2L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe un área con ese nombre en el mismo nivel");
    }
    
    @Test
    @DisplayName("validarNombreUnico() en actualización con nombre único -> no lanza excepción")
    void validarNombreUnico_actualizacionNombreUnico_noLanzaExcepcion() {
        // Arrange
        when(repository.existsByNombreIgnoreCaseAndPadreIdAndIdNot("Finanzas", 1L, 2L)).thenReturn(false);
        
        // Act & Assert - No debe lanzar excepción
        validator.validarNombreUnico("Finanzas", 1L, 2L);
    }
    
    @Test
    @DisplayName("validarSinCiclos() con área como su propio padre -> lanza BusinessException")
    void validarSinCiclos_areaComoPropioPadre_lanzaBusinessException() {
        // Act & Assert
        assertThatThrownBy(() -> validator.validarSinCiclos(1L, 1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Un área no puede ser su propio padre");
    }
    
    @Test
    @DisplayName("validarSinCiclos() con ciclo indirecto -> lanza BusinessException")
    void validarSinCiclos_cicloIndirecto_lanzaBusinessException() {
        // Arrange - Crear ciclo: 1 -> 2 -> 3 -> 1
        Area area2 = RrhhTestFixtures.area(2L, "Área 2", 1L);
        Area area3 = RrhhTestFixtures.area(3L, "Área 3", 2L);
        Area area1 = RrhhTestFixtures.area(1L, "Área 1", 3L);
        
        when(repository.findById(3L)).thenReturn(Optional.of(area3));
        lenient().when(repository.findById(2L)).thenReturn(Optional.of(area2));
        lenient().when(repository.findById(1L)).thenReturn(Optional.of(area1));
        
        // Act & Assert
        assertThatThrownBy(() -> validator.validarSinCiclos(1L, 3L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("La asignación de padre genera un ciclo en la jerarquía");
    }
    
    @Test
    @DisplayName("validarSinCiclos() sin ciclo -> no lanza excepción")
    void validarSinCiclos_sinCiclo_noLanzaExcepcion() {
        // Arrange - Estructura lineal: 1 -> 2 -> 3
        Area area2 = RrhhTestFixtures.area(2L, "Área 2", 1L);
        Area area3 = RrhhTestFixtures.area(3L, "Área 3", 2L);
        
        when(repository.findById(3L)).thenReturn(Optional.of(area3));
        when(repository.findById(2L)).thenReturn(Optional.of(area2));
        when(repository.findById(1L)).thenReturn(Optional.empty()); // Fin de la cadena
        
        // Act & Assert - No debe lanzar excepción
        validator.validarSinCiclos(4L, 3L);
    }
    
    @Test
    @DisplayName("validarSinCiclos() con padreId null -> no lanza excepción")
    void validarSinCiclos_padreIdNull_noLanzaExcepcion() {
        // Act & Assert - No debe lanzar excepción
        validator.validarSinCiclos(1L, null);
    }
    
    @Test
    @DisplayName("validarSinCiclos() con areaId null -> no lanza excepción")
    void validarSinCiclos_areaIdNull_noLanzaExcepcion() {
        // Act & Assert - No debe lanzar excepción
        validator.validarSinCiclos(null, 1L);
    }
    
    @Test
    @DisplayName("validarSinHijos() con hijos -> lanza BusinessException")
    void validarSinHijos_conHijos_lanzaBusinessException() {
        // Arrange
        when(repository.countByPadreId(1L)).thenReturn(2L);
        
        // Act & Assert
        assertThatThrownBy(() -> validator.validarSinHijos(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede eliminar un área que tiene sub-áreas asignadas");
    }
    
    @Test
    @DisplayName("validarSinHijos() sin hijos -> no lanza excepción")
    void validarSinHijos_sinHijos_noLanzaExcepcion() {
        // Arrange
        when(repository.countByPadreId(1L)).thenReturn(0L);
        
        // Act & Assert - No debe lanzar excepción
        validator.validarSinHijos(1L);
    }
    
    @Test
    @DisplayName("validarSinHijos() con count cero -> no lanza excepción")
    void validarSinHijos_countCero_noLanzaExcepcion() {
        // Arrange
        when(repository.countByPadreId(1L)).thenReturn(0L);
        
        // Act & Assert - No debe lanzar excepción
        validator.validarSinHijos(1L);
    }
}
