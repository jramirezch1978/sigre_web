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
import org.springframework.http.HttpStatus;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.dto.DetraccionRequest;
import com.sigre.core.dto.DetraccionResponse;
import com.sigre.core.entity.Detraccion;
import com.sigre.core.mapper.DetraccionMapper;
import com.sigre.core.repository.DetraccionRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DetraccionServiceImplTest {

    @Mock private DetraccionRepository repository;
    @Mock private DetraccionMapper mapper;
    @InjectMocks private DetraccionServiceImpl service;

    private Detraccion entity;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        entity = new Detraccion("001", "Servicios", "02", BigDecimal.valueOf(12), "1", 22001L, BigDecimal.ZERO);
    }

    @Nested
    class ListMethod {
        @Test
        void returnsPage() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(pageable);
            assertThat(result.getContent()).hasSize(1);
        }
    }

    @Nested
    class GetById {
        @Test
        void success() {
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            DetraccionResponse resp = new DetraccionResponse();
            resp.setBienServ("001");
            when(mapper.toResponse(entity)).thenReturn(resp);

            var result = service.getById("001");
            assertThat(result.getBienServ()).isEqualTo("001");
        }

        @Test
        void throwsNotFound() {
            when(repository.findByBienServ("999")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.getById("999"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void normalizesInput() {
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            DetraccionResponse resp = new DetraccionResponse();
            when(mapper.toResponse(entity)).thenReturn(resp);

            service.getById(" 001 ");
            verify(repository).findByBienServ("001");
        }
    }

    @Nested
    class Create {
        @Test
        void success() {
            DetraccionRequest request = new DetraccionRequest("002", "Bienes", null, "03", BigDecimal.TEN, "1", 22002L, BigDecimal.ZERO);
            when(repository.existsByBienServ("002")).thenReturn(false);
            when(mapper.toEntity(request)).thenReturn(new Detraccion());
            when(repository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(mapper.toResponse(any())).thenReturn(new DetraccionResponse());

            var result = service.create(request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsConflict() {
            DetraccionRequest request = new DetraccionRequest("001", "Dup", "1", "02", BigDecimal.ONE, "1", 22001L, BigDecimal.ZERO);
            when(repository.existsByBienServ("001")).thenReturn(true);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> assertThat(((BusinessException) ex).getStatus()).isEqualTo(HttpStatus.CONFLICT));
        }

        @Test
        void throwsWhenBienServNull() {
            DetraccionRequest request = new DetraccionRequest(null, "X", null, null, null, null, null, BigDecimal.ZERO);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("obligatorio");
        }

        @Test
        void throwsWhenBienServBlank() {
            DetraccionRequest request = new DetraccionRequest("  ", "X", null, null, null, null, null, BigDecimal.ZERO);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("obligatorio");
        }

        @Test
        void appliesDefaultFlagEstado() {
            DetraccionRequest request = new DetraccionRequest("003", "Test", null, null, null, null, null, null);
            Detraccion newEntity = new Detraccion();
            when(repository.existsByBienServ("003")).thenReturn(false);
            when(mapper.toEntity(request)).thenReturn(newEntity);
            when(repository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(mapper.toResponse(any())).thenReturn(new DetraccionResponse());

            service.create(request);
            verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
        }

        @Test
        void appliesDefaultMontoMinDepre() {
            DetraccionRequest request = new DetraccionRequest("003", "Test", "1", null, null, null, null, null);
            Detraccion newEntity = new Detraccion();
            newEntity.setFlagEstado("1");
            when(repository.existsByBienServ("003")).thenReturn(false);
            when(mapper.toEntity(request)).thenReturn(newEntity);
            when(repository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(mapper.toResponse(any())).thenReturn(new DetraccionResponse());

            service.create(request);
            verify(repository).save(argThat(e -> BigDecimal.ZERO.equals(e.getMontoMinDepre())));
        }

        @Test
        void normalizesToUpperCase() {
            DetraccionRequest request = new DetraccionRequest("abc", "Test", "1", null, null, null, null, BigDecimal.ZERO);
            when(repository.existsByBienServ("ABC")).thenReturn(false);
            Detraccion newEntity = new Detraccion();
            newEntity.setFlagEstado("1");
            newEntity.setMontoMinDepre(BigDecimal.ZERO);
            when(mapper.toEntity(request)).thenReturn(newEntity);
            when(repository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(mapper.toResponse(any())).thenReturn(new DetraccionResponse());

            service.create(request);
            verify(repository).save(argThat(e -> "ABC".equals(e.getBienServ())));
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            DetraccionRequest request = new DetraccionRequest("001", "Updated", "1", "02", BigDecimal.TEN, "1", 22001L, BigDecimal.ZERO);
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new DetraccionResponse());

            var result = service.update("001", request);
            assertThat(result).isNotNull();
            verify(mapper).updateEntity(request, entity);
        }

        @Test
        void throwsWhenBienServChanged() {
            DetraccionRequest request = new DetraccionRequest("002", "Changed", null, null, null, null, null, BigDecimal.ZERO);
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));

            assertThatThrownBy(() -> service.update("001", request))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> assertThat(((BusinessException) ex).getStatus()).isEqualTo(HttpStatus.BAD_REQUEST));
        }

        @Test
        void throwsNotFound() {
            when(repository.findByBienServ("999")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update("999", new DetraccionRequest()))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void allowsNullBienServInRequest() {
            DetraccionRequest request = new DetraccionRequest(null, "Updated", "1", null, null, null, null, BigDecimal.ZERO);
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new DetraccionResponse());

            var result = service.update("001", request);
            assertThat(result).isNotNull();
        }

        @Test
        void sameBienServAllowed() {
            DetraccionRequest request = new DetraccionRequest("001", "Same", "1", null, null, null, null, BigDecimal.ZERO);
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new DetraccionResponse());

            var result = service.update("001", request);
            assertThat(result).isNotNull();
        }
    }

    @Nested
    class Delete {
        @Test
        void deletesSuccessfully() {
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            service.delete("001");
            verify(repository).delete(entity);
        }

        @Test
        void throwsNotFound() {
            when(repository.findByBienServ("999")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete("999"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test
        void setsEstadoTo1() {
            entity.setFlagEstado("0");
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.activate("001");
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsNotFound() {
            when(repository.findByBienServ("999")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate("999"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test
        void setsEstadoTo0() {
            when(repository.findByBienServ("001")).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.deactivate("001");
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsNotFound() {
            when(repository.findByBienServ("999")).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate("999"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
