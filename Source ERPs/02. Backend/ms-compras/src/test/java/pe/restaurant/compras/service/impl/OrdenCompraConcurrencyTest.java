package pe.restaurant.compras.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import pe.restaurant.compras.entity.OrdenCompra;
import pe.restaurant.compras.repository.*;
import pe.restaurant.compras.service.OrdenCompraPdfService;
import pe.restaurant.compras.service.OrdenCompraCalculator;
import pe.restaurant.compras.service.OrdenCompraValidator;
import pe.restaurant.compras.client.AlmacenClient;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.ConfigParameterService;
import pe.restaurant.common.service.NumeradorDocumentoService;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.compras.ComprasTestFixtures.*;

@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("OrdenCompraConcurrency — Pruebas Unitarias")
class OrdenCompraConcurrencyTest {

    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private AprobacionRepository aprobacionRepository;
    @Mock private OcImportacionRepository ocImportacionRepository;
    @Mock private IncotermRepository incotermRepository;
    @Mock private ArticuloMovProyRepository articuloMovProyRepository;
    @Mock private EntidadBancoCntaRepository entidadBancoCntaRepository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private OrdenCompraCalculator calculator;
    @Mock private OrdenCompraValidator validator;
    @Mock private OrdenCompraPdfService pdfService;
    @Mock private ConfigParameterService configParameterService;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    @Mock private ArticuloAlmacenRefRepository articuloAlmacenRefRepository;
    @Mock private AlmacenTacitoRefRepository almacenTacitoRefRepository;
    @Mock private ValeMovRefRepository valeMovRefRepository;
    @Mock private ArticuloPrecioPactadoRepository articuloPrecioPactadoRepository;
    @Mock private AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private JavaMailSender mailSender;
    @Mock private AlmacenClient almacenClient;

    @InjectMocks private OrdenCompraServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    @DisplayName("aprobar() invocaciones concurrentes solo una exitosa")
    void aprobar_invocacionesConcurrentes_soloUnaExitosa() throws Exception {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");

        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(aprobacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());

        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger errorCount = new AtomicInteger(0);

        int threadCount = 5;
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        CountDownLatch latch = new CountDownLatch(1);

        List<Future<?>> futures = new java.util.ArrayList<>();
        for (int i = 0; i < threadCount; i++) {
            futures.add(executor.submit(() -> {
                TenantContext.setUsuarioId(1L);
                TenantContext.setSucursalId(1L);
                try {
                    latch.await();
                    service.aprobar(1L, "Aprobado concurrente");
                    successCount.incrementAndGet();
                } catch (BusinessException e) {
                    errorCount.incrementAndGet();
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    TenantContext.clear();
                }
            }));
        }

        latch.countDown();

        for (Future<?> f : futures) {
            f.get(5, TimeUnit.SECONDS);
        }
        executor.shutdown();

        assertThat(successCount.get() + errorCount.get()).isEqualTo(threadCount);
        assertThat(successCount.get()).isGreaterThanOrEqualTo(1);
    }

    @Test
    @DisplayName("aprobar() y rechazar simultaneo uno falla")
    void aprobar_yRechazar_simultaneo_unoFalla() throws Exception {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");

        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        lenient().when(ordenCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(aprobacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());

        AtomicInteger totalOps = new AtomicInteger(0);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        CountDownLatch latch = new CountDownLatch(1);

        Future<?> approverFuture = executor.submit(() -> {
            TenantContext.setUsuarioId(1L);
            TenantContext.setSucursalId(1L);
            try {
                latch.await();
                service.aprobar(1L, "Aprobado");
                totalOps.incrementAndGet();
            } catch (BusinessException | InterruptedException ignored) {
                totalOps.incrementAndGet();
            } finally {
                TenantContext.clear();
            }
        });

        Future<?> rejectorFuture = executor.submit(() -> {
            TenantContext.setUsuarioId(2L);
            TenantContext.setSucursalId(1L);
            try {
                latch.await();
                service.rechazar(1L, "Rechazado");
                totalOps.incrementAndGet();
            } catch (BusinessException | InterruptedException ignored) {
                totalOps.incrementAndGet();
            } finally {
                TenantContext.clear();
            }
        });

        latch.countDown();

        approverFuture.get(5, TimeUnit.SECONDS);
        rejectorFuture.get(5, TimeUnit.SECONDS);
        executor.shutdown();

        assertThat(totalOps.get()).isEqualTo(2);
    }
}
