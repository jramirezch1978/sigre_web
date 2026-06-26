package pe.restaurant.activos.entity;

import jakarta.persistence.*;
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
@Table(name = "af_aseguradora", schema = "activos")
public class AfAseguradora extends BaseEntity {

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(length = 20)
    private String ruc;

    @Column(length = 150)
    private String contacto;
}
