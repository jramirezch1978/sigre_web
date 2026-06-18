package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfAdaptacionDep;

import java.util.List;

public interface AfAdaptacionDepService {
    AfAdaptacionDep findById(Long id);
    AfAdaptacionDep create(AfAdaptacionDep entity);
    AfAdaptacionDep update(Long id, AfAdaptacionDep entity);
    void delete(Long id);
    List<AfAdaptacionDep> findByAdaptacion(Long adaptacionId);
    List<AfAdaptacionDep> findByPeriodo(Integer anio, Integer mes);
    AfAdaptacionDep calcularDepreciacion(Long adaptacionId, Integer anio, Integer mes);
}
