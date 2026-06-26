package pe.restaurant.almacen.entity;

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

    @Column(name = "codigo", length = 20)
    private String codigo;

    @Column(name = "abreviatura", length = 20)
    private String abreviatura;

    public String getLabel() {
        return abreviatura != null && !abreviatura.isBlank() ? abreviatura : codigo;
    }
}
