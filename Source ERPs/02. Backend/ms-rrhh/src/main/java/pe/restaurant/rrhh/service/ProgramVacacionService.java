package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.ProgramVacacionCreateRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionImportarRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.ProgramVacacionResponse;

import java.util.List;

public interface ProgramVacacionService {
    Page<ProgramVacacionResponse> listar(Long trabajadorId, Integer anio, Pageable pageable);
    ProgramVacacionResponse obtenerPorId(Long id);
    ProgramVacacionResponse crear(ProgramVacacionCreateRequest request);
    ProgramVacacionResponse actualizar(Long id, ProgramVacacionUpdateRequest request);
    ProgramVacacionResponse desactivar(Long id);
    List<ProgramVacacionResponse> importar(ProgramVacacionImportarRequest request);
    byte[] exportarExcel(Integer anio);
}
