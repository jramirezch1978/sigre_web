package pe.com.sytco.fastsales.util;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.ImageView;
import android.widget.TableRow;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.regex.Pattern;

import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;

/**
 * Created by jramirez on 01/05/2016.
 */
public class UTIL {
    public static final String CERO = "0";
    public static final String BARRA = "/";
    public static final int REQUEST_IMAGE_CAPTURE = 1;

    public static final int MIN_LONGITUD_DESCRIPCION = 50;

    public static void setImageViewWithByteArray(ImageView view, byte[] data) {
        Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
        view.setImageBitmap(bitmap);
    }

    public static Bitmap getBitmap( byte[] data) {
        Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
        return bitmap;
    }

    public static java.sql.Date parseDate(String fecRegistro) throws Exception {
        java.sql.Date sql = null;

        //2015-09-25T13:06:46-05:00
        if (fecRegistro == null || fecRegistro.trim().equals("") ) {
            sql = null;
        }else {

            String Fecha = fecRegistro.substring(8, 10) + "/" + fecRegistro.substring(5, 7) + "/" + fecRegistro.substring(0, 4) +
                    " " + fecRegistro.substring(11, 13) + ":" + fecRegistro.substring(14, 16) + ":" + fecRegistro.substring(17, 19);
            //System.out.print("Fecha -> " + Fecha);
            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            java.util.Date parsed = format.parse(Fecha);
            sql = new java.sql.Date(parsed.getTime());

            //System.out.println(" Translate -> " + parsed.toString());
        }
        return sql;
    }

    public static String ConvetToString(Double value, String format) {
        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols(Locale.getDefault());
        otherSymbols.setDecimalSeparator('.');
        otherSymbols.setGroupingSeparator(',');

        DecimalFormat df = new DecimalFormat(format, otherSymbols);
        String result = df.format(value);
        return result;
    }

    public static String ConvetToString(Long value, String format) {
        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols(Locale.getDefault());
        otherSymbols.setDecimalSeparator('.');
        otherSymbols.setGroupingSeparator(',');

        DecimalFormat df = new DecimalFormat(format, otherSymbols);
        String result = df.format(value);
        return result;
    }

    public static String ConvetToString(Integer value, String format) {
        DecimalFormat df = new DecimalFormat(format);
        String result = df.format(value);
        return result;
    }

    public static String ConvetToString(Float value, String format) {
        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols(Locale.getDefault());
        otherSymbols.setDecimalSeparator('.');
        otherSymbols.setGroupingSeparator(',');

        DecimalFormat df = new DecimalFormat(format, otherSymbols);
        String result;

        if (value == null)
            result = "";
        else
            result = df.format(value);

        return result;
    }

    public static void OcultarTeclado(Context context, View v){
        //Lineas para ocultar el teclado virtual (Hide keyboard)
        InputMethodManager imm = (InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
    }

    public static Date getSqlDateNow() {
        java.util.Date utilDate = new java.util.Date();
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
        System.out.println("utilDate:" + utilDate);
        System.out.println("sqlDate:" + sqlDate);

        return sqlDate;

    }

    public static String parseSqlDatetoString(java.sql.Date date) {
        String dateForMySql = "";
        if (date == null) {
            dateForMySql = null;
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            dateForMySql = sdf.format(date);
        }

        return dateForMySql;
    }

    public static String parseSqlShortDatetoString(java.sql.Date date) {
        String dateForMySql = "";
        if (date == null) {
            dateForMySql = null;
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            dateForMySql = sdf.format(date);
        }

        return dateForMySql;
    }

    public static String parseSqlDatetoString(java.sql.Date date, String strFormato) {
        String dateForMySql = "";
        if (date == null) {
            dateForMySql = null;
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat(strFormato);
            dateForMySql = sdf.format(date);
        }

        return dateForMySql;
    }

    public static String getDeviceName(Context context){
        String IMEI = "", ID = "", deviceName = "";

        //Obtengo el ID
        ID = Settings.Secure.getString(context.getApplicationContext().getContentResolver(), Settings.Secure.ANDROID_ID);

        //Obtengo el Device Name
        deviceName = android.os.Build.MANUFACTURER + " " + android.os.Build.MODEL;

        //Obtengo el IMEI
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return null;
        }
        IMEI = telephonyManager.getDeviceId();

        if(IMEI == null)
            IMEI = "SIN IMEI. Version Software: " + telephonyManager.getDeviceSoftwareVersion();

        if (IMEI == null)
            IMEI = "DESCONOCIDO";

        return deviceName + " ID: " + ID + " IMEI: " + IMEI;

    }

    public static java.sql.Date parseStringToSqlDate(String strDate) {
        SimpleDateFormat dateFormat = null;
        java.sql.Date sqlDate = null;
        try {
            //System.out.println("parseStringToSqlDate: " + strDate);

            if (strDate == null || strDate.trim().equals("")) return null;

            if (strDate.trim().length()== 10 ){
                dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            }else{
                dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            }

            java.util.Date convertedDate = dateFormat.parse(strDate);
            sqlDate = new java.sql.Date(convertedDate.getTime());

        } catch (ParseException e) {
            e.printStackTrace();
        }finally {
            dateFormat = null;
        }
        return sqlDate;
    }

    public static java.sql.Date parseStringToSqlDate(String strDate, String strFormat) {
        SimpleDateFormat dateFormat = null;
        java.sql.Date sqlDate = null;
        try {
            System.out.println("parseStringToSqlDate: " + strDate);

            if (strDate == null || strDate.trim().equals("")) return null;

            dateFormat = new SimpleDateFormat(strFormat);
            java.util.Date convertedDate = dateFormat.parse(strDate);
            sqlDate = new java.sql.Date(convertedDate.getTime());

        } catch (ParseException e) {
            e.printStackTrace();
        }finally {
            dateFormat = null;
        }
        return sqlDate;
    }

    public static boolean isConecctedToInternet() throws IOException, InterruptedException {

        Runtime runtime = Runtime.getRuntime();
        try {
            Process ipProcess = runtime.exec("/system/bin/ping -c 1 " + SOAPClient.serverDefault.getHostIP());
            int exitValue = ipProcess.waitFor();

            return (exitValue == 0);

        } catch (IOException e)          {
            e.printStackTrace();
            throw e;
        }
        catch (InterruptedException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public static boolean PingIP(String IP) throws IOException, InterruptedException {

        Runtime runtime = Runtime.getRuntime();
        try {
            Process ipProcess = runtime.exec("/system/bin/ping -c 1 " + IP);
            int exitValue = ipProcess.waitFor();

            return (exitValue == 0);

        } catch (IOException e)          {
            e.printStackTrace();
            throw e;
        }
        catch (InterruptedException e) {
            e.printStackTrace();
            throw e;
        }
    }

    //Para comprobar la conexion a Internet mediante Wifi el metodo conectadoWifi seria asi
    public static Boolean conectadoWifi(Context context){
        ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity != null) {
            NetworkInfo info = connectivity.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            if (info != null) {
                if (info.isConnected()) {
                    return true;
                }
            }
        }
        return false;
    }

    //El metodo conectadoRedMovil comprueba la conexion a la RedMovil del dispositivo android
    public static Boolean conectadoRedMovil(Context context){
        ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity != null) {
            NetworkInfo info = connectivity.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
            if (info != null) {
                if (info.isConnected()) {
                    return true;
                }
            }
        }
        return false;
    }

    public static Boolean isConnected(Context context){
        if(UTIL.conectadoWifi(context)){
            Toast.makeText(context, "Conexion a Wifi se encuentra presente en el dispositivo.", Toast.LENGTH_LONG).show();
            return true;
        }else{
            if(conectadoRedMovil(context)){
                Toast.makeText(context, "Conexion a datos MOVILES se encuentra presente en el dispositivo.", Toast.LENGTH_LONG).show();

                return true;
            }else{
                MessageBox.AlertDialog(context, "Conexion a Internet",
                        "Tu Dispositivo no tiene Conexion a Internet.", false);
                return false;
            }
        }
    }

    public static boolean validarTexto(String nombre){
        Pattern patron = Pattern.compile("^[a-zA-Z ]+$");
        return patron.matcher(nombre).matches() || nombre.length() > 0;
    }

    public static GlobalClass getGlobalClass(Context context) {
        GlobalClass globalClass = (GlobalClass) context.getApplicationContext();
        return globalClass;
    }

    /**
     * Obtiene la dirección IP del dispositivo (prioriza IPv4)
     * @return Dirección IP del dispositivo o "DESCONOCIDA" si no se puede obtener
     */
    public static String getDeviceIPAddress() {
        try {
            java.util.Enumeration<java.net.NetworkInterface> interfaces = java.net.NetworkInterface.getNetworkInterfaces();
            
            // Verificar si getNetworkInterfaces() devolvió null
            if (interfaces == null) {
                android.util.Log.w("UTIL", "getNetworkInterfaces() devolvió null");
                return "DESCONOCIDA";
            }
            
            while (interfaces.hasMoreElements()) {
                java.net.NetworkInterface networkInterface = interfaces.nextElement();
                
                // Ignorar interfaces inactivas o loopback
                if (!networkInterface.isUp() || networkInterface.isLoopback()) {
                    continue;
                }
                
                java.util.Enumeration<java.net.InetAddress> addresses = networkInterface.getInetAddresses();
                while (addresses.hasMoreElements()) {
                    java.net.InetAddress address = addresses.nextElement();
                    
                    // Ignorar direcciones loopback (127.0.0.1 o ::1)
                    if (address.isLoopbackAddress()) {
                        continue;
                    }
                    
                    // Ignorar direcciones link-local (169.254.x.x o fe80::)
                    if (address.isLinkLocalAddress()) {
                        continue;
                    }
                    
                    // PRIORIZAR IPv4
                    if (address instanceof java.net.Inet4Address) {
                        String ipAddress = address.getHostAddress();
                        android.util.Log.i("UTIL", "IP del dispositivo encontrada: " + ipAddress);
                        return ipAddress;
                    }
                }
            }
            
            // Si no se encontró IPv4, buscar IPv6 (limpiando el sufijo %interfaz)
            interfaces = java.net.NetworkInterface.getNetworkInterfaces();
            if (interfaces != null) {
                while (interfaces.hasMoreElements()) {
                    java.net.NetworkInterface networkInterface = interfaces.nextElement();
                    java.util.Enumeration<java.net.InetAddress> addresses = networkInterface.getInetAddresses();
                    while (addresses.hasMoreElements()) {
                        java.net.InetAddress address = addresses.nextElement();
                        
                        if (!address.isLoopbackAddress() && !address.isLinkLocalAddress()) {
                            String ipAddress = address.getHostAddress();
                            
                            // Limpiar sufijo de interfaz en IPv6 (ejemplo: fe80::1%wlan0 -> fe80::1)
                            int percentIndex = ipAddress.indexOf('%');
                            if (percentIndex > 0) {
                                ipAddress = ipAddress.substring(0, percentIndex);
                            }
                            
                            android.util.Log.i("UTIL", "IP IPv6 del dispositivo encontrada: " + ipAddress);
                            return ipAddress;
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            android.util.Log.e("UTIL", "Error al obtener IP del dispositivo: " + e.getMessage());
            e.printStackTrace();
        }
        
        android.util.Log.w("UTIL", "No se pudo obtener la IP del dispositivo");
        return "DESCONOCIDA";
    }

    public static double redondearDecimales(double valorInicial, int numeroDecimales) {
        double parteEntera, resultado;
        resultado = valorInicial;
        parteEntera = Math.floor(resultado);
        resultado=(resultado-parteEntera)*Math.pow(10, numeroDecimales);
        resultado=Math.round(resultado);
        resultado=(resultado/Math.pow(10, numeroDecimales))+parteEntera;
        return resultado;
    }

    public static String DateToString(int dia, int mes, int year) {
        //Formateo el día obtenido: antepone el 0 si son menores de 10
        String diaFormateado = (dia < 10)? UTIL.CERO + String.valueOf(dia):String.valueOf(dia);

        //Formateo el mes obtenido: antepone el 0 si son menores de 10
        String mesFormateado = (mes < 10)? UTIL.CERO + String.valueOf(mes):String.valueOf(mes);

        return diaFormateado + UTIL.BARRA + mesFormateado + UTIL.BARRA + String.valueOf(year);
    }

    public static void SaveBitmap(Bitmap imageBitmap) {
        FileOutputStream outStream = null;
        String ruta_fotos = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/HermesFotos/";
        File ruta = new File(ruta_fotos);

        try {
            //Creo la ruta completa
            ruta.mkdirs();
            String filePath = ruta_fotos + getCode() + ".png";

            File mi_foto = new File( filePath );

            outStream = new FileOutputStream(filePath);

            imageBitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);


        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        } finally{
            if (outStream != null) {
                try {
                    outStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Metodo privado que genera un codigo unico segun la hora y fecha del sistema
     * @return photoCode
     * */
    @SuppressLint("SimpleDateFormat")
    public static String getCode()
    {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyymmddhhmmss");
        String date = dateFormat.format(new java.util.Date() );
        String photoCode = "pic_" + date;
        return photoCode;

    }

    public static void SonidoPopup(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.mensaje_popup);
        mp.start();

        mp = null;
    }

    public static void SonidoError(Context context) {
        //Creo el sonido de error
        MediaPlayer mp;
        mp = MediaPlayer.create(context, R.raw.sonido_error);
        mp.start();

        mp = null;
    }

    public static void SonidoCorrecto(Context context) {
        //Creo el sonido de error
        MediaPlayer mp;
        mp = MediaPlayer.create(context, R.raw.correcto);
        mp.start();

        mp = null;
    }

    public static void SonidoAlerta(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.alerta);
        mp.start();

        mp = null;
    }

    public static void SonidoBoxeo(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.boxeo);
        mp.start();

        mp = null;
    }

    public static void SonidoCampanilla(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.campanilla);
        mp.start();

        mp = null;
    }

    public static void SonidoCuak(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.cuak);
        mp.start();

        mp = null;
    }

    public static void SonidoEsperandoWTF(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.esperando_wtf);
        mp.start();

        mp = null;
    }

    public static void SonidoWithYou(Context context){
        MediaPlayer mp;

        mp = MediaPlayer.create(context, R.raw.with_you_denclan_dp);
        mp.start();

        mp = null;
    }

    public static void setImagenResize(Context context, byte[] imagen, ImageView pIvImagen) {

        TableRow.LayoutParams ltr_layout = null;
        ViewGroup.LayoutParams lvg_layout = null;
        Bitmap OldBitmap = null, resizedBitmap = null;
        Integer li_Width, li_Height;

        if (imagen != null){
            OldBitmap = BitmapFactory.decodeByteArray(imagen, 0, imagen.length);

        }else {
            OldBitmap = BitmapFactory.decodeResource(context.getResources(), R.drawable.noimagen);

        }

        li_Height= AncestorUI.heightImaggeButton - 5;

        //Obtengo el ancho segun la proporcion
        li_Width = (int) ((float)li_Height * (float)OldBitmap.getWidth() / (float)OldBitmap.getHeight());

        resizedBitmap=Bitmap.createScaledBitmap(OldBitmap, li_Width, li_Height, true);

        pIvImagen.setImageBitmap(resizedBitmap);

        ltr_layout = new TableRow.LayoutParams();
        ltr_layout.setMargins(0, 0, 0, 0);
        ltr_layout.gravity= Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL;

        pIvImagen.setLayoutParams(ltr_layout);
        pIvImagen.setBackgroundResource(R.drawable.image_border);

        lvg_layout = pIvImagen.getLayoutParams();
        lvg_layout.height = AncestorUI.heightImaggeButton;

        li_Width = (int) ((float)AncestorUI.heightImaggeButton * (float)OldBitmap.getWidth() / (float)OldBitmap.getHeight());

        lvg_layout.width = li_Width;
        pIvImagen.setLayoutParams(lvg_layout);

    }
}
