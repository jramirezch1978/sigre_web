package com.sigre.common.testutil;

import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * Wrapper "factory" for seeding integration test data by methods.
 *
 * <p>In this codebase, the real seeding logic is implemented in {@link TestDataSeeder}.
 * This class exists to provide the "TestDataFactory" naming and a fluent API that teams
 * can use from tests:</p>
 *
 * <pre>
 *   @Autowired DataSource ds;
 *   @BeforeEach void seed() {
 *     TestDataFactory.using(ds)
 *       .seedAlmacenUser()
 *       .seedValeMov();
 *   }
 * </pre>
 *
 * <p>Important: master data is loaded by SQL seeds (e.g. 01-carga-inicial-maestros.sql).
 * Only transactional or non-seeded tables should be created here.</p>
 */
public final class TestDataFactory {

    private final TestDataSeeder seeder;

    private TestDataFactory(TestDataSeeder seeder) {
        this.seeder = seeder;
    }

    public static TestDataFactory using(DataSource dataSource) {
        return new TestDataFactory(new TestDataSeeder(dataSource));
    }

    public static TestDataFactory using(JdbcTemplate jdbcTemplate) {
        return new TestDataFactory(new TestDataSeeder(jdbcTemplate));
    }

    /** Seeds all transactional datasets known by the project. */
    public TestDataFactory seedAll() {
        seeder.seedAll();
        return this;
    }

    // ── Core ────────────────────────────────────────────────────────────────

    public TestDataFactory seedMoneda() {
        seeder.seedMoneda();
        return this;
    }

    public TestDataFactory seedTiposDocumento() {
        seeder.seedTiposDocumento();
        return this;
    }

    public TestDataFactory seedDocTipo() {
        seeder.seedDocTipo();
        return this;
    }

    public TestDataFactory seedSucursal() {
        seeder.seedSucursal();
        return this;
    }

    public TestDataFactory seedCentrosCosto() {
        seeder.seedCentrosCosto();
        return this;
    }

    public TestDataFactory seedArticulo() {
        seeder.seedArticulo();
        return this;
    }

    public TestDataFactory seedEntidadContribuyente() {
        seeder.seedEntidadContribuyente();
        return this;
    }

    public TestDataFactory seedConceptoFinanciero() {
        seeder.seedConceptoFinanciero();
        return this;
    }

    public TestDataFactory seedPlanContable() {
        seeder.seedPlanContable();
        return this;
    }

    // ── Almacén transactional ────────────────────────────────────────────────

    public TestDataFactory seedUbicacionAlmacen() {
        seeder.seedUbicacionAlmacen();
        return this;
    }

    public TestDataFactory seedLotePallet() {
        seeder.seedLotePallet();
        return this;
    }

    public TestDataFactory seedAlmacenUser() {
        seeder.seedAlmacenUser();
        return this;
    }

    public TestDataFactory seedAlmacenTipoMov() {
        seeder.seedAlmacenTipoMov();
        return this;
    }

    public TestDataFactory seedValeMov() {
        seeder.seedValeMov();
        return this;
    }

    public TestDataFactory seedGuia() {
        seeder.seedGuia();
        return this;
    }

    public TestDataFactory seedOrdenTraslado() {
        seeder.seedOrdenTraslado();
        return this;
    }

    public TestDataFactory seedInventarioConteo() {
        seeder.seedInventarioConteo();
        return this;
    }

    public TestDataFactory seedSolicitudSalida() {
        seeder.seedSolicitudSalida();
        return this;
    }

    public TestDataFactory seedArticuloBonificacion() {
        seeder.seedArticuloBonificacion();
        return this;
    }

    public TestDataFactory seedArticuloAlmacen() {
        seeder.seedArticuloAlmacen();
        return this;
    }

    public TestDataFactory seedArticuloAlmacenPosicion() {
        seeder.seedArticuloAlmacenPosicion();
        return this;
    }

    public TestDataFactory seedArticuloSaldoMensual() {
        seeder.seedArticuloSaldoMensual();
        return this;
    }

    // ── Finanzas / Ventas transactional ─────────────────────────────────────

    public TestDataFactory seedBanco() {
        seeder.seedBanco();
        return this;
    }

    public TestDataFactory seedBancoCnta() {
        seeder.seedBancoCnta();
        return this;
    }

    public TestDataFactory seedCntasPagar() {
        seeder.seedCntasPagar();
        return this;
    }

    public TestDataFactory seedCntasCobrar() {
        seeder.seedCntasCobrar();
        return this;
    }

    public TestDataFactory seedDocTipoNumSerie() {
        seeder.seedDocTipoNumSerie();
        return this;
    }

    // ── Compras transactional ─────────────────────────────────────────────────

    public TestDataFactory seedComprador() {
        seeder.seedComprador();
        return this;
    }

    public TestDataFactory seedAprobadorConfigurado() {
        seeder.seedAprobadorConfigurado();
        return this;
    }

    public TestDataFactory seedServicio() {
        seeder.seedServicio();
        return this;
    }
}

