package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.AuditOnlyMappedEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "proforma_det", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class ProformaDet extends AuditOnlyMappedEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "proforma_id", nullable = false)
    private Proforma proforma;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "descripcion", length = 250)
    private String descripcion;

    @Column(name = "cantidad", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "precio_unitario", nullable = false, precision = 18, scale = 4)
    private BigDecimal precioUnitario;

    @Column(name = "descuento", precision = 18, scale = 4)
    private BigDecimal descuento = BigDecimal.ZERO;

    @Column(name = "subtotal", precision = 18, scale = 4)
    private BigDecimal subtotal;
}
