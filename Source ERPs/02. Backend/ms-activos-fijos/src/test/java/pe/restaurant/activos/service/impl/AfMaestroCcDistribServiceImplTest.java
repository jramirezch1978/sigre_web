package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.AfMaestroCcDistribRequest;
import pe.restaurant.activos.repository.AfMaestroCcDistribRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfMaestroCcDistribServiceImplTest {

    @Mock
    private AfMaestroCcDistribRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @InjectMocks
    private AfMaestroCcDistribServiceImpl service;

    @Test
    void reemplazarDistribucion_rechazaSumaDistintaDe100() {
        when(maestroRepository.existsById(1L)).thenReturn(true);
        AfMaestroCcDistribRequest a = new AfMaestroCcDistribRequest();
        a.setCentroCostoId(10L);
        a.setPorcentaje(new BigDecimal("60"));
        AfMaestroCcDistribRequest b = new AfMaestroCcDistribRequest();
        b.setCentroCostoId(20L);
        b.setPorcentaje(new BigDecimal("30"));
        assertThatThrownBy(() -> service.reemplazarDistribucion(1L, List.of(a, b)))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.DISTRIBUCION_CC_INVALIDA);
    }

    @Test
    void reemplazarDistribucion_aceptaSuma100() {
        when(maestroRepository.existsById(1L)).thenReturn(true);
        AfMaestroCcDistribRequest a = new AfMaestroCcDistribRequest();
        a.setCentroCostoId(10L);
        a.setPorcentaje(new BigDecimal("70"));
        AfMaestroCcDistribRequest b = new AfMaestroCcDistribRequest();
        b.setCentroCostoId(20L);
        b.setPorcentaje(new BigDecimal("30"));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        assertThat(service.reemplazarDistribucion(1L, List.of(a, b))).hasSize(2);
    }
}
