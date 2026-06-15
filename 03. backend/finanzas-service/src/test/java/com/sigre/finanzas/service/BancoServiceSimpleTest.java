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
import com.sigre.finanzas.entity.Banco;
import com.sigre.finanzas.repository.BancoRepository;
import com.sigre.finanzas.service.impl.BancoServiceImpl;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - BancoService")
class BancoServiceSimpleTest {

    @Mock
    private BancoRepository bancoRepository;

    @InjectMocks
    private BancoServiceImpl bancoService;

    private Banco banco;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        banco = new Banco();
        banco.setId(1L);
        banco.setCodBanco("001");
        banco.setNomBanco("BANCO DE LA NACION");
        banco.setProveedor("BANCO001");
        banco.setSwift("BNANPEPL");
        banco.setCodBancoSunat("01");
        banco.setDireccion("Av. Javier Prado 1234");
        banco.setFlagEstado("1");

        pageable = PageRequest.of(0, 20);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("findAll - Debe retornar página de bancos")
    void listar_retornaPagina() {
        // Arrange
        List<Banco> bancos = List.of(banco);
        Page<Banco> expectedPage = new PageImpl<>(bancos, pageable, bancos.size());

        when(bancoRepository.findAll(pageable)).thenReturn(expectedPage);

        // Act
        Page<Banco> result = bancoService.findAll(pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getContent().size()).isEqualTo(1);
        assertThat(result.getContent().get(0).getCodBanco()).isEqualTo("001");
        assertThat(result.getContent().get(0).getNomBanco()).isEqualTo("BANCO DE LA NACION");

        verify(bancoRepository, times(1)).findAll(pageable);
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("findById - Debe retornar banco cuando existe")
    void obtenerPorId_cuandoExiste_retornaBanco() {
        // Arrange
        when(bancoRepository.findById(1L)).thenReturn(Optional.of(banco));

        // Act
        Banco result = bancoService.findById(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodBanco()).isEqualTo("001");
        assertThat(result.getNomBanco()).isEqualTo("BANCO DE LA NACION");

        verify(bancoRepository, times(1)).findById(1L);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("findById - lanza ResourceNotFoundException cuando no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(bancoRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> {
            bancoService.findById(1L);
        }).isInstanceOf(RuntimeException.class)
          .hasMessage("Recurso 'Banco' con id 1 no encontrado");
        verify(bancoRepository, times(1)).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("create - Debe crear nuevo banco")
    void crear_conDatosValidos_creaBanco() {
        // Arrange
        Banco newBanco = new Banco();
        newBanco.setCodBanco("002");
        newBanco.setNomBanco("BANCO DE CREDITO");
        newBanco.setFlagEstado("1");

        Banco savedBanco = new Banco();
        savedBanco.setId(2L);
        savedBanco.setCodBanco("002");
        savedBanco.setNomBanco("BANCO DE CREDITO");
        savedBanco.setFlagEstado("1");

        when(bancoRepository.save(any(Banco.class))).thenReturn(savedBanco);

        // Act
        Banco result = bancoService.create(newBanco);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(2L);
        assertThat(result.getCodBanco()).isEqualTo("002");
        assertThat(result.getNomBanco()).isEqualTo("BANCO DE CREDITO");
        assertThat(result.getFlagEstado()).isEqualTo("1");

        verify(bancoRepository, times(1)).save(any(Banco.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("update - Debe actualizar banco existente")
    void actualizar_conDatosValidos_actualizaBanco() {
        // Arrange
        Banco updatedBanco = banco;
        updatedBanco.setNomBanco("BANCO DE LA NACION - UPDATED");

        when(bancoRepository.findById(1L)).thenReturn(Optional.of(banco));
        when(bancoRepository.save(any(Banco.class))).thenReturn(updatedBanco);

        // Act
        Banco result = bancoService.update(1L, updatedBanco);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNomBanco()).isEqualTo("BANCO DE LA NACION - UPDATED");

        verify(bancoRepository, times(1)).findById(1L);
        verify(bancoRepository, times(1)).save(any(Banco.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("delete - Debe eliminar banco")
    void eliminar_conIdValido_eliminaBanco() {
        // Arrange
        when(bancoRepository.findById(1L)).thenReturn(Optional.of(banco));
        doNothing().when(bancoRepository).delete(banco);

        // Act
        bancoService.delete(1L);

        // Assert
        verify(bancoRepository, times(1)).findById(1L);
        verify(bancoRepository, times(1)).delete(banco);
    }


    // ==== eliminar — otros ====

    @Test
    @DisplayName("delete - Debe lanzar excepción cuando banco no existe")
    void eliminar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(bancoRepository.findById(1L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> {
            bancoService.delete(1L);
        }).isInstanceOf(RuntimeException.class)
          .hasMessage("Recurso 'Banco' con id 1 no encontrado");
        verify(bancoRepository, times(1)).findById(1L);
        verify(bancoRepository, never()).delete(any());
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar banco")
    void activar_conIdValido_activaBanco() {
        // Arrange
        Banco activatedBanco = banco;
        activatedBanco.setFlagEstado("1");

        when(bancoRepository.findById(1L)).thenReturn(Optional.of(banco));
        when(bancoRepository.save(any(Banco.class))).thenReturn(activatedBanco);

        // Act
        Banco result = bancoService.activate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");

        verify(bancoRepository, times(1)).findById(1L);
        verify(bancoRepository, times(1)).save(any(Banco.class));
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar banco")
    void desactivar_conIdValido_desactivaBanco() {
        // Arrange
        Banco deactivatedBanco = banco;
        deactivatedBanco.setFlagEstado("0");

        when(bancoRepository.findById(1L)).thenReturn(Optional.of(banco));
        when(bancoRepository.save(any(Banco.class))).thenReturn(deactivatedBanco);

        // Act
        Banco result = bancoService.deactivate(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");

        verify(bancoRepository, times(1)).findById(1L);
        verify(bancoRepository, times(1)).save(any(Banco.class));
    }
}
