package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.FormaEmbarque;

public interface FormaEmbarqueRepository extends JpaRepository<FormaEmbarque, Long> {

    boolean existsByFormaEmbarqueIgnoreCase(String formaEmbarque);

    boolean existsByFormaEmbarqueIgnoreCaseAndIdNot(String formaEmbarque, Long id);
}
