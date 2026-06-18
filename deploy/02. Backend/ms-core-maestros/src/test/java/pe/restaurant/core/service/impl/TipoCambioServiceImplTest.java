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
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.TipoCambio;
import pe.restaurant.core.repository.MonedaRepository;
import pe.restaurant.core.repository.TipoCambioRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TipoCambioServiceImplTest {

    @Mock private TipoCambioRepository repository;
    @Mock private MonedaRepository monedaRepository;
    @InjectMocks private TipoCambioServiceImpl service;

    private TipoCambio tipoCambio;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        tipoCambio = new TipoCambio();
        tipoCambio.setId(1L);
        tipoCambio.setMonedaId(1L);
        tipoCambio.setFecha(LocalDate.of(2026, 4, 8));
        tipoCambio.setCompra(new BigDecimal("3.750000"));
        tipoCambio.setVenta(new BigDecimal("3.780000"));
    }

    @Nested
    class FindAll {
        @SuppressWarnings("unchecked")
        @Test void withNoFilters() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(tipoCambio)));
            var result = service.findAll(null, null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test void withAllFilters() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(tipoCambio)));
            var result = service.findAll(1L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31), pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test void withPartialFilters_monedaId() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(tipoCambio)));
            var result = service.findAll(1L, null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test void withPartialFilters_fechaDesde() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(tipoCambio)));
            var result = service.findAll(null, LocalDate.of(2026, 1, 1), null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test void withPartialFilters_fechaHasta() {
            when(repository.findAll(any(Specification.class), eq(pageable)))
                    .thenReturn(new PageImpl<>(List.of(tipoCambio)));
            var result = service.findAll(null, null, LocalDate.of(2026, 12, 31), pageable);
            assertThat(result.getContent()).hasSize(1);
        }
    }

    @Nested
    class FindByFecha {
        @Test void returnsWhenExists() {
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.of(tipoCambio));
            assertThat(service.findByFecha(LocalDate.of(2026, 4, 8), 1L)).isNotNull();
        }

        @Test void throwsWhenNotFound() {
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findByFecha(LocalDate.of(2026, 4, 8), 1L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test void createsSuccessfully() {
            when(monedaRepository.existsById(1L)).thenReturn(true);
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.empty());
            when(repository.save(tipoCambio)).thenReturn(tipoCambio);
            assertThat(service.create(tipoCambio)).isNotNull();
        }

        @Test void throwsOnDuplicate() {
            when(monedaRepository.existsById(1L)).thenReturn(true);
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.of(tipoCambio));

            TipoCambio nuevo = new TipoCambio();
            nuevo.setMonedaId(1L);
            nuevo.setFecha(LocalDate.of(2026, 4, 8));
            nuevo.setCompra(BigDecimal.ONE);
            nuevo.setVenta(BigDecimal.ONE);

            assertThatThrownBy(() -> service.create(nuevo)).isInstanceOf(BusinessException.class);
        }

        @Test void throwsOnInvalidMoneda() {
            when(monedaRepository.existsById(99L)).thenReturn(false);
            TipoCambio tc = new TipoCambio();
            tc.setMonedaId(99L);
            tc.setFecha(LocalDate.now());
            assertThatThrownBy(() -> service.create(tc))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class FindById {
        @Test void returnsWhenExists() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoCambio));
            assertThat(service.findById(1L)).isEqualTo(tipoCambio);
        }

        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Update {
        @Test void updatesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoCambio));
            when(monedaRepository.existsById(1L)).thenReturn(true);
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.empty());
            when(repository.save(any(TipoCambio.class))).thenReturn(tipoCambio);

            TipoCambio updated = new TipoCambio();
            updated.setMonedaId(1L);
            updated.setFecha(LocalDate.of(2026, 4, 9));
            updated.setCompra(new BigDecimal("3.800000"));
            updated.setVenta(new BigDecimal("3.830000"));

            assertThat(service.update(1L, updated)).isNotNull();
            verify(repository).save(any(TipoCambio.class));
        }

        @Test void throwsOnDuplicateDateMoneda() {
            TipoCambio existing = new TipoCambio();
            existing.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(monedaRepository.existsById(1L)).thenReturn(true);

            TipoCambio other = new TipoCambio();
            other.setId(2L);
            when(repository.findByFechaAndMonedaId(any(), eq(1L)))
                    .thenReturn(Optional.of(other));

            TipoCambio updated = new TipoCambio();
            updated.setMonedaId(1L);
            updated.setFecha(LocalDate.of(2026, 4, 8));
            updated.setCompra(BigDecimal.ONE);
            updated.setVenta(BigDecimal.ONE);

            assertThatThrownBy(() -> service.update(1L, updated))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested
    class Delete {
        @Test void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipoCambio));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test void activatesSuccessfully() {
            tipoCambio.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(tipoCambio));
            when(repository.save(any(TipoCambio.class))).thenReturn(tipoCambio);

            TipoCambio result = service.activate(1L);

            assertThat(result.getFlagEstado()).isEqualTo("1");
            verify(repository).save(tipoCambio);
        }

        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test void deactivatesSuccessfully() {
            tipoCambio.setFlagEstado("1");
            when(repository.findById(1L)).thenReturn(Optional.of(tipoCambio));
            when(repository.save(any(TipoCambio.class))).thenReturn(tipoCambio);

            TipoCambio result = service.deactivate(1L);

            assertThat(result.getFlagEstado()).isEqualTo("0");
            verify(repository).save(tipoCambio);
        }

        @Test void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
