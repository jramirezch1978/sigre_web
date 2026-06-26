package pe.restaurant.rrhh.testdata;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * TestDataFactory del microservicio RRHH (Rol B).
 * Se encarga de crear datos de prueba específicos del dominio para integration tests.
 * Implementa el patrón B según el estándar generacion-test.md.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RrhhTestDataFactory {
    
    private final JdbcTemplate jdbc;
    
    /**
     * Crea datos de prueba básicos para el módulo de áreas.
     * Crea una estructura jerárquica simple para probar validaciones.
     */
    public void ensureAreaTestData() {
        log.info("Creando datos de prueba para áreas...");
        
        // Áreas raíz
        Long area1Id = ensureArea("Gerencia General", null, null);
        Long area2Id = ensureArea("Gerencia de Operaciones", null, null);
        Long area3Id = ensureArea("Gerencia de Finanzas", null, null);
        
        // Sub-áreas
        ensureArea("Administración", area1Id, null);
        ensureArea("RRHH", area1Id, null);
        ensureArea("Producción", area2Id, null);
        ensureArea("Logística", area2Id, null);
        ensureArea("Contabilidad", area3Id, null);
        ensureArea("Tesorería", area3Id, null);
        
        // Sub-sub-áreas
        Long rrhhId = findAreaByName("RRHH");
        if (rrhhId != null) {
            ensureArea("Reclutamiento", rrhhId, null);
            ensureArea("Capacitación", rrhhId, null);
        }
        
        log.info("Datos de prueba para áreas creados exitosamente");
    }
    
    /**
     * Asegura que un área exista, si no existe la crea.
     * 
     * @param nombre Nombre del área
     * @param padreId ID del área padre
     * @param responsableId ID del responsable
     * @return ID del área (existente o creado)
     */
    private Long ensureArea(String nombre, Long padreId, Long responsableId) {
        // Primero verificar si ya existe
        Long existingId = findAreaByName(nombre);
        if (existingId != null) {
            log.debug("Área '{}' ya existe con ID: {}", nombre, existingId);
            return existingId;
        }
        
        // Crear nueva área
        String sql = """
            INSERT INTO rrhh.area (nombre, padre_id, responsable_id, created_by, fec_creacion)
            VALUES (?, ?, ?, 1, NOW())
            RETURNING id
            """;
        
        try {
            Long newId = jdbc.queryForObject(sql, Long.class, nombre, padreId, responsableId);
            log.info("Área '{}' creada con ID: {}", nombre, newId);
            return newId;
        } catch (Exception e) {
            log.error("Error al crear área '{}': {}", nombre, e.getMessage());
            return null;
        }
    }
    
    /**
     * Busca un área por nombre y retorna su ID.
     * 
     * @param nombre Nombre del área a buscar
     * @return ID del área o null si no existe
     */
    private Long findAreaByName(String nombre) {
        String sql = "SELECT id FROM rrhh.area WHERE nombre = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, nombre);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Crea un área específica para pruebas de validación.
     * Útil para tests que necesitan un área específica.
     * 
     * @param nombre Nombre del área
     * @param padreId ID del área padre
     * @return ID del área creada
     */
    public Long createTestArea(String nombre, Long padreId) {
        return ensureArea(nombre, padreId, 1L);
    }
    
    /**
     * Crea una estructura de áreas para pruebas de ciclos.
     * Crea: A → B → C para probar validación de ciclos.
     */
    public void createCycleTestData() {
        log.info("Creando datos de prueba para validación de ciclos...");
        
        Long areaA = ensureArea("Área A", null, null);
        Long areaB = ensureArea("Área B", areaA, null);
        Long areaC = ensureArea("Área C", areaB, null);
        
        log.info("Estructura de ciclos creada: A({}) → B({}) → C({})", areaA, areaB, areaC);
    }
    
    /**
     * Crea un área con hijos para pruebas de eliminación.
     * 
     * @param nombrePadre Nombre del área padre
     * @param nombreHijo Nombre del área hija
     */
    public void createParentChildTestData(String nombrePadre, String nombreHijo) {
        Long padreId = ensureArea(nombrePadre, null, null);
        ensureArea(nombreHijo, padreId, null);
        
        log.info("Estructura padre-hijo creada: {}({}) → {}()", nombrePadre, padreId, nombreHijo);
    }
    
    /**
     * Retorna el ID de un área por nombre (para uso en tests).
     * 
     * @param nombre Nombre del área
     * @return ID del área o null
     */
    public Long getAreaIdByName(String nombre) {
        return findAreaByName(nombre);
    }
    
    /**
     * Cuenta cuántos hijos tiene un área.
     * 
     * @param areaId ID del área padre
     * @return Cantidad de hijos
     */
    public long countAreaChildren(Long areaId) {
        String sql = "SELECT COUNT(*) FROM rrhh.area WHERE padre_id = ?";
        Long result = jdbc.queryForObject(sql, Long.class, areaId);
        return result != null ? result : 0L;
    }
    
    /**
     * Verifica si existe un área con nombre duplicado en el mismo nivel.
     * 
     * @param nombre Nombre a verificar
     * @param padreId ID del área padre
     * @return true si existe duplicado
     */
    public boolean existsAreaByNameAndPadre(String nombre, Long padreId) {
        String sql = "SELECT COUNT(*) FROM rrhh.area WHERE nombre = ? AND (padre_id = ? OR (padre_id IS NULL AND ? IS NULL))";
        Long count = jdbc.queryForObject(sql, Long.class, nombre, padreId, padreId);
        return count != null && count > 0;
    }
    
    // ══════════════════════════════════════════════════════════════
    // CARGO - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════
    
    /**
     * Crea datos de prueba básicos para el módulo de cargos.
     * Crea cargos de diferentes niveles jerárquicos.
     */
    public void ensureCargoTestData() {
        log.info("Creando datos de prueba para cargos...");
        
        // Cargos operativos
        ensureCargo("Ayudante de Cocina", "OPERATIVO", "1500.0000", "2500.0000");
        ensureCargo("Cocinero", "OPERATIVO", "2000.0000", "3000.0000");
        ensureCargo("Mesero", "OPERATIVO", "1200.0000", "2000.0000");
        
        // Cargos tácticos
        ensureCargo("Sous Chef", "TÁCTICO", "2500.0000", "4000.0000");
        ensureCargo("Jefe de Sala", "TÁCTICO", "2200.0000", "3500.0000");
        ensureCargo("Supervisor de Almacén", "TÁCTICO", "2000.0000", "3200.0000");
        
        // Cargos estratégicos
        ensureCargo("Chef Ejecutivo", "ESTRATÉGICO", "4000.0000", "7000.0000");
        ensureCargo("Gerente de Operaciones", "ESTRATÉGICO", "5000.0000", "8000.0000");
        ensureCargo("Gerente General", "ESTRATÉGICO", "6000.0000", "10000.0000");
        
        log.info("Datos de prueba para cargos creados exitosamente");
    }
    
    /**
     * Asegura que un cargo exista, si no existe lo crea.
     * 
     * @param nombre Nombre del cargo
     * @param nivel Nivel del cargo
     * @param sueldoMinimo Sueldo mínimo
     * @param sueldoMaximo Sueldo máximo
     * @return ID del cargo (existente o creado)
     */
    private Long ensureCargo(String nombre, String nivel, String sueldoMinimo, String sueldoMaximo) {
        Long existingId = findCargoByName(nombre);
        if (existingId != null) {
            log.debug("Cargo '{}' ya existe con ID: {}", nombre, existingId);
            return existingId;
        }
        
        String sql = """
            INSERT INTO rrhh.cargo (nombre, nivel, sueldo_minimo, sueldo_maximo, created_by, fec_creacion)
            VALUES (?, ?, ?::numeric, ?::numeric, 1, NOW())
            RETURNING id
            """;
        
        try {
            Long newId = jdbc.queryForObject(sql, Long.class, nombre, nivel, sueldoMinimo, sueldoMaximo);
            log.info("Cargo '{}' creado con ID: {}", nombre, newId);
            return newId;
        } catch (Exception e) {
            log.error("Error al crear cargo '{}': {}", nombre, e.getMessage());
            return null;
        }
    }
    
    /**
     * Busca un cargo por nombre y retorna su ID.
     * 
     * @param nombre Nombre del cargo a buscar
     * @return ID del cargo o null si no existe
     */
    private Long findCargoByName(String nombre) {
        String sql = "SELECT id FROM rrhh.cargo WHERE nombre = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, nombre);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Crea un cargo específico para pruebas.
     * 
     * @param nombre Nombre del cargo
     * @param nivel Nivel del cargo
     * @param sueldoMinimo Sueldo mínimo
     * @param sueldoMaximo Sueldo máximo
     * @return ID del cargo creado
     */
    public Long createTestCargo(String nombre, String nivel, String sueldoMinimo, String sueldoMaximo) {
        return ensureCargo(nombre, nivel, sueldoMinimo, sueldoMaximo);
    }
    
    /**
     * Retorna el ID de un cargo por nombre (para uso en tests).
     * 
     * @param nombre Nombre del cargo
     * @return ID del cargo o null
     */
    public Long getCargoIdByName(String nombre) {
        return findCargoByName(nombre);
    }
    
    /**
     * Cuenta cuántos trabajadores tienen asignado un cargo.
     * 
     * @param cargoId ID del cargo
     * @return Cantidad de trabajadores
     */
    public long countTrabajadoresByCargo(Long cargoId) {
        String sql = "SELECT COUNT(*) FROM rrhh.trabajador WHERE cargo_id = ?";
        Long result = jdbc.queryForObject(sql, Long.class, cargoId);
        return result != null ? result : 0L;
    }
    
    /**
     * Verifica si existe un cargo con el nombre dado.
     * 
     * @param nombre Nombre a verificar
     * @return true si existe
     */
    public boolean existsCargoByName(String nombre) {
        String sql = "SELECT COUNT(*) FROM rrhh.cargo WHERE nombre = ?";
        Long count = jdbc.queryForObject(sql, Long.class, nombre);
        return count != null && count > 0;
    }
    
    // ══════════════════════════════════════════════════════════════
    // ADMIN AFP - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════
    
    /**
     * Asegura que existan datos de prueba de AFP.
     * Crea AFP de prueba con diferentes porcentajes.
     */
    public void ensureAdminAfpTestData() {
        log.info("Creando datos de prueba para AFP...");
        
        ensureAdminAfp("AFP Integra", "1.5500", "1.3600", "10.0000");
        ensureAdminAfp("AFP Prima", "1.6000", "1.3600", "10.0000");
        ensureAdminAfp("AFP Habitat", "1.3500", "1.3600", "10.0000");
        ensureAdminAfp("AFP Profuturo", "1.4500", "1.3600", "10.0000");
        
        log.info("Datos de prueba para AFP creados exitosamente");
    }
    
    /**
     * Asegura que una AFP exista, si no existe la crea.
     * 
     * @param nombre Nombre de la AFP
     * @param comisionPorcentaje Porcentaje de comisión
     * @param primaSeguro Porcentaje de prima de seguro
     * @param aporteObligatorio Porcentaje de aporte obligatorio
     * @return ID de la AFP (existente o creada)
     */
    private Long ensureAdminAfp(String nombre, String comisionPorcentaje, String primaSeguro, String aporteObligatorio) {
        Long existingId = findAdminAfpByName(nombre);
        if (existingId != null) {
            log.debug("AFP '{}' ya existe con ID: {}", nombre, existingId);
            return existingId;
        }
        
        String sql = """
            INSERT INTO rrhh.admin_afp (nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, created_by, fec_creacion)
            VALUES (?, CAST(? AS numeric), CAST(? AS numeric), CAST(? AS numeric), 1, NOW())
            RETURNING id
            """;
        
        try {
            Long newId = jdbc.queryForObject(sql, Long.class, nombre, comisionPorcentaje, primaSeguro, aporteObligatorio);
            log.info("AFP '{}' creada con ID: {}", nombre, newId);
            return newId;
        } catch (Exception e) {
            log.error("Error al crear AFP '{}': {}", nombre, e.getMessage());
            return null;
        }
    }
    
    /**
     * Busca una AFP por nombre y retorna su ID.
     * 
     * @param nombre Nombre de la AFP a buscar
     * @return ID de la AFP o null si no existe
     */
    private Long findAdminAfpByName(String nombre) {
        String sql = "SELECT id FROM rrhh.admin_afp WHERE nombre = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, nombre);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Crea una AFP específica para pruebas.
     * 
     * @param nombre Nombre de la AFP
     * @param comisionPorcentaje Porcentaje de comisión
     * @param primaSeguro Porcentaje de prima de seguro
     * @param aporteObligatorio Porcentaje de aporte obligatorio
     * @return ID de la AFP creada
     */
    public Long createTestAdminAfp(String nombre, String comisionPorcentaje, String primaSeguro, String aporteObligatorio) {
        return ensureAdminAfp(nombre, comisionPorcentaje, primaSeguro, aporteObligatorio);
    }
    
    /**
     * Retorna el ID de una AFP por nombre (para uso en tests).
     * 
     * @param nombre Nombre de la AFP
     * @return ID de la AFP o null
     */
    public Long getAdminAfpIdByName(String nombre) {
        return findAdminAfpByName(nombre);
    }
    
    /**
     * Cuenta cuántos trabajadores tienen asignada una AFP.
     * 
     * @param afpId ID de la AFP
     * @return Cantidad de trabajadores
     */
    public long countTrabajadoresByAdminAfp(Long afpId) {
        String sql = "SELECT COUNT(*) FROM rrhh.trabajador WHERE admin_afp_id = ? AND flag_estado = '1'";
        Long result = jdbc.queryForObject(sql, Long.class, afpId);
        return result != null ? result : 0L;
    }
    
    /**
     * Verifica si existe una AFP con el nombre dado.
     * 
     * @param nombre Nombre a verificar
     * @return true si existe
     */
    public boolean existsAdminAfpByName(String nombre) {
        String sql = "SELECT COUNT(*) FROM rrhh.admin_afp WHERE nombre = ?";
        Long count = jdbc.queryForObject(sql, Long.class, nombre);
        return count != null && count > 0;
    }
    
    /**
     * Obtiene el ID de la AFP de prueba estándar.
     * 
     * @return ID de AFP Integra (para pruebas estándar)
     */
    public Long resolveAdminAfpId() {
        return getAdminAfpIdByName("AFP Integra");
    }
    
    // ══════════════════════════════════════════════════════════════
    // TIPO NOVEDAD RRHH - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensureTipoNovedadRrhhTestData() {
        log.info("Creando datos de prueba para tipos de novedad...");

        ensureTipoNovedadRrhh("PER", "Permiso");
        ensureTipoNovedadRrhh("FAL", "Falta Injustificada");
        ensureTipoNovedadRrhh("AMO", "Amonestaci\u00f3n");
        ensureTipoNovedadRrhh("SUS", "Suspensi\u00f3n");

        log.info("Datos de prueba para tipos de novedad creados exitosamente");
    }

    private Long ensureTipoNovedadRrhh(String codigo, String nombre) {
        Long existingId = findTipoNovedadRrhhByCodigo(codigo);
        if (existingId != null) {
            log.debug("Tipo de novedad '{}' ya existe con ID: {}", codigo, existingId);
            return existingId;
        }

        String sql = """
            INSERT INTO rrhh.tipo_novedad_rrhh (codigo, nombre, created_by, fec_creacion)
            VALUES (?, ?, 1, NOW())
            RETURNING id
            """;

        try {
            Long newId = jdbc.queryForObject(sql, Long.class, codigo, nombre);
            log.info("Tipo de novedad '{}' creado con ID: {}", codigo, newId);
            return newId;
        } catch (Exception e) {
            log.error("Error al crear tipo de novedad '{}': {}", codigo, e.getMessage());
            return null;
        }
    }

    private Long findTipoNovedadRrhhByCodigo(String codigo) {
        String sql = "SELECT id FROM rrhh.tipo_novedad_rrhh WHERE codigo = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, codigo);
        } catch (Exception e) {
            return null;
        }
    }

    public Long createTestTipoNovedadRrhh(String codigo, String nombre) {
        return ensureTipoNovedadRrhh(codigo, nombre);
    }

    public Long getTipoNovedadRrhhIdByCodigo(String codigo) {
        return findTipoNovedadRrhhByCodigo(codigo);
    }

    public boolean existsTipoNovedadRrhhByCodigo(String codigo) {
        String sql = "SELECT COUNT(*) FROM rrhh.tipo_novedad_rrhh WHERE codigo = ?";
        Long count = jdbc.queryForObject(sql, Long.class, codigo);
        return count != null && count > 0;
    }

    public Long resolveTipoNovedadRrhhId() {
        return getTipoNovedadRrhhIdByCodigo("PER");
    }

    // ══════════════════════════════════════════════════════════════
    // CONCEPTO PLANILLA - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════
    
    /**
     * Asegura que existan datos de prueba de conceptos de planilla.
     * Crea conceptos de tipo INGRESO, DESCUENTO y APORTE.
     */
    public void ensureConceptoPlanillaTestData() {
        log.info("Creando datos de prueba para conceptos de planilla...");
        ensureGrupoConceptosPlanillaTestData();
        
        // Ingresos
        ensureConceptoPlanilla("ING-TEST-001", "Sueldo Básico Test", "INGRESO", null, "1500.0000", true, true, true);
        ensureConceptoPlanilla("ING-TEST-002", "Bonificación Test", "INGRESO", null, "500.0000", true, true, false);
        ensureConceptoPlanilla("ING-TEST-003", "Asignación Familiar Test", "INGRESO", null, "102.5000", true, true, false);
        
        // Descuentos
        ensureConceptoPlanilla("DESC-TEST-001", "AFP Test", "DESCUENTO", "SUELDO_BASICO * 0.13", null, false, false, true);
        ensureConceptoPlanilla("DESC-TEST-002", "ONP Test", "DESCUENTO", "SUELDO_BASICO * 0.13", null, false, false, false);
        ensureConceptoPlanilla("DESC-TEST-003", "Quinta Categoría Test", "DESCUENTO", null, null, false, false, true);
        
        // Aportes
        ensureConceptoPlanilla("APO-TEST-001", "EsSalud Test", "APORTE", "SUELDO_BASICO * 0.09", null, false, false, true);
        ensureConceptoPlanilla("APO-TEST-002", "SCTR Test", "APORTE", null, "50.0000", false, false, true);
        
        log.info("Datos de prueba para conceptos de planilla creados exitosamente");
    }

    /**
     * Asegura catálogos mínimos de grupo de cálculo SIGRE para pruebas.
     */
    public void ensureGrupoConceptosPlanillaTestData() {
        ensureGrupoConceptosPlanilla("10", "GANANCIAS FIJAS");
        ensureGrupoConceptosPlanilla("14", "GANANCIAS VARIABLES");
        ensureGrupoConceptosPlanilla("20", "DESCUENTOS DE LEY");
        ensureGrupoConceptosPlanilla("30", "APORTACIONES DE LA EMPRESA");
    }

    private void ensureGrupoConceptosPlanilla(String codigo, String nombre) {
        String sql = """
            INSERT INTO rrhh.grupo_conceptos_planilla
            (codigo, nombre, flag_replicacion, flag_estado, created_by, fec_creacion)
            VALUES (?, ?, '1', '1', 1, NOW())
            ON CONFLICT (codigo) DO NOTHING
            """;
        jdbc.update(sql, codigo, nombre);
    }

    private Long findGrupoConceptosPlanillaIdByCodigo(String codigo) {
        String sql = "SELECT id FROM rrhh.grupo_conceptos_planilla WHERE codigo = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, codigo);
        } catch (Exception e) {
            return null;
        }
    }

    private String mapTipoToGrupoCalculo(String tipo) {
        return switch (tipo) {
            case "DESCUENTO" -> "20";
            case "APORTE" -> "30";
            case "INGRESO" -> "10";
            default -> "10";
        };
    }
    
    /**
     * Asegura que un concepto de planilla exista, si no existe lo crea.
     * 
     * @param codigo Código del concepto
     * @param nombre Nombre del concepto
     * @param tipo Tipo del concepto (INGRESO, DESCUENTO, APORTE)
     * @param formula Fórmula de cálculo (puede ser null)
     * @param valorFijo Valor fijo (puede ser null)
     * @param afectoQuinta Si afecta a quinta categoría
     * @param afectoEssalud Si afecta a EsSalud
     * @param aplicaTodos Si aplica a todos los trabajadores
     * @return ID del concepto (existente o creado)
     */
    private Long ensureConceptoPlanilla(String codigo, String nombre, String tipo, String formula, 
                                        String valorFijo, boolean afectoQuinta, boolean afectoEssalud, 
                                        boolean aplicaTodos) {
        Long existingId = findConceptoPlanillaByCodigo(codigo);
        if (existingId != null) {
            log.debug("Concepto de planilla '{}' ya existe con ID: {}", codigo, existingId);
            return existingId;
        }

        ensureGrupoConceptosPlanillaTestData();
        String grupoCodigo = mapTipoToGrupoCalculo(tipo);
        Long grupoId = findGrupoConceptosPlanillaIdByCodigo(grupoCodigo);
        if (grupoId == null) {
            log.error("Grupo de conceptos '{}' no encontrado para concepto '{}'", grupoCodigo, codigo);
            return null;
        }
        
        String sql = """
            INSERT INTO rrhh.concepto_planilla
            (codigo, nombre, descripcion_breve, factor_pago, importe_tope_min, importe_tope_max,
             grupo_conceptos_planilla_id, flag_replicacion, flag_subsidio, flag_reporte_quinta,
             flag_estado, created_by, fec_creacion)
            VALUES (?, ?, ?, ?, 0, 0, ?, '1', '0', ?, '1', 1, NOW())
            RETURNING id
            """;
        
        try {
            BigDecimal factor = valorFijo != null ? new BigDecimal(valorFijo) : BigDecimal.ONE;
            String flagQuinta = afectoQuinta ? "1" : "0";
            Long newId = jdbc.queryForObject(sql, Long.class, codigo, nombre, nombre, factor, grupoId, flagQuinta);
            log.info("Concepto de planilla '{}' creado con ID: {}", codigo, newId);
            return newId;
        } catch (Exception e) {
            log.error("Error al crear concepto de planilla '{}': {}", codigo, e.toString());
            if (e.getCause() != null) {
                log.error("Causa raíz: {}", e.getCause().toString());
            }
            return null;
        }
    }
    
    /**
     * Busca un concepto de planilla por código y retorna su ID.
     * 
     * @param codigo Código del concepto a buscar
     * @return ID del concepto o null si no existe
     */
    private Long findConceptoPlanillaByCodigo(String codigo) {
        String sql = "SELECT id FROM rrhh.concepto_planilla WHERE codigo = ? ORDER BY id LIMIT 1";
        try {
            return jdbc.queryForObject(sql, Long.class, codigo);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Crea un concepto de planilla específico para pruebas.
     * 
     * @param codigo Código del concepto
     * @param nombre Nombre del concepto
     * @param tipo Tipo del concepto
     * @return ID del concepto creado
     */
    public Long createTestConceptoPlanilla(String codigo, String nombre, String tipo) {
        return ensureConceptoPlanilla(codigo, nombre, tipo, null, null, true, true, true);
    }
    
    /**
     * Retorna el ID de un concepto de planilla por código (para uso en tests).
     * 
     * @param codigo Código del concepto
     * @return ID del concepto o null
     */
    public Long getConceptoPlanillaIdByCodigo(String codigo) {
        return findConceptoPlanillaByCodigo(codigo);
    }
    
    /**
     * Verifica si existe un concepto de planilla con el código dado.
     * 
     * @param codigo Código a verificar
     * @return true si existe
     */
    public boolean existsConceptoPlanillaByCodigo(String codigo) {
        String sql = "SELECT COUNT(*) FROM rrhh.concepto_planilla WHERE codigo = ?";
        Long count = jdbc.queryForObject(sql, Long.class, codigo);
        return count != null && count > 0;
    }
    
    /**
     * Obtiene el ID de un concepto de planilla de prueba estándar de tipo INGRESO.
     * 
     * @return ID del concepto ING-TEST-001
     */
    public Long resolveConceptoPlanillaIngresoId() {
        return getConceptoPlanillaIdByCodigo("ING-TEST-001");
    }
    
    /**
     * Obtiene el ID de un concepto de planilla de prueba estándar de tipo DESCUENTO.
     * 
     * @return ID del concepto DESC-TEST-001
     */
    public Long resolveConceptoPlanillaDescuentoId() {
        return getConceptoPlanillaIdByCodigo("DESC-TEST-001");
    }
    
    /**
     * Obtiene el ID de un concepto de planilla de prueba estándar de tipo APORTE.
     * 
     * @return ID del concepto APO-TEST-001
     */
    public Long resolveConceptoPlanillaAporteId() {
        return getConceptoPlanillaIdByCodigo("APO-TEST-001");
    }

    // ══════════════════════════════════════════════════════════════
    // GANANCIA/DESCUENTO FIJO - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    /**
     * Asegura que existan datos de prueba de ganancias/descuentos fijos.
     * Requiere que exista un concepto de planilla y un trabajador.
     */
    public void ensureGanDescFijoTestData() {
        log.info("Creando datos de prueba para ganancias/descuentos fijos...");

        Long trabajadorId = ensureTrabajadorTest();
        Long conceptoId = resolveConceptoPlanillaIngresoId();
        if (trabajadorId == null || conceptoId == null) return;

        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.gan_desct_fijo WHERE trabajador_id = ? AND concepto_id = ?",
            Integer.class, trabajadorId, conceptoId);
        if (count != null && count > 0) {
            log.debug("GanDescFijo test data ya existe");
            return;
        }

        jdbc.update("""
            INSERT INTO rrhh.gan_desct_fijo
            (trabajador_id, concepto_id, imp_gan_desc, flag_estado, created_by, fec_creacion)
            VALUES (?, ?, 500.0000, '1', 1, NOW())
            """, trabajadorId, conceptoId);

        log.info("Datos de prueba para ganancias/descuentos fijos creados exitosamente");
    }

    /**
     * Crea un trabajador de prueba si no existe.
     * @return ID del trabajador o null si falla
     */
    private Long ensureTrabajadorTest() {
        Long existing = findTrabajadorById(1001L);
        if (existing != null) return existing;

        try {
            jdbc.update("""
                INSERT INTO rrhh.trabajador
                (id, codigo_trabajador, nombres, apellido_paterno, apellido_materno,
                 numero_documento, flag_estado, created_by, fec_creacion)
                VALUES (1001, 'TRB-TEST-001', 'Juan', 'Pérez', 'García',
                        '12345678', '1', 1, NOW())
                """);
            return 1001L;
        } catch (Exception e) {
            log.error("Error al crear trabajador de prueba: {}", e.getMessage());
            return null;
        }
    }

    private Long findTrabajadorById(Long id) {
        try {
            return jdbc.queryForObject("SELECT id FROM rrhh.trabajador WHERE id = ?", Long.class, id);
        } catch (Exception e) {
            return null;
        }
    }

    // ══════════════════════════════════════════════════════════════
    // PERMISO LICENCIA / TIPO SUSPENSIÓN LABORAL - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensurePermisoLicenciaTestData() {
        log.info("Creando datos de prueba para permisos/licencias...");

        ensureTipoSuspensionLaboral("ENF", "Enfermedad", "2", null, "1");
        ensureTipoSuspensionLaboral("PER", "Permiso Personal", "1", null, "0");
        ensureTipoSuspensionLaboral("MAT", "Maternidad", "2", 1L, "1");

        Long trabajadorId = ensureTrabajadorTest();
        Long tipoSuspId = resolveTipoSuspensionLaboralId();
        if (trabajadorId == null || tipoSuspId == null) return;

        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.permiso_licencia WHERE trabajador_id = ?", Integer.class, trabajadorId);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO rrhh.permiso_licencia
            (trabajador_id, tipo_suspension_laboral_id, fecha_inicio, fecha_fin, dias, sustento, flag_estado, created_by, fec_creacion)
            VALUES (?, ?, '2026-01-15', '2026-01-17', 3, 'Permiso por enfermedad', '1', 1, NOW())
            """, trabajadorId, tipoSuspId);

        log.info("Datos de prueba para permisos/licencias creados exitosamente");
    }

    private Long ensureTipoSuspensionLaboral(String codigo, String nombre, String flagTipoSusp, Long tipoSubsidioId, String flagCitt) {
        Long existingId = findTipoSuspensionLaboralByCodigo(codigo);
        if (existingId != null) return existingId;

        String sql = """
            INSERT INTO rrhh.tipo_suspension_laboral
            (codigo, nombre, flag_tipo_susp, tipo_subsidio_id, flag_citt, created_by, fec_creacion)
            VALUES (?, ?, ?, ?, ?, 1, NOW())
            RETURNING id
            """;
        try {
            return jdbc.queryForObject(sql, Long.class, codigo, nombre, flagTipoSusp, tipoSubsidioId, flagCitt);
        } catch (Exception e) {
            log.error("Error al crear tipo suspensión '{}': {}", codigo, e.getMessage());
            return null;
        }
    }

    private Long findTipoSuspensionLaboralByCodigo(String codigo) {
        try {
            return jdbc.queryForObject("SELECT id FROM rrhh.tipo_suspension_laboral WHERE codigo = ? ORDER BY id LIMIT 1", Long.class, codigo);
        } catch (Exception e) {
            return null;
        }
    }

    public Long createTestTipoSuspensionLaboral(String codigo, String nombre) {
        return ensureTipoSuspensionLaboral(codigo, nombre, "1", null, "0");
    }

    public Long getTipoSuspensionLaboralIdByCodigo(String codigo) {
        return findTipoSuspensionLaboralByCodigo(codigo);
    }

    public Long resolveTipoSuspensionLaboralId() {
        return getTipoSuspensionLaboralIdByCodigo("ENF");
    }

    // ══════════════════════════════════════════════════════════════
    // TIPO SANCIÓN - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensureTipoSancionTestData() {
        log.info("Creando datos de prueba para tipos de sanción...");

        ensureTipoSancion("LEVE", "Amonestación Verbal");
        ensureTipoSancion("MOD", "Amonestación Escrita");
        ensureTipoSancion("GRAVE", "Suspensión sin goce");

        log.info("Datos de prueba para tipos de sanción creados exitosamente");
    }

    private Long ensureTipoSancion(String codigo, String nombre) {
        Long existingId = findTipoSancionByCodigo(codigo);
        if (existingId != null) return existingId;

        String sql = "INSERT INTO rrhh.tipo_sancion (codigo, nombre, created_by, fec_creacion) VALUES (?, ?, 1, NOW()) RETURNING id";
        try {
            return jdbc.queryForObject(sql, Long.class, codigo, nombre);
        } catch (Exception e) {
            log.error("Error al crear tipo sanción '{}': {}", codigo, e.getMessage());
            return null;
        }
    }

    private Long findTipoSancionByCodigo(String codigo) {
        try {
            return jdbc.queryForObject("SELECT id FROM rrhh.tipo_sancion WHERE codigo = ? ORDER BY id LIMIT 1", Long.class, codigo);
        } catch (Exception e) {
            return null;
        }
    }

    public Long createTestTipoSancion(String codigo, String nombre) {
        return ensureTipoSancion(codigo, nombre);
    }

    public Long getTipoSancionIdByCodigo(String codigo) {
        return findTipoSancionByCodigo(codigo);
    }

    public Long resolveTipoSancionId() {
        return getTipoSancionIdByCodigo("LEVE");
    }

    // ══════════════════════════════════════════════════════════════
    // CAPACITACIÓN - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensureCapacitacionTestData() {
        log.info("Creando datos de prueba para capacitaciones...");

        String today = "2026-01-15";
        String nextWeek = "2026-01-20";

        Integer count = jdbc.queryForObject("SELECT COUNT(*) FROM rrhh.capacitacion WHERE nombre LIKE 'Capacitación Test%'", Integer.class);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO rrhh.capacitacion
            (nombre, descripcion, fecha_inicio, fecha_fin, horas, proveedor, costo, flag_estado, created_by, fec_creacion)
            VALUES ('Capacitación Test 1', 'Descripción test 1', ?, ?, 20, 'Proveedor Test', 500.0000, '1', 1, NOW()),
                   ('Capacitación Test 2', 'Descripción test 2', ?, ?, 16, 'Proveedor Test', 300.0000, '1', 1, NOW())
            """, today, nextWeek, today, nextWeek);

        log.info("Datos de prueba para capacitaciones creados exitosamente");
    }

    public Long resolveCapacitacionId() {
        try {
            return jdbc.queryForObject("SELECT id FROM rrhh.capacitacion WHERE nombre = ? ORDER BY id LIMIT 1", Long.class, "Capacitación Test 1");
        } catch (Exception e) {
            return null;
        }
    }

    // ══════════════════════════════════════════════════════════════
    // NOVEDAD RRHH - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensureNovedadRrhhTestData() {
        log.info("Creando datos de prueba para novedades RRHH...");

        Long trabajadorId = ensureTrabajadorTest();
        if (trabajadorId == null) return;

        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.novedad_rrhh WHERE trabajador_id = ?", Integer.class, trabajadorId);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO rrhh.novedad_rrhh
            (trabajador_id, tipo_novedad_rrhh_id, citt, fecha_ini, fecha_fin, dias_teoricos, dias_reales, flag_estado, created_by, fec_creacion)
            VALUES (?, 1, 'CITT-TEST', '2026-01-01', '2026-01-15', 15, 14, '1', 1, NOW())
            """, trabajadorId);

        log.info("Datos de prueba para novedades RRHH creados exitosamente");
    }

    public Long resolveNovedadRrhhId() {
        try {
            return jdbc.queryForObject("SELECT id FROM rrhh.novedad_rrhh WHERE citt = ? ORDER BY id LIMIT 1", Long.class, "CITT-TEST");
        } catch (Exception e) {
            return null;
        }
    }

    // ══════════════════════════════════════════════════════════════
    // CNTA CRRTE - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensureCntaCrrteTestData() {
        log.info("Creando datos de prueba para cuentas corrientes...");

        Long trabajadorId = ensureTrabajadorTest();
        if (trabajadorId == null) return;

        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.cnta_crrte WHERE trabajador_id = ?", Integer.class, trabajadorId);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO rrhh.cnta_crrte
            (trabajador_id, doc_tipo_id, nro_doc, concepto_planilla_id, fec_prestamo,
             nro_cuotas, monto_original, monto_cuota, saldo_prestamo, flag_estado, created_by, fec_creacion)
            VALUES (?, 1, 'CC-TEST-001', 1, '2026-01-01', 1, 1000.00000, 1000.00000, 800.00000, '1', 1, NOW())
            """, trabajadorId);

        log.info("Datos de prueba para cuentas corrientes creados exitosamente");
    }

    public Long resolveCntaCrrteId() {
        try {
            Long trabajadorId = ensureTrabajadorTest();
            if (trabajadorId == null) return null;
            return jdbc.queryForObject("SELECT id FROM rrhh.cnta_crrte WHERE trabajador_id = ? ORDER BY id LIMIT 1", Long.class, trabajadorId);
        } catch (Exception e) {
            return null;
        }
    }

    // ══════════════════════════════════════════════════════════════
    // PRÉSTAMO - Test Data Factory (Rol B)
    // ══════════════════════════════════════════════════════════════

    public void ensurePrestamoTestData() {
        log.info("Creando datos de prueba para préstamos...");

        Long trabajadorId = ensureTrabajadorTest();
        if (trabajadorId == null) return;

        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.prestamo WHERE trabajador_id = ?", Integer.class, trabajadorId);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO rrhh.prestamo
            (trabajador_id, monto_total, cuotas, cuota_mensual, saldo, flag_estado, created_by, fec_creacion)
            VALUES (?, 5000.0000, 12, 450.0000, 3000.0000, '1', 1, NOW())
            """, trabajadorId);

        log.info("Datos de prueba para préstamos creados exitosamente");
    }

    public Long resolvePrestamoId() {
        try {
            Long trabajadorId = ensureTrabajadorTest();
            if (trabajadorId == null) return null;
            return jdbc.queryForObject("SELECT id FROM rrhh.prestamo WHERE trabajador_id = ? ORDER BY id LIMIT 1", Long.class, trabajadorId);
        } catch (Exception e) {
            return null;
        }
    }
}
