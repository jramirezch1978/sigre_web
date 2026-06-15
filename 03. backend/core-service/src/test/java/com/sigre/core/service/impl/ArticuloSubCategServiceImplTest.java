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
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.ArticuloCateg;
import com.sigre.core.entity.ArticuloSubCateg;
import com.sigre.core.repository.ArticuloCategRepository;
import com.sigre.core.repository.ArticuloSubCategRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloSubCategServiceImplTest {

    @Mock private ArticuloSubCategRepository repository;
    @Mock private ArticuloCategRepository articuloCategRepository;
    @InjectMocks private ArticuloSubCategServiceImpl service;

    private ArticuloSubCateg subCateg;

    @BeforeEach
    void setUp() {
        subCateg = new ArticuloSubCateg("SC01", "Sub categoría uno", 100L);
        subCateg.setId(1L);
    }

    @Nested class FindAll {
        @Test void returnsPagedResults() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(subCateg)));
            assertThat(service.findAll(pageable).getContent()).hasSize(1);
        }

        @Test void returnsEmptyPage() {
            var pageable = PageRequest.of(0, 10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(Collections.emptyList()));
            assertThat(service.findAll(pageable).getContent()).isEmpty();
        }
    }

    @Nested class FindByCategoria {
        @Test void returnsList() {
            when(repository.findByArticuloCategId(100L)).thenReturn(List.of(subCateg));
            assertThat(service.findByCategoria(100L)).hasSize(1);
        }

        @Test void returnsEmptyList() {
            when(repository.findByArticuloCategId(999L)).thenReturn(Collections.emptyList());
            assertThat(service.findByCategoria(999L)).isEmpty();
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
            assertThat(service.findById(1L).getCodSubCat()).isEqualTo("SC01");
        }

        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            ArticuloCateg categ = new ArticuloCateg("CAT01", "Cat");
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.of(categ));
            when(repository.existsByCodSubCatIgnoreCase("SC01")).thenReturn(false);
            when(repository.save(subCateg)).thenReturn(subCateg);
            assertThat(service.create(subCateg).getId()).isEqualTo(1L);
        }

        @Test void categNotFoundThrows() {
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.create(subCateg))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateCodSubCatThrowsConflict() {
            ArticuloCateg categ = new ArticuloCateg("CAT01", "Cat");
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.of(categ));
            when(repository.existsByCodSubCatIgnoreCase("SC01")).thenReturn(true);
            assertThatThrownBy(() -> service.create(subCateg))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            ArticuloCateg categ = new ArticuloCateg("CAT01", "Cat");
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.of(categ));
            when(repository.existsByCodSubCatIgnoreCaseAndIdNot("SC01", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(subCateg);
            assertThat(service.update(1L, subCateg)).isNotNull();
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, subCateg))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void categNotFoundThrows() {
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
            ArticuloSubCateg upd = new ArticuloSubCateg("SC01", "Desc", 999L);
            when(articuloCategRepository.findById(999L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateCodSubCatInOtherRecordThrowsConflict() {
            ArticuloCateg categ = new ArticuloCateg("CAT01", "Cat");
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.of(categ));
            when(repository.existsByCodSubCatIgnoreCaseAndIdNot("DUP", 1L)).thenReturn(true);
            ArticuloSubCateg upd = new ArticuloSubCateg("DUP", "Dup", 100L);
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void setsIdFromPath() {
            ArticuloCateg categ = new ArticuloCateg("CAT01", "Cat");
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
            when(articuloCategRepository.findById(100L)).thenReturn(Optional.of(categ));
            when(repository.existsByCodSubCatIgnoreCaseAndIdNot("NEW", 1L)).thenReturn(false);
            ArticuloSubCateg upd = new ArticuloSubCateg("NEW", "Nueva", 100L);
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            assertThat(service.update(1L, upd).getId()).isEqualTo(1L);
        }
    }

    @Nested class Activate {
        @Test void setsFlagEstadoToOne() {
            subCateg.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
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
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
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
            when(repository.findById(1L)).thenReturn(Optional.of(subCateg));
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