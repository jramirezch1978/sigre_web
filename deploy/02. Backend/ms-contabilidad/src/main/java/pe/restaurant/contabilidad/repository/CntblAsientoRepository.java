package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.CntblAsiento;

import java.util.List;
import java.util.Optional;

@Repository
public interface CntblAsientoRepository extends JpaRepository<CntblAsiento, Long>, JpaSpecificationExecutor<CntblAsiento> {
    
    @Query("SELECT a FROM CntblAsiento a LEFT JOIN FETCH a.detalles WHERE a.id = :id")
    Optional<CntblAsiento> findByIdWithDetalles(@Param("id") Long id);
    
    List<CntblAsiento> findByFlagEstado(String flagEstado);
    
    boolean existsByVoucher(String voucher);

    @Query(value = "SELECT contabilidad.fn_get_voucher_number(:sucursalId, :anio, :mes, :libroId)",
           nativeQuery = true)
    String getVoucherNumber(@Param("sucursalId") Long sucursalId,
                            @Param("anio") Integer anio,
                            @Param("mes") Integer mes,
                            @Param("libroId") Long libroId);
}
