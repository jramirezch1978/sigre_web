package pe.restaurant.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.entity.Detraccion;
import pe.restaurant.core.mapper.DetraccionMapper;
import pe.restaurant.core.service.DetraccionService;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DetraccionControllerTest {

    @Mock private DetraccionService service;
    @Mock private DetraccionMapper mapper;
    @InjectMocks private DetraccionController controller;

    @Test
    void listCallsService() {
        Detraccion entity = new Detraccion("001", "Servicios", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        Page<Detraccion> page = new PageImpl<>(List.of(entity));
        when(service.list(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(
                new DetraccionResponse(1L, "001", "Servicios", "1", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO)
        );
        var result = controller.list(Pageable.unpaged());
        assertEquals(1, result.getData().getContent().size());
        verify(service).list(any(Pageable.class));
    }

    @Test
    void createCallsService() {
        DetraccionRequest request = new DetraccionRequest("001", "Servicios", "1", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        when(service.create(request)).thenReturn(new DetraccionResponse());
        assertTrue(controller.create(request).isSuccess());
        verify(service).create(request);
    }

    @Test
    void getByIdCallsService() {
        var resp = new DetraccionResponse(1L, "001", "Servicios", "1", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        when(service.getById("001")).thenReturn(resp);
        var result = controller.getById("001");
        assertTrue(result.isSuccess());
        assertEquals("001", result.getData().getBienServ());
    }

    @Test
    void updateCallsService() {
        DetraccionRequest request = new DetraccionRequest("001", "Servicios Mod", "1", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        when(service.update("001", request)).thenReturn(new DetraccionResponse());
        var result = controller.update("001", request);
        assertTrue(result.isSuccess());
        verify(service).update("001", request);
    }

    @Test
    void deleteCallsService() {
        doNothing().when(service).delete("001");
        var result = controller.delete("001");
        assertTrue(result.isSuccess());
        assertTrue(result.getData());
        verify(service).delete("001");
    }

    @Test
    void activateCallsService() {
        Detraccion entity = new Detraccion("001", "Servicios", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        when(service.activate("001")).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new DetraccionResponse());
        var result = controller.activate("001");
        assertTrue(result.isSuccess());
        verify(service).activate("001");
    }

    @Test
    void deactivateCallsService() {
        Detraccion entity = new Detraccion("001", "Servicios", "02", BigDecimal.ONE, "1", null, BigDecimal.ZERO);
        when(service.deactivate("001")).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new DetraccionResponse());
        var result = controller.deactivate("001");
        assertTrue(result.isSuccess());
        verify(service).deactivate("001");
    }
}
