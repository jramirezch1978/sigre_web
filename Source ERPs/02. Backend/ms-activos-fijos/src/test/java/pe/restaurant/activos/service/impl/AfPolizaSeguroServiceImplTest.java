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
import pe.restaurant.activos.entity.AfAseguradora;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.repository.AfAseguradoraRepository;
import pe.restaurant.activos.repository.AfPolizaSeguroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfPolizaSeguroServiceImplTest {

    @Mock
    private AfPolizaSeguroRepository repository;
    @Mock
    private AfAseguradoraRepository aseguradoraRepository;
    @InjectMocks
    private AfPolizaSeguroServiceImpl service;

    @Test
    void findAllReturnsPage() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(1L);
        poliza.setNumeroPoliza("POL-001");

        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(poliza)));
        Page<AfPolizaSeguro> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setId(1L);
        entity.setNumeroPoliza("POL-001");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfPolizaSeguro result = service.findById(1L);
        assertEquals("POL-001", result.getNumeroPoliza());
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

            AfAseguradora aseguradora = new AfAseguradora();
            aseguradora.setId(3L);
            aseguradora.setNombre("Segura S.A.");
            aseguradora.setFlagEstado("1");

            AfPolizaSeguro entity = new AfPolizaSeguro();
            entity.setNumeroPoliza("POL-001");
            entity.setAfAseguradoraId(3L);
            entity.setFechaInicio(LocalDate.of(2026, 1, 1));
            entity.setFechaFin(LocalDate.of(2027, 1, 1));
            entity.setPrima(new BigDecimal("5000.0000"));

            AfPolizaSeguro saved = new AfPolizaSeguro();
            saved.setId(1L);
            saved.setNumeroPoliza("POL-001");
            saved.setFlagEstado("1");

            when(repository.existsByNumeroPolizaIgnoreCase("POL-001")).thenReturn(false);
            when(aseguradoraRepository.findById(3L)).thenReturn(Optional.of(aseguradora));
            when(repository.save(any(AfPolizaSeguro.class))).thenReturn(saved);

            AfPolizaSeguro result = service.create(entity);
            assertEquals("1", result.getFlagEstado());
        }
    }

    @Test
    void createThrowsWhenNumeroPolizaDuplicated() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setNumeroPoliza("POL-001");
        entity.setAfAseguradoraId(3L);
        entity.setFechaInicio(LocalDate.of(2026, 1, 1));

        when(repository.existsByNumeroPolizaIgnoreCase("POL-001")).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.POLIZA_NUMERO_DUPLICADO, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenAseguradoraNotFound() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setNumeroPoliza("POL-002");
        entity.setAfAseguradoraId(99L);
        entity.setFechaInicio(LocalDate.of(2026, 1, 1));

        when(repository.existsByNumeroPolizaIgnoreCase("POL-002")).thenReturn(false);
        when(aseguradoraRepository.findById(99L)).thenReturn(Optional.empty());

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ASEGURADORA_NO_ENCONTRADA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenAseguradoraInactiva() {
        AfAseguradora aseguradora = new AfAseguradora();
        aseguradora.setId(3L);
        aseguradora.setNombre("Segura S.A.");
        aseguradora.setFlagEstado("0");

        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setNumeroPoliza("POL-003");
        entity.setAfAseguradoraId(3L);
        entity.setFechaInicio(LocalDate.of(2026, 1, 1));

        when(repository.existsByNumeroPolizaIgnoreCase("POL-003")).thenReturn(false);
        when(aseguradoraRepository.findById(3L)).thenReturn(Optional.of(aseguradora));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.ASEGURADORA_INACTIVA, ex.getErrorCode());
    }

    @Test
    void createThrowsWhenFechaFinBeforeInicio() {
        AfAseguradora aseguradora = new AfAseguradora();
        aseguradora.setId(3L);
        aseguradora.setNombre("Segura S.A.");
        aseguradora.setFlagEstado("1");

        AfPolizaSeguro entity = new AfPolizaSeguro();
        entity.setNumeroPoliza("POL-004");
        entity.setAfAseguradoraId(3L);
        entity.setFechaInicio(LocalDate.of(2026, 6, 1));
        entity.setFechaFin(LocalDate.of(2026, 1, 1));

        when(repository.existsByNumeroPolizaIgnoreCase("POL-004")).thenReturn(false);
        when(aseguradoraRepository.findById(3L)).thenReturn(Optional.of(aseguradora));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.FECHA_FIN_ANTERIOR_INICIO, ex.getErrorCode());
    }

    @Test
    void createAcceptsNullFechaFin() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfAseguradora aseguradora = new AfAseguradora();
            aseguradora.setId(3L);
            aseguradora.setNombre("Segura S.A.");
            aseguradora.setFlagEstado("1");

            AfPolizaSeguro entity = new AfPolizaSeguro();
            entity.setNumeroPoliza("POL-005");
            entity.setAfAseguradoraId(3L);
            entity.setFechaInicio(LocalDate.of(2026, 1, 1));
            entity.setFechaFin(null);

            AfPolizaSeguro saved = new AfPolizaSeguro();
            saved.setId(1L);
            saved.setFlagEstado("1");

            when(repository.existsByNumeroPolizaIgnoreCase("POL-005")).thenReturn(false);
            when(aseguradoraRepository.findById(3L)).thenReturn(Optional.of(aseguradora));
            when(repository.save(any(AfPolizaSeguro.class))).thenReturn(saved);

            assertDoesNotThrow(() -> service.create(entity));
        }
    }

    @Test
    void updateModifiesEntity() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro existing = new AfPolizaSeguro();
            existing.setId(1L);
            existing.setNumeroPoliza("POL-001");
            existing.setAfAseguradoraId(3L);

            AfAseguradora aseguradora = new AfAseguradora();
            aseguradora.setId(4L);
            aseguradora.setNombre("Nueva S.A.");
            aseguradora.setFlagEstado("1");

            AfPolizaSeguro updateData = new AfPolizaSeguro();
            updateData.setNumeroPoliza("POL-001-R");
            updateData.setAfAseguradoraId(4L);
            updateData.setFechaInicio(LocalDate.of(2026, 6, 1));
            updateData.setFechaFin(LocalDate.of(2027, 6, 1));
            updateData.setPrima(new BigDecimal("6000.0000"));
            updateData.setCobertura(new BigDecimal("100000.0000"));

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByNumeroPolizaIgnoreCaseAndIdNot("POL-001-R", 1L)).thenReturn(false);
            when(aseguradoraRepository.findById(4L)).thenReturn(Optional.of(aseguradora));
            when(repository.save(any(AfPolizaSeguro.class))).thenReturn(existing);

            AfPolizaSeguro result = service.update(1L, updateData);
            assertNotNull(result);
        }
    }

    @Test
    void updateSkipsNumeroValidationWhenSame() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfPolizaSeguro existing = new AfPolizaSeguro();
            existing.setId(1L);
            existing.setNumeroPoliza("POL-001");
            existing.setAfAseguradoraId(3L);

            AfPolizaSeguro updateData = new AfPolizaSeguro();
            updateData.setNumeroPoliza("POL-001");
            updateData.setAfAseguradoraId(3L);
            updateData.setFechaInicio(LocalDate.of(2026, 1, 1));
            updateData.setFechaFin(LocalDate.of(2027, 1, 1));

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any(AfPolizaSeguro.class))).thenReturn(existing);

            assertDoesNotThrow(() -> service.update(1L, updateData));
            verify(repository, never()).existsByNumeroPolizaIgnoreCaseAndIdNot(anyString(), anyLong());
        }
    }

    @Test
    void updateThrowsWhenNumeroDuplicated() {
        AfPolizaSeguro existing = new AfPolizaSeguro();
        existing.setId(1L);
        existing.setNumeroPoliza("POL-001");
        existing.setAfAseguradoraId(3L);

        AfPolizaSeguro updateData = new AfPolizaSeguro();
        updateData.setNumeroPoliza("POL-EXISTENTE");
        updateData.setAfAseguradoraId(3L);
        updateData.setFechaInicio(LocalDate.of(2026, 1, 1));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByNumeroPolizaIgnoreCaseAndIdNot("POL-EXISTENTE", 1L)).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.POLIZA_NUMERO_DUPLICADO, ex.getErrorCode());
    }

    @Test
    void deleteRemovesEntity() {
        AfPolizaSeguro entity = new AfPolizaSeguro();
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
    void findPolizasVigentesReturnsPage() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(1L);

        when(repository.findPolizasVigentes(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(poliza)));
        Page<AfPolizaSeguro> result = service.findPolizasVigentes(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findPolizasPorVencerReturnsList() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(1L);

        when(repository.findPolizasPorVencer(any(LocalDate.class), any(LocalDate.class)))
                .thenReturn(List.of(poliza));

        List<AfPolizaSeguro> result = service.findPolizasPorVencer(30);
        assertEquals(1, result.size());
    }

    @Test
    void findByAseguradoraReturnsPage() {
        AfPolizaSeguro poliza = new AfPolizaSeguro();
        poliza.setId(1L);

        when(repository.findByAfAseguradoraId(eq(3L), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(poliza)));

        Page<AfPolizaSeguro> result = service.findByAseguradora(3L, PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void renovarPolizaUpdatesFields() {
        AfPolizaSeguro existing = new AfPolizaSeguro();
        existing.setId(1L);
        existing.setNumeroPoliza("POL-001");
        existing.setFechaInicio(LocalDate.of(2025, 1, 1));
        existing.setFechaFin(LocalDate.of(2026, 1, 1));

        AfPolizaSeguro datosRenovacion = new AfPolizaSeguro();
        datosRenovacion.setFechaInicio(LocalDate.of(2026, 1, 1));
        datosRenovacion.setFechaFin(LocalDate.of(2027, 1, 1));
        datosRenovacion.setPrima(new BigDecimal("7000.0000"));
        datosRenovacion.setCobertura(new BigDecimal("200000.0000"));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(AfPolizaSeguro.class))).thenReturn(existing);

        AfPolizaSeguro result = service.renovarPoliza(1L, datosRenovacion);
        assertNotNull(result);
    }

    @Test
    void renovarPolizaThrowsWhenFechasInvalidas() {
        AfPolizaSeguro existing = new AfPolizaSeguro();
        existing.setId(1L);
        existing.setNumeroPoliza("POL-001");

        AfPolizaSeguro datosRenovacion = new AfPolizaSeguro();
        datosRenovacion.setFechaInicio(LocalDate.of(2027, 1, 1));
        datosRenovacion.setFechaFin(LocalDate.of(2026, 1, 1));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        BusinessException ex = assertThrows(BusinessException.class, () -> service.renovarPoliza(1L, datosRenovacion));
        assertEquals(ActivosErrorCodes.FECHA_FIN_ANTERIOR_INICIO, ex.getErrorCode());
    }

    @Test
    void renovarPolizaThrowsNotFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.renovarPoliza(99L, new AfPolizaSeguro()));
    }
}
