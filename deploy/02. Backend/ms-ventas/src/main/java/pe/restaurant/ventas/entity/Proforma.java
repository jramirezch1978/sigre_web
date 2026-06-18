package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "proforma", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Proforma extends BaseEntity {

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "cliente_id")
    private Long clienteId;

    @Column(name = "numero", nullable = false, length = 30, unique = true)
    private String numero;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "fecha_validez")
    private LocalDate fechaValidez;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "subtotal", precision = 18, scale = 4)
    private BigDecimal subtotal;

    @Column(name = "igv", precision = 18, scale = 4)
    private BigDecimal igv;

    @Column(name = "total", precision = 18, scale = 4)
    private BigDecimal total;

    @OneToMany(mappedBy = "proforma", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProformaDet> detalles = new ArrayList<>();
}
