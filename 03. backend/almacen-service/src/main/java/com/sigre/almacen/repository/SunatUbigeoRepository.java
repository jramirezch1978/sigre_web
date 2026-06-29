package com.sigre.almacen.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.SunatUbigeo;

public interface SunatUbigeoRepository extends JpaRepository<SunatUbigeo, Long> {

    /** Solo ubigeos activos (flag_estado), ordenados por departamento/provincia/distrito. */
    List<SunatUbigeo> findByFlagEstadoOrderByDepartamentoAscProvinciaAscDistritoAsc(String flagEstado);
}
