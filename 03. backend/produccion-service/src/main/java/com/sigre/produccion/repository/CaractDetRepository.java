package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.produccion.entity.ArticuloDocTecnicaCaractDet;

import java.util.List;

public interface CaractDetRepository extends JpaRepository<ArticuloDocTecnicaCaractDet, Long> {

    List<ArticuloDocTecnicaCaractDet> findByArticuloDocTecnicaIdOrderByIdAsc(Long articuloDocTecnicaId);

    void deleteByArticuloDocTecnicaId(Long articuloDocTecnicaId);
}
