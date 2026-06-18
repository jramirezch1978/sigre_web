package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.dto.response.CargoResponse;

import java.util.List;

public interface CargoService {

    Page<CargoResponse> listar(Pageable pageable, String nombre, String nivel);
    CargoResponse obtener(Long id);
    CargoResponse crear(CargoRequest request);
    CargoResponse actualizar(Long id, CargoRequest request);
    CargoResponse desactivar(Long id);
    CargoResponse activar(Long id);
    List<CargoResponse> listarActivos();
}
