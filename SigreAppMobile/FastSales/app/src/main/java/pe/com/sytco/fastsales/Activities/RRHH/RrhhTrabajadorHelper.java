package pe.com.sytco.fastsales.Activities.RRHH;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.widget.ImageView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.RRHH.ImplTrabajador;
import pe.com.sytco.fastsales.Dialog.DialogConfirmarAsistencia;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.util.MessageBox;

public final class RrhhTrabajadorHelper {

    public interface OnTrabajadorConfirmado {
        void onConfirmado(BeanTrabajador trabajador);
    }

    public static final class OpcionesConfirmacion {
        public String tituloDialogo;
        public String textoBotonConfirmar;
        public boolean modoSoloConsulta;

        public OpcionesConfirmacion(String tituloDialogo, String textoBotonConfirmar, boolean modoSoloConsulta) {
            this.tituloDialogo = tituloDialogo;
            this.textoBotonConfirmar = textoBotonConfirmar;
            this.modoSoloConsulta = modoSoloConsulta;
        }

        public static OpcionesConfirmacion jornal() {
            return new OpcionesConfirmacion("Confirmar trabajador - Jornal", "SELECCIONAR", false);
        }

        public static OpcionesConfirmacion destajoAgregar() {
            return new OpcionesConfirmacion("Confirmar trabajador - Destajo", "AGREGAR", false);
        }

        public static OpcionesConfirmacion consulta() {
            return new OpcionesConfirmacion("Ficha del trabajador", "CERRAR", true);
        }
    }

    private RrhhTrabajadorHelper() {
    }

    private static String valorCampo(Map<String, Object> row, String key) {
        if (row == null || key == null) {
            return "";
        }
        Object val = row.get(key);
        return val == null ? "" : String.valueOf(val).trim();
    }

    public static boolean esTrabajadorHabilitado(BeanTrabajador trabajador) {
        return trabajador != null && !trabajador.estaCesado() && !trabajador.estaInactivo();
    }

    public static String getMensajeNoHabilitado(BeanTrabajador trabajador) {
        if (trabajador == null) {
            return "Trabajador no encontrado";
        }
        if (trabajador.estaCesado()) {
            return "El trabajador está cesado y no puede registrarse";
        }
        if (trabajador.estaInactivo()) {
            return "El trabajador está inactivo y no puede registrarse";
        }
        return null;
    }

    /** Tipos de trabajador válidos para PR327 (jornal de campo). */
    public static final String TIPOS_JORNAL = "JOR,EJO";

    public static void buscarYConfirmar(Context context, String textoInicial,
            OpcionesConfirmacion opciones, final OnTrabajadorConfirmado callback) {
        buscarYConfirmar(context, textoInicial, opciones, null, null, false, callback);
    }

    /**
     * Búsqueda de trabajadores para jornal (PR327): solo JOR/EJO activos.
     * Si hay cuadrilla, prioriza integrantes de {@code tg_cuadrillas_det}.
     */
    public static void buscarYConfirmarJornal(Context context, String textoInicial,
            final String codCuadrilla, final OnTrabajadorConfirmado callback) {
        buscarYConfirmar(context, textoInicial, OpcionesConfirmacion.jornal(),
                TIPOS_JORNAL, codCuadrilla, true, callback);
    }

    public static void buscarYConfirmar(Context context, String textoInicial,
            OpcionesConfirmacion opciones, final String tipos, final String codCuadrilla,
            final boolean soloActivos, final OnTrabajadorConfirmado callback) {
        final String titulo = (codCuadrilla != null && !codCuadrilla.trim().isEmpty())
                ? "TRABAJADORES DE CUADRILLA (" + codCuadrilla.trim() + ")"
                : "BÚSQUEDA DE TRABAJADORES";
        new RrhhSearchDialog<Map<String, Object>>(context, titulo,
                new RrhhSearchDialog.DataLoader<Map<String, Object>>() {
                    @Override
                    public List<Map<String, Object>> load(String filter) throws Exception {
                        pe.com.sytco.fastsales.Controller.RRHH.ImplRrhhProduccion api =
                                new pe.com.sytco.fastsales.Controller.RRHH.ImplRrhhProduccion(
                                        ImplEmpresa.empresaDefault.getCodigo());
                        String texto = filter != null ? filter.trim() : "";
                        if (codCuadrilla != null && !codCuadrilla.trim().isEmpty()) {
                            return filtrarResumenCuadrilla(
                                    api.getCuadrillaTrabajadores(codCuadrilla.trim()), texto);
                        }
                        if (texto.isEmpty()) {
                            return api.listarTrabajadoresVista(null, null, null, null, true, 300,
                                    tipos, soloActivos);
                        }
                        return api.listarTrabajadoresVista(texto, null, null, null, false, 150,
                                tipos, soloActivos);
                    }
                },
                new RrhhSearchDialog.ItemMapper<Map<String, Object>>() {
                    @Override
                    public List<BeanItemSearch> toSearchItems(List<Map<String, Object>> items) {
                        List<BeanItemSearch> list = new ArrayList<BeanItemSearch>();
                        for (Map<String, Object> row : items) {
                            BeanItemSearch item = new BeanItemSearch();
                            item.setCadena1(valorCampo(row, "cod_trabajador"));
                            item.setCadena2(valorCampo(row, "nom_trabajador"));
                            String dni = valorCampo(row, "dni");
                            if (dni.isEmpty()) {
                                dni = valorCampo(row, "nro_doc_ident_rtps");
                            }
                            String tipo = valorCampo(row, "tipo_trabajador");
                            String extra = dni.isEmpty() ? "" : "DNI: " + dni;
                            if (!tipo.isEmpty()) {
                                extra = extra.isEmpty() ? tipo : extra + " | " + tipo;
                            }
                            item.setCadena3(extra);
                            list.add(item);
                        }
                        return list;
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<Map<String, Object>>() {
                    @Override
                    public void onSelected(Map<String, Object> item) {
                        cargarYConfirmar(context, valorCampo(item, "cod_trabajador"), opciones, callback);
                    }
                },
                (tipos != null || (codCuadrilla != null && !codCuadrilla.trim().isEmpty()))
                        ? "No hay trabajadores para el filtro indicado (JOR/EJO activos"
                        + (codCuadrilla != null && !codCuadrilla.trim().isEmpty()
                        ? " o integrantes de la cuadrilla" : "") + ")."
                        : null).show(textoInicial);
    }

    private static List<Map<String, Object>> filtrarResumenCuadrilla(
            List<pe.com.sytco.fastsales.api.rrhh.dto.TrabajadorResumenDto> trabajadores, String filtro) {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        if (trabajadores == null) {
            return list;
        }
        String f = filtro != null ? filtro.trim().toUpperCase() : "";
        for (pe.com.sytco.fastsales.api.rrhh.dto.TrabajadorResumenDto t : trabajadores) {
            String cod = t.getCodTrabajador() != null ? t.getCodTrabajador().trim() : "";
            String nom = t.getNomTrabajador() != null ? t.getNomTrabajador().trim() : "";
            String dni = t.getDni() != null ? t.getDni().trim() : "";
            if (!f.isEmpty()) {
                String hay = (cod + " " + nom + " " + dni).toUpperCase();
                if (!hay.contains(f)) {
                    continue;
                }
            }
            Map<String, Object> row = new java.util.HashMap<String, Object>();
            row.put("cod_trabajador", cod);
            row.put("nom_trabajador", nom);
            row.put("dni", dni);
            list.add(row);
        }
        return list;
    }

    public static void buscarYConfirmar(Context context, String textoInicial,
            final OnTrabajadorConfirmado callback) {
        buscarYConfirmar(context, textoInicial, OpcionesConfirmacion.jornal(), callback);
    }

    public static void cargarYConfirmar(Context context, String codTrabajador,
            OpcionesConfirmacion opciones, final OnTrabajadorConfirmado callback) {
        new AsyncTask<Void, Void, Object[]>() {
            ProgressDialog pd;

            @Override
            protected void onPreExecute() {
                pd = ProgressDialog.show(context, "Espere", "Cargando trabajador...");
            }

            @Override
            protected Object[] doInBackground(Void... voids) {
                try {
                    ImplTrabajador impl = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    BeanTrabajador bean = impl.getTrabajadorByCodigo(codTrabajador);
                    return new Object[]{bean, null};
                } catch (Exception e) {
                    return new Object[]{null, e.getMessage()};
                }
            }

            @Override
            protected void onPostExecute(Object[] data) {
                try {
                    pd.dismiss();
                } catch (Exception ignored) {
                }
                if (data[1] != null) {
                    MessageBox.AlertDialog(context, "Error", String.valueOf(data[1]), false);
                    return;
                }
                BeanTrabajador trabajador = (BeanTrabajador) data[0];
                mostrarConfirmacion(context, trabajador, opciones, callback);
            }
        }.execute();
    }

    public static void cargarYConfirmar(Context context, String codTrabajador,
            final OnTrabajadorConfirmado callback) {
        cargarYConfirmar(context, codTrabajador, OpcionesConfirmacion.jornal(), callback);
    }

    public static void mostrarFichaConsulta(Context context, String codTrabajador) {
        cargarYConfirmar(context, codTrabajador, OpcionesConfirmacion.consulta(), null);
    }

    public static void mostrarFichaConsulta(Context context, BeanTrabajador trabajador) {
        mostrarConfirmacion(context, trabajador, OpcionesConfirmacion.consulta(), null);
    }

    public static void mostrarConfirmacion(Context context, BeanTrabajador trabajador,
            OpcionesConfirmacion opciones, final OnTrabajadorConfirmado callback) {
        if (trabajador == null) {
            MessageBox.AlertDialog(context, "Error", "No se encontró el trabajador", false);
            return;
        }
        if (opciones == null) {
            opciones = OpcionesConfirmacion.jornal();
        }
        if (!opciones.modoSoloConsulta && !esTrabajadorHabilitado(trabajador)) {
            MessageBox.AlertDialog(context, "Aviso", getMensajeNoHabilitado(trabajador), false);
            return;
        }
        DialogConfirmarAsistencia dialog = new DialogConfirmarAsistencia(context, trabajador,
                opciones.tituloDialogo, opciones.textoBotonConfirmar, opciones.modoSoloConsulta,
                new DialogConfirmarAsistencia.OnConfirmListener() {
                    @Override
                    public void onConfirm(BeanTrabajador t) {
                        if (callback != null) {
                            callback.onConfirmado(t);
                        }
                    }

                    @Override
                    public void onCancel() {
                    }
                });
        dialog.show();
    }

    public static void cargarFotoEnImageView(final ImageView imageView, final String codTrabajador) {
        imageView.setImageResource(R.drawable.ic_user_placeholder);
        new AsyncTask<Void, Void, Bitmap>() {
            @Override
            protected Bitmap doInBackground(Void... voids) {
                try {
                    ImplTrabajador impl = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    BeanTrabajador bean = impl.getTrabajadorByCodigo(codTrabajador);
                    if (bean != null && bean.tieneFoto()) {
                        return BitmapFactory.decodeByteArray(bean.getFotoBlob(), 0, bean.getFotoBlob().length);
                    }
                } catch (Exception ignored) {
                }
                return null;
            }

            @Override
            protected void onPostExecute(Bitmap bitmap) {
                if (bitmap != null) {
                    imageView.setImageBitmap(bitmap);
                }
            }
        }.execute();
    }
}
