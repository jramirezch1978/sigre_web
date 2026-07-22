package pe.com.sytco.fastsales.adapter;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import java.util.List;

import pe.com.sytco.fastsales.Activities.Almacen.InventarioPalletsActivity;
import pe.com.sytco.fastsales.Dialog.DialogShowPalletsPosicion;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.data.SigreAppHelper;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ListViewPosicionesAdapter extends ArrayAdapter<BeanInventarioPallet> {
    Context context;
    Activity _activity;

    //Controles para la interfaz
    TextView tvNroPallets, tvNroCajas, tvNroColumna;
    ImageView ivImagen, ivDefault;
    Button btnDelete, btnLeerPallet;

    //Referencia a la base de datos
    private SigreAppHelper sigreAppHelper;

    public ListViewPosicionesAdapter(@NonNull Context context, int resource) {
        super(context, resource);
    }

    public ListViewPosicionesAdapter(Context context, List<BeanInventarioPallet> objects, Activity pActivity, SigreAppHelper db) {

        super(context, 0, objects);

        this.context = context;
        this._activity = pActivity;
        this.sigreAppHelper = db;

        //Obtengo objeto ImplServerRemote de la clase global
        //implListadoCajas = UTIL.getGlobalClass(context).getListadoCajas();

    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        //Obteniendo una instancia del inflater
        LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        //Salvando la referencia del View de la fila
        View listItemView = convertView;

        //Comprobando si el View no existe
        if (null == convertView) {
            //Si no existe, entonces inflarlo con image_list_view.xml
            listItemView = inflater.inflate(R.layout.item_row_columna_pos, parent, false);
        }

        //Obteniendo instancias de los elementos
        tvNroPallets = (TextView)listItemView.findViewById(R.id.tvNroPallets);
        tvNroCajas = (TextView)listItemView.findViewById(R.id.tvNroCajas);
        tvNroColumna = (TextView)listItemView.findViewById(R.id.tvNroColumna);

        ivImagen = (ImageView)listItemView.findViewById(R.id.ivImagen);
        ivDefault = (ImageView)listItemView.findViewById(R.id.ivDefault);

        btnDelete = (Button)listItemView.findViewById(R.id.btnDelete);
        btnLeerPallet = (Button)listItemView.findViewById(R.id.btnLeerPallet);

        //Obteniendo instancia de la Tarea en la posicion actual
        final BeanInventarioPallet item = getItem(position);

        // Capture position and set to the TextViews
        tvNroPallets.setText(UTIL.ConvetToString(item.getNroPallets(), "###,##0"));
        tvNroCajas.setText(UTIL.ConvetToString(item.getNroCajas(), "###,##0"));
        tvNroColumna.setText(item.getColumna());

        if (item.getNroPallets() == 0){
            ivDefault.setVisibility(ImageView.INVISIBLE);
            ivImagen.setVisibility(ImageView.INVISIBLE);
        }else{
            ivDefault.setVisibility(ImageView.VISIBLE);
            ivImagen.setVisibility(ImageView.VISIBLE);

            //Asignación de la imagen
            ivImagen.setImageResource(R.drawable.pallet);
        }



        //Adiciono el click
        ivImagen.setClickable(true);
        ivImagen.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                //MessageBox.AlertDialog("Ha hecho click en el detalle de articulos", "Aviso", context);
                //DialogArticuloDetails(item);
            }
        });

        btnLeerPallet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialogShowPalletsPosicion(item);
            }
        });

        //Agrego el evento click en el boton btnDelete
        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmDeleteRow(item);
            }
        });


        return listItemView;
    }

    private void dialogShowPalletsPosicion(BeanInventarioPallet item) {
        new LoadDataPosicionTask(context, item).execute();
    }

    private void confirmDeleteRow(final BeanInventarioPallet item) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);

        builder.setMessage("¿Desea eliminar el registro de la columna " + item.getColumna() + " del listado ?");
        builder.setTitle("Confirmacion");
        builder.setCancelable(false);

        builder.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                //ImplInventarioPallet.(item);


                //if (_activity instanceof AlmacenTransferenciaPPTTActivity){
                //    ((AlmacenTransferenciaPPTTActivity) _activity).RefrescarCajas();
                //}

                sigreAppHelper.deleteInventarioPallet(item);
                ((InventarioPalletsActivity) _activity).LeerColumnas();

                dialog.cancel();
            }
        });
        builder.setNegativeButton("Cancelar", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
            }
        });

        builder.create();
        builder.show();
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadDataPosicionTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        private Context _context;
        private BeanInventarioPallet _item;
        List<BeanInventarioPallet> _consulta;

        private ProgressDialog pDialog;

        private LoadDataPosicionTask(){

        }

        public LoadDataPosicionTask(Context context, BeanInventarioPallet item){
            this._context = context;
            this._item = item;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Cargando datos de los pallets leidos en la posicion...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //LLenado de Lista para los articulos
                _consulta = sigreAppHelper.getPalletsLeidos(_item);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {

            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    new DialogShowPalletsPosicion(context, _consulta).ConfirmDialog();
                }else{
                    MessageBox.AlertDialog(context, "Error mostrar los pallets leidos por posicion", mensaje, false);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }


}
