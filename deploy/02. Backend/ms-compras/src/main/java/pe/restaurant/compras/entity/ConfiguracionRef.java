package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@Entity
@Table(name = "configuracion", schema = "core")
public class ConfiguracionRef {

    @Id
    private Long id;

    @Column(name = "parameter", length = 120)
    private String parametro;

    @Column(name = "value_text", columnDefinition = "TEXT")
    private String valorTexto;
}
