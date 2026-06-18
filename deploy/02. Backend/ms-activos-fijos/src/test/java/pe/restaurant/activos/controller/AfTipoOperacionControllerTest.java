package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfTipoOperacionRequest;
import pe.restaurant.activos.dto.AfTipoOperacionResponse;
import pe.restaurant.activos.entity.AfTipoOperacion;
import pe.restaurant.activos.service.AfTipoOperacionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfTipoOperacionControllerTest {

    @Mock private AfTipoOperacionService service;
    @InjectMocks private AfTipoOperacionController controller;

    private AfTipoOperacion buildEntity(Long id, String codigo) {
        var entity = new AfTipoOperacion();
        entity.setId(id);
        entity.setCodigo(codigo);
        entity.setDescripcion("Descripción " + codigo);
        entity.setNaturaleza("GASTO");
        entity.setTipoCalculo("FIJO");
        entity.setCuentaContableId(10L);
        entity.setCentroCostoId(20L);
        entity.setAfectaContabilidad(true);
        entity.setMetodoCalculo("LINEAL");
        entity.setObservaciones("Obs");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        return entity;
    }

    private AfTipoOperacionRequest buildRequest(String codigo) {
        var req = new AfTipoOperacionRequest();
        req.setCodigo(codigo);
        req.setDescripcion("Mantenimiento");
        req.setNaturaleza("GASTO");
        req.setTipoCalculo("FIJO");
        req.setCuentaContableId(10L);
        req.setCentroCostoId(20L);
        req.setAfectaContabilidad(true);
        req.setMetodoCalculo("LINEAL");
        req.setObservaciones("Obs");
        return req;
    }

    @Nested
    class Listar {

        @Test
        void retornaPaginaConElementos() {
            var entity = buildEntity(1L, "MANT");
            when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));

            var response = controller.listar(Pageable.unpaged());

            assertThat(response.getData().getContent()).hasSize(1);
            assertThat(response.isSuccess()).isTrue();
        }

        @Test
        void retornaPaginaVacia() {
            when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(Collections.emptyList()));

            var response = controller.listar(Pageable.unpaged());

            assertThat(response.getData().getContent()).isEmpty();
            assertThat(response.isSuccess()).isTrue();
        }

        @Test
        void responseContieneDatosCompletos() {
            var entity = buildEntity(1L, "MANT");
            when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));

            var response = controller.listar(Pageable.unpaged());
            AfTipoOperacionResponse first = response.getData().getContent().get(0);

            assertThat(first.getId()).isEqualTo(1L);
            assertThat(first.getCodigo()).isEqualTo("MANT");
            assertThat(first.getDescripcion()).isEqualTo("Descripción MANT");
            assertThat(first.getNaturaleza()).isEqualTo("GASTO");
            assertThat(first.getTipoCalculo()).isEqualTo("FIJO");
            assertThat(first.getCuentaContableId()).isEqualTo(10L);
            assertThat(first.getCentroCostoId()).isEqualTo(20L);
            assertThat(first.getAfectaContabilidad()).isTrue();
            assertThat(first.getMetodoCalculo()).isEqualTo("LINEAL");
            assertThat(first.getObservaciones()).isEqualTo("Obs");
            assertThat(first.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
        }
    }

    @Nested
    class Obtener {

        @Test
        void retornaEntityPorId() {
            var entity = buildEntity(1L, "MANT");
            when(service.findById(1L)).thenReturn(entity);

            var response = controller.obtener(1L);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData().getId()).isEqualTo(1L);
            assertThat(response.getData().getCodigo()).isEqualTo("MANT");
        }
    }

    @Nested
    class Crear {

        @Test
        void creaRegistroExitosamente() {
            var entity = buildEntity(1L, "MANT");
            when(service.create(any())).thenReturn(entity);

            var req = buildRequest("mant");
            var response = controller.crear(req);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData().getCodigo()).isEqualTo("MANT");
        }

        @Test
        void trimYUppercaseEnCodigo() {
            var entity = buildEntity(1L, "DEPR");
            when(service.create(any(AfTipoOperacion.class))).thenAnswer(inv -> {
                AfTipoOperacion arg = inv.getArgument(0);
                assertThat(arg.getCodigo()).isEqualTo("DEPR");
                entity.setCodigo(arg.getCodigo());
                return entity;
            });

            var req = buildRequest("  depr  ");
            controller.crear(req);

            verify(service).create(any(AfTipoOperacion.class));
        }
    }

    @Nested
    class Actualizar {

        @Test
        void actualizaRegistroExitosamente() {
            var existing = buildEntity(1L, "MANT");
            var updated = buildEntity(1L, "DEPR");
            when(service.findById(1L)).thenReturn(existing);
            when(service.update(eq(1L), any(AfTipoOperacion.class))).thenReturn(updated);

            var req = buildRequest("DEPR");
            var response = controller.actualizar(1L, req);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData().getCodigo()).isEqualTo("DEPR");
        }

        @Test
        void aplicaCamposDelRequest() {
            var existing = buildEntity(1L, "MANT");
            when(service.findById(1L)).thenReturn(existing);
            when(service.update(eq(1L), any(AfTipoOperacion.class))).thenAnswer(inv -> inv.getArgument(1));

            var req = new AfTipoOperacionRequest();
            req.setCodigo("NUEVO");
            req.setDescripcion("Nueva desc");
            req.setNaturaleza("INGRESO");
            req.setTipoCalculo("PORCENTAJE");
            req.setCuentaContableId(99L);
            req.setCentroCostoId(88L);
            req.setAfectaContabilidad(false);
            req.setMetodoCalculo("ACELERADO");
            req.setObservaciones("Observación nueva");

            var response = controller.actualizar(1L, req);

            assertThat(response.getData().getCodigo()).isEqualTo("NUEVO");
            assertThat(response.getData().getDescripcion()).isEqualTo("Nueva desc");
            assertThat(response.getData().getNaturaleza()).isEqualTo("INGRESO");
            assertThat(response.getData().getTipoCalculo()).isEqualTo("PORCENTAJE");
            assertThat(response.getData().getCuentaContableId()).isEqualTo(99L);
            assertThat(response.getData().getCentroCostoId()).isEqualTo(88L);
            assertThat(response.getData().getAfectaContabilidad()).isFalse();
            assertThat(response.getData().getMetodoCalculo()).isEqualTo("ACELERADO");
            assertThat(response.getData().getObservaciones()).isEqualTo("Observación nueva");
        }
    }

    @Nested
    class Eliminar {

        @Test
        void eliminaRegistroExitosamente() {
            doNothing().when(service).delete(1L);

            var response = controller.eliminar(1L);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData()).isTrue();
            verify(service).delete(1L);
        }
    }

    @Nested
    class Activar {

        @Test
        void activaRegistroExitosamente() {
            var entity = buildEntity(1L, "MANT");
            entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
            when(service.activate(1L)).thenReturn(entity);

            var response = controller.activar(1L);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData().getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
        }
    }

    @Nested
    class Desactivar {

        @Test
        void desactivaRegistroExitosamente() {
            var entity = buildEntity(1L, "MANT");
            entity.setFlagEstado(ActivosFlagEstado.INACTIVO);
            when(service.deactivate(1L)).thenReturn(entity);

            var response = controller.desactivar(1L);

            assertThat(response.isSuccess()).isTrue();
            assertThat(response.getData().getFlagEstado()).isEqualTo(ActivosFlagEstado.INACTIVO);
        }
    }
}
