package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "af_operaciones", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfOperaciones extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "tipo", length = 20, nullable = false)
    private String tipo;

    @Column(name = "fecha_programada")
    private LocalDate fechaProgramada;

    @Column(name = "fecha_ejecucion")
    private LocalDate fechaEjecucion;

    @Column(name = "costo", precision = 18, scale = 4)
    private BigDecimal costo;

    @Column(name = "proveedor_servicio", length = 200)
    private String proveedorServicio;

}
