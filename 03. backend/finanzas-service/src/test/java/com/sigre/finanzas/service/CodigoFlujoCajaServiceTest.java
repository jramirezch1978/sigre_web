package com.sigre.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.entity.CodigoFlujoCaja;
import com.sigre.finanzas.repository.CodigoFlujoCajaRepository;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.service.impl.CodigoFlujoCajaServiceImpl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CodigoFlujoCajaService")
class CodigoFlujoCajaServiceTest {

    @Mock
    private CodigoFlujoCajaRepository codigoFlujoCajaRepository;

    @InjectMocks
    private CodigoFlujoCajaServiceImpl codigoFlujoCajaService;

    private CodigoFlujoCaja codigoFlujoCaja;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        // Setup test entity
        codigoFlujoCaja = new CodigoFlujoCaja();
        codigoFlujoCaja.setId(1L);
        codigoFlujoCaja.setCodigo("CFC001");
        codigoFlujoCaja.setGrupoCodigoFlujoCajaId(1L);
        codigoFlujoCaja.setNombre("VENTAS CONTADO");
        codigoFlujoCaja.setTipo("INGRESO");
        codigoFlujoCaja.setFactor(BigDecimal.ONE);
        codigoFlujoCaja.setFactorFlujoCaja((short) 1);
        codigoFlujoCaja.setFlagEstado("1");

        // Setup pageable
        pageable = PageRequest.of(0, 10);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("findAll - Debe retornar página de códigos de flujo de caja")
    void listar_conPaginacion_retornaPagina() {
        // Arrange
        Page<CodigoFlujoCaja> expectedPage = new PageImpl<>(List.of(codigoFlujoCaja), pageable, 1);
        when(codigoFlujoCajaRepository.findAll(pageable)).thenReturn(expectedPage);

        // Act
        Page<CodigoFlujoCaja> result = codigoFlujoCajaService.findAll(pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getCodigo()).isEqualTo("CFC001");
        verify(codigoFlujoCajaRepository, times(1)).findAll(pageable);
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("findById - Debe retornar código de flujo de caja cuando existe")
    void obtenerPorId_cuandoExiste_retornaEntidad() {
        // Arrange
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.of(codigoFlujoCaja));

        // Act
        CodigoFlujoCaja result = codigoFlujoCajaService.findById(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("CFC001");
        assertThat(result.getNombre()).isEqualTo("VENTAS CONTADO");
        verify(codigoFlujoCajaRepository, times(1)).findById(1L);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("findById - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> codigoFlujoCajaService.findById(1L)).isInstanceOf(RuntimeException.class);
        verify(codigoFlujoCajaRepository, times(1)).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("create - Debe crear código de flujo de caja exitosamente")
    void crear_conDatosValidos_creaEntidad() {
        // Arrange
        CodigoFlujoCaja newCodigo = new CodigoFlujoCaja();
        newCodigo.setCodigo("CFC002");
        newCodigo.setGrupoCodigoFlujoCajaId(1L);
        newCodigo.setNombre("VENTAS CREDITO");
        newCodigo.setTipo("INGRESO");
        newCodigo.setFactor(BigDecimal.valueOf(-1));
        newCodigo.setFactorFlujoCaja((short) 1);

        when(codigoFlujoCajaRepository.save(any(CodigoFlujoCaja.class))).thenReturn(newCodigo);
        when(codigoFlujoCajaRepository.existsByCodigoIgnoreCase(anyString())).thenReturn(false);

        // Act
        CodigoFlujoCaja result = codigoFlujoCajaService.create(newCodigo);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getCodigo()).isEqualTo("CFC002");
        assertThat(result.getNombre()).isEqualTo("VENTAS CREDITO");
        assertThat(result.getFactor()).isEqualTo(BigDecimal.valueOf(-1));
        assertThat(result.getFactorFlujoCaja()).isEqualTo((short) 1);
        verify(codigoFlujoCajaRepository, times(1)).save(any(CodigoFlujoCaja.class));
    }


    // ==== crear — otros ====

    @Test
    @DisplayName("create - Debe lanzar excepción cuando código ya existe")
    void crear_conCodigoDuplicado_lanzaBusinessException() {
        // Arrange
        CodigoFlujoCaja newCodigo = new CodigoFlujoCaja();
        newCodigo.setCodigo("CFC001");
        newCodigo.setNombre("DUPLICADO");
        newCodigo.setTipo("INGRESO");

        when(codigoFlujoCajaRepository.existsByCodigoIgnoreCase("CFC001")).thenReturn(true);

        // Act & Then
        assertThatThrownBy(() -> codigoFlujoCajaService.create(newCodigo)).isInstanceOf(RuntimeException.class);
        verify(codigoFlujoCajaRepository, never()).save(any(CodigoFlujoCaja.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("update - Debe actualizar código de flujo de caja exitosamente")
    void actualizar_conDatosValidos_actualizaEntidad() {
        // Arrange
        CodigoFlujoCaja updateData = new CodigoFlujoCaja();
        updateData.setCodigo("CFC003");
        updateData.setGrupoCodigoFlujoCajaId(2L);
        updateData.setNombre("VENTAS ACTUALIZADAS");
        updateData.setTipo("INGRESO");
        updateData.setFactor(BigDecimal.TEN);
        updateData.setFactorFlujoCaja((short) 2);

        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.of(codigoFlujoCaja));
        when(codigoFlujoCajaRepository.save(any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCaja);
        when(codigoFlujoCajaRepository.existsByCodigoIgnoreCaseAndIdNot(anyString(), anyLong())).thenReturn(false);

        // Act
        CodigoFlujoCaja result = codigoFlujoCajaService.update(1L, updateData);

        // Assert
        assertThat(result).isNotNull();
        verify(codigoFlujoCajaRepository, times(1)).findById(1L);
        verify(codigoFlujoCajaRepository, times(1)).save(any(CodigoFlujoCaja.class));
    }


    // ==== actualizar — otros ====

    @Test
    @DisplayName("update - lanza ResourceNotFoundException cuando no existe")
    void actualizar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        CodigoFlujoCaja updateData = new CodigoFlujoCaja();
        updateData.setCodigo("CFC003");
        updateData.setNombre("NO EXISTE");
        updateData.setTipo("INGRESO");

        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> codigoFlujoCajaService.update(1L, updateData)).isInstanceOf(RuntimeException.class);
        verify(codigoFlujoCajaRepository, never()).save(any(CodigoFlujoCaja.class));
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar código de flujo de caja")
    void activar_conIdValido_activaEntidad() {
        // Arrange
        codigoFlujoCaja.setFlagEstado("0");
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.of(codigoFlujoCaja));
        when(codigoFlujoCajaRepository.save(any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCaja);

        // Act
        CodigoFlujoCaja result = codigoFlujoCajaService.activate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(codigoFlujoCajaRepository, times(1)).save(any(CodigoFlujoCaja.class));
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar código de flujo de caja")
    void desactivar_conIdValido_desactivaEntidad() {
        // Arrange
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.of(codigoFlujoCaja));
        when(codigoFlujoCajaRepository.save(any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCaja);

        // Act
        CodigoFlujoCaja result = codigoFlujoCajaService.deactivate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(codigoFlujoCajaRepository, times(1)).save(any(CodigoFlujoCaja.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("delete - Debe eliminar código de flujo de caja")
    void eliminar_conIdValido_eliminaEntidad() {
        // Arrange
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.of(codigoFlujoCaja));
        doNothing().when(codigoFlujoCajaRepository).delete(any(CodigoFlujoCaja.class));

        // Act
        codigoFlujoCajaService.delete(1L);

        // Assert
        verify(codigoFlujoCajaRepository, times(1)).findById(1L);
        verify(codigoFlujoCajaRepository, times(1)).delete(any(CodigoFlujoCaja.class));
    }


    // ==== eliminar — otros ====

    @Test
    @DisplayName("delete - lanza ResourceNotFoundException cuando no existe")
    void eliminar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(codigoFlujoCajaRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> codigoFlujoCajaService.delete(1L)).isInstanceOf(RuntimeException.class);
        verify(codigoFlujoCajaRepository, never()).delete(any(CodigoFlujoCaja.class));
    }
}
