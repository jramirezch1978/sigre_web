package pe.com.hermes.appmobile.ui.empresa;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.bienvenida.BienvenidaActivity;
import pe.com.hermes.appmobile.util.AppUtils;

/** Segundo paso del login: elegir empresa y, si tiene mas de una, sucursal (el backend siempre
 * requiere ambos IDs para /seleccionar-empresa — nunca se puede saltar este paso). */
public class SeleccionEmpresaActivity extends AppCompatActivity {

    private ActivityGenericListBinding binding;
    private AuthRepository authRepository;
    private SimpleListAdapter adapter;

    private List<EmpresaUsuarioDto> empresas = Collections.emptyList();
    private EmpresaUsuarioDto empresaElegida;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGenericListBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        binding.toolbar.setTitle(getString(R.string.empresa_titulo));
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SimpleListAdapter(this::onItemClick);
        binding.recyclerView.setAdapter(adapter);
        binding.swipeRefresh.setOnRefreshListener(this::cargarEmpresas);

        cargarEmpresas();
    }

    private void onItemClick(SimpleItem item) {
        if (empresaElegida == null) {
            EmpresaUsuarioDto empresa = null;
            for (EmpresaUsuarioDto e : empresas) {
                if (e.empresaId == item.id) { empresa = e; break; }
            }
            if (empresa == null) return;
            empresaElegida = empresa;
            cargarSucursales(empresa);
        } else {
            seleccionarSucursal(item.id);
        }
    }

    private void cargarEmpresas() {
        mostrarCargando(true);
        authRepository.listarEmpresas(new ResultCallback<List<EmpresaUsuarioDto>>() {
            @Override
            public void onSuccess(List<EmpresaUsuarioDto> lista) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                empresas = lista;
                List<SimpleItem> items = new ArrayList<>();
                for (EmpresaUsuarioDto e : lista) {
                    String titulo = e.razonSocial != null ? e.razonSocial : (e.codigo != null ? e.codigo : "Empresa " + e.empresaId);
                    items.add(new SimpleItem(e.empresaId, titulo, e.ruc));
                }
                adapter.actualizar(items);
                mostrarVacio(lista.isEmpty(), "No tiene empresas asignadas.");
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                binding.swipeRefresh.setRefreshing(false);
                AppUtils.toast(SeleccionEmpresaActivity.this, mensaje != null ? mensaje : "No se pudieron cargar las empresas");
            }
        });
    }

    private void cargarSucursales(EmpresaUsuarioDto empresa) {
        binding.toolbar.setTitle(getString(R.string.empresa_sucursal_titulo));
        mostrarCargando(true);
        authRepository.listarSucursales(empresa.empresaId, new ResultCallback<List<SucursalDto>>() {
            @Override
            public void onSuccess(List<SucursalDto> sucursales) {
                mostrarCargando(false);
                if (sucursales.isEmpty()) {
                    AppUtils.toast(SeleccionEmpresaActivity.this, "La empresa no tiene sucursales asignadas.");
                    return;
                }
                if (sucursales.size() == 1) {
                    seleccionarSucursal(sucursales.get(0).id);
                    return;
                }
                List<SimpleItem> items = new ArrayList<>();
                for (SucursalDto s : sucursales) {
                    items.add(new SimpleItem(s.id, s.nombre != null ? s.nombre : (s.codigo != null ? s.codigo : "Sucursal " + s.id)));
                }
                adapter.actualizar(items);
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(SeleccionEmpresaActivity.this, mensaje != null ? mensaje : "No se pudieron cargar las sucursales");
            }
        });
    }

    private void seleccionarSucursal(long sucursalId) {
        if (empresaElegida == null) return;
        mostrarCargando(true);
        authRepository.seleccionarEmpresa(empresaElegida.empresaId, sucursalId, new ResultCallback<LoginResponse>() {
            @Override
            public void onSuccess(LoginResponse data) {
                mostrarCargando(false);
                startActivity(new Intent(SeleccionEmpresaActivity.this, BienvenidaActivity.class));
                finish();
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(SeleccionEmpresaActivity.this, mensaje != null ? mensaje : "No se pudo completar el acceso");
            }
        });
    }

    private void mostrarCargando(boolean cargando) {
        binding.progressBar.setVisibility(cargando ? View.VISIBLE : View.GONE);
    }

    private void mostrarVacio(boolean vacio, String mensaje) {
        binding.tvVacio.setText(mensaje);
        binding.tvVacio.setVisibility(vacio ? View.VISIBLE : View.GONE);
    }
}
