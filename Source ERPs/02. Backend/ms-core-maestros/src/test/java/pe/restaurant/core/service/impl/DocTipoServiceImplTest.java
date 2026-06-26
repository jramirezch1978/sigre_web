package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.DocTipo;
import pe.restaurant.core.repository.DocTipoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DocTipoServiceImplTest {

    @Mock private DocTipoRepository repository;
    @InjectMocks private DocTipoServiceImpl service;

    private DocTipo docTipo;

    @BeforeEach
    void setUp() {
        docTipo = new DocTipo();
        docTipo.setId(1L);
        docTipo.setCodigo("FAC");
        docTipo.setNombre("Factura");
        docTipo.setSunatCodigo("01");
        docTipo.setFlagEstado("1");
    }

    @Nested class FindAll {
        @Test void returnsList() {
            when(repository.findAll()).thenReturn(List.of(docTipo));
            assertThat(service.findAll()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void found() {
            when(repository.findById(1L)).thenReturn(Optional.of(docTipo));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("FAC");
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class FindByCodigo {
        @Test void found() {
            when(repository.findByCodigo("FAC")).thenReturn(Optional.of(docTipo));
            assertThat(service.findByCodigo("FAC").getNombre()).isEqualTo("Factura");
        }
        @Test void notFound() {
            when(repository.findByCodigo("XXX")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findByCodigo("XXX")).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void success() {
            when(repository.save(docTipo)).thenReturn(docTipo);
            assertThat(service.create(docTipo)).isNotNull();
        }
    }

    @Nested class Update {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(docTipo));
            when(repository.save(any())).thenReturn(docTipo);
            assertThat(service.update(1L, docTipo)).isNotNull();
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, docTipo)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(docTipo));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }
        @Test void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
