package pe.restaurant.almacen.event.publisher;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import pe.restaurant.almacen.client.ContabilidadPreAsientoClient;
import pe.restaurant.almacen.entity.ArticuloMovTipo;
import pe.restaurant.almacen.entity.ValeMov;
import pe.restaurant.almacen.entity.ValeMovDet;
import pe.restaurant.almacen.event.CosteoPeriodoProcesadoEvent;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.event.PreAsientoEvent;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class HttpAlmacenPreAsientoPublisherTest {

    @Mock
    private ContabilidadPreAsientoClient client;

    @InjectMocks
    private HttpAlmacenPreAsientoPublisher publisher;

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private ArticuloMovTipo tipo(String flagContabiliza) {
        ArticuloMovTipo t = new ArticuloMovTipo();
        t.setFlagContabiliza(flagContabiliza);
        return t;
    }

    private ValeMov vale(String clase) {
        ValeMov mov = new ValeMov();
        mov.setId(100L);
        mov.setSucursalId(1L);
        mov.setAlmacenId(7L);
        mov.setNroVale("V-001");
        mov.setFechaMov(LocalDate.of(2026, 5, 10));
        mov.setTipoReferenciaOrigen(clase);
        ValeMovDet d = new ValeMovDet();
        d.setCantProcesada(new BigDecimal("2"));
        d.setCostoUnitario(new BigDecimal("5"));
        mov.addLinea(d);
        return mov;
    }

    @Test
    void publicarMovimientoConfirmado_ingreso_invocaContabilidadConDocumentoIngreso() {
        when(client.registrarPreAsiento(any())).thenReturn(ApiResponse.<Void>builder().success(true).build());

        publisher.publicarMovimientoConfirmado(vale("I"), tipo("1"));

        ArgumentCaptor<PreAsientoEvent> captor = ArgumentCaptor.forClass(PreAsientoEvent.class);
        verify(client).registrarPreAsiento(captor.capture());
        assertThat(captor.getValue().getTipoDocumento()).isEqualTo("INGRESO_ALMACEN");
        assertThat(captor.getValue().getNumeroDocumento()).isEqualTo("V-001");
    }

    @Test
    void publicarMovimientoConfirmado_produccion_clasificaComoIngreso() {
        when(client.registrarPreAsiento(any())).thenReturn(ApiResponse.<Void>builder().success(true).build());

        publisher.publicarMovimientoConfirmado(vale("P"), tipo("1"));

        ArgumentCaptor<PreAsientoEvent> captor = ArgumentCaptor.forClass(PreAsientoEvent.class);
        verify(client).registrarPreAsiento(captor.capture());
        assertThat(captor.getValue().getTipoDocumento()).isEqualTo("INGRESO_ALMACEN");
    }

    @Test
    void publicarMovimientoConfirmado_consumo_invocaContabilidadConDocumentoConsumo() {
        when(client.registrarPreAsiento(any())).thenReturn(ApiResponse.<Void>builder().success(true).build());

        publisher.publicarMovimientoConfirmado(vale("C"), tipo("1"));

        ArgumentCaptor<PreAsientoEvent> captor = ArgumentCaptor.forClass(PreAsientoEvent.class);
        verify(client).registrarPreAsiento(captor.capture());
        assertThat(captor.getValue().getTipoDocumento()).isEqualTo("CONSUMO_ALMACEN");
    }

    @Test
    void publicarMovimientoConfirmado_noContabiliza_noInvoca() {
        publisher.publicarMovimientoConfirmado(vale("I"), tipo("0"));
        verify(client, never()).registrarPreAsiento(any());
    }

    @Test
    void publicarMovimientoConfirmado_claseSalida_noInvoca() {
        publisher.publicarMovimientoConfirmado(vale("V"), tipo("1"));
        verify(client, never()).registrarPreAsiento(any());
    }

    @Test
    void publicarMovimientoConfirmado_cuandoClienteFalla_noPropagaExcepcion() {
        when(client.registrarPreAsiento(any())).thenThrow(new RuntimeException("contabilidad caída"));

        publisher.publicarMovimientoConfirmado(vale("I"), tipo("1"));

        verify(client).registrarPreAsiento(any());
    }

    @Test
    void publicarCosteoProduccion_invocaContabilidadConDocumentoCosteo() {
        when(client.registrarPreAsiento(any())).thenReturn(ApiResponse.<Void>builder().success(true).build());
        var evento = CosteoPeriodoProcesadoEvent.builder()
                .anio(2026).mes(5).empresaId(1L).sucursalFiltroId(2L).usuarioId(9L)
                .build();

        publisher.publicarCosteoProduccion(evento, 3, 5);

        ArgumentCaptor<PreAsientoEvent> captor = ArgumentCaptor.forClass(PreAsientoEvent.class);
        verify(client).registrarPreAsiento(captor.capture());
        assertThat(captor.getValue().getTipoDocumento()).isEqualTo("COSTEO_PRODUCCION");
        assertThat(captor.getValue().getNumeroDocumento()).isEqualTo("2026-05");
    }
}
