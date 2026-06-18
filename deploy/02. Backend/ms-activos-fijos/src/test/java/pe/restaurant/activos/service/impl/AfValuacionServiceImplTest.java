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
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfValuacion;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfValuacionRepository;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfValuacionServiceImplTest {

    @Mock
    private AfValuacionRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfHistorialService historialService;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    @InjectMocks
    private AfValuacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(10L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private AfMaestro activoValido() {
        AfMaestro a = new AfMaestro();
        a.setId(5L);
        a.setFlagEstado("1");
        a.setValorAdquisicion(new BigDecimal("10000.00"));
        return a;
    }

    @Nested
    class FindAll {

        @Test
        void retornaPagina() {
            when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(new AfValuacion())));
            Page<AfValuacion> result = service.findAll(PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }

    @Nested
    class FindById {

        @Test
        void retornaValuacion() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(v));
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
        void creaValuacionExitosamente() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(5L);
            entity.setValorAnterior(new BigDecimal("10000.00"));
            entity.setValorNuevo(new BigDecimal("12000.00"));
            entity.setMetodoValuacion("COSTO");

            AfMaestro activo = activoValido();
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));
            when(repository.findByAfMaestroIdOrderByFechaValuacionDesc(5L)).thenReturn(Collections.emptyList());
            when(repository.save(any())).thenAnswer(inv -> {
                AfValuacion v = inv.getArgument(0);
                v.setId(1L);
                return v;
            });

            AfValuacion result = service.create(entity);
            assertThat(result.getEstado()).isEqualTo("EN_PROCESO");
            verify(historialService).create(any(AfHistorial.class));
        }

        @Test
        void lanzaExcepcionSiActivoNoExiste() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(99L);
            when(maestroRepository.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MAESTRO_NO_ENCONTRADO);
        }

        @Test
        void lanzaExcepcionSiActivoEnEstadoInvalido() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(5L);
            AfMaestro activo = activoValido();
            activo.setFlagEstado("0");
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        @Test
        void lanzaExcepcionSiYaExisteEnProceso() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(5L);
            AfMaestro activo = activoValido();
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));

            AfValuacion enProceso = new AfValuacion();
            enProceso.setEstado("EN_PROCESO");
            when(repository.findByAfMaestroIdOrderByFechaValuacionDesc(5L)).thenReturn(List.of(enProceso));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        @Test
        void lanzaExcepcionSiYaExisteValidada() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(5L);
            AfMaestro activo = activoValido();
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));

            AfValuacion validada = new AfValuacion();
            validada.setEstado("VALIDADO");
            when(repository.findByAfMaestroIdOrderByFechaValuacionDesc(5L)).thenReturn(List.of(validada));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void permiteCrearSiExistenteYaAprobada() {
            AfValuacion entity = new AfValuacion();
            entity.setAfMaestroId(5L);
            entity.setValorAnterior(new BigDecimal("10000.00"));
            entity.setValorNuevo(new BigDecimal("12000.00"));
            entity.setMetodoValuacion("COSTO");

            AfMaestro activo = activoValido();
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));

            AfValuacion aprobada = new AfValuacion();
            aprobada.setEstado("APROBADO");
            when(repository.findByAfMaestroIdOrderByFechaValuacionDesc(5L)).thenReturn(List.of(aprobada));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.create(entity);
            assertThat(result.getEstado()).isEqualTo("EN_PROCESO");
        }
    }

    @Nested
    class UpdateTest {

        @Test
        void actualizaValuacionEnProceso() {
            AfValuacion existing = new AfValuacion();
            existing.setId(1L);
            existing.setEstado("EN_PROCESO");

            AfValuacion updated = new AfValuacion();
            updated.setFechaValuacion(LocalDate.of(2026, 5, 1));
            updated.setValorAnterior(new BigDecimal("10000.00"));
            updated.setValorNuevo(new BigDecimal("11000.00"));
            updated.setMetodoValuacion("MERCADO");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.update(1L, updated);
            assertThat(result.getMetodoValuacion()).isEqualTo("MERCADO");
        }

        @Test
        void lanzaExcepcionSiNoEnProceso() {
            AfValuacion existing = new AfValuacion();
            existing.setId(1L);
            existing.setEstado("APROBADO");
            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            assertThatThrownBy(() -> service.update(1L, new AfValuacion()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }
    }

    @Nested
    class DeleteTest {

        @Test
        void eliminaValuacionEnProceso() {
            AfValuacion existing = new AfValuacion();
            existing.setId(1L);
            existing.setEstado("EN_PROCESO");
            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            service.delete(1L);
            verify(repository).delete(existing);
        }

        @Test
        void lanzaExcepcionSiNoEnProceso() {
            AfValuacion existing = new AfValuacion();
            existing.setId(1L);
            existing.setEstado("VALIDADO");
            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            assertThatThrownBy(() -> service.delete(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }
    }

    @Nested
    class FindByActivo {

        @Test
        void retornaListaDeValuaciones() {
            when(repository.findByAfMaestroIdOrderByFechaValuacionDesc(5L))
                    .thenReturn(List.of(new AfValuacion()));
            assertThat(service.findByActivo(5L)).hasSize(1);
        }
    }

    @Nested
    class FindByPeriodo {

        @Test
        void retornaValuacionesEnRango() {
            LocalDate ini = LocalDate.of(2026, 1, 1);
            LocalDate fin = LocalDate.of(2026, 12, 31);
            when(repository.findByPeriodo(ini, fin)).thenReturn(List.of(new AfValuacion()));
            assertThat(service.findByPeriodo(ini, fin)).hasSize(1);
        }
    }

    @Nested
    class Validar {

        @Test
        void validaValuacionEnProceso() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setEstado("EN_PROCESO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.validar(1L);
            assertThat(result.getEstado()).isEqualTo("VALIDADO");
            verify(historialService).create(any(AfHistorial.class));
        }

        @Test
        void lanzaExcepcionSiNoEnProceso() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setEstado("APROBADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));

            assertThatThrownBy(() -> service.validar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }
    }

    @Nested
    class Aprobar {

        @Test
        void apruebaDesdeValidado() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setValorAnterior(new BigDecimal("10000.00"));
            v.setValorNuevo(new BigDecimal("12000.00"));
            v.setEstado("VALIDADO");

            AfMaestro activo = activoValido();
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.aprobar(1L);

            assertThat(result.getEstado()).isEqualTo("APROBADO");
            assertThat(result.getFechaAprobacion()).isNotNull();
            assertThat(result.getAprobadorId()).isEqualTo(10L);
            assertThat(activo.getValorAdquisicion()).isEqualByComparingTo("12000.00");
        }

        @Test
        void apruebaDesdeEnProceso() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setValorAnterior(new BigDecimal("10000.00"));
            v.setValorNuevo(new BigDecimal("12000.00"));
            v.setEstado("EN_PROCESO");

            AfMaestro activo = activoValido();
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.aprobar(1L);
            assertThat(result.getEstado()).isEqualTo("APROBADO");
        }

        @Test
        void lanzaExcepcionSiYaAprobada() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setEstado("APROBADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));

            assertThatThrownBy(() -> service.aprobar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        @Test
        void lanzaExcepcionSiContabilizada() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setEstado("CONTABILIZADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));

            assertThatThrownBy(() -> service.aprobar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }

        @Test
        void actualizaValorResidualSiProvisto() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setValorAnterior(new BigDecimal("10000.00"));
            v.setValorNuevo(new BigDecimal("12000.00"));
            v.setEstado("VALIDADO");
            v.setValorResidual(new BigDecimal("500.00"));

            AfMaestro activo = activoValido();
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.aprobar(1L);
            assertThat(activo.getValorResidual()).isEqualByComparingTo("500.00");
        }

        @Test
        void noActualizaValorResidualSiNull() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setValorAnterior(new BigDecimal("10000.00"));
            v.setValorNuevo(new BigDecimal("10000.00"));
            v.setEstado("VALIDADO");
            v.setValorResidual(null);

            AfMaestro activo = activoValido();
            activo.setValorResidual(new BigDecimal("1000.00"));
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(maestroRepository.findById(5L)).thenReturn(Optional.of(activo));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.aprobar(1L);
            assertThat(activo.getValorResidual()).isEqualByComparingTo("1000.00");
        }
    }

    @Nested
    class Anular {

        @Test
        void anulaValuacionEnProceso() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setEstado("EN_PROCESO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.anular(1L);
            assertThat(result.getEstado()).isEqualTo("ANULADO");
            verify(historialService).create(any(AfHistorial.class));
        }

        @Test
        void anulaValuacionValidada() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setEstado("VALIDADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.anular(1L);
            assertThat(result.getEstado()).isEqualTo("ANULADO");
        }

        @Test
        void anulaValuacionAprobada() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setAfMaestroId(5L);
            v.setEstado("APROBADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfValuacion result = service.anular(1L);
            assertThat(result.getEstado()).isEqualTo("ANULADO");
        }

        @Test
        void lanzaExcepcionSiContabilizada() {
            AfValuacion v = new AfValuacion();
            v.setId(1L);
            v.setEstado("CONTABILIZADO");
            when(repository.findById(1L)).thenReturn(Optional.of(v));

            assertThatThrownBy(() -> service.anular(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_ESTADO_INVALIDO);
        }
    }
}
