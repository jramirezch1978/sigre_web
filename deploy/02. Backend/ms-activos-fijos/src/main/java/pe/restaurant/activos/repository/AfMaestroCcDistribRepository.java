package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfMaestroCcDistrib;

import java.util.List;

public interface AfMaestroCcDistribRepository extends JpaRepository<AfMaestroCcDistrib, Long> {

    List<AfMaestroCcDistrib> findByAfMaestroIdOrderByIdAsc(Long afMaestroId);

    void deleteByAfMaestroId(Long afMaestroId);

    boolean existsByAfMaestroId(Long afMaestroId);
}
