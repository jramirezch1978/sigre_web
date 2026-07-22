package pe.com.sytco.fastsales.Activities.RRHH;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.RRHH.ImplRrhhProduccion;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaDto;
import pe.com.sytco.fastsales.api.rrhh.dto.JornalCampoRequest;
import pe.com.sytco.fastsales.api.rrhh.dto.JornalCampoResultDto;
import pe.com.sytco.fastsales.api.rrhh.dto.LaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OperacionDto;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.util.MessageBox;

/**
 * Parte de jornaleros de campo (PR327). Un trabajador por registro en PD_JORNAL_CAMPO.
 */
public class ParteJornalCampoActivity extends AppCompatActivity {

    private EditText etFecha, etFiltroCuadrilla, etFiltroEspecie, etFiltroPresentacion, etFiltroTarea;
    private EditText etCuadrilla, etLabor, etOtAdm, etOperSec;
    private EditText etHoraInicio, etHoraFin;
    private EditText etHrsNormales, etHrsExtra25, etHrsExtra35, etHrsExtra100;
    private EditText etHrsNocNormal, etHrsNocExtra25, etHrsNocExtra35, etBuscarTrabajador;
    private TextView tvTrabajadorCodigo, tvTrabajadorSeleccionado, tvTrabajadorDni, tvImportes;
    private TextView tvInfoCuadrilla;
    private ImageView ivFotoTrabajadorJornal;
    private View cardTrabajadorJornal;
    private Button btnBuscarCuadrilla, btnBuscarLabor, btnBuscarOper, btnBuscarTrabajador;
    private Button btnCalcular, btnGuardar;

    private ImplRrhhProduccion api;
    private CuadrillaDto cuadrillaSeleccionada;
    private BeanTrabajador trabajadorSeleccionado;
    private LaborDto laborSeleccionada;
    private OperacionDto operacionSeleccionada;
    private Integer nroItemGuardado;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_jornal_campo);

        RrhhUiHelper.setupScreen(this);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Jornales de Campo");

        try {
            api = new ImplRrhhProduccion(ImplEmpresa.empresaDefault.getCodigo());
        } catch (Exception e) {
            MessageBox.AlertDialog(this, "Error", e.getMessage(), false);
            finish();
            return;
        }
        initControls();
        String hoy = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(new Date());
        etFecha.setText(hoy);
        aplicarHorasPorDefecto(hoy);
        etHrsNormales.setText("8");
        etHrsExtra25.setText("0");
        etHrsExtra35.setText("0");
        etHrsExtra100.setText("0");
        etHrsNocNormal.setText("0");
        etHrsNocExtra25.setText("0");
        etHrsNocExtra35.setText("0");
        RrhhUiHelper.attachDatePicker(this, etFecha, null);
        etFecha.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) { }
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) { }
            @Override
            public void afterTextChanged(Editable s) {
                String fecha = s != null ? s.toString().trim() : "";
                if (fecha.length() == 10) {
                    sincronizarHorasConFecha(fecha);
                }
            }
        });
        assignEvents();
    }

    private void initControls() {
        etFecha = findViewById(R.id.etFecha);
        etFiltroCuadrilla = findViewById(R.id.etFiltroCuadrilla);
        etFiltroEspecie = findViewById(R.id.etFiltroEspecie);
        etFiltroPresentacion = findViewById(R.id.etFiltroPresentacion);
        etFiltroTarea = findViewById(R.id.etFiltroTarea);
        etCuadrilla = findViewById(R.id.etCuadrilla);
        etLabor = findViewById(R.id.etLabor);
        etOtAdm = findViewById(R.id.etOtAdm);
        etOperSec = findViewById(R.id.etOperSec);
        etHoraInicio = findViewById(R.id.etHoraInicio);
        etHoraFin = findViewById(R.id.etHoraFin);
        etHrsNormales = findViewById(R.id.etHrsNormales);
        etHrsExtra25 = findViewById(R.id.etHrsExtra25);
        etHrsExtra35 = findViewById(R.id.etHrsExtra35);
        etHrsExtra100 = findViewById(R.id.etHrsExtra100);
        etHrsNocNormal = findViewById(R.id.etHrsNocNormal);
        etHrsNocExtra25 = findViewById(R.id.etHrsNocExtra25);
        etHrsNocExtra35 = findViewById(R.id.etHrsNocExtra35);
        etBuscarTrabajador = findViewById(R.id.etBuscarTrabajador);
        tvTrabajadorCodigo = findViewById(R.id.tvTrabajadorCodigo);
        tvTrabajadorSeleccionado = findViewById(R.id.tvTrabajadorSeleccionado);
        tvTrabajadorDni = findViewById(R.id.tvTrabajadorDni);
        ivFotoTrabajadorJornal = findViewById(R.id.ivFotoTrabajadorJornal);
        cardTrabajadorJornal = findViewById(R.id.cardTrabajadorJornal);
        tvImportes = findViewById(R.id.tvImportes);
        tvInfoCuadrilla = findViewById(R.id.tvInfoCuadrilla);
        btnBuscarCuadrilla = findViewById(R.id.btnBuscarCuadrilla);
        btnBuscarLabor = findViewById(R.id.btnBuscarLabor);
        btnBuscarOper = findViewById(R.id.btnBuscarOper);
        btnBuscarTrabajador = findViewById(R.id.btnBuscarTrabajador);
        btnCalcular = findViewById(R.id.btnCalcular);
        btnGuardar = findViewById(R.id.btnGuardar);
    }

    private void assignEvents() {
        btnBuscarCuadrilla.setOnClickListener(v -> buscarCuadrilla());
        btnBuscarLabor.setOnClickListener(v -> buscarLabor());
        btnBuscarOper.setOnClickListener(v -> buscarOperacion());
        btnBuscarTrabajador.setOnClickListener(v -> buscarTrabajador());
        btnCalcular.setOnClickListener(v -> ejecutarCalculo(false));
        btnGuardar.setOnClickListener(v -> guardarJornal());

        View.OnClickListener reabrirFicha = v -> reabrirFichaTrabajador();
        if (cardTrabajadorJornal != null) {
            cardTrabajadorJornal.setOnClickListener(reabrirFicha);
        }
        ivFotoTrabajadorJornal.setOnClickListener(reabrirFicha);
    }

    private void aplicarHorasPorDefecto(String fecha) {
        etHoraInicio.setText(fecha + " 08:00");
        etHoraFin.setText(fecha + " 17:00");
    }

    private void sincronizarHorasConFecha(String fecha) {
        etHoraInicio.setText(preservarHora(etHoraInicio.getText().toString(), fecha, "08:00"));
        etHoraFin.setText(preservarHora(etHoraFin.getText().toString(), fecha, "17:00"));
    }

    private String preservarHora(String actual, String fecha, String horaDefault) {
        String hora = horaDefault;
        if (actual != null && actual.length() >= 16 && actual.charAt(10) == ' ') {
            hora = actual.substring(11).trim();
            if (hora.isEmpty()) {
                hora = horaDefault;
            }
        }
        return fecha + " " + hora;
    }

    private void reabrirFichaTrabajador() {
        if (trabajadorSeleccionado == null) {
            buscarTrabajador();
            return;
        }
        RrhhTrabajadorHelper.mostrarConfirmacion(this, trabajadorSeleccionado,
                RrhhTrabajadorHelper.OpcionesConfirmacion.jornal(),
                new RrhhTrabajadorHelper.OnTrabajadorConfirmado() {
                    @Override
                    public void onConfirmado(BeanTrabajador trabajador) {
                        trabajadorSeleccionado = trabajador;
                        nroItemGuardado = null;
                        mostrarTrabajador(trabajador);
                    }
                });
    }

    private String getUsuario() {
        GlobalClass app = (GlobalClass) getApplication();
        if (app.getUserLogin() != null && app.getUserLogin().getUsuario() != null) {
            return app.getUserLogin().getUsuario().trim();
        }
        return "";
    }

    private String filtroEspecie() {
        return etFiltroEspecie.getText().toString().trim();
    }

    private String filtroPresentacion() {
        return etFiltroPresentacion.getText().toString().trim();
    }

    private String filtroTarea() {
        return etFiltroTarea.getText().toString().trim();
    }

    private JornalCampoRequest buildRequest(boolean calcular) {
        JornalCampoRequest req = new JornalCampoRequest();
        req.setEmpresa(ImplEmpresa.empresaDefault.getCodigo());
        req.setUsuario(getUsuario());
        req.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
        req.setFecha(etFecha.getText().toString().trim());
        req.setCodTrabajador(trabajadorSeleccionado != null ? trabajadorSeleccionado.getCodTrabajador() : "");
        req.setCodCuadrilla(cuadrillaSeleccionada != null ? cuadrillaSeleccionada.getCodCuadrilla() : "");
        req.setCodLabor(laborSeleccionada != null ? laborSeleccionada.getCodLabor() : etLabor.getText().toString().trim());
        req.setOtAdm(etOtAdm.getText().toString().trim());
        req.setOperSec(operacionSeleccionada != null ? operacionSeleccionada.getOperSec() : etOperSec.getText().toString().trim());
        req.setHoraInicio(etHoraInicio.getText().toString().trim());
        req.setHoraFin(etHoraFin.getText().toString().trim());
        req.setHrsNormales(parseDouble(etHrsNormales.getText().toString()));
        req.setHrsExtras25(parseDouble(etHrsExtra25.getText().toString()));
        req.setHrsExtras35(parseDouble(etHrsExtra35.getText().toString()));
        req.setHrsExtras100(parseDouble(etHrsExtra100.getText().toString()));
        req.setHrsNocNormal(parseDouble(etHrsNocNormal.getText().toString()));
        req.setHrsNocExtras25(parseDouble(etHrsNocExtra25.getText().toString()));
        req.setHrsNocExtras35(parseDouble(etHrsNocExtra35.getText().toString()));
        req.setCalcularHoras(calcular);
        req.setModoEdicion(nroItemGuardado != null);
        req.setNroItem(nroItemGuardado);
        return req;
    }

    private String mensajeSinCuadrillas(String filtroTexto) {
        StringBuilder sb = new StringBuilder();
        sb.append("No hay cuadrillas disponibles");
        String usuario = getUsuario();
        if (usuario.isEmpty()) {
            sb.append(" (no se identificó el usuario de sesión)");
        } else {
            sb.append(" para el usuario \"").append(usuario).append("\"");
            sb.append(" según su acceso en OT administrativa (ot_adm_usuario)");
        }
        String empresa = ImplEmpresa.empresaDefault != null
                ? ImplEmpresa.empresaDefault.getCodigo() : "?";
        sb.append(".\n\nEmpresa activa: ").append(empresa);
        if (filtroTexto != null && !filtroTexto.trim().isEmpty()) {
            sb.append("\nFiltro: \"").append(filtroTexto.trim()).append("\"");
        }
        return sb.toString();
    }

    private void buscarCuadrilla() {
        new RrhhSearchDialog<CuadrillaDto>(this, "BÚSQUEDA DE CUADRILLAS",
                new RrhhSearchDialog.DataLoader<CuadrillaDto>() {
                    @Override
                    public List<CuadrillaDto> load(String filter) throws Exception {
                        return api.getCuadrillas(filter, getUsuario(), null, null,
                                filtroEspecie(), filtroPresentacion(), filtroTarea());
                    }
                },
                new RrhhSearchDialog.ItemMapper<CuadrillaDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<CuadrillaDto> items) {
                        return RrhhItemSearch.fromCuadrillas(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<CuadrillaDto>() {
                    @Override
                    public void onSelected(CuadrillaDto item) {
                        aplicarCuadrilla(item);
                    }
                },
                null,
                new RrhhSearchDialog.EmptyMessageProvider() {
                    @Override
                    public String buildMessage(String filtroActual) {
                        return mensajeSinCuadrillas(filtroActual);
                    }
                }).show(etFiltroCuadrilla.getText().toString().trim());
    }

    private void aplicarCuadrilla(CuadrillaDto item) {
        cuadrillaSeleccionada = item;
        etCuadrilla.setText(item.getCodCuadrilla());
        etOtAdm.setText(item.getOtAdm() != null ? item.getOtAdm() : "");
        operacionSeleccionada = null;
        etOperSec.setText("");
        if (tvInfoCuadrilla != null) {
            String turno = item.getTurno() != null ? item.getTurno() : "";
            if (item.getDescTurno() != null && !item.getDescTurno().isEmpty()) {
                turno += " | " + item.getDescTurno();
            }
            String desc = item.getDescCuadrilla() != null ? item.getDescCuadrilla() : "";
            tvInfoCuadrilla.setText(desc + (turno.isEmpty() ? "" : "\nTurno: " + turno));
        }
    }

    private void buscarLabor() {
        new RrhhSearchDialog<LaborDto>(this, "BÚSQUEDA DE LABORES",
                new RrhhSearchDialog.DataLoader<LaborDto>() {
                    @Override
                    public List<LaborDto> load(String filter) throws Exception {
                        return api.getLabores(filter);
                    }
                },
                new RrhhSearchDialog.ItemMapper<LaborDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<LaborDto> items) {
                        return RrhhItemSearch.fromLabores(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<LaborDto>() {
                    @Override
                    public void onSelected(LaborDto item) {
                        laborSeleccionada = item;
                        etLabor.setText(item.getCodLabor());
                    }
                }).show(etLabor.getText().toString().trim());
    }

    private void buscarOperacion() {
        String otAdm = etOtAdm.getText().toString().trim();
        if (otAdm.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione cuadrilla u OT adm.", false);
            return;
        }
        final String ot = otAdm;
        new RrhhSearchDialog<OperacionDto>(this, "BÚSQUEDA DE OPERACIONES",
                new RrhhSearchDialog.DataLoader<OperacionDto>() {
                    @Override
                    public List<OperacionDto> load(String filter) throws Exception {
                        return api.getOperaciones(ot, null, null, filter);
                    }
                },
                new RrhhSearchDialog.ItemMapper<OperacionDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<OperacionDto> items) {
                        return RrhhItemSearch.fromOperaciones(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<OperacionDto>() {
                    @Override
                    public void onSelected(OperacionDto item) {
                        operacionSeleccionada = item;
                        etOperSec.setText(item.getOperSec());
                    }
                }).show();
    }

    private void buscarTrabajador() {
        String codCuadrilla = cuadrillaSeleccionada != null
                ? cuadrillaSeleccionada.getCodCuadrilla() : null;
        RrhhTrabajadorHelper.buscarYConfirmarJornal(this,
                etBuscarTrabajador.getText().toString().trim(),
                codCuadrilla,
                new RrhhTrabajadorHelper.OnTrabajadorConfirmado() {
                    @Override
                    public void onConfirmado(BeanTrabajador trabajador) {
                        if (!RrhhTrabajadorHelper.esTrabajadorHabilitado(trabajador)) {
                            MessageBox.AlertDialog(ParteJornalCampoActivity.this, "Aviso",
                                    RrhhTrabajadorHelper.getMensajeNoHabilitado(trabajador), false);
                            return;
                        }
                        trabajadorSeleccionado = trabajador;
                        nroItemGuardado = null;
                        mostrarTrabajador(trabajador);
                    }
                });
    }

    private void mostrarTrabajador(BeanTrabajador trabajador) {
        tvTrabajadorCodigo.setText(trabajador.getCodTrabajador());
        tvTrabajadorSeleccionado.setText(trabajador.getNombreCompleto());
        tvTrabajadorDni.setText(trabajador.getDocumentoIdentidad());
        if (trabajador.tieneFoto()) {
            Bitmap bitmap = BitmapFactory.decodeByteArray(trabajador.getFotoBlob(), 0, trabajador.getFotoBlob().length);
            if (bitmap != null) {
                ivFotoTrabajadorJornal.setImageBitmap(bitmap);
                return;
            }
        }
        ivFotoTrabajadorJornal.setImageResource(R.drawable.ic_user_placeholder);
    }

    private void aplicarResultado(JornalCampoResultDto result) {
        if (result == null) {
            return;
        }
        nroItemGuardado = result.getNroItem();
        setHrsField(etHrsNormales, result.getHrsNormales());
        setHrsField(etHrsExtra25, result.getHrsExtras25());
        setHrsField(etHrsExtra35, result.getHrsExtras35());
        setHrsField(etHrsExtra100, result.getHrsExtras100());
        setHrsField(etHrsNocNormal, result.getHrsNocNormal());
        setHrsField(etHrsNocExtra25, result.getHrsNocExtras25());
        setHrsField(etHrsNocExtra35, result.getHrsNocExtras35());
        tvImportes.setText(result.getResumenImportes());
    }

    private void setHrsField(EditText field, Double value) {
        if (field == null) {
            return;
        }
        if (value == null) {
            return;
        }
        field.setText(String.format(Locale.US, "%.2f", value));
    }

    private String validarCabecera(boolean exigirCompleto) {
        if (etFecha.getText().toString().trim().isEmpty()) {
            return "Ingrese la fecha del jornal";
        }
        if (trabajadorSeleccionado == null) {
            return "Seleccione trabajador";
        }
        if (!RrhhTrabajadorHelper.esTrabajadorHabilitado(trabajadorSeleccionado)) {
            return RrhhTrabajadorHelper.getMensajeNoHabilitado(trabajadorSeleccionado);
        }
        if (!exigirCompleto) {
            return null;
        }
        if (cuadrillaSeleccionada == null) {
            return "Seleccione cuadrilla";
        }
        if (etOtAdm.getText().toString().trim().isEmpty()) {
            return "OT administrativa es obligatoria (seleccione cuadrilla)";
        }
        if (etLabor.getText().toString().trim().isEmpty()) {
            return "Seleccione labor";
        }
        if (getUsuario().isEmpty()) {
            return "No se identificó el usuario de sesión";
        }
        return null;
    }

    /**
     * @param guardarPrimero true = GUARDAR (merge + calcular). false = CALCULAR:
     *                       si ya hay item guardado recalcula; si no, guarda y calcula.
     */
    private void ejecutarCalculo(final boolean guardarPrimero) {
        boolean debePersistir = guardarPrimero || nroItemGuardado == null;
        String error = validarCabecera(debePersistir);
        if (error != null) {
            MessageBox.AlertDialog(this, "Aviso", error, false);
            return;
        }

        final boolean persistir = debePersistir;
        final JornalCampoRequest req = buildRequest(true);

        new AsyncTask<Void, Void, Object[]>() {
            ProgressDialog pd;

            @Override
            protected void onPreExecute() {
                String msg = persistir
                        ? (guardarPrimero ? "Guardando y calculando..." : "Guardando para calcular...")
                        : "Calculando...";
                pd = ProgressDialog.show(ParteJornalCampoActivity.this, "Espere", msg);
            }

            @Override
            protected Object[] doInBackground(Void... voids) {
                try {
                    JornalCampoResultDto result;
                    if (persistir) {
                        result = api.guardarJornalCampo(req);
                    } else {
                        result = api.calcularJornalCampo(req);
                    }
                    return new Object[]{result, null};
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
                    MessageBox.AlertDialog(ParteJornalCampoActivity.this, "Error",
                            String.valueOf(data[1]), false);
                    return;
                }
                JornalCampoResultDto result = (JornalCampoResultDto) data[0];
                if (result == null) {
                    MessageBox.AlertDialog(ParteJornalCampoActivity.this, "Aviso",
                            "No se obtuvo resultado del cálculo", false);
                    return;
                }
                aplicarResultado(result);
                String titulo = persistir ? "Éxito" : "Cálculo";
                String mensaje = result.getMensaje() != null
                        ? result.getMensaje()
                        : (persistir ? "Jornal guardado" : "Cálculo ejecutado");
                MessageBox.AlertDialog(ParteJornalCampoActivity.this, titulo, mensaje, true);
            }
        }.execute();
    }

    private void guardarJornal() {
        ejecutarCalculo(true);
    }

    private Double parseDouble(String s) {
        try {
            return Double.parseDouble(s.trim().replace(',', '.'));
        } catch (Exception e) {
            return 0d;
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
