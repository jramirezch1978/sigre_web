package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.compras.entity.ArticuloPrecioPactado;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ArticuloPrecioPactadoRepository extends JpaRepository<ArticuloPrecioPactado, Long>,
        JpaSpecificationExecutor<ArticuloPrecioPactado> {

    List<ArticuloPrecioPactado> findByArticuloId(Long articuloId);

    List<ArticuloPrecioPactado> findByProveedorId(Long proveedorId);

    @Query(value = "SELECT precio FROM compras.articulo_precio_pactado " +
            "WHERE articulo_id = :articuloId AND proveedor_id = :proveedorId AND moneda_id = :monedaId " +
            "AND flag_estado = '1' " +
            "AND (fecha_desde IS NULL OR fecha_desde <= :fecha) " +
            "AND (fecha_hasta IS NULL OR fecha_hasta >= :fecha) " +
            "ORDER BY fecha_desde DESC NULLS LAST LIMIT 1",
            nativeQuery = true)
    Optional<BigDecimal> findPrecioVigente(Long articuloId, Long proveedorId, Long monedaId, LocalDate fecha);
}
