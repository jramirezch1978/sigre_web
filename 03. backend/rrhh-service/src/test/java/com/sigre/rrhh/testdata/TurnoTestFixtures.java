package com.sigre.rrhh.testdata;

import com.sigre.rrhh.dto.request.TurnoRequest;
import com.sigre.rrhh.dto.response.TurnoResponse;
import com.sigre.rrhh.entity.Turno;

import java.time.Instant;
import java.time.LocalTime;
import java.time.OffsetDateTime;

/**
 * Fixtures estáticos en RAM para tests del módulo de Turnos.
 * Proporciona datos de prueba consistentes para unit tests (C) y bodies JSON en integration tests.
 * Siguen el patrón C del estándar de testing del proyecto.
 */
public final class TurnoTestFixtures {

    private TurnoTestFixtures() {
        throw new UnsupportedOperationException("Clase de fixtures - no instanciable");
    }

    // ==== Fixtures de DTOs (Request/Response) ====

    /**
     * Crea un TurnoRequest con datos válidos y completos.
     * Ideal para tests de creación y actualización.
     */
    public static TurnoRequest turnoRequestValido() {
        return TurnoRequest.builder()
                .nombre("Turno Mañana Estándar")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 30))
                .minutosTolerancia(15)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .build();
    }

    /**
     * Crea un TurnoRequest para turno nocturno.
     * Cruza medianoche para probar validaciones de horario.
     */
    public static TurnoRequest turnoRequestNocturno() {
        return TurnoRequest.builder()
                .nombre("Turno Nocturno")
                .horaEntrada(LocalTime.of(22, 0))
                .horaSalida(LocalTime.of(6, 0))
                .minutosTolerancia(10)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(true)
                .aplicaDomingo(false)
                .build();
    }

    /**
     * Crea un TurnoRequest con fines de semana.
     * Para probar escenarios con días no laborales.
     */
    public static TurnoRequest turnoRequestFinDeSemana() {
        return TurnoRequest.builder()
                .nombre("Turno Fin de Semana")
                .horaEntrada(LocalTime.of(10, 0))
                .horaSalida(LocalTime.of(14, 0))
                .minutosTolerancia(5)
                .aplicaLunes(false)
                .aplicaMartes(false)
                .aplicaMiercoles(false)
                .aplicaJueves(false)
                .aplicaViernes(false)
                .aplicaSabado(true)
                .aplicaDomingo(true)
                .build();
    }

    /**
     * Crea un TurnoRequest inválido (sin días activos).
     * Para probar validaciones de negocio.
     */
    public static TurnoRequest turnoRequestSinDiasActivos() {
        return TurnoRequest.builder()
                .nombre("Turno Sin Días")
                .horaEntrada(LocalTime.of(9, 0))
                .horaSalida(LocalTime.of(17, 0))
                .minutosTolerancia(0)
                .aplicaLunes(false)
                .aplicaMartes(false)
                .aplicaMiercoles(false)
                .aplicaJueves(false)
                .aplicaViernes(false)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .build();
    }

    /**
     * Crea un TurnoRequest con tolerancia negativa.
     * Para probar validaciones de valores negativos.
     */
    public static TurnoRequest turnoRequestToleranciaNegativa() {
        return TurnoRequest.builder()
                .nombre("Turno Tolerancia Negativa")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(-10)
                .aplicaLunes(true)
                .build();
    }

    /**
     * Crea un TurnoRequest con nombre vacío.
     * Para probar validaciones de campos obligatorios.
     */
    public static TurnoRequest turnoRequestNombreVacio() {
        return TurnoRequest.builder()
                .nombre("")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(0)
                .aplicaLunes(true)
                .build();
    }

    /**
     * Crea un TurnoRequest con nombre nulo.
     * Para probar validaciones de nulos.
     */
    public static TurnoRequest turnoRequestNombreNulo() {
        return TurnoRequest.builder()
                .nombre(null)
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(0)
                .aplicaLunes(true)
                .build();
    }

    // ==== Fixtures de Entidades ====

    /**
     * Crea una entidad Turno completa con datos válidos.
     * Para tests de repository y mapper.
     */
    public static Turno turnoEntityValido(Long id) {
        Turno turno = new Turno();
        turno.setNombre("Turno Mañana Entidad");
        turno.setHoraEntrada(LocalTime.of(8, 0));
        turno.setHoraSalida(LocalTime.of(16, 30));
        turno.setMinutosTolerancia(15);
        turno.setAplicaLunes(true);
        turno.setAplicaMartes(true);
        turno.setAplicaMiercoles(true);
        turno.setAplicaJueves(true);
        turno.setAplicaViernes(true);
        turno.setAplicaSabado(false);
        turno.setAplicaDomingo(false);
        turno.setId(id);
        turno.setCreatedBy(1L);
        turno.setFecCreacion(Instant.now());
        return turno;
    }

    /**
     * Crea una entidad Turno con auditoría completa.
     * Incluye campos de actualización para tests de modificación.
     */
    public static Turno turnoEntityConAuditoria(Long id) {
        Turno turno = new Turno();
        turno.setNombre("Turno Con Auditoría");
        turno.setHoraEntrada(LocalTime.of(9, 0));
        turno.setHoraSalida(LocalTime.of(17, 0));
        turno.setMinutosTolerancia(10);
        turno.setAplicaLunes(true);
        turno.setAplicaMartes(true);
        turno.setAplicaMiercoles(true);
        turno.setAplicaJueves(true);
        turno.setAplicaViernes(true);
        turno.setAplicaSabado(false);
        turno.setAplicaDomingo(false);
        turno.setId(id);
        turno.setCreatedBy(1L);
        turno.setFecCreacion(Instant.now().minusSeconds(86400));
        turno.setUpdatedBy(2L);
        turno.setFecModificacion(Instant.now());
        return turno;
    }

    /**
     * Crea una entidad Turno nocturna.
     * Cruza medianoche para casos especiales.
     */
    public static Turno turnoEntityNocturna(Long id) {
        Turno turno = new Turno();
        turno.setNombre("Turno Nocturno Entidad");
        turno.setHoraEntrada(LocalTime.of(22, 0));
        turno.setHoraSalida(LocalTime.of(6, 0));
        turno.setMinutosTolerancia(10);
        turno.setAplicaLunes(true);
        turno.setAplicaMartes(true);
        turno.setAplicaMiercoles(true);
        turno.setAplicaJueves(true);
        turno.setAplicaViernes(true);
        turno.setAplicaSabado(true);
        turno.setAplicaDomingo(false);
        turno.setId(id);
        turno.setCreatedBy(1L);
        turno.setFecCreacion(Instant.now());
        return turno;
    }

    // ==== Fixtures de Response ====

    /**
     * Crea un TurnoResponse completo.
     * Para tests de controller y mapper.
     */
    public static TurnoResponse turnoResponseValido(Long id) {
        return TurnoResponse.builder()
                .id(id)
                .nombre("Turno Mañana Response")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 30))
                .minutosTolerancia(15)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .createdBy(1L)
                .fecCreacion(OffsetDateTime.now())
                .build();
    }

    /**
     * Crea un TurnoResponse con auditoría completa.
     * Para verificar actualizaciones.
     */
    public static TurnoResponse turnoResponseConAuditoria(Long id) {
        return TurnoResponse.builder()
                .id(id)
                .nombre("Turno Response Actualizado")
                .horaEntrada(LocalTime.of(9, 30))
                .horaSalida(LocalTime.of(18, 0))
                .minutosTolerancia(20)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(true)
                .aplicaDomingo(false)
                .createdBy(1L)
                .fecCreacion(OffsetDateTime.now().minusDays(1))
                .updatedBy(2L)
                .fecModificacion(OffsetDateTime.now())
                .build();
    }

    // ==== Fixtures para casos borde ====

    /**
     * Crea un TurnoRequest con horarios mínimos.
     * 1 minuto de tolerancia, horario básico.
     */
    public static TurnoRequest turnoRequestMinimo() {
        return TurnoRequest.builder()
                .nombre("Turno Mínimo")
                .horaEntrada(LocalTime.of(0, 1))
                .horaSalida(LocalTime.of(23, 59))
                .minutosTolerancia(1)
                .aplicaLunes(true)
                .build();
    }

    /**
     * Crea un TurnoRequest con valores máximos.
     * Máxima tolerancia, nombre largo.
     */
    public static TurnoRequest turnoRequestMaximo() {
        return TurnoRequest.builder()
                .nombre("Turno Con Nombre Muy Largo Para Probar Validación De Tamaño Máximo De Campo")
                .horaEntrada(LocalTime.of(0, 0))
                .horaSalida(LocalTime.of(23, 59))
                .minutosTolerancia(999)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(true)
                .aplicaDomingo(true)
                .build();
    }

    // ==== Utilitarios ====

    /**
     * Crea un TurnoRequest con nombre personalizado.
     * Útil para tests de unicidad de nombre.
     */
    public static TurnoRequest turnoRequestConNombre(String nombre) {
        return TurnoRequest.builder()
                .nombre(nombre)
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(10)
                .aplicaLunes(true)
                .build();
    }

    /**
     * Crea un TurnoRequest con horarios personalizados.
     * Para probar validaciones de coherencia horaria.
     */
    public static TurnoRequest turnoRequestConHorarios(LocalTime entrada, LocalTime salida) {
        return TurnoRequest.builder()
                .nombre("Turno Horario Personalizado")
                .horaEntrada(entrada)
                .horaSalida(salida)
                .minutosTolerancia(10)
                .aplicaLunes(true)
                .build();
    }
}
