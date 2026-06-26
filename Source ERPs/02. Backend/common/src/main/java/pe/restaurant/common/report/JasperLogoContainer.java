package pe.restaurant.common.report;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

/**
 * Compila una sola vez el subreporte {@code /reports/logo_container.jrxml} incluido en el JAR common.
 * Ver comentarios en ese archivo para parámetros ({@code logoImage}, {@code logoSize}).
 */
public final class JasperLogoContainer {

    private static volatile JasperReport compiled;

    private JasperLogoContainer() {
    }

    /**
     * Subreporte listo para pasar como {@code $P{logoSubreport}} en reportes padre.
     *
     * @throws JRException si falta el recurso o la compilación falla
     */
    public static JasperReport compiledSubreport() throws JRException {
        JasperReport local = compiled;
        if (local != null) {
            return local;
        }
        synchronized (JasperLogoContainer.class) {
            if (compiled == null) {
                try (var in = JasperLogoContainer.class.getResourceAsStream("/reports/logo_container.jrxml")) {
                    if (in == null) {
                        throw new JRException("Classpath missing resource /reports/logo_container.jrxml");
                    }
                    compiled = JasperCompileManager.compileReport(in);
                } catch (java.io.IOException e) {
                    throw new JRException(e);
                }
            }
            return compiled;
        }
    }

    /**
     * Variante sin {@link JRException} comprobada para uso desde servicios que ya convierten cualquier fallo a error de negocio.
     */
    public static JasperReport requireCompiledSubreport() {
        try {
            return compiledSubreport();
        } catch (JRException e) {
            throw new IllegalStateException("No se pudo compilar logo_container.jrxml", e);
        }
    }
}
