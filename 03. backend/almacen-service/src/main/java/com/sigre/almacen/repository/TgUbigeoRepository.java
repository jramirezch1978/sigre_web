package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.TgUbigeo;

public interface TgUbigeoRepository extends JpaRepository<TgUbigeo, Long> {

    java.util.List<TgUbigeo> findAllByOrderByUbigeDescripcionAsc();
}
