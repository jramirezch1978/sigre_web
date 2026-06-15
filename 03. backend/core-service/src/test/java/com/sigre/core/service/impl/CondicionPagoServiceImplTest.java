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
import com.sigre.core.dto.CondicionPagoRequest;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.entity.CondicionPago;
import com.sigre.core.mapper.CondicionPagoMapper;
import com.sigre.core.repository.CondicionPagoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CondicionPagoServiceImplTest {

    @Mock private CondicionPagoRepository repository;
    @Mock private CondicionPagoMapper mapper;
    @InjectMocks private CondicionPagoServiceImpl service;

    private CondicionPago entity;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        entity = new CondicionPago("CONTADO", "Contado", 0);
    }

    @Nested
    class ListMethod {
        @Test
        void returnsPage() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @Test
        void returnsEmptyPage() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of()));
            var result = service.list(pageable);
            assertThat(result.getContent()).isEmpty();
        }
    }

    @Nested
    class GetById {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            CondicionPagoResponse resp = new CondicionPagoResponse();
            resp.setId(1L);
            resp.setCodigo("CONTADO");
            when(mapper.toResponse(entity)).thenReturn(resp);

            var result = service.getById(1L);
            assertThat(result.getCodigo()).isEqualTo("CONTADO");
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
            CondicionPagoRequest request = new CondicionPagoRequest("CRED30", "Credito 30", 30, "1");
            when(repository.existsByCodigoIgnoreCase("CRED30")).thenReturn(false);
            CondicionPago newEntity = new CondicionPago("CRED30", "Credito 30", 30);
            when(mapper.toEntity(request)).thenReturn(newEntity);
            when(repository.save(newEntity)).thenReturn(newEntity);
            CondicionPagoResponse resp = new CondicionPagoResponse();
            resp.setId(2L);
            when(mapper.toResponse(newEntity)).thenReturn(resp);

            var result = service.create(request);
            assertThat(result.getId()).isEqualTo(2L);
        }

        @Test
        void throwsConflictWhenDuplicateCodigo() {
            CondicionPagoRequest request = new CondicionPagoRequest("CONTADO", "Contado Dup", 0, "1");
            when(repository.existsByCodigoIgnoreCase("CONTADO")).thenReturn(true);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            CondicionPagoRequest request = new CondicionPagoRequest("CONTADO", "Contado Updated", 0, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("CONTADO", 1L)).thenReturn(false);
            when(repository.save(entity)).thenReturn(entity);
            CondicionPagoResponse resp = new CondicionPagoResponse();
            resp.setId(1L);
            when(mapper.toResponse(entity)).thenReturn(resp);

            var result = service.update(1L, request);
            assertThat(result.getId()).isEqualTo(1L);
            verify(mapper).updateEntity(request, entity);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, new CondicionPagoRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsConflictWhenDuplicateCodigo() {
            CondicionPagoRequest request = new CondicionPagoRequest("CRED30", "Cred", 30, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("CRED30", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.update(1L, request))
                    .isInstanceOf(BusinessException.class);
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
