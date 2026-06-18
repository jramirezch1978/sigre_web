package pe.restaurant.almacen.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.almacen.dto.*;
import pe.restaurant.almacen.entity.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static pe.restaurant.almacen.TestDataFactory.almacen;

class AlmacenMappersTest {

    private final AlmacenMapper almacenMapper = Mappers.getMapper(AlmacenMapper.class);
    private final AlmacenTipoMapper almacenTipoMapper = Mappers.getMapper(AlmacenTipoMapper.class);
    private final ArticuloMovTipoMapper articuloMovTipoMapper = Mappers.getMapper(ArticuloMovTipoMapper.class);
    private final ArticuloBonificacionMapper articuloBonificacionMapper = Mappers.getMapper(ArticuloBonificacionMapper.class);
    private final LotePalletMapper lotePalletMapper = Mappers.getMapper(LotePalletMapper.class);
    private final MotivoTrasladoMapper motivoTrasladoMapper = Mappers.getMapper(MotivoTrasladoMapper.class);
    private final UbicacionAlmacenMapper ubicacionAlmacenMapper = Mappers.getMapper(UbicacionAlmacenMapper.class);

    @Test
    void almacenMapper_toEntity_yResponse() {
        AlmacenRequest req = new AlmacenRequest();
        req.setSucursalId(1L);
        req.setAlmacenTipoId(2L);
        req.setCodigo("AL-01");
        req.setNombre("Central");

        Almacen entity = almacenMapper.toEntity(req);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getCodigo()).isEqualTo("AL-01");

        Almacen saved = almacen(5L);
        AlmacenResponse resp = almacenMapper.toResponse(saved);
        assertThat(resp.getId()).isEqualTo(5L);
        assertThat(resp.getCodigo()).isEqualTo(saved.getCodigo());

        assertThat(almacenMapper.toResponseList(List.of(saved))).hasSize(1);
        assertThat(almacenMapper.toResponseList(null)).isNull();
        assertThat(almacenMapper.toEntity(null)).isNull();
        assertThat(almacenMapper.toResponse(null)).isNull();
    }

    @Test
    void almacenMapper_updateEntity() {
        Almacen entity = almacen(1L);
        AlmacenRequest req = new AlmacenRequest();
        req.setNombre("Nuevo nombre");
        almacenMapper.updateEntity(req, entity);
        assertThat(entity.getNombre()).isEqualTo("Nuevo nombre");
        assertThat(entity.getId()).isEqualTo(1L);
        almacenMapper.updateEntity(null, entity);
        assertThat(entity.getNombre()).isEqualTo("Nuevo nombre");
    }

    @Test
    void articuloMovTipoMapper_roundTrip() {
        ArticuloMovTipoRequest req = new ArticuloMovTipoRequest();
        req.setTipoMov("I01");
        req.setDescTipoMov("Ingreso");
        req.setFlagEstado("1");
        req.setFactorSldoTotal(BigDecimal.ONE);

        ArticuloMovTipo entity = articuloMovTipoMapper.toEntity(req);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getTipoMov()).isEqualTo("I01");

        entity.setId(3L);
        ArticuloMovTipoResponse resp = articuloMovTipoMapper.toResponse(entity);
        assertThat(resp.getId()).isEqualTo(3L);
        assertThat(articuloMovTipoMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(articuloMovTipoMapper.toResponseList(null)).isNull();
        assertThat(articuloMovTipoMapper.toEntity(null)).isNull();
        assertThat(articuloMovTipoMapper.toResponse(null)).isNull();

        ArticuloMovTipo target = new ArticuloMovTipo();
        target.setId(3L);
        target.setTipoMov("OLD");
        articuloMovTipoMapper.updateEntity(req, target);
        assertThat(target.getTipoMov()).isEqualTo("I01");
        assertThat(target.getId()).isEqualTo(3L);
        articuloMovTipoMapper.updateEntity(null, target);
        assertThat(target.getTipoMov()).isEqualTo("I01");
    }

    @Test
    void ubicacionAlmacenMapper_mapsCampos() {
        UbicacionAlmacenRequest req = new UbicacionAlmacenRequest();
        req.setCodigo("A-01");
        req.setNombre("Pasillo A");
        req.setPasillo("P1");

        UbicacionAlmacen entity = ubicacionAlmacenMapper.toEntity(req);
        entity.setId(7L);
        entity.setAlmacenId(10L);
        assertThat(ubicacionAlmacenMapper.toResponse(entity).getCodigo()).isEqualTo("A-01");
        assertThat(ubicacionAlmacenMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(ubicacionAlmacenMapper.toResponseList(null)).isNull();
        assertThat(ubicacionAlmacenMapper.toEntity(null)).isNull();
        assertThat(ubicacionAlmacenMapper.toResponse(null)).isNull();

        UbicacionAlmacen target = new UbicacionAlmacen();
        target.setId(7L);
        target.setAlmacenId(10L);
        ubicacionAlmacenMapper.updateEntity(req, target);
        assertThat(target.getNombre()).isEqualTo("Pasillo A");
        assertThat(target.getAlmacenId()).isEqualTo(10L);
        ubicacionAlmacenMapper.updateEntity(null, target);
        assertThat(target.getNombre()).isEqualTo("Pasillo A");
    }

    @Test
    void motivoTrasladoMapper_mapsCampos() {
        MotivoTrasladoRequest req = new MotivoTrasladoRequest();
        req.setCodigo("MT01");
        req.setNombre("Traslado interno");

        MotivoTraslado entity = motivoTrasladoMapper.toEntity(req);
        entity.setId(1L);
        assertThat(motivoTrasladoMapper.toResponse(entity).getCodigo()).isEqualTo("MT01");
        assertThat(motivoTrasladoMapper.toResponse(entity).getNombre()).isEqualTo("Traslado interno");
        assertThat(motivoTrasladoMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(motivoTrasladoMapper.toResponseList(Collections.emptyList())).isEmpty();
        assertThat(motivoTrasladoMapper.toEntity(null)).isNull();
        assertThat(motivoTrasladoMapper.toResponse(null)).isNull();

        MotivoTraslado target = new MotivoTraslado();
        target.setId(1L);
        motivoTrasladoMapper.updateEntity(req, target);
        assertThat(target.getCodigo()).isEqualTo("MT01");
        motivoTrasladoMapper.updateEntity(null, target);
        assertThat(target.getCodigo()).isEqualTo("MT01");
        assertThat(motivoTrasladoMapper.toResponseList(null)).isNull();
    }

    @Test
    void lotePalletMapper_mapsCampos() {
        LotePalletRequest req = new LotePalletRequest();
        req.setAlmacenId(10L);
        req.setArticuloId(100L);
        req.setNroLote("LOTE-1");
        req.setFechaProduccion(LocalDate.of(2026, 1, 1));
        req.setObservacion("obs");

        LotePallet entity = lotePalletMapper.toEntity(req);
        entity.setId(4L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(lotePalletMapper.toResponse(entity).getNroLote()).isEqualTo("LOTE-1");
        assertThat(lotePalletMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(lotePalletMapper.toResponseList(null)).isNull();
        assertThat(lotePalletMapper.toEntity(null)).isNull();
        assertThat(lotePalletMapper.toResponse(null)).isNull();

        LotePallet target = new LotePallet();
        target.setId(4L);
        target.setAlmacenId(10L);
        target.setArticuloId(100L);
        lotePalletMapper.updateEntity(req, target);
        assertThat(target.getNroLote()).isEqualTo("LOTE-1");
        assertThat(target.getObservacion()).isEqualTo("obs");
        assertThat(target.getAlmacenId()).isEqualTo(10L);
        lotePalletMapper.updateEntity(null, target);
        assertThat(target.getNroLote()).isEqualTo("LOTE-1");
    }

    @Test
    void articuloBonificacionMapper_mapsCampos() {
        ArticuloBonificacionRequest req = new ArticuloBonificacionRequest();
        req.setArticuloId(100L);
        req.setCantidadMinima(new BigDecimal("10"));
        req.setCantidadBonificacion(new BigDecimal("2"));

        ArticuloBonificacion entity = articuloBonificacionMapper.toEntity(req);
        entity.setId(8L);
        assertThat(articuloBonificacionMapper.toResponse(entity).getArticuloId()).isEqualTo(100L);
        assertThat(articuloBonificacionMapper.toResponse(entity).getCantidadBonificacion())
                .isEqualByComparingTo("2");
        assertThat(articuloBonificacionMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(articuloBonificacionMapper.toEntity(null)).isNull();
        assertThat(articuloBonificacionMapper.toResponse(null)).isNull();

        ArticuloBonificacion target = new ArticuloBonificacion();
        target.setId(8L);
        articuloBonificacionMapper.updateEntity(req, target);
        assertThat(target.getCantidadMinima()).isEqualByComparingTo("10");
        articuloBonificacionMapper.updateEntity(null, target);
        assertThat(target.getCantidadMinima()).isEqualByComparingTo("10");
        assertThat(articuloBonificacionMapper.toResponseList(null)).isNull();
    }

    @Test
    void almacenTipoMapper_mapsCampos() {
        AlmacenTipoRequest req = new AlmacenTipoRequest();
        req.setCodigo("TIPO-1");
        req.setNombre("Principal");

        AlmacenTipo entity = almacenTipoMapper.toEntity(req);
        entity.setId(2L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(almacenTipoMapper.toResponse(entity).getNombre()).isEqualTo("Principal");
        assertThat(almacenTipoMapper.toResponseList(List.of(entity))).hasSize(1);
        assertThat(almacenTipoMapper.toResponseList(null)).isNull();
        assertThat(almacenTipoMapper.toEntity(null)).isNull();
        assertThat(almacenTipoMapper.toResponse(null)).isNull();

        AlmacenTipo target = new AlmacenTipo();
        target.setId(2L);
        target.setFlagEstado("0");
        almacenTipoMapper.updateEntity(req, target);
        assertThat(target.getNombre()).isEqualTo("Principal");
        assertThat(target.getFlagEstado()).isEqualTo("0");
        almacenTipoMapper.updateEntity(null, target);
        assertThat(target.getNombre()).isEqualTo("Principal");
        assertThat(almacenTipoMapper.toResponseList(Collections.emptyList())).isEmpty();
    }
}
