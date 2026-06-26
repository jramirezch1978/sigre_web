package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfTraslado;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfTrasladoRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfTrasladoServiceImplTest {

    @Mock
    private AfTrasladoRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfUbicacionRepository ubicacionRepository;
    @Mock
    private AfHistorialService historialService;
    @InjectMocks
    private AfTrasladoServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfTraslado entity = new AfTraslado();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(2L);
        entity.setMotivo("Traslado de oficina");
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfTraslado> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfTraslado entity = new AfTraslado();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(2L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfTraslado result = service.findById(1L);
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfTraslado entity = new AfTraslado();
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(2L);
        entity.setMotivo("Traslado de oficina");

        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        maestro.setFlagEstado("1");

        AfUbicacion origen = new AfUbicacion();
        origen.setId(1L);

        AfUbicacion destino = new AfUbicacion();
        destino.setId(2L);

        AfTraslado saved = new AfTraslado();
        saved.setId(1L);
        saved.setAfMaestroId(1L);
        saved.setUbicacionOrigenId(1L);
        saved.setUbicacionDestinoId(2L);
        saved.setMotivo("Traslado de oficina");
        saved.setFechaSolicitud(LocalDate.now());

        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(ubicacionRepository.findById(1L)).thenReturn(Optional.of(origen));
        when(ubicacionRepository.findById(2L)).thenReturn(Optional.of(destino));
        when(repository.save(any(AfTraslado.class))).thenReturn(saved);
        AfTraslado result = service.create(entity);
        assertEquals(LocalDate.now(), result.getFechaSolicitud());
        assertEquals(1L, result.getId());
    }

    @Test
    void createThrowsNotFoundWhenActivoNotExists() {
        AfTraslado entity = new AfTraslado();
        entity.setAfMaestroId(999L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(2L);

        when(maestroRepository.findById(999L)).thenReturn(Optional.empty());

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.MAESTRO_NO_ENCONTRADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("999"));
    }

    @Test
    void createThrowsNotFoundWhenUbicacionOrigenNotExists() {
        AfTraslado entity = new AfTraslado();
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(999L);
        entity.setUbicacionDestinoId(2L);

        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        maestro.setFlagEstado("1");

        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(ubicacionRepository.findById(999L)).thenReturn(Optional.empty());

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.UBICACION_NO_ENCONTRADA, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("999"));
    }

    @Test
    void createThrowsNotFoundWhenUbicacionDestinoNotExists() {
        AfTraslado entity = new AfTraslado();
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(999L);

        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        maestro.setFlagEstado("1");

        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(ubicacionRepository.findById(1L)).thenReturn(Optional.of(new AfUbicacion()));
        when(ubicacionRepository.findById(999L)).thenReturn(Optional.empty());

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.UBICACION_NO_ENCONTRADA, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("999"));
    }

    @Test
    void createThrowsConflictWhenUbicacionesIguales() {
        AfTraslado entity = new AfTraslado();
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(1L);

        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        maestro.setFlagEstado("1");

        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.UBICACIONES_IGUALES, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("misma"));
    }

    @Test
    void updateModifiesEntity() {
        AfTraslado existing = new AfTraslado();
        existing.setId(1L);
        existing.setAfMaestroId(1L);
        existing.setUbicacionOrigenId(1L);
        existing.setUbicacionDestinoId(2L);
        existing.setMotivo("Motivo original");
        AfTraslado updateData = new AfTraslado();
        updateData.setUbicacionOrigenId(1L);
        updateData.setUbicacionDestinoId(3L);
        updateData.setMotivo("Motivo actualizado");

        AfTraslado updated = new AfTraslado();
        updated.setId(1L);
        updated.setAfMaestroId(1L);
        updated.setUbicacionOrigenId(1L);
        updated.setUbicacionDestinoId(3L);
        updated.setMotivo("Motivo actualizado");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(ubicacionRepository.findById(1L)).thenReturn(Optional.of(new AfUbicacion()));
        when(ubicacionRepository.findById(3L)).thenReturn(Optional.of(new AfUbicacion()));
        when(repository.save(any(AfTraslado.class))).thenReturn(updated);

        AfTraslado result = service.update(1L, updateData);
        assertEquals("Motivo actualizado", result.getMotivo());
        assertEquals(3L, result.getUbicacionDestinoId());
    }

    @Test
    void deleteRemovesEntity() {
        AfTraslado entity = new AfTraslado();
        entity.setId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void findByActivoReturnsList() {
        AfTraslado entity1 = new AfTraslado();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);

        AfTraslado entity2 = new AfTraslado();
        entity2.setId(2L);
        entity2.setAfMaestroId(1L);

        when(repository.findByAfMaestroId(1L)).thenReturn(List.of(entity1, entity2));
        List<AfTraslado> result = service.findByActivo(1L);
        assertEquals(2, result.size());
        assertEquals(1L, result.get(0).getAfMaestroId());
        assertEquals(1L, result.get(1).getAfMaestroId());
    }

    @Test
    void ejecutarSavesTraslado() {
        AfTraslado entity = new AfTraslado();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setUbicacionDestinoId(2L);
        AfMaestro activo = new AfMaestro();
        activo.setId(1L);
        activo.setAfUbicacionId(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
        when(maestroRepository.save(any(AfMaestro.class))).thenReturn(activo);
        when(repository.save(any(AfTraslado.class))).thenAnswer(invocation -> invocation.getArgument(0));

        AfTraslado result = service.ejecutar(1L);
        assertNotNull(result);
        assertEquals(LocalDate.now(), result.getFechaEjecucion());
        verify(maestroRepository).save(any(AfMaestro.class));
    }

    @Nested
    class CreateBranches {

        @Test
        void createPermiteTrasladoConActivoActivo() {
            AfTraslado entity = new AfTraslado();
            entity.setAfMaestroId(1L);
            entity.setUbicacionOrigenId(1L);
            entity.setUbicacionDestinoId(2L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setAfUbicacionId(1L);

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(ubicacionRepository.findById(1L)).thenReturn(Optional.of(new AfUbicacion()));
            when(ubicacionRepository.findById(2L)).thenReturn(Optional.of(new AfUbicacion()));
            when(repository.save(any(AfTraslado.class))).thenAnswer(inv -> inv.getArgument(0));

            AfTraslado result = service.create(entity);

            assertThat(result.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
        }

        @Test
        void createThrowsWhenActivoEstadoBajado() {
            AfTraslado entity = new AfTraslado();
            entity.setAfMaestroId(1L);
            entity.setUbicacionOrigenId(1L);
            entity.setUbicacionDestinoId(2L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("0");

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.TRASLADO_ESTADO_INVALIDO);
        }

        @Test
        void createUsaUbicacionDelActivoCuandoOrigenEsNull() {
            AfTraslado entity = new AfTraslado();
            entity.setAfMaestroId(1L);
            entity.setUbicacionOrigenId(null);
            entity.setUbicacionDestinoId(2L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setAfUbicacionId(5L);

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(ubicacionRepository.findById(2L)).thenReturn(Optional.of(new AfUbicacion()));
            when(repository.save(any(AfTraslado.class))).thenAnswer(inv -> inv.getArgument(0));

            AfTraslado result = service.create(entity);

            assertThat(result.getUbicacionOrigenId()).isEqualTo(5L);
        }
    }

    @Nested
    class EjecutarBranches {

        @Test
        void ejecutarThrowsWhenActivoNoExiste() {
            AfTraslado entity = new AfTraslado();
            entity.setId(1L);
            entity.setAfMaestroId(999L);

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(999L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.ejecutar(1L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void ejecutarActualizaUbicacionEnMaestro() {
            AfTraslado entity = new AfTraslado();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setUbicacionDestinoId(50L);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setAfUbicacionId(10L);

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));
            when(repository.save(any(AfTraslado.class))).thenAnswer(inv -> inv.getArgument(0));

            service.ejecutar(1L);

            assertThat(activo.getAfUbicacionId()).isEqualTo(50L);
        }
    }
}
