package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ReservacionCancelRequest;
import pe.restaurant.ventas.dto.request.ReservacionRequest;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.entity.Reservacion;
import pe.restaurant.ventas.repository.ArticuloRepository;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.ReservacionRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Tests completos de Branch Coverage para ReservacionServiceImpl
 * Objetivo: Cubrir 34 branches para +3.2% de coverage total
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ReservacionServiceImplCompleteTest {

    @Mock
    private ReservacionRepository repository;

    @Mock
    private VentasFkValidator fkValidator;

    @Mock
    private MesaRepository mesaRepository;

    @Mock
    private ArticuloRepository articuloRepository;

    @InjectMocks
    private ReservacionServiceImpl service;

    private ReservacionRequest request;

    @BeforeEach
    void setUp() {
        request = new ReservacionRequest();
        request.setSucursalId(1L);
        request.setClienteId(1L);
        request.setMesaId(1L);
        request.setFecha(LocalDate.now().plusDays(1));
        request.setHora(LocalTime.of(19, 0));
        request.setComensales(4);
        request.setObservaciones("Test");
    }

    // ==================== TESTS PARA CONFIRMAR ====================

    @Test
    void confirmar_conReservacionCancelada_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Reservacion reservacion = new Reservacion();
            reservacion.setId(1L);
            reservacion.setEstado("CANCELADA");

            when(repository.findDetailById(1L)).thenReturn(Optional.of(reservacion));

            // When & Then
            assertThatThrownBy(() -> service.confirmar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("No se puede confirmar una reservación cancelada");
        }
    }

    @Test
    void confirmar_conReservacionConfirmada_actualizaEstado() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Reservacion reservacion = new Reservacion();
            reservacion.setId(1L);
            reservacion.setEstado("PENDIENTE");

            when(repository.findDetailById(1L)).thenReturn(Optional.of(reservacion));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.confirmar(1L);

            // Then
            assertThat(result.getEstado()).isEqualTo("CONFIRMADA");
            assertThat(result.getUpdatedBy()).isEqualTo(1L);
        }
    }

    // ==================== TESTS PARA CANCELAR ====================

    @Test
    void cancelar_conRequestNull_estableceMotivoNull() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Reservacion reservacion = new Reservacion();
            reservacion.setId(1L);
            reservacion.setEstado("CONFIRMADA");

            when(repository.findDetailById(1L)).thenReturn(Optional.of(reservacion));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.cancelar(1L, null);

            // Then
            assertThat(result.getEstado()).isEqualTo("CANCELADA");
            assertThat(result.getMotivoCancelacion()).isNull();
        }
    }

    @Test
    void cancelar_conRequestConMotivo_estableceMotivo() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Reservacion reservacion = new Reservacion();
            reservacion.setId(1L);
            reservacion.setEstado("CONFIRMADA");

            ReservacionCancelRequest cancelRequest = new ReservacionCancelRequest();
            cancelRequest.setMotivo("Cliente canceló");

            when(repository.findDetailById(1L)).thenReturn(Optional.of(reservacion));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.cancelar(1L, cancelRequest);

            // Then
            assertThat(result.getEstado()).isEqualTo("CANCELADA");
            assertThat(result.getMotivoCancelacion()).isEqualTo("Cliente canceló");
        }
    }

    @Test
    void cancelar_conReservacionNoConfirmada_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Reservacion reservacion = new Reservacion();
            reservacion.setId(1L);
            reservacion.setEstado("CANCELADA");

            when(repository.findDetailById(1L)).thenReturn(Optional.of(reservacion));

            // When & Then
            assertThatThrownBy(() -> service.cancelar(1L, null))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Solo se permite en estado CONFIRMADA");
        }
    }

    // ==================== TESTS PARA APPLY CABECERA ====================

    @Test
    void create_conSucursalIdNull_usaTenantContext() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            mockedContext.when(TenantContext::getSucursalId).thenReturn(5L);
            
            request.setSucursalId(null);

            when(fkValidator.existsSucursalActiva(5L)).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(createMesa(10)));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result.getSucursalId()).isEqualTo(5L);
        }
    }

    @Test
    void create_conSucursalIdInvalida_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            when(fkValidator.existsSucursalActiva(1L)).thenReturn(false);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Sucursal no válida");
        }
    }

    @Test
    void create_conClienteIdInvalido_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(1L)).thenReturn(false);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Cliente no válido");
        }
    }

    @Test
    void create_conMesaIdInvalida_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(1L)).thenReturn(false);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Mesa no válida");
        }
    }

    @Test
    void create_conFsFacturaSimplIdInvalida_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setFsFacturaSimplId(999L);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsFsFacturaSimplNoAnulada(999L)).thenReturn(false);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Comprobante simplificado no válido o anulado");
        }
    }

    @Test
    void create_conItemsConArticuloInvalido_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            ReservacionRequest.ReservacionItemRequest item = new ReservacionRequest.ReservacionItemRequest();
            item.setArticuloId(999L);
            item.setCantidad(java.math.BigDecimal.valueOf(2));
            request.setItems(java.util.List.of(item));

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(articuloRepository.existsByIdAndFlagEstado(999L, "1")).thenReturn(false);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Artículo no válido");
        }
    }

    @Test
    void create_conItemsValidos_creaReservacionConItems() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            ReservacionRequest.ReservacionItemRequest item = new ReservacionRequest.ReservacionItemRequest();
            item.setArticuloId(1L);
            item.setCantidad(java.math.BigDecimal.valueOf(2));
            item.setObservacion("Sin cebolla");
            request.setItems(java.util.List.of(item));

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(articuloRepository.existsByIdAndFlagEstado(1L, "1")).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(createMesa(10)));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result.getItems()).hasSize(1);
            assertThat(result.getItems().get(0).getArticuloId()).isEqualTo(1L);
            assertThat(result.getItems().get(0).getCantidad()).isEqualTo(java.math.BigDecimal.valueOf(2));
        }
    }

    // ==================== TESTS PARA VALIDAR FECHA HORA ====================

    @Test
    void create_conFechaEnPasado_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setFecha(LocalDate.now().minusDays(1));
            request.setHora(LocalTime.of(12, 0));

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("fecha y hora de reservación no pueden estar en el pasado");
        }
    }

    // ==================== TESTS PARA VALIDAR SOLAPE MESA ====================

    @Test
    void create_conMesaIdNull_noValidaSolape() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setMesaId(null);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result).isNotNull();
            verify(repository, never()).countSolapeMesaFechaHora(anyLong(), any(), any(), any());
        }
    }

    @Test
    void create_conMesaOcupada_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(1L);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Ya existe una reservación confirmada para la misma mesa");
        }
    }

    // ==================== TESTS PARA VALIDAR CAPACIDAD MESA ====================

    @Test
    void create_conMesaIdNull_noValidaCapacidad() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setMesaId(null);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result).isNotNull();
            verify(mesaRepository, never()).findById(anyLong());
        }
    }

    @Test
    void create_conComensalesNull_noValidaCapacidad() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setComensales(null);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result).isNotNull();
            verify(mesaRepository, never()).findById(anyLong());
        }
    }

    @Test
    void create_conMesaNoEncontrada_noLanzaExcepcion() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(mesaRepository.findById(anyLong())).thenReturn(Optional.empty());
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result).isNotNull();
        }
    }

    @Test
    void create_conMesaSinCapacidad_noLanzaExcepcion() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            Mesa mesa = new Mesa();
            mesa.setId(1L);
            mesa.setCapacidad(null);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(mesa));
            when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

            // When
            Reservacion result = service.create(request);

            // Then
            assertThat(result).isNotNull();
        }
    }

    @Test
    void create_conComensalesSuperanCapacidad_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(1L);
            
            request.setComensales(10);

            when(fkValidator.existsSucursalActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsEntidadContribuyenteActiva(anyLong())).thenReturn(true);
            when(fkValidator.existsMesaActiva(anyLong())).thenReturn(true);
            when(repository.countSolapeMesaFechaHora(anyLong(), any(), any(), any())).thenReturn(0L);
            when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(createMesa(4)));

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Los comensales superan la capacidad de la mesa");
        }
    }

    // ==================== TESTS PARA REQUIRE USUARIO ====================

    @Test
    void create_sinUsuarioEnContexto_lanzaBusinessException() {
        try (MockedStatic<TenantContext> mockedContext = mockStatic(TenantContext.class)) {
            // Given
            mockedContext.when(TenantContext::getUsuarioId).thenReturn(null);

            // When & Then
            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Usuario no disponible en el contexto");
        }
    }

    // ==================== TESTS PARA GET BY ID ====================

    @Test
    void getById_conIdInexistente_lanzaResourceNotFoundException() {
        // Given
        when(repository.findDetailById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> service.getById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ==================== MÉTODOS AUXILIARES ====================

    private Mesa createMesa(int capacidad) {
        Mesa mesa = new Mesa();
        mesa.setId(1L);
        mesa.setCapacidad(capacidad);
        return mesa;
    }
}
