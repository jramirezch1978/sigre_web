package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.Moneda;
import pe.restaurant.core.repository.MonedaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MonedaServiceImplTest {

    @Mock private MonedaRepository repository;
    @InjectMocks private MonedaServiceImpl service;

    private Moneda moneda;

    @BeforeEach
    void setUp() {
        moneda = new Moneda("PEN", "PEN", "Sol Peruano", "S/", 2);
        moneda.setId(1L);
    }

    @Nested class FindAll {
        @Test void returnsPage() {
            var pageable = PageRequest.of(0, 20);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(moneda)));
            assertThat(service.findAll(pageable).getContent()).hasSize(1);
        }
    }

    @Nested class FindById {
        @Test void returnsMoneda() {
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            assertThat(service.findById(1L).getCodigo()).isEqualTo("PEN");
        }
        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Create {
        @Test void createsSuccessfully() {
            when(repository.findByCodigo("PEN")).thenReturn(Optional.empty());
            when(repository.save(moneda)).thenReturn(moneda);
            assertThat(service.create(moneda).getCodigo()).isEqualTo("PEN");
        }
        @Test void throwsOnDuplicate() {
            when(repository.findByCodigo("PEN")).thenReturn(Optional.of(moneda));
            Moneda dup = new Moneda("PEN", "PEN", "Otro", null, 2);
            assertThatThrownBy(() -> service.create(dup)).isInstanceOf(BusinessException.class);
        }
    }

    @Nested class Update {
        @Test void updatesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.findByCodigo("PEN")).thenReturn(Optional.of(moneda));
            when(repository.save(any())).thenReturn(moneda);
            assertThat(service.update(1L, moneda)).isNotNull();
        }
        @Test void throwsOnDuplicateCodeOther() {
            Moneda other = new Moneda("USD", "USD", "Dolar", "$", 2);
            other.setId(2L);
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.findByCodigo("USD")).thenReturn(Optional.of(other));
            Moneda upd = new Moneda("USD", "USD", "test", null, 2);
            assertThatThrownBy(() -> service.update(1L, upd)).isInstanceOf(BusinessException.class);
        }
        @Test void updatesAllFields() {
            Moneda updated = new Moneda("USD", "USD", "Dolar Americano", "$", 2);
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.findByCodigo("USD")).thenReturn(Optional.empty());
            when(repository.save(any())).thenReturn(updated);
            Moneda result = service.update(1L, updated);
            assertThat(result.getCodigo()).isEqualTo("USD");
            verify(repository).save(any());
        }
    }

    @Nested class Activate {
        @Test void activatesSuccessfully() {
            moneda.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            Moneda result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }
        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Deactivate {
        @Test void deactivatesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            Moneda result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class Delete {
        @Test void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            doNothing().when(repository).deleteById(1L);
            service.delete(1L);
            verify(repository).deleteById(1L);
        }
        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested class ValidateUniqueCodigo {
        @Test void allowsWhenCodigoNotFound() {
            when(repository.findByCodigo("EUR")).thenReturn(Optional.empty());
            when(repository.save(any())).thenReturn(moneda);
            Moneda newMoneda = new Moneda("EUR", "EUR", "Euro", null, 2);
            assertThatCode(() -> service.create(newMoneda)).doesNotThrowAnyException();
        }
        @Test void allowsSameEntityId() {
            when(repository.findById(1L)).thenReturn(Optional.of(moneda));
            when(repository.findByCodigo("PEN")).thenReturn(Optional.of(moneda));
            when(repository.save(any())).thenReturn(moneda);
            assertThatCode(() -> service.update(1L, moneda)).doesNotThrowAnyException();
        }
    }
}