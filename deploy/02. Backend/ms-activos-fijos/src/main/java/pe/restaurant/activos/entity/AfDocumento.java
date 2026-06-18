package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDate;

@Entity
@Table(name = "af_documento", schema = "activos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfDocumento extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "tipo_documento", nullable = false, length = 50)
    private String tipoDocumento;

    @Column(name = "nombre_archivo", nullable = false, length = 255)
    private String nombreArchivo;

    @Column(name = "ruta_archivo", nullable = false, length = 500)
    private String rutaArchivo;

    @Column(name = "descripcion", length = 500)
    private String descripcion;

    @Column(name = "fecha_carga", nullable = false)
    private LocalDate fechaCarga;

    @Column(name = "tamanio_bytes")
    private Long tamanioBytes;

    @Column(name = "extension", length = 10)
    private String extension;

    @Column(name = "usuario_carga_id", nullable = false)
    private Long usuarioCargaId;
}
