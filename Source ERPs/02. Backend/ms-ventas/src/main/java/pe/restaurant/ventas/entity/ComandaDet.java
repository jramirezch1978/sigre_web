package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "comanda_det", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = "comanda")
public class ComandaDet extends BaseEntity {

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "comanda_id", nullable = false)
    private Comanda comanda;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "cantidad", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "precio_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal precioUnitario;

    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "observacion", length = 250)
    private String observacion;
}
