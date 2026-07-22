package pe.com.sytco.fastsales.Activities.RRHH;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.api.rrhh.dto.ClienteDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaLaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.LaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OperacionDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OtAdmDto;
import pe.com.sytco.fastsales.api.rrhh.dto.TarifarioDto;
import pe.com.sytco.fastsales.beans.BeanItemSearch;

public final class RrhhItemSearch {

    private RrhhItemSearch() {
    }

    public static List<BeanItemSearch> fromClientes(List<ClienteDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (ClienteDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            String cod = dto.getCodCliente() != null ? dto.getCodCliente().trim() : "";
            String nom = dto.getNomCliente() != null ? dto.getNomCliente().trim() : "";
            item.setCadena1(cod);
            item.setCadena2(nom);
            item.setCadena3(dto.getRuc() != null && !dto.getRuc().isEmpty()
                    ? "RUC: " + dto.getRuc() : "");
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromCuadrillas(List<CuadrillaDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (CuadrillaDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getCodCuadrilla());
            item.setCadena2(dto.getDescCuadrilla());
            item.setCadena3("Turno: " + dto.getTurno() + " | OT: " + dto.getOtAdm());
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromLaboresCuadrilla(List<CuadrillaLaborDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (CuadrillaLaborDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getCodEspecie() + " / " + dto.getCodPresentacion());
            item.setCadena2(dto.getCodTarea());
            item.setCadena3("Tarifa: " + (dto.getTarifa() != null ? dto.getTarifa() : 0));
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromTarifario(List<TarifarioDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (TarifarioDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getCodEspecie() + " / " + dto.getCodPresentacion());
            item.setCadena2(dto.getCodTarea());
            item.setCadena3("Tarifa: " + (dto.getTarifa() != null ? dto.getTarifa() : 0)
                    + (dto.getUnd() != null ? " " + dto.getUnd() : ""));
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromLabores(List<LaborDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (LaborDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getCodLabor());
            item.setCadena2(dto.getDescLabor());
            item.setCadena3("");
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromOtAdm(List<OtAdmDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (OtAdmDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getOtAdm());
            item.setCadena2(dto.getDescripcion());
            item.setCadena3("");
            items.add(item);
        }
        return items;
    }

    public static List<BeanItemSearch> fromOperaciones(List<OperacionDto> list) {
        List<BeanItemSearch> items = new ArrayList<BeanItemSearch>();
        if (list == null) {
            return items;
        }
        for (OperacionDto dto : list) {
            BeanItemSearch item = new BeanItemSearch();
            item.setCadena1(dto.getNroOrden() != null ? dto.getNroOrden() : "");
            item.setCadena2(dto.getOperSec());
            String desc = dto.getDescOperacion() != null ? dto.getDescOperacion() : "";
            if (dto.getTituloOt() != null && !dto.getTituloOt().isEmpty()) {
                desc = dto.getTituloOt() + " | " + desc;
            }
            item.setCadena3(desc);
            items.add(item);
        }
        return items;
    }
}
