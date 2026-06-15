package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.comercializacion.dto.request.CartaRequest;
import com.sigre.comercializacion.dto.response.CartaResponse;
import com.sigre.comercializacion.entity.CartaDet;
import com.sigre.comercializacion.mapper.CartaMapper;
import com.sigre.comercializacion.service.CartaService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CartaItemControllerTest {

    @Mock
    private CartaService service;
    @Mock
    private CartaMapper mapper;
    @InjectMocks
    private CartaItemController controller;

    @Test
    void findAllByCartaId() {
        when(service.findItemsByCartaId(1L)).thenReturn(List.of(new CartaDet()));
        when(mapper.toDetResponseList(any())).thenReturn(List.of());
        assertThat(controller.findAllByCartaId(1L).isSuccess()).isTrue();
    }

    @Test
    void add_update_delete_item() {
        CartaRequest.CartaDetRequest req = new CartaRequest.CartaDetRequest();
        req.setArticuloId(10L);
        req.setPrecio(new BigDecimal("15"));
        CartaDet det = new CartaDet();
        det.setId(5L);
        when(mapper.toDetEntity(req)).thenReturn(det);
        when(service.addItem(1L, det)).thenReturn(det);
        when(mapper.toDetResponse(det)).thenReturn(new CartaResponse.CartaDetResponse());
        assertThat(controller.addItem(1L, req).isSuccess()).isTrue();

        CartaRequest.CartaDetUpdateRequest upd = new CartaRequest.CartaDetUpdateRequest();
        upd.setPrecio(new BigDecimal("20"));
        upd.setOrden(2);
        when(service.updateItemFields(1L, 5L, upd.getPrecio(), upd.getOrden())).thenReturn(det);
        assertThat(controller.updateItem(1L, 5L, upd).isSuccess()).isTrue();

        assertThat(controller.deleteItem(1L, 5L).isSuccess()).isTrue();
        verify(service).deleteItem(1L, 5L);
    }
}
