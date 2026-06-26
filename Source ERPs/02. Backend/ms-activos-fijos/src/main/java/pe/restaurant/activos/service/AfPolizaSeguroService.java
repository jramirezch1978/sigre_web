package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfPolizaSeguro;

import java.util.List;

public interface AfPolizaSeguroService {
    Page<AfPolizaSeguro> findAll(Pageable pageable);
    AfPolizaSeguro findById(Long id);
    AfPolizaSeguro create(AfPolizaSeguro entity);
    AfPolizaSeguro update(Long id, AfPolizaSeguro entity);
    void delete(Long id);
    Page<AfPolizaSeguro> findPolizasVigentes(Pageable pageable);
    List<AfPolizaSeguro> findPolizasPorVencer(Integer dias);
    Page<AfPolizaSeguro> findByAseguradora(Long aseguradoraId, Pageable pageable);
    AfPolizaSeguro renovarPoliza(Long id, AfPolizaSeguro datosRenovacion);
}
