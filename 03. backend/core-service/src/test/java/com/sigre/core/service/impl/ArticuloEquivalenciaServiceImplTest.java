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
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.ArticuloEquivalencia;
import com.sigre.core.repository.ArticuloEquivalenciaRepository;
import com.sigre.core.repository.ArticuloRepository;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloEquivalenciaServiceImplTest {

    @Mock private ArticuloEquivalenciaRepository repository;
    @Mock private ArticuloRepository articuloRepository;
    @InjectMocks private ArticuloEquivalenciaServiceImpl service;

    private ArticuloEquivalencia equiv;

    @BeforeEach
    void setUp() {
        equiv = new ArticuloEquivalencia();
        equiv.setId(1L);
        equiv.setArticuloId(10L);
        equiv.setArticuloEquivalenteId(20L);
        equiv.setFactor(new BigDecimal("2.5"));
        equiv.setFlagEstado("1");
    }

    @Nested class FindAll {
        @Test void withArticuloIdFilters() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findByArticuloId(10L, pageable))
                    .thenReturn(new PageImpl<>(List.of(equiv)));
            assertThat(service.findAll(10L, pageable).getContent()).hasSize(1);
            verify(repository, never()).findAll(any(Pageable.class));
        }

        @Test void withoutArticuloIdReturnsAll() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable))
                    .thenReturn(new PageImpl<>(List.of(equiv)));
            assertThat(service.findAll(null, pageable).getContent()).hasSize(1);
            verify(repository, never()).findByArticuloId(any(), any());
        }

        @Test void emptyResultReturnsEmptyPage() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable))
                    .thenReturn(new PageImpl<>(Collections.emptyList()));
            assertThat(service.findAll(null, pageable).getContent()).isEmpty();
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            assertThat(service.findById(1L).getArticuloId()).isEqualTo(10L);
        }

        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(20L)).thenReturn(true);
            when(repository.existsByArticuloIdAndArticuloEquivalenteId(10L, 20L)).thenReturn(false);
            when(repository.save(equiv)).thenReturn(equiv);
            assertThat(service.create(equiv).getId()).isEqualTo(1L);
        }

        @Test void sameArticuloThrowsValidationError() {
            equiv.setArticuloEquivalenteId(10L);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void nullFactorThrowsValidationError() {
            equiv.setFactor(null);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void zeroFactorThrowsValidationError() {
            equiv.setFactor(BigDecimal.ZERO);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void negativeFactorThrowsValidationError() {
            equiv.setFactor(new BigDecimal("-1"));
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void articuloIdNotFoundThrows() {
            when(articuloRepository.existsById(10L)).thenReturn(false);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void articuloEquivalenteIdNotFoundThrows() {
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(20L)).thenReturn(false);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateEquivalenciaThrowsConflict() {
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(20L)).thenReturn(true);
            when(repository.existsByArticuloIdAndArticuloEquivalenteId(10L, 20L)).thenReturn(true);
            assertThatThrownBy(() -> service.create(equiv))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void successSamePair() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(20L)).thenReturn(true);
            when(repository.save(any())).thenReturn(equiv);

            ArticuloEquivalencia upd = new ArticuloEquivalencia();
            upd.setArticuloId(10L);
            upd.setArticuloEquivalenteId(20L);
            upd.setFactor(new BigDecimal("3.0"));

            var result = service.update(1L, upd);
            assertThat(result).isNotNull();
            verify(repository, never()).existsByArticuloIdAndArticuloEquivalenteId(any(), any());
        }

        @Test void successChangedPairNoDuplicate() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(30L)).thenReturn(true);
            when(repository.existsByArticuloIdAndArticuloEquivalenteId(10L, 30L)).thenReturn(false);
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            ArticuloEquivalencia upd = new ArticuloEquivalencia();
            upd.setArticuloId(10L);
            upd.setArticuloEquivalenteId(30L);
            upd.setFactor(new BigDecimal("5.0"));

            var result = service.update(1L, upd);
            assertThat(result.getArticuloEquivalenteId()).isEqualTo(30L);
        }

        @Test void changedPairDuplicateThrowsConflict() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            when(articuloRepository.existsById(10L)).thenReturn(true);
            when(articuloRepository.existsById(30L)).thenReturn(true);
            when(repository.existsByArticuloIdAndArticuloEquivalenteId(10L, 30L)).thenReturn(true);

            ArticuloEquivalencia upd = new ArticuloEquivalencia();
            upd.setArticuloId(10L);
            upd.setArticuloEquivalenteId(30L);
            upd.setFactor(new BigDecimal("1.0"));

            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, equiv))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void sameArticuloInUpdateThrowsValidation() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            ArticuloEquivalencia upd = new ArticuloEquivalencia();
            upd.setArticuloId(10L);
            upd.setArticuloEquivalenteId(10L);
            upd.setFactor(BigDecimal.ONE);
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Activate {
        @Test void setsFlagEstadoToOne() {
            equiv.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.activate(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsFlagEstadoToZero() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.deactivate(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void deletesExistingEntity() {
            when(repository.findById(1L)).thenReturn(Optional.of(equiv));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
