package com.sigre.rrhh.testdata;

import org.springframework.jdbc.core.JdbcTemplate;
import javax.sql.DataSource;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * TestDataSeeder específico para ms-rrhh.
 * Las áreas no se insertan aquí - se crean dinámicamente en los tests de integración.
 * Esto permite probar el flujo completo de CRUD sin datos preexistentes.
 *
 * Uso en tests:
 * <pre>
 *   &#64;Autowired DataSource dataSource;
 *   &#64;BeforeEach void setup() {
 *       // Maestros comunes
 *       new TestDataSeeder(dataSource).seedAll();
 *       // Datos específicos de RRHH (solo maestros si aplica)
 *       new TestDataSeederRrhh(dataSource).ensureRrhhTransactionalData();
 *   }
 * </pre>
 */
public class TestDataSeederRrhh {

    private final JdbcTemplate jdbc;

    public TestDataSeederRrhh(DataSource dataSource) {
        this.jdbc = new JdbcTemplate(dataSource);
    }

    public TestDataSeederRrhh(JdbcTemplate jdbcTemplate) {
        this.jdbc = jdbcTemplate;
    }

    /**
     * Asegura que todos los datos transaccionales de RRHH existan.
     * Las áreas y cargos se crean dinámicamente en los tests de integración.
     * Las AFP y tipos de novedad se insertan aquí como datos base para pruebas.
     *
     * @return Mapa con tabla -> cantidad de registros afectados (insertados + actualizados)
     */
    public Map<String, Integer> ensureRrhhTransactionalData() {
        Map<String, Integer> counts = new LinkedHashMap<>();

        // Insertar datos base de AFP para pruebas
        counts.put("rrhh.admin_afp", ensureAdminAfp());
        
        // Insertar datos base de tipos de novedad para pruebas
        counts.put("rrhh.tipo_novedad_rrhh", ensureTipoNovedadRrhh());
        
        return counts;
    }
    
    /**
     * Asegura que existan AFP de prueba para los tests de integración.
     * Valida por nombre individual y actualiza si existe, inserta si no.
     */
    private Integer ensureAdminAfp() {
        int inserted = 0;
        int updated = 0;
        
        String[][] afps = {
            {"AFP Integra", "1.5500", "1.3600", "10.0000"},
            {"AFP Prima", "1.6000", "1.3600", "10.0000"}
        };
        
        for (String[] afp : afps) {
            String nombre = afp[0];
            String comision = afp[1];
            String prima = afp[2];
            String aporte = afp[3];
            
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM rrhh.admin_afp WHERE TRIM(UPPER(nombre)) = TRIM(UPPER(?))",
                Integer.class, nombre);
            
            if (count == null || count == 0) {
                // No existe, insertar
                jdbc.update("""
                    INSERT INTO rrhh.admin_afp (nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, created_by, fec_creacion)
                    VALUES (?, ?, ?, ?, 1, NOW())
                    """, nombre, comision, prima, aporte);
                inserted++;
            } else {
                // Ya existe, actualizar
                jdbc.update("""
                    UPDATE rrhh.admin_afp SET
                        comision_porcentaje = ?,
                        prima_seguro = ?,
                        aporte_obligatorio = ?,
                        flag_estado = '1'
                    WHERE TRIM(UPPER(nombre)) = TRIM(UPPER(?))
                    """, comision, prima, aporte, nombre);
                updated++;
            }
        }
        
        return inserted + updated;
    }

    /**
     * Asegura que existan tipos de novedad de prueba para los tests de integración.
     * Inserta los tipos estándar: PER (Permiso), FAL (Falta), AMO (Amonestación), SUS (Suspensión).
     */
    private Integer ensureTipoNovedadRrhh() {
        int inserted = 0;

        String[][] tipos = {
            {"PER", "Permiso"},
            {"FAL", "Falta Injustificada"},
            {"AMO", "Amonestaci\u00f3n"},
            {"SUS", "Suspensi\u00f3n"}
        };

        for (String[] tipo : tipos) {
            String codigo = tipo[0];
            String nombre = tipo[1];

            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM rrhh.tipo_novedad_rrhh WHERE codigo = ?",
                Integer.class, codigo);

            if (count == null || count == 0) {
                jdbc.update(
                    "INSERT INTO rrhh.tipo_novedad_rrhh (codigo, nombre, created_by, fec_creacion) VALUES (?, ?, 1, NOW())",
                    codigo, nombre);
                inserted++;
            }
        }

        return inserted;
    }
}
