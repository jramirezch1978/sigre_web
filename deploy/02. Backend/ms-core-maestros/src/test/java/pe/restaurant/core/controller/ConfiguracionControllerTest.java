package pe.restaurant.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.service.ConfiguracionService;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConfiguracionControllerTest {

    @Mock private ConfiguracionService service;
    @InjectMocks private ConfiguracionController controller;

    @Test
    void listClavesDelegates() {
        when(service.listClaves(null, null, null)).thenReturn(List.of());
        assertTrue(controller.listClaves(null, null, null).isSuccess());
        verify(service).listClaves(null, null, null);
    }

    @Test
    void resolverDelegates() {
        ConfigResolverRequest request = new ConfigResolverRequest("IGV", null);
        when(service.resolver(request)).thenReturn(new ConfigResolverResult("18", "EMPRESA"));
        assertTrue(controller.resolver(request).isSuccess());
        verify(service).resolver(request);
    }

    @Test
    void getEmpresaDelegates() {
        when(service.getEmpresa(1L, null)).thenReturn(Map.of());
        assertTrue(controller.getEmpresa(1L, null).isSuccess());
        verify(service).getEmpresa(1L, null);
    }

    @Test
    void getEmpresaWithClavesDelegates() {
        when(service.getEmpresa(1L, List.of("IGV", "MONEDA")))
                .thenReturn(Map.of("IGV", 18, "MONEDA", "PEN"));
        var result = controller.getEmpresa(1L, List.of("IGV", "MONEDA"));
        assertTrue(result.isSuccess());
        verify(service).getEmpresa(1L, List.of("IGV", "MONEDA"));
    }

    @Test
    void saveEmpresaDelegates() {
        var request = new ConfigEmpresaSaveRequest(1L, Map.of("IGV", 18));
        when(service.saveEmpresa(request)).thenReturn(Map.of("IGV", 18));
        var result = controller.saveEmpresa(request);
        assertTrue(result.isSuccess());
        verify(service).saveEmpresa(request);
    }

    @Test
    void getSucursalDelegates() {
        when(service.getSucursal(1L, 2L, null)).thenReturn(Map.of());
        var result = controller.getSucursal(1L, 2L, null);
        assertTrue(result.isSuccess());
        verify(service).getSucursal(1L, 2L, null);
    }

    @Test
    void getSucursalWithClavesDelegates() {
        when(service.getSucursal(1L, 2L, List.of("CAJA")))
                .thenReturn(Map.of("CAJA", "A"));
        var result = controller.getSucursal(1L, 2L, List.of("CAJA"));
        assertTrue(result.isSuccess());
    }

    @Test
    void saveSucursalDelegates() {
        var request = new ConfigSucursalSaveRequest(1L, 2L, Map.of("CAJA", "A"));
        when(service.saveSucursal(request)).thenReturn(Map.of("CAJA", "A"));
        var result = controller.saveSucursal(request);
        assertTrue(result.isSuccess());
        verify(service).saveSucursal(request);
    }

    @Test
    void getUsuarioDelegates() {
        when(service.getUsuario(1L, 5L, null, null)).thenReturn(Map.of());
        var result = controller.getUsuario(1L, 5L, null, null);
        assertTrue(result.isSuccess());
        verify(service).getUsuario(1L, 5L, null, null);
    }

    @Test
    void getUsuarioWithSucursalAndClavesDelegates() {
        when(service.getUsuario(1L, 5L, 2L, List.of("THEME")))
                .thenReturn(Map.of("THEME", "dark"));
        var result = controller.getUsuario(1L, 5L, 2L, List.of("THEME"));
        assertTrue(result.isSuccess());
    }

    @Test
    void saveUsuarioDelegates() {
        var request = new ConfigUsuarioSaveRequest(1L, 5L, 2L, Map.of("THEME", "dark"));
        when(service.saveUsuario(request)).thenReturn(Map.of("THEME", "dark"));
        var result = controller.saveUsuario(request);
        assertTrue(result.isSuccess());
        verify(service).saveUsuario(request);
    }

    @Test
    void listClavesWithFiltersDelegates() {
        when(service.listClaves("COMPRAS", "EMPRESA", "1")).thenReturn(List.of());
        var result = controller.listClaves("COMPRAS", "EMPRESA", "1");
        assertTrue(result.isSuccess());
        verify(service).listClaves("COMPRAS", "EMPRESA", "1");
    }
}
