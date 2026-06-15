package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.Aprobacion;

import java.util.List;

public interface AprobacionRepository extends JpaRepository<Aprobacion, Long> {

    List<Aprobacion> findByDocTipoIdAndDocumentoIdOrderByFechaAsc(Long docTipoId, Long documentoId);
}
