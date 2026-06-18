package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "sucursal", schema = "auth")
public class SucursalRef {

    @Id
    private Long id;

    @Column(name = "codigo", length = 2)
    private String codigo;

    @Column(name = "nombre", length = 150)
    private String nombre;
}
