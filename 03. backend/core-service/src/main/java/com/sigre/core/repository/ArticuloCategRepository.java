package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloCateg;

public interface ArticuloCategRepository extends JpaRepository<ArticuloCateg, Long> {
    boolean existsByCatArtIgnoreCase(String catArt);
    boolean existsByCatArtIgnoreCaseAndIdNot(String catArt, Long id);
    Page<ArticuloCateg> findByFlagEstado(String flagEstado, Pageable pageable);
}
