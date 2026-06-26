package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
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
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionServiceImplTest {

    @Mock
    private AfAdaptacionRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfHistorialService historialService;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    @InjectMocks
    private AfAdaptacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(7L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private AfMaestro activoValido() {
        AfMaestro a = new AfMaestro();
        a.setId(2L);
        a.setFlagEstado("1");
        a.setValorAdquisicion(new BigDecimal("1000.00"));
        return a;
    }

    @Nested
    class FindAll {

        @Test
        void retornaPagina() {
            when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(new AfAdaptacion())));
            Page<AfAdaptacion> result = service.findAll(PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }

    @Nested
    class FindById {

        @Test
        void retornaAdaptacion() {
            AfAdaptacion a = new AfAdaptacion();
            a.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(a));
            assertThat(service.findById(1L).getId()).isEqualTo(1L);
        }

        @Test
        void lanzaExcepcionSiNoExiste() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateTest {

        @Test
        void creaAdaptacionExitosamente() {
            AfAdaptacion entity = new AfAdaptacion();
            entity.setAfMaestroId(2L);
            entity.setMontoTotal(new BigDecimal("500.00"));
            entity.setDescripcion("Mejora");
            entity.setFecha(LocalDate.of(2026, 3, 1));

            when(maestroRepository.findById(2L)).thenReturn(Optional.of(activoValido()));
            when(repository.save(any())).thenAnswer(inv -> {
                AfAdaptacion a = inv.getArgument(0);
                a.setId(1L);
                return a;
            });

            AfAdaptacion result = service.create(entity);
            assertThat(result.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
            verify(historialService).create(any(AfHistorial.class));
        }

        @Test
        void lanzaExcepcionSiActivoNoExiste() {
            AfAdaptacion entity = new AfAdaptacion();
            entity.setAfMaestroId(99L);
            when(maestroRepository.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MAESTRO_NO_ENCONTRADO);
        }

        @Test
        void lanzaExcepcionSiActivoEnEstadoInvalido() {
            AfAdaptacion entity = new AfAdaptacion();
            entity.setAfMaestroId(2L);
            AfMaestro a = activoValido();
            a.setFlagEstado("0");
            when(maestroRepository.findById(2L)).thenReturn(Optional.of(a));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_INACTIVO_ADAPTACION);
        }

        @Test
        void permiteCrearSiActivoConFlagActivo() {
            AfAdaptacion entity = new AfAdaptacion();
            entity.setAfMaestroId(2L);
            entity.setMontoTotal(new BigDecimal("500.00"));
            entity.setDescripcion("Mejora");
            AfMaestro a = activoValido();
            a.setFlagEstado("1");
            when(maestroRepository.findById(2L)).thenReturn(Optional.of(a));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfAdaptacion result = service.create(entity);
            assertThat(result.getDescripcion()).isEqualTo("Mejora");
        }
    }

    @Nested
    class UpdateTest {

        @Test
        void actualizaAdaptacionRegistrada() {
            AfAdaptacion existing = new AfAdaptacion();
            existing.setId(1L);
            existing.setAfMaestroId(2L);

            AfAdaptacion updated = new AfAdaptacion();
            updated.setAfMaestroId(2L);
            updated.setDescripcion("Mejora actualizada");
            updated.setMontoTotal(new BigDecimal("600.00"));
            updated.setFecha(LocalDate.of(2026, 4, 1));

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfAdaptacion result = service.update(1L, updated);
            assertThat(result.getDescripcion()).isEqualTo("Mejora actualizada");
        }

        @Test
        void validaActivoSiCambiaMaestroId() {
            AfAdaptacion existing = new AfAdaptacion();
            existing.setId(1L);
            existing.setAfMaestroId(2L);

            AfAdaptacion updated = new AfAdaptacion();
            updated.setAfMaestroId(3L);
            updated.setDescripcion("Desc");
            updated.setMontoTotal(new BigDecimal("100.00"));
            updated.setFecha(LocalDate.now());

            AfMaestro a = new AfMaestro();
            a.setId(3L);
            a.setFlagEstado("1");
            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(maestroRepository.findById(3L)).thenReturn(Optional.of(a));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.update(1L, updated);
            verify(maestroRepository).findById(3L);
        }
    }

    @Nested
    class DeleteTest {

        @Test
        void eliminaAdaptacion() {
            AfAdaptacion existing = new AfAdaptacion();
            existing.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            service.delete(1L);
            verify(repository).delete(existing);
        }
    }

    @Nested
    class FindByActivo {

        @Test
        void retornaAdaptaciones() {
            when(repository.findByAfMaestroId(2L)).thenReturn(List.of(new AfAdaptacion()));
            assertThat(service.findByActivo(2L)).hasSize(1);
        }
    }

    @Nested
    class FindByFechaRange {

        @Test
        void retornaAdaptacionesEnRango() {
            LocalDate ini = LocalDate.of(2026, 1, 1);
            LocalDate fin = LocalDate.of(2026, 12, 31);
            when(repository.findByFechaRange(ini, fin)).thenReturn(List.of(new AfAdaptacion()));
            assertThat(service.findByFechaRange(ini, fin)).hasSize(1);
        }
    }

    @Nested
    class Capitalizar {

        @Test
        void capitalizaSumaMontoAlActivo() {
            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(1L);
            adaptacion.setAfMaestroId(2L);
            adaptacion.setMontoTotal(new BigDecimal("500.00"));

            AfMaestro activo = activoValido();
            when(repository.findById(1L)).thenReturn(Optional.of(adaptacion));
            when(maestroRepository.findById(2L)).thenReturn(Optional.of(activo));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.capitalizar(1L);

            assertThat(activo.getValorAdquisicion()).isEqualByComparingTo("1500.00");
            verify(historialService).create(any(AfHistorial.class));
        }

        @Test
        void lanzaExcepcionSiMontoCero() {
            AfAdaptacion a = new AfAdaptacion();
            a.setId(1L);
            a.setMontoTotal(BigDecimal.ZERO);
            when(repository.findById(1L)).thenReturn(Optional.of(a));

            assertThatThrownBy(() -> service.capitalizar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_INVALIDO_CAPITALIZACION);
        }

        @Test
        void lanzaExcepcionSiMontoNulo() {
            AfAdaptacion a = new AfAdaptacion();
            a.setId(1L);
            a.setMontoTotal(null);
            when(repository.findById(1L)).thenReturn(Optional.of(a));

            assertThatThrownBy(() -> service.capitalizar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_INVALIDO_CAPITALIZACION);
        }

        @Test
        void lanzaExcepcionSiMontoNegativo() {
            AfAdaptacion a = new AfAdaptacion();
            a.setId(1L);
            a.setMontoTotal(new BigDecimal("-100.00"));
            when(repository.findById(1L)).thenReturn(Optional.of(a));

            assertThatThrownBy(() -> service.capitalizar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_INVALIDO_CAPITALIZACION);
        }

        @Test
        void lanzaExcepcionSiActivoNoExiste() {
            AfAdaptacion a = new AfAdaptacion();
            a.setId(1L);
            a.setAfMaestroId(99L);
            a.setMontoTotal(new BigDecimal("500.00"));
            when(repository.findById(1L)).thenReturn(Optional.of(a));
            when(maestroRepository.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.capitalizar(1L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ObtenerTotalCapitalizado {

        @Test
        void retornaTotalCuandoHayDatos() {
            when(repository.obtenerTotalCapitalizado(2L)).thenReturn(new BigDecimal("5000.00"));
            assertThat(service.obtenerTotalCapitalizado(2L)).isEqualByComparingTo("5000.00");
        }

        @Test
        void retornaCeroSiNull() {
            when(repository.obtenerTotalCapitalizado(2L)).thenReturn(null);
            assertThat(service.obtenerTotalCapitalizado(2L)).isEqualByComparingTo("0");
        }
    }
}
