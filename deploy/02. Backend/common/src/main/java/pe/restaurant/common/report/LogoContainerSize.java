package pe.restaurant.common.report;

/**
 * Tamaños predefinidos para el contenedor de logo en reportes PDF.
 * <p>
 * El contenedor mantiene un <b>aspect ratio fijo 3:1</b> (ancho : alto).
 * La imagen dentro del contenedor se centra vertical y horizontalmente
 * sin exceder los bordes y <b>sin estirarse</b> (equivalente a CSS
 * {@code object-fit: contain} o JasperReports {@code scaleImage="RetainShape"}).
 * <p>
 * Si el logo es cuadrado, quedará centrado sin cambiar sus proporciones.
 * Si el logo es rectangular, se ajustará al máximo posible dentro del
 * contenedor sin deformarse.
 * <p>
 * <b>HTML/Thymeleaf</b>: usar el fragmento {@code fragments/logo_container :: logo(...)}<br>
 * <b>JasperReports</b>: usar el subreporte {@code /reports/logo_container.jrxml}
 */
public enum LogoContainerSize {

    /** 90 × 30 px — cabeceras compactas, tickets, formatos reducidos. */
    S(90, 30),

    /** 120 × 40 px — tamaño estándar para documentos A4. */
    M(120, 40),

    /** 150 × 50 px — tamaño por defecto, cabeceras prominentes, portadas. */
    L(150, 50);

    /** Aspect ratio fijo del contenedor: ancho / alto = 3/1. */
    public static final double ASPECT_RATIO = 3.0;

    private final int width;
    private final int height;

    LogoContainerSize(int width, int height) {
        this.width = width;
        this.height = height;
    }

    public int getWidth()  { return width; }
    public int getHeight() { return height; }

    /** CSS inline para el contenedor (width + height). */
    public String cssContainer() {
        return "width:" + width + "px;height:" + height + "px;";
    }

    /** CSS inline para la imagen (max bounds + object-fit). */
    public String cssImage() {
        return "max-width:" + width + "px;max-height:" + height + "px;";
    }

    /**
     * Resuelve un tamaño por nombre (case-insensitive), con fallback a {@link #L}.
     */
    public static LogoContainerSize of(String name) {
        if (name == null || name.isBlank()) return L;
        try {
            return valueOf(name.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return M;
        }
    }
}
