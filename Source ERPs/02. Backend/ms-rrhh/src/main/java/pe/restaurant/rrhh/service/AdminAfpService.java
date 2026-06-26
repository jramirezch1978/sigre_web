package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.AdminAfpRequest;
import pe.restaurant.rrhh.dto.response.AdminAfpResponse;

import java.util.List;

public interface AdminAfpService {

    Page<AdminAfpResponse> listar(String nombre, String flagEstado, Pageable pageable);

    AdminAfpResponse obtenerPorId(Long id);

    AdminAfpResponse crear(AdminAfpRequest request);

    AdminAfpResponse actualizar(Long id, AdminAfpRequest request);

    AdminAfpResponse desactivar(Long id);

    AdminAfpResponse activar(Long id);

    List<AdminAfpResponse> listarActivos();
}
