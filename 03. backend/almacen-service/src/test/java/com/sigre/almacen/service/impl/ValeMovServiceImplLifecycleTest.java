package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.domain.ValeMovFlagEstado;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.*;
import com.sigre.almacen.repository.*;
import com.sigre.almacen.service.EmpresaInfoService;
import com.sigre.almacen.support.UsuarioResumenLoader;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.service.NumeradorDocumentoService;

import java.io.ByteArrayInputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.almacen.TestDataFactory.*;

/**
 * Cobertura de listar, confirmar, actualizar, devoluciones, export Excel y PDF.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ValeMovServiceImplLifecycleTest {

    @Mock private ValeMovRepository valeMovRepository;
    @Mock private ArticuloMovTipoRepository articuloMovTipoRepository;
    @Mock private AlmacenRepository almacenRepository;
    @Mock private AlmacenTipoMovRepository almacenTipoMovRepository;
    @Mock private UbicacionAlmacenRepository ubicacionAlmacenRepository;
    @Mock private ArticuloAlmacenRepository articuloAlmacenRepository;
    @Mock private ArticuloAlmacenPosicionRepository articuloAlmacenPosicionRepository;
    @Mock private ArticuloSaldoMensualRepository articuloSaldoMensualRepository;
    @Mock private CntblCierreRepository cntblCierreRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private ArticuloSubCategRefRepository articuloSubCategRefRepository;
    @Mock private TipoMovMatrizSubcatRepository tipoMovMatrizSubcatRepository;
    @Mock private OrdenTrasladoRepository ordenTrasladoRepository;
    @Mock private GuiaRepository guiaRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private SucursalRefRepository sucursalRefRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private EmpresaInfoService empresaInfoService;
    @Mock private UsuarioResumenLoader usuarioResumenLoader;
    @Mock private com.sigre.almacen.event.publisher.AlmacenPreAsientoPublisher preAsientoPublisher;

    @InjectMocks
    private ValeMovServiceImpl service;

    @BeforeEach
    void baseStubs() {
        when(usuarioResumenLoader.loadByIds(any())).thenReturn(Map.of());
        when(jdbcTemplate.queryForList(anyString(), any(Object.class))).thenReturn(List.of());
    }

    @Nested
    @DisplayName("listar / obtener")
    class ListarObtener {

        @Test
        void listar_delegaSpecificationYPageable() {
            ValeMov mov = valeMovConLinea(1L, 100L);
            Page<ValeMov> page = new PageImpl<>(List.of(mov));
            when(valeMovRepository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

            Page<MovimientoListItemResponse> out = service.listar(
                    1L, 10L, 2L, "ACTIVO",
                    LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31),
                    50L, 60L, "I", Pageable.unpaged());

            assertThat(out.getContent()).hasSize(1);
            assertThat(out.getContent().get(0).getId()).isEqualTo(1L);

            ArgumentCaptor<Specification<ValeMov>> specCap = ArgumentCaptor.forClass(Specification.class);
            verify(valeMovRepository).findAll(specCap.capture(), any(Pageable.class));
            assertThat(specCap.getValue()).isNotNull();
        }

        @Test
        void obtener_retornaDetalle() {
            ValeMov mov = valeMovConLinea(5L, 100L);
            when(valeMovRepository.findById(5L)).thenReturn(Optional.of(mov));

            MovimientoDetalleResponse out = service.obtener(5L);

            assertThat(out.getId()).isEqualTo(5L);
            assertThat(out.getLineas()).isNotEmpty();
        }
    }

    @Nested
    @DisplayName("confirmar")
    class Confirmar {

        @Test
        void confirmar_activo_ok() {
            ValeMov mov = valeMovConLinea(1L, 100L);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(articuloMovTipoIngreso(1L)));
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(anyLong(), anyLong()))
                    .thenReturn(Optional.of(articuloAlmacenDefault()));
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(i -> i.getArgument(0));

            MovimientoConfirmarRequest req = new MovimientoConfirmarRequest();
            req.setId(1L);
            req.setObservacion("OK confirmado");

            MovimientoDetalleResponse out = service.confirmar(req);

            assertThat(out.getObservaciones()).contains("OK confirmado");
            verify(valeMovRepository).save(mov);
        }

        @Test
        void confirmar_noActivo_lanzaError() {
            ValeMov mov = valeMov(1L);
            mov.setFlagEstado(ValeMovFlagEstado.ANULADO);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));

            MovimientoConfirmarRequest req = new MovimientoConfirmarRequest();
            req.setId(1L);

            assertThatThrownBy(() -> service.confirmar(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SOLO_CONFIRMABLE_ACTIVO);
        }
    }

    @Nested
    @DisplayName("actualizar")
    class Actualizar {

        @Test
        void actualizar_noActivo_lanzaError() {
            ValeMov mov = valeMov(1L);
            mov.setFlagEstado(ValeMovFlagEstado.CERRADO);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));

            assertThatThrownBy(() -> service.actualizar(1L, movimientoCabeceraRequest()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SOLO_EDITABLE_ACTIVO);
        }

        @Test
        void actualizar_activo_cambiaCantidad() {
            ValeMov mov = valeMovConLinea(1L, 100L);
            mov.getLineas().get(0).setId(500L);
            mov.setArticuloMovTipoId(1L);
            mov.setAlmacenId(10L);
            mov.setSucursalId(1L);
            mov.setFechaMov(LocalDate.of(2026, 4, 17));
            ArticuloMovTipo tipo = articuloMovTipoIngreso(1L);
            tipo.setFlagSolicitaRef("0");
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipo));
            when(almacenRepository.existsById(10L)).thenReturn(true);
            when(almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(10L, 1L, "1"))
                    .thenReturn(true);
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(eq(10L), eq(100L)))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5.00"))));
            when(articuloAlmacenRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(articuloSaldoMensualRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(valeMovRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            MovimientoCabeceraRequest req = movimientoCabeceraRequest();
            MovimientoLineaRequest lr = req.getLineas().get(0);
            lr.setId(500L);
            lr.setArticuloId(100L);
            lr.setMonedaId(1L);
            lr.setCantProcesada(new BigDecimal("8"));
            lr.setCostoUnitario(new BigDecimal("5.00"));

            MovimientoDetalleResponse out = service.actualizar(1L, req);

            assertThat(out).isNotNull();
            assertThat(mov.getLineas().get(0).getCantProcesada()).isEqualByComparingTo("8");
        }
    }

    @Nested
    @DisplayName("devoluciones")
    class Devoluciones {

        @Test
        void obtenerDevolvible_conSaldoPendiente() {
            ValeMov mov = valeMovConLinea(10L, 100L);
            mov.setNroVale("VALE-10");
            ArticuloMovTipo tipo = articuloMovTipoConDevolucion(1L, "DEV01");
            when(valeMovRepository.findById(10L)).thenReturn(Optional.of(mov));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipo));
            when(valeMovRepository.sumCantDevueltaPorArticulo(10L, 100L)).thenReturn(BigDecimal.ZERO);

            DevolvibleResponse out = service.obtenerDevolvible(10L);

            assertThat(out.getValeMovId()).isEqualTo(10L);
            assertThat(out.getLineas()).hasSize(1);
            assertThat(out.getLineas().get(0).getCantDevolvible()).isEqualByComparingTo("10");
        }

        @Test
        void obtenerDevolvible_tipoSinDevolucion_lanzaError() {
            ValeMov mov = valeMovConLinea(10L, 100L);
            ArticuloMovTipo tipo = articuloMovTipoIngreso(1L);
            tipo.setTipoMovDev(null);
            when(valeMovRepository.findById(10L)).thenReturn(Optional.of(mov));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipo));

            assertThatThrownBy(() -> service.obtenerDevolvible(10L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.TIPO_SIN_DEVOLUCION);
        }

        @Test
        void crearDevolucion_ok() {
            ValeMov origen = valeMovConLinea(20L, 100L);
            origen.setArticuloMovTipoId(1L);
            origen.setAlmacenId(10L);
            origen.setNroVale("VALE-ORIGEN");

            ArticuloMovTipo tipoOrigen = articuloMovTipoConDevolucion(1L, "DEV01");
            ArticuloMovTipo tipoDev = articuloMovTipoDevolucion("DEV01");
            tipoDev.setId(2L);

            when(valeMovRepository.findById(20L)).thenReturn(Optional.of(origen));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoOrigen));
            when(articuloMovTipoRepository.findByTipoMov("DEV01")).thenReturn(Optional.of(tipoDev));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.sumCantDevueltaPorArticulo(20L, 100L)).thenReturn(BigDecimal.ZERO);
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(anyLong(), anyLong()))
                    .thenReturn(Optional.of(articuloAlmacenDefault()));
            when(articuloAlmacenRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(articuloSaldoMensualRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                    .thenReturn("VALE-DEV-001");
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(inv -> {
                ValeMov v = inv.getArgument(0);
                v.setId(21L);
                return v;
            });

            DevolucionRequest req = new DevolucionRequest();
            req.setValeMovOrigenId(20L);
            req.setSucursalId(1L);
            req.setFechaMov(LocalDate.of(2026, 5, 10));
            DevolucionLineaRequest linea = new DevolucionLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantDevolver(new BigDecimal("3"));
            req.setLineas(List.of(linea));

            MovimientoDetalleResponse out = service.crearDevolucion(req);

            assertThat(out.getId()).isEqualTo(21L);
            verify(valeMovRepository).save(argThat(v -> v.getValeMovOrigId().equals(20L)));
        }

        @Test
        void crearDevolucion_excedeCantidad_lanzaError() {
            ValeMov origen = valeMovConLinea(20L, 100L);
            origen.setArticuloMovTipoId(1L);
            when(valeMovRepository.findById(20L)).thenReturn(Optional.of(origen));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(articuloMovTipoConDevolucion(1L, "DEV01")));
            when(articuloMovTipoRepository.findByTipoMov("DEV01"))
                    .thenReturn(Optional.of(articuloMovTipoDevolucion("DEV01")));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.sumCantDevueltaPorArticulo(20L, 100L)).thenReturn(new BigDecimal("8"));

            DevolucionRequest req = new DevolucionRequest();
            req.setValeMovOrigenId(20L);
            req.setSucursalId(1L);
            req.setFechaMov(LocalDate.now());
            DevolucionLineaRequest linea = new DevolucionLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantDevolver(new BigDecimal("5"));
            req.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crearDevolucion(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.CANTIDAD_DEVOLUCION_EXCEDIDA);
        }
    }

    @Nested
    @DisplayName("exportarExcel / generarPdf")
    class ExportPdf {

        @Test
        void exportarExcel_generaBytesConCabecera() {
            ValeMov mov = valeMov(1L);
            mov.setProveedorId(99L);
            mov.setTipoReferenciaOrigen("I");
            mov.setObservaciones("Test export");
            when(valeMovRepository.findAll(any(Specification.class))).thenReturn(List.of(mov));

            byte[] bytes = service.exportarExcel(1L, 10L, 2L, "1",
                    LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31));

            assertThat(bytes.length).isGreaterThan(100);
            assertThat(bytes[0]).isEqualTo((byte) 0x50);
        }

        @Test
        void exportarExcel_listaVacia_ok() {
            when(valeMovRepository.findAll(any(Specification.class))).thenReturn(List.of());

            byte[] bytes = service.exportarExcel(null, null, null, null, null, null);

            assertThat(bytes).isNotEmpty();
        }

        @Test
        void generarPdf_valeConLinea_generaPdf() {
            ValeMov mov = valeMovConLinea(7L, 100L);
            mov.setArticuloMovTipoId(1L);
            mov.setAlmacenId(10L);
            mov.setSucursalId(1L);
            mov.setNroVale("VALE-PDF");

            when(valeMovRepository.findById(7L)).thenReturn(Optional.of(mov));
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(articuloMovTipoIngreso(1L)));
            when(almacenRepository.findById(10L)).thenReturn(Optional.of(almacen(10L)));
            when(sucursalRefRepository.findById(1L)).thenReturn(Optional.of(new SucursalRef()));
            ArticuloRef art = org.mockito.Mockito.mock(ArticuloRef.class);
            when(art.getCodigo()).thenReturn("ART-100");
            when(art.getNombre()).thenReturn("Artículo test");
            when(art.getUnidadMedidaId()).thenReturn(null);
            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(art));
            when(empresaInfoService.obtener(any())).thenReturn(
                    new EmpresaInfoService.EmpresaInfo("Empresa Test", "20123456789", "Lima", null,
                            new ByteArrayInputStream(new byte[0])));

            byte[] pdf = service.generarPdf(7L);

            assertThat(pdf.length).isGreaterThan(100);
            assertThat(pdf[0]).isEqualTo((byte) '%');
            assertThat(pdf[1]).isEqualTo((byte) 'P');
        }

        @Test
        void generarPdf_valeInexistente_lanzaError() {
            when(valeMovRepository.findById(404L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.generarPdf(404L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("status", HttpStatus.NOT_FOUND);
        }
    }
}
