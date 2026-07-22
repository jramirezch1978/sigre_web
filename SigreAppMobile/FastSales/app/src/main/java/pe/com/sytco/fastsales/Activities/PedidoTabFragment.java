package pe.com.sytco.fastsales.Activities;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.Finanzas.ImplTasaCambio;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Dialog.DialogAddClientePedido;
import pe.com.sytco.fastsales.Dialog.DialogAddPedido;
import pe.com.sytco.fastsales.Dialog.DialogLecturaQR;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.PedidoUI;
import pe.com.sytco.fastsales.adapter.ListViewArticulosAdapter;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.pedido.PedidoLayoutInflater;
import pe.com.sytco.fastsales.pedido.PedidoTabState;
import pe.com.sytco.fastsales.util.ConfirmDialog;
import pe.com.sytco.fastsales.util.LogHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.SafeProgress;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;
import pe.com.sytco.fastsales.util.ViewBinder;

/**
 * Created by jramirez on 25/04/2016.
 */
public class PedidoTabFragment extends Fragment implements PedidoSession {

    public static final String ARG_TAB_ID = "tabId";
    public static final String ARG_TAB_TITLE = "tabTitle";

    private View rootView;
    private String tabId;
    private String tabTitle;
    private PedidoHostActivity hostActivity;


    //Variables por defecto
    private ArrayAdapter adaptador;

    //Controles diversos
    private EditText etFiltro;
    private ListView lvListaArticulos;
    private TextView tvTotalRegistros, tvCaption, tvMonedaIGV, tvMonedaBI, tvMonedaVta;
    private RadioButton rbFactura, rbBoleta, rbNotaVenta;
    private Button btnBuscar, btnGrabar, btnLimpiarPedido, btnSalir, btnMostrarBusqueda, btnLecturaQR;
    private ImageButton ibOcultarBusqueda, ibMenuArticulos, btnAddArticulo;
    private RadioGroup rgFlagFacturaBoleta;
    private LinearLayout llBusqueda;
    private DrawerLayout drawerArticulos;

    //Listados
    List<BeanArticulo> articulos;

    //Action por defecto del Activity anterior
    Integer ACTION_LOAD = -1;

    //Usuario que se ha logueado
    private BeanUsuario userLogin = null;
    private BeanProforma proformaSelected = null;

    //Representa al pedido General
    private ImplPedido implPedido = null;

    //Variables y Parametros Generales
    Boolean bPrimeraVez = true;
    Double ldcTasaCambio = 0.00;

    //Objeto para el UI de la Activity
    private PedidoUI pedidoUI;

    public ImplPedido getImplPedido() {
        return implPedido;
    }

    public BeanUsuario getUserLogin() {
        return userLogin;
    }

    public PedidoUI getPedidoUI() {
        return  pedidoUI;
    }

    @Override
    public View getContentRoot() {
        return rootView;
    }

    public static PedidoTabFragment newInstance(String tabId, String tabTitle) {
        PedidoTabFragment fragment = new PedidoTabFragment();
        Bundle args = new Bundle();
        args.putString(ARG_TAB_ID, tabId);
        args.putString(ARG_TAB_TITLE, tabTitle != null ? tabTitle : "Pedido");
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (!(context instanceof PedidoHostActivity)) {
            throw new IllegalStateException("PedidoTabFragment debe alojarse en PedidoHostActivity");
        }
        hostActivity = (PedidoHostActivity) context;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        // Inflar según ancho/alto real (layout-land), no solo Configuration.orientation del emulador.
        LayoutInflater oriented = PedidoLayoutInflater.forWindow(requireContext());
        rootView = oriented.inflate(R.layout.fragment_pedido_tab, container, false);
        return rootView;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        try {
            if (ImplEmpresa.empresaDefault == null && hostActivity != null) {
                // Tras un crash/recreate el static puede quedar null; el host lo restaura.
                hostActivity.ensureEmpresaDefault();
            }
            if (ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }
            Bundle args = getArguments();
            tabId = args != null ? args.getString(ARG_TAB_ID) : null;
            tabTitle = args != null ? args.getString(ARG_TAB_TITLE, "Pedido") : "Pedido";
            if (tabId == null) {
                throw new Exception("tabId requerido");
            }

            InitControllers();
            AsignarEventos();
            LoadDataDefault();
        } catch (Exception e) {
            LogHelper.e("PedidoTabFragment", "Error en onViewCreated tabId=" + tabId, e);
            MessageBox.AlertDialog(requireActivity(), "Ha ocurrido un error",
                    "Mensaje de Error: " + e.getMessage(), false);
        }
    }

    @Override
    public Activity getHostActivity() {
        return requireActivity();
    }

    @Override
    public String getTabId() {
        if (tabId != null) {
            return tabId;
        }
        Bundle args = getArguments();
        return args != null ? args.getString(ARG_TAB_ID) : null;
    }

    @Override
    public void persistCache() {
        if (hostActivity != null) {
            hostActivity.persistTab(this);
        }
    }

    @Override
    public void notifyPedidoChanged() {
        if (hostActivity != null) {
            hostActivity.onTabPedidoChanged(this);
        }
    }

    private void LoadDataDefault() throws Exception {
        final GlobalClass globalVariable = (GlobalClass) requireActivity().getApplicationContext();
        userLogin = globalVariable.getUserLogin();

        PedidoTabState state = hostActivity.ensureTabState(tabId, tabTitle);
        if (state == null) {
            throw new Exception("Estado de pestaña no encontrado: " + tabId);
        }
        implPedido = state.pedido;
        proformaSelected = state.proformaToLoad;
        if (implPedido == null) {
            implPedido = new ImplPedido(ImplEmpresa.empresaDefault.getCodigo());
            state.pedido = implPedido;
        }

        globalVariable.setImplPedido(implPedido);

        pedidoUI = new PedidoUI(this);
        pedidoUI.drawHeaderPedido();
        UTIL.OcultarTeclado(requireActivity(), btnBuscar);
        applyNotaVentaVisibility();

        if (proformaSelected != null && !state.proformaLoaded) {
            new SearchPedidoTask().execute();
        } else if (state.fromCache) {
            refreshPedidoUi(true);
            new NewPedidoTask().execute();
        } else {
            implPedido.newPedido();
            new NewPedidoTask().execute();
        }
    }

    private void applyNotaVentaVisibility() throws Exception {
        if (ImplEmpresa.beanParametros == null) {
            throw new Exception("Verificar beanParametros esta en blanco o es NULO, por favor vuelva a cargar la APLICACION");
        }
        if (ImplEmpresa.beanParametros.getShowVentasNVC() == null) {
            throw new Exception("El parametro ShowVentasNVC esta en blanco");
        }
        rbNotaVenta.setVisibility(
                "0".equals(ImplEmpresa.beanParametros.getShowVentasNVC()) ? View.GONE : View.VISIBLE);
    }

    private void refreshPedidoUi(boolean collapseSearchIfHasItems) {
        applyFlagComprobanteFromCabecera();
        pedidoUI.drawDetailPedido(implPedido);
        if (collapseSearchIfHasItems
                && implPedido.getDetalle() != null
                && implPedido.getDetalle().size() > 0) {
            setBusquedaVisible(false);
        }
    }

    private void setBusquedaVisible(boolean visible) {
        // Portrait: drawer con layout_gravity=start.
        // Landscape: llBusqueda es columna fija; nunca GONE (si no, al rotar
        // un pedido con ítems desaparece el listado y solo se ve el detalle).
        if (isDrawerMode()) {
            if (visible) {
                drawerArticulos.openDrawer(GravityCompat.START);
            } else {
                drawerArticulos.closeDrawer(GravityCompat.START);
            }
            return;
        }
        if (llBusqueda != null) {
            llBusqueda.setVisibility(View.VISIBLE);
        }
        if (btnMostrarBusqueda != null) {
            btnMostrarBusqueda.setVisibility(View.GONE);
        }
    }

    /**
     * Portrait: llBusqueda es panel drawer (layout_gravity=start).
     * Landscape: llBusqueda va en el contenido a dos columnas (sin gravity de drawer).
     */
    private boolean isDrawerMode() {
        if (drawerArticulos == null || llBusqueda == null) {
            return false;
        }
        ViewGroup.LayoutParams lp = llBusqueda.getLayoutParams();
        if (!(lp instanceof DrawerLayout.LayoutParams)) {
            return false;
        }
        int gravity = ((DrawerLayout.LayoutParams) lp).gravity;
        return gravity == android.view.Gravity.START
                || gravity == android.view.Gravity.LEFT
                || (gravity & android.view.Gravity.START) == android.view.Gravity.START
                || (gravity & android.view.Gravity.LEFT) == android.view.Gravity.LEFT;
    }

    private void clearPedidoLocal() {
        implPedido.newPedido();
        implPedido.ResetDetalle();
        pedidoUI.drawDetailPedido(implPedido);
        persistCache();
        notifyPedidoChanged();
        new NewPedidoTask().execute();
    }

    private void applyFlagComprobanteFromCabecera() {
        if (implPedido == null || implPedido.getCabecera() == null) return;
        String flag = implPedido.getCabecera().getFlagBoletaFactura();
        if ("B".equals(flag)) rbBoleta.setChecked(true);
        else if ("F".equals(flag)) rbFactura.setChecked(true);
        else if ("N".equals(flag)) rbNotaVenta.setChecked(true);
    }

    public void resetAfterSuccessfulSave() {
        try {
            implPedido.newPedido();
            implPedido.ResetDetalle();
            pedidoUI.drawDetailPedido(implPedido);
            rbFactura.setChecked(false);
            rbBoleta.setChecked(false);
            rbNotaVenta.setChecked(false);
            rgFlagFacturaBoleta.clearCheck();
            ResetListaArticulos();
            etFiltro.requestFocus();
            persistCache();
            notifyPedidoChanged();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }


    private void InitControllers() {
        ViewBinder binder = new ViewBinder(rootView);
        etFiltro = binder.require(R.id.etFiltro, "etFiltro");
        llBusqueda = binder.require(R.id.llBusqueda, "llBusqueda");
        View drawerCandidate = rootView.findViewById(R.id.drawerArticulos);
        drawerArticulos = drawerCandidate instanceof DrawerLayout
                ? (DrawerLayout) drawerCandidate
                : null;
        ibMenuArticulos = rootView.findViewById(R.id.ibMenuArticulos);
        btnAddArticulo = rootView.findViewById(R.id.btnAddArticulo);
        tvTotalRegistros = binder.require(R.id.tvTotalRegistros, "tvTotalRegistros");
        tvMonedaIGV = binder.require(R.id.tvMonedaIGV, "tvMonedaIGV");
        tvMonedaBI = binder.require(R.id.tvMonedaBI, "tvMonedaBI");
        tvMonedaVta = binder.require(R.id.tvMonedaVta, "tvMonedaVta");
        tvCaption = binder.require(R.id.tvCaption, "tvCaption");
        rbFactura = binder.require(R.id.rbFactura, "rbFactura");
        rbBoleta = binder.require(R.id.rbBoleta, "rbBoleta");
        rbNotaVenta = binder.require(R.id.rbNotaVenta, "rbNotaVenta");
        btnBuscar = binder.require(R.id.btnBuscar, "btnBuscar");
        btnGrabar = binder.require(R.id.btnGrabar, "btnGrabar");
        btnSalir = binder.require(R.id.btnSalir, "btnSalir");
        btnLimpiarPedido = binder.require(R.id.btnLimpiarPedido, "btnLimpiarPedido");
        btnLecturaQR = binder.require(R.id.btnLecturaQR, "btnLecturaQR");
        ibOcultarBusqueda = binder.require(R.id.ibOcultarBusqueda, "ibOcultarBusqueda");
        btnMostrarBusqueda = binder.require(R.id.btnMostrarBusqueda, "btnMostrarBusqueda");
        rgFlagFacturaBoleta = binder.require(R.id.rgFlagFacturaBoleta, "rgFlagFacturaBoleta");
        lvListaArticulos = binder.require(R.id.lvListaArticulos, "lvListaArticulos");

        rgFlagFacturaBoleta.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                syncFlagComprobanteFromRadios();
                persistCache();
            }
        });

        ValidInputHelper.bindEditText(etFiltro, ValidInputHelper.notBlank());

        // Portrait: drawer de artículos. Landscape: dos columnas (drawer bloqueado).
        if (drawerArticulos != null) {
            if (isDrawerMode()) {
                drawerArticulos.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
                setBusquedaVisible(false);
                if (btnMostrarBusqueda != null) {
                    btnMostrarBusqueda.setVisibility(View.VISIBLE);
                }
            } else {
                drawerArticulos.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
                if (llBusqueda != null) {
                    llBusqueda.setVisibility(View.VISIBLE);
                }
                if (btnMostrarBusqueda != null) {
                    btnMostrarBusqueda.setVisibility(View.GONE);
                }
                // En dos columnas no tiene sentido "ocultar" la búsqueda.
                if (ibOcultarBusqueda != null) {
                    ibOcultarBusqueda.setVisibility(View.GONE);
                }
            }
        }
    }

    private void syncFlagComprobanteFromRadios() {
        if (implPedido == null || implPedido.getCabecera() == null) {
            return;
        }
        if (rbBoleta.isChecked()) {
            implPedido.getCabecera().setFlagBoletaFactura("B");
        } else if (rbFactura.isChecked()) {
            implPedido.getCabecera().setFlagBoletaFactura("F");
        } else if (rbNotaVenta.isChecked()) {
            implPedido.getCabecera().setFlagBoletaFactura("N");
        }
    }

    private void AsignarEventos() {
        ViewBinder binder = new ViewBinder(rootView);
        lvListaArticulos.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                try {
                    if (isDrawerMode()) {
                        setBusquedaVisible(false);
                    }
                    insertarPedido(articulos.get(position));
                } catch (Exception ex) {
                    ex.printStackTrace();
                    MessageBox.AlertDialog(
                            "Ha ocurrido un error al insertar un detalle al pedido. Exception: " + ex.getMessage(),
                            "Function insertarPedido", requireActivity());
                }
            }
        });

        binder.onClick(ibOcultarBusqueda, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setBusquedaVisible(false);
            }
        });
        View.OnClickListener openArticulos = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setBusquedaVisible(true);
            }
        };
        binder.onClick(btnMostrarBusqueda, openArticulos);
        if (ibMenuArticulos != null) {
            ibMenuArticulos.setOnClickListener(openArticulos);
        }
        if (btnAddArticulo != null) {
            btnAddArticulo.setOnClickListener(openArticulos);
        }
        binder.onClick(btnGrabar, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EventPreUpdate(view);
            }
        });
        binder.onClick(btnSalir, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                exitActivity();
            }
        });
        binder.onClick(btnLimpiarPedido, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LimpiarPedido(view);
            }
        });
        binder.onClick(btnLecturaQR, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                LecturaQR(view);
            }
        });
        binder.onClick(btnBuscar, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                runFiltroSafe();
            }
        });

        etFiltro.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode == EditorInfo.IME_ACTION_SEARCH
                        || keyCode == EditorInfo.IME_ACTION_DONE
                        || (event.getAction() == KeyEvent.ACTION_DOWN
                        && event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {
                    runFiltroSafe();
                }
                return false;
            }
        });
    }

    private void runFiltroSafe() {
        try {
            Filtrar();
        } catch (Exception ex) {
            UTIL.SonidoError(requireActivity());
            MessageBox.AlertDialog(requireActivity(), "Error en Busqueda por Filtro", ex.getMessage(), false);
        }
    }

    private void LecturaQR(View view) {
        new DialogLecturaQR(this).openDialog();
    }

    /** Abre el escáner de cámara (QR / código de barras). */
    public void startCameraScan() {
        IntentIntegrator integrator = IntentIntegrator.forSupportFragment(this);
        integrator.setDesiredBarcodeFormats(IntentIntegrator.ALL_CODE_TYPES);
        integrator.setPrompt("Escanee el código de barras o QR del artículo");
        integrator.setBeepEnabled(true);
        integrator.setOrientationLocked(false);
        integrator.setBarcodeImageEnabled(false);
        integrator.initiateScan();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            if (result.getContents() != null && !result.getContents().trim().isEmpty()) {
                new DialogLecturaQR(this).processCodigo(result.getContents().trim());
            } else {
                MessageBox.AlertDialog(requireActivity(), "Lectura de código",
                        "Escaneo cancelado o sin datos.", false);
            }
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void exitActivity() {
        requireActivity().startActivity(new Intent(requireActivity(), HomeActivity.class));
        requireActivity().finish();
    }

    @Override
    public void onResume() {
        super.onResume();
        bPrimeraVez = false;
        if (implPedido != null) {
            final GlobalClass globalVariable = (GlobalClass) requireActivity().getApplicationContext();
            globalVariable.setImplPedido(implPedido);
        }
    }

    public void insertarPedido(BeanArticulo value) throws Exception {
        //this.articuloSelected = value;
        new DialogAddPedido(this).openDialog(value);
    }

    public void Filtrar() throws Exception {
        final String lsFiltro = etFiltro.getText().toString().trim();
        if (lsFiltro.equals("")) {
            ConfirmDialog.ask(requireActivity(),
                    "Mostrar todos los registros",
                    "¿ Desea mostrar todos los registros?. Tener en cuenta que dicha carga va a demandar mucho tiempo.",
                    "SI", "NO",
                    new ConfirmDialog.Action() {
                        @Override
                        public void run() {
                            launchSearchArticulos(lsFiltro);
                        }
                    },
                    null);
            return;
        }
        launchSearchArticulos(lsFiltro);
    }

    private void launchSearchArticulos(String filtro) {
        UTIL.OcultarTeclado(requireActivity(), btnBuscar);
        new SearchArticulosTask(filtro).execute(ImplArticulo.ACTION_FILTRAR_ARTICULOS);
    }

    public void EventPreUpdate(View view) {

        //Validaciones
        if (!rbFactura.isChecked() && !rbBoleta.isChecked() && !rbNotaVenta.isChecked()){
            MessageBox.AlertDialog("Debe seleccionar si desea factura, boleta o Nota de Venta", "Advertencia", requireActivity());
            return;
        }
        if (implPedido.getDetalle().size() == 0){
            MessageBox.AlertDialog("El pedido debe tener al menos un registro para ser grabado", "Advertencia", requireActivity());
            return;
        }

        syncFlagComprobanteFromRadios();
        implPedido.getCabecera().setMoneda(ImplEmpresa.beanParametros.getSoles());
        implPedido.getCabecera().setTasaCambio(ldcTasaCambio);
        implPedido.getCabecera().setVendedor(userLogin.getUsuario());
        implPedido.getCabecera().setCodUsuario(userLogin.getUsuario());

        if ("0".equals(ImplEmpresa.beanParametros.getSolicitarCliente())) {
            SavePedido();
        } else {
            new DialogAddClientePedido(this).openDialog();
        }
    }

    public void SavePedido() {
        ConfirmDialog.ask(requireActivity(),
                "Cancelación de Pedido",
                "¿ Desea GRABAR el pedido el cual contiene " + implPedido.getDetalle().size()
                        + " registros? \r\nTotal Pedido: "
                        + UTIL.ConvetToString(implPedido.getTotalVenta(), "###,##0.00"),
                "Si", "No",
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        new PedidoSaveTask().execute();
                    }
                },
                null);
    }

    public void LimpiarPedido(View view) {
        if (implPedido.getDetalle().size() == 0) {
            clearPedidoLocal();
            return;
        }
        ConfirmDialog.ask(requireActivity(),
                "Cancelación de Pedido",
                "¿ Desea Limpiar el pedido generado de " + implPedido.getDetalle().size() + " registros?",
                "Si", "No",
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        clearPedidoLocal();
                    }
                },
                null);
    }

    private void ResetListaArticulos(){
        if(articulos == null){
            articulos = new ArrayList<BeanArticulo>();
        }else{
            articulos.clear();
        }
        //Elimino el texto del filtro
        etFiltro.setText("");

        adaptador = new ListViewArticulosAdapter(this, articulos);
        lvListaArticulos.setAdapter(adaptador);

        tvTotalRegistros.setText(UTIL.ConvetToString(articulos.size(), "###,##0"));
    }

    public void clickLayout(View view){
        UTIL.OcultarTeclado(requireActivity(), btnBuscar);
    }

    //Clase Asincrona para tareas en segundo plano
    private class SearchArticulosTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplArticulo implArticulo = null;
        Integer liAccion;
        private ProgressDialog pDialog;
        private String lsFiltro;

        private SearchArticulosTask()
        {

        }

        public SearchArticulosTask(String filtro){
            lsFiltro = filtro;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = SafeProgress.show(requireActivity(),
                    "Buscando Información según Filtro [" + lsFiltro + "] por favor espere...");
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            liAccion = params[0];

            //Accion para cargar datos
            if (liAccion == implArticulo.ACTION_FILTRAR_ARTICULOS) {
                try {
                    if(ImplEmpresa.empresaDefault == null)
                    {
                        mensaje = "No se ha especificado la empresa por defecto";
                        return false;
                    }

                    //LLenado de Lista para los articulos
                    implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());
                    articulos = implArticulo.getByFiltro(lsFiltro.trim());

                    return true;

                } catch (Exception ex) {
                    mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                    ex.printStackTrace();
                    return false;
                } finally {
                    implArticulo = null;
                }
            }

            mensaje = "Accion no definida en PedidoActivityTask " + String.valueOf(liAccion) + ". Por favor verifique!";
            return false;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                bPrimeraVez = false;

                if (liAccion == ImplArticulo.ACTION_FILTRAR_ARTICULOS) {
                    if (articulos.size() == 0) {
                        MessageBox.AlertDialog("No existen artículos que cumplan con el criterio ingresado", "Error", requireActivity());
                        return;
                    }

                    //Elimino el texto del filtro
                    etFiltro.setText("");

                    adaptador = new ListViewArticulosAdapter(PedidoTabFragment.this, articulos);
                    lvListaArticulos.setAdapter(adaptador);

                    tvTotalRegistros.setText(UTIL.ConvetToString(articulos.size(), "###,##0"));

                    //Oculto el teclado
                    UTIL.OcultarTeclado(requireActivity(), lvListaArticulos);

                    //Le pongo el foco a la lista de articulos
                    lvListaArticulos.requestFocus();


                } else {
                    Toast.makeText(requireActivity(), mensaje, Toast.LENGTH_LONG).show();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                SafeProgress.dismiss(pDialog);
            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class PedidoSaveTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        private ProgressDialog pDialog;
        private ImplTasaCambio implTasaCambio;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = SafeProgress.show(requireActivity(), "Grabando la información, por favor espere...");
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //Creo los objetos
                implTasaCambio = new ImplTasaCambio(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo el tasa de Cambio
                ldcTasaCambio = implTasaCambio.getTasaCambio();

                //LLenado de Lista para los cursos
                implPedido.getCabecera().setTasaCambio(ldcTasaCambio);
                implPedido.Update();

                return true;

            } catch (Exception ex) {
                mensaje = "Error al grabar pedido: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally{
                implTasaCambio = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    final String nroPedido = implPedido.getNroPedido();
                    tvCaption.setText("ULTIMA PROFORMA GENERADA: " + nroPedido);
                    if (hostActivity != null) {
                        hostActivity.onPedidoGrabadoOk(PedidoTabFragment.this, nroPedido);
                    } else {
                        MessageBox.AlertDialog("Pedido grabado satisfactoriamente. Nro Pedido: " + nroPedido, "Aviso", requireActivity());
                        resetAfterSuccessfulSave();
                    }
                } else {
                    Toast.makeText(requireActivity(), mensaje, Toast.LENGTH_LONG).show();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                SafeProgress.dismiss(pDialog);
            }

        }

    }

    //Clase Asincrona para crear un nuevo pedido
    private class NewPedidoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        private ProgressDialog pDialog;
        private ImplTasaCambio implTasaCambio;

        private NewPedidoTask()
        {

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = SafeProgress.show(requireActivity(),
                    "Un momento, estoy limpiando el PEDIDO, por favor espere...");
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {

                //Creo los objetos
                implTasaCambio = new ImplTasaCambio(ImplEmpresa.empresaDefault.getCodigo());

                //Obtengo el tasa de Cambio
                ldcTasaCambio = implTasaCambio.getTasaCambio();

                return true;

            } catch (Exception ex) {
                ex.printStackTrace();
                mensaje = "Ha ocurrido una exception al recuperar datos necesarios. Error: " + ex.getMessage();
                return false;

            } finally {
                implTasaCambio = null;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (!result) {
                    MessageBox.AlertDialog(requireActivity(), "Error en NewPedidoTask()", mensaje, false);
                    return;
                }
                String soles = ImplEmpresa.beanParametros.getSoles();
                tvMonedaBI.setText(soles);
                tvMonedaIGV.setText(soles);
                tvMonedaVta.setText(soles);
                implPedido.getCabecera().setTasaCambio(ldcTasaCambio);
                ResetListaArticulos();
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                SafeProgress.dismiss(pDialog);
                pDialog = null;
            }
        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class SearchPedidoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        private ProgressDialog pDialog;

        private SearchPedidoTask()
        {

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = SafeProgress.show(requireActivity(),
                    "Abriendo Proforma [" + proformaSelected.getNroProforma() + "] por favor espere...");
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                implPedido.searchPedido(proformaSelected.getNroProforma());
                return true;
            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                tvCaption.setText("PROFORMA : " + implPedido.getCabecera().getNroProforma());
                refreshPedidoUi(true);
                PedidoTabState state = hostActivity.getTabState(tabId);
                if (state != null) {
                    state.proformaLoaded = true;
                    state.proformaToLoad = null;
                }
                persistCache();
                notifyPedidoChanged();
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                SafeProgress.dismiss(pDialog);
            }
        }
    }

}
