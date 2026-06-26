package pe.restaurant.core.entity;

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
@Table(name = "tipo_doc_identidad", schema = "core")
public class TipoDocIdentidad extends BaseEntity {

    @Column(nullable = false, unique = true, length = 10)
    private String codigo;

    @Column(nullable = false, length = 120)
    private String nombre;

    @Column(name = "tipo_doc", length = 10)
    private String tipoDoc;

    @Column(name = "tipo_doc_afpnet", nullable = false, length = 10)
    private String tipoDocAfpnet = "0";

    @Column(name = "flag_doc_bbva", length = 1)
    private String flagDocBbva;
}
