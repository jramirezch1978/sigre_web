package pe.restaurant.rrhh.repository;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Trabajador;

/**
 * Repositorio JPA para la entidad {@link Trabajador}.
 * Incluye consultas de filtrado paginado y validaciones de FK cruzadas
 * hacia esquemas {@code rrhh}, {@code auth} y {@code core}.
 */
@Repository
public interface TrabajadorRepository extends JpaRepository<Trabajador, Long> {

    /** Verifica si ya existe un trabajador activo con el mismo código. */
    boolean existsByCodigoTrabajadorAndFlagEstado(String codigoTrabajador, String flagEstado);

    /** Verifica si ya existe un trabajador activo con el mismo número de documento. */
    boolean existsByNumeroDocumentoAndFlagEstado(String numeroDocumento, String flagEstado);

    /** Verifica duplicidad de código excluyendo al trabajador que se está editando. */
    boolean existsByCodigoTrabajadorAndIdNotAndFlagEstado(String codigoTrabajador, Long id, String flagEstado);

    /** Verifica duplicidad de documento excluyendo al trabajador que se está editando. */
    boolean existsByNumeroDocumentoAndIdNotAndFlagEstado(String numeroDocumento, Long id, String flagEstado);

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     * Los filtros de texto aplican LIKE case-insensitive.
     */
    @Query("SELECT t FROM Trabajador t WHERE "
            + "(:codigoTrabajador IS NULL OR :codigoTrabajador = '' OR LOWER(t.codigoTrabajador) LIKE LOWER(CONCAT('%', :codigoTrabajador, '%'))) "
            + "AND (:nombres IS NULL OR :nombres = '' OR LOWER(t.nombres) LIKE LOWER(CONCAT('%', :nombres, '%'))) "
            + "AND (:apellidoPaterno IS NULL OR :apellidoPaterno = '' OR LOWER(t.apellidoPaterno) LIKE LOWER(CONCAT('%', :apellidoPaterno, '%'))) "
            + "AND (:numeroDocumento IS NULL OR :numeroDocumento = '' OR t.numeroDocumento LIKE CONCAT('%', :numeroDocumento, '%')) "
            + "AND (:areaId IS NULL OR t.areaId = :areaId) "
            + "AND (:cargoId IS NULL OR t.cargoId = :cargoId) "
            + "AND (:sucursalId IS NULL OR t.sucursalId = :sucursalId) "
            + "AND (:flagEstado IS NULL OR :flagEstado = '' OR t.flagEstado = :flagEstado)")
    Page<Trabajador> findWithFilters(
            @Param("codigoTrabajador") String codigoTrabajador,
            @Param("nombres") String nombres,
            @Param("apellidoPaterno") String apellidoPaterno,
            @Param("numeroDocumento") String numeroDocumento,
            @Param("areaId") Long areaId,
            @Param("cargoId") Long cargoId,
            @Param("sucursalId") Long sucursalId,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);

    /** Valida existencia de área en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.area WHERE id = :id", nativeQuery = true)
    boolean existsAreaById(@Param("id") Long id);

    /** Valida existencia de cargo en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.cargo WHERE id = :id", nativeQuery = true)
    boolean existsCargoById(@Param("id") Long id);

    /** Valida existencia de sucursal activa en esquema {@code auth}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM auth.sucursal WHERE id = :id AND flag_estado = '1'", nativeQuery = true)
    boolean existsSucursalById(@Param("id") Long id);

    /** Valida existencia de administradora AFP en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.admin_afp WHERE id = :id", nativeQuery = true)
    boolean existsAdminAfpById(@Param("id") Long id);

    /** Obtiene el nombre del área por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.area WHERE id = :id", nativeQuery = true)
    String findAreaNombreById(@Param("id") Long id);

    /** Obtiene el nombre del cargo por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.cargo WHERE id = :id", nativeQuery = true)
    String findCargoNombreById(@Param("id") Long id);

    /** Obtiene el nombre de la sucursal por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM auth.sucursal WHERE id = :id", nativeQuery = true)
    String findSucursalNombreById(@Param("id") Long id);

    /** Obtiene el nombre de la administradora AFP por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.admin_afp WHERE id = :id", nativeQuery = true)
    String findAdminAfpNombreById(@Param("id") Long id);

    /** Obtiene el nombre del turno por ID para resolver FK en responses de horario. */
    @Query(value = "SELECT nombre FROM rrhh.turno WHERE id = :id", nativeQuery = true)
    String findTurnoNombreById(@Param("id") Long id);

    /** Valida existencia de turno en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.turno WHERE id = :id", nativeQuery = true)
    boolean existsTurnoById(@Param("id") Long id);

    /** Verifica si existen trabajadores asignados a una AFP específica. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.trabajador WHERE admin_afp_id = :id AND flag_estado = '1'", nativeQuery = true)
    boolean existsTrabajadoresByAdminAfpId(@Param("id") Long id);

    // ── Catálogos FK: tipo_doc_identidad, sexo, estado_civil, regimen_laboral ──

    /** Valida existencia de tipo de documento de identidad en esquema {@code core}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM core.tipo_doc_identidad WHERE id = :id", nativeQuery = true)
    boolean existsTipoDocIdentidadById(@Param("id") Long id);

    /** Valida existencia de sexo en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.sexo WHERE id = :id", nativeQuery = true)
    boolean existsSexoById(@Param("id") Long id);

    /** Valida existencia de estado civil en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.estado_civil WHERE id = :id", nativeQuery = true)
    boolean existsEstadoCivilById(@Param("id") Long id);

    /** Valida existencia de régimen laboral en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.regimen_laboral WHERE id = :id", nativeQuery = true)
    boolean existsRegimenLaboralById(@Param("id") Long id);

    /** Obtiene el nombre del tipo de documento de identidad por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM core.tipo_doc_identidad WHERE id = :id", nativeQuery = true)
    String findTipoDocIdentidadNombreById(@Param("id") Long id);

    /** Obtiene el nombre del sexo por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.sexo WHERE id = :id", nativeQuery = true)
    String findSexoNombreById(@Param("id") Long id);

    /** Obtiene el nombre del estado civil por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.estado_civil WHERE id = :id", nativeQuery = true)
    String findEstadoCivilNombreById(@Param("id") Long id);

    /** Obtiene el nombre del régimen laboral por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.regimen_laboral WHERE id = :id", nativeQuery = true)
    String findRegimenLaboralNombreById(@Param("id") Long id);

    /** Obtiene el código del régimen laboral por ID (usado en cálculo de liquidación). */
    @Query(value = "SELECT codigo FROM rrhh.regimen_laboral WHERE id = :id", nativeQuery = true)
    String findRegimenLaboralCodigoById(@Param("id") Long id);

    /** Valida existencia de entidad contribuyente en esquema {@code core}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM core.entidad_contribuyente WHERE id = :id", nativeQuery = true)
    boolean existsEntidadContribuyenteById(@Param("id") Long id);

    /** Valida existencia de tipo de contrato en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.tipo_contrato WHERE id = :id", nativeQuery = true)
    boolean existsTipoContratoById(@Param("id") Long id);

    /** Obtiene el nombre del tipo de contrato por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.tipo_contrato WHERE id = :id", nativeQuery = true)
    String findTipoContratoNombreById(@Param("id") Long id);

    /** Lista IDs de trabajadores activos para procesos batch. */
    @Query(value = "SELECT id FROM rrhh.trabajador WHERE flag_estado = '1'", nativeQuery = true)
    List<Long> findActivosIds();
}
