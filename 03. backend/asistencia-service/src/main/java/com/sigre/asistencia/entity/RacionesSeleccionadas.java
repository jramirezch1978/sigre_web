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
    
    @Column(name = "tipo_racion", length = 20, nullable = false)
    private String tipoRacion; // DESAYUNO, ALMUERZO, CENA
    
    @Column(name = "fecha_registro", nullable = false)
    private LocalDateTime fechaRegistro;
    
    @Column(name = "cod_usuario", length = 6)
    private String codUsuario;
    
    @Column(name = "direccion_ip", length = 20)
    private String direccionIp;
    
    @Column(name = "observaciones", length = 500)
    private String observaciones;
    
    @Column(name = "flag_estado", length = 1, nullable = false)
    @Builder.Default
    private String flagEstado = "1"; // 1=Activo, 0=Inactivo
    
    // Relación con Maestro
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cod_trabajador", referencedColumnName = "COD_TRABAJADOR", insertable = false, updatable = false)
    private Maestro trabajador;
    
    // Método helper para verificar si está activa
    public boolean isActiva() {
        return "1".equals(flagEstado);
    }
    
    // Enums para tipos de ración
    public enum TipoRacion {
        DESAYUNO("DESAYUNO"),
        ALMUERZO("ALMUERZO"),
        CENA("CENA");
        
        private final String valor;
        
        TipoRacion(String valor) {
            this.valor = valor;
        }
        
        public String getValor() {
            return valor;
        }
        
        public static TipoRacion fromString(String valor) {
            for (TipoRacion tipo : TipoRacion.values()) {
                if (tipo.valor.equalsIgnoreCase(valor)) {
                    return tipo;
                }
            }
            throw new IllegalArgumentException("Tipo de ración no válido: " + valor);
        }
    }
}