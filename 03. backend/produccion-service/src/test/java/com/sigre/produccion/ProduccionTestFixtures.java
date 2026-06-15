package com.sigre.produccion;

import com.sigre.produccion.client.dto.ArticuloResponse;
import com.sigre.produccion.dto.request.OtTipoRequest;
import com.sigre.produccion.entity.ControlCalidad;
import com.sigre.produccion.entity.Ejecutor;
import com.sigre.produccion.entity.FichaTecnica;
import com.sigre.produccion.entity.Operacion;
import com.sigre.produccion.entity.OperacionesDet;
import com.sigre.produccion.entity.ParteProduccion;
import com.sigre.produccion.entity.OtAdministracion;
import com.sigre.produccion.entity.OtTipo;
import com.sigre.produccion.entity.OrdenTrabajo;
import com.sigre.produccion.entity.ProgramacionProduccion;
import com.sigre.produccion.entity.Receta;
import com.sigre.produccion.entity.RecetaLabor;

import java.math.BigDecimal;
import java.time.LocalDate;

import java.util.concurrent.atomic.AtomicLong;

public final class ProduccionTestFixtures {

    private ProduccionTestFixtures() {
        throw new UnsupportedOperationException("Clase de fixtures — no instanciable");
    }

    private static final AtomicLong contador = new AtomicLong(1);

    private static String sufijoUnico() {
        return String.valueOf(contador.getAndIncrement());
    }

    // ==================== ENTIDADES ====================

    public static OtTipo otTipo(Long id) {
        return otTipo(id, "1");
    }

    public static OtTipo otTipo(Long id, String flagEstado) {
        OtTipo entity = new OtTipo();
        entity.setId(id);
        entity.setCodigo("PROD-TEST-" + sufijoUnico());
        entity.setNombre("Tipo Test " + id);
        entity.setFlagEstado(flagEstado);
        return entity;
    }

    public static OtAdministracion otAdministracion(Long id) {
        return otAdministracion(id, "1");
    }

    public static OtAdministracion otAdministracion(Long id, String flagEstado) {
        OtAdministracion entity = new OtAdministracion();
        entity.setId(id);
        entity.setCodigo("ADMIN-TEST-" + sufijoUnico());
        entity.setNombre("Admin Test " + id);
        entity.setFlagEstado(flagEstado);
        entity.setFlagTipoCosto("D");
        return entity;
    }

    public static Ejecutor ejecutor(Long id) {
        return ejecutor(id, "1");
    }

    public static Ejecutor ejecutor(Long id, String flagEstado) {
        Ejecutor entity = new Ejecutor();
        entity.setId(id);
        entity.setCodigo("EJEC-TEST-" + sufijoUnico());
        entity.setNombre("Ejecutor Test " + id);
        entity.setFlagEstado(flagEstado);
        entity.setFlagExterno("0");
        return entity;
    }

    public static ControlCalidad controlCalidad(Long id) {
        ControlCalidad entity = new ControlCalidad();
        entity.setId(id);
        entity.setOrdenTrabajoId(1L);
        entity.setInspectorId(1L);
        entity.setFecha(LocalDate.now());
        entity.setResultado("APROBADO");
        entity.setObservaciones("Control de prueba");
        return entity;
    }

    public static Receta receta(Long id) {
        return receta(id, "1");
    }

    public static Receta receta(Long id, String flagEstado) {
        Receta entity = new Receta();
        entity.setId(id);
        entity.setArticuloProducidoId(1L);
        entity.setNroReceta("REC-TEST-" + sufijoUnico());
        entity.setNombre("Receta Test " + id);
        entity.setVersion(1);
        entity.setFlagTipoReceta("P");
        entity.setFlagEstado(flagEstado);
        entity.setCostoManoObra(BigDecimal.TEN);
        entity.setCostoIndirecto(BigDecimal.valueOf(5));
        return entity;
    }

    public static RecetaLabor recetaLabor(Long id) {
        RecetaLabor entity = new RecetaLabor();
        entity.setId(id);
        entity.setRecetaId(1L);
        entity.setLaborId(1L);
        entity.setSecuencia(1);
        entity.setDescripcionPaso("Paso de prueba");
        return entity;
    }

    public static FichaTecnica fichaTecnica(Long id) {
        FichaTecnica entity = new FichaTecnica();
        entity.setId(id);
        entity.setRecetaId(1L);
        entity.setAlergenos("NINGUNO");
        entity.setCalorias(BigDecimal.valueOf(450));
        entity.setTipoDieta("GENERAL");
        return entity;
    }

    public static OrdenTrabajo ordenTrabajo(Long id) {
        return ordenTrabajo(id, "1");
    }

    public static OrdenTrabajo ordenTrabajo(Long id, String flagEstado) {
        OrdenTrabajo entity = new OrdenTrabajo();
        entity.setId(id);
        entity.setSucursalId(1L);
        entity.setOtTipoId(1L);
        entity.setOtAdministracionId(1L);
        entity.setCodigo("OT-" + java.time.Year.now().getValue() + "-" + sufijoUnico());
        entity.setFechaInicio(LocalDate.now());
        entity.setFechaFin(LocalDate.now().plusDays(30));
        entity.setFlagEstado(flagEstado);
        return entity;
    }

    public static ParteProduccion parteProduccion(Long id) {
        return parteProduccion(id, "1");
    }

    public static ParteProduccion parteProduccion(Long id, String flagEstado) {
        ParteProduccion entity = new ParteProduccion();
        entity.setId(id);
        entity.setOrdenTrabajoId(1L);
        entity.setFecha(LocalDate.now());
        entity.setFlagEstado(flagEstado);
        return entity;
    }

    public static Operacion operacion(Long id) {
        return operacion(id, "1");
    }

    public static Operacion operacion(Long id, String flagEstado) {
        Operacion entity = new Operacion();
        entity.setId(id);
        entity.setOrdenTrabajoId(1L);
        entity.setNroOperacion(1);
        entity.setDescripcion("Operacion Test");
        entity.setFlagEstado(flagEstado);
        return entity;
    }

    public static OperacionesDet operacionesDet(Long id) {
        OperacionesDet entity = new OperacionesDet();
        entity.setId(id);
        entity.setOperacionId(1L);
        entity.setArticuloId(1L);
        entity.setCantidadRequerida(BigDecimal.TEN);
        return entity;
    }

    public static ProgramacionProduccion programacionProduccion(Long id) {
        return programacionProduccion(id, "1");
    }

    public static ProgramacionProduccion programacionProduccion(Long id, String flagEstado) {
        ProgramacionProduccion entity = new ProgramacionProduccion();
        entity.setId(id);
        entity.setSucursalId(1L);
        entity.setRecetaId(1L);
        entity.setFrecuencia("DIARIA");
        entity.setFechaInicio(LocalDate.now());
        entity.setCantidadPorPeriodo(BigDecimal.valueOf(50));
        entity.setTurno("MANANA");
        entity.setFlagEstado(flagEstado);
        return entity;
    }

    public static com.sigre.produccion.dto.response.CosteoProduccionResponse costeoProduccionResponse() {
        return com.sigre.produccion.dto.response.CosteoProduccionResponse.builder().id(1L).build();
    }

    public static ArticuloResponse articuloResponse() {
        return ArticuloResponse.builder()
                .id(1L).codigo("ART-TEST").nombre("Articulo Test")
                .flagEstado("1").build();
    }

    // ==================== REQUESTS ====================

    public static OtTipoRequest otTipoRequest() {
        OtTipoRequest req = new OtTipoRequest();
        req.setCodigo("PROD-TEST-REQ-" + sufijoUnico());
        req.setNombre("Tipo Request Test");
        return req;
    }
}
