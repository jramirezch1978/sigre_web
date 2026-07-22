package pe.com.sytco.fastsales.Activities.RRHH;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.RRHH.ImplRrhhProduccion;
import pe.com.sytco.fastsales.Controller.RRHH.ImplTrabajador;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.api.rrhh.dto.ClienteDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaLaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OperacionDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OtAdmDto;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoDetalleDto;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoRequest;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoResultDto;
import pe.com.sytco.fastsales.api.rrhh.dto.TarifarioDto;
import pe.com.sytco.fastsales.api.rrhh.dto.TrabajadorResumenDto;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.util.MessageBox;

public class ParteDestajoActivity extends AppCompatActivity {

    private EditText etFechaParte, etFiltroCuadrilla, etFiltroEspecie, etFiltroPresentacion, etFiltroTarea;
    private EditText etCuadrilla, etEspecie, etPresentacion, etTarea, etCliente, etOtAdm, etNroOrden, etOperSec;
    private TextView tvInfoCuadrilla, tvOtAdmDesc, tvTarifa, tvProdTotal, tvClienteCodigo, tvNombreCliente;
    private ListView lvTrabajadores;
    private ImageButton btnFechaParte;
    private Button btnBuscarCuadrilla, btnBuscarCliente, btnBuscarLabor, btnBuscarTarifario, btnBuscarOtAdm, btnBuscarOper;
    private Button btnCargarCuadrilla, btnAgregarTrabajador, btnGuardar;

    private ImplRrhhProduccion api;
    private CuadrillaDto cuadrillaSeleccionada;
    private CuadrillaLaborDto laborSeleccionada;
    private TarifarioDto tarifarioSeleccionado;
    private OtAdmDto otAdmSeleccionada;
    private OperacionDto operacionSeleccionada;
    private List<CuadrillaLaborDto> laboresCuadrilla = new ArrayList<CuadrillaLaborDto>();
    private final List<ParteDestajoDetalleDto> detalle = new ArrayList<ParteDestajoDetalleDto>();
    private TrabajadorDestajoAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_parte_destajo);

        RrhhUiHelper.setupScreen(this);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Parte de Destajo");

        try {
            api = new ImplRrhhProduccion(ImplEmpresa.empresaDefault.getCodigo());
        } catch (Exception e) {
            MessageBox.AlertDialog(this, "Error", e.getMessage(), false);
            finish();
            return;
        }

        initControls();
        etFechaParte.setText(new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(new Date()));
        RrhhUiHelper.attachDatePicker(this, etFechaParte, btnFechaParte);
        cargarClientePorDefecto();
        adapter = new TrabajadorDestajoAdapter(detalle);
        lvTrabajadores.setAdapter(adapter);
        assignEvents();
    }

    private void initControls() {
        etFechaParte = findViewById(R.id.etFechaParte);
        etFiltroCuadrilla = findViewById(R.id.etFiltroCuadrilla);
        etFiltroEspecie = findViewById(R.id.etFiltroEspecie);
        etFiltroPresentacion = findViewById(R.id.etFiltroPresentacion);
        etFiltroTarea = findViewById(R.id.etFiltroTarea);
        etCuadrilla = findViewById(R.id.etCuadrilla);
        etEspecie = findViewById(R.id.etEspecie);
        etPresentacion = findViewById(R.id.etPresentacion);
        etTarea = findViewById(R.id.etTarea);
        etCliente = findViewById(R.id.etCliente);
        tvClienteCodigo = findViewById(R.id.tvClienteCodigo);
        tvNombreCliente = findViewById(R.id.tvNombreCliente);
        btnFechaParte = findViewById(R.id.btnFechaParte);
        btnBuscarCliente = findViewById(R.id.btnBuscarCliente);
        etOtAdm = findViewById(R.id.etOtAdm);
        etNroOrden = findViewById(R.id.etNroOrden);
        tvOtAdmDesc = findViewById(R.id.tvOtAdmDesc);
        etOperSec = findViewById(R.id.etOperSec);
        tvInfoCuadrilla = findViewById(R.id.tvInfoCuadrilla);
        tvTarifa = findViewById(R.id.tvTarifa);
        tvProdTotal = findViewById(R.id.tvProdTotal);
        lvTrabajadores = findViewById(R.id.lvTrabajadores);
        btnBuscarCuadrilla = findViewById(R.id.btnBuscarCuadrilla);
        btnBuscarLabor = findViewById(R.id.btnBuscarLabor);
        btnBuscarTarifario = findViewById(R.id.btnBuscarTarifario);
        btnBuscarOtAdm = findViewById(R.id.btnBuscarOtAdm);
        btnBuscarOper = findViewById(R.id.btnBuscarOper);
        btnCargarCuadrilla = findViewById(R.id.btnCargarCuadrilla);
        btnAgregarTrabajador = findViewById(R.id.btnAgregarTrabajador);
        btnGuardar = findViewById(R.id.btnGuardar);
    }

    private void cargarClientePorDefecto() {
        tvClienteCodigo.setText("Código: …");
        tvNombreCliente.setText("Cargando empresa…");

        new AsyncTask<Void, Void, ClienteDto>() {
            String error;

            @Override
            protected ClienteDto doInBackground(Void... voids) {
                try {
                    return api.getClienteEmpresaDefault();
                } catch (Exception e) {
                    error = e.getMessage();
                    return null;
                }
            }

            @Override
            protected void onPostExecute(ClienteDto cliente) {
                if (cliente != null && cliente.getCodCliente() != null
                        && !cliente.getCodCliente().trim().isEmpty()) {
                    aplicarCliente(cliente);
                    return;
                }
                tvClienteCodigo.setText("Código: —");
                tvNombreCliente.setText(error != null ? error : "No se pudo cargar la empresa");
            }
        }.execute();
    }

    private void aplicarCliente(ClienteDto cliente) {
        if (cliente == null) {
            return;
        }
        String cod = cliente.getCodCliente() != null ? cliente.getCodCliente().trim() : "";
        String nom = cliente.getNomCliente() != null ? cliente.getNomCliente().trim() : "";

        etCliente.setText(cod);
        tvClienteCodigo.setText(cod.isEmpty() ? "Código: —" : "Código: " + cod);
        tvNombreCliente.setText(nom.isEmpty() ? "Seleccione una empresa" : nom);
    }

    private void assignEvents() {
        View.OnClickListener abrirClientes = v -> buscarCliente();
        btnBuscarCliente.setOnClickListener(abrirClientes);
        tvNombreCliente.setOnClickListener(abrirClientes);
        tvClienteCodigo.setOnClickListener(abrirClientes);
        btnBuscarCuadrilla.setOnClickListener(v -> buscarCuadrilla());
        btnBuscarLabor.setOnClickListener(v -> seleccionarLabor());
        btnBuscarTarifario.setOnClickListener(v -> buscarTarifario());
        btnBuscarOtAdm.setOnClickListener(v -> buscarOtAdm());
        btnBuscarOper.setOnClickListener(v -> buscarOperacion());
        btnCargarCuadrilla.setOnClickListener(v -> cargarTrabajadoresCuadrilla());
        btnAgregarTrabajador.setOnClickListener(v -> agregarTrabajadorIndividual());
        btnGuardar.setOnClickListener(v -> guardarParte());

        lvTrabajadores.setOnItemClickListener((parent, view, position, id) -> {
            ParteDestajoDetalleDto d = detalle.get(position);
            BeanTrabajador bean = adapter.getTrabajador(d.getCodTrabajador());
            if (bean != null) {
                RrhhTrabajadorHelper.mostrarFichaConsulta(ParteDestajoActivity.this, bean);
            } else {
                RrhhTrabajadorHelper.mostrarFichaConsulta(ParteDestajoActivity.this, d.getCodTrabajador());
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

    private String mensajeSinCuadrillas(String filtroTexto) {
        StringBuilder sb = new StringBuilder();
        sb.append("No hay cuadrillas disponibles");
        String usuario = getUsuario();
        if (usuario.isEmpty()) {
            sb.append(" (no se identificó el usuario de sesión; inicie sesión nuevamente)");
        } else {
            sb.append(" para el usuario \"").append(usuario).append("\"");
            sb.append(" según su acceso en OT administrativa (ot_adm_usuario)");
        }
        String empresa = ImplEmpresa.empresaDefault != null
                ? ImplEmpresa.empresaDefault.getCodigo() : "?";
        sb.append(".\n\nEmpresa activa: ").append(empresa);
        if (filtroTexto != null && !filtroTexto.trim().isEmpty()) {
            sb.append("\nFiltro de búsqueda: \"").append(filtroTexto.trim()).append("\"");
        }
        String esp = filtroEspecie();
        String pres = filtroPresentacion();
        String tar = filtroTarea();
        if (!esp.isEmpty() || !pres.isEmpty() || !tar.isEmpty()) {
            sb.append("\nFiltros tarifario: especie=").append(esp.isEmpty() ? "*" : esp);
            sb.append(", presentación=").append(pres.isEmpty() ? "*" : pres);
            sb.append(", tarea=").append(tar.isEmpty() ? "*" : tar);
        }
        return sb.toString();
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

    private void buscarCliente() {
        new RrhhSearchDialog<ClienteDto>(this, "BÚSQUEDA DE EMPRESAS",
                new RrhhSearchDialog.DataLoader<ClienteDto>() {
                    @Override
                    public List<ClienteDto> load(String filter) throws Exception {
                        return api.getClientes(filter);
                    }
                },
                new RrhhSearchDialog.ItemMapper<ClienteDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<ClienteDto> items) {
                        return RrhhItemSearch.fromClientes(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<ClienteDto>() {
                    @Override
                    public void onSelected(ClienteDto item) {
                        aplicarCliente(item);
                    }
                }).show("");
    }

    private void buscarCuadrilla() {
        final String filtroInicial = etFiltroCuadrilla.getText().toString().trim();
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
                }).show(filtroInicial);
    }

    private void aplicarCuadrilla(final CuadrillaDto cuadrilla) {
        cuadrillaSeleccionada = cuadrilla;
        laborSeleccionada = null;
        tarifarioSeleccionado = null;
        otAdmSeleccionada = null;
        operacionSeleccionada = null;
        etCuadrilla.setText(cuadrilla.getCodCuadrilla());
        String turnoTxt = cuadrilla.getTurno() != null ? cuadrilla.getTurno() : "";
        if (cuadrilla.getDescTurno() != null && !cuadrilla.getDescTurno().isEmpty()) {
            turnoTxt += " | " + cuadrilla.getDescTurno();
        }
        tvInfoCuadrilla.setText(cuadrilla.getDescCuadrilla() + "\nTurno: " + turnoTxt);
        limpiarOtYOperacion();
        limpiarLabor();

        new AsyncTask<Void, Void, List<CuadrillaLaborDto>>() {
            ProgressDialog pd;
            String error;

            @Override
            protected void onPreExecute() {
                pd = ProgressDialog.show(ParteDestajoActivity.this, "Espere", "Cargando labores...");
            }

            @Override
            protected List<CuadrillaLaborDto> doInBackground(Void... voids) {
                try {
                    return api.getCuadrillaLabores(cuadrilla.getCodCuadrilla());
                } catch (Exception e) {
                    error = e.getMessage();
                    return null;
                }
            }

            @Override
            protected void onPostExecute(List<CuadrillaLaborDto> labores) {
                pd.dismiss();
                if (error != null) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Error", error, false);
                    return;
                }
                laboresCuadrilla = labores != null ? labores : new ArrayList<CuadrillaLaborDto>();
                if (laboresCuadrilla.size() == 1) {
                    aplicarLabor(laboresCuadrilla.get(0));
                } else if (laboresCuadrilla.isEmpty()) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Aviso",
                            "La cuadrilla no tiene labores configuradas", false);
                }
            }
        }.execute();
    }

    private void seleccionarLabor() {
        if (laboresCuadrilla == null || laboresCuadrilla.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione cuadrilla con labores", false);
            return;
        }
        new RrhhSearchDialog<CuadrillaLaborDto>(this, "LABORES DE CUADRILLA",
                new RrhhSearchDialog.DataLoader<CuadrillaLaborDto>() {
                    @Override
                    public List<CuadrillaLaborDto> load(String filter) throws Exception {
                        if (filter == null || filter.trim().isEmpty()) {
                            return laboresCuadrilla;
                        }
                        String f = filter.trim().toUpperCase(Locale.getDefault());
                        List<CuadrillaLaborDto> filtradas = new ArrayList<CuadrillaLaborDto>();
                        for (CuadrillaLaborDto l : laboresCuadrilla) {
                            if (l.getLabel().toUpperCase(Locale.getDefault()).contains(f)) {
                                filtradas.add(l);
                            }
                        }
                        return filtradas;
                    }
                },
                new RrhhSearchDialog.ItemMapper<CuadrillaLaborDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<CuadrillaLaborDto> items) {
                        return RrhhItemSearch.fromLaboresCuadrilla(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<CuadrillaLaborDto>() {
                    @Override
                    public void onSelected(CuadrillaLaborDto item) {
                        aplicarLabor(item);
                    }
                }).show();
    }

    private void buscarTarifario() {
        new RrhhSearchDialog<TarifarioDto>(this, "CATÁLOGO TARIFARIO",
                new RrhhSearchDialog.DataLoader<TarifarioDto>() {
                    @Override
                    public List<TarifarioDto> load(String filter) throws Exception {
                        return api.getTarifario(filter, filtroEspecie(), filtroPresentacion(), filtroTarea());
                    }
                },
                new RrhhSearchDialog.ItemMapper<TarifarioDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<TarifarioDto> items) {
                        return RrhhItemSearch.fromTarifario(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<TarifarioDto>() {
                    @Override
                    public void onSelected(TarifarioDto item) {
                        aplicarTarifario(item);
                    }
                }).show();
    }

    private void aplicarLabor(CuadrillaLaborDto labor) {
        laborSeleccionada = labor;
        tarifarioSeleccionado = null;
        limpiarOtYOperacion();
        etEspecie.setText(labor.getCodEspecie());
        etPresentacion.setText(labor.getCodPresentacion());
        etTarea.setText(labor.getCodTarea());
        tvTarifa.setText("Tarifa: " + (labor.getTarifa() != null ? labor.getTarifa() : "0")
                + (labor.getUnd() != null ? " " + labor.getUnd() : ""));
        actualizarProduccionTotal();
    }

    private void aplicarTarifario(TarifarioDto tarifario) {
        tarifarioSeleccionado = tarifario;
        laborSeleccionada = null;
        limpiarOtYOperacion();
        etEspecie.setText(tarifario.getCodEspecie());
        etPresentacion.setText(tarifario.getCodPresentacion());
        etTarea.setText(tarifario.getCodTarea());
        tvTarifa.setText("Tarifa: " + (tarifario.getTarifa() != null ? tarifario.getTarifa() : "0")
                + (tarifario.getUnd() != null ? " " + tarifario.getUnd() : ""));
        actualizarProduccionTotal();
    }

    private void limpiarLabor() {
        etEspecie.setText("");
        etPresentacion.setText("");
        etTarea.setText("");
        tvTarifa.setText("Tarifa: -");
    }

    private void limpiarOtYOperacion() {
        otAdmSeleccionada = null;
        operacionSeleccionada = null;
        etOtAdm.setText("");
        etNroOrden.setText("");
        etOperSec.setText("");
        tvOtAdmDesc.setText("");
        tvOtAdmDesc.setVisibility(View.GONE);
    }

    private String getCodLaborTarifario() {
        if (laborSeleccionada != null && laborSeleccionada.getCodLabor() != null
                && !laborSeleccionada.getCodLabor().trim().isEmpty()) {
            return laborSeleccionada.getCodLabor().trim();
        }
        if (tarifarioSeleccionado != null && tarifarioSeleccionado.getCodLabor() != null
                && !tarifarioSeleccionado.getCodLabor().trim().isEmpty()) {
            return tarifarioSeleccionado.getCodLabor().trim();
        }
        return "";
    }

    private void buscarOtAdm() {
        String codLabor = getCodLaborTarifario();
        if (codLabor.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso",
                    "Seleccione primero labor o tarifario (debe tener código de labor)", false);
            return;
        }
        final String usuario = getUsuario();
        if (usuario == null || usuario.trim().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Usuario de sesión no disponible", false);
            return;
        }
        new RrhhSearchDialog<OtAdmDto>(this, "BÚSQUEDA OT ADMINISTRATIVA",
                new RrhhSearchDialog.DataLoader<OtAdmDto>() {
                    @Override
                    public List<OtAdmDto> load(String filter) throws Exception {
                        return api.getOtAdm(usuario, filter);
                    }
                },
                new RrhhSearchDialog.ItemMapper<OtAdmDto>() {
                    @Override
                    public List<pe.com.sytco.fastsales.beans.BeanItemSearch> toSearchItems(List<OtAdmDto> items) {
                        return RrhhItemSearch.fromOtAdm(items);
                    }
                },
                new RrhhSearchDialog.OnSelectedListener<OtAdmDto>() {
                    @Override
                    public void onSelected(OtAdmDto item) {
                        otAdmSeleccionada = item;
                        operacionSeleccionada = null;
                        etOtAdm.setText(item.getOtAdm());
                        etNroOrden.setText("");
                        etOperSec.setText("");
                        if (item.getDescripcion() != null && !item.getDescripcion().isEmpty()) {
                            tvOtAdmDesc.setText(item.getDescripcion());
                            tvOtAdmDesc.setVisibility(View.VISIBLE);
                        } else {
                            tvOtAdmDesc.setVisibility(View.GONE);
                        }
                    }
                }).show();
    }

    private void buscarOperacion() {
        String codLabor = getCodLaborTarifario();
        if (codLabor.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso",
                    "Seleccione primero labor o tarifario (debe tener código de labor)", false);
            return;
        }
        if (otAdmSeleccionada == null || otAdmSeleccionada.getOtAdm() == null
                || otAdmSeleccionada.getOtAdm().trim().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione primero OT administrativa", false);
            return;
        }
        final String otAdm = otAdmSeleccionada.getOtAdm().trim();
        final String nroOrdenFiltro = etNroOrden.getText().toString().trim();
        final String nroOrdenParam = nroOrdenFiltro.isEmpty() ? null : nroOrdenFiltro;
        new RrhhSearchDialog<OperacionDto>(this, "BÚSQUEDA DE OPERACIONES (OT + TARIFARIO)",
                new RrhhSearchDialog.DataLoader<OperacionDto>() {
                    @Override
                    public List<OperacionDto> load(String filter) throws Exception {
                        return api.getOperaciones(otAdm, codLabor, nroOrdenParam, filter);
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
                        if (item.getNroOrden() != null) {
                            etNroOrden.setText(item.getNroOrden());
                        }
                        etOperSec.setText(item.getOperSec());
                    }
                }).show();
    }

    private void agregarTrabajadorIndividual() {
        RrhhTrabajadorHelper.buscarYConfirmar(this, "",
                RrhhTrabajadorHelper.OpcionesConfirmacion.destajoAgregar(),
                new RrhhTrabajadorHelper.OnTrabajadorConfirmado() {
                    @Override
                    public void onConfirmado(BeanTrabajador trabajador) {
                        if (!RrhhTrabajadorHelper.esTrabajadorHabilitado(trabajador)) {
                            MessageBox.AlertDialog(ParteDestajoActivity.this, "Aviso",
                                    RrhhTrabajadorHelper.getMensajeNoHabilitado(trabajador), false);
                            return;
                        }
                        if (adapter.contieneTrabajador(trabajador.getCodTrabajador())) {
                            MessageBox.AlertDialog(ParteDestajoActivity.this, "Aviso",
                                    "El trabajador ya está en el parte", false);
                            return;
                        }
                        ParteDestajoDetalleDto d = new ParteDestajoDetalleDto();
                        d.setCodTrabajador(trabajador.getCodTrabajador());
                        d.setNomTrabajador(trabajador.getNombreCompleto());
                        d.setCantProducida(0d);
                        adapter.agregarDetalle(d, trabajador);
                        actualizarProduccionTotal();
                    }
                });
    }

    private void cargarTrabajadoresCuadrilla() {
        if (cuadrillaSeleccionada == null) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione una cuadrilla primero", false);
            return;
        }
        new AsyncTask<Void, Void, Object[]>() {
            ProgressDialog pd;

            @Override
            protected void onPreExecute() {
                pd = ProgressDialog.show(ParteDestajoActivity.this, "Espere", "Cargando trabajadores...");
            }

            @Override
            protected Object[] doInBackground(Void... voids) {
                try {
                    List<TrabajadorResumenDto> trabajadores = api.getCuadrillaTrabajadores(
                            cuadrillaSeleccionada.getCodCuadrilla());
                    ImplTrabajador impl = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    Map<String, BeanTrabajador> beans = new HashMap<String, BeanTrabajador>();
                    List<ParteDestajoDetalleDto> lista = new ArrayList<ParteDestajoDetalleDto>();
                    int omitidos = 0;
                    if (trabajadores != null) {
                        for (TrabajadorResumenDto t : trabajadores) {
                            BeanTrabajador bean = null;
                            try {
                                bean = impl.getTrabajadorByCodigo(t.getCodTrabajador());
                            } catch (Exception ignored) {
                            }
                            if (bean != null && !RrhhTrabajadorHelper.esTrabajadorHabilitado(bean)) {
                                omitidos++;
                                continue;
                            }
                            ParteDestajoDetalleDto d = new ParteDestajoDetalleDto();
                            d.setCodTrabajador(t.getCodTrabajador());
                            d.setNomTrabajador(t.getNomTrabajador());
                            d.setCantProducida(0d);
                            lista.add(d);
                            if (bean != null) {
                                beans.put(t.getCodTrabajador(), bean);
                            }
                        }
                    }
                    return new Object[]{lista, beans, omitidos, null};
                } catch (Exception e) {
                    return new Object[]{null, null, 0, e.getMessage()};
                }
            }

            @Override
            protected void onPostExecute(Object[] data) {
                pd.dismiss();
                if (data[3] != null) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Error", String.valueOf(data[3]), false);
                    return;
                }
                detalle.clear();
                @SuppressWarnings("unchecked")
                List<ParteDestajoDetalleDto> lista = (List<ParteDestajoDetalleDto>) data[0];
                @SuppressWarnings("unchecked")
                Map<String, BeanTrabajador> beans = (Map<String, BeanTrabajador>) data[1];
                int omitidos = (Integer) data[2];
                if (lista != null) {
                    detalle.addAll(lista);
                }
                adapter.setTrabajadores(beans);
                adapter.notifyDataSetChanged();
                actualizarProduccionTotal();
                if (omitidos > 0) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Aviso",
                            omitidos + " trabajador(es) cesado(s) o inactivo(s) no se incluyeron", false);
                }
                if (lista == null || lista.isEmpty()) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Aviso",
                            "No hay trabajadores activos en la cuadrilla", false);
                }
            }
        }.execute();
    }

    private void actualizarProduccionTotal() {
        adapter.syncAllFromListView(lvTrabajadores);
        tvProdTotal.setText(String.format(Locale.US, "Producción total: %.2f", adapter.getTotalProduccion()));
    }

    private void guardarParte() {
        adapter.syncAllFromListView(lvTrabajadores);
        actualizarProduccionTotal();

        if (etCliente.getText().toString().trim().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione un cliente", false);
            return;
        }
        if (cuadrillaSeleccionada == null) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione cuadrilla", false);
            return;
        }
        if (laborSeleccionada == null && tarifarioSeleccionado == null
                && etEspecie.getText().toString().trim().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione labor o tarifario", false);
            return;
        }
        if (getCodLaborTarifario().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "La labor/tarifario no tiene código de labor", false);
            return;
        }
        if (otAdmSeleccionada == null || otAdmSeleccionada.getOtAdm() == null
                || otAdmSeleccionada.getOtAdm().trim().isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Seleccione OT administrativa", false);
            return;
        }
        if (detalle.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Cargue trabajadores de la cuadrilla", false);
            return;
        }

        final ParteDestajoRequest req = new ParteDestajoRequest();
        req.setEmpresa(ImplEmpresa.empresaDefault.getCodigo());
        req.setUsuario(getUsuario());
        req.setCodOrigen(ImplEmpresa.empresaDefault.getCodOrigen());
        req.setFecParte(etFechaParte.getText().toString().trim());
        req.setCliente(etCliente.getText().toString().trim());
        req.setCuadrilla(cuadrillaSeleccionada.getCodCuadrilla());
        req.setTurno(cuadrillaSeleccionada.getTurno());
        req.setOtAdm(otAdmSeleccionada.getOtAdm().trim());
        req.setEspecie(etEspecie.getText().toString().trim());
        req.setPresentacion(etPresentacion.getText().toString().trim());
        req.setTarea(etTarea.getText().toString().trim());
        if (operacionSeleccionada != null) {
            req.setNumeroOt(operacionSeleccionada.getNroOrden());
            req.setOperSec(operacionSeleccionada.getOperSec());
        } else if (etOperSec.getText().length() > 0) {
            req.setOperSec(etOperSec.getText().toString().trim());
        }
        req.setFechaInicio(req.getFecParte());
        req.setFechaFin(req.getFecParte());

        List<ParteDestajoDetalleDto> envio = new ArrayList<ParteDestajoDetalleDto>();
        for (ParteDestajoDetalleDto d : detalle) {
            Double cant = adapter.getCantidad(d.getCodTrabajador());
            if (cant != null && cant > 0) {
                d.setCantProducida(cant);
                envio.add(d);
            }
        }
        if (envio.isEmpty()) {
            MessageBox.AlertDialog(this, "Aviso", "Ingrese cantidad producida en al menos un trabajador", false);
            return;
        }
        req.setDetalle(envio);

        new AsyncTask<ParteDestajoRequest, Void, Object[]>() {
            ProgressDialog pd;

            @Override
            protected void onPreExecute() {
                pd = ProgressDialog.show(ParteDestajoActivity.this, "Espere", "Guardando parte...");
            }

            @Override
            protected Object[] doInBackground(ParteDestajoRequest... params) {
                try {
                    ParteDestajoResultDto result = api.guardarParteDestajo(params[0]);
                    return new Object[]{result, null};
                } catch (Exception e) {
                    return new Object[]{null, e.getMessage()};
                }
            }

            @Override
            protected void onPostExecute(Object[] data) {
                pd.dismiss();
                if (data[1] != null) {
                    MessageBox.AlertDialog(ParteDestajoActivity.this, "Error", String.valueOf(data[1]), false);
                    return;
                }
                ParteDestajoResultDto result = (ParteDestajoResultDto) data[0];
                String msg = "Parte registrado";
                if (result.getNroParte() != null) {
                    msg += "\nNro. Parte: " + result.getNroParte();
                }
                if (result.getProduccionTotal() != null) {
                    msg += "\nProducción total: " + result.getProduccionTotal();
                }
                msg += "\nTrabajadores: " + result.getTrabajadoresRegistrados();
                MessageBox.AlertDialog(ParteDestajoActivity.this, "Éxito", msg, false);
                finish();
            }
        }.execute(req);
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
