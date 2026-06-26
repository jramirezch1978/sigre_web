package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "unidad_medida", schema = "core")
public class UnidadMedidaRef {

    @Id
    private Long id;

    @Column(length = 100)
    private String nombre;

    @Column(length = 20)
    private String abreviatura;

    public String getLabel() {
        if (abreviatura != null && !abreviatura.isBlank()) return abreviatura;
        return nombre != null ? nombre : "";
    }
}
