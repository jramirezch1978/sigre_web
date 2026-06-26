package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "articulo", schema = "core")
public class ArticuloRef {

    @Id
    private Long id;

    @Column(length = 30)
    private String codigo;

    @Column(length = 220)
    private String nombre;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;

    @Column(name = "articulo_categ_id")
    private Long articuloCategId;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
