package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.LotePalletRequest;
import pe.restaurant.almacen.dto.LotePalletResponse;
import pe.restaurant.almacen.entity.LotePallet;
import pe.restaurant.almacen.mapper.LotePalletMapper;
import pe.restaurant.almacen.service.LotePalletService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LotePalletControllerTest {

    @Mock
    private LotePalletService service;

    @Mock
    private LotePalletMapper mapper;

    @InjectMocks
    private LotePalletController controller;

    private LotePallet entity;
    private LotePalletResponse response;

    @BeforeEach
    void setUp() {
        entity = new LotePallet();
        entity.setId(1L);
        entity.setAlmacenId(10L);
        entity.setArticuloId(100L);
        entity.setNroLote("L-001");

        response = new LotePalletResponse(
                1L, 10L, 100L, "L-001",
                LocalDate.of(2026, 1, 1),
                LocalDate.of(2027, 1, 1),
                null,
                "1");
    }

    @Test
    void buscar_mapsThroughMapper() {
        var page = new PageImpl<>(List.of(entity));
        when(service.buscar(isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(anyList())).thenReturn(List.of(response));

        var result = controller.buscar(null, null, Pageable.unpaged());

        assertThat(result.getData().getContent()).containsExactly(response);
        verify(mapper).toResponseList(page.getContent());
    }

    @Test
    void findById_mapsEntity() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        assertThat(controller.findById(1L).getData().getNroLote()).isEqualTo("L-001");
    }

    @Test
    void create_update_activate_deactivate_delegate() {
        LotePalletRequest req = new LotePalletRequest();
        req.setAlmacenId(10L);
        req.setArticuloId(100L);
        req.setNroLote("L-NEW");

        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(service.update(eq(1L), eq(entity))).thenReturn(entity);
        when(service.deactivate(1L)).thenReturn(entity);
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        assertThat(controller.create(req).getMessage()).isEqualTo("Registro creado");

        when(service.findById(1L)).thenReturn(entity);
        assertThat(controller.update(1L, req).getMessage()).isEqualTo("Registro actualizado");

        assertThat(controller.deactivate(1L).getMessage()).isEqualTo("Registro desactivado");
        assertThat(controller.activate(1L).getMessage()).isEqualTo("Registro activado");
    }
}
