package pe.restaurant.produccion.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.produccion.dto.request.*;
import pe.restaurant.produccion.entity.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class MapperToEntityTest {

    // ==================== OperacionMapper ====================

    @Test
    void operacion_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(OperacionMapper.class);
        var req = new OperacionRequest();
        req.setOrdenTrabajoId(1L);
        req.setNroOperacion(2);
        req.setLaborId(10L);
        req.setEjecutorId(20L);
        req.setDescripcion("Test");
        req.setCantidadProyectada(BigDecimal.valueOf(100));
        req.setCostoUnitario(BigDecimal.valueOf(25));

        Operacion result = mapper.toEntity(req);

        assertThat(result.getOrdenTrabajoId()).isEqualTo(1L);
        assertThat(result.getNroOperacion()).isEqualTo(2);
        assertThat(result.getLaborId()).isEqualTo(10L);
        assertThat(result.getEjecutorId()).isEqualTo(20L);
        assertThat(result.getDescripcion()).isEqualTo("Test");
        assertThat(result.getCantidadProyectada()).isEqualByComparingTo(BigDecimal.valueOf(100));
        assertThat(result.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(25));
        assertThat(result.getId()).isNull();
    }

    @Test
    void operacion_toEntity_cuandoNull_retornaNull() {
        assertThat(Mappers.getMapper(OperacionMapper.class).toEntity(null)).isNull();
    }

    @Test
    void operacion_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(OperacionMapper.class);
        var req = new OperacionRequest();
        req.setOrdenTrabajoId(2L);
        req.setNroOperacion(3);
        req.setDescripcion("Actualizado");

        var entity = new Operacion();
        entity.setId(1L);
        entity.setOrdenTrabajoId(1L);
        entity.setNroOperacion(1);

        mapper.updateEntity(req, entity);

        assertThat(entity.getOrdenTrabajoId()).isEqualTo(2L);
        assertThat(entity.getNroOperacion()).isEqualTo(3);
        assertThat(entity.getDescripcion()).isEqualTo("Actualizado");
        assertThat(entity.getId()).isEqualTo(1L);
    }

    // ==================== RecetaMapper ====================

    @Test
    void receta_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(RecetaMapper.class);
        var req = new RecetaRequest();
        req.setArticuloProducidoId(1L);
        req.setNroReceta("REC-001");
        req.setNombre("Receta Test");
        req.setFlagTipoReceta("P");
        req.setRendimientoEsperado(BigDecimal.valueOf(10));
        req.setCostoManoObra(BigDecimal.valueOf(50));

        Receta result = mapper.toEntity(req);

        assertThat(result.getArticuloProducidoId()).isEqualTo(1L);
        assertThat(result.getNroReceta()).isEqualTo("REC-001");
        assertThat(result.getNombre()).isEqualTo("Receta Test");
        assertThat(result.getFlagTipoReceta()).isEqualTo("P");
        assertThat(result.getRendimientoEsperado()).isEqualByComparingTo(BigDecimal.valueOf(10));
        assertThat(result.getCostoManoObra()).isEqualByComparingTo(BigDecimal.valueOf(50));
    }

    @Test
    void receta_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(RecetaMapper.class);
        var req = new RecetaRequest();
        req.setArticuloProducidoId(2L);
        req.setNroReceta("REC-002");
        req.setNombre("Actualizada");

        var entity = new Receta();
        entity.setId(1L);

        mapper.updateEntity(req, entity);

        assertThat(entity.getNroReceta()).isEqualTo("REC-002");
        assertThat(entity.getNombre()).isEqualTo("Actualizada");
    }

    // ==================== CosteoProduccionMapper ====================

    @Test
    void costeoProduccion_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(CosteoProduccionMapper.class);
        var req = new CosteoProduccionRequest();
        req.setOrdenTrabajoId(1L);
        req.setCostoTotal(BigDecimal.valueOf(500));
        req.setCostoUnitario(BigDecimal.valueOf(25));

        CosteoProduccion result = mapper.toEntity(req);

        assertThat(result.getOrdenTrabajoId()).isEqualTo(1L);
        assertThat(result.getCostoTotal()).isEqualByComparingTo(BigDecimal.valueOf(500));
        assertThat(result.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(25));
    }

    @Test
    void costeoProduccion_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(CosteoProduccionMapper.class);
        var req = new CosteoProduccionRequest();
        req.setCostoTotal(BigDecimal.valueOf(1000));

        var entity = new CosteoProduccion();
        mapper.updateEntity(req, entity);

        assertThat(entity.getCostoTotal()).isEqualByComparingTo(BigDecimal.valueOf(1000));
    }

    // ==================== ProgramacionProduccionMapper ====================

    @Test
    void programacionProduccion_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ProgramacionProduccionMapper.class);
        var req = new ProgramacionProduccionRequest();
        req.setSucursalId(1L);
        req.setRecetaId(10L);
        req.setFrecuencia("DIARIA");
        req.setFechaInicio(LocalDate.now());
        req.setCantidadPorPeriodo(BigDecimal.valueOf(50));
        req.setTurno("MANANA");

        ProgramacionProduccion result = mapper.toEntity(req);

        assertThat(result.getSucursalId()).isEqualTo(1L);
        assertThat(result.getRecetaId()).isEqualTo(10L);
        assertThat(result.getFrecuencia()).isEqualTo("DIARIA");
        assertThat(result.getFechaInicio()).isEqualTo(LocalDate.now());
        assertThat(result.getCantidadPorPeriodo()).isEqualByComparingTo(BigDecimal.valueOf(50));
        assertThat(result.getTurno()).isEqualTo("MANANA");
    }

    @Test
    void programacionProduccion_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(ProgramacionProduccionMapper.class);
        var req = new ProgramacionProduccionRequest();
        req.setFrecuencia("SEMANAL");
        var entity = new ProgramacionProduccion();
        mapper.updateEntity(req, entity);
        assertThat(entity.getFrecuencia()).isEqualTo("SEMANAL");
    }

    // ==================== ArticuloDocTecnicaMapper ====================

    @Test
    void articuloDocTecnica_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ArticuloDocTecnicaMapper.class);
        var req = new DocTecnicaRequest();
        req.setArticuloId(1L);
        req.setDocTipoId(10L);
        req.setNombreDocumento("Documento.pdf");
        req.setDocumentoExtension("pdf");

        ArticuloDocTecnica result = mapper.toEntity(req);

        assertThat(result.getArticuloId()).isEqualTo(1L);
        assertThat(result.getDocTipoId()).isEqualTo(10L);
        assertThat(result.getNombreDocumento()).isEqualTo("Documento.pdf");
        assertThat(result.getDocumentoExtension()).isEqualTo("pdf");
    }

    @Test
    void articuloDocTecnica_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(ArticuloDocTecnicaMapper.class);
        var req = new DocTecnicaRequest();
        req.setNombreDocumento("Nuevo.pdf");

        var entity = new ArticuloDocTecnica();
        mapper.updateEntity(req, entity);
        assertThat(entity.getNombreDocumento()).isEqualTo("Nuevo.pdf");
    }

    // ==================== FichaTecnicaMapper ====================

    @Test
    void fichaTecnica_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(FichaTecnicaMapper.class);
        var req = new FichaTecnicaRequest();
        req.setAlergenos("NINGUNO");
        req.setCalorias(BigDecimal.valueOf(450));
        req.setTipoDieta("GENERAL");
        req.setFotoBlob(new byte[]{1, 2, 3});
        req.setInstruccionesEmplatado("Servir frío");

        FichaTecnica result = mapper.toEntity(req);

        assertThat(result.getAlergenos()).isEqualTo("NINGUNO");
        assertThat(result.getCalorias()).isEqualByComparingTo(BigDecimal.valueOf(450));
        assertThat(result.getTipoDieta()).isEqualTo("GENERAL");
        assertThat(result.getFotoBlob()).containsExactly(1, 2, 3);
        assertThat(result.getInstruccionesEmplatado()).isEqualTo("Servir frío");
    }

    @Test
    void fichaTecnica_toEntity_sinFotoBlob_noSetea() {
        var mapper = Mappers.getMapper(FichaTecnicaMapper.class);
        var req = new FichaTecnicaRequest();
        req.setFotoBlob(null);

        FichaTecnica result = mapper.toEntity(req);

        assertThat(result.getFotoBlob()).isNull();
    }

    // ==================== LaborEjecutorMapper ====================

    @Test
    void laborEjecutor_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(LaborEjecutorMapper.class);
        var req = new LaborEjecutorRequest();
        req.setEjecutorId(1L);
        req.setCostoUnitario(BigDecimal.valueOf(100));
        req.setNroPersonas(3);

        LaborEjecutor result = mapper.toEntity(req);

        assertThat(result.getEjecutorId()).isEqualTo(1L);
        assertThat(result.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(100));
        assertThat(result.getNroPersonas()).isEqualTo(3);
    }

    @Test
    void laborEjecutor_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(LaborEjecutorMapper.class);
        var req = new LaborEjecutorRequest();
        req.setCostoUnitario(BigDecimal.valueOf(200));
        var entity = new LaborEjecutor();
        mapper.updateEntity(req, entity);
        assertThat(entity.getCostoUnitario()).isEqualByComparingTo(BigDecimal.valueOf(200));
    }

    // ==================== OrdenTrabajoMapper ====================

    @Test
    void ordenTrabajo_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(OrdenTrabajoMapper.class);
        var req = new OrdenTrabajoRequest();
        req.setSucursalId(1L);
        req.setOtTipoId(10L);
        req.setOtAdministracionId(20L);
        req.setFechaInicio(LocalDate.now());

        OrdenTrabajo result = mapper.toEntity(req);
        assertThat(result.getSucursalId()).isEqualTo(1L);
        assertThat(result.getOtTipoId()).isEqualTo(10L);
        assertThat(result.getOtAdministracionId()).isEqualTo(20L);
    }

    // ==================== OtAdministracionMapper ====================

    @Test
    void otAdministracion_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(OtAdministracionMapper.class);
        var req = new OtAdministracionRequest();
        req.setCodigo("ADM-001");
        req.setNombre("Admin Test");
        req.setFlagTipoCosto("D");

        OtAdministracion result = mapper.toEntity(req);
        assertThat(result.getCodigo()).isEqualTo("ADM-001");
        assertThat(result.getNombre()).isEqualTo("Admin Test");
        assertThat(result.getFlagTipoCosto()).isEqualTo("D");
    }

    // ==================== LaborMapper ====================

    @Test
    void labor_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(LaborMapper.class);
        var req = new LaborRequest();
        req.setCodigo("LAB-001");
        req.setNombre("Labor Test");

        Labor result = mapper.toEntity(req);
        assertThat(result.getCodigo()).isEqualTo("LAB-001");
        assertThat(result.getNombre()).isEqualTo("Labor Test");
    }

    // ==================== OtTipoMapper ====================

    @Test
    void otTipo_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(OtTipoMapper.class);
        var req = new OtTipoRequest();
        req.setCodigo("TIPO-01");
        req.setNombre("Tipo Test");

        OtTipo result = mapper.toEntity(req);
        assertThat(result.getCodigo()).isEqualTo("TIPO-01");
        assertThat(result.getNombre()).isEqualTo("Tipo Test");
    }

    // ==================== EjecutorMapper ====================

    @Test
    void ejecutor_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(EjecutorMapper.class);
        var req = new EjecutorRequest();
        req.setCodigo("EJEC-001");
        req.setNombre("Ejecutor Test");

        Ejecutor result = mapper.toEntity(req);
        assertThat(result.getCodigo()).isEqualTo("EJEC-001");
        assertThat(result.getNombre()).isEqualTo("Ejecutor Test");
    }

    // ==================== ControlCalidadMapper ====================

    @Test
    void controlCalidad_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ControlCalidadMapper.class);
        var req = new ControlCalidadRequest();
        req.setOrdenTrabajoId(1L);
        req.setResultado("APROBADO");

        ControlCalidad result = mapper.toEntity(req);
        assertThat(result.getOrdenTrabajoId()).isEqualTo(1L);
        assertThat(result.getResultado()).isEqualTo("APROBADO");
    }

    // ==================== ParteProduccionMapper ====================

    @Test
    void parteProduccion_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ParteProduccionMapper.class);
        var req = new ParteProduccionRequest();
        req.setOrdenTrabajoId(1L);
        req.setFecha(LocalDate.now());
        req.setTurnoId(10L);

        ParteProduccion result = mapper.toEntity(req);

        assertThat(result.getOrdenTrabajoId()).isEqualTo(1L);
        assertThat(result.getFecha()).isEqualTo(LocalDate.now());
        assertThat(result.getTurnoId()).isEqualTo(10L);
    }

    @Test
    void parteProduccion_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(ParteProduccionMapper.class);
        var req = new ParteProduccionRequest();
        req.setOrdenTrabajoId(2L);
        req.setTurnoId(20L);

        var entity = new ParteProduccion();
        entity.setOrdenTrabajoId(1L);

        mapper.updateEntity(req, entity);

        assertThat(entity.getOrdenTrabajoId()).isEqualTo(2L);
        assertThat(entity.getTurnoId()).isEqualTo(20L);
    }

    // ==================== ControlCalidadMapper ====================

    @Test
    void controlCalidad_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(ControlCalidadMapper.class);
        var req = new ControlCalidadRequest();
        req.setResultado("RECHAZADO");

        var entity = new ControlCalidad();
        entity.setResultado("APROBADO");

        mapper.updateEntity(req, entity);

        assertThat(entity.getResultado()).isEqualTo("RECHAZADO");
    }

    // ==================== EjecutorMapper ====================

    @Test
    void ejecutor_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(EjecutorMapper.class);
        var req = new EjecutorRequest();
        req.setNombre("Actualizado");

        var entity = new Ejecutor();
        mapper.updateEntity(req, entity);

        assertThat(entity.getNombre()).isEqualTo("Actualizado");
    }

    // ==================== OrdenTrabajoMapper ====================

    @Test
    void ordenTrabajo_updateEntity_actualizaCampos() {
        var mapper = Mappers.getMapper(OrdenTrabajoMapper.class);
        var req = new OrdenTrabajoRequest();
        req.setSucursalId(2L);

        var entity = new OrdenTrabajo();
        entity.setSucursalId(1L);

        mapper.updateEntity(req, entity);

        assertThat(entity.getSucursalId()).isEqualTo(2L);
    }

    // ==================== Mappers simples (solo toEntity, sin updateEntity) ====================

    @Test
    void operacionesDet_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(OperacionesDetMapper.class);
        var req = new OperacionDetRequest();
        req.setArticuloId(100L);
        req.setCantidadRequerida(BigDecimal.valueOf(15));

        OperacionesDet result = mapper.toEntity(req);
        assertThat(result.getArticuloId()).isEqualTo(100L);
        assertThat(result.getCantidadRequerida()).isEqualByComparingTo(BigDecimal.valueOf(15));
    }

    @Test
    void parteInsumo_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ParteInsumoMapper.class);
        var req = new ParteInsumoRequest();
        req.setArticuloId(1L);
        req.setCantidadConsumida(BigDecimal.TEN);

        ParteProduccionInsumo result = mapper.toEntity(req);
        assertThat(result.getArticuloId()).isEqualTo(1L);
        assertThat(result.getCantidadConsumida()).isEqualByComparingTo(BigDecimal.TEN);
    }

    @Test
    void parteProducido_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(ParteProducidoMapper.class);
        var req = new ParteProducidoRequest();
        req.setArticuloId(1L);
        req.setCantidadProducida(BigDecimal.valueOf(20));

        ParteProduccionProducido result = mapper.toEntity(req);
        assertThat(result.getArticuloId()).isEqualTo(1L);
        assertThat(result.getCantidadProducida()).isEqualByComparingTo(BigDecimal.valueOf(20));
    }

    @Test
    void caractDet_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(CaractDetMapper.class);
        var req = new CaractDetRequest();
        req.setCaracteristica("Color");
        req.setValor("Rojo");
        req.setUnidadMedidaId(5L);

        ArticuloDocTecnicaCaractDet result = mapper.toEntity(req);
        assertThat(result.getCaracteristica()).isEqualTo("Color");
        assertThat(result.getValor()).isEqualTo("Rojo");
        assertThat(result.getUnidadMedidaId()).isEqualTo(5L);
    }

    @Test
    void recetaLabor_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(RecetaLaborMapper.class);
        var req = new RecetaLaborRequest();
        req.setLaborId(10L);
        req.setSecuencia(1);
        req.setDescripcionPaso("Paso 1");

        RecetaLabor result = mapper.toEntity(req);
        assertThat(result.getLaborId()).isEqualTo(10L);
        assertThat(result.getSecuencia()).isEqualTo(1);
        assertThat(result.getDescripcionPaso()).isEqualTo("Paso 1");
    }

    @Test
    void recetaConsumible_toEntity_mapeaCampos() {
        var mapper = Mappers.getMapper(RecetaConsumibleMapper.class);
        var req = new RecetaConsumibleRequest();
        req.setArticuloId(100L);
        req.setCantidad(BigDecimal.valueOf(5));

        RecetaLaborConsumible result = mapper.toEntity(req);
        assertThat(result.getArticuloId()).isEqualTo(100L);
        assertThat(result.getCantidad()).isEqualByComparingTo(BigDecimal.valueOf(5));
    }

    // ==================== null safety tests ====================

    @Test
    void todosLosMappers_retornanNull_cuandoRequestNull() {
        assertThat(Mappers.getMapper(OperacionMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(RecetaMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(CosteoProduccionMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(ProgramacionProduccionMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(ArticuloDocTecnicaMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(FichaTecnicaMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(LaborEjecutorMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(OperacionesDetMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(ParteInsumoMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(ParteProducidoMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(CaractDetMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(RecetaLaborMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(RecetaConsumibleMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(OrdenTrabajoMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(OtAdministracionMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(EjecutorMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(ControlCalidadMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(LaborMapper.class).toEntity(null)).isNull();
        assertThat(Mappers.getMapper(OtTipoMapper.class).toEntity(null)).isNull();
    }
}
