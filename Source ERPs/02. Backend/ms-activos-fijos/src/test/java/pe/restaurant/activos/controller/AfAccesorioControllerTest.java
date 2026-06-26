package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.AfAccesorioRequest;
import pe.restaurant.activos.entity.AfAccesorio;
import pe.restaurant.activos.service.AfAccesorioService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfAccesorioControllerTest {

    @Mock private AfAccesorioService service;
    @InjectMocks private AfAccesorioController controller;

    @Test
    void listarPorMaestro() {
        var e = new AfAccesorio();
        e.setId(1L);
        e.setAfMaestroId(2L);
        e.setDescripcion("Monitor");
        when(service.findByMaestro(2L)).thenReturn(List.of(e));
        assertThat(controller.listarPorMaestro(2L).getData()).hasSize(1);
    }

    @Test
    void crear() {
        var e = new AfAccesorio();
        e.setId(1L);
        when(service.create(any())).thenReturn(e);
        var req = new AfAccesorioRequest();
        req.setAfMaestroId(1L);
        req.setDescripcion("Teclado");
        req.setCosto(BigDecimal.TEN);
        assertThat(controller.crear(req).isSuccess()).isTrue();
    }

    @Test
    void obtener() {
        var e = new AfAccesorio();
        e.setId(7L);
        e.setAfMaestroId(2L);
        e.setDescripcion("Mouse");
        e.setCosto(new BigDecimal("25.50"));
        e.setFechaInstalacion(LocalDate.of(2026, 1, 15));
        when(service.findById(7L)).thenReturn(e);

        var resp = controller.obtener(7L);

        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getId()).isEqualTo(7L);
        assertThat(resp.getData().getDescripcion()).isEqualTo("Mouse");
        assertThat(resp.getData().getCosto()).isEqualByComparingTo("25.50");
        assertThat(resp.getData().getFechaInstalacion()).isEqualTo(LocalDate.of(2026, 1, 15));
    }

    @Test
    void actualizar() {
        var existing = new AfAccesorio();
        existing.setId(9L);
        existing.setAfMaestroId(3L);
        existing.setDescripcion("Viejo");
        existing.setCosto(BigDecimal.ONE);

        var updated = new AfAccesorio();
        updated.setId(9L);
        updated.setAfMaestroId(3L);
        updated.setDescripcion("Nuevo");
        updated.setCosto(new BigDecimal("99.99"));
        updated.setFechaInstalacion(LocalDate.of(2026, 3, 10));

        when(service.findById(9L)).thenReturn(existing);
        when(service.update(eq(9L), any(AfAccesorio.class))).thenReturn(updated);

        var req = new AfAccesorioRequest();
        req.setAfMaestroId(3L);
        req.setDescripcion("Nuevo");
        req.setCosto(new BigDecimal("99.99"));
        req.setFechaInstalacion(LocalDate.of(2026, 3, 10));

        var resp = controller.actualizar(9L, req);

        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getDescripcion()).isEqualTo("Nuevo");
        assertThat(resp.getData().getCosto()).isEqualByComparingTo("99.99");

        ArgumentCaptor<AfAccesorio> captor = ArgumentCaptor.forClass(AfAccesorio.class);
        verify(service).update(eq(9L), captor.capture());
        assertThat(captor.getValue().getDescripcion()).isEqualTo("Nuevo");
        assertThat(captor.getValue().getCosto()).isEqualByComparingTo("99.99");
    }

    @Test
    void eliminar() {
        var resp = controller.eliminar(15L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData()).isTrue();
        verify(service).delete(15L);
    }
}
