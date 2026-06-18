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
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
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
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
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
        saved.setFechaBaja(LocalDate.now());
        saved.setMotivo("VENTA");
        saved.setValorVenta(new BigDecimal("10000.00"));
        saved.setComprador("Comprador Test");
        
        when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
        when(repository.findByAfMaestroId(1L)).thenReturn(List.of());
        when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.empty());
        when(repository.save(any(AfVenta.class))).thenReturn(saved);
        
        AfVenta result = service.create(entity);
        assertEquals(1L, result.getId());
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
        existing.setFechaBaja(LocalDate.now());
        existing.setMotivo("VENTA");
        existing.setValorVenta(new BigDecimal("10000.00"));
        existing.setComprador("Comprador Original");
        AfVenta updateData = new AfVenta();
        updateData.setFechaBaja(LocalDate.now().plusDays(1));
        updateData.setMotivo("BAJA");
        updateData.setValorVenta(new BigDecimal("5000.00"));
        updateData.setComprador("Comprador Actualizado");
        
        AfVenta updated = new AfVenta();
        updated.setId(1L);
        updated.setAfMaestroId(1L);
        updated.setFechaBaja(LocalDate.now().plusDays(1));
        updated.setMotivo("BAJA");
        updated.setValorVenta(new BigDecimal("5000.00"));
        updated.setComprador("Comprador Actualizado");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(AfVenta.class))).thenReturn(updated);
        
        AfVenta result = service.update(1L, updateData);
        assertEquals("BAJA", result.getMotivo());
        assertEquals("Comprador Actualizado", result.getComprador());
        assertEquals(new BigDecimal("5000.00"), result.getValorVenta());
    }

    @Test
    void deleteRemovesEntity() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        
        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
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

    @Test
    void aprobarSavesVenta() {
        AfVenta entity = new AfVenta();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setMotivo("VENTA");
        entity.setEstado("EN_PROCESO");
        entity.setTipoBaja("VENTA");
        entity.setResultadoBaja(new BigDecimal("1000.00"));
        
        AfMaestro activo = new AfMaestro();
        activo.setId(1L);
        activo.setFlagEstado("1");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
        when(repository.save(any(AfVenta.class))).thenAnswer(invocation -> {
            AfVenta saved = invocation.getArgument(0);
            return saved;
        });
        when(maestroRepository.save(any(AfMaestro.class))).thenReturn(activo);
        
        AfVenta result = service.aprobar(1L);
        assertNotNull(result);
        verify(maestroRepository).save(any(AfMaestro.class));
    }

    @Nested
    class CreateBranches {

        @Test
        void createConTipoBajaSiniestroCalculaResultadoConIndemnizacion() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);
            entity.setTipoBaja("SINIESTRO");
            entity.setValorVenta(new BigDecimal("5000.00"));
            entity.setMontoIndemnizacion(new BigDecimal("8000.00"));

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

            AfVenta result = service.create(entity);

            assertThat(result.getDepreciacionAcumulada()).isEqualByComparingTo("3000.00");
            assertThat(result.getValorNetoContable()).isEqualByComparingTo("7000.00");
            assertThat(result.getResultadoBaja()).isEqualByComparingTo("1000.00");
        }

        @Test
        void createConTipoBajaObsolescenciaCalculaResultadoConIndemnizacion() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);
            entity.setTipoBaja("OBSOLESCENCIA");
            entity.setMontoIndemnizacion(null);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of());
            when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.empty());
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.create(entity);

            assertThat(result.getResultadoBaja()).isEqualByComparingTo("-10000.00");
        }

        @Test
        void createConVentaNullUsaCeroComoIngreso() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);
            entity.setTipoBaja("VENTA");
            entity.setValorVenta(null);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of());
            when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.empty());
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.create(entity);

            assertThat(result.getResultadoBaja()).isEqualByComparingTo("-10000.00");
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
        void createThrowsWhenYaExisteProcesoActivoDeBaja() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            AfVenta ventaActiva = new AfVenta();
            ventaActiva.setEstado("EN_PROCESO");

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of(ventaActiva));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }

        @Test
        void createThrowsWhenYaExisteVentaContabilizada() {
            AfVenta entity = new AfVenta();
            entity.setAfMaestroId(1L);

            AfMaestro maestro = new AfMaestro();
            maestro.setId(1L);
            maestro.setFlagEstado("1");
            maestro.setValorAdquisicion(new BigDecimal("10000.00"));

            AfVenta ventaContab = new AfVenta();
            ventaContab.setEstado("CONTABILIZADO");

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(maestro));
            when(repository.findByAfMaestroId(1L)).thenReturn(List.of(ventaContab));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }
    }

    @Nested
    class UpdateBranches {

        @Test
        void updateThrowsWhenEstadoNoEsEnProceso() {
            AfVenta existing = new AfVenta();
            existing.setId(1L);
            existing.setEstado("CONTABILIZADO");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            assertThatThrownBy(() -> service.update(1L, new AfVenta()))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }
    }

    @Nested
    class DeleteBranches {

        @Test
        void deleteThrowsWhenEstadoNoEsEnProceso() {
            AfVenta existing = new AfVenta();
            existing.setId(1L);
            existing.setEstado("CONTABILIZADO");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            assertThatThrownBy(() -> service.delete(1L))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }
    }

    @Nested
    class AprobarBranches {

        @Test
        void aprobarThrowsWhenEstadoNoEsEnProceso() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setEstado("CONTABILIZADO");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));

            assertThatThrownBy(() -> service.aprobar(1L))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        @Test
        void aprobarConTipoBajaSiniestroEstableceBajS() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("EN_PROCESO");
            entity.setTipoBaja("SINIESTRO");
            entity.setResultadoBaja(BigDecimal.ZERO);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("1");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            service.aprobar(1L);

            assertThat(activo.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void aprobarConTipoBajaObsolescenciaEstableceBajO() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("EN_PROCESO");
            entity.setTipoBaja("OBSOLESCENCIA");
            entity.setResultadoBaja(BigDecimal.ZERO);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("1");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            service.aprobar(1L);

            assertThat(activo.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void aprobarConTipoBajaNullEstableceBajV() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("EN_PROCESO");
            entity.setTipoBaja(null);
            entity.setResultadoBaja(BigDecimal.ZERO);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("1");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            service.aprobar(1L);

            assertThat(activo.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void aprobarEstableceEstadoContabilizado() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("EN_PROCESO");
            entity.setTipoBaja("VENTA");
            entity.setResultadoBaja(BigDecimal.ZERO);

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("1");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.aprobar(1L);

            assertThat(result.getEstado()).isEqualTo("CONTABILIZADO");
        }
    }

    @Nested
    class AnularBranches {

        @Test
        void anularThrowsWhenEstadoCerrado() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setEstado("CERRADO");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));

            assertThatThrownBy(() -> service.anular(1L))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.VENTA_ESTADO_INVALIDO);
        }

        @Test
        void anularDesdeContabilizadoRestauraActivoAEstadoActivo() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("CONTABILIZADO");

            AfMaestro activo = new AfMaestro();
            activo.setId(1L);
            activo.setFlagEstado("0");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(activo));
            when(maestroRepository.save(any(AfMaestro.class))).thenAnswer(inv -> inv.getArgument(0));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.anular(1L);

            assertThat(activo.getFlagEstado()).isEqualTo("1");
            assertThat(result.getEstado()).isEqualTo("ANULADO");
        }

        @Test
        void anularDesdeEnProcesoNoModificaActivo() {
            AfVenta entity = new AfVenta();
            entity.setId(1L);
            entity.setAfMaestroId(1L);
            entity.setEstado("EN_PROCESO");

            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(any(AfVenta.class))).thenAnswer(inv -> inv.getArgument(0));

            AfVenta result = service.anular(1L);

            assertThat(result.getEstado()).isEqualTo("ANULADO");
            verify(maestroRepository, never()).save(any());
        }
    }
}
