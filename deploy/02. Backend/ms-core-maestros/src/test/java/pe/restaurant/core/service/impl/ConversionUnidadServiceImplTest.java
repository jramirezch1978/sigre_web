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
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.entity.ConversionUnidad;
import pe.restaurant.core.mapper.ConversionUnidadMapper;
import pe.restaurant.core.repository.ConversionUnidadRepository;
import pe.restaurant.core.repository.UnidadMedidaRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConversionUnidadServiceImplTest {

    @Mock private ConversionUnidadRepository repository;
    @Mock private UnidadMedidaRepository unidadMedidaRepository;
    @Mock private ConversionUnidadMapper mapper;

    @InjectMocks private ConversionUnidadServiceImpl service;

    private ConversionUnidad entity;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        entity = new ConversionUnidad(1L, 2L, BigDecimal.TEN, 5L);
    }

    @Nested
    class ListMethod {
        @Test
        void returnsPage() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(5L, null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @Test
        void returnsPageNoFilters() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }
    }

    @Nested
    class GetById {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ConversionUnidadResponse resp = new ConversionUnidadResponse(1L, 5L, 1L, 2L, BigDecimal.TEN, "1");
            when(mapper.toResponse(entity)).thenReturn(resp);

            var result = service.getById(1L);
            assertThat(result.getArticuloId()).isEqualTo(5L);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.getById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test
        void success() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(9L, 1L, 2L, BigDecimal.TEN);
            ConversionUnidad newEntity = new ConversionUnidad(1L, 2L, BigDecimal.TEN, null);
            ConversionUnidad saved = new ConversionUnidad(1L, 2L, BigDecimal.TEN, 9L);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(unidadMedidaRepository.existsById(2L)).thenReturn(true);
            when(mapper.toEntity(request)).thenReturn(newEntity);
            when(repository.save(newEntity)).thenReturn(saved);
            when(mapper.toResponse(saved)).thenReturn(new ConversionUnidadResponse(1L, 9L, 1L, 2L, BigDecimal.TEN, "1"));

            var result = service.create(request);
            assertThat(result.getArticuloId()).isEqualTo(9L);
        }

        @Test
        void throwsWhenUmOrigenNotFound() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(1L, 99L, 2L, BigDecimal.ONE);
            when(unidadMedidaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenUmDestinoNotFound() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(1L, 1L, 99L, BigDecimal.ONE);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(unidadMedidaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(5L, 1L, 3L, BigDecimal.valueOf(5));
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(unidadMedidaRepository.existsById(3L)).thenReturn(true);
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new ConversionUnidadResponse());

            var result = service.update(1L, request);
            assertThat(result).isNotNull();
            verify(mapper).updateEntity(request, entity);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, new ConversionUnidadRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenUmOrigenNotFound() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(5L, 99L, 2L, BigDecimal.ONE);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(unidadMedidaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenUmDestinoNotFound() {
            ConversionUnidadRequest request = new ConversionUnidadRequest(5L, 1L, 99L, BigDecimal.ONE);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(unidadMedidaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Delete {
        @Test
        void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test
        void setsEstadoTo1() {
            entity.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test
        void setsEstadoTo0() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
