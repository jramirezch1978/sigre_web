package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.DepreciacionMensualRequest;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.service.AfCalculoCntblService;
import pe.restaurant.activos.service.AfPrimaDevengoService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfJobsControllerTest {

    @Mock private AfCalculoCntblService calculoService;
    @Mock private AfPrimaDevengoService primaDevengoService;
    @Mock private ContabilidadIntegracionService contabilidadIntegracionService;
    @InjectMocks private AfJobsController controller;

    private AfCalculoCntbl calculo(Long id) {
        var c = new AfCalculoCntbl();
        c.setId(id);
        return c;
    }

    private AfPrimaDevengo devengo(Long id) {
        var d = new AfPrimaDevengo();
        d.setId(id);
        return d;
    }

    @Test
    void depreciacionMasivaSinContabilizar() {
        var req = new DepreciacionMensualRequest();
        req.setAnio(2026);
        req.setMes(5);
        when(calculoService.calcularDepreciacionMasiva(2026, 5))
                .thenReturn(List.of(calculo(1L), calculo(2L)));

        var result = controller.depreciacionMasiva(req, false);

        assertThat(result.getData().getRegistrosProcesados()).isEqualTo(2);
        assertThat(result.getData().getRegistrosContabilizados()).isEqualTo(0);
        assertThat(result.getData().getJob()).isEqualTo("DEPRECIACION_MASIVA");
        verify(contabilidadIntegracionService, never()).contabilizarDepreciacion(org.mockito.ArgumentMatchers.anyLong());
    }

    @Test
    void depreciacionMasivaConContabilizar() {
        var req = new DepreciacionMensualRequest();
        req.setAnio(2026);
        req.setMes(5);
        when(calculoService.calcularDepreciacionMasiva(2026, 5))
                .thenReturn(List.of(calculo(1L), calculo(2L), calculo(3L)));
        when(contabilidadIntegracionService.contabilizarDepreciacion(1L))
                .thenReturn(IntegracionContabilidadResult.builder().asientoId(11L).build());
        when(contabilidadIntegracionService.contabilizarDepreciacion(2L))
                .thenThrow(new RuntimeException("fallo"));
        when(contabilidadIntegracionService.contabilizarDepreciacion(3L))
                .thenReturn(IntegracionContabilidadResult.builder().asientoId(13L).build());

        var result = controller.depreciacionMasiva(req, true);

        assertThat(result.getData().getRegistrosProcesados()).isEqualTo(3);
        assertThat(result.getData().getRegistrosContabilizados()).isEqualTo(2);
        verify(contabilidadIntegracionService).contabilizarDepreciacion(1L);
        verify(contabilidadIntegracionService).contabilizarDepreciacion(2L);
        verify(contabilidadIntegracionService).contabilizarDepreciacion(3L);
    }

    @Test
    void devengoPrimaMasivoSinContabilizar() {
        when(primaDevengoService.registrarDevengoMasivo(2026, 5))
                .thenReturn(List.of(devengo(1L)));

        var result = controller.devengoPrimaMasivo(2026, 5, false);

        assertThat(result.getData().getRegistrosProcesados()).isEqualTo(1);
        assertThat(result.getData().getRegistrosContabilizados()).isEqualTo(0);
        assertThat(result.getData().getJob()).isEqualTo("DEVENGO_PRIMA_MASIVO");
        verify(contabilidadIntegracionService, never()).contabilizarDevengoPrima(org.mockito.ArgumentMatchers.anyLong());
    }

    @Test
    void devengoPrimaMasivoConContabilizar() {
        when(primaDevengoService.registrarDevengoMasivo(2026, 5))
                .thenReturn(List.of(devengo(1L), devengo(2L), devengo(3L)));
        when(contabilidadIntegracionService.contabilizarDevengoPrima(1L))
                .thenReturn(IntegracionContabilidadResult.builder().asientoId(21L).build());
        when(contabilidadIntegracionService.contabilizarDevengoPrima(2L))
                .thenThrow(new IllegalStateException("fallo"));
        when(contabilidadIntegracionService.contabilizarDevengoPrima(3L))
                .thenReturn(IntegracionContabilidadResult.builder().asientoId(23L).build());

        var result = controller.devengoPrimaMasivo(2026, 5, true);

        assertThat(result.getData().getRegistrosProcesados()).isEqualTo(3);
        assertThat(result.getData().getRegistrosContabilizados()).isEqualTo(2);
        assertThat(result.getData().getAnio()).isEqualTo(2026);
        assertThat(result.getData().getMes()).isEqualTo(5);
    }
}
