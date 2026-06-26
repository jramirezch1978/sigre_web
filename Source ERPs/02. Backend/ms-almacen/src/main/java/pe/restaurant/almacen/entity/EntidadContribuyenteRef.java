package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "entidad_contribuyente", schema = "core")
public class EntidadContribuyenteRef {

    @Id
    private Long id;

    @Column(name = "nro_documento", length = 30)
    private String nroDocumento;

    @Column(name = "razon_social", length = 200)
    private String razonSocial;

    @Column(name = "nombres", length = 120)
    private String nombres;

    @Column(name = "apellidos", length = 120)
    private String apellidos;

    public String getNombreCompleto() {
        if (razonSocial != null && !razonSocial.isBlank()) return razonSocial;
        String n = nombres != null ? nombres : "";
        String a = apellidos != null ? apellidos : "";
        return (n + " " + a).trim();
    }
}
