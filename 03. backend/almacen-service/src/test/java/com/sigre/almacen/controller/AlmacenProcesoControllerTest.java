package com.sigre.almacen.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.dto.ProcesoAlmacenFiltroRequest;
import com.sigre.almacen.dto.ProcesoAlmacenResponse;
import com.sigre.almacen.service.AlmacenProcesoService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlmacenProcesoControllerTest {

    @Mock
    private AlmacenProcesoService procesoService;

    @InjectMocks
    private AlmacenProcesoController controller;

    @Test
    void recalculoPreciosPromedio_delegates() {
        ProcesoAlmacenResponse out = ProcesoAlmacenResponse.builder()
                .procesados(3)
                .mensaje("OK")
                .codigoMenu("ALMACEN_PROC_RECALCULO")
                .build();
        ProcesoAlmacenFiltroRequest filtro = new ProcesoAlmacenFiltroRequest();
        when(procesoService.recalcularPreciosPromedio(filtro)).thenReturn(out);

        var result = controller.recalculoPreciosPromedio(filtro);

        assertThat(result.getData().getProcesados()).isEqualTo(3);
        assertThat(result.getData().getCodigoMenu()).isEqualTo("ALMACEN_PROC_RECALCULO");
        verify(procesoService).recalcularPreciosPromedio(filtro);
    }

    @Test
    void cuadreStock_actualizacionAutomatica_acceptNullBody() {
        when(procesoService.cuadrarStockVsPosiciones(isNull()))
                .thenReturn(ProcesoAlmacenResponse.builder().procesados(0).mensaje("idle").build());
        when(procesoService.actualizacionAutomatica(isNull()))
                .thenReturn(ProcesoAlmacenResponse.builder().procesados(1).mensaje("run").build());

        assertThat(controller.cuadreStock(null).getData().getMensaje()).isEqualTo("idle");
        assertThat(controller.actualizacionAutomatica(null).getData().getProcesados()).isEqualTo(1);
    }
}
