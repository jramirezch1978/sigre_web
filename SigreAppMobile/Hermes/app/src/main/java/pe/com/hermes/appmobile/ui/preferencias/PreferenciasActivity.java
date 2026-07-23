package pe.com.hermes.appmobile.ui.preferencias;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import pe.com.hermes.appmobile.databinding.ActivityPreferenciasBinding;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;

public class PreferenciasActivity extends AppCompatActivity {

    private ActivityPreferenciasBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityPreferenciasBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.toolbar.setNavigationOnClickListener(v -> finish());
        binding.cardServidores.setOnClickListener(v ->
                startActivity(new Intent(this, ServidorListActivity.class)));
    }
}
