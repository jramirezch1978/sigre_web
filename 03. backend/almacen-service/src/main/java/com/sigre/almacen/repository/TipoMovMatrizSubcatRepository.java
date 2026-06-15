package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.TipoMovMatrizSubcat;

import java.util.Optional;

public interface TipoMovMatrizSubcatRepository
        extends JpaRepository<TipoMovMatrizSubcat, TipoMovMatrizSubcat.TipoMovMatrizSubcatId> {

    Optional<TipoMovMatrizSubcat> findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(
            String tipoMov, String grpCntbl, String codSubCat);
}
