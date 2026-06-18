package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfPolizaActivo;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfPolizaActivoRepository;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfPolizaActivoServiceImplTest {

    @Mock
    private AfPolizaActivoRepository repository;
    @Mock
    private AfPolizaSeguroRepository polizaSeguroRepository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfCalculoCntblRepository calculoCntblRepository;
    @InjectMocks
    private AfPolizaActivoServiceImpl service;

    @Test
    void findAllReturnsPage() {
        AfPolizaActivo pa = new AfPolizaActivo();
        pa.setId(1L);

        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(pa)));
        Page<AfPolizaActivo> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setId(1L);
        entity.setAfPolizaSeguroId(5L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfPolizaActivo result = service.findById(1L);
        assertEquals(5L, result.getAfPolizaSeguroId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(99L));
    }

    @Test
    void createSavesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro poliza = new AfPolizaSeguro();
            poliza.setId(2L);
            poliza.setNumeroPoliza("POL-001");

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);
            maestro.setCodigo("ACT-001");
            maestro.setValorAdquisicion(new BigDecimal("10000.0000"));

            AfPolizaActivo entity = new AfPolizaActivo();
            entity.setAfPolizaSeguroId(2L);
            entity.setAfMaestroId(10L);
            entity.setValorAsegurado(new BigDecimal("8000.0000"));

            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setValorNeto(new BigDecimal("9000.0000"));

            AfPolizaActivo saved = new AfPolizaActivo();
            saved.setId(1L);
            saved.setFlagEstado("1");

            when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(2L, 10L)).thenReturn(false);
            when(calculoCntblRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.of(ultimaDep));
            when(repository.save(any(AfPolizaActivo.class))).thenReturn(saved);

            AfPolizaActivo result = service.create(entity);
            assertEquals("1", result.getFlagEstado());
        }
    }

    @Test
    void createThrowsWhenPolizaNotFound() {
        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setAfPolizaSeguroId(99L);
        entity.setAfMaestroId(10L);

        when(polizaSeguroRepository.findById(99L)).thenReturn(Optional.empty());
        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals("ACT-031", ex.getErrorCode());
    }

    @Test
    void createThrowsWhenActivoNotFound() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(2L);
        poliza.setNumeroPoliza("POL-001");

        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setAfPolizaSeguroId(2L);
        entity.setAfMaestroId(99L);

        when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
        when(maestroRepository.findById(99L)).thenReturn(Optional.empty());

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ACTIVO_NO_ENCONTRADO_POLIZA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenActivoDuplicated() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(2L);
        poliza.setNumeroPoliza("POL-001");

        AfMaestro maestro = new AfMaestro();
        maestro.setId(10L);
        maestro.setCodigo("ACT-001");

        AfPolizaActivo existing = new AfPolizaActivo();
        existing.setId(5L);

        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setAfPolizaSeguroId(2L);
        entity.setAfMaestroId(10L);
        entity.setValorAsegurado(null);

        when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
        when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
        when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(2L, 10L)).thenReturn(true);
        when(repository.findByPolizaAndActivo(2L, 10L)).thenReturn(existing);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ACTIVO_YA_ASEGURADO, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenValorAseguradoExceedsNeto() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro poliza = new AfPolizaSeguro();
            poliza.setId(2L);
            poliza.setNumeroPoliza("POL-001");

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);
            maestro.setCodigo("ACT-001");
            maestro.setValorAdquisicion(new BigDecimal("10000.0000"));

            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setValorNeto(new BigDecimal("5000.0000"));

            AfPolizaActivo entity = new AfPolizaActivo();
            entity.setAfPolizaSeguroId(2L);
            entity.setAfMaestroId(10L);
            entity.setValorAsegurado(new BigDecimal("7000.0000"));

            when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(2L, 10L)).thenReturn(false);
            when(calculoCntblRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.of(ultimaDep));

            BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
            assertEquals(ActivosErrorCodes.VALOR_ASEGURADO_EXCEDE_NETO, ex.getErrorCode());
        }
    }

    @Test
    void createUsesValorAdquisicionWhenNoDepreciacion() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro poliza = new AfPolizaSeguro();
            poliza.setId(2L);
            poliza.setNumeroPoliza("POL-001");

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);
            maestro.setCodigo("ACT-001");
            maestro.setValorAdquisicion(new BigDecimal("10000.0000"));

            AfPolizaActivo entity = new AfPolizaActivo();
            entity.setAfPolizaSeguroId(2L);
            entity.setAfMaestroId(10L);
            entity.setValorAsegurado(new BigDecimal("9000.0000"));

            AfPolizaActivo saved = new AfPolizaActivo();
            saved.setId(1L);
            saved.setFlagEstado("1");

            when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(2L, 10L)).thenReturn(false);
            when(calculoCntblRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.empty());
            when(repository.save(any(AfPolizaActivo.class))).thenReturn(saved);

            AfPolizaActivo result = service.create(entity);
            assertNotNull(result);
        }
    }

    @Test
    void createSkipsValorValidationWhenNull() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro poliza = new AfPolizaSeguro();
            poliza.setId(2L);
            poliza.setNumeroPoliza("POL-001");

            AfMaestro maestro = new AfMaestro();
            maestro.setId(10L);
            maestro.setCodigo("ACT-001");

            AfPolizaActivo entity = new AfPolizaActivo();
            entity.setAfPolizaSeguroId(2L);
            entity.setAfMaestroId(10L);
            entity.setValorAsegurado(null);

            AfPolizaActivo saved = new AfPolizaActivo();
            saved.setId(1L);
            saved.setFlagEstado("1");

            when(polizaSeguroRepository.findById(2L)).thenReturn(Optional.of(poliza));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(maestro));
            when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(2L, 10L)).thenReturn(false);
            when(repository.save(any(AfPolizaActivo.class))).thenReturn(saved);

            AfPolizaActivo result = service.create(entity);
            assertNotNull(result);
            verify(calculoCntblRepository, never()).obtenerUltimaDepreciacion(anyLong());
        }
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaActivo existing = new AfPolizaActivo();
            existing.setId(1L);
            existing.setAfPolizaSeguroId(2L);
            existing.setAfMaestroId(10L);

            AfPolizaActivo updateData = new AfPolizaActivo();
            updateData.setAfPolizaSeguroId(2L);
            updateData.setAfMaestroId(10L);
            updateData.setValorAsegurado(null);

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any(AfPolizaActivo.class))).thenReturn(existing);

            AfPolizaActivo result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void updateValidatesWhenPolizaOrActivoChanges() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaActivo existing = new AfPolizaActivo();
            existing.setId(1L);
            existing.setAfPolizaSeguroId(2L);
            existing.setAfMaestroId(10L);

            AfPolizaSeguro poliza = new AfPolizaSeguro();
            poliza.setId(3L);
            poliza.setNumeroPoliza("POL-002");

            AfMaestro maestro = new AfMaestro();
            maestro.setId(20L);
            maestro.setCodigo("ACT-002");
            maestro.setValorAdquisicion(new BigDecimal("5000.0000"));

            AfPolizaActivo updateData = new AfPolizaActivo();
            updateData.setAfPolizaSeguroId(3L);
            updateData.setAfMaestroId(20L);
            updateData.setValorAsegurado(null);

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(polizaSeguroRepository.findById(3L)).thenReturn(Optional.of(poliza));
            when(maestroRepository.findById(20L)).thenReturn(Optional.of(maestro));
            when(repository.existsByAfPolizaSeguroIdAndAfMaestroId(3L, 20L)).thenReturn(false);
            when(repository.save(any(AfPolizaActivo.class))).thenReturn(existing);

            AfPolizaActivo result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void deleteRemovesEntity() {
        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setId(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.delete(99L));
    }

    @Test
    void findByPolizaReturnsList() {
        AfPolizaActivo pa = new AfPolizaActivo();
        pa.setId(1L);

        when(repository.findByAfPolizaSeguroId(2L)).thenReturn(List.of(pa));
        List<AfPolizaActivo> result = service.findByPoliza(2L);
        assertEquals(1, result.size());
    }

    @Test
    void findByActivoReturnsList() {
        AfPolizaActivo pa = new AfPolizaActivo();
        pa.setId(1L);

        when(repository.findByAfMaestroId(10L)).thenReturn(List.of(pa));
        List<AfPolizaActivo> result = service.findByActivo(10L);
        assertEquals(1, result.size());
    }
}
