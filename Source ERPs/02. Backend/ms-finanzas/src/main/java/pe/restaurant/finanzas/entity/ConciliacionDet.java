package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "conciliacion_det", schema = "finanzas")
@EntityListeners(AuditingEntityListener.class)
public class ConciliacionDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conciliacion_id", nullable = false)
    private ConciliacionBancaria conciliacion;

    @Column(name = "caja_bancos_id")
    private Long cajaBancosId;

    @Column(nullable = false)
    private Boolean conciliado = false;

    @Column(columnDefinition = "TEXT")
    private String observacion;
}
