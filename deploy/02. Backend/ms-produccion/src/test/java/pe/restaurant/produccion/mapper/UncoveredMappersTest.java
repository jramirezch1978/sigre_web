package pe.restaurant.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.produccion.dto.response.*;
import pe.restaurant.produccion.entity.*;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class UncoveredMappersTest {

    // ==================== ParteInsumoMapper ====================

    @Test
    void parteInsumo_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(ParteInsumoMapper.class);
        var entity = new ParteProduccionInsumo();
        entity.setId(1L);
        entity.setArticuloId(100L);
        entity.setUnidadMedidaId(10L);
        entity.setCantidadConsumida(BigDecimal.valueOf(25));
        entity.setValeMovId(999L);

        ParteInsumoResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(100L);
        assertThat(out.getUnidadMedidaId()).isEqualTo(10L);
        assertThat(out.getCantidadConsumida()).isEqualByComparingTo(BigDecimal.valueOf(25));
        assertThat(out.getValeMovId()).isEqualTo(999L);
    }

    @Test
    void parteInsumo_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(ParteInsumoMapper.class);
        var a = new ParteProduccionInsumo();
        a.setId(1L);
        a.setArticuloId(100L);
        var b = new ParteProduccionInsumo();
        b.setId(2L);
        b.setArticuloId(101L);

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(ParteInsumoResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(ParteInsumoResponse::getArticuloId).containsExactly(100L, 101L);
    }

    // ==================== LaborEjecutorMapper ====================

    @Test
    void laborEjecutor_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(LaborEjecutorMapper.class);
        var entity = new LaborEjecutor();
        entity.setId(1L);
        entity.setLaborId(10L);
        entity.setEjecutorId(20L);
        entity.setCostoUnitario(BigDecimal.valueOf(50));
        entity.setFlagEstado("1");

        LaborEjecutorResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getLaborId()).isEqualTo(10L);
        assertThat(out.getEjecutorId()).isEqualTo(20L);
        assertThat(out.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(50));
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void laborEjecutor_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(LaborEjecutorMapper.class);
        var a = new LaborEjecutor();
        a.setId(1L);
        a.setLaborId(10L);
        var b = new LaborEjecutor();
        b.setId(2L);
        b.setLaborId(20L);

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(LaborEjecutorResponse::getId).containsExactly(1L, 2L);
    }

    // ==================== FichaTecnicaMapper ====================

    @Test
    void fichaTecnica_toResponse_conFoto_tieneFotoTrue() {
        var mapper = Mappers.getMapper(FichaTecnicaMapper.class);
        var entity = new FichaTecnica();
        entity.setId(1L);
        entity.setAlergenos("NINGUNO");
        entity.setCalorias(BigDecimal.valueOf(450));
        entity.setFotoBlob(new byte[]{1, 2, 3});

        FichaTecnicaResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getAlergenos()).isEqualTo("NINGUNO");
        assertThat(out.getCalorias()).isEqualByComparingTo(BigDecimal.valueOf(450));
        assertThat(out.getTieneFotoBlob()).isTrue();
    }

    @Test
    void fichaTecnica_toResponse_sinFoto_tieneFotoFalse() {
        var mapper = Mappers.getMapper(FichaTecnicaMapper.class);
        var entity = new FichaTecnica();
        entity.setId(1L);
        entity.setFotoBlob(null);

        FichaTecnicaResponse out = mapper.toResponse(entity);

        assertThat(out.getTieneFotoBlob()).isFalse();
    }

    // ==================== RecetaLaborMapper ====================

    @Test
    void recetaLabor_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(RecetaLaborMapper.class);
        var entity = new RecetaLabor();
        entity.setId(1L);
        entity.setRecetaId(10L);
        entity.setLaborId(20L);
        entity.setSecuencia(1);
        entity.setDescripcionPaso("Paso 1");

        RecetaLaborResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getLaborId()).isEqualTo(20L);
        assertThat(out.getSecuencia()).isEqualTo(1);
        assertThat(out.getDescripcionPaso()).isEqualTo("Paso 1");
    }

    @Test
    void recetaLabor_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(RecetaLaborMapper.class);
        var a = new RecetaLabor();
        a.setId(1L);
        a.setSecuencia(1);
        var b = new RecetaLabor();
        b.setId(2L);
        b.setSecuencia(2);

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(RecetaLaborResponse::getId).containsExactly(1L, 2L);
    }

    // ==================== RecetaConsumibleMapper ====================

    @Test
    void recetaConsumible_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(RecetaConsumibleMapper.class);
        var entity = new RecetaLaborConsumible();
        entity.setId(1L);
        entity.setRecetaPadreId(10L);
        entity.setArticuloId(100L);
        entity.setCantidad(BigDecimal.valueOf(5));

        RecetaConsumibleResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(100L);
        assertThat(out.getCantidad()).isEqualByComparingTo(BigDecimal.valueOf(5));
    }

    @Test
    void recetaConsumible_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(RecetaConsumibleMapper.class);
        var a = new RecetaLaborConsumible();
        a.setId(1L);
        a.setArticuloId(100L);
        var b = new RecetaLaborConsumible();
        b.setId(2L);
        b.setArticuloId(101L);

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(RecetaConsumibleResponse::getId).containsExactly(1L, 2L);
    }

    // ==================== CaractDetMapper ====================

    @Test
    void caractDet_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(CaractDetMapper.class);
        var entity = new ArticuloDocTecnicaCaractDet();
        entity.setId(1L);
        entity.setArticuloDocTecnicaId(10L);
        entity.setCaracteristica("Color");
        entity.setValor("Rojo");
        entity.setUnidadMedidaId(5L);

        CaractDetResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getCaracteristica()).isEqualTo("Color");
        assertThat(out.getValor()).isEqualTo("Rojo");
        assertThat(out.getUnidadMedidaId()).isEqualTo(5L);
    }

    @Test
    void caractDet_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(CaractDetMapper.class);
        var a = new ArticuloDocTecnicaCaractDet();
        a.setId(1L);
        a.setCaracteristica("A");
        var b = new ArticuloDocTecnicaCaractDet();
        b.setId(2L);
        b.setCaracteristica("B");

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(CaractDetResponse::getId).containsExactly(1L, 2L);
    }

    // ==================== ParteProducidoMapper ====================

    @Test
    void parteProducido_toResponse_mapeaCampos() {
        var mapper = Mappers.getMapper(ParteProducidoMapper.class);
        var entity = new ParteProduccionProducido();
        entity.setId(1L);
        entity.setParteProduccionId(10L);
        entity.setArticuloId(100L);
        entity.setUnidadMedidaId(5L);
        entity.setCantidadProducida(BigDecimal.valueOf(30));

        ParteProducidoResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(100L);
        assertThat(out.getUnidadMedidaId()).isEqualTo(5L);
        assertThat(out.getCantidadProducida()).isEqualByComparingTo(BigDecimal.valueOf(30));
    }

    @Test
    void parteProducido_toResponseList_mapeaCadaElemento() {
        var mapper = Mappers.getMapper(ParteProducidoMapper.class);
        var a = new ParteProduccionProducido();
        a.setId(1L);
        a.setArticuloId(100L);
        var b = new ParteProduccionProducido();
        b.setId(2L);
        b.setArticuloId(101L);

        var out = mapper.toResponseList(List.of(a, b));

        assertThat(out).extracting(ParteProducidoResponse::getId).containsExactly(1L, 2L);
    }

    // ==================== null safety (toResponse) ====================

    @Test
    void todosLosMappers_toResponse_retornanNull_cuandoEntityNull() {
        assertThat(Mappers.getMapper(ParteInsumoMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(LaborEjecutorMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(FichaTecnicaMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(RecetaLaborMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(RecetaConsumibleMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(CaractDetMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(ParteProducidoMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(OperacionesDetMapper.class).toResponse(null)).isNull();
    }

    @Test
    void todosLosMappers_toResponseList_retornanNull_cuandoListNull() {
        assertThat(Mappers.getMapper(ParteInsumoMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(LaborEjecutorMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(RecetaLaborMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(RecetaConsumibleMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(CaractDetMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(ParteProducidoMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(OperacionesDetMapper.class).toResponseList(null)).isNull();
    }

    @Test
    void mappersConSoloResponse_toResponse_retornanNull_cuandoEntityNull() {
        assertThat(Mappers.getMapper(OtAdminUderMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(LaborProduccionMapper.class).toResponse(null)).isNull();
        assertThat(Mappers.getMapper(LaborInsumoMapper.class).toResponse(null)).isNull();
    }

    @Test
    void mappersConSoloResponse_toResponseList_retornanNull_cuandoListNull() {
        assertThat(Mappers.getMapper(OtAdminUderMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(LaborProduccionMapper.class).toResponseList(null)).isNull();
        assertThat(Mappers.getMapper(LaborInsumoMapper.class).toResponseList(null)).isNull();
    }

    // ==================== null safety (toEntity - mappers faltantes) ====================

    @Test
    void mappersFaltantes_toEntity_retornanNull_cuandoRequestNull() {
        assertThat(Mappers.getMapper(ParteProduccionMapper.class).toEntity(null)).isNull();
    }

    // ==================== null safety (updateEntity) ====================

    @Test
    void mappersConUpdate_updateEntity_requestNull_noCambia() {
        var entity = new Operacion();
        entity.setId(1L);
        Mappers.getMapper(OperacionMapper.class).updateEntity(null, entity);
        assertThat(entity.getId()).isEqualTo(1L);

        var receta = new Receta();
        receta.setId(1L);
        Mappers.getMapper(RecetaMapper.class).updateEntity(null, receta);
        assertThat(receta.getId()).isEqualTo(1L);

        var costeo = new CosteoProduccion();
        Mappers.getMapper(CosteoProduccionMapper.class).updateEntity(null, costeo);

        var prog = new ProgramacionProduccion();
        Mappers.getMapper(ProgramacionProduccionMapper.class).updateEntity(null, prog);

        var doc = new ArticuloDocTecnica();
        Mappers.getMapper(ArticuloDocTecnicaMapper.class).updateEntity(null, doc);

        var le = new LaborEjecutor();
        Mappers.getMapper(LaborEjecutorMapper.class).updateEntity(null, le);

        var ot = new OrdenTrabajo();
        Mappers.getMapper(OrdenTrabajoMapper.class).updateEntity(null, ot);

        var adm = new OtAdministracion();
        Mappers.getMapper(OtAdministracionMapper.class).updateEntity(null, adm);

        var ej = new Ejecutor();
        Mappers.getMapper(EjecutorMapper.class).updateEntity(null, ej);

        var cc = new ControlCalidad();
        Mappers.getMapper(ControlCalidadMapper.class).updateEntity(null, cc);

        var pp = new ParteProduccion();
        Mappers.getMapper(ParteProduccionMapper.class).updateEntity(null, pp);

        var lab = new Labor();
        Mappers.getMapper(LaborMapper.class).updateEntity(null, lab);

        var otTipo = new OtTipo();
        Mappers.getMapper(OtTipoMapper.class).updateEntity(null, otTipo);
    }
}
