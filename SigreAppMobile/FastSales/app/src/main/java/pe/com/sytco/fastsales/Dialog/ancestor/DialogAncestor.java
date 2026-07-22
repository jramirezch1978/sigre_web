package pe.com.sytco.fastsales.Dialog.ancestor;

import android.app.AlertDialog;
import android.content.Context;
import android.view.View;
import android.widget.Button;

import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class DialogAncestor {
    //Cuadro de dialogo para Ver detalles del articulo
    protected Context context;

    //Para la creacion del AlertDialog
    protected AlertDialog.Builder builder;
    protected View dialogLayout, layoutReference;
    protected AlertDialog dialogMain;
    protected Button btnCerrar;

    private boolean firstTime = true;

    //Objeto
    protected BeanAncestor bean = null;

    public boolean isFirstTime() {
        return firstTime;
    }

    public void setFirstTime(boolean firstTime) {
        this.firstTime = firstTime;
    }

    public void showDialog(){

        dialogMain.show();

        this.firstTime = false;

    }

    protected void AsignarEventos() {

    }
    public void openDialog(BeanAncestor value) {

    }
    public void openDialog() {

    }
    protected void InitControllers(){

    }
    public void Filtrar() {
    }
    public void LoadData() {
    }
}
