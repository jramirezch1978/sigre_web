package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mapstruct.factory.Mappers;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.ventas.dto.request.*;
import pe.restaurant.ventas.entity.*;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VentasMappersTest {

    private final CanalDistribucionMapper canalDistribucionMapper = Mappers.getMapper(CanalDistribucionMapper.class);
    private final MesaMapper mesaMapper = Mappers.getMapper(MesaMapper.class);
    private final ZonaMapper zonaMapper = Mappers.getMapper(ZonaMapper.class);
    private final ZonaVentaMapper zonaVentaMapper = Mappers.getMapper(ZonaVentaMapper.class);
    private final ZonaDespachoMapper zonaDespachoMapper = Mappers.getMapper(ZonaDespachoMapper.class);
    private final ZonaRepartoMapper zonaRepartoMapper = Mappers.getMapper(ZonaRepartoMapper.class);
    private final VendedorMapper vendedorMapper = Mappers.getMapper(VendedorMapper.class);
    private final PuntoVentaMapper puntoVentaMapper = Mappers.getMapper(PuntoVentaMapper.class);
    private final ServiciosCxCMapper serviciosCxCMapper = Mappers.getMapper(ServiciosCxCMapper.class);
    private final CartaMapper cartaMapper = Mappers.getMapper(CartaMapper.class);
    private final CartaMenuMapper cartaMenuMapper = Mappers.getMapper(CartaMenuMapper.class);
    private final CuentaCobrarMapper cuentaCobrarMapper = new CuentaCobrarMapper();
    private final VentasResponseMapper ventasResponseMapper = new VentasResponseMapper();

    @Mock
    private VentasFkValidator fkValidator;
    @Mock
    private MesaRepository mesaRepository;

    @Test
    void canalDistribucionMapper_roundTrip() {
        CanalDistribucionRequest req = new CanalDistribucionRequest();
        req.setCodigo("CD01");
        req.setNombre("Directo");
        CanalDistribucion entity = canalDistribucionMapper.toEntity(req);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("CD01");

        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(canalDistribucionMapper.toResponse(entity).getCodigo()).isEqualTo("CD01");
        assertThat(canalDistribucionMapper.toResponseList(List.of(entity))).hasSize(1);

        canalDistribucionMapper.updateEntity(req, entity);
        assertThat(entity.getNombre()).isEqualTo("Directo");

        assertThat(canalDistribucionMapper.toEntity(null)).isNull();
        assertThat(canalDistribucionMapper.toResponse(null)).isNull();
    }

    @Test
    void mesaMapper_roundTrip() {
        MesaRequest req = new MesaRequest();
        req.setZonaId(5L);
        req.setNumero("M01");
        req.setCapacidad(4);
        Mesa entity = mesaMapper.toEntity(req);
        assertThat(entity.getZona().getId()).isEqualTo(5L);

        entity.setId(2L);
        entity.setFlagEstado("1");
        assertThat(mesaMapper.toResponse(entity).getNumero()).isEqualTo("M01");
        assertThat(mesaMapper.toResponseList(List.of(entity))).hasSize(1);
        mesaMapper.updateEntity(req, entity);
        assertThat(mesaMapper.toEntity(null)).isNull();
        assertThat(mesaMapper.toResponse(null)).isNull();
    }

    @Test
    void zonaMapper_roundTrip() {
        ZonaRequest req = new ZonaRequest();
        req.setSucursalId(1L);
        req.setNombre("Salón");
        req.setCapacidad(30);
        Zona entity = zonaMapper.toEntity(req);
        assertThat(entity.getSucursal().getId()).isEqualTo(1L);

        entity.setId(3L);
        entity.setFlagEstado("1");
        Zona.Sucursal suc = new Zona.Sucursal();
        suc.setId(1L);
        suc.setNombre("Sucursal 1");
        entity.setSucursal(suc);
        assertThat(zonaMapper.toResponse(entity).getSucursalNombre()).isEqualTo("Sucursal 1");
        assertThat(zonaMapper.toResponseList(List.of(entity))).hasSize(1);
        zonaMapper.updateEntity(req, entity);
        assertThat(zonaMapper.toEntity(null)).isNull();
        assertThat(zonaMapper.toResponse(null)).isNull();
    }

    @Test
    void zonaVentaMapper_roundTrip() {
        ZonaVentaRequest req = new ZonaVentaRequest();
        req.setZonaVenta("ZV01");
        req.setDescZonaVenta("Zona Norte");
        ZonaVenta entity = zonaVentaMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(zonaVentaMapper.toResponse(entity).getZonaVenta()).isEqualTo("ZV01");
        assertThat(zonaVentaMapper.toResponseList(List.of(entity))).hasSize(1);
        zonaVentaMapper.updateEntity(req, entity);
        assertThat(zonaVentaMapper.toEntity(null)).isNull();
        assertThat(zonaVentaMapper.toResponse(null)).isNull();
    }

    @Test
    void zonaDespachoMapper_roundTrip() {
        ZonaDespachoRequest req = new ZonaDespachoRequest();
        req.setZonaDespacho("ZD01");
        ZonaDespacho entity = zonaDespachoMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(zonaDespachoMapper.toResponse(entity).getZonaDespacho()).isEqualTo("ZD01");
        assertThat(zonaDespachoMapper.toResponseList(List.of(entity))).hasSize(1);
        zonaDespachoMapper.updateEntity(req, entity);
        assertThat(zonaDespachoMapper.toEntity(null)).isNull();
        assertThat(zonaDespachoMapper.toResponse(null)).isNull();
    }

    @Test
    void zonaRepartoMapper_roundTrip() {
        ZonaRepartoRequest req = new ZonaRepartoRequest();
        req.setZonaReparto("ZR01");
        ZonaReparto entity = zonaRepartoMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(zonaRepartoMapper.toResponse(entity).getZonaReparto()).isEqualTo("ZR01");
        assertThat(zonaRepartoMapper.toResponseList(List.of(entity))).hasSize(1);
        zonaRepartoMapper.updateEntity(req, entity);
        assertThat(zonaRepartoMapper.toEntity(null)).isNull();
        assertThat(zonaRepartoMapper.toResponse(null)).isNull();
    }

    @Test
    void vendedorMapper_roundTrip() {
        VendedorRequest req = new VendedorRequest();
        req.setUsuarioId(100L);
        req.setNombre("Juan");
        req.setComisionPorcentaje(new BigDecimal("5"));
        Vendedor entity = vendedorMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(vendedorMapper.toResponse(entity).getNombre()).isEqualTo("Juan");
        assertThat(vendedorMapper.toResponseList(List.of(entity))).hasSize(1);
        vendedorMapper.updateEntity(req, entity);
        assertThat(vendedorMapper.toEntity(null)).isNull();
        assertThat(vendedorMapper.toResponse(null)).isNull();
    }

    @Test
    void puntoVentaMapper_roundTrip() {
        PuntoVentaRequest req = new PuntoVentaRequest();
        req.setSucursalId(1L);
        req.setCodigo("PV01");
        req.setNombre("Caja 1");
        PuntoVenta entity = puntoVentaMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(puntoVentaMapper.toResponse(entity).getCodigo()).isEqualTo("PV01");
        assertThat(puntoVentaMapper.toResponseList(List.of(entity))).hasSize(1);
        puntoVentaMapper.updateEntity(req, entity);
        assertThat(puntoVentaMapper.toEntity(null)).isNull();
        assertThat(puntoVentaMapper.toResponse(null)).isNull();
    }

    @Test
    void serviciosCxCMapper_roundTrip() {
        ServiciosCxCRequest req = new ServiciosCxCRequest();
        req.setCodServicio("SVC01");
        req.setDescServicio("Delivery");
        req.setTarifa(new BigDecimal("12"));
        ServiciosCxC entity = serviciosCxCMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(serviciosCxCMapper.toResponse(entity).getCodServicio()).isEqualTo("SVC01");
        assertThat(serviciosCxCMapper.toResponseList(List.of(entity))).hasSize(1);
        serviciosCxCMapper.updateEntity(req, entity);
        assertThat(serviciosCxCMapper.toEntity(null)).isNull();
        assertThat(serviciosCxCMapper.toResponse(null)).isNull();
    }

    @Test
    void cartaMapper_roundTrip() {
        CartaRequest req = new CartaRequest();
        req.setSucursalId(1L);
        req.setNombre("Menú");
        CartaRequest.CartaDetRequest detReq = new CartaRequest.CartaDetRequest();
        detReq.setArticuloId(10L);
        detReq.setPrecio(new BigDecimal("15"));
        req.setDetalles(List.of(detReq));

        Carta entity = cartaMapper.toEntity(req);
        assertThat(entity.getDetalles()).hasSize(1);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(cartaMapper.toResponse(entity).getNombre()).isEqualTo("Menú");
        assertThat(cartaMapper.toResponseList(List.of(entity))).hasSize(1);
        cartaMapper.updateEntity(req, entity);
        assertThat(cartaMapper.toEntity(null)).isNull();
        assertThat(cartaMapper.toResponse(null)).isNull();
    }

    @Test
    void cartaMenuMapper_roundTrip() {
        CartaRequest req = new CartaRequest();
        req.setSucursalId(1L);
        req.setNombre("Carta");
        Carta entity = cartaMenuMapper.toEntity(req);
        entity.setId(1L);
        entity.setFlagEstado("1");
        assertThat(cartaMenuMapper.toListItemResponse(entity).getNombre()).isEqualTo("Carta");
        assertThat(cartaMenuMapper.toListItemResponseList(List.of(entity))).hasSize(1);
        cartaMenuMapper.updateEntity(req, entity);
        assertThat(cartaMenuMapper.toEntity(null)).isNull();
        assertThat(cartaMenuMapper.toListItemResponse(null)).isNull();
    }

    @Test
    void cuentaCobrarMapper_nullSafe() {
        assertThat(cuentaCobrarMapper.toResponse(null, List.of())).isNull();
        assertThat(cuentaCobrarMapper.toListItemResponse(null)).isNull();
        assertThat(cuentaCobrarMapper.toListItemResponseList(null)).isEmpty();
    }

    @Test
    void cuentaCobrarMapper_mapsEntity() {
        CuentaCobrar cxc = CuentaCobrar.builder()
                .id(1L)
                .sucursalId(10L)
                .clienteId(5L)
                .docTipoId(1L)
                .serie("F001")
                .numero("00001")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L)
                .total(new BigDecimal("100"))
                .saldo(new BigDecimal("50"))
                .build();
        cxc.setFlagEstado("1");
        cxc.setFecCreacion(Instant.now());
        assertThat(cuentaCobrarMapper.toListItemResponse(cxc).getSerie()).isEqualTo("F001");
        assertThat(cuentaCobrarMapper.toListItemResponse(cxc).getDocTipoNombre()).isEqualTo("Boleta");
        assertThat(cuentaCobrarMapper.toListItemResponse(cxc).getMonedaSimbolo()).isEqualTo("S/");

        CuentaCobrarDet mov = CuentaCobrarDet.builder()
                .id(2L)
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(1L)
                .referencia("REF")
                .build();
        mov.setFlagEstado("1");
        mov.setFecCreacion(Instant.now());
        var full = cuentaCobrarMapper.toResponse(cxc, List.of(mov));
        assertThat(full.getMovimientos()).hasSize(1);
        assertThat(full.getMovimientos().get(0).getTipoMov()).isEqualTo("ABONO");

        CuentaCobrar cxc2 = CuentaCobrar.builder().id(2L).docTipoId(2L).monedaId(2L).build();
        assertThat(cuentaCobrarMapper.toListItemResponse(cxc2).getDocTipoNombre()).isEqualTo("Factura");
        assertThat(cuentaCobrarMapper.toListItemResponseList(List.of(cxc))).hasSize(1);
        assertThat(cuentaCobrarMapper.toResponse(cxc, null).getMovimientos()).isEmpty();
    }

    @Test
    void cartaMenuMapper_detalleCompleto() {
        Carta carta = new Carta();
        carta.setId(1L);
        carta.setSucursalId(1L);
        carta.setNombre("Menú");
        carta.setFlagEstado("1");
        carta.setFecCreacion(Instant.now());
        CartaDet det = new CartaDet();
        det.setId(10L);
        det.setPrecio(new BigDecimal("25"));
        CartaDet.Articulo art = new CartaDet.Articulo();
        art.setId(5L);
        art.setCodigo("ART01");
        art.setNombre("Pollo");
        det.setArticulo(art);
        det.setCarta(carta);
        carta.setDetalles(new ArrayList<>());
        carta.getDetalles().add(det);

        assertThat(cartaMenuMapper.toResponse(carta).getItems()).hasSize(1);
        assertThat(cartaMenuMapper.toResponseList(List.of(carta))).hasSize(1);
        assertThat(cartaMenuMapper.toListItemResponsePage(new org.springframework.data.domain.PageImpl<>(List.of(carta)))
                .getContent()).hasSize(1);

        CartaRequest req = new CartaRequest();
        req.setSucursalId(1L);
        req.setNombre("Nueva");
        CartaRequest.CartaDetRequest detReq = new CartaRequest.CartaDetRequest();
        detReq.setArticuloId(99L);
        detReq.setPrecio(new BigDecimal("10"));
        req.setDetalles(List.of(detReq));
        assertThat(cartaMenuMapper.toEntity(req).getDetalles()).hasSize(1);
    }

    @Test
    void ventasIssue5DtoMapper_reservacion() {
        VentasIssue5DtoMapper issue5Mapper = new VentasIssue5DtoMapper(fkValidator, mesaRepository);
        Reservacion r = new Reservacion();
        r.setId(1L);
        r.setSucursalId(1L);
        r.setClienteId(2L);
        r.setMesaId(3L);
        r.setFecha(LocalDate.now());
        r.setFlagEstado("1");
        ReservacionDet det = new ReservacionDet();
        det.setId(10L);
        det.setArticuloId(50L);
        det.setCantidad(BigDecimal.ONE);
        r.getItems().add(det);

        when(fkValidator.findSucursalNombre(1L)).thenReturn("Sucursal");
        when(fkValidator.findEntidadRazonSocial(2L)).thenReturn("Cliente");
        when(mesaRepository.findById(3L)).thenReturn(Optional.of(new Mesa()));
        assertThat(issue5Mapper.toReservacionResponse(r).getItems()).hasSize(1);
        assertThat(issue5Mapper.toReservacionListItem(r).getItems()).isNull();
    }

    @Test
    void ventasResponseMapper_nullSafe() {
        assertThat(ventasResponseMapper.toOrdenVentaResponse(null)).isNull();
        assertThat(ventasResponseMapper.toProformaResponse(null)).isNull();
        assertThat(ventasResponseMapper.toCierreCajaResponse(null)).isNull();
        assertThat(ventasResponseMapper.toDescuentoResponse(null)).isNull();
    }

    @Test
    void ventasIssue5DtoMapper_mapsCreditos() {
        VentasIssue5DtoMapper issue5Mapper = new VentasIssue5DtoMapper(fkValidator, mesaRepository);
        EntidadCreditosCxc e = new EntidadCreditosCxc();
        e.setId(1L);
        e.setEntidadContribuyenteId(10L);
        e.setMonedaId(1L);
        e.setLimiteCredito(new BigDecimal("5000"));
        e.setDiasCredito(30);
        e.setFlagEstado("1");
        when(fkValidator.findEntidadRazonSocial(10L)).thenReturn("Cliente SA");
        when(fkValidator.findEntidadRuc(10L)).thenReturn("20123456789");
        when(fkValidator.findMonedaSimbolo(1L)).thenReturn("S/");
        assertThat(issue5Mapper.toCreditosResponse(e).getEntidadRazonSocial()).isEqualTo("Cliente SA");
    }

    @Test
    void ventasIssue5DtoMapper_propinaNull() {
        VentasIssue5DtoMapper issue5Mapper = new VentasIssue5DtoMapper(fkValidator, mesaRepository);
        Propina p = new Propina();
        p.setId(1L);
        p.setMonto(new BigDecimal("5"));
        p.setFlagEstado("1");
        p.setFecha(LocalDate.now());
        assertThat(issue5Mapper.toPropinaResponse(p).getMonto()).isEqualByComparingTo("5");
    }
}
