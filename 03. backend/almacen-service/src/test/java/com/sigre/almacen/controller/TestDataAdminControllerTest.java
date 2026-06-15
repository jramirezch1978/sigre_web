package com.sigre.almacen.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.service.TestDataSeedService;

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
        var counts = Map.of("almacen", 2, "ubicacion", 5);
        when(seedService.seedAlmacenDemoData()).thenReturn(counts);

        var result = controller.seed();

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Datos de prueba creados");
        assertThat(result.getData()).isEqualTo(counts);
        verify(seedService).seedAlmacenDemoData();
    }
}
