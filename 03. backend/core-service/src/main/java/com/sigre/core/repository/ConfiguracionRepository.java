package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.Configuracion;

import java.util.List;
import java.util.Optional;

public interface ConfiguracionRepository extends JpaRepository<Configuracion, Long> {
    List<Configuracion> findByFlagEstado(String flagEstado);
    List<Configuracion> findByModuloAndFlagEstado(String modulo, String flagEstado);
    Optional<Configuracion> findByParametroAndFlagEstado(String parametro, String flagEstado);
}
