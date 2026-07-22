package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.BarcodeHardwareHelper;
import pe.com.sytco.fastsales.util.ConfirmDialog;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.ValidInputHelper;

/**
 * Componente reutilizable de lectura de código (PDA wedge + cámara).
 * Usar desde Tomapedidos, Inventario u otros módulos.
 *
 * <pre>
 * DialogCodigoScan.show(activity,
 *     DialogCodigoScan.LaunchMode.AUTO_BY_HARDWARE,
 *     DialogCodigoScan.Options.defaults(),
 *     listener);
 * </pre>
 */
public final class DialogCodigoScan {

    /**
     * Cómo abrir el flujo de lectura.
     */
    public enum LaunchMode {
        /** PDA detectado → modal wedge; si no → pregunta y abre cámara. */
        AUTO_BY_HARDWARE,
        /** Siempre muestra el modal (útil en inventario / forzar UI). */
        ALWAYS_WEDGE_DIALOG,
        /** Solo confirma y dispara cámara (sin modal wedge). */
        CAMERA_ONLY_PROMPT
    }

    public interface Listener {
        /** Código capturado por wedge / Aceptar / Enter. */
        void onCodigoLeido(String codigo);

        /** El usuario eligió escanear con cámara (el host abre el scanner). */
        void onSolicitarCamara();

        /** Canceló el flujo (opcional). */
        void onCancelado();
    }

    public static class Options {
        public String title = "Lectura de código";
        public String subtitle = "Escanee con el PDA o use la cámara";
        public String label = "Código / SKU / QR";
        public String hint = "Apunte el lector aquí…";
        public String helpText = "En PDA el código se escribe solo al escanear. Pulse Enter o Aceptar.";
        public String cameraPromptMessage =
                "No se detectó un lector de código de barras/QR incorporado.\n\n"
                        + "¿Desea abrir la cámara para escanear?";
        public boolean showCameraButton = true;

        public static Options defaults() {
            return new Options();
        }

        public Options title(String value) {
            this.title = value;
            return this;
        }

        public Options subtitle(String value) {
            this.subtitle = value;
            return this;
        }

        public Options showCameraButton(boolean value) {
            this.showCameraButton = value;
            return this;
        }
    }

    private DialogCodigoScan() {
    }

    public static void show(Activity activity, LaunchMode mode, Options options, Listener listener) {
        if (activity == null || listener == null) {
            return;
        }
        Options opts = options != null ? options : Options.defaults();
        LaunchMode launchMode = mode != null ? mode : LaunchMode.AUTO_BY_HARDWARE;

        boolean hasPda = BarcodeHardwareHelper.hasBuiltInBarcodeReader(activity);
        boolean hasCamera = activity.getPackageManager()
                .hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY);

        switch (launchMode) {
            case CAMERA_ONLY_PROMPT:
                promptCamera(activity, opts, hasCamera, listener);
                return;
            case ALWAYS_WEDGE_DIALOG:
                showWedgeDialog(activity, opts, hasCamera, listener);
                return;
            case AUTO_BY_HARDWARE:
            default:
                if (hasPda) {
                    showWedgeDialog(activity, opts, hasCamera, listener);
                } else {
                    promptCamera(activity, opts, hasCamera, listener);
                }
        }
    }

    /** Fuerza el modal wedge (mismo UI), sin evaluar hardware. */
    public static void showWedgeDialog(Activity activity, Options options, Listener listener) {
        boolean hasCamera = activity.getPackageManager()
                .hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY);
        showWedgeDialog(activity, options != null ? options : Options.defaults(), hasCamera, listener);
    }

    private static void promptCamera(final Context context, Options opts, boolean hasCamera,
                                     final Listener listener) {
        if (!hasCamera) {
            MessageBox.AlertDialog(context, opts.title,
                    "Este equipo no tiene lector incorporado ni cámara disponible.", false);
            listener.onCancelado();
            return;
        }
        ConfirmDialog.ask(context,
                opts.title,
                opts.cameraPromptMessage,
                "Abrir cámara",
                "Cancelar",
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        listener.onSolicitarCamara();
                    }
                },
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        listener.onCancelado();
                    }
                });
    }

    private static void showWedgeDialog(final Activity activity, Options opts, boolean hasCamera,
                                        final Listener listener) {
        final AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        final View root = LayoutInflater.from(activity).inflate(R.layout.dialog_codigo_scan, null);

        final TextView tvTitle = root.findViewById(R.id.tvScanTitle);
        final TextView tvSubtitle = root.findViewById(R.id.tvScanSubtitle);
        final TextView tvLabel = root.findViewById(R.id.tvScanLabel);
        final TextView tvHint = root.findViewById(R.id.tvScanHint);
        final EditText etCodigo = root.findViewById(R.id.etCodigo);
        final Button btnCamara = root.findViewById(R.id.btnCamara);
        final Button btnCancelar = root.findViewById(R.id.btnCancelar);
        final Button btnAceptar = root.findViewById(R.id.btnAceptar);

        tvTitle.setText(opts.title);
        tvSubtitle.setText(opts.subtitle);
        tvLabel.setText(opts.label);
        tvHint.setText(opts.helpText);
        etCodigo.setHint(opts.hint);

        ValidInputHelper.bindEditText(etCodigo, ValidInputHelper.notBlank());

        boolean showCam = opts.showCameraButton && hasCamera;
        btnCamara.setVisibility(showCam ? View.VISIBLE : View.GONE);

        builder.setView(root);
        builder.setCancelable(false);
        final AlertDialog dialog = builder.create();

        if (dialog.getWindow() != null) {
            dialog.getWindow().setSoftInputMode(
                    WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }

        final Runnable accept = new Runnable() {
            @Override
            public void run() {
                String codigo = etCodigo.getText() != null
                        ? etCodigo.getText().toString().trim() : "";
                if (TextUtils.isEmpty(codigo)) {
                    MessageBox.AlertDialog(activity, opts.title,
                            "Ingrese o escanee un código.", false);
                    etCodigo.requestFocus();
                    return;
                }
                dialog.dismiss();
                listener.onCodigoLeido(codigo);
            }
        };

        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
                listener.onCancelado();
            }
        });
        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                accept.run();
            }
        });
        btnCamara.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
                listener.onSolicitarCamara();
            }
        });
        etCodigo.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean enter = event != null
                        && event.getAction() == KeyEvent.ACTION_DOWN
                        && event.getKeyCode() == KeyEvent.KEYCODE_ENTER;
                if (actionId == EditorInfo.IME_ACTION_DONE
                        || actionId == EditorInfo.IME_ACTION_SEARCH
                        || enter) {
                    accept.run();
                    return true;
                }
                return false;
            }
        });
        etCodigo.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View view, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_DOWN
                        && keyCode == KeyEvent.KEYCODE_ENTER) {
                    accept.run();
                    return true;
                }
                return false;
            }
        });

        dialog.setOnShowListener(new android.content.DialogInterface.OnShowListener() {
            @Override
            public void onShow(android.content.DialogInterface d) {
                etCodigo.requestFocus();
            }
        });
        dialog.show();
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (etCodigo != null) {
                    etCodigo.requestFocus();
                }
            }
        }, 200);
    }
}
