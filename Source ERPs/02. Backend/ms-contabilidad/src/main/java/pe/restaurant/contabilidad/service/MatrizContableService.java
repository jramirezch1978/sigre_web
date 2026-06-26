package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.MatrizContableDetRequest;
import pe.restaurant.contabilidad.dto.request.MatrizContableRequest;
import pe.restaurant.contabilidad.entity.MatrizContable;
import pe.restaurant.contabilidad.entity.MatrizContableDet;

import java.util.List;

public interface MatrizContableService {

    Page<MatrizContable> findAll(String q, Long grupoMatrizCntblId, String flagEstado, Pageable pageable);

    MatrizContable findById(Long id);

    MatrizContable create(MatrizContableRequest request);

    MatrizContable update(Long id, MatrizContableRequest request);

    void delete(Long id);

    List<MatrizContableDet> findDetalles(Long matrizId);

    MatrizContableDet createDetalle(Long matrizId, MatrizContableDetRequest request);

    MatrizContableDet updateDetalle(Long matrizId, Long detalleId, MatrizContableDetRequest request);

    void deleteDetalle(Long matrizId, Long detalleId);
}
