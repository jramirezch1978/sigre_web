package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "almacen_tacito", schema = "almacen")
public class AlmacenTacitoRef {

    @Id
    private Long id;

    @Column(name = "cod_clase", length = 20)
    private String codClase;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "almacen_id")
    private Long almacenId;
}
