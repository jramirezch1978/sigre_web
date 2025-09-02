package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entidad para numeración secuencial de documentos/tickets
 * Tabla: num_doc_tipo
 */
@Entity
@Table(name = "num_doc_tipo")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NumDocTipo {
    
    @EmbeddedId
    private NumDocTipoId id; // PK compuesta: tipo_doc + cod_origen
    
    @Column(name = "ult_nro", nullable = false)
    @Builder.Default
    private Long ultNro = 0L; // Último número generado para este tipo+origen
    
    /**
     * Obtener y incrementar el siguiente número
     */
    public synchronized Long obtenerSiguienteNumero() {
        this.ultNro++;
        return this.ultNro;
    }
    
    /**
     * Formatear número como hexadecimal de 10 caracteres
     * Formato: [cod_origen][000000][número_hex]
     */
    public String formatearNumeroTicket(Long numero) {
        // Convertir a hexadecimal
        String numeroHex = Long.toHexString(numero).toUpperCase();
        
        // Calcular padding necesario (10 - cod_origen.length())
        int longitudDisponible = 10 - id.getCodOrigen().length();
        String padding = "0".repeat(Math.max(0, longitudDisponible - numeroHex.length()));
        
        return id.getCodOrigen() + padding + numeroHex;
    }
    
    /**
     * Generar siguiente número de ticket formateado
     */
    public synchronized String generarSiguienteTicket() {
        Long siguiente = obtenerSiguienteNumero();
        return formatearNumeroTicket(siguiente);
    }
}
