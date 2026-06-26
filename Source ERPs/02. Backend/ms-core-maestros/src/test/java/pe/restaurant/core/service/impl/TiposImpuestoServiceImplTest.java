package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.client.ContabilidadClient;
import pe.restaurant.core.client.dto.PlanContableDetResponse;
import pe.restaurant.core.entity.TiposImpuesto;
import pe.restaurant.core.repository.TiposImpuestoRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TiposImpuestoServiceImplTest {

    @Mock private TiposImpuestoRepository repository;
    @Mock private ContabilidadClient contabilidadClient;
    @InjectMocks private TiposImpuestoServiceImpl service;

    private TiposImpuesto impuesto;

    @BeforeEach
    void setUp() {
        impuesto = new TiposImpuesto();
        impuesto.setId(1L);
        impuesto.setTipoImpuesto("IGV");
        impuesto.setDescImpuesto("Impuesto General a las Ventas");
        impuesto.setTasaImpuesto(new java.math.BigDecimal("18.00"));
        impuesto.setSigno("+");
        impuesto.setFlagDhCxp("D");
        impuesto.setFlagIgv("1");
    }

    @Nested
    class FindById {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            assertThat(service.findById(1L)).isEqualTo(impuesto);
        }

        @Test
        void notFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test
        void successSinPlanContableDet() {
            when(repository.save(impuesto)).thenReturn(impuesto);
            assertThat(service.create(impuesto)).isNotNull();
            verifyNoInteractions(contabilidadClient);
        }

        @Test
        void successConPlanContableDetActivo() {
            impuesto.setPlanContableDetId(10L);
            var response = new PlanContableDetResponse();
            response.setFlagEstado("1");
            when(contabilidadClient.obtenerPlanContableDet(10L))
                    .thenReturn(ApiResponse.ok(response));
            when(repository.save(impuesto)).thenReturn(impuesto);
            assertThat(service.create(impuesto)).isNotNull();
        }

        @Test
        void rechazaPlanContableDetInexistente() {
            impuesto.setPlanContableDetId(99L);
            when(contabilidadClient.obtenerPlanContableDet(99L))
                    .thenReturn(ApiResponse.ok(null));
            assertThatThrownBy(() -> service.create(impuesto))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void rechazaPlanContableDetInactivo() {
            impuesto.setPlanContableDetId(10L);
            var response = new PlanContableDetResponse();
            response.setFlagEstado("0");
            when(contabilidadClient.obtenerPlanContableDet(10L))
                    .thenReturn(ApiResponse.ok(response));
            assertThatThrownBy(() -> service.create(impuesto))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }
    }

    @Nested
    class Update {
        @Test
        void successSinPlanContableDet() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.update(1L, impuesto)).isNotNull();
            verifyNoInteractions(contabilidadClient);
        }

        @Test
        void successConPlanContableDetActivo() {
            impuesto.setPlanContableDetId(10L);
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            var response = new PlanContableDetResponse();
            response.setFlagEstado("1");
            when(contabilidadClient.obtenerPlanContableDet(10L))
                    .thenReturn(ApiResponse.ok(response));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.update(1L, impuesto)).isNotNull();
        }

        @Test
        void rechazaPlanContableDetInexistente() {
            impuesto.setPlanContableDetId(99L);
            when(contabilidadClient.obtenerPlanContableDet(99L))
                    .thenReturn(ApiResponse.ok(null));
            assertThatThrownBy(() -> service.update(1L, impuesto))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }
    }

    @Nested
    class Delete {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }
    }

    @Nested
    class Activate {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.activate(1L)).isNotNull();
        }
    }

    @Nested
    class Deactivate {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(impuesto));
            when(repository.save(any())).thenReturn(impuesto);
            assertThat(service.deactivate(1L)).isNotNull();
        }
    }
}
