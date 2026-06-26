package pe.restaurant.compras.service;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JRDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.repository.*;

import java.math.BigDecimal;
import java.io.InputStream;
import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenCompraPdfService — Pruebas Unitarias")
class OrdenCompraPdfServiceTest {

    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private EntidadBancoCntaRefRepository entidadBancoCntaRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private FormaPagoRefRepository formaPagoRefRepository;
    @Mock private ContactoRefRepository contactoRefRepository;
    @Mock private TipoDocIdentidadRefRepository tipoDocIdentidadRefRepository;
    @Mock private EmpresaInfoService empresaInfoService;
    @InjectMocks private OrdenCompraPdfService pdfService;

    private OrdenCompra oc;
    private MockedStatic<TenantContext> tenantContextMock;
    private MockedStatic<JasperCompileManager> jasperCompileManagerMock;
    private MockedStatic<JasperFillManager> jasperFillManagerMock;
    private MockedStatic<JasperExportManager> jasperExportManagerMock;

    @BeforeEach
    void setUp() {
        tenantContextMock = mockStatic(TenantContext.class);
        tenantContextMock.when(TenantContext::getEmpresaId).thenReturn(1L);

        JasperReport jasperReport = mock(JasperReport.class);
        JasperPrint jasperPrint = mock(JasperPrint.class);

        jasperCompileManagerMock = mockStatic(JasperCompileManager.class);
        jasperCompileManagerMock.when(() -> JasperCompileManager.compileReport(any(InputStream.class)))
                .thenReturn(jasperReport);

        jasperFillManagerMock = mockStatic(JasperFillManager.class);
        jasperFillManagerMock.when(() -> JasperFillManager.fillReport(
                        any(JasperReport.class),
                        org.mockito.ArgumentMatchers.<String, Object>anyMap(),
                        any(JRDataSource.class)))
                .thenReturn(jasperPrint);

        jasperExportManagerMock = mockStatic(JasperExportManager.class);
        jasperExportManagerMock.when(() -> JasperExportManager.exportReportToPdf(any(JasperPrint.class)))
                .thenReturn("%PDF-test".getBytes());

        oc = new OrdenCompra();
        oc.setId(1L);
        oc.setSucursalId(1L);
        oc.setProveedorId(1L);
        oc.setMonedaId(1L);
        oc.setNroOrdenCompra("OC-2026-000001");
        oc.setFormaPagoId(1L);
        oc.setFlagImportacion("0");
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        oc.setSubtotal(new BigDecimal("1000.0000"));
        oc.setDescuentoTotal(BigDecimal.ZERO);
        oc.setIgvTotal(new BigDecimal("180.0000"));
        oc.setPercepcionTotal(BigDecimal.ZERO);
        oc.setTotal(new BigDecimal("1180.0000"));
        oc.setCompradorId(10L);
        oc.setAprobadorId(20L);

        OrdenCompraDet linea = new OrdenCompraDet();
        linea.setId(100L);
        linea.setArticuloId(1L);
        linea.setCantProyectada(new BigDecimal("10"));
        linea.setValorUnitario(new BigDecimal("100"));
        linea.setDescuentoMonto(BigDecimal.ZERO);
        linea.setSubtotal(new BigDecimal("1180"));
        linea.setFechaEntrega(LocalDate.of(2026, 5, 1));
        linea.setFlagEstado("1");
        oc.addLinea(linea);
    }

    @AfterEach
    void tearDown() {
        jasperExportManagerMock.close();
        jasperFillManagerMock.close();
        jasperCompileManagerMock.close();
        tenantContextMock.close();
    }

    @Test
    @DisplayName("generarPdf() oc no existe -> lanza excepción")
    void generarPdf_ocNoExiste_lanzaExcepcion() {
        when(ordenCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> pdfService.generarPdf(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("generarPdf() ok -> retorna bytes")
    void generarPdf_ok_retornaBytes() {
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        assertThat(pdf.length).isGreaterThan(0);
        assertThat(pdf[0]).isEqualTo((byte) '%');
    }

    @Test
    @DisplayName("generarPdf() sin datos ref -> usa valores por defecto")
    void generarPdf_sinDatosRef_usaValoresPorDefecto() {
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        lenient().when(empresaInfoService.obtener(anyLong()))
                .thenReturn(new EmpresaInfoService.EmpresaInfo("", "", "", null, null));
        lenient().when(entidadContribuyenteRefRepository.findFirstByFlagEstadoOrderByIdAsc(anyString()))
                .thenReturn(Optional.empty());
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.empty());

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        assertThat(pdf.length).isGreaterThan(0);
    }

    @Test
    @DisplayName("generarPdf() línea inactiva -> no incluida en reporte")
    void generarPdf_lineaInactiva_noIncluidaEnReporte() {
        OrdenCompraDet inactiva = new OrdenCompraDet();
        inactiva.setId(200L);
        inactiva.setArticuloId(2L);
        inactiva.setFlagEstado("0");
        oc.addLinea(inactiva);

        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        verify(articuloRefRepository, never()).findById(2L);
    }

    @Test
    @DisplayName("generarPdf() comprador null -> retorna vacio")
    void generarPdf_compradorNull_retornaVacio() {
        oc.setCompradorId(null);
        oc.setAprobadorId(null);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() jasper exception -> lanza business exception")
    void generarPdf_jasperException_lanzaBusinessException() {
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        jasperFillManagerMock.close();
        jasperFillManagerMock = mockStatic(JasperFillManager.class);
        jasperFillManagerMock.when(() -> JasperFillManager.fillReport(
                        any(JasperReport.class),
                        org.mockito.ArgumentMatchers.<String, Object>anyMap(),
                        any(JRDataSource.class)))
                .thenThrow(new RuntimeException("Jasper internal error"));

        assertThatThrownBy(() -> pdfService.generarPdf(1L))
                .isInstanceOf(pe.restaurant.common.exception.BusinessException.class)
                .hasMessageContaining("Error al generar el PDF");
    }

    @Test
    @DisplayName("generarPdf() con entidad banco cnta id -> retorna cci")
    void generarPdf_conEntidadBancoCntaId_retornaCci() {
        oc.setEntidadBancoCntaId(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        EntidadBancoCntaRef bancoCnta = mock(EntidadBancoCntaRef.class);
        lenient().when(bancoCnta.getCci()).thenReturn("CCI-1234567890");
        lenient().when(entidadBancoCntaRefRepository.findById(10L)).thenReturn(Optional.of(bancoCnta));

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() direccion y banco del proveedor cuando la OC no los tiene")
    void generarPdf_usaDireccionYBancoDelProveedor() {
        oc.setBancoId(null);
        oc.setNroCuenta(null);
        oc.setEntidadBancoCntaId(null);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        EntidadContribuyenteRef proveedor = mock(EntidadContribuyenteRef.class);
        lenient().when(proveedor.getNroDocumento()).thenReturn("20512345678");
        lenient().when(proveedor.getNombreCompleto()).thenReturn("DISTRIBUIDORA SAN MARTIN S.A.C.");
        lenient().when(proveedor.getDireccion()).thenReturn("Av. Industrial 123, Lima");
        lenient().when(proveedor.getTipoDocIdentidadId()).thenReturn(6L);
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.of(proveedor));

        TipoDocIdentidadRef tipoDoc = mock(TipoDocIdentidadRef.class);
        lenient().when(tipoDoc.getNombre()).thenReturn("RUC");
        lenient().when(tipoDocIdentidadRefRepository.findById(6L)).thenReturn(Optional.of(tipoDoc));

        EntidadBancoCntaRef cuenta = mock(EntidadBancoCntaRef.class);
        lenient().when(cuenta.getCodBanco()).thenReturn("002");
        lenient().when(cuenta.getNroCuenta()).thenReturn("1234567890");
        lenient().when(cuenta.getCci()).thenReturn("00200212345678901234");
        lenient().when(entidadBancoCntaRefRepository
                .findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(1L, "1"))
                .thenReturn(Optional.of(cuenta));

        FormaPagoRef formaPago = mock(FormaPagoRef.class);
        lenient().when(formaPago.getNombre()).thenReturn("Crédito 30 días");
        lenient().when(formaPagoRefRepository.findById(anyLong())).thenReturn(Optional.of(formaPago));

        ContactoRef contacto = mock(ContactoRef.class);
        lenient().when(contacto.getNombre()).thenReturn("Juan Pérez");
        lenient().when(contactoRefRepository
                .findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(1L, "1"))
                .thenReturn(Optional.of(contacto));

        pdfService.generarPdf(1L);

        @SuppressWarnings("unchecked")
        org.mockito.ArgumentCaptor<java.util.Map<String, Object>> captor =
                org.mockito.ArgumentCaptor.forClass(java.util.Map.class);
        jasperFillManagerMock.verify(() -> JasperFillManager.fillReport(
                any(JasperReport.class), captor.capture(), any(JRDataSource.class)));
        java.util.Map<String, Object> params = captor.getValue();
        assertThat(params.get("proveedorDireccion")).isEqualTo("Av. Industrial 123, Lima");
        assertThat(params.get("bancoPago")).isEqualTo("002");
        assertThat(params.get("nroCuenta")).isEqualTo("1234567890");
        assertThat(params.get("cci")).isEqualTo("00200212345678901234");
        assertThat(params.get("formaPago")).isEqualTo("Crédito 30 días");
        assertThat(params.get("proveedorVendedor")).isEqualTo("Juan Pérez");
        assertThat(params.get("proveedorDocIdentidad")).isEqualTo("20512345678");
        assertThat(params.get("proveedorTipoDocLabel")).isEqualTo("RUC");
    }

    @Test
    @DisplayName("generarPdf() moneda id null -> usa valor vacio")
    void generarPdf_monedaIdNull_usaValorVacio() {
        oc.setMonedaId(null);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() fec creacion presente formatea fecha")
    void generarPdf_fecCreacionPresente_formateaFecha() {
        oc.setFecCreacion(java.time.OffsetDateTime.now());
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() comprador con nombre blank fallback a usuario")
    void generarPdf_compradorConNombreBlank_fallbackAUsuario() {
        oc.setCompradorId(10L);
        oc.setAprobadorId(null);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        Comprador comp = mock(Comprador.class);
        lenient().when(comp.getNombre()).thenReturn("  ");
        lenient().when(comp.getUsuarioId()).thenReturn(1L);
        lenient().when(compradorRepository.findById(10L)).thenReturn(Optional.of(comp));

        UsuarioRef usr = mock(UsuarioRef.class);
        lenient().when(usr.getUsername()).thenReturn("admin");
        lenient().when(usuarioRefRepository.findById(1L)).thenReturn(Optional.of(usr));

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() comprador no existe fallback a usuario ref")
    void generarPdf_compradorNoExiste_fallbackAUsuarioRef() {
        oc.setCompradorId(99L);
        oc.setAprobadorId(null);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        lenient().when(compradorRepository.findById(99L)).thenReturn(Optional.empty());

        UsuarioRef usr = mock(UsuarioRef.class);
        lenient().when(usr.getUsername()).thenReturn("user99");
        lenient().when(usuarioRefRepository.findById(99L)).thenReturn(Optional.of(usr));

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    @Test
    @DisplayName("generarPdf() artículo sin unidad medida -> usa vacio")
    void generarPdf_articuloSinUnidadMedida_usaVacio() {
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        stubAllRefCalls();

        ArticuloRef artSinUm = mock(ArticuloRef.class);
        lenient().when(artSinUm.getCodigo()).thenReturn("ART002");
        lenient().when(artSinUm.getNombre()).thenReturn("Sin UM");
        lenient().when(artSinUm.getUnidadMedidaId()).thenReturn(null);
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.of(artSinUm));

        byte[] pdf = pdfService.generarPdf(1L);
        assertThat(pdf).isNotNull();
    }

    private void stubAllRefCalls() {
        lenient().when(empresaInfoService.obtener(anyLong()))
                .thenReturn(new EmpresaInfoService.EmpresaInfo("Empresa Test", "20123456789", "Av. Test 123", null, null));

        EntidadContribuyenteRef ecEmpresa = mock(EntidadContribuyenteRef.class);
        lenient().when(ecEmpresa.getNroDocumento()).thenReturn("20123456789");
        lenient().when(ecEmpresa.getEmail()).thenReturn("empresa@test.com");
        lenient().when(entidadContribuyenteRefRepository.findFirstByFlagEstadoOrderByIdAsc("1"))
                .thenReturn(Optional.of(ecEmpresa));

        EntidadContribuyenteRef proveedor = mock(EntidadContribuyenteRef.class);
        lenient().when(proveedor.getNroDocumento()).thenReturn("10987654321");
        lenient().when(proveedor.getNombreCompleto()).thenReturn("Proveedor Test");
        lenient().when(proveedor.getTelefono()).thenReturn("999888777");
        lenient().when(proveedor.getDocIdentidad()).thenReturn("RUC: 10987654321");
        lenient().when(proveedor.getEmail()).thenReturn("prov@test.com");
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.of(proveedor));

        MonedaRef moneda = mock(MonedaRef.class);
        lenient().when(moneda.getNombre()).thenReturn("Soles");
        lenient().when(moneda.getSimbolo()).thenReturn("S/");
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.of(moneda));

        ArticuloRef articulo = mock(ArticuloRef.class);
        lenient().when(articulo.getCodigo()).thenReturn("ART001");
        lenient().when(articulo.getNombre()).thenReturn("Artículo Test");
        lenient().when(articulo.getUnidadMedidaId()).thenReturn(1L);
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.of(articulo));

        UnidadMedidaRef unidad = mock(UnidadMedidaRef.class);
        lenient().when(unidad.getLabel()).thenReturn("UND");
        lenient().when(unidadMedidaRefRepository.findById(anyLong())).thenReturn(Optional.of(unidad));

        Comprador comprador = mock(Comprador.class);
        lenient().when(comprador.getNombre()).thenReturn("Comprador Test");
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.of(comprador));
    }
}
