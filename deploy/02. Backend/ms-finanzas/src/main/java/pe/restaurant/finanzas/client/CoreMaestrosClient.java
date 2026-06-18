package pe.restaurant.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import pe.restaurant.finanzas.dto.response.CatalogoSunatDetResponse;
import pe.restaurant.finanzas.dto.response.DocTipoNumSerieResponse;
import pe.restaurant.finanzas.dto.response.DocTipoResponse;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;
import pe.restaurant.finanzas.dto.response.TipoCambioResponse;
import pe.restaurant.finanzas.dto.response.PaisResponse;
import pe.restaurant.finanzas.dto.response.SucursalResponse;
import pe.restaurant.finanzas.dto.response.TiposImpuestoResponse;
import pe.restaurant.finanzas.dto.response.UsuarioResponse;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

@FeignClient(
    name = "ms-core-maestros",
    url = "${client.ms-core-maestros.url:${api.gateway.url}}",
    path = "/api/core",
    configuration = pe.restaurant.finanzas.config.FeignConfig.class
)
public interface CoreMaestrosClient {
    
    @GetMapping("/monedas/{id}")
    ApiResponse<MonedaResponse> obtenerMonedaPorId(@PathVariable("id") Long id);
    
    @GetMapping("/sucursales/{id}")
    ApiResponse<SucursalResponse> obtenerSucursalPorId(@PathVariable("id") Long id);
    
    // Métodos para catálogos SUNAT (TAB01 = Medios de Pago, TAB10 = Tipo Documento Pago SUNAT)
    @GetMapping("/catalogos-sunat/detalles/{id}")
    ApiResponse<CatalogoSunatDetResponse> obtenerCatalogoSunatDet(@PathVariable("id") Long id);
    
    @GetMapping("/catalogos-sunat/catalogo/{catalog}/detalles")
    ApiResponse<List<CatalogoSunatDetResponse>> listarPorCatalogo(@PathVariable("catalog") String catalog);
    
    @GetMapping("/catalogos-sunat/catalogo/{catalog}/detalles/activos")
    ApiResponse<List<CatalogoSunatDetResponse>> listarActivosPorCatalogo(@PathVariable("catalog") String catalog);
    
    @GetMapping("/relaciones-comerciales/{id}")
    ApiResponse<EntidadContribuyenteResponse> obtenerEntidadPorId(@PathVariable("id") Long id);
    
    @GetMapping("/tipos-documento/{id}")
    ApiResponse<DocTipoResponse> obtenerDocTipoPorId(@PathVariable("id") Long id);
    
    @GetMapping("/plan-contable-det/{id}")
    ApiResponse<PlanContableDetResponse> obtenerPlanContableDetPorId(@PathVariable("id") Long id);
    
    @GetMapping("/tipos-documento/codigo/{codigo}/series/sucursal/{sucursalId}")
    ApiResponse<List<DocTipoNumSerieResponse>> listarSeriesPorCodigoDocYSucursal(
            @PathVariable("codigo") String codigo,
            @PathVariable("sucursalId") Long sucursalId);
    
    @GetMapping("/articulos/{id}")
    ApiResponse<Void> obtenerArticuloPorId(@PathVariable("id") Long id);

    @GetMapping("/tipos-cambio/ultimo-por-fecha")
    ApiResponse<TipoCambioResponse> obtenerUltimoTipoCambioPorFecha(
            @RequestParam("fecha") LocalDate fecha,
            @RequestParam("monedaId") Long monedaId);

    @GetMapping("/geografia/paises/{id}")
    ApiResponse<PaisResponse> obtenerPaisPorId(@PathVariable("id") Long id);

    @GetMapping("/impuestos/{id}")
    ApiResponse<TiposImpuestoResponse> obtenerImpuestoPorId(@PathVariable("id") Long id);
}
