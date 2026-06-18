package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.TipoDocIdentidad;
import pe.restaurant.core.repository.TipoDocIdentidadRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TipoDocIdentidadServiceImplTest {

    @Mock private TipoDocIdentidadRepository repository;
    @InjectMocks private TipoDocIdentidadServiceImpl service;

    private TipoDocIdentidad tipoDoc;

    @BeforeEach
    void setUp() {
        tipoDoc = new TipoDocIdentidad("DNI", "Documento Nacional de Identidad");
        tipoDoc.setId(1L);
        tipoDoc.setFlagEstado("0");
    }

    @Nested class FindAll {
        @Test void withFlagEstadoFilters() {
            when(repository.findByFlagEstadoOrderByNombre("1")).thenReturn(List.of(tipoDoc));
            assertThat(service.findAll("1")).hasSize(1);
            verify(repository, never()).findAll();
        }

        @Test void withNullFlagEstadoReturnsAll() {
            when(repository.findAll()).thenReturn(List.of(tipoDoc));
            assertThat(service.findAll(null)).hasSize(1);
            verify(repository, never()).findByFlagEstadoOrderByNombre(any());
        }

        @Test void returnsEmptyList() {
            when(repository.findAll()).thenReturn(Collections.emptyList());
            assertThat(service.findAll(null)).isEmpty();
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("DNI");
        }

        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.findByCodigo("DNI")).thenReturn(Optional.empty());
            when(repository.save(tipoDoc)).thenReturn(tipoDoc);
            assertThat(service.create(tipoDoc).getId()).isEqualTo(1L);
        }

        @Test void duplicateCodigoThrowsConflict() {
            TipoDocIdentidad existing = new TipoDocIdentidad("DNI", "Otro");
            existing.setId(2L);
            when(repository.findByCodigo("DNI")).thenReturn(Optional.of(existing));
            assertThatThrownBy(() -> service.create(tipoDoc))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void sameCodeAlwaysThrowsOnCreate() {
            when(repository.findByCodigo("DNI")).thenReturn(Optional.of(tipoDoc));
            assertThatThrownBy(() -> service.create(tipoDoc))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
            when(repository.findByCodigo("DNI")).thenReturn(Optional.of(tipoDoc));
            when(repository.save(any())).thenReturn(tipoDoc);
            assertThat(service.update(1L, tipoDoc)).isNotNull();
        }

        @Test void notFoundThrows() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, tipoDoc))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test void duplicateCodigoInOtherRecordThrowsConflict() {
            TipoDocIdentidad other = new TipoDocIdentidad("RUC", "RUC");
            other.setId(2L);
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
            when(repository.findByCodigo("RUC")).thenReturn(Optional.of(other));
            TipoDocIdentidad upd = new TipoDocIdentidad("RUC", "RUC update");
            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(BusinessException.class);
        }

        @Test void codigoNotFoundInRepoSucceeds() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
            when(repository.findByCodigo("NEW")).thenReturn(Optional.empty());
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            TipoDocIdentidad upd = new TipoDocIdentidad("NEW", "Nuevo tipo");
            var result = service.update(1L, upd);
            assertThat(result.getCodigo()).isEqualTo("NEW");
        }

        @Test void copiesFieldsFromEntity() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
            when(repository.findByCodigo("CE")).thenReturn(Optional.empty());
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            TipoDocIdentidad upd = new TipoDocIdentidad("CE", "Carnet Extranjeria");
            var result = service.update(1L, upd);
            assertThat(result.getCodigo()).isEqualTo("CE");
            assertThat(result.getNombre()).isEqualTo("Carnet Extranjeria");
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    @Nested class Activate {
        @Test void setsFlagEstadoToOne() {
            tipoDoc.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
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
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
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
            when(repository.findById(1L)).thenReturn(Optional.of(tipoDoc));
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