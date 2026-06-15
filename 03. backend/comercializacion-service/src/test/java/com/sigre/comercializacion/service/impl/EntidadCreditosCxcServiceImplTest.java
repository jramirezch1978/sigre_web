package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.EntidadCreditosCxcRequest;
import com.sigre.comercializacion.entity.EntidadCreditosCxc;
import com.sigre.comercializacion.repository.EntidadCreditosCxcRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("EntidadCreditosCxcServiceImpl — Pruebas Unitarias")
class EntidadCreditosCxcServiceImplTest {

    @Mock
    private EntidadCreditosCxcRepository repository;
    @Mock
    private VentasFkValidator fkValidator;
    @InjectMocks
    private EntidadCreditosCxcServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findById ====

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity(1L, "1")));

        EntidadCreditosCxc result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getEntidadContribuyenteId()).isEqualTo(10L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() con filtros -> delega en repository con Specification")
    void findAll_conFiltros_delegaEnRepositorio() {
        when(repository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAll(10L, 1L, "1", Pageable.unpaged()).getContent()).isEmpty();
        verify(repository).findAll(any(Specification.class), eq(Pageable.unpaged()));
    }

    @Test
    @DisplayName("findAll() sin filtros -> retorna pagina vacia")
    void findAll_sinFiltros_retornaPaginaVacia() {
        when(repository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAll(null, null, null, Pageable.unpaged()).getContent()).isEmpty();
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste y retorna con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        EntidadCreditosCxcRequest req = request(10L, 1L, new BigDecimal("5000"), 30);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(repository.existsActiveDuplicate(10L, 1L, null)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            EntidadCreditosCxc e = inv.getArgument(0);
            e.setId(5L);
            return e;
        });

        EntidadCreditosCxc result = service.create(req);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        assertThat(result.getEntidadContribuyenteId()).isEqualTo(10L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con entidad inactiva -> lanza BusinessException")
    void create_cuandoEntidadInactiva_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(99L, 1L, BigDecimal.TEN, 30);
        when(fkValidator.existsEntidadContribuyenteActiva(99L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Entidad contribuyente no válida");
    }

    @Test
    @DisplayName("create() con moneda inactiva -> lanza BusinessException")
    void create_cuandoMonedaInactiva_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(10L, 99L, BigDecimal.TEN, 30);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(99L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Moneda no válida");
    }

    @Test
    @DisplayName("create() con duplicado activo -> lanza BusinessException")
    void create_cuandoDuplicadoActivo_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(10L, 1L, new BigDecimal("100"), 15);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(repository.existsActiveDuplicate(10L, 1L, null)).thenReturn(true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un registro activo");
    }

    @Test
    @DisplayName("create() con limiteCredito negativo -> lanza BusinessException")
    void create_cuandoLimiteNegativo_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(10L, 1L, new BigDecimal("-1"), 30);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("limiteCredito no puede ser negativo");
    }

    @Test
    @DisplayName("create() con diasCredito negativo -> lanza BusinessException")
    void create_cuandoDiasNegativo_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(10L, 1L, BigDecimal.TEN, -1);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("diasCredito no puede ser negativo");
    }

    @Test
    @DisplayName("create() sin usuario en contexto -> lanza BusinessException")
    void create_sinUsuarioEnContexto_lanzaBusinessException() {
        TenantContext.clear();

        assertThatThrownBy(() -> service.create(request(10L, 1L, BigDecimal.TEN, 30)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Usuario no disponible");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        EntidadCreditosCxc existing = entity(5L, "1");
        EntidadCreditosCxcRequest req = request(10L, 2L, new BigDecimal("8000"), 45);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(2L)).thenReturn(true);
        when(repository.existsActiveDuplicate(10L, 2L, 5L)).thenReturn(false);
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        EntidadCreditosCxc result = service.update(5L, req);

        assertThat(result.getMonedaId()).isEqualTo(2L);
        assertThat(result.getLimiteCredito()).isEqualByComparingTo(new BigDecimal("8000"));
        assertThat(result.getDiasCredito()).isEqualTo(45);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(99L, request(10L, 1L, BigDecimal.TEN, 30)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("update() con duplicado excluyendo propio ID -> lanza BusinessException")
    void update_cuandoDuplicado_lanzaBusinessException() {
        EntidadCreditosCxcRequest req = request(10L, 1L, BigDecimal.TEN, 30);
        when(fkValidator.existsEntidadContribuyenteActiva(10L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(repository.existsActiveDuplicate(10L, 1L, 5L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(5L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe otro registro activo");
    }

    // ==== activar / desactivar ====

    @Test
    @DisplayName("activar() con ID existente -> cambia flagEstado a 1")
    void activar_cuandoExiste_cambiaFlagEstado() {
        EntidadCreditosCxc e = entity(3L, "0");
        when(repository.findById(3L)).thenReturn(Optional.of(e));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.activar(3L).getFlagEstado()).isEqualTo("1");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("activar() con ID inexistente -> lanza ResourceNotFoundException")
    void activar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("desactivar() con ID existente -> cambia flagEstado a 0")
    void desactivar_cuandoExiste_cambiaFlagEstado() {
        EntidadCreditosCxc e = entity(4L, "1");
        when(repository.findById(4L)).thenReturn(Optional.of(e));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.desactivar(4L).getFlagEstado()).isEqualTo("0");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> desactiva (setea flagEstado 0)")
    void delete_cuandoExiste_desactivaEntidad() {
        EntidadCreditosCxc e = entity(6L, "1");
        when(repository.findById(6L)).thenReturn(Optional.of(e));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.delete(6L);

        assertThat(e.getFlagEstado()).isEqualTo("0");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== helpers ====

    private static EntidadCreditosCxcRequest request(Long entidadId, Long monedaId, BigDecimal limite, int dias) {
        return EntidadCreditosCxcRequest.builder()
                .entidadContribuyenteId(entidadId)
                .monedaId(monedaId)
                .limiteCredito(limite)
                .diasCredito(dias)
                .build();
    }

    private static EntidadCreditosCxc entity(Long id, String flag) {
        EntidadCreditosCxc e = new EntidadCreditosCxc();
        e.setId(id);
        e.setEntidadContribuyenteId(10L);
        e.setMonedaId(1L);
        e.setLimiteCredito(new BigDecimal("1000"));
        e.setDiasCredito(30);
        e.setFlagEstado(flag);
        return e;
    }
}
