package pe.restaurant.ventas.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "propina", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Propina extends BaseEntity {

    @Column(name = "fs_factura_simpl_id", nullable = false)
    private Long fsFacturaSimplId;

    @Column(name = "trabajador_id")
    private Long trabajadorId;

    @Column(name = "monto", nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;
}
