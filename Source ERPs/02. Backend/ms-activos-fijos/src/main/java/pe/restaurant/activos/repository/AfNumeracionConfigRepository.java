package pe.restaurant.activos.repository;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfNumeracionConfig;

import java.util.Optional;

public interface AfNumeracionConfigRepository extends JpaRepository<AfNumeracionConfig, Long> {

    Optional<AfNumeracionConfig> findByTipoIgnoreCase(String tipo);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT n FROM AfNumeracionConfig n WHERE UPPER(n.tipo) = UPPER(:tipo)")
    Optional<AfNumeracionConfig> findByTipoForUpdate(@Param("tipo") String tipo);
}
