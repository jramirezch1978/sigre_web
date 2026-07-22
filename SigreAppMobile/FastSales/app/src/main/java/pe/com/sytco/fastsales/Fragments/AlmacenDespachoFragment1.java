package pe.com.sytco.fastsales.Fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import androidx.fragment.app.Fragment;

import pe.com.sytco.fastsales.Controller.Almacen.ImplParteDespacho;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewPackingAdapter;


public class AlmacenDespachoFragment1 extends Fragment {

    private static final String ARG_PARAM1 = "param1";

    // TODO: Rename and change types of parameters
    private String mParam1;

    ListView lvPackingList;

    //Listado de Cajas
    ArrayAdapter adaptador;
    View view;

    public AlmacenDespachoFragment1() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        view = inflater.inflate(R.layout.fragment_almacen_despacho1, container, false);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();

        return view;
    }

    private void LoadDataDefault() {

    }

    private void AsignarEventos() {
        
    }

    private void InitControllers() {
        lvPackingList = (ListView) view.findViewById (R.id.lvPackingList);
    }

    // TODO: Rename and change types and number of parameters
    public static AlmacenDespachoFragment1 newInstance(String param1) {
        AlmacenDespachoFragment1 fragment = new AlmacenDespachoFragment1();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        fragment.setArguments(args);

        return fragment;
    }

    public void ListRefresh() {

        //Indico el adaptador para el listado de Servidores
        adaptador = new ListViewPackingAdapter(getContext(), ImplParteDespacho.getListadoCajas(), getActivity());
        lvPackingList.setAdapter(adaptador);



    }

}
