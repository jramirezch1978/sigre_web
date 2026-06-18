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
import org.springframework.http.HttpStatus;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.DepreciacionService;
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
class AfCalculoCntblServiceImplTest {

    @Mock
    private AfCalculoCntblRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfSubClaseRepository subClaseRepository;
    @Mock
    private AfClaseRepository claseRepository;
    @Mock
    private DepreciacionService depreciacionService;
    @Mock
    private AfVentaRepository ventaRepository;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @InjectMocks
    private AfCalculoCntblServiceImpl service;

    @BeforeEach
    void setTenant() {
        TenantContext.setUsuarioId(99L);
        lenient().when(ventaRepository.existsByAfMaestroId(anyLong())).thenReturn(false);
    }

    @AfterEach
    void clearTenant() {
        TenantContext.clear();
    }

    private static AfMaestro maestroActivo(Long id) {
        AfMaestro m = new AfMaestro();
        m.setId(id);
        m.setCodigo("A-" + id);
        m.setNombre("Activo " + id);
        m.setAfSubClaseId(10L);
        m.setFechaAdquisicion(LocalDate.of(2023, 1, 15));
        m.setValorAdquisicion(new BigDecimal("12000.00"));
        m.setValorResidual(BigDecimal.ZERO);
        m.setFlagEstado(ActivosFlagEstado.ACTIVO);
        return m;
    }

    private AfSubClase subClaseBase() {
        AfSubClase sub = new AfSubClase();
        sub.setId(10L);
        sub.setAfClaseId(5L);
        sub.setVidaUtilMeses(120);
        return sub;
    }

    private AfClase claseLineal() {
        AfClase clase = new AfClase();
        clase.setId(5L);
        clase.setMetodoDepreciacion("LINEAL");
        clase.setVidaUtilMeses(120);
        return clase;
    }

    @Nested
    class FindAll {

        @Test
        void retornaPaginaDeCalculos() {
            AfCalculoCntbl c = new AfCalculoCntbl();
            c.setId(1L);
            Page<AfCalculoCntbl> page = new PageImpl<>(List.of(c));
            when(repository.findAll(any(Pageable.class))).thenReturn(page);

            Page<AfCalculoCntbl> result = service.findAll(PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }

    @Nested
    class FindById {

        @Test
        void retornaCalculoExistente() {
            AfCalculoCntbl c = new AfCalculoCntbl();
            c.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(c));

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
    class Create {

        @Test
        void creaCalculoExitosamente() {
            AfCalculoCntbl entity = new AfCalculoCntbl();
            entity.setAfMaestroId(1L);
            entity.setAnio(2024);
            entity.setMes(6);
            entity.setDepreciacionPeriodo(new BigDecimal("100.00"));

            when(repository.existsByAfMaestroIdAndAnioAndMes(1L, 2024, 6)).thenReturn(false);
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(1L);
                return c;
            });

            AfCalculoCntbl result = service.create(entity);
            assertThat(result.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        void lanzaExcepcionSiPeriodoDuplicado() {
            AfCalculoCntbl entity = new AfCalculoCntbl();
            entity.setAfMaestroId(1L);
            entity.setAnio(2024);
            entity.setMes(6);

            when(repository.existsByAfMaestroIdAndAnioAndMes(1L, 2024, 6)).thenReturn(true);

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.DEPRECIACION_DUPLICADA);
        }
    }

    @Nested
    class Update {

        @Test
        void actualizaCalculoExitosamente() {
            AfCalculoCntbl existing = new AfCalculoCntbl();
            existing.setId(1L);
            existing.setAfMaestroId(1L);
            existing.setAnio(2024);
            existing.setMes(6);

            AfCalculoCntbl updated = new AfCalculoCntbl();
            updated.setAfMaestroId(1L);
            updated.setAnio(2024);
            updated.setMes(6);
            updated.setDepreciacionPeriodo(new BigDecimal("200.00"));
            updated.setDepreciacionAcumulada(new BigDecimal("1200.00"));
            updated.setValorNeto(new BigDecimal("10800.00"));

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfCalculoCntbl result = service.update(1L, updated);
            assertThat(result.getDepreciacionPeriodo()).isEqualByComparingTo("200.00");
        }

        @Test
        void validaDuplicadoSiCambiaPeriodo() {
            AfCalculoCntbl existing = new AfCalculoCntbl();
            existing.setId(1L);
            existing.setAfMaestroId(1L);
            existing.setAnio(2024);
            existing.setMes(6);

            AfCalculoCntbl updated = new AfCalculoCntbl();
            updated.setAfMaestroId(1L);
            updated.setAnio(2024);
            updated.setMes(7);

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByAfMaestroIdAndAnioAndMes(1L, 2024, 7)).thenReturn(true);

            assertThatThrownBy(() -> service.update(1L, updated))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.DEPRECIACION_DUPLICADA);
        }
    }

    @Nested
    class Delete {

        @Test
        void eliminaCalculoExistente() {
            AfCalculoCntbl existing = new AfCalculoCntbl();
            existing.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(existing));

            service.delete(1L);
            verify(repository).delete(existing);
        }
    }

    @Nested
    class ObtenerHistorialPorActivo {

        @Test
        void retornaHistorial() {
            when(repository.obtenerHistorialDepreciacion(1L)).thenReturn(List.of(new AfCalculoCntbl()));
            assertThat(service.obtenerHistorialPorActivo(1L)).hasSize(1);
        }
    }

    @Nested
    class ObtenerPorPeriodo {

        @Test
        void retornaDepreciacionesDelPeriodo() {
            when(repository.obtenerDepreciacionPorPeriodo(2024, 6)).thenReturn(List.of(new AfCalculoCntbl()));
            assertThat(service.obtenerPorPeriodo(2024, 6)).hasSize(1);
        }
    }

    @Nested
    class CalcularDepreciacionMensual {

        @Test
        void calculaLinealExitosamente() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);

            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(claseLineal()));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());
            when(depreciacionService.calcularDepreciacionLineal(eq(activo), eq(120), anyInt()))
                    .thenReturn(new BigDecimal("100.0000"));
            when(repository.save(any(AfCalculoCntbl.class))).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(500L);
                return c;
            });

            AfCalculoCntbl result = service.calcularDepreciacionMensual(maestroId, 2024, 6, null);

            assertThat(result.getId()).isEqualTo(500L);
            assertThat(result.getDepreciacionPeriodo()).isEqualByComparingTo("100.0000");
            verify(depreciacionService).calcularDepreciacionLineal(eq(activo), eq(120), anyInt());
        }

        @Test
        void calculaAcelerada() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("ACELERADA");
            clase.setVidaUtilMeses(120);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());
            when(depreciacionService.calcularDepreciacionAcelerada(eq(activo), eq(120), any()))
                    .thenReturn(new BigDecimal("200.0000"));
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(501L);
                return c;
            });

            AfCalculoCntbl result = service.calcularDepreciacionMensual(maestroId, 2024, 6, null);
            assertThat(result.getDepreciacionPeriodo()).isEqualByComparingTo("200.0000");
        }

        @Test
        void calculaUnidadesProducidasConOverride() {
            Long maestroId = 3L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);

            AfMaestro activo = maestroActivo(maestroId);
            activo.setUnidadesProduccionTotales(1000);
            activo.setUnidadesProduccionPeriodo(1);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("UNIDADES_PRODUCIDAS");
            clase.setVidaUtilMeses(120);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());
            when(depreciacionService.calcularDepreciacionUnidadesProduccion(eq(activo), eq(1000), eq(77)))
                    .thenReturn(new BigDecimal("50.0000"));
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(502L);
                return c;
            });

            service.calcularDepreciacionMensual(maestroId, 2024, 6, 77);
            verify(depreciacionService).calcularDepreciacionUnidadesProduccion(activo, 1000, 77);
        }

        @Test
        void lanzaExcepcionSiUnidadesTotalesNulas() {
            Long maestroId = 2L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);

            AfMaestro activo = maestroActivo(maestroId);
            activo.setUnidadesProduccionTotales(null);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("UNIDADES_PRODUCIDAS");
            clase.setVidaUtilMeses(120);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS);
        }

        @Test
        void lanzaExcepcionSiUnidadesTotalesCero() {
            Long maestroId = 2L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setUnidadesProduccionTotales(0);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("UNIDADES_PRODUCIDAS");
            clase.setVidaUtilMeses(120);
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS);
        }

        @Test
        void lanzaExcepcionSiUnidadesPeriodoNulasYSinOverride() {
            Long maestroId = 2L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setUnidadesProduccionTotales(1000);
            activo.setUnidadesProduccionPeriodo(null);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("UNIDADES_PRODUCIDAS");
            clase.setVidaUtilMeses(120);
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.UNIDADES_PRODUCCION_INCOMPLETAS);
        }

        @Test
        void lanzaConflictoSiPeriodoDuplicado() {
            when(repository.existsByAfMaestroIdAndAnioAndMes(9L, 2024, 6)).thenReturn(true);

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(9L, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("status", HttpStatus.CONFLICT)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.DEPRECIACION_DUPLICADA);
        }

        @Test
        void lanzaExcepcionSiPeriodoFuturo() {
            int anioFuturo = LocalDate.now().getYear() + 1;
            assertThatThrownBy(() -> service.calcularDepreciacionMensual(1L, anioFuturo, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PERIODO_FUTURO_NO_PERMITIDO);
        }

        @Test
        void lanzaExcepcionSiActivoInactivo() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setFlagEstado("0");
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_INACTIVO_DEPRECIACION);
        }

        @Test
        void lanzaExcepcionSiActivoDadoDeBaja() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setFlagEstado("0");
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_INACTIVO_DEPRECIACION);
        }

        @Test
        void lanzaExcepcionSiActivoTieneVenta() {
            Long maestroId = 77L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            when(ventaRepository.existsByAfMaestroId(maestroId)).thenReturn(true);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }

        @Test
        void lanzaExcepcionSiMetodoDepreciacionNulo() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion(null);
            clase.setVidaUtilMeses(120);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_SIN_METODO_DEPRECIACION);
        }

        @Test
        void lanzaExcepcionSiMetodoDepreciacionBlanco() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("   ");
            clase.setVidaUtilMeses(120);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_SIN_METODO_DEPRECIACION);
        }

        @Test
        void lanzaExcepcionSiMetodoNoSoportado() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));

            AfClase clase = new AfClase();
            clase.setId(5L);
            clase.setMetodoDepreciacion("SUMA_DIGITOS");
            clase.setVidaUtilMeses(120);
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("no soportado");
        }

        @Test
        void lanzaExcepcionSiVidaUtilNula() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            sub.setVidaUtilMeses(null);
            AfClase clase = claseLineal();
            clase.setVidaUtilMeses(null);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("vida útil");
        }

        @Test
        void lanzaExcepcionSiVidaUtilCero() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            sub.setVidaUtilMeses(0);
            AfClase clase = claseLineal();
            clase.setVidaUtilMeses(0);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void lanzaExcepcionSiPeriodoAnteriorAAdquisicion() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2022, 1)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(claseLineal()));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2022, 1, null))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("anterior a la adquisición");
        }

        @Test
        void lanzaExcepcionSiActivoCompletamenteDepreciado() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setValorResidual(new BigDecimal("1000.00"));
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(claseLineal()));

            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setValorNeto(new BigDecimal("1000.00"));
            ultimaDep.setDepreciacionAcumulada(new BigDecimal("11000.00"));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.of(ultimaDep));

            assertThatThrownBy(() -> service.calcularDepreciacionMensual(maestroId, 2024, 6, null))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_COMPLETAMENTE_DEPRECIADO);
        }

        @Test
        void ajustaDepreciacionCuandoSuperaValorResidual() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            activo.setValorResidual(new BigDecimal("1000.00"));
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(claseLineal()));

            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setValorNeto(new BigDecimal("1050.00"));
            ultimaDep.setDepreciacionAcumulada(new BigDecimal("10950.00"));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.of(ultimaDep));
            when(depreciacionService.calcularDepreciacionLineal(any(), anyInt(), anyInt()))
                    .thenReturn(new BigDecimal("100.00"));
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(600L);
                return c;
            });

            AfCalculoCntbl result = service.calcularDepreciacionMensual(maestroId, 2024, 6, null);
            assertThat(result.getValorNeto()).isEqualByComparingTo("1000.00");
            assertThat(result.getDepreciacionPeriodo()).isEqualByComparingTo("50.00");
        }

        @Test
        void usaVidaUtilDeClaseSiSubClaseEsNull() {
            Long maestroId = 1L;
            when(repository.existsByAfMaestroIdAndAnioAndMes(maestroId, 2024, 6)).thenReturn(false);
            AfMaestro activo = maestroActivo(maestroId);
            when(maestroRepository.findById(maestroId)).thenReturn(Optional.of(activo));

            AfSubClase sub = subClaseBase();
            sub.setVidaUtilMeses(null);
            AfClase clase = claseLineal();
            clase.setVidaUtilMeses(60);

            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(sub));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(clase));
            when(repository.obtenerUltimaDepreciacion(maestroId)).thenReturn(Optional.empty());
            when(depreciacionService.calcularDepreciacionLineal(eq(activo), eq(60), anyInt()))
                    .thenReturn(new BigDecimal("200.00"));
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(700L);
                return c;
            });

            service.calcularDepreciacionMensual(maestroId, 2024, 6, null);
            verify(depreciacionService).calcularDepreciacionLineal(eq(activo), eq(60), anyInt());
        }
    }

    @Nested
    class CalcularDepreciacionMasiva {

        @Test
        void soloConsultaActivosActivos() {
            when(maestroRepository.findByFlagEstado(ActivosFlagEstado.ACTIVO, Pageable.unpaged()))
                    .thenReturn(new PageImpl<>(List.of()));

            assertThat(service.calcularDepreciacionMasiva(2024, 6)).isEmpty();
            verify(maestroRepository).findByFlagEstado(ActivosFlagEstado.ACTIVO, Pageable.unpaged());
        }

        @Test
        void omiteActivosDadosDeBaja() {
            AfMaestro a = maestroActivo(11L);
            a.setFlagEstado("0");
            when(maestroRepository.findByFlagEstado(eq(ActivosFlagEstado.ACTIVO), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(a)));

            assertThat(service.calcularDepreciacionMasiva(2024, 6)).isEmpty();
            verify(repository, never()).save(any());
        }

        @Test
        void omiteSiYaExistePeriodo() {
            AfMaestro a = maestroActivo(11L);
            when(maestroRepository.findByFlagEstado(eq(ActivosFlagEstado.ACTIVO), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(a)));
            when(repository.existsByAfMaestroIdAndAnioAndMes(11L, 2024, 6)).thenReturn(true);

            assertThat(service.calcularDepreciacionMasiva(2024, 6)).isEmpty();
            verify(repository, never()).save(any());
        }

        @Test
        void continuaSiUnActivoLanzaBusinessException() {
            AfMaestro a1 = maestroActivo(1L);
            AfMaestro a2 = maestroActivo(2L);
            when(maestroRepository.findByFlagEstado(eq(ActivosFlagEstado.ACTIVO), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(a1, a2)));
            when(repository.existsByAfMaestroIdAndAnioAndMes(1L, 2024, 6)).thenReturn(false);
            when(repository.existsByAfMaestroIdAndAnioAndMes(2L, 2024, 6)).thenReturn(true);
            when(maestroRepository.findById(1L)).thenReturn(Optional.of(a1));
            when(ventaRepository.existsByAfMaestroId(1L)).thenReturn(true);

            List<AfCalculoCntbl> results = service.calcularDepreciacionMasiva(2024, 6);
            assertThat(results).isEmpty();
        }

        @Test
        void continuaSiUnActivoLanzaExcepcionInesperada() {
            AfMaestro a1 = maestroActivo(1L);
            AfMaestro a2 = maestroActivo(2L);
            when(maestroRepository.findByFlagEstado(eq(ActivosFlagEstado.ACTIVO), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(a1, a2)));
            when(repository.existsByAfMaestroIdAndAnioAndMes(anyLong(), eq(2024), eq(6))).thenReturn(false);
            when(maestroRepository.findById(1L)).thenThrow(new RuntimeException("unexpected"));
            when(maestroRepository.findById(2L)).thenReturn(Optional.of(a2));
            when(subClaseRepository.findById(10L)).thenReturn(Optional.of(subClaseBase()));
            when(claseRepository.findById(5L)).thenReturn(Optional.of(claseLineal()));
            when(repository.obtenerUltimaDepreciacion(2L)).thenReturn(Optional.empty());
            when(depreciacionService.calcularDepreciacionLineal(any(), anyInt(), anyInt()))
                    .thenReturn(new BigDecimal("100.00"));
            when(repository.save(any())).thenAnswer(inv -> {
                AfCalculoCntbl c = inv.getArgument(0);
                c.setId(800L);
                return c;
            });

            List<AfCalculoCntbl> results = service.calcularDepreciacionMasiva(2024, 6);
            assertThat(results).hasSize(1);
        }

        @Test
        void lanzaExcepcionSiPeriodoFuturo() {
            int anioFuturo = LocalDate.now().getYear() + 1;
            assertThatThrownBy(() -> service.calcularDepreciacionMasiva(anioFuturo, 6))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PERIODO_FUTURO_NO_PERMITIDO);
        }
    }
}
