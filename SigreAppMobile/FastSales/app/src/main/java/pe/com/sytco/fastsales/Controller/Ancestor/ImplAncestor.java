package pe.com.sytco.fastsales.Controller.Ancestor;

import android.content.Context;

/**
 * Created by jramirez on 05/05/2016.
 */
public class ImplAncestor {
    protected Context context;

    protected String empresaDefault;

    public Context getContext() {
        return context;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public String getEmpresaDefault() {
        return empresaDefault;
    }

    public void setEmpresaDefault(String empresaDefault) {
        this.empresaDefault = empresaDefault;
    }

}
