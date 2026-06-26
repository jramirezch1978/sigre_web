package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.entity.Detraccion;

public interface DetraccionService {
    Page<Detraccion> list(Pageable pageable);
    DetraccionResponse getById(String bienServ);
    DetraccionResponse create(DetraccionRequest request);
    DetraccionResponse update(String bienServ, DetraccionRequest request);
    void delete(String bienServ);
    Detraccion activate(String bienServ);
    Detraccion deactivate(String bienServ);
}
