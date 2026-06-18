package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.PedidoMesaDet;

import java.util.List;

@Repository
public interface PedidoMesaDetRepository extends JpaRepository<PedidoMesaDet, Long> {

    // Buscar items de un pedido mesa
    @Query("SELECT pmd FROM PedidoMesaDet pmd WHERE pmd.pedidoMesa.id = :pedidoMesaId AND pmd.flagEstado = '1' ORDER BY pmd.id")
    List<PedidoMesaDet> findByPedidoMesaId(@Param("pedidoMesaId") Long pedidoMesaId);

    // Validación de FK: articulo debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.articulo WHERE id = :articuloId AND flag_estado = '1')", nativeQuery = true)
    boolean existsArticuloActivo(@Param("articuloId") Long articuloId);
}
