package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.text.TextUtils;

import java.util.List;

import pe.com.sytco.fastsales.Activities.PedidoSession;
import pe.com.sytco.fastsales.Activities.PedidoTabFragment;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.util.LogHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Caso de uso Tomapedidos: lectura de código → busca artículo → abre {@link DialogAddPedido}.
 * <p>
 * UI reutilizable: {@link DialogCodigoScan} (también para Inventario).
 * Por ahora Tomapedidos usa {@link DialogCodigoScan.LaunchMode#AUTO_BY_HARDWARE}.
 */
public class DialogLecturaQR extends DialogAncestor {

    private final PedidoSession session;

    public DialogLecturaQR(PedidoSession value) {
        this.session = value;
        this.context = value.getHostActivity();
    }

    @Override
    public void openDialog() {
        Activity activity = session.getHostActivity();
        DialogCodigoScan.show(
                activity,
                DialogCodigoScan.LaunchMode.AUTO_BY_HARDWARE,
                DialogCodigoScan.Options.defaults(),
                new DialogCodigoScan.Listener() {
                    @Override
                    public void onCodigoLeido(String codigo) {
                        processCodigo(codigo);
                    }

                    @Override
                    public void onSolicitarCamara() {
                        openCameraScan();
                    }

                    @Override
                    public void onCancelado() {
                        // sin acción
                    }
                });
    }

    /** Procesa un código ya leído (cámara o wedge) y abre el alta de ítem. */
    public void processCodigo(String rawCodigo) {
        if (TextUtils.isEmpty(rawCodigo)) {
            MessageBox.AlertDialog(context, "Lectura de código",
                    "No se recibió ningún código. Intente nuevamente.", false);
            return;
        }
        new BuscarCodigoTask(rawCodigo.trim()).execute();
    }

    private void openCameraScan() {
        if (!(session instanceof PedidoTabFragment)) {
            MessageBox.AlertDialog(context, "Cámara",
                    "No se puede abrir la cámara en este contexto.", false);
            return;
        }
        ((PedidoTabFragment) session).startCameraScan();
    }

    private class BuscarCodigoTask extends AsyncTask<Void, Void, BeanArticulo> {
        private final String codigo;
        private String mensaje;
        private ProgressDialog pDialog;

        BuscarCodigoTask(String codigo) {
            this.codigo = codigo;
        }

        @Override
        protected void onPreExecute() {
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Buscando artículo [" + codigo + "]…");
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected BeanArticulo doInBackground(Void... voids) {
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa";
                    return null;
                }
                ImplArticulo impl = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());
                String filtro = codigo;

                if (filtro.contains("|") || filtro.contains("]")) {
                    try {
                        BeanArticulo fromQr = ImplArticulo.getInstanceArticulo(filtro);
                        if (fromQr.getCodigoCU() != null && !fromQr.getCodigoCU().isEmpty()) {
                            List<BeanArticulo> byCu = impl.getByCodigoCU(fromQr.getCodigoCU());
                            if (byCu != null && !byCu.isEmpty()) {
                                return byCu.get(0);
                            }
                        }
                        if (fromQr.getCodSKU() != null && !fromQr.getCodSKU().isEmpty()) {
                            filtro = fromQr.getCodSKU();
                        }
                    } catch (Exception ignored) {
                        // Continuar con búsqueda normal
                    }
                }

                if (impl.isCodigoCU(filtro)) {
                    List<BeanArticulo> byCu = impl.getByCodigoCU(filtro);
                    if (byCu != null && !byCu.isEmpty()) {
                        return byCu.get(0);
                    }
                }

                List<BeanArticulo> bySku = impl.getBySKU(filtro);
                if (bySku != null && !bySku.isEmpty()) {
                    return bySku.get(0);
                }

                List<BeanArticulo> byFiltro = impl.getByFiltro(filtro);
                if (byFiltro != null && !byFiltro.isEmpty()) {
                    return byFiltro.get(0);
                }

                mensaje = "No se encontró artículo para el código: " + codigo;
                return null;
            } catch (Exception ex) {
                LogHelper.e("DialogLecturaQR", "Error buscando código", ex);
                mensaje = "Error al buscar artículo: " + ex.getMessage();
                return null;
            }
        }

        @Override
        protected void onPostExecute(BeanArticulo articulo) {
            try {
                if (pDialog != null && pDialog.isShowing()) {
                    pDialog.dismiss();
                }
                if (articulo == null) {
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Artículo no encontrado",
                            mensaje != null ? mensaje : "Sin resultados", false);
                    return;
                }
                new DialogAddPedido(session).openDialog(articulo);
            } catch (Exception ex) {
                MessageBox.AlertDialog(context, "Error",
                        "No se pudo abrir el artículo: " + ex.getMessage(), false);
            }
        }
    }
}
