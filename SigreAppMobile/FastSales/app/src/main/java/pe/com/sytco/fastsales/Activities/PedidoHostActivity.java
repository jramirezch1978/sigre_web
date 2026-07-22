package pe.com.sytco.fastsales.Activities;

import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import java.util.ArrayList;

import com.google.android.material.tabs.TabLayout;

import pe.com.sytco.fastsales.Activities.RRHH.RrhhUiHelper;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanEmpresa;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.pedido.PedidoLayoutInflater;
import pe.com.sytco.fastsales.pedido.PedidoTabManager;
import pe.com.sytco.fastsales.pedido.PedidoTabState;
import pe.com.sytco.fastsales.util.ConfirmDialog;
import pe.com.sytco.fastsales.util.LogHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ViewBinder;

/**
 * Host multipestaña de tomapedidos (Controller UI).
 * La lógica de pestañas/caché vive en {@link PedidoTabManager}.
 */
public class PedidoHostActivity extends AppCompatActivity {

    private PedidoTabManager tabManager;
    private PedidoTabsAdapter tabsAdapter;
    private ViewPager viewPager;
    private TabLayout tabLayout;
    private ImageButton btnTabScrollLeft;
    private ImageButton btnTabScrollRight;
    /** Última orientación por tamaño de ventana (para MEmu / resize). */
    private Boolean lastWindowLandscape;

    private static final String STATE_TAB_IDS = "pedido_host_tab_ids";
    private static final String STATE_TAB_TITLES = "pedido_host_tab_titles";
    private static final String STATE_CURRENT_TAB = "pedido_host_current_tab";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // fullSensor: sigue al sensor; no es bloqueo (Play pide quitar solo PORTRAIT/LANDSCAPE fijos).
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_FULL_SENSOR);

        // Guardamos solo nuestros datos de pestañas. NO pasamos savedInstanceState a
        // super.onCreate: si FM restaura PedidoTabFragment viejos (sobre todo pestañas
        // vacías no cacheadas), aparece "Estado de pestaña no encontrado".
        final ArrayList<String> restoredTabIds;
        final ArrayList<String> restoredTabTitles;
        final int restoredCurrentTab;
        if (savedInstanceState != null) {
            restoredTabIds = savedInstanceState.getStringArrayList(STATE_TAB_IDS);
            restoredTabTitles = savedInstanceState.getStringArrayList(STATE_TAB_TITLES);
            restoredCurrentTab = savedInstanceState.getInt(STATE_CURRENT_TAB, 0);
        } else {
            restoredTabIds = null;
            restoredTabTitles = null;
            restoredCurrentTab = 0;
        }
        super.onCreate(null);

        try {
            ensureEmpresaDefault();
            if (ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }

            setContentView(R.layout.activity_pedido_host);
            RrhhUiHelper.setupScreen(this);
            setupTitleBar();

            tabManager = new PedidoTabManager(this);
            bootstrapTabs(restoredTabIds, restoredTabTitles);
            bindPagerAndChrome(restoredCurrentTab);
            watchWindowAspectForLayout();
        } catch (Exception e) {
            e.printStackTrace();
            MessageBox.AlertDialog(this, "Ha ocurrido un error",
                    "Mensaje de Error: " + e.getMessage(), false);
        }
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        // Persistimos pestañas (incl. vacías) antes de que Android mate la Activity.
        persistAllTabsBeforeRecreate();
        super.onSaveInstanceState(outState);
        if (tabManager == null) {
            return;
        }
        ArrayList<String> ids = new ArrayList<>();
        ArrayList<String> titles = new ArrayList<>();
        for (PedidoTabState state : tabManager.getTabs()) {
            ids.add(state.tabId);
            titles.add(state.title != null ? state.title : "Pedido");
        }
        outState.putStringArrayList(STATE_TAB_IDS, ids);
        outState.putStringArrayList(STATE_TAB_TITLES, titles);
        if (viewPager != null) {
            outState.putInt(STATE_CURRENT_TAB, viewPager.getCurrentItem());
        }
    }

    /**
     * Si el emulador solo cambia el tamaño de ventana (sin Configuration.orientation),
     * recreamos la Activity para cargar layout-land / portrait.
     */
    private void watchWindowAspectForLayout() {
        final View content = findViewById(android.R.id.content);
        if (content == null) {
            return;
        }
        lastWindowLandscape = PedidoLayoutInflater.isLandscapeWindow(this);
        content.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    @Override
                    public void onGlobalLayout() {
                        boolean land = content.getWidth() > 0 && content.getHeight() > 0
                                && content.getWidth() > content.getHeight();
                        if (lastWindowLandscape != null && lastWindowLandscape == land) {
                            return;
                        }
                        Boolean previous = lastWindowLandscape;
                        lastWindowLandscape = land;
                        if (previous == null) {
                            return;
                        }
                        LogHelper.i("PedidoHostActivity",
                                "Cambio aspect ventana land=" + land + " → recreate()");
                        content.post(new Runnable() {
                            @Override
                            public void run() {
                                if (!isFinishing()) {
                                    persistAllTabsBeforeRecreate();
                                    recreate();
                                }
                            }
                        });
                    }
                });
    }

    private void persistAllTabsBeforeRecreate() {
        if (tabManager == null || tabsAdapter == null) {
            return;
        }
        try {
            for (int i = 0; i < tabManager.size(); i++) {
                PedidoTabState state = tabManager.getTabs().get(i);
                PedidoTabFragment fragment = tabsAdapter.getFragment(i);
                if (fragment != null && fragment.getImplPedido() != null) {
                    state.pedido = fragment.getImplPedido();
                }
                if (state.pedido != null && state.pedido.getCabecera() == null) {
                    state.pedido.newPedido();
                }
                tabManager.persist(state, i);
            }
        } catch (Exception ex) {
            LogHelper.e("PedidoHostActivity", "No se pudo persistir pestañas antes de recreate", ex);
        }
    }

    private void setupTitleBar() {
        TextView tvHeader = findViewById(R.id.tvNombreEmpresaRrhh);
        if (tvHeader == null || ImplEmpresa.empresaDefault == null) {
            return;
        }
        BeanUsuario userLogin = ((GlobalClass) getApplicationContext()).getUserLogin();
        String empresa = ImplEmpresa.empresaDefault.getCodigo();
        if (userLogin == null) {
            tvHeader.setText("EMPRESA: " + empresa);
            return;
        }
        tvHeader.setText("EMPRESA: " + empresa
                + " · " + userLogin.getNombre()
                + " · Ingreso: "
                + UTIL.parseSqlDatetoString(userLogin.getFecLogin()));
    }

    private void bootstrapTabs(@Nullable ArrayList<String> restoredTabIds,
                               @Nullable ArrayList<String> restoredTabTitles) throws Exception {
        try {
            // Si venimos de recreate, reconstruir EN EL MISMO ORDEN (vacías + con ítems).
            if (restoredTabIds != null && !restoredTabIds.isEmpty()) {
                tabManager.restoreSession(restoredTabIds, restoredTabTitles);
            } else {
                tabManager.restoreFromCache();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            Toast.makeText(this, "No se pudieron restaurar pestañas: " + ex.getMessage(),
                    Toast.LENGTH_LONG).show();
        }

        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            BeanProforma proforma = (BeanProforma) bundle.getSerializable("proformaSelected");
            if (proforma != null) {
                if (tabManager.canAddTab()) {
                    tabManager.addProforma(proforma);
                } else {
                    Toast.makeText(this, "Máximo " + PedidoTabManager.MAX_TABS
                            + " pestañas permitidas", Toast.LENGTH_SHORT).show();
                }
            }
        }
        tabManager.ensureAtLeastOne();
    }

    private void bindPagerAndChrome(int restoredCurrentTab) {
        viewPager = findViewById(R.id.viewpager);
        tabsAdapter = new PedidoTabsAdapter(getSupportFragmentManager());
        for (PedidoTabState state : tabManager.getTabs()) {
            tabsAdapter.addTab(PedidoTabFragment.newInstance(state.tabId, state.title), state.title);
        }
        viewPager.setAdapter(tabsAdapter);

        tabLayout = findViewById(R.id.tabs);
        tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);
        tabLayout.setupWithViewPager(viewPager);
        attachTabLongClickListeners();
        bindTabScrollControls();

        if (restoredCurrentTab >= 0 && restoredCurrentTab < tabManager.size()) {
            viewPager.setCurrentItem(restoredCurrentTab, false);
        }

        ViewBinder binder = new ViewBinder(findViewById(android.R.id.content));
        Button btnAddTab = findViewById(R.id.btnAddTab);
        Button btnCloseTab = findViewById(R.id.btnCloseTab);
        binder.onClick(btnAddTab, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                addTabFromUi();
            }
        });
        binder.onClick(btnCloseTab, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmCloseTab(viewPager.getCurrentItem());
            }
        });
    }

    private void bindTabScrollControls() {
        btnTabScrollLeft = findViewById(R.id.btnTabScrollLeft);
        btnTabScrollRight = findViewById(R.id.btnTabScrollRight);
        if (btnTabScrollLeft == null || btnTabScrollRight == null || tabLayout == null) {
            return;
        }

        final int scrollStepDp = 140;
        final float density = getResources().getDisplayMetrics().density;
        final int scrollStepPx = Math.max((int) (scrollStepDp * density), 80);

        btnTabScrollLeft.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                tabLayout.smoothScrollBy(-scrollStepPx, 0);
                tabLayout.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        updateTabScrollArrows();
                    }
                }, 180);
            }
        });
        btnTabScrollRight.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                tabLayout.smoothScrollBy(scrollStepPx, 0);
                tabLayout.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        updateTabScrollArrows();
                    }
                }, 180);
            }
        });

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                updateTabScrollArrows();
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {
            }
        });

        tabLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    @Override
                    public void onGlobalLayout() {
                        updateTabScrollArrows();
                    }
                });
        updateTabScrollArrows();
    }

    private void updateTabScrollArrows() {
        if (tabLayout == null || btnTabScrollLeft == null || btnTabScrollRight == null) {
            return;
        }
        tabLayout.post(new Runnable() {
            @Override
            public void run() {
                View strip = tabLayout.getChildCount() > 0 ? tabLayout.getChildAt(0) : null;
                int contentWidth = strip != null ? strip.getWidth() : 0;
                int viewport = tabLayout.getWidth();
                int scrollX = tabLayout.getScrollX();
                int maxScroll = Math.max(0, contentWidth - viewport);
                boolean overflow = maxScroll > 2;

                btnTabScrollLeft.setEnabled(overflow && scrollX > 2);
                btnTabScrollRight.setEnabled(overflow && scrollX < maxScroll - 2);
                btnTabScrollLeft.setAlpha(btnTabScrollLeft.isEnabled() ? 1f : 0.35f);
                btnTabScrollRight.setAlpha(btnTabScrollRight.isEnabled() ? 1f : 0.35f);
            }
        });
    }

    /**
     * Si el proceso murió y reinició la Activity, el static empresaDefault se pierde.
     * Se recupera desde preferencias (misma fuente que el login).
     */
    void ensureEmpresaDefault() {
        if (ImplEmpresa.empresaDefault != null) {
            return;
        }
        try {
            ImplEmpresa implEmpresa = new ImplEmpresa(this);
            BeanEmpresa stored = implEmpresa.loadEmpresaFromPreferences();
            if (stored != null) {
                ImplEmpresa.empresaDefault = stored;
                LogHelper.i("PedidoHostActivity",
                        "Empresa restaurada desde preferencias: " + stored.getCodigo());
            }
        } catch (Exception ex) {
            LogHelper.e("PedidoHostActivity", "No se pudo restaurar empresa", ex);
        }
    }

    private void addTabFromUi() {
        try {
            ensureEmpresaDefault();
            if (ImplEmpresa.empresaDefault == null) {
                MessageBox.AlertDialog(this, "Ha ocurrido un error",
                        "Mensaje de Error: No se ha especificado la empresa", false);
                return;
            }
            if (!tabManager.canAddTab()) {
                Toast.makeText(this, "Máximo " + PedidoTabManager.MAX_TABS
                        + " pestañas permitidas", Toast.LENGTH_SHORT).show();
                return;
            }
            PedidoTabState state = tabManager.addEmpty();
            LogHelper.i("PedidoHostActivity",
                    "Nueva pestaña: " + state.tabId + " / " + state.title);
            tabsAdapter.addTab(PedidoTabFragment.newInstance(state.tabId, state.title), state.title);
            viewPager.setCurrentItem(tabManager.size() - 1);
            attachTabLongClickListeners();
            updateTabScrollArrows();
        } catch (Exception ex) {
            LogHelper.e("PedidoHostActivity", "Error al añadir pestaña", ex);
            MessageBox.AlertDialog(this, "Ha ocurrido un error",
                    "Mensaje de Error: " + ex.getMessage(), false);
        }
    }

    public PedidoTabState getTabState(String tabId) {
        return tabManager.getById(tabId);
    }

    public PedidoTabState ensureTabState(String tabId, String title) {
        return tabManager.ensureById(tabId, title);
    }

    public void persistTab(PedidoTabFragment fragment) {
        syncTitleAndMaybePersist(fragment, true);
    }

    public void onTabPedidoChanged(PedidoTabFragment fragment) {
        syncTitleAndMaybePersist(fragment, false);
    }

    private void syncTitleAndMaybePersist(PedidoTabFragment fragment, boolean persist) {
        PedidoTabState state = tabManager.getById(fragment.getTabId());
        if (state == null) {
            return;
        }
        String title = tabManager.refreshTitle(state, fragment.getImplPedido());
        int index = tabsAdapter.indexOfTabId(fragment.getTabId());
        if (index < 0) {
            return;
        }
        tabsAdapter.updateTitle(index, title);
        if (tabLayout != null) {
            TabLayout.Tab tab = tabLayout.getTabAt(index);
            if (tab != null) {
                tab.setText(title);
            }
        }
        if (persist) {
            tabManager.persist(state, index);
        }
        attachTabLongClickListeners();
        updateTabScrollArrows();
    }

    public void onPedidoGrabadoOk(final PedidoTabFragment fragment, final String nroPedido) {
        tabManager.deleteCache(fragment.getTabId());
        new AlertDialog.Builder(this)
                .setTitle("Aviso")
                .setMessage("Pedido grabado satisfactoriamente. Nro Pedido: " + nroPedido)
                .setCancelable(false)
                .setPositiveButton("OK", new android.content.DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(android.content.DialogInterface dialog, int which) {
                        askCloseTabAfterSave(fragment);
                    }
                })
                .show();
    }

    private void askCloseTabAfterSave(final PedidoTabFragment fragment) {
        ConfirmDialog.ask(this, "Cerrar pestaña", "¿Desea cerrar esta pestaña?",
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        int index = tabsAdapter.indexOfTabId(fragment.getTabId());
                        if (index >= 0) {
                            removeTabAt(index);
                        }
                    }
                },
                new ConfirmDialog.Action() {
                    @Override
                    public void run() {
                        fragment.resetAfterSuccessfulSave();
                    }
                });
    }

    private void confirmCloseTab(final int index) {
        if (index < 0 || index >= tabManager.size()) {
            return;
        }
        PedidoTabState state = tabManager.getTabs().get(index);
        ConfirmDialog.Action close = new ConfirmDialog.Action() {
            @Override
            public void run() {
                removeTabAt(index);
            }
        };
        if (state.hasItems()) {
            ConfirmDialog.ask(this, "Cerrar pestaña",
                    "¿Desea descartar los cambios de esta pestaña?", close);
        } else {
            close.run();
        }
    }

    private void removeTabAt(int index) {
        tabManager.removeAt(index);
        tabsAdapter.removeTabAt(index);
        attachTabLongClickListeners();

        if (tabManager.size() == 0) {
            PedidoTabState state = tabManager.addEmpty();
            tabsAdapter.addTab(PedidoTabFragment.newInstance(state.tabId, state.title), state.title);
        }
        int newIndex = Math.min(index, tabManager.size() - 1);
        if (newIndex >= 0) {
            viewPager.setCurrentItem(newIndex);
        }
        updateTabScrollArrows();
    }

    private void attachTabLongClickListeners() {
        if (tabLayout == null) {
            return;
        }
        tabLayout.post(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < tabLayout.getTabCount(); i++) {
                    TabLayout.Tab tab = tabLayout.getTabAt(i);
                    if (tab == null || tab.view == null) {
                        continue;
                    }
                    final int tabIndex = i;
                    tab.view.setOnLongClickListener(new View.OnLongClickListener() {
                        @Override
                        public boolean onLongClick(View v) {
                            confirmCloseTab(tabIndex);
                            return true;
                        }
                    });
                }
            }
        });
    }
}
