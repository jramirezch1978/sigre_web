package pe.restaurant.compras.integration;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.compras.support.ComprasIntegrationTest;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

@ComprasIntegrationTest
@DisplayName("Compras tenant DB probe")
class ComprasTenantDbProbeIT {

    @Autowired
    private DataSource dataSource;

    @Test
    @DisplayName("imprime contexto real de BD tenant para compras")
    void probeTenantDatabaseContext() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);

        String currentDatabase = jdbc.queryForObject("select current_database()", String.class);
        String currentSchema = jdbc.queryForObject("select current_schema()", String.class);
        String searchPath = jdbc.queryForObject("show search_path", String.class);
        String docTipoRegclass = jdbc.queryForObject("select to_regclass('core.doc_tipo')::text", String.class);

        List<Map<String, Object>> docTipos = jdbc.queryForList("""
                select id, codigo, nombre, flag_estado
                from core.doc_tipo
                where codigo in ('OC', 'OS')
                order by codigo
                """);

        System.out.println("DB_PROBE current_database=" + currentDatabase);
        System.out.println("DB_PROBE current_schema=" + currentSchema);
        System.out.println("DB_PROBE search_path=" + searchPath);
        System.out.println("DB_PROBE core.doc_tipo=" + docTipoRegclass);
        System.out.println("DB_PROBE core.doc_tipo OC/OS rows=" + docTipos);

        assertThat(currentDatabase).isNotBlank();
        assertThat(docTipoRegclass).isNotBlank();
        assertThat(docTipos).isNotEmpty();
    }
}
