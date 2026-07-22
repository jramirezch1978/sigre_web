package pe.com.sytco.fastsales.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.google.gson.Gson;

/**
 * Created by jramirez on 29/10/2017.
 */
public class SettingPreferences {

    private final Context context;

    public SettingPreferences(Context context) {
        this.context = context;
    }

    public void saveToPreferences(String parametro, String value) {
        SharedPreferences.Editor edit = getSharedPreferences().edit();
        edit.putString(parametro, value);
        edit.commit();
    }

    public String loadFromPreferences(String parametro) {
        String json = getSharedPreferences().getString(parametro, null);
        return json;
    }

    private SharedPreferences getSharedPreferences(){
        //SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        SharedPreferences preferences = context.getSharedPreferences("MisPreferencias", Context.MODE_PRIVATE);
        return preferences;
    }

}
