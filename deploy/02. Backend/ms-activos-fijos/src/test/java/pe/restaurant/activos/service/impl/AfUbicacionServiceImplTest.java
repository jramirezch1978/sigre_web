package pe.restaurant.activos.service.impl;

import feign.FeignException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import pe.restaurant.activos.client.CoreMaestrosClient;
import pe.restaurant.activos.dto.SucursalResponse;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfUbicacionServiceImplTest {

    @Mock
    private AfUbicacionRepository repository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private CoreMaestrosClient coreMaestrosClient;
    @InjectMocks
    private AfUbicacionServiceImpl service;

    @Test
    void findAllReturnsPageData() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        Page<AfUbicacion> result = service.findAll(PageRequest.of(0, 10));
        assertEquals(1, result.getContent().size());
        assertEquals("UB001", result.getContent().get(0).getCodigo());
    }

    @Test
    void findByIdReturnsEntity() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        AfUbicacion result = service.findById(1L);
        assertEquals("UB001", result.getCodigo());
        assertEquals(1L, result.getId());
    }

    @Test
    void findByIdThrowsNotFound() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findById(9L));
    }

    @Test
    void createSavesEntity() {
        AfUbicacion entity = new AfUbicacion();
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        AfUbicacion saved = new AfUbicacion();
        saved.setId(1L);
        saved.setSucursalId(1L);
        saved.setCodigo("UB001");
        saved.setNombre("Ubicación Test");
        saved.setFlagEstado("1");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Test");
        sucursal.setFlagEstado("1");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(coreMaestrosClient.obtenerSucursalPorId(1L)).thenReturn(sucursalResponse);
        when(repository.existsBySucursalIdAndCodigoIgnoreCase(1L, "UB001")).thenReturn(false);
        when(repository.save(any(AfUbicacion.class))).thenReturn(saved);
        
        AfUbicacion result = service.create(entity);
        assertEquals("UB001", result.getCodigo());
        assertEquals("1", result.getFlagEstado());
        assertEquals(1L, result.getId());
    }

    @Test
    void createThrowsNotFoundWhenSucursalNotExists() {
        AfUbicacion entity = new AfUbicacion();
        entity.setSucursalId(999L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        when(coreMaestrosClient.obtenerSucursalPorId(999L))
                .thenThrow(FeignException.NotFound.class);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.SUCURSAL_NO_ENCONTRADA, exception.getErrorCode());
    }

    @Test
    void createThrowsBadRequestWhenSucursalInactive() {
        AfUbicacion entity = new AfUbicacion();
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Inactiva");
        sucursal.setFlagEstado("0");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(coreMaestrosClient.obtenerSucursalPorId(1L)).thenReturn(sucursalResponse);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.SUCURSAL_INACTIVA, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("inactiva"));
    }

    @Test
    void createThrowsConflictWhenCodigoExists() {
        AfUbicacion entity = new AfUbicacion();
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Test");
        sucursal.setFlagEstado("1");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(coreMaestrosClient.obtenerSucursalPorId(1L)).thenReturn(sucursalResponse);
        when(repository.existsBySucursalIdAndCodigoIgnoreCase(1L, "UB001")).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals(ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO, exception.getErrorCode());
        assertTrue(exception.getMessage().contains("UB001"));
    }

    @Test
    void createThrowsServiceUnavailableWhenFeignError() {
        AfUbicacion entity = new AfUbicacion();
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación Test");
        
        when(coreMaestrosClient.obtenerSucursalPorId(1L))
                .thenThrow(FeignException.ServiceUnavailable.class);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.create(entity));
        assertEquals("ACT-999", exception.getErrorCode());
        assertTrue(exception.getMessage().contains("Error al validar la sucursal"));
    }

    @Test
    void updateModifiesEntity() {
        AfUbicacion existing = new AfUbicacion();
        existing.setId(1L);
        existing.setSucursalId(1L);
        existing.setCodigo("UB001");
        existing.setNombre("Ubicación Original");
        
        AfUbicacion updateData = new AfUbicacion();
        updateData.setSucursalId(1L);
        updateData.setCodigo("UB001");
        updateData.setNombre("Ubicación Actualizada");
        
        AfUbicacion updated = new AfUbicacion();
        updated.setId(1L);
        updated.setSucursalId(1L);
        updated.setCodigo("UB001");
        updated.setNombre("Ubicación Actualizada");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Test");
        sucursal.setFlagEstado("1");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        lenient().when(coreMaestrosClient.obtenerSucursalPorId(1L)).thenReturn(sucursalResponse);
        when(repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(1L, "UB001", 1L)).thenReturn(false);
        when(repository.save(any(AfUbicacion.class))).thenReturn(updated);
        
        AfUbicacion result = service.update(1L, updateData);
        assertEquals("Ubicación Actualizada", result.getNombre());
    }

    @Test
    void updateValidatesSucursalWhenChanged() {
        AfUbicacion existing = new AfUbicacion();
        existing.setId(1L);
        existing.setSucursalId(1L);
        existing.setCodigo("UB001");
        existing.setNombre("Ubicación Original");
        
        AfUbicacion updateData = new AfUbicacion();
        updateData.setSucursalId(2L);
        updateData.setCodigo("UB001");
        updateData.setNombre("Ubicación Actualizada");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(2L);
        sucursal.setCodigo("PI");
        sucursal.setNombre("Sucursal Nueva");
        sucursal.setFlagEstado("1");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(coreMaestrosClient.obtenerSucursalPorId(2L)).thenReturn(sucursalResponse);
        when(repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(2L, "UB001", 1L)).thenReturn(false);
        when(repository.save(any(AfUbicacion.class))).thenReturn(updateData);
        
        AfUbicacion result = service.update(1L, updateData);
        assertEquals(2L, result.getSucursalId());
        verify(coreMaestrosClient).obtenerSucursalPorId(2L);
    }

    @Test
    void updateThrowsConflictWhenCodigoExistsInOtherEntity() {
        AfUbicacion existing = new AfUbicacion();
        existing.setId(1L);
        existing.setSucursalId(1L);
        existing.setCodigo("UB001");
        
        AfUbicacion updateData = new AfUbicacion();
        updateData.setSucursalId(1L);
        updateData.setCodigo("UB002");
        
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Test");
        sucursal.setFlagEstado("1");
        
        ApiResponse<SucursalResponse> sucursalResponse = ApiResponse.ok(sucursal);
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        lenient().when(coreMaestrosClient.obtenerSucursalPorId(1L)).thenReturn(sucursalResponse);
        when(repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(1L, "UB002", 1L)).thenReturn(true);
        
        BusinessException exception = assertThrows(BusinessException.class, () -> service.update(1L, updateData));
        assertEquals(ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO, exception.getErrorCode());
    }

    @Test
    void activateSetsEstadoToActive() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setFlagEstado("0");
        
        AfUbicacion activated = new AfUbicacion();
        activated.setId(1L);
        activated.setSucursalId(1L);
        activated.setCodigo("UB001");
        activated.setFlagEstado("1");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfUbicacion.class))).thenReturn(activated);
        
        AfUbicacion result = service.activate(1L);
        assertEquals("1", result.getFlagEstado());
    }

    @Test
    void deactivateSetsEstadoToInactive() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        
        AfUbicacion deactivated = new AfUbicacion();
        deactivated.setId(1L);
        deactivated.setSucursalId(1L);
        deactivated.setCodigo("UB001");
        deactivated.setFlagEstado("0");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(AfUbicacion.class))).thenReturn(deactivated);
        
        AfUbicacion result = service.deactivate(1L);
        assertEquals("0", result.getFlagEstado());
    }

    @Test
    void deleteRemovesEntity() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.existsByAfUbicacionId(1L)).thenReturn(false);

        assertDoesNotThrow(() -> service.delete(1L));
        verify(repository).delete(entity);
    }

    @Test
    void deleteThrowsWhenMaestroExists() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(maestroRepository.existsByAfUbicacionId(1L)).thenReturn(true);

        BusinessException exception = assertThrows(BusinessException.class, () -> service.delete(1L));
        assertEquals(ActivosErrorCodes.UBICACION_CON_MAESTROS, exception.getErrorCode());
    }
}
