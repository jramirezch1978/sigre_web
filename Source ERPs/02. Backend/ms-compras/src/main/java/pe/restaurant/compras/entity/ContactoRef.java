package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "contacto", schema = "core")
public class ContactoRef {

    @Id
    private Long id;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(length = 150)
    private String nombre;

    @Column(length = 120)
    private String cargo;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
