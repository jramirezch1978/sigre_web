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
import org.springframework.lang.NonNull;
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.client.AuthSecurityClient;
import com.sigre.finanzas.dto.response.UsuarioResponse;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.entity.AutorizadorGiro;
import com.sigre.finanzas.mapper.AutorizadorGiroMapper;
import com.sigre.finanzas.repository.AutorizadorGiroRepository;
import com.sigre.finanzas.service.impl.AutorizadorGiroServiceImpl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - AutorizadorGiroService")
class AutorizadorGiroServiceSimpleTest {

    @Mock
    private AutorizadorGiroRepository autorizadorGiroRepository;

    @Mock
    private AutorizadorGiroMapper autorizadorGiroMapper;

    @Mock
    private AuthSecurityClient authSecurityClient;

    @InjectMocks
    private AutorizadorGiroServiceImpl autorizadorGiroService;

    private AutorizadorGiro autorizadorGiro;
    private AutorizadorGiroResponse autorizadorGiroResponse;
    private AutorizadorGiroRequest autorizadorGiroRequest;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        // Setup mock for AuthSecurityClient (lenient para evitar UnnecessaryStubbingException)
        UsuarioResponse usuarioResponse = new UsuarioResponse();
        usuarioResponse.setId(1L);
        usuarioResponse.setNombres("Test User");
        usuarioResponse.setFlagEstado("1"); // Usuario activo
        
        lenient().when(authSecurityClient.obtenerUsuarioPorId(anyLong()))
                .thenReturn(ApiResponse.ok(usuarioResponse));
        
        // Setup test entity
        autorizadorGiro = new AutorizadorGiro();
        autorizadorGiro.setId(1L);
        autorizadorGiro.setCentrosCostoId(124L);
        autorizadorGiro.setUsuarioId(6L);
        autorizadorGiro.setActivo(true);

        // Setup test response
        autorizadorGiroResponse = new AutorizadorGiroResponse();
        autorizadorGiroResponse.setId(1L);
        autorizadorGiroResponse.setCentrosCostoId(124L);
        autorizadorGiroResponse.setUsuarioId(6L);
        autorizadorGiroResponse.setActivo(true);

        // Setup test request
        autorizadorGiroRequest = new AutorizadorGiroRequest();
        autorizadorGiroRequest.setCentrosCostoId(124L);
        autorizadorGiroRequest.setActivo(true);

        pageable = PageRequest.of(0, 20);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("findAll - Debe retornar página de autorizadores de giro")
    void listar_retornaPagina() {
        // Arrange
        List<AutorizadorGiro> autorizadores = List.of(autorizadorGiro);
        Page<AutorizadorGiro> entityPage = new PageImpl<>(autorizadores, pageable, autorizadores.size());

        when(autorizadorGiroRepository.findAll(pageable)).thenReturn(entityPage);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        Page<AutorizadorGiroResponse> result = autorizadorGiroService.findAll(pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getContent().size()).isEqualTo(1);
        assertThat(result.getContent().get(0).getCentrosCostoId()).isEqualTo(124L);

        verify(autorizadorGiroRepository, times(1)).findAll(pageable);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("findById - Debe retornar autorizador por ID cuando existe")
    void obtenerPorId_cuandoExiste_retornaAutorizador() {
        // Arrange
        when(autorizadorGiroRepository.findById(1L)).thenReturn(Optional.of(autorizadorGiro));
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        AutorizadorGiroResponse result = autorizadorGiroService.findById(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCentrosCostoId()).isEqualTo(124L);

        verify(autorizadorGiroRepository, times(1)).findById(1L);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("findById - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(autorizadorGiroRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> {
            autorizadorGiroService.findById(1L);
        }).isInstanceOf(RuntimeException.class)
          .hasMessage("Recurso 'Autorizador de giro' con id 1 no encontrado");
        verify(autorizadorGiroRepository, times(1)).findById(1L);
        verify(autorizadorGiroMapper, never()).toResponse(any());
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("create - Debe crear nuevo autorizador de giro")
    void crear_conDatosValidos_creaAutorizador() {
        // Arrange
        AutorizadorGiro savedEntity = new AutorizadorGiro();
        savedEntity.setId(1L);
        savedEntity.setCentrosCostoId(124L);
        savedEntity.setUsuarioId(6L);
        savedEntity.setActivo(true);

        when(autorizadorGiroMapper.toEntity(autorizadorGiroRequest)).thenReturn(autorizadorGiro);
        when(autorizadorGiroRepository.save(autorizadorGiro)).thenReturn(savedEntity);
        when(autorizadorGiroMapper.toResponse(savedEntity)).thenReturn(autorizadorGiroResponse);

        // Act
        AutorizadorGiroResponse result = autorizadorGiroService.create(autorizadorGiroRequest);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCentrosCostoId()).isEqualTo(124L);

        verify(autorizadorGiroMapper, times(1)).toEntity(autorizadorGiroRequest);
        verify(autorizadorGiroRepository, times(1)).save(autorizadorGiro);
        verify(autorizadorGiroMapper, times(1)).toResponse(savedEntity);
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("update - Debe actualizar autorizador existente")
    void actualizar_conDatosValidos_actualizaAutorizador() {
        // Arrange
        AutorizadorGiroRequest updateRequest = new AutorizadorGiroRequest();
        updateRequest.setCentrosCostoId(200L);
        updateRequest.setActivo(false);

        when(autorizadorGiroRepository.findById(1L)).thenReturn(Optional.of(autorizadorGiro));
        when(autorizadorGiroRepository.save(autorizadorGiro)).thenReturn(autorizadorGiro);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        AutorizadorGiroResponse result = autorizadorGiroService.update(1L, updateRequest);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);

        verify(autorizadorGiroRepository, times(1)).findById(1L);
        verify(autorizadorGiroMapper, times(1)).updateEntity(updateRequest, autorizadorGiro);
        verify(autorizadorGiroRepository, times(1)).save(autorizadorGiro);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("deleteById - Debe eliminar autorizador")
    void eliminar_conIdValido_eliminaAutorizador() {
        // Arrange
        when(autorizadorGiroRepository.existsById(1L)).thenReturn(true);

        // Act
        autorizadorGiroService.deleteById(1L);

        // Assert
        verify(autorizadorGiroRepository, times(1)).existsById(1L);
        verify(autorizadorGiroRepository, times(1)).deleteById(1L);
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar autorizador")
    void activar_conIdValido_activaAutorizador() {
        // Arrange
        autorizadorGiro.setActivo(false);
        when(autorizadorGiroRepository.findById(1L)).thenReturn(Optional.of(autorizadorGiro));
        when(autorizadorGiroRepository.save(autorizadorGiro)).thenReturn(autorizadorGiro);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        AutorizadorGiroResponse result = autorizadorGiroService.activate(1L);

        // Assert
        assertThat(result).isNotNull();
        verify(autorizadorGiroRepository, times(1)).findById(1L);
        verify(autorizadorGiroRepository, times(1)).save(autorizadorGiro);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar autorizador")
    void desactivar_conIdValido_desactivaAutorizador() {
        // Arrange
        autorizadorGiro.setActivo(true);
        when(autorizadorGiroRepository.findById(1L)).thenReturn(Optional.of(autorizadorGiro));
        when(autorizadorGiroRepository.save(autorizadorGiro)).thenReturn(autorizadorGiro);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        AutorizadorGiroResponse result = autorizadorGiroService.deactivate(1L);

        // Assert
        assertThat(result).isNotNull();
        verify(autorizadorGiroRepository, times(1)).findById(1L);
        verify(autorizadorGiroRepository, times(1)).save(autorizadorGiro);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== findByCentroCosto — escenarios felices ====

    @Test
    @DisplayName("findByCentroCosto - Debe retornar autorizadores por centro de costo")
    void findByCentroCosto_cuandoExiste_retornaAutorizadores() {
        // Arrange
        List<AutorizadorGiro> autorizadores = List.of(autorizadorGiro);
        when(autorizadorGiroRepository.findByCentrosCostoIdAndActivo(124L, true)).thenReturn(autorizadores);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        List<AutorizadorGiroResponse> result = autorizadorGiroService.findByCentroCosto(124L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.size()).isEqualTo(1);
        assertThat(result.get(0).getCentrosCostoId()).isEqualTo(124L);

        verify(autorizadorGiroRepository, times(1)).findByCentrosCostoIdAndActivo(124L, true);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }


    // ==== findActivosByCentroCosto — escenarios felices ====

    @Test
    @DisplayName("findActivosByCentroCosto - Debe retornar autorizadores activos por centro de costo")
    void findActivosByCentroCosto_cuandoExiste_retornaActivos() {
        // Arrange
        List<AutorizadorGiro> autorizadores = List.of(autorizadorGiro);
        when(autorizadorGiroRepository.findAutorizadoresActivosPorCentroCosto(124L)).thenReturn(autorizadores);
        when(autorizadorGiroMapper.toResponse(autorizadorGiro)).thenReturn(autorizadorGiroResponse);

        // Act
        List<AutorizadorGiroResponse> result = autorizadorGiroService.findActivosByCentroCosto(124L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.size()).isEqualTo(1);
        assertThat(result.get(0).getActivo()).isTrue();

        verify(autorizadorGiroRepository, times(1)).findAutorizadoresActivosPorCentroCosto(124L);
        verify(autorizadorGiroMapper, times(1)).toResponse(autorizadorGiro);
    }

}
