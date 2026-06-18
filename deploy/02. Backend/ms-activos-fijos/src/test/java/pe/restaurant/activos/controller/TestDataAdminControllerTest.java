package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.service.TestDataSeedService;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TestDataAdminControllerTest {

    @Mock
    private TestDataSeedService seedService;

    @InjectMocks
    private TestDataAdminController controller;

    @Test
    void seed_delegatesToServiceAndReturnsCounts() {
        var counts = Map.of("activos.af_clase", 2, "activos.af_maestro", 3);
        when(seedService.seedActivosDemoData()).thenReturn(counts);

        var result = controller.seed();

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Datos de prueba activos fijos creados");
        assertThat(result.getData()).isEqualTo(counts);
        verify(seedService).seedActivosDemoData();
    }
}
