package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "tipo_doc_identidad", schema = "core")
public class TipoDocIdentidadRef {

    @Id
    private Long id;

    @Column(length = 10)
    private String codigo;

    @Column(length = 120)
    private String nombre;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
