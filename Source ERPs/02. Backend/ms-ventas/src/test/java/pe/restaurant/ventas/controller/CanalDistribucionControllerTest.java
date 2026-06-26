package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.CanalDistribucionRequest;
import pe.restaurant.ventas.dto.response.CanalDistribucionResponse;
import pe.restaurant.ventas.entity.CanalDistribucion;
import pe.restaurant.ventas.mapper.CanalDistribucionMapper;
import pe.restaurant.ventas.service.CanalDistribucionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CanalDistribucionControllerTest {

    @Mock
    private CanalDistribucionService service;
    @Mock
    private CanalDistribucionMapper mapper;
    @InjectMocks
    private CanalDistribucionController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new CanalDistribucion())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new CanalDistribucionResponse()));
        assertThat(controller.findAll(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(new CanalDistribucion());
        when(mapper.toResponse(any())).thenReturn(new CanalDistribucionResponse());
        assertThat(controller.findById(1L).isSuccess()).isTrue();
    }

    @Test
    void create_update_delete_activate_deactivate() {
        CanalDistribucionRequest req = new CanalDistribucionRequest();
        req.setCodigo("CD1");
        req.setNombre("Canal");
        CanalDistribucion entity = new CanalDistribucion();
        entity.setId(1L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new CanalDistribucionResponse());
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        assertThat(controller.update(1L, req).isSuccess()).isTrue();

        when(service.activate(1L)).thenReturn(entity);
        assertThat(controller.activate(1L).isSuccess()).isTrue();
        when(service.deactivate(1L)).thenReturn(entity);
        assertThat(controller.deactivate(1L).isSuccess()).isTrue();

        assertThat(controller.delete(1L).isSuccess()).isTrue();
        verify(service).delete(1L);
    }
}
