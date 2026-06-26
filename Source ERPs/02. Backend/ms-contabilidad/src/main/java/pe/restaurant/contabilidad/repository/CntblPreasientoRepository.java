package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.CntblPreasiento;

import java.util.List;
import java.util.Optional;

@Repository
public interface CntblPreasientoRepository extends JpaRepository<CntblPreasiento, Long> {

    @Query("SELECT p FROM CntblPreasiento p LEFT JOIN FETCH p.detalles WHERE p.id = :id")
    Optional<CntblPreasiento> findByIdWithDetalles(@Param("id") Long id);

    Optional<CntblPreasiento> findByModuloOrigenAndNaturalezaAsientoAndVoucher(
            String moduloOrigen, String naturalezaAsiento, String voucher);

    @Query("SELECT p FROM CntblPreasiento p LEFT JOIN FETCH p.detalles " +
           "WHERE p.sucursalId = :sucursalId " +
           "AND YEAR(p.fecha) = :anio AND MONTH(p.fecha) = :mes " +
           "AND p.flagEstado = '1' AND p.fechaProcesamiento IS NULL")
    List<CntblPreasiento> findPendientesBySucursalAndPeriodo(
            @Param("sucursalId") Long sucursalId,
            @Param("anio") Integer anio,
            @Param("mes") Integer mes);

    @Query(value = "SELECT contabilidad.fn_get_voucher_number(:sucursalId, :anio, :mes, :libroId)",
           nativeQuery = true)
    String getVoucherNumber(@Param("sucursalId") Long sucursalId,
                            @Param("anio") Integer anio,
                            @Param("mes") Integer mes,
                            @Param("libroId") Long libroId);
}
