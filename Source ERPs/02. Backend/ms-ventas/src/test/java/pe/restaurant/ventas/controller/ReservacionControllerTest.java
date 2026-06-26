package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ReservacionRequest;
import pe.restaurant.ventas.dto.response.ReservacionResponse;
import pe.restaurant.ventas.entity.Reservacion;
import pe.restaurant.ventas.mapper.VentasIssue5DtoMapper;
import pe.restaurant.ventas.service.ReservacionService;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ReservacionControllerTest {

    @Mock
    private ReservacionService service;
    @Mock
    private VentasIssue5DtoMapper mapper;
    @InjectMocks
    private ReservacionController controller;

    @Test
    void list() {
        when(service.findAll(any(), any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new Reservacion())));
        when(mapper.toReservacionListItem(any())).thenReturn(ReservacionResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null, null, null, null).isSuccess()).isTrue();
    }

    @Test
    void getById() {
        when(service.getById(1L)).thenReturn(new Reservacion());
        when(mapper.toReservacionResponse(any())).thenReturn(
                ReservacionResponse.builder().id(1L).fsFacturaSimplId(10L).build());
        assertThat(controller.get(1L).getData().getFsFacturaSimplId()).isEqualTo(10L);
    }

    @Test
    void create() {
        ReservacionRequest req = ReservacionRequest.builder()
                .sucursalId(1L)
                .fecha(LocalDate.now().plusDays(10))
                .hora(LocalTime.NOON)
                .fsFacturaSimplId(99L)
                .build();
        when(service.create(any())).thenAnswer(inv -> {
            Reservacion r = new Reservacion();
            r.setId(5L);
            r.setFsFacturaSimplId(inv.getArgument(0, ReservacionRequest.class).getFsFacturaSimplId());
            return r;
        });
        when(mapper.toReservacionResponse(any())).thenAnswer(inv -> {
            Reservacion r = inv.getArgument(0);
            return ReservacionResponse.builder().id(r.getId()).fsFacturaSimplId(r.getFsFacturaSimplId()).build();
        });
        var resp = controller.create(req);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getFsFacturaSimplId()).isEqualTo(99L);
    }

    @Test
    void update() {
        ReservacionRequest req = ReservacionRequest.builder()
                .fecha(LocalDate.now().plusDays(10))
                .hora(LocalTime.NOON)
                .build();
        when(service.update(eq(2L), any())).thenReturn(new Reservacion());
        when(mapper.toReservacionResponse(any())).thenReturn(ReservacionResponse.builder().id(2L).build());
        assertThat(controller.update(2L, req).isSuccess()).isTrue();
    }

    @Test
    void confirmarCancelarActivarDesactivar() {
        when(service.confirmar(1L)).thenReturn(new Reservacion());
        when(service.cancelar(eq(1L), any())).thenReturn(new Reservacion());
        when(service.activar(1L)).thenReturn(new Reservacion());
        when(service.desactivar(1L)).thenReturn(new Reservacion());
        when(mapper.toReservacionResponse(any())).thenReturn(ReservacionResponse.builder().id(1L).build());
        assertThat(controller.confirmar(1L).isSuccess()).isTrue();
        assertThat(controller.cancelar(1L, null).isSuccess()).isTrue();
        assertThat(controller.activar(1L).isSuccess()).isTrue();
        assertThat(controller.desactivar(1L).isSuccess()).isTrue();
        verify(service).cancelar(eq(1L), any());
    }
}
