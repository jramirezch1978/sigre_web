package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
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
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.PropinaRequest;
import com.sigre.comercializacion.entity.Propina;
import com.sigre.comercializacion.repository.FsFacturaSimplRepository;
import com.sigre.comercializacion.repository.PropinaRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PropinaServiceImpl — Branch Coverage")
class PropinaServiceImplTest {

    @Mock
    private PropinaRepository repository;
    @Mock
    private FsFacturaSimplRepository facturaRepository;
    @Mock
    private VentasFkValidator fkValidator;
    @InjectMocks
    private PropinaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @SuppressWarnings("SameParameterValue")
    private static PropinaRequest requestValido() {
        PropinaRequest r = new PropinaRequest();
        r.setFsFacturaSimplId(10L);
        r.setMonto(new BigDecimal("5.00"));
        r.setFecha(LocalDate.now());
        return r;
    }

    @SuppressWarnings("SameParameterValue")
    private static Propina propinaPersistida(Long id) {
        Propina p = new Propina();
        p.setId(id);
        p.setFsFacturaSimplId(10L);
        p.setMonto(new BigDecimal("5.00"));
        p.setFecha(LocalDate.now());
        p.setFlagEstado("1");
        p.setCreatedBy(1L);
        return p;
    }

    @Test
    @DisplayName("findAll: sin filtros delega al repositorio y retorna página")
    void findAll_sinFiltros_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Propina> expectedPage = new PageImpl<>(List.of(propinaPersistida(1L)));
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);

        Page<Propina> result = service.findAll(null, null, null, null, null, pageable);

        assertThat(result).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("findById: cuando existe retorna la entidad")
    void findById_cuandoExiste_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(propinaPersistida(1L)));

        Propina result = service.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("findById: cuando no existe lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Propina")
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("create: con datos válidos persiste y retorna la entidad")
    void create_conDatosValidos_retornaCreado() {
        PropinaRequest req = requestValido();
        req.setTrabajadorId(20L);
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(true);
        when(fkValidator.existsTrabajadorActivo(20L)).thenReturn(true);
        when(repository.save(any(Propina.class))).thenAnswer(inv -> {
            Propina p = inv.getArgument(0);
            p.setId(88L);
            return p;
        });

        Propina result = service.create(req);

        assertThat(result.getId()).isEqualTo(88L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("create: cuando factura no existe o está anulada lanza BusinessException")
    void create_cuandoFacturaNoExiste_lanzaBusinessException() {
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(requestValido()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("factura simplificada no existe o está anulada");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("create: cuando trabajador no está activo lanza BusinessException")
    void create_cuandoTrabajadorNoActivo_lanzaBusinessException() {
        PropinaRequest req = requestValido();
        req.setTrabajadorId(20L);
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(true);
        when(fkValidator.existsTrabajadorActivo(20L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Trabajador no válido o inactivo");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("create: cuando trabajadorId es null omite validación de FK")
    void create_cuandoTrabajadorEsNull_noValidaFk() {
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(true);
        when(repository.save(any(Propina.class))).thenAnswer(inv -> inv.getArgument(0));

        service.create(requestValido());

        verify(fkValidator, never()).existsTrabajadorActivo(any());
    }

    @Test
    @DisplayName("create: cuando fecha es futura lanza BusinessException")
    void create_cuandoFechaFutura_lanzaBusinessException() {
        PropinaRequest req = requestValido();
        req.setFecha(LocalDate.now().plusDays(1));
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha de propina no puede ser futura");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("create: cuando no hay usuario en contexto lanza BusinessException")
    void create_cuandoUsuarioNoDisponible_lanzaBusinessException() {
        TenantContext.clear();

        assertThatThrownBy(() -> service.create(requestValido()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Usuario no disponible");

        verify(facturaRepository, never()).existsByIdAndNotAnulada(any());
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("update: con datos válidos actualiza y retorna la entidad")
    void update_conDatosValidos_retornaActualizado() {
        Propina existing = propinaPersistida(1L);
        PropinaRequest req = requestValido();
        req.setTrabajadorId(20L);
        req.setMonto(new BigDecimal("10.00"));
        req.setFecha(LocalDate.now().minusDays(1));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(true);
        when(fkValidator.existsTrabajadorActivo(20L)).thenReturn(true);
        when(repository.save(any(Propina.class))).thenAnswer(inv -> inv.getArgument(0));

        Propina result = service.update(1L, req);

        assertThat(result.getMonto()).isEqualByComparingTo(new BigDecimal("10.00"));
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("update: cuando id no existe lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(99L, requestValido()))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Propina");

        verify(facturaRepository, never()).existsByIdAndNotAnulada(any());
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("update: cuando factura no existe lanza BusinessException")
    void update_cuandoFacturaNoExiste_lanzaBusinessException() {
        Propina existing = propinaPersistida(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(facturaRepository.existsByIdAndNotAnulada(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.update(1L, requestValido()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("factura simplificada");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("activar: cuando existe cambia flagEstado a 1")
    void activar_cuandoExiste_cambiaFlagEstado() {
        Propina p = propinaPersistida(1L);
        p.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(p));
        when(repository.save(any(Propina.class))).thenAnswer(inv -> inv.getArgument(0));

        Propina result = service.activar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("activar: cuando no existe lanza ResourceNotFoundException")
    void activar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Propina");

        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("desactivar: cuando existe cambia flagEstado a 0")
    void desactivar_cuandoExiste_cambiaFlagEstado() {
        Propina p = propinaPersistida(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(p));
        when(repository.save(any(Propina.class))).thenAnswer(inv -> inv.getArgument(0));

        Propina result = service.desactivar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("desactivar: cuando no existe lanza ResourceNotFoundException")
    void desactivar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Propina");

        verify(repository, never()).save(any());
    }
}
