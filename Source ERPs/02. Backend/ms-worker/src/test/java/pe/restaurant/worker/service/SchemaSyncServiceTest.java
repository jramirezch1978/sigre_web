package pe.restaurant.worker.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.worker.config.DataSyncProperties;
import pe.restaurant.worker.config.DynamicTenantDataSourceManager;
import pe.restaurant.worker.dto.SchemaSyncRequest;
import pe.restaurant.worker.repository.SchemaSyncCronLogRepository;
import pe.restaurant.worker.schema.PgSchemaDiffEngine;
import pe.restaurant.common.schema.PgSchemaMetadataReader;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@ExtendWith(MockitoExtension.class)
class SchemaSyncServiceTest {

    @Mock
    private PgSchemaMetadataReader metadataReader;
    @Mock
    private PgSchemaDiffEngine diffEngine;
    @Mock
    private DynamicTenantDataSourceManager dataSourceManager;
    @Mock
    private SchemaSyncCronLogRepository cronLogRepository;
    @Mock
    private SchemaSyncEmailNotifier emailNotifier;
    @Mock
    private DataSyncProperties dataSyncProperties;

    private SchemaSyncService service;

    @BeforeEach
    void setUp() throws Exception {
        service = new SchemaSyncService(
                metadataReader,
                diffEngine,
                dataSourceManager,
                cronLogRepository,
                emailNotifier,
                dataSyncProperties);

        var adminSecretField = SchemaSyncService.class.getDeclaredField("adminSecret");
        adminSecretField.setAccessible(true);
        adminSecretField.set(service, "test-secret");
    }

    @Test
    @DisplayName("CA-06: Admin secret valido acepta")
    void validAdminSecret() {
        assertThat(service.isAdminSecretValid("test-secret")).isTrue();
    }

    @Test
    @DisplayName("CA-06: Admin secret invalido rechaza")
    void invalidAdminSecret() {
        assertThat(service.isAdminSecretValid("wrong")).isFalse();
    }

    @Test
    @DisplayName("CA-06: Admin secret null rechaza")
    void nullAdminSecret() {
        assertThat(service.isAdminSecretValid(null)).isFalse();
    }

    @Test
    @DisplayName("CA-06: Admin secret en blanco rechaza")
    void blankAdminSecret() {
        assertThat(service.isAdminSecretValid("  ")).isFalse();
    }

    @Test
    @DisplayName("allowDestructive sin token -> no confirmado")
    void destructiveWithoutToken() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setAllowDestructive(true);
        request.setDestructiveConfirmationToken(null);

        assertThat(service.isDestructiveConfirmed(request)).isFalse();
    }

    @Test
    @DisplayName("allowDestructive con token correcto -> confirmado")
    void destructiveWithValidToken() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setAllowDestructive(true);
        request.setDestructiveConfirmationToken("test-secret");

        assertThat(service.isDestructiveConfirmed(request)).isTrue();
    }

    @Test
    @DisplayName("allowDestructive con token incorrecto -> no confirmado")
    void destructiveWithWrongToken() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setAllowDestructive(true);
        request.setDestructiveConfirmationToken("wrong-secret");

        assertThat(service.isDestructiveConfirmed(request)).isFalse();
    }

    @Test
    @DisplayName("Sin allowDestructive -> siempre confirmado (no se requiere token)")
    void nonDestructiveAlwaysConfirmed() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setAllowDestructive(false);

        assertThat(service.isDestructiveConfirmed(request)).isTrue();
    }

    @Test
    @DisplayName("execute con allowDestructive sin token valido -> lanza excepcion")
    void executeBlocksUnconfirmedDestructive() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setAllowDestructive(true);
        request.setDestructiveConfirmationToken(null);

        assertThatThrownBy(() -> service.execute(request, "test"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("destructiveConfirmationToken");
    }

    @Test
    @DisplayName("CA-03: Request por defecto es dry-run")
    void defaultIsDryRun() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        assertThat(request.isDryRun()).isTrue();
    }

    @Test
    @DisplayName("Request por defecto no permite destructivos")
    void defaultNoDestructive() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        assertThat(request.isAllowDestructive()).isFalse();
    }

    @Test
    @DisplayName("Request sin tenantDbNames apunta a todos")
    void defaultTargetsAll() {
        SchemaSyncRequest request = new SchemaSyncRequest();
        assertThat(request.targetsAllTenants()).isTrue();
    }
}
