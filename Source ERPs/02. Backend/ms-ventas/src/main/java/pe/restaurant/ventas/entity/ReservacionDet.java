package pe.restaurant.ventas.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "reservacion_det", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = "reservacion")
public class ReservacionDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "reservacion_id", nullable = false)
    private Reservacion reservacion;

    @Column(name = "articulo_id")
    private Long articuloId;

    @Column(name = "cantidad", precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "observacion", columnDefinition = "TEXT")
    private String observacion;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
