package pe.com.hermes.appmobile.ui.servidor;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputLayout;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.databinding.ActivityServidorListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.ConnectivityChecker;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.common.ui.MessageBox;
import pe.com.hermes.common.ui.ValidInputHelper;
import pe.com.hermes.common.util.AsyncRunner;

/**
 * Listado de servidores remotos — equivalente a ServerRemoteActivity de FastSales:
 * la lista se edita EN MEMORIA (añadir/editar/quitar) y solo se persiste al archivo
 * de configuración cuando el usuario toca "Guardar" (mismo patrón que confirmSave()).
 */
public class ServidorListActivity extends AppCompatActivity {

    private ActivityServidorListBinding binding;
    private SimpleListAdapter adapter;
    private final List<ServerProfile> servidores = new ArrayList<>();
    private boolean hayCambios = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityServidorListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        servidores.addAll(AppUtils.app(this).getConfig().listarServidores());

        adapter = new SimpleListAdapter(item -> editarPorIndice((int) item.id));
        binding.recyclerView.setAdapter(adapter);
        refrescarLista();

        binding.btnAdd.setOnClickListener(v -> abrirDialogoServidor(null));
        binding.btnSave.setOnClickListener(v -> confirmarGuardado());
        binding.btnCerrar.setOnClickListener(v -> confirmarCierre());

        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                confirmarCierre();
            }
        });
    }

    private void refrescarLista() {
        List<SimpleItem> items = new ArrayList<>();
        for (int i = 0; i < servidores.size(); i++) {
            ServerProfile s = servidores.get(i);
            String marca = s.isFlagDefault() ? " ★ Por defecto" : "";
            items.add(new SimpleItem(i, s.getNombre(), s.getProtocolo() + "://" + s.getHostIp() + ":" + s.getPort() + marca));
        }
        adapter.actualizar(items);
        binding.tvNroRegistros.setText(servidores.size() + " servidor(es)");
    }

    private void editarPorIndice(int indice) {
        if (indice < 0 || indice >= servidores.size()) return;
        abrirDialogoServidor(indice);
    }

    /** null = alta nueva; no-null = edicion del indice indicado. */
    private void abrirDialogoServidor(Integer indiceEditar) {
        View view = getLayoutInflater().inflate(R.layout.dialog_add_server, null);

        EditText etNombre = view.findViewById(R.id.etNombre);
        EditText etHostIp = view.findViewById(R.id.etHostIp);
        EditText etPort = view.findViewById(R.id.etPort);
        Spinner spProtocolo = view.findViewById(R.id.spProtocolo);
        CheckBox chkFlagDefault = view.findViewById(R.id.chkFlagDefault);
        TextInputLayout tilNombre = view.findViewById(R.id.tilNombre);
        TextInputLayout tilHostIp = view.findViewById(R.id.tilHostIp);
        TextInputLayout tilPort = view.findViewById(R.id.tilPort);
        Button btnProbarConexion = view.findViewById(R.id.btnProbarConexion);
        ProgressBar progressProbarConexion = view.findViewById(R.id.progressProbarConexion);
        TextView tvResultadoConexion = view.findViewById(R.id.tvResultadoConexion);

        List<String> protocolos = Arrays.asList("http", "https");
        ArrayAdapter<String> protocoloAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, protocolos);
        protocoloAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spProtocolo.setAdapter(protocoloAdapter);

        ServerProfile existente = indiceEditar != null && indiceEditar >= 0 && indiceEditar < servidores.size()
                ? servidores.get(indiceEditar) : null;
        if (existente != null) {
            etNombre.setText(existente.getNombre());
            etHostIp.setText(existente.getHostIp());
            etPort.setText(existente.getPort());
            int posicion = protocolos.indexOf(existente.getProtocolo());
            spProtocolo.setSelection(Math.max(posicion, 0));
            chkFlagDefault.setChecked(existente.isFlagDefault());
        }

        // Check verde en campos del diálogo (FastSales ImplServerRemote + ValidInputHelper.bindTree)
        ValidInputHelper.bindTree(view);

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .setCancelable(false)
                .create();

        btnProbarConexion.setOnClickListener(v -> {
            String hostIp = etHostIp.getText() != null ? etHostIp.getText().toString().trim() : "";
            String port = etPort.getText() != null ? etPort.getText().toString().trim() : "";

            if (hostIp.isEmpty() || port.isEmpty()) {
                tvResultadoConexion.setTextColor(Color.parseColor("#C62828"));
                tvResultadoConexion.setText("Ingrese host y puerto antes de probar");
                return;
            }

            progressProbarConexion.setVisibility(View.VISIBLE);
            tvResultadoConexion.setText("");
            btnProbarConexion.setEnabled(false);

            AsyncRunner.ejecutar(
                    () -> ConnectivityChecker.probar(hostIp, port),
                    new AsyncRunner.OnResultado<ConnectivityChecker.Resultado>() {
                        @Override
                        public void onExito(ConnectivityChecker.Resultado resultado) {
                            progressProbarConexion.setVisibility(View.GONE);
                            btnProbarConexion.setEnabled(true);
                            if (resultado.conectado) {
                                tvResultadoConexion.setTextColor(Color.parseColor("#2E7D32"));
                                tvResultadoConexion.setText("✓ Conectado (" + resultado.latenciaMs + " ms)");
                            } else {
                                tvResultadoConexion.setTextColor(Color.parseColor("#C62828"));
                                tvResultadoConexion.setText("✗ Sin conexión");
                            }
                        }

                        @Override
                        public void onError(Exception error) {
                            progressProbarConexion.setVisibility(View.GONE);
                            btnProbarConexion.setEnabled(true);
                            tvResultadoConexion.setTextColor(Color.parseColor("#C62828"));
                            tvResultadoConexion.setText("✗ Sin conexión");
                        }
                    }
            );
        });

        view.<Button>findViewById(R.id.btnCancelar).setOnClickListener(v -> dialog.dismiss());

        view.<Button>findViewById(R.id.btnAceptar).setOnClickListener(v -> {
            String nombre = etNombre.getText() != null ? etNombre.getText().toString().trim() : "";
            String hostIp = etHostIp.getText() != null ? etHostIp.getText().toString().trim() : "";
            String port = etPort.getText() != null ? etPort.getText().toString().trim() : "";

            boolean valido = true;
            if (nombre.isEmpty()) { tilNombre.setError("Nombre de servidor inválido"); valido = false; } else tilNombre.setError(null);
            if (hostIp.isEmpty()) { tilHostIp.setError("Host o IP inválido"); valido = false; } else tilHostIp.setError(null);
            if (port.isEmpty()) { tilPort.setError("Puerto inválido"); valido = false; } else tilPort.setError(null);
            if (!valido) return;

            boolean nombreDuplicado = false;
            for (int i = 0; i < servidores.size(); i++) {
                if ((indiceEditar == null || i != indiceEditar) && servidores.get(i).getNombre().equalsIgnoreCase(nombre)) {
                    nombreDuplicado = true;
                    break;
                }
            }
            if (nombreDuplicado) {
                tilNombre.setError("Ya existe un servidor con ese nombre");
                return;
            }

            ServerProfile nuevo = new ServerProfile(nombre, hostIp, port, (String) spProtocolo.getSelectedItem(), chkFlagDefault.isChecked());

            if (nuevo.isFlagDefault()) {
                for (ServerProfile s : servidores) s.setFlagDefault(false);
            }

            if (indiceEditar != null) {
                servidores.set(indiceEditar, nuevo);
            } else {
                servidores.add(nuevo);
            }

            hayCambios = true;
            refrescarLista();
            dialog.dismiss();
        });

        dialog.show();
    }

    private void confirmarGuardado() {
        String mensaje;
        if (servidores.isEmpty()) {
            mensaje = "No hay ningún servidor registrado. ¿Desea guardar de todas maneras?";
        } else if (servidores.stream().noneMatch(ServerProfile::isFlagDefault)) {
            mensaje = "No ha marcado ningún servidor como predeterminado. ¿Desea guardar de todas maneras?";
        } else {
            mensaje = "¿Desea guardar los cambios realizados?";
        }
        ConfirmDialog.mostrar(this, "Confirmación de grabación", mensaje, false, () -> {
            AppUtils.app(this).getConfig().guardarServidores(servidores);
            hayCambios = false;
            MessageBox.exito(this, "Servidores guardados correctamente.");
        });
    }

    private void confirmarCierre() {
        if (!hayCambios) {
            cerrar();
            return;
        }
        ConfirmDialog.mostrar(this, "Confirmación", "Hay modificaciones pendientes de grabar, ¿desea salir sin guardar?",
                "Salir", "Cancelar", false, this::cerrar, null);
    }

    private void cerrar() {
        startActivity(new Intent(this, LoginActivity.class));
        finish();
    }
}
