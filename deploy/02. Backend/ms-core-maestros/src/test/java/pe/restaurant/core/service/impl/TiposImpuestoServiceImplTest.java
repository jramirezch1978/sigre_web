package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.TiposImpuesto;
import pe.restaurant.core.repository.TiposImpuestoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TiposImpuestoServiceImplTest {

    @Mock private TiposImpuestoRepository repository;
    @Mock private JdbcTemplate jdbcTemplate;
    @InjectMocks private TiposImpuestoServiceImpl service;

    private TiposImpuesto impuesto;

    @BeforeEach
    void setUp() {
        impuesto = new TiposImpuesto();
        impuesto.setId(1L);
        impuesto.setTipoImpuesto("IGV");
        impuesto.setDescImpuesto("Impuesto General a las Ventas");
    }

    @Nested class FindAll {
        @Test void returnsList() {
            when(repository.findAll()).thenReturn(List.of(impuesto));
            assertThat(service.findAll()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            assertThat(service.findById(1L).getTipoImpuesto()).isEqualTo("IGV");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class FindByTipoImpuesto {
        @Test void found() {
            when(repository.findByTipoImpuesto("IGV")).thenReturn(Optional.of(impuesto));
            assertThat(service.findByTipoImpuesto("IGV")).isNotNull();
        }
        @Test void notFound() {
            when(repository.findByTipoImpuesto("XXX")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findByTipoImpuesto("XXX")).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.save(impuesto)).thenReturn(impuesto);
            assertThat(service.create(impuesto)).isNotNull();
            verifyNoInteractions(jdbcTemplate);
        }

        @Test void successConPlanContableDetActivo() {
            impuesto.setPlanContableDetId(10L);
            when(jdbcTemplate.query(
                    eq(TiposImpuestoServiceImpl.SQL_PLAN_CONTABLE_DET_FLAG),
                    ArgumentMatchers.<RowMapper<String>>any(),
                    eq(10L)))
                    .thenReturn(List.of("1"));
            when(repository.save(impuesto)).thenReturn(impuesto);
            assertThat(service.create(impuesto)).isNotNull();
        }

        @Test void rechazaPlanContableDetInexistente() {
            impuesto.setPlanContableDetId(99L);
            when(jdbcTemplate.query(
                    eq(TiposImpuestoServiceImpl.SQL_PLAN_CONTABLE_DET_FLAG),
                    ArgumentMatchers.<RowMapper<String>>any(),
                    eq(99L)))
                    .thenReturn(List.of());
            assertThatThrownBy(() -> service.create(impuesto)).isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }

        @Test void rechazaPlanContableDetInactivo() {
            impuesto.setPlanContableDetId(10L);
            when(jdbcTemplate.query(
                    eq(TiposImpuestoServiceImpl.SQL_PLAN_CONTABLE_DET_FLAG),
                    ArgumentMatchers.<RowMapper<String>>any(),
                    eq(10L)))
                    .thenReturn(List.of("0"));
            assertThatThrownBy(() -> service.create(impuesto)).isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.update(1L, impuesto)).isNotNull();
            verifyNoInteractions(jdbcTemplate);
        }

        @Test void successConPlanContableDetActivo() {
            var incoming = new TiposImpuesto();
            incoming.setId(1L);
            incoming.setTipoImpuesto("IGV");
            incoming.setDescImpuesto("Impuesto General a las Ventas");
            incoming.setPlanContableDetId(10L);
            when(jdbcTemplate.query(
                    eq(TiposImpuestoServiceImpl.SQL_PLAN_CONTABLE_DET_FLAG),
                    ArgumentMatchers.<RowMapper<String>>any(),
                    eq(10L)))
                    .thenReturn(List.of("1"));
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.update(1L, incoming)).isNotNull();
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, impuesto)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
