package pe.com.sytco.fastsales.Global;

import android.app.Activity;
import android.app.Application;
import android.util.Log;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplListadoCajas;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.Controller.ImplServerRemote;
import pe.com.sytco.fastsales.Services.GlobalTimeSyncService;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.data.PingHistoryDbHelper;
import pe.com.sytco.fastsales.util.EdgeToEdgeHelper;

/**
 * Created by jramirez on 05/04/2016.
 */
public class GlobalClass extends Application {

    private static final String TAG = "GlobalClass";
    
    private BeanUsuario userLogin;
    private ImplPedido implPedido;
    private String editPassword;
    private ImplServerRemote implServerRemote;
    private Activity myActivity;

    //Empresa
    private ImplEmpresa _implEmpresa;

    //Listado de cajas
    private ImplListadoCajas _implListadoCajas;
    
    // Servicio global de sincronización de hora
    private GlobalTimeSyncService timeSyncService;

    public static int CONNECT_DATABASE_DIRECT = 1;
    public static int CONNECT_SOAP = 2;

    //Tipo de Conexion elegida, sería en este caso soap
    public static int CHOISE_CONNECT = 1;

    //Aplicacion Prueba o Test
    public static int CHOISE_ENVIROMENT = 1;

    public static int ENVIROMENT_PROD = 1;
    public static int ENVIROMENT_TEST = 2;
    public static int ENVIROMENT_LOCAL = 3;

    @Override
    public void onCreate() {
        super.onCreate();
        
        Log.i(TAG, "=== INICIALIZACIÓN DE APLICACIÓN ===");
        
        // Inicializar la base de datos de historial de pings
        // Esto crea la tabla automáticamente si no existe
        try {
            PingHistoryDbHelper.getInstance(this);
            Log.i(TAG, "Base de datos de historial de pings inicializada correctamente");
        } catch (Exception e) {
            Log.e(TAG, "Error al inicializar la base de datos de pings", e);
        }

        // Edge-to-edge global (Play / Android 15): sin setStatusBarColor / setNavigationBarColor.
        registerActivityLifecycleCallbacks(new EdgeToEdgeHelper.LifecycleCallbacks());
        
        Log.i(TAG, "=== APLICACIÓN LISTA ===");
    }

    public BeanUsuario getUserLogin() {
        return userLogin;
    }

    public void setUserLogin(BeanUsuario userLogin) {
        this.userLogin = userLogin;
    }

    public void setImplPedido(ImplPedido value) {
        this.implPedido = value;
    }

    public ImplPedido getImplPedido() {
        return  implPedido;
    }

    public String getEditPassword() {
        return editPassword;
    }

    public String getNombreEmpresa() throws Exception {
        if (ImplEmpresa.empresaDefault == null)
            throw new Exception("Error en getNombreEmpresa de globalClass. No se ha especificado una empresa por defecto");

        return ImplEmpresa.empresaDefault.getRazonSocial();

    }

    public Double getPorcIGV() {
        return 18.0;
    }

    public void setEditPassword(String value) {
        this.editPassword = value;
    }

    public ImplServerRemote getImplServerRemote() {
        return implServerRemote;
    }

    public void setImplServerRemote(ImplServerRemote value) {
        this.implServerRemote = value;
    }

    public ImplEmpresa getImplEmpresa() {
        return this._implEmpresa;
    }

    public void setImplEmpresa(ImplEmpresa value) {
        this._implEmpresa = value;
    }

    public void setActivity(Activity value) {
        this.myActivity = value;
    }

    public Activity getActivity() {
        return this.myActivity;
    }

    public ImplListadoCajas getListadoCajas() {
        return this._implListadoCajas;
    }

    public void setListadoCajas(ImplListadoCajas value) {
        this._implListadoCajas = value;
    }
    
    /**
     * Obtiene el servicio global de sincronización de hora
     */
    public GlobalTimeSyncService getTimeSyncService() {
        if (timeSyncService == null) {
            timeSyncService = GlobalTimeSyncService.getInstance(this);
        }
        return timeSyncService;
    }
    
    /**
     * Inicia la sincronización de hora con el servidor
     * Este método debe ser llamado después del login exitoso
     */
    public void startTimeSynchronization(final GlobalTimeSyncService.InitialSyncListener listener) {
        Log.i(TAG, "Iniciando sincronización global de hora");
        getTimeSyncService().start(listener);
    }
    
    @Override
    public void onTerminate() {
        super.onTerminate();
        // Detener el servicio de sincronización al cerrar la aplicación
        if (timeSyncService != null) {
            timeSyncService.stop();
        }
    }
}
