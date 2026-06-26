package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.MesaRequest;
import pe.restaurant.ventas.dto.response.MesaResponse;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.mapper.MesaMapper;
import pe.restaurant.ventas.service.MesaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MesaControllerTest {

    @Mock
    private MesaService service;
    @Mock
    private MesaMapper mapper;
    @InjectMocks
    private MesaController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new Mesa())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new MesaResponse()));
        assertThat(controller.findAll(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(new Mesa());
        when(mapper.toResponse(any())).thenReturn(new MesaResponse());
        assertThat(controller.findById(1L).isSuccess()).isTrue();
    }

    @Test
    void create_update_delete_lifecycle() {
        MesaRequest req = new MesaRequest();
        req.setZonaId(1L);
        req.setNumero("M1");
        Mesa entity = new Mesa();
        entity.setId(2L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new MesaResponse());
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.findById(2L)).thenReturn(entity);
        when(service.update(eq(2L), any())).thenReturn(entity);
        assertThat(controller.update(2L, req).isSuccess()).isTrue();

        when(service.activate(2L)).thenReturn(entity);
        assertThat(controller.activate(2L).isSuccess()).isTrue();
        when(service.deactivate(2L)).thenReturn(entity);
        assertThat(controller.deactivate(2L).isSuccess()).isTrue();

        assertThat(controller.delete(2L).isSuccess()).isTrue();
        verify(service).delete(2L);
    }
}
