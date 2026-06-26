package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.almacen.entity.ArticuloBonificacion;
import pe.restaurant.almacen.repository.ArticuloBonificacionRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloBonificacionServiceImplTest {

    @Mock
    private ArticuloBonificacionRepository repository;
    @Mock
    private JdbcTemplate jdbcTemplate;
    @InjectMocks
    private ArticuloBonificacionServiceImpl service;

    private ArticuloBonificacion bonificacion;

    @BeforeEach
    void setUp() {
        bonificacion = new ArticuloBonificacion();
        bonificacion.setId(1L);
        bonificacion.setArticuloId(10L);
        bonificacion.setCantidadMinima(new BigDecimal("100.0000"));
        bonificacion.setCantidadBonificacion(new BigDecimal("5.0000"));
        bonificacion.setFechaInicio(LocalDate.of(2026, 1, 1));
        bonificacion.setFechaFin(LocalDate.of(2026, 12, 31));
        bonificacion.setFlagEstado("1");
    }

    @Nested
    @DisplayName("findAll")
    class FindAll {
        @Test
        void conArticuloId_filtra() {
            Page<ArticuloBonificacion> page = new PageImpl<>(List.of(bonificacion));
            when(repository.findByArticuloId(eq(10L), any(Pageable.class))).thenReturn(page);
            var result = service.findAll(10L, PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
            verify(repository).findByArticuloId(eq(10L), any(Pageable.class));
        }

        @Test
        void sinArticuloId_devuelveTodo() {
            Page<ArticuloBonificacion> page = new PageImpl<>(List.of(bonificacion));
            when(repository.findAll(any(Pageable.class))).thenReturn(page);
            var result = service.findAll(null, PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
            verify(repository).findAll(any(Pageable.class));
        }
    }

    @Nested
    @DisplayName("findById")
    class FindById {
        @Test
        void existente_retorna() {
            when(repository.findById(1L)).thenReturn(Optional.of(bonificacion));
            assertThat(service.findById(1L)).isEqualTo(bonificacion);
        }

        @Test
        void noExistente_lanzaExcepcion() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("create")
    class Create {
        @Test
        void ok_creaCorrectamente() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L))).thenReturn(1);
            when(repository.existsByArticuloIdAndCantidadMinima(10L, bonificacion.getCantidadMinima()))
                    .thenReturn(false);
            when(repository.save(any(ArticuloBonificacion.class))).thenReturn(bonificacion);

            var result = service.create(bonificacion);
            assertThat(result.getId()).isEqualTo(1L);
            verify(repository).save(bonificacion);
        }

        @Test
        void articuloNoExiste_lanzaExcepcion() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L))).thenReturn(0);
            assertThatThrownBy(() -> service.create(bonificacion))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void duplicado_lanzaBusinessException() {
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L))).thenReturn(1);
            when(repository.existsByArticuloIdAndCantidadMinima(10L, bonificacion.getCantidadMinima()))
                    .thenReturn(true);
            assertThatThrownBy(() -> service.create(bonificacion))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Ya existe una bonificación");
            verify(repository, never()).save(any());
        }

        @Test
        void fechaFinAnteriorAInicio_lanzaBusinessException() {
            bonificacion.setFechaInicio(LocalDate.of(2026, 6, 1));
            bonificacion.setFechaFin(LocalDate.of(2026, 1, 1));
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L))).thenReturn(1);
            assertThatThrownBy(() -> service.create(bonificacion))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("fecha_fin");
            verify(repository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("update")
    class Update {
        @Test
        void ok_actualizaCorrectamente() {
            when(repository.findById(1L)).thenReturn(Optional.of(bonificacion));
            when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(10L))).thenReturn(1);
            when(repository.existsByArticuloIdAndCantidadMinimaAndIdNot(10L, bonificacion.getCantidadMinima(), 1L))
                    .thenReturn(false);
            when(repository.save(any(ArticuloBonificacion.class))).thenReturn(bonificacion);

            var result = service.update(1L, bonificacion);
            assertThat(result).isNotNull();
            verify(repository).save(any(ArticuloBonificacion.class));
        }

        @Test
        void noExistente_lanzaExcepcion() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, bonificacion))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("delete")
    class Delete {
        @Test
        void ok_eliminaCorrectamente() {
            when(repository.existsById(1L)).thenReturn(true);
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test
        void noExistente_lanzaExcepcion() {
            when(repository.existsById(99L)).thenReturn(false);
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("activate / deactivate")
    class ActivateDeactivate {
        @Test
        void activate_cambiaFlagA1() {
            bonificacion.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(bonificacion));
            when(repository.save(any(ArticuloBonificacion.class))).thenReturn(bonificacion);
            var result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
            verify(repository).save(bonificacion);
        }

        @Test
        void deactivate_cambiaFlagA0() {
            bonificacion.setFlagEstado("1");
            when(repository.findById(1L)).thenReturn(Optional.of(bonificacion));
            when(repository.save(any(ArticuloBonificacion.class))).thenReturn(bonificacion);
            var result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
            verify(repository).save(bonificacion);
        }

        @Test
        void activate_noExistente_lanzaExcepcion() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
