package com.sigre.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.ParametroSistema;
import com.sigre.core.repository.ParametroSistemaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ParametroSistemaServiceImplTest {

    @Mock private ParametroSistemaRepository repository;
    @InjectMocks private ParametroSistemaServiceImpl service;

    private ParametroSistema parametro;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        parametro = new ParametroSistema("IGV_TASA", "Tasa IGV", "CONTABILIDAD", "18", "DECIMAL");
        parametro.setId(1L);
    }

    @SuppressWarnings("unchecked")
    @Nested
    class FindAll {
        @Test
        void noFilters() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(parametro)));
            assertThat(service.findAll(null, null, pageable).getContent()).hasSize(1);
        }

        @Test
        void filterByCodigo() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(parametro)));
            assertThat(service.findAll("IGV", null, pageable).getContent()).hasSize(1);
        }

        @Test
        void filterByModulo() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(parametro)));
            assertThat(service.findAll(null, "CONTABILIDAD", pageable).getContent()).hasSize(1);
        }

        @Test
        void filterByBoth() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(parametro)));
            assertThat(service.findAll("IGV", "CONTABILIDAD", pageable).getContent()).hasSize(1);
        }

        @Test
        void emptyStringFilters() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(parametro)));
            assertThat(service.findAll("", "  ", pageable).getContent()).hasSize(1);
        }
    }

    @Nested
    class FindById {
        @Test
        void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("IGV_TASA");
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test
        void success() {
            when(repository.findByCodigo("IGV_TASA")).thenReturn(Optional.empty());
            when(repository.save(parametro)).thenReturn(parametro);
            assertThat(service.create(parametro)).isNotNull();
        }

        @Test
        void duplicateCodigo() {
            when(repository.findByCodigo("IGV_TASA")).thenReturn(Optional.of(parametro));
            ParametroSistema dup = new ParametroSistema("IGV_TASA", "Otro", null, null, null);
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }

        @Test
        void noDuplicate_whenCodigoNotInRepo() {
            ParametroSistema newParam = new ParametroSistema("NUEVO_COD", "Nuevo", "MOD", "val", "STRING");
            when(repository.findByCodigo("NUEVO_COD")).thenReturn(Optional.empty());
            when(repository.save(newParam)).thenReturn(newParam);
            assertThat(service.create(newParam)).isNotNull();
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.findByCodigo("IGV_TASA")).thenReturn(Optional.of(parametro));
            when(repository.save(any())).thenReturn(parametro);
            assertThat(service.update(1L, parametro)).isNotNull();
        }

        @Test
        void duplicateCodigoOther() {
            ParametroSistema other = new ParametroSistema("OTRO", "Otro", null, null, null);
            other.setId(2L);
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.findByCodigo("OTRO")).thenReturn(Optional.of(other));
            ParametroSistema upd = new ParametroSistema("OTRO", "test", null, null, null);
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, parametro)).isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void noDuplicateWhenCodigoNotInRepo() {
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.findByCodigo("NEW_CODE")).thenReturn(Optional.empty());
            when(repository.save(any())).thenReturn(parametro);
            ParametroSistema upd = new ParametroSistema("NEW_CODE", "Nuevo", "M", "V", "STRING");
            assertThat(service.update(1L, upd)).isNotNull();
        }
    }

    @Nested
    class Delete {
        @Test
        void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test
        void setsActivoTrue() {
            parametro.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.save(any())).thenReturn(parametro);
            var result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test
        void setsActivoFalse() {
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.save(any())).thenReturn(parametro);
            service.deactivate(1L);
            assertThat(parametro.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class UpdateBatch {
        @Test
        void updatesMultiple() {
            ParametroSistema p1 = new ParametroSistema("IGV_TASA", "Tasa IGV", "CONTABILIDAD", "18", "DECIMAL");
            p1.setId(1L);
            ParametroSistema p2 = new ParametroSistema("RET_TASA", "Tasa Ret", "CONTABILIDAD", "3", "DECIMAL");
            p2.setId(2L);
            when(repository.findById(1L)).thenReturn(Optional.of(parametro));
            when(repository.findById(2L)).thenReturn(Optional.of(p2));
            when(repository.findByCodigo("IGV_TASA")).thenReturn(Optional.of(parametro));
            when(repository.findByCodigo("RET_TASA")).thenReturn(Optional.of(p2));
            when(repository.save(any())).thenAnswer(i -> i.getArgument(0));

            var results = service.updateBatch(List.of(p1, p2));
            assertThat(results).hasSize(2);
            verify(repository, times(2)).save(any());
        }

        @Test
        void emptyList() {
            var results = service.updateBatch(List.of());
            assertThat(results).isEmpty();
        }
    }
}