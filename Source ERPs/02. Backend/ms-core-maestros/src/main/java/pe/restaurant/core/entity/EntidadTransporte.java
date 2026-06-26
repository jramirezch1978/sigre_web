package pe.restaurant.core.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "entidad_transporte", schema = "core")
public class EntidadTransporte extends BaseEntity {

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "placa", length = 20)
    private String placa;

    @Column(name = "licencia", length = 30)
    private String licencia;

    @Column(name = "mtc", length = 30)
    private String mtc;

    @Column(name = "chofer", length = 150)
    private String chofer;
}
