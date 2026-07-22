package pe.com.sytco.fastsales.Activities;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;

import com.google.android.material.navigation.NavigationView;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.UTIL;

public class LeftMenuActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private TextView tvUsuarioLogueado, tvEmail;
    private TextView tvNombreEmpresaMenu;
    private ImageView ivLogoEmpresaMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_left_menu);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        
        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        
        // Obtener el header del NavigationView
        View headerView = navigationView.getHeaderView(0);
        
        // Inicializar las vistas del header
        tvUsuarioLogueado = headerView.findViewById(R.id.tvUsuarioLogueado);
        tvEmail = headerView.findViewById(R.id.tvEmail);
        tvNombreEmpresaMenu = headerView.findViewById(R.id.tvNombreEmpresaMenu);
        ivLogoEmpresaMenu = headerView.findViewById(R.id.ivLogoEmpresaMenu);

        // Cargar información del usuario
        tvUsuarioLogueado.setText(UTIL.getGlobalClass(this).getUserLogin().getNombre());
        tvEmail.setText(UTIL.getGlobalClass(this).getUserLogin().getEmail());
        
        // Cargar información de la empresa
        cargarInformacionEmpresa();

        /*FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });*/

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();
    }
    
    /**
     * Carga la información de la empresa (logo y nombre) en el menú lateral
     */
    private void cargarInformacionEmpresa() {
        try {
            if (ImplEmpresa.empresaDefault != null) {
                // Mostrar nombre de empresa
                tvNombreEmpresaMenu.setText(ImplEmpresa.empresaDefault.getRazonSocial());
                
                // Cargar logo desde Base64 si existe
                if (ImplEmpresa.empresaDefault.getLogoBase64() != null && 
                    !ImplEmpresa.empresaDefault.getLogoBase64().isEmpty()) {
                    try {
                        byte[] decodedString = Base64.decode(ImplEmpresa.empresaDefault.getLogoBase64(), Base64.DEFAULT);
                        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                        ivLogoEmpresaMenu.setImageBitmap(decodedByte);
                    } catch (Exception e) {
                        android.util.Log.e("LeftMenu", "Error al cargar logo: " + e.getMessage());
                        // Si falla, usar logo por defecto
                        ivLogoEmpresaMenu.setImageResource(R.drawable.icono_empresa);
                    }
                } else {
                    // Si no tiene logo, usar icono por defecto
                    ivLogoEmpresaMenu.setImageResource(R.drawable.icono_empresa);
                }
            }
        } catch (Exception e) {
            android.util.Log.e("LeftMenu", "Error en cargarInformacionEmpresa: " + e.getMessage());
        }
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.left_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.salir) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_camera) {
            // Handle the camera action
        } else if (id == R.id.nav_gallery) {

        } else if (id == R.id.nav_slideshow) {

        } else if (id == R.id.nav_manage) {

        } else if (id == R.id.nav_share) {

        } else if (id == R.id.nav_send) {

        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
}
