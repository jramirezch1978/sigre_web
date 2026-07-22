package pe.com.sytco.fastsales.UI;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.io.IOException;

public class ActivityFoto extends AppCompatActivity {
    // Control imagen para la captura de la foto
    private ImageView ivImagen;
    private TextView tvRutaFoto;
    private Uri uriImagenPath;
    private ImageButton ibGuardarFoto;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == 0 && resultCode == RESULT_OK) {
            Bitmap imageBitmap = null;
            try {
                imageBitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uriImagenPath);

                tvRutaFoto.setText(uriImagenPath.getPath());

                //ivImagen.setImageBitmap(imageBitmap.createScaledBitmap(imageBitmap, 1800, 1800, false));
                ivImagen.setImageBitmap(imageBitmap);

                ibGuardarFoto.setVisibility(ImageButton.VISIBLE);



            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    public void setImagenView(ImageView value) {
        this.ivImagen = value;
    }

    public void setUriImagenPath(Uri value) {
        this.uriImagenPath = value;
    }

    public void setRutaFoto(TextView value) {
        this.tvRutaFoto = value;
    }

    public void setBtnGuardarFoto(ImageButton value) {
        this.ibGuardarFoto= value;
    }
}
