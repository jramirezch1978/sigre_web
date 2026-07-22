package pe.com.sytco.fastsales.Controller;

import java.util.List;

import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;

public class ImplListadoCajas {
    private static List<BeanCaja> _listadoCajas;

    public static void setListadoCajas(List<BeanCaja> value){
        ImplListadoCajas._listadoCajas = value;
    }

    public static List<BeanCaja> getListadoCajas(){
        return ImplListadoCajas._listadoCajas;
    }

    public static void deleteCaja(BeanCaja item){
        BeanCaja cajaSeleted = null;
        for (BeanCaja bean: ImplListadoCajas._listadoCajas) {
            if (bean.getCodigoCU().toUpperCase().equals(item.getCodigoCU().toUpperCase())){
                cajaSeleted = bean;
                break;
            }
        }

        if (cajaSeleted != null)
            ImplListadoCajas._listadoCajas.remove(cajaSeleted);
    }

    public static Double getCantidad() {
        Double ldcCantidad = 0.0;

        for (BeanCaja bean: ImplListadoCajas._listadoCajas) {
            ldcCantidad += bean.getSaldoUnd();
        }

        return ldcCantidad;
    }

    public static Double getCantidadUnd2() {
        Double ldcCantidad = 0.0;

        for (BeanCaja bean: ImplListadoCajas._listadoCajas) {
            ldcCantidad += bean.getSaldoUnd2();
        }

        return ldcCantidad;
    }
}
