package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "raciones_seleccionadas", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"cod_trabajador", "fecha", "tipo_racion"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "idRacionComedor")
@ToString(exclude = "trabajador")
public class RacionesSeleccionadas {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_racion_comedor")
    private Long idRacionComedor;
    
    @Column(name = "cod_trabajador", length = 8, nullable = false)
    private String codTrabajador;
    
    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;
    
    @Column(name = "tipo_racion", length = 1, nullable = false)
    private String tipoRacion; // D = Desayuno, A = Almuerzo, C = Cena
    
    @Column(name = "fecha_registro", nullable = false)
    private LocalDateTime fechaRegistro;
    
    @Column(name = "cod_usuario", length = 6)
    private String codUsuario;
    
    @Column(name = "direccion_ip", length = 20)
    private String direccionIp;
    
    @Column(name = "observaciones", length = 500)
    private String observaciones;
    
    @Column(name = "id_asistencia_referencia", length = 12)
    private String idAsistenciaReferencia; // RECKEY de asistencia_ht580 relacionada
    
    @Column(name = "flag_estado", length = 1, nullable = false)
    @Builder.Default
    private String flagEstado = "1"; // 1=Activo, 0=Inactivo
    
    // ===== RELACIONES JPA =====
    
    /**
     * Relación con el trabajador (FK hacia Maestro)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cod_trabajador", referencedColumnName = "COD_TRABAJADOR", insertable = false, updatable = false)
    private Maestro trabajador;
    
    /**
     * Relación con el registro de asistencia que generó esta ración (FK hacia AsistenciaHt580)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_asistencia_referencia", referencedColumnName = "RECKEY", insertable = false, updatable = false)
    private AsistenciaHt580 asistenciaReferencia;
    
    // Método helper para verificar si está activa
    public boolean isActiva() {
        return "1".equals(flagEstado);
    }
    
    // Enums para tipos de ración (códigos de 1 carácter)
    public enum TipoRacion {
        DESAYUNO("D"),
        ALMUERZO("A"),
        CENA("C");
        
        private final String codigo;
        
        TipoRacion(String codigo) {
            this.codigo = codigo;
        }
        
        public String getCodigo() {
            return codigo;
        }
        
        public static TipoRacion fromCodigo(String codigo) {
            for (TipoRacion tipo : TipoRacion.values()) {
                if (tipo.codigo.equalsIgnoreCase(codigo)) {
                    return tipo;
                }
            }
            throw new IllegalArgumentException("Código de ración no válido: " + codigo);
        }
    }
}