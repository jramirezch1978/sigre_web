package pe.restaurant.core.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
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
@Table(name = "entidad_contribuyente_telefono", schema = "core")
public class EntidadContribuyenteTelefono extends BaseEntity {

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "item", nullable = false)
    private Short item;

    @Column(name = "descripcion", length = 60)
    private String descripcion;

    @Column(name = "codigo_pais", length = 5)
    private String codigoPais;

    @Column(name = "codigo_ciudad", length = 5)
    private String codigoCiudad;

    @Column(name = "numero", length = 20)
    private String numero;

    @Column(name = "flag_fax", length = 1)
    private String flagFax = "0";
}
