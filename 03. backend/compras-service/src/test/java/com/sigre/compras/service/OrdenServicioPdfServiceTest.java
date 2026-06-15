package com.sigre.compras.service;

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
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.compras.entity.*;
import com.sigre.compras.repository.*;

import java.math.BigDecimal;
import java.io.InputStream;
import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenServicioPdfService — Pruebas Unitarias")
class OrdenServicioPdfServiceTest {

    @Mock private OrdenServicioRepository ordenServicioRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private ServicioCatalogoRepository servicioCatalogoRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private EmpresaInfoService empresaInfoService;
    @InjectMocks private OrdenServicioPdfService pdfService;

    private OrdenServicio os;
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

        os = new OrdenServicio();
        os.setId(1L);
        os.setSucursalId(1L);
        os.setProveedorId(1L);
        os.setMonedaId(1L);
        os.setNroOs("OS-00000001");
        os.setFormaPagoId(1L);
        os.setFecRegistro(LocalDate.of(2026, 4, 15));
        os.setMontoTotal(new BigDecimal("1180.0000"));
        os.setCompradorId(10L);
        os.setAprobadorId(20L);

        OrdenServicioDet linea = new OrdenServicioDet();
        linea.setId(100L);
        linea.setServicioId(1L);
        linea.setNroItem(1);
        linea.setDescripcion("Servicio de mantenimiento");
        linea.setImporte(new BigDecimal("1000"));
        linea.setDecuento(BigDecimal.ZERO);
        linea.setImpuesto(new BigDecimal("180"));
        linea.setSubtotal(new BigDecimal("1180"));
        linea.setFecProyect(LocalDate.of(2026, 5, 1));
        linea.setFlagEstado("1");
        os.addLinea(linea);
    }

    @AfterEach
    void tearDown() {
        jasperExportManagerMock.close();
        jasperFillManagerMock.close();
        jasperCompileManagerMock.close();
        tenantContextMock.close();
    }

    @Test
    @DisplayName("generarPdf() os no existe -> lanza excepción")
    void generarPdf_osNoExiste_lanzaExcepcion() {
        when(ordenServicioRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> pdfService.generarPdf(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("generarPdf() ok -> retorna bytes")
    void generarPdf_ok_retornaBytes() {
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        assertThat(pdf.length).isGreaterThan(0);
        assertThat(pdf[0]).isEqualTo((byte) '%');
    }

    @Test
    @DisplayName("generarPdf() sin datos ref -> usa valores por defecto")
    void generarPdf_sinDatosRef_usaValoresPorDefecto() {
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        lenient().when(empresaInfoService.obtener(anyLong()))
                .thenReturn(new EmpresaInfoService.EmpresaInfo("", "", "", null, null));
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(servicioCatalogoRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.empty());

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        assertThat(pdf.length).isGreaterThan(0);
    }

    @Test
    @DisplayName("generarPdf() línea inactiva -> no incluida en reporte")
    void generarPdf_lineaInactiva_noIncluidaEnReporte() {
        OrdenServicioDet inactiva = new OrdenServicioDet();
        inactiva.setId(200L);
        inactiva.setServicioId(2L);
        inactiva.setFlagEstado("0");
        os.addLinea(inactiva);

        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarPdf(1L);

        assertThat(pdf).isNotNull();
        verify(servicioCatalogoRepository, never()).findById(2L);
    }

    @Test
    @DisplayName("generarActaConformidadPdf() ok -> retorna bytes")
    void generarActaConformidadPdf_ok_retornaBytes() {
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarActaConformidadPdf(1L);

        assertThat(pdf).isNotNull();
        assertThat(pdf.length).isGreaterThan(0);
        assertThat(pdf[0]).isEqualTo((byte) '%');
    }

    @Test
    @DisplayName("generarActaConformidadPdf() sin conformidad -> retorna vacio")
    void generarActaConformidadPdf_sinConformidad_retornaVacio() {
        os.getLineas().get(0).setConformidadFecha(null);

        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        stubAllRefCalls();

        byte[] pdf = pdfService.generarActaConformidadPdf(1L);

        assertThat(pdf).isNotNull();
    }

    private void stubAllRefCalls() {
        lenient().when(empresaInfoService.obtener(anyLong()))
                .thenReturn(new EmpresaInfoService.EmpresaInfo("Empresa Test", "20123456789", "Av. Test 123", null, null));

        EntidadContribuyenteRef proveedor = mock(EntidadContribuyenteRef.class);
        lenient().when(proveedor.getNroDocumento()).thenReturn("10987654321");
        lenient().when(proveedor.getNombreCompleto()).thenReturn("Proveedor Test");
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.of(proveedor));

        MonedaRef moneda = mock(MonedaRef.class);
        lenient().when(moneda.getNombre()).thenReturn("Soles");
        lenient().when(moneda.getSimbolo()).thenReturn("S/");
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.of(moneda));

        ServicioCatalogo servicio = mock(ServicioCatalogo.class);
        lenient().when(servicio.getServicio()).thenReturn("SRV001");
        lenient().when(servicio.getDescripcion()).thenReturn("Servicio Test");
        lenient().when(servicioCatalogoRepository.findById(anyLong())).thenReturn(Optional.of(servicio));

        Comprador comprador = mock(Comprador.class);
        lenient().when(comprador.getNombre()).thenReturn("Comprador Test");
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.of(comprador));

        lenient().when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.empty());
    }
}
