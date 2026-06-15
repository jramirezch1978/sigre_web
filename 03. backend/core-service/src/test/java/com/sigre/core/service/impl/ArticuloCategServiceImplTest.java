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
import com.sigre.core.entity.ArticuloCateg;
import com.sigre.core.repository.ArticuloCategRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloCategServiceImplTest {

    @Mock private ArticuloCategRepository repository;
    @InjectMocks private ArticuloCategServiceImpl service;

    private ArticuloCateg categ;

    @BeforeEach
    void setUp() {
        categ = new ArticuloCateg("CAT01", "Categoría uno");
        categ.setId(1L);
    }

    @Nested class FindAll {
        @Test void returnsPagedResults() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(categ)));
            var result = service.findAll(pageable);
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getCatArt()).isEqualTo("CAT01");
        }

        @Test void returnsEmptyPage() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(Collections.emptyList()));
            assertThat(service.findAll(pageable).getContent()).isEmpty();
        }

        @Test void unpagedReturnsAll() {
            when(repository.findAll(Pageable.unpaged())).thenReturn(new PageImpl<>(List.of(categ)));
            assertThat(service.findAll(Pageable.unpaged()).getTotalElements()).isEqualTo(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            assertThat(service.findById(1L).getCatArt()).isEqualTo("CAT01");
        }

        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.existsByCatArtIgnoreCase("CAT01")).thenReturn(false);
            when(repository.save(categ)).thenReturn(categ);
            assertThat(service.create(categ).getId()).isEqualTo(1L);
        }

        @Test void duplicateCatArtThrowsConflict() {
            when(repository.existsByCatArtIgnoreCase("CAT01")).thenReturn(true);
            assertThatThrownBy(() -> service.create(categ))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            when(repository.existsByCatArtIgnoreCaseAndIdNot("CAT01", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(categ);
            var result = service.update(1L, categ);
            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, categ))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateCatArtInOtherRecordThrowsConflict() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            when(repository.existsByCatArtIgnoreCaseAndIdNot("CAT02", 1L)).thenReturn(true);
            ArticuloCateg upd = new ArticuloCateg("CAT02", "Otra");
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void setsIdFromPath() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            when(repository.existsByCatArtIgnoreCaseAndIdNot("NEW", 1L)).thenReturn(false);
            ArticuloCateg upd = new ArticuloCateg("NEW", "Nueva");
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            var result = service.update(1L, upd);
            assertThat(result.getId()).isEqualTo(1L);
        }
    }

    @Nested class Activate {
        @Test void setsFlagEstadoToOne() {
            categ.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            var result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Deactivate {
        @Test void setsFlagEstadoToZero() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            var result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void deletesExistingEntity() {
            when(repository.findById(1L)).thenReturn(Optional.of(categ));
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