package pe.restaurant.produccion.event.publisher;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.client.AlmacenCosteoIntegracionClient;
import pe.restaurant.produccion.client.dto.ProcesoCosteoAlmacenResponse;
import pe.restaurant.produccion.entity.OrdenTrabajo;
import pe.restaurant.produccion.event.CosteoPeriodoProcesadoEvent;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.mockito.Mockito.doThrow;

@ExtendWith(MockitoExtension.class)
class HttpProduccionEventPublisherTest {

    @Mock
    private AlmacenCosteoIntegracionClient almacenCosteoIntegracionClient;

    @InjectMocks
    private HttpProduccionEventPublisher publisher;

    @BeforeEach
    void setUp() {
        TenantContext.setEmpresaId(2L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(10L);
    }

    @Test
    void publicarCosteoCompletado_invocaAlmacenTrasCommit() {
        when(almacenCosteoIntegracionClient.aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class)))
                .thenReturn(ApiResponse.ok(
                        ProcesoCosteoAlmacenResponse.builder().mensaje("OK").build(),
                        "Costeo aplicado en almacén"));

        TransactionSynchronizationManager.initSynchronization();
        try {
            publisher.publicarCosteoCompletado(2026, 5, null, null, 3, 1, 2);
            assertThat(TransactionSynchronizationManager.getSynchronizations()).hasSize(1);
            TransactionSynchronizationManager.getSynchronizations().forEach(s -> s.afterCommit());
        } finally {
            TransactionSynchronizationManager.clear();
            TenantContext.clear();
        }

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
    }

    @Test
    void publicarCosteoCompletado_sinTransaccion_invocaAlmacenDirecto() {
        when(almacenCosteoIntegracionClient.aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class)))
                .thenReturn(ApiResponse.ok(
                        ProcesoCosteoAlmacenResponse.builder().mensaje("OK").build(),
                        "Costeo aplicado en almacén"));

        publisher.publicarCosteoCompletado(2026, 5, 1L, null, 1, 0, 1);

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
        TenantContext.clear();
    }

    @Test
    void publicarOrdenCompletada_noInvocaAlmacen() {
        OrdenTrabajo ot = new OrdenTrabajo();
        ot.setId(7L);

        publisher.publicarOrdenCompletada(ot);

        verify(almacenCosteoIntegracionClient, never()).aplicarCosteo(any());
        TenantContext.clear();
    }

    @Test
    void publicarOrdenCompletada_conNull_noFalla() {
        publisher.publicarOrdenCompletada(null);

        verify(almacenCosteoIntegracionClient, never()).aplicarCosteo(any());
        TenantContext.clear();
    }

    @Test
    void publicarOrdenCancelada_noInvocaAlmacen() {
        OrdenTrabajo ot = new OrdenTrabajo();
        ot.setId(7L);

        publisher.publicarOrdenCancelada(ot);

        verify(almacenCosteoIntegracionClient, never()).aplicarCosteo(any());
        TenantContext.clear();
    }

    @Test
    void publicarOrdenCancelada_conNull_noFalla() {
        publisher.publicarOrdenCancelada(null);

        verify(almacenCosteoIntegracionClient, never()).aplicarCosteo(any());
        TenantContext.clear();
    }

    @Test
    void publicarCosteoCompletado_responseSinExito_loggeaWarn() {
        when(almacenCosteoIntegracionClient.aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class)))
                .thenReturn(ApiResponse.error("Error en almacén", "ERR-001"));

        TransactionSynchronizationManager.initSynchronization();
        try {
            publisher.publicarCosteoCompletado(2026, 5, null, null, 3, 1, 2);
            TransactionSynchronizationManager.getSynchronizations().forEach(s -> s.afterCommit());
        } finally {
            TransactionSynchronizationManager.clear();
            TenantContext.clear();
        }

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
    }

    @Test
    void publicarCosteoCompletado_responseNull_loggeaWarn() {
        when(almacenCosteoIntegracionClient.aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class)))
                .thenReturn(null);

        TransactionSynchronizationManager.initSynchronization();
        try {
            publisher.publicarCosteoCompletado(2026, 5, null, null, 3, 1, 2);
            TransactionSynchronizationManager.getSynchronizations().forEach(s -> s.afterCommit());
        } finally {
            TransactionSynchronizationManager.clear();
            TenantContext.clear();
        }

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
    }

    @Test
    void publicarCosteoCompletado_responseExitosoSinData_loggeaMensaje() {
        when(almacenCosteoIntegracionClient.aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class)))
                .thenReturn(ApiResponse.ok(null, "Costeo aplicado"));

        TransactionSynchronizationManager.initSynchronization();
        try {
            publisher.publicarCosteoCompletado(2026, 5, null, null, 3, 1, 2);
            TransactionSynchronizationManager.getSynchronizations().forEach(s -> s.afterCommit());
        } finally {
            TransactionSynchronizationManager.clear();
            TenantContext.clear();
        }

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
    }

    @Test
    void publicarCosteoCompletado_cuandoClienteLanzaExcepcion_loggeaWarn() {
        doThrow(new RuntimeException("Timeout"))
                .when(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));

        TransactionSynchronizationManager.initSynchronization();
        try {
            publisher.publicarCosteoCompletado(2026, 5, null, null, 3, 1, 2);
            TransactionSynchronizationManager.getSynchronizations().forEach(s -> s.afterCommit());
        } finally {
            TransactionSynchronizationManager.clear();
            TenantContext.clear();
        }

        verify(almacenCosteoIntegracionClient).aplicarCosteo(any(CosteoPeriodoProcesadoEvent.class));
    }
}
