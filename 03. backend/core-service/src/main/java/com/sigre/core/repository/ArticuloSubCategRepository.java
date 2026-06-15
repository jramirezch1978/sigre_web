package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloSubCateg;

import java.util.List;

public interface ArticuloSubCategRepository extends JpaRepository<ArticuloSubCateg, Long> {
    boolean existsByCodSubCatIgnoreCase(String codSubCat);
    boolean existsByCodSubCatIgnoreCaseAndIdNot(String codSubCat, Long id);
    List<ArticuloSubCateg> findByArticuloCategId(Long articuloCategId);
    List<ArticuloSubCateg> findByArticuloCategIdAndFlagEstado(Long articuloCategId, String flagEstado);
    Page<ArticuloSubCateg> findByArticuloCategId(Long articuloCategId, Pageable pageable);
}
