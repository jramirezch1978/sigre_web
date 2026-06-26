package pe.restaurant.finanzas.service;

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
import pe.restaurant.finanzas.entity.ConceptoFinanciero;
import pe.restaurant.finanzas.repository.ConceptoFinancieroRepository;
import pe.restaurant.finanzas.service.impl.ConceptoFinancieroServiceImpl;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConceptoFinancieroService")
class ConceptoFinancieroServiceTest {

    @Mock
    private ConceptoFinancieroRepository conceptoFinancieroRepository;

    @InjectMocks
    private ConceptoFinancieroServiceImpl conceptoFinancieroService;

    private ConceptoFinanciero conceptoFinanciero;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        // Setup test entity
        conceptoFinanciero = new ConceptoFinanciero();
        conceptoFinanciero.setId(1L);
        conceptoFinanciero.setCodigo("CF001");
        conceptoFinanciero.setNombre("VENTAS CONTADO");
        conceptoFinanciero.setFlagEstado("1");

        // Setup pageable
        pageable = PageRequest.of(0, 10);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("findAll - Debe retornar página de conceptos financieros")
    void listar_conPaginacion_retornaPagina() {
        // Arrange
        Page<ConceptoFinanciero> expectedPage = new PageImpl<>(List.of(conceptoFinanciero), pageable, 1);
        when(conceptoFinancieroRepository.findAll(pageable)).thenReturn(expectedPage);

        // Act
        Page<ConceptoFinanciero> result = conceptoFinancieroService.findAll(pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getCodigo()).isEqualTo("CF001");
        verify(conceptoFinancieroRepository, times(1)).findAll(pageable);
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("findById - Debe retornar concepto financiero cuando existe")
    void obtenerPorId_cuandoExiste_retornaEntidad() {
        // Arrange
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.of(conceptoFinanciero));

        // Act
        ConceptoFinanciero result = conceptoFinancieroService.findById(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("CF001");
        assertThat(result.getNombre()).isEqualTo("VENTAS CONTADO");
        verify(conceptoFinancieroRepository, times(1)).findById(1L);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("findById - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> conceptoFinancieroService.findById(1L)).isInstanceOf(RuntimeException.class);
        verify(conceptoFinancieroRepository, times(1)).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("create - Debe crear concepto financiero exitosamente")
    void crear_conDatosValidos_creaEntidad() {
        // Arrange
        ConceptoFinanciero newConcepto = new ConceptoFinanciero();
        newConcepto.setCodigo("CF002");
        newConcepto.setNombre("VENTAS CREDITO");

        when(conceptoFinancieroRepository.save(any(ConceptoFinanciero.class))).thenReturn(newConcepto);
        when(conceptoFinancieroRepository.existsByCodigoIgnoreCase(anyString())).thenReturn(false);

        // Act
        ConceptoFinanciero result = conceptoFinancieroService.create(newConcepto);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getCodigo()).isEqualTo("CF002");
        assertThat(result.getNombre()).isEqualTo("VENTAS CREDITO");
        verify(conceptoFinancieroRepository, times(1)).save(any(ConceptoFinanciero.class));
    }


    // ==== crear — otros ====

    @Test
    @DisplayName("create - Debe lanzar excepción cuando código ya existe")
    void crear_conCodigoDuplicado_lanzaBusinessException() {
        // Arrange
        ConceptoFinanciero newConcepto = new ConceptoFinanciero();
        newConcepto.setCodigo("CF001");
        newConcepto.setNombre("DUPLICADO");

        when(conceptoFinancieroRepository.existsByCodigoIgnoreCase("CF001")).thenReturn(true);

        // Act & Then
        assertThatThrownBy(() -> conceptoFinancieroService.create(newConcepto)).isInstanceOf(RuntimeException.class);
        verify(conceptoFinancieroRepository, never()).save(any(ConceptoFinanciero.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("update - Debe actualizar concepto financiero exitosamente")
    void actualizar_conDatosValidos_actualizaEntidad() {
        // Arrange
        ConceptoFinanciero updateData = new ConceptoFinanciero();
        updateData.setCodigo("CF003");
        updateData.setNombre("VENTAS ACTUALIZADAS");

        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.of(conceptoFinanciero));
        when(conceptoFinancieroRepository.save(any(ConceptoFinanciero.class))).thenReturn(conceptoFinanciero);
        when(conceptoFinancieroRepository.existsByCodigoIgnoreCaseAndIdNot(anyString(), anyLong())).thenReturn(false);

        // Act
        ConceptoFinanciero result = conceptoFinancieroService.update(1L, updateData);

        // Assert
        assertThat(result).isNotNull();
        verify(conceptoFinancieroRepository, times(1)).findById(1L);
        verify(conceptoFinancieroRepository, times(1)).save(any(ConceptoFinanciero.class));
    }


    // ==== actualizar — otros ====

    @Test
    @DisplayName("update - lanza ResourceNotFoundException cuando no existe")
    void actualizar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        ConceptoFinanciero updateData = new ConceptoFinanciero();
        updateData.setCodigo("CF003");
        updateData.setNombre("NO EXISTE");

        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> conceptoFinancieroService.update(1L, updateData)).isInstanceOf(RuntimeException.class);
        verify(conceptoFinancieroRepository, never()).save(any(ConceptoFinanciero.class));
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar concepto financiero")
    void activar_conIdValido_activaEntidad() {
        // Arrange
        conceptoFinanciero.setFlagEstado("0");
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.of(conceptoFinanciero));
        when(conceptoFinancieroRepository.save(any(ConceptoFinanciero.class))).thenReturn(conceptoFinanciero);

        // Act
        ConceptoFinanciero result = conceptoFinancieroService.activate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(conceptoFinancieroRepository, times(1)).save(any(ConceptoFinanciero.class));
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar concepto financiero")
    void desactivar_conIdValido_desactivaEntidad() {
        // Arrange
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.of(conceptoFinanciero));
        when(conceptoFinancieroRepository.save(any(ConceptoFinanciero.class))).thenReturn(conceptoFinanciero);

        // Act
        ConceptoFinanciero result = conceptoFinancieroService.deactivate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(conceptoFinancieroRepository, times(1)).save(any(ConceptoFinanciero.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("delete - Debe eliminar concepto financiero")
    void eliminar_conIdValido_eliminaEntidad() {
        // Arrange
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.of(conceptoFinanciero));
        doNothing().when(conceptoFinancieroRepository).delete(any(ConceptoFinanciero.class));

        // Act
        conceptoFinancieroService.delete(1L);

        // Assert
        verify(conceptoFinancieroRepository, times(1)).findById(1L);
        verify(conceptoFinancieroRepository, times(1)).delete(any(ConceptoFinanciero.class));
    }


    // ==== eliminar — otros ====

    @Test
    @DisplayName("delete - lanza ResourceNotFoundException cuando no existe")
    void eliminar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(conceptoFinancieroRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> conceptoFinancieroService.delete(1L)).isInstanceOf(RuntimeException.class);
        verify(conceptoFinancieroRepository, never()).delete(any(ConceptoFinanciero.class));
    }
}
