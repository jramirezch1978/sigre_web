package pe.restaurant.compras.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Compras entities - lifecycle hooks")
class EntityLifecycleTest {

    @Test
    @DisplayName("ContratoMarco prePersist y preUpdate asignan auditoria")
    void contratoMarco_prePersistYPreUpdate_asignanAuditoria() {
        ContratoMarco entity = new ContratoMarco();
        entity.setProveedorId(1L);
        entity.setNroContrato("CM-001");
        entity.setFechaInicio(LocalDate.of(2026, 5, 23));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("ConformidadServicioDet lifecycle conserva relacion y subtotal")
    void conformidadServicioDet_lifecycle_conservaRelacionYSubtotal() {
        ConformidadServicio parent = new ConformidadServicio();
        ConformidadServicioDet det = new ConformidadServicioDet();
        det.setConformidadServicio(parent);
        det.setSecuencia(1);
        det.setCantidad(new BigDecimal("2"));
        det.setPrecioUnitario(new BigDecimal("50"));
        det.setSubtotal(new BigDecimal("100"));

        det.prePersist();
        assertThat(det.getFecCreacion()).isNotNull();
        assertThat(det.getConformidadServicio()).isSameAs(parent);
        assertThat(det.getSubtotal()).isEqualByComparingTo("100");

        det.preUpdate();
        assertThat(det.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("ArticuloEstructura lifecycle mantiene defaults")
    void articuloEstructura_lifecycle_mantieneDefaults() {
        ArticuloEstructura entity = new ArticuloEstructura();
        entity.setArticuloPadreId(1L);
        entity.setArticuloHijoId(2L);

        entity.onCreate();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getCantidad()).isEqualByComparingTo(BigDecimal.ZERO);

        entity.onUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("TipoPercepcion lifecycle mantiene estado por defecto")
    void tipoPercepcion_lifecycle_mantieneEstadoPorDefecto() {
        TipoPercepcion entity = new TipoPercepcion();
        entity.setCodigo("51");
        entity.setDescripcion("Percepcion");
        entity.setTasa(new BigDecimal("2.0000"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("Aprobacion prePersist asigna fecha y auditoria")
    void aprobacion_prePersist_asignaFechaYAuditoria() {
        Aprobacion entity = new Aprobacion();
        entity.setDocTipoId(85L);
        entity.setDocumentoId(900L);

        entity.prePersist();

        assertThat(entity.getNivel()).isEqualTo(1);
        assertThat(entity.getFecha()).isNotNull();
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("ProgramacionComprasDet lifecycle asigna timestamps")
    void programacionComprasDet_lifecycle_asignaTimestamps() {
        ProgramacionComprasDet entity = new ProgramacionComprasDet();
        entity.setArticuloId(1L);
        entity.setCantidad(new BigDecimal("5"));
        entity.setPrecioEstimado(new BigDecimal("11.20"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("OrdenCompra addLinea enlaza bidireccionalmente y conserva defaults")
    void ordenCompra_addLinea_enlazaBidireccionalmenteYConservaDefaults() {
        OrdenCompra entity = new OrdenCompra();
        entity.setSucursalId(1L);
        entity.setProveedorId(2L);
        entity.setFechaEmision(LocalDate.of(2026, 5, 23));

        OrdenCompraDet det = new OrdenCompraDet();
        det.setArticuloId(10L);
        det.setCantProyectada(new BigDecimal("2"));
        det.setValorUnitario(new BigDecimal("15.50"));

        entity.prePersist();
        entity.addLinea(det);

        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getLineas()).containsExactly(det);
        assertThat(det.getOrdenCompra()).isSameAs(entity);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getTotal()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    @DisplayName("OrdenCompraDet lifecycle asigna timestamps")
    void ordenCompraDet_lifecycle_asignaTimestamps() {
        OrdenCompraDet entity = new OrdenCompraDet();
        entity.setArticuloId(1L);
        entity.setCantProyectada(new BigDecimal("4"));
        entity.setValorUnitario(new BigDecimal("20"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getCantProcesada()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(entity.getFlagEstado()).isEqualTo("1");

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("OrdenServicio addLinea enlaza bidireccionalmente y conserva defaults")
    void ordenServicio_addLinea_enlazaBidireccionalmenteYConservaDefaults() {
        OrdenServicio entity = new OrdenServicio();
        entity.setSucursalId(1L);
        entity.setProveedorId(2L);
        entity.setFecRegistro(LocalDate.of(2026, 5, 23));

        OrdenServicioDet det = new OrdenServicioDet();
        det.setNroItem(1);
        det.setServicioId(5L);
        det.setImporte(new BigDecimal("45"));

        entity.prePersist();
        entity.addLinea(det);

        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getLineas()).containsExactly(det);
        assertThat(det.getOrdenServicio()).isSameAs(entity);
        assertThat(entity.getFlagCotizacion()).isEqualTo("0");
        assertThat(entity.getMontoTotal()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    @DisplayName("OrdenServicioDet lifecycle asigna timestamps")
    void ordenServicioDet_lifecycle_asignaTimestamps() {
        OrdenServicioDet entity = new OrdenServicioDet();
        entity.setNroItem(1);
        entity.setServicioId(8L);
        entity.setImporte(new BigDecimal("100"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getImpuesto()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(entity.getFlagEstado()).isEqualTo("1");

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("SolicitudCompra addLinea enlaza bidireccionalmente")
    void solicitudCompra_addLinea_enlazaBidireccionalmente() {
        SolicitudCompra entity = new SolicitudCompra();
        entity.setFecha(LocalDate.of(2026, 5, 23));

        SolicitudCompraDet det = new SolicitudCompraDet();
        det.setArticuloId(3L);
        det.setCantidad(new BigDecimal("7"));

        entity.prePersist();
        entity.addLinea(det);

        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getLineas()).containsExactly(det);
        assertThat(det.getSolicitudCompra()).isSameAs(entity);
        assertThat(entity.getPrioridad()).isEqualTo("MEDIA");
    }

    @Test
    @DisplayName("SolicitudCompraDet lifecycle asigna timestamps")
    void solicitudCompraDet_lifecycle_asignaTimestamps() {
        SolicitudCompraDet entity = new SolicitudCompraDet();
        entity.setArticuloId(3L);
        entity.setCantidad(new BigDecimal("7"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("Cotizacion addLinea enlaza bidireccionalmente")
    void cotizacion_addLinea_enlazaBidireccionalmente() {
        Cotizacion entity = new Cotizacion();
        entity.setSucursalId(1L);
        entity.setProveedorId(2L);
        entity.setFecha(LocalDate.of(2026, 5, 23));

        CotizacionDet det = new CotizacionDet();
        det.setArticuloId(4L);
        det.setCantidad(new BigDecimal("2"));
        det.setPrecioUnitario(new BigDecimal("12.50"));

        entity.prePersist();
        entity.addLinea(det);

        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getLineas()).containsExactly(det);
        assertThat(det.getCotizacion()).isSameAs(entity);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("CotizacionDet lifecycle asigna timestamps")
    void cotizacionDet_lifecycle_asignaTimestamps() {
        CotizacionDet entity = new CotizacionDet();
        entity.setArticuloId(4L);
        entity.setCantidad(new BigDecimal("2"));
        entity.setPrecioUnitario(new BigDecimal("12.50"));

        entity.prePersist();
        assertThat(entity.getFecCreacion()).isNotNull();
        assertThat(entity.getDescuento()).isEqualByComparingTo(BigDecimal.ZERO);

        entity.preUpdate();
        assertThat(entity.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("ArticuloEstructuraId equals y hashCode comparan ambas claves")
    void articuloEstructuraId_equalsYHashCode_comparanAmbasClaves() {
        ArticuloEstructuraId left = new ArticuloEstructuraId();
        left.setArticuloPadreId(1L);
        left.setArticuloHijoId(2L);

        ArticuloEstructuraId right = new ArticuloEstructuraId();
        right.setArticuloPadreId(1L);
        right.setArticuloHijoId(2L);

        ArticuloEstructuraId other = new ArticuloEstructuraId();
        other.setArticuloPadreId(1L);
        other.setArticuloHijoId(3L);

        assertThat(left).isEqualTo(right);
        assertThat(left).hasSameHashCodeAs(right);
        assertThat(left).isNotEqualTo(other);
    }
}
