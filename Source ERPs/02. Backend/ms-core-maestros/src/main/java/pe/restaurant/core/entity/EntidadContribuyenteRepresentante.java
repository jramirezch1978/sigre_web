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
@Table(name = "entidad_contribuyente_representante", schema = "core")
public class EntidadContribuyenteRepresentante extends BaseEntity {

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "item", nullable = false)
    private Short item;

    @Column(name = "nombre", length = 150)
    private String nombre;

    @Column(name = "cargo", length = 120)
    private String cargo;

    @Column(name = "telefono", length = 20)
    private String telefono;

    @Column(name = "email", length = 200)
    private String email;
}
