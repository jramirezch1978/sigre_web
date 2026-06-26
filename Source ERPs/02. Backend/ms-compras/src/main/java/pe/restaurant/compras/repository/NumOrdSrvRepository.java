package pe.restaurant.compras.repository;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.compras.entity.NumOrdSrv;

import java.util.Optional;

public interface NumOrdSrvRepository extends JpaRepository<NumOrdSrv, Long> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT n FROM NumOrdSrv n WHERE n.sucursalId = :sucursalId AND n.codOrigen = :codOrigen")
    Optional<NumOrdSrv> findForUpdate(@Param("sucursalId") Long sucursalId,
                                      @Param("codOrigen") String codOrigen);
}
