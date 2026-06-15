package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_doc_tecnica", schema = "produccion")
public class ArticuloDocTecnica extends BaseEntity {

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "nombre_documento", nullable = false, length = 200)
    private String nombreDocumento;

    @Column(name = "documento_extension", length = 10)
    private String documentoExtension;

    @Column(name = "archivo_url", length = 3000)
    private String archivoUrl;

    @Column(name = "documento_blob")
    private byte[] documentoBlob;

    @Column(name = "observacion", length = 3000)
    private String observacion;
}
