package pe.com.hermes.appmobile.data.menu;

import java.util.ArrayList;
import java.util.List;

/** Nodo de menú (módulo / sección / opción) — mismo árbol que el ERP web. */
public class MenuNodo {
    public enum Tipo { MODULO, SECCION, OPCION }

    public final Tipo tipo;
    public final long id;
    public final String codigo;
    public final String nombre;
    public final String pathUrl;
    public final List<MenuNodo> hijos = new ArrayList<>();
    public boolean expandido;

    public MenuNodo(Tipo tipo, long id, String codigo, String nombre, String pathUrl) {
        this.tipo = tipo;
        this.id = id;
        this.codigo = codigo;
        this.nombre = nombre;
        this.pathUrl = pathUrl;
    }

    public boolean esHoja() {
        return hijos.isEmpty();
    }
}
