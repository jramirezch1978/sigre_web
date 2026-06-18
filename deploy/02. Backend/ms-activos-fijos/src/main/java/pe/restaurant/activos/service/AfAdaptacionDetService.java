package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfAdaptacionDet;

import java.math.BigDecimal;
import java.util.List;

public interface AfAdaptacionDetService {
    AfAdaptacionDet findById(Long id);
    AfAdaptacionDet create(AfAdaptacionDet entity);
    AfAdaptacionDet update(Long id, AfAdaptacionDet entity);
    void delete(Long id);
    List<AfAdaptacionDet> findByAdaptacion(Long adaptacionId);
    BigDecimal calcularTotal(Long adaptacionId);
}
