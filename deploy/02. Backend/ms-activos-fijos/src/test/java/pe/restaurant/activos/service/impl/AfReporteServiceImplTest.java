package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionAnualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.activos.service.AfReporteCatalogoResolver;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfReporteServiceImplTest {

    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfCalculoCntblRepository calculoRepository;
    @Mock
    private AfMatrizSubClaseRepository matrizRepository;
    @Mock
    private AfSubClaseRepository subClaseRepository;
    @Mock
    private AfReporteCatalogoResolver catalogoResolver;

    @InjectMocks
    private AfReporteServiceImpl service;

    private AfMaestro buildMaestro(Long id, String codigo, Long subClaseId, Long ubicacionId,
                                    BigDecimal valorAdq, String flagEstado) {
        AfMaestro m = new AfMaestro();
        m.setId(id);
        m.setCodigo(codigo);
        m.setNombre("Activo " + codigo);
        m.setAfSubClaseId(subClaseId);
        m.setAfUbicacionId(ubicacionId);
        m.setValorAdquisicion(valorAdq);
        m.setValorResidual(BigDecimal.ZERO);
        m.setFlagEstado(flagEstado);
        m.setFechaAdquisicion(LocalDate.of(2023, 1, 15));
        return m;
    }

    @Nested
    class LibroActivos {

        @Test
        void cuadraTotalesConMotor() {
            AfMaestro m = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");

            AfCalculoCntbl c = new AfCalculoCntbl();
            c.setAnio(2026);
            c.setMes(4);
            c.setDepreciacionAcumulada(new BigDecimal("100.0000"));
            c.setValorNeto(new BigDecimal("900.0000"));

        when(maestroRepository.findAll()).thenReturn(List.of(m));
        when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c));
        when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());
        when(catalogoResolver.monedaDefecto()).thenReturn("PEN");
        when(catalogoResolver.etiquetasCentroCosto(org.mockito.ArgumentMatchers.any())).thenReturn(java.util.Map.of());
        when(catalogoResolver.subClase(10L)).thenReturn(Optional.empty());
            when(maestroRepository.findAll()).thenReturn(List.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c));
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(null, null, null, null, null, null, null);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getTotalValorAdquisicion()).isEqualByComparingTo("1000.0000");
            assertThat(report.getTotalDepreciacionAcumulada()).isEqualByComparingTo("100.0000");
            assertThat(report.getTotalValorNeto()).isEqualByComparingTo("900.0000");
        }

        @Test
        void usaFechaActualCuandoFechaCorteEsNull() {
            when(maestroRepository.findAll()).thenReturn(Collections.emptyList());

            AfReporteLibroResponse report = service.libroActivos(null, null, null, null, null, null, null);

            assertThat(report.getFechaCorte()).isEqualTo(LocalDate.now());
            assertThat(report.getLineas()).isEmpty();
        }

        @Test
        void usaFechaCorteExplicita() {
            LocalDate corte = LocalDate.of(2025, 6, 30);
            when(maestroRepository.findAll()).thenReturn(Collections.emptyList());

            AfReporteLibroResponse report = service.libroActivos(corte, null, null, null, null, null, null);

            assertThat(report.getFechaCorte()).isEqualTo(corte);
        }

        @Test
        void filtraPorSubClaseId() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 20L, 5L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), 10L, null, null, null, null, null);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getAfSubClaseId()).isEqualTo(10L);
        }

        @Test
        void filtraPorUbicacionId() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 10L, 7L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, 5L, null, null, null, null);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getAfUbicacionId()).isEqualTo(5L);
        }

        @Test
        void filtraPorFlagEstado() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 10L, 5L, new BigDecimal("2000.0000"), "0");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, "1", null, null, null);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getFlagEstado()).isEqualTo("1");
        }

        @Test
        void filtraPorValorMin() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("500.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 10L, 5L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(2L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, null, null,
                    new BigDecimal("1000.0000"), null);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getValorAdquisicion()).isEqualByComparingTo("2000.0000");
        }

        @Test
        void filtraPorValorMax() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("500.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 10L, 5L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, null, null,
                    null, new BigDecimal("1000.0000"));

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getValorAdquisicion()).isEqualByComparingTo("500.0000");
        }

        @Test
        void sinCalculoUsaValorAdquisicionComoNeto() {
            AfMaestro m = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("5000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, null, null, null, null);

            assertThat(report.getLineas().getFirst().getDepreciacionAcumulada()).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(report.getLineas().getFirst().getValorNeto()).isEqualByComparingTo("5000.0000");
        }

        @Test
        void calculoConMatrizAsignaCentroCosto() {
            AfMaestro m = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");

            AfMatrizSubClase matriz = new AfMatrizSubClase();
            matriz.setCentroCostoId(99L);

            when(maestroRepository.findAll()).thenReturn(List.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.of(matriz));

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, null, null, null, null);

            assertThat(report.getLineas().getFirst().getCentroCostoId()).isEqualTo(99L);
        }

        @Test
        void lineasOrdenaPorCodigo() {
            AfMaestro m1 = buildMaestro(1L, "AF-002", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-001", 10L, 5L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(2L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.now(), null, null, null, null, null, null);

            assertThat(report.getLineas()).hasSize(2);
            assertThat(report.getLineas().get(0).getCodigo()).isEqualTo("AF-001");
            assertThat(report.getLineas().get(1).getCodigo()).isEqualTo("AF-002");
        }

        @Test
        void calculoFiltradoPorFechaCorte() {
            AfMaestro m = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");

            AfCalculoCntbl futuro = new AfCalculoCntbl();
            futuro.setAnio(2027);
            futuro.setMes(1);
            futuro.setDepreciacionAcumulada(new BigDecimal("500.0000"));
            futuro.setValorNeto(new BigDecimal("500.0000"));

            AfCalculoCntbl pasado = new AfCalculoCntbl();
            pasado.setAnio(2025);
            pasado.setMes(12);
            pasado.setDepreciacionAcumulada(new BigDecimal("200.0000"));
            pasado.setValorNeto(new BigDecimal("800.0000"));

            when(maestroRepository.findAll()).thenReturn(List.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L))
                    .thenReturn(List.of(futuro, pasado));
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.libroActivos(LocalDate.of(2026, 6, 15), null, null, null, null, null, null);

            assertThat(report.getLineas().getFirst().getDepreciacionAcumulada()).isEqualByComparingTo("200.0000");
        }
    }

    @Nested
    class DepreciacionAnual {

        @Test
        void sumaPeriodos() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setCodigo("AF-001");
            m.setValorAdquisicion(new BigDecimal("1200.0000"));
            m.setValorResidual(BigDecimal.ZERO);

            AfCalculoCntbl c1 = new AfCalculoCntbl();
            c1.setId(10L);
            c1.setAnio(2026);
            c1.setMes(1);
            c1.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            c1.setDepreciacionAcumulada(new BigDecimal("100.0000"));
            c1.setValorNeto(new BigDecimal("1100.0000"));

            AfCalculoCntbl c2 = new AfCalculoCntbl();
            c2.setId(11L);
            c2.setAnio(2026);
            c2.setMes(2);
            c2.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            c2.setDepreciacionAcumulada(new BigDecimal("200.0000"));
            c2.setValorNeto(new BigDecimal("1000.0000"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c2, c1));

            AfReporteDepreciacionAnualResponse r = service.depreciacionAnual(1L, 2026);

            assertThat(r.getTotalDepreciacionAnual()).isEqualByComparingTo("200.0000");
            assertThat(r.getMeses()).hasSize(2);
        }

        @Test
        void throwsResourceNotFoundCuandoActivoNoExiste() {
            when(maestroRepository.findById(999L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.depreciacionAnual(999L, 2026))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void sinCalculosDelAnioUsaUltimaDepreciacion() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setCodigo("AF-001");
            m.setValorAdquisicion(new BigDecimal("1200.0000"));
            m.setValorResidual(BigDecimal.ZERO);

            AfCalculoCntbl cOtroAnio = new AfCalculoCntbl();
            cOtroAnio.setId(10L);
            cOtroAnio.setAnio(2025);
            cOtroAnio.setMes(12);
            cOtroAnio.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            cOtroAnio.setDepreciacionAcumulada(new BigDecimal("300.0000"));
            cOtroAnio.setValorNeto(new BigDecimal("900.0000"));

            AfCalculoCntbl ultimoCalc = new AfCalculoCntbl();
            ultimoCalc.setDepreciacionAcumulada(new BigDecimal("300.0000"));
            ultimoCalc.setValorNeto(new BigDecimal("900.0000"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(cOtroAnio));
            when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.of(ultimoCalc));

            AfReporteDepreciacionAnualResponse r = service.depreciacionAnual(1L, 2026);

            assertThat(r.getTotalDepreciacionAnual()).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(r.getMeses()).isEmpty();
            assertThat(r.getDepreciacionAcumuladaFinAnio()).isEqualByComparingTo("300.0000");
            assertThat(r.getValorNetoFinAnio()).isEqualByComparingTo("900.0000");
        }

        @Test
        void sinCalculosYSinUltimaDepUsaValoresBase() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setCodigo("AF-001");
            m.setValorAdquisicion(new BigDecimal("1200.0000"));
            m.setValorResidual(BigDecimal.ZERO);

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(calculoRepository.obtenerUltimaDepreciacion(1L)).thenReturn(Optional.empty());

            AfReporteDepreciacionAnualResponse r = service.depreciacionAnual(1L, 2026);

            assertThat(r.getDepreciacionAcumuladaFinAnio()).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(r.getValorNetoFinAnio()).isEqualByComparingTo("1200.0000");
        }

        @Test
        void mesesSeOrdenanPorMes() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setCodigo("AF-001");
            m.setValorAdquisicion(new BigDecimal("1200.0000"));
            m.setValorResidual(BigDecimal.ZERO);

            AfCalculoCntbl c1 = new AfCalculoCntbl();
            c1.setId(10L);
            c1.setAnio(2026);
            c1.setMes(3);
            c1.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            c1.setDepreciacionAcumulada(new BigDecimal("300.0000"));
            c1.setValorNeto(new BigDecimal("900.0000"));

            AfCalculoCntbl c2 = new AfCalculoCntbl();
            c2.setId(11L);
            c2.setAnio(2026);
            c2.setMes(1);
            c2.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            c2.setDepreciacionAcumulada(new BigDecimal("100.0000"));
            c2.setValorNeto(new BigDecimal("1100.0000"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c1, c2));

            AfReporteDepreciacionAnualResponse r = service.depreciacionAnual(1L, 2026);

            assertThat(r.getMeses().get(0).getMes()).isEqualTo(1);
            assertThat(r.getMeses().get(1).getMes()).isEqualTo(3);
        }

        @Test
        void responseContieneDatosBasicosDelActivo() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setCodigo("AF-001");
            m.setValorAdquisicion(new BigDecimal("1200.0000"));
            m.setValorResidual(new BigDecimal("200.0000"));

            AfCalculoCntbl c = new AfCalculoCntbl();
            c.setId(10L);
            c.setAnio(2026);
            c.setMes(1);
            c.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            c.setDepreciacionAcumulada(new BigDecimal("100.0000"));
            c.setValorNeto(new BigDecimal("1100.0000"));

            when(maestroRepository.findById(1L)).thenReturn(Optional.of(m));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c));

            AfReporteDepreciacionAnualResponse r = service.depreciacionAnual(1L, 2026);

            assertThat(r.getAfMaestroId()).isEqualTo(1L);
            assertThat(r.getCodigoActivo()).isEqualTo("AF-001");
            assertThat(r.getAnio()).isEqualTo(2026);
            assertThat(r.getValorAdquisicion()).isEqualByComparingTo("1200.0000");
            assertThat(r.getValorResidual()).isEqualByComparingTo("200.0000");
        }
    }

    @Nested
    class Consolidado {

        @Test
        void sinClaseIdDevuelveTodosLosActivos() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 20L, 5L, new BigDecimal("2000.0000"), "1");

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(2L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());
            when(matrizRepository.findByAfSubClaseId(20L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.consolidado(LocalDate.now(), null);

            assertThat(report.getLineas()).hasSize(2);
            assertThat(report.getTotalValorAdquisicion()).isEqualByComparingTo("3000.0000");
        }

        @Test
        void conClaseIdFiltraPorSubClases() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 20L, 5L, new BigDecimal("2000.0000"), "1");

            AfSubClase sub10 = new AfSubClase();
            sub10.setId(10L);
            sub10.setAfClaseId(100L);

            AfSubClase sub20 = new AfSubClase();
            sub20.setId(20L);
            sub20.setAfClaseId(200L);

            when(subClaseRepository.findAll()).thenReturn(List.of(sub10, sub20));
            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(Collections.emptyList());
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.consolidado(LocalDate.now(), 100L);

            assertThat(report.getLineas()).hasSize(1);
            assertThat(report.getLineas().getFirst().getAfSubClaseId()).isEqualTo(10L);
        }

        @Test
        void usaFechaActualSiFechaCorteEsNull() {
            when(maestroRepository.findAll()).thenReturn(Collections.emptyList());

            AfReporteLibroResponse report = service.consolidado(null, null);

            assertThat(report.getFechaCorte()).isEqualTo(LocalDate.now());
        }

        @Test
        void totalesAcumulanCorrectamente() {
            AfMaestro m1 = buildMaestro(1L, "AF-001", 10L, 5L, new BigDecimal("1000.0000"), "1");
            AfMaestro m2 = buildMaestro(2L, "AF-002", 10L, 5L, new BigDecimal("3000.0000"), "1");

            AfCalculoCntbl c1 = new AfCalculoCntbl();
            c1.setAnio(2026);
            c1.setMes(1);
            c1.setDepreciacionAcumulada(new BigDecimal("100.0000"));
            c1.setValorNeto(new BigDecimal("900.0000"));

            AfCalculoCntbl c2 = new AfCalculoCntbl();
            c2.setAnio(2026);
            c2.setMes(1);
            c2.setDepreciacionAcumulada(new BigDecimal("300.0000"));
            c2.setValorNeto(new BigDecimal("2700.0000"));

            when(maestroRepository.findAll()).thenReturn(List.of(m1, m2));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(1L)).thenReturn(List.of(c1));
            when(calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(2L)).thenReturn(List.of(c2));
            when(matrizRepository.findByAfSubClaseId(10L)).thenReturn(Optional.empty());

            AfReporteLibroResponse report = service.consolidado(LocalDate.of(2026, 6, 30), null);

            assertThat(report.getTotalValorAdquisicion()).isEqualByComparingTo("4000.0000");
            assertThat(report.getTotalDepreciacionAcumulada()).isEqualByComparingTo("400.0000");
            assertThat(report.getTotalValorNeto()).isEqualByComparingTo("3600.0000");
        }
    }
}
