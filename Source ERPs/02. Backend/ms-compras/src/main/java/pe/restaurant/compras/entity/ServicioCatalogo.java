package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "servicio", schema = "compras")
public class ServicioCatalogo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 6)
    private String servicio;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado = "1";

    @Column(name = "articulo_sub_categ_id")
    private Long articuloSubCategId;

    @Column(length = 200)
    private String descripcion;

    @Column(name = "tarifa_estd", precision = 18, scale = 4)
    private BigDecimal tarifaEstd;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;
}
