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
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfVenta;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfVentaServiceImplTest {

    @Mock
    private AfVentaRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfCalculoCntblRepository calculoRepository;
    @Mock
    private AfHistorialService historialService;
    @InjectMocks
    private AfVentaServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setFechaBaja(LocalDate.now());
        entity.setMotivo("VENTA");
        entity.setValorVenta(new BigDecimal("10000.00"));
        entity.setComprador("Comprador Test");
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfVenta> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
    }

    @Test
    void findByIdReturnsEntity() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfVenta result = service.findById(1L);
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfVenta entity = new AfVenta();
        entity.setAfMaestroId(1L);
        entity.setCntasCobrarId(100L);
        entity.setSerieDoc("F001");
        entity.setNroDoc("00000123");
        entity.setFechaBaja(LocalDate.now());
        entity.setMotivo("VENTA");
        entity.setValorVenta(new BigDecimal("10000.00"));
        entity.setComprador("Comprador Test");

        AfMaestro maestro = new AfMaestro();
        maestro.setId(1L);
        maestro.setFlagEstado("1");
        maestro.setValorAdquisicion(new BigDecimal("15000.00"));

        AfVenta saved = new AfVenta();
        saved.setId(1L);
        saved.setAfMaestroId(1L);
        saved.setFechaBaja(entity.getFechaBaja());
        saved.setMotivo("VENTA");
        saved.setValorVenta(new BigDecimal("10000.00"));
        saved.setComprador("Comprador Test");

        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(repository.findByAfMaestroId(1L)).thenReturn(List.of());
        when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.empty());
        when(repository.save(any(AfVenta.class))).thenReturn(saved);
        when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

        AfVenta result = service.create(entity);
        assertEquals(1L, result.getId());
        verify(maestroRepository).save(any(AfMaestro.class));
        verify(historialService).create(any());
    }

    @Test
    void createThrowsNotFoundWhenActivoNotExists() {
        AfVenta entity = new AfVenta();
        entity.setAfMaestroId(999L);

        when(maestroRepository.findById(999L)).thenReturn(Optional.empty());

        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.MAESTRO_NO_ENCONTRADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("999"));
    }

    @Test
    void updateModifiesEntity() {
        AfVenta existing = new AfVenta();
        existing.setId(1L);
        existing.setAfMaestroId(1L);
        existing.setCntasCobrarId(100L);
        existing.setFechaBaja(LocalDate.now());
        existing.setMotivo("VENTA");
        existing.setValorVenta(new BigDecimal("10000.00"));
        existing.setComprador("Comprador Original");

        AfVenta updateData = new AfVenta();
        updateData.setCntasCobrarId(200L);
        updateData.setDocTipoId(3L);
        updateData.setSerieDoc("B001");
        updateData.setNroDoc("00000456");
        updateData.setFechaBaja(LocalDate.now().plusDays(1));
        updateData.setMotivo("BAJA");
        updateData.setValorVenta(new BigDecimal("5000.00"));
        updateData.setComprador("Comprador Actualizado");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));

        AfVenta result = service.update(1L, updateData);

        assertEquals("BAJA", result.getMotivo());
        assertEquals("Comprador Actualizado", result.getComprador());
        assertEquals(new BigDecimal("5000.00"), result.getValorVenta());
        assertEquals(200L, result.getCntasCobrarId());
        assertEquals("B001", result.getSerieDoc());
        assertEquals("00000456", result.getNroDoc());
    }

    @Test
    void deleteRemovesEntity() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.findById(1L)).thenReturn(Optional.empty());

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
        verify(historialService).create(any());
    }

    @Test
    void findByActivoReturnsList() {
        AfVenta entity1 = new AfVenta();
        entity1.setId(1L);
        entity1.setAfMaestroId(1L);
        AfVenta entity2 = new AfVenta();
        entity2.setId(2L);
        entity2.setAfMaestroId(1L);

        when(repository.findByAfMaestroId(1L)).thenReturn(List.of(entity1, entity2));
        List<AfVenta> result = service.findByActivo(1L);
        assertEquals(2, result.size());
        assertEquals(1L, result.get(0).getAfMaestroId());
        assertEquals(1L, result.get(1).getAfMaestroId());
    }

    @Test
    void findByAnioReturnsList() {
        AfVenta entity1 = new AfVenta();
        entity1.setId(1L);
        entity1.setFechaBaja(LocalDate.of(2024, 1, 15));

        AfVenta entity2 = new AfVenta();
        entity2.setId(2L);
        entity2.setFechaBaja(LocalDate.of(2024, 6, 20));

        when(repository.findByAnio(2024)).thenReturn(List.of(entity1, entity2));
        List<AfVenta> result = service.findByAnio(2024);
        assertEquals(2, result.size());
        assertEquals(2024, result.get(0).getFechaBaja().getYear());
        assertEquals(2024, result.get(1).getFechaBaja().getYear());
    }

    @Nested
    class CreateBranches {

        @Test
        void createCalculaDepreciacionYValorNetoContable() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);
            entity.setFechaBaja(LocalDate.now());
            entity.setMotivo("VENTA");
            entity.setValorVenta(new BigDecimal("5000.00"));

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            AfCalculoCntbl calc = new AfCalculoCntbl();
            calc.setDepreciacionAcumulada(new BigDecimal("3000.00"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of());
            when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.of(calc));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.create(entity);

            assertThat(result.getDepreciacionAcumulada()).isEqualByComparingTo("3000.00");
            assertThat(result.getValorNetoContable()).isEqualByComparingTo("7000.00");
            assertThat(maestro.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void createThrowsWhenActivoYaBajado() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("0");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }

        @Test
        void createThrowsWhenYaExisteVentaActiva() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            AfVenta ventaActiva = new AfVenta();
            ventaActiva.setFlagEstado("1");

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of(ventaActiva));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }
    }

    @Nested
    class DeleteBranches {

        @Test
        void deleteRestauraActivoCuandoEstabaInactivo() {
            AfVenta existing = new AfVenta();
            existing.setId(1L);
            existing.setAfMaestroId(1L);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("0");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            service.delete(1L);

            assertThat(activo.getFlagEstado()).isEqualTo("1");
            verify(repository).delete(existing);
            verify(historialService).create(any());
        }
    }
}
