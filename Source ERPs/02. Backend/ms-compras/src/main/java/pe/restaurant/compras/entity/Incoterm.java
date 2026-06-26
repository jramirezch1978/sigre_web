package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "incoterm", schema = "compras")
public class Incoterm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "codigo", length = 3, nullable = false, unique = true)
    private String codigo;

    @Column(name = "descripcion", length = 60)
    private String descripcion;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado = "1";
}
