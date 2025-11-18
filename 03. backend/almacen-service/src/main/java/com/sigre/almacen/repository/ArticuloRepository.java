package com.sigre.almacen.repository;

import com.sigre.almacen.model.entity.Articulo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ArticuloRepository extends JpaRepository<Articulo, String> {
    
    List<Articulo> findByFlagEstado(String estado);
    
    List<Articulo> findByTipoArticulo(String tipo);
}

