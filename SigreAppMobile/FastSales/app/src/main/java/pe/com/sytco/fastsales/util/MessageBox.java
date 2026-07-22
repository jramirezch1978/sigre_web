package pe.com.sytco.fastsales.util;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.media.MediaPlayer;
import android.provider.MediaStore;

import pe.com.sytco.fastsales.R;

/**
 * Created by jramirez on 01/05/2016.
 */
public class MessageBox {


    public static void AlertDialog(String pMensaje, String pTitulo, Context context){

        AlertDialog.Builder builder;
        builder = new AlertDialog.Builder(context);
        builder.setTitle(pTitulo);
        builder.setMessage(pMensaje);
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
            }
        });
        builder.setCancelable(false);
        builder.create();
        builder.show();


    }

    public static void AlertDialog(Context context, String title, String message, Boolean status) {


        AlertDialog alertDialog = new AlertDialog.Builder(context).create();

        alertDialog.setTitle(title);

        alertDialog.setMessage(message);

        alertDialog.setIcon((status) ? R.drawable.exito : R.drawable.fail);

        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
            }
        });

        alertDialog.show();

    }

    public static AlertDialog createAlertDialog(Context context, String title, String message, Boolean status) {


        AlertDialog alertDialog = new AlertDialog.Builder(context).create();

        alertDialog.setTitle(title);

        alertDialog.setMessage(message);

        alertDialog.setIcon((status) ? R.drawable.exito : R.drawable.fail);

        return alertDialog;

    }
}

