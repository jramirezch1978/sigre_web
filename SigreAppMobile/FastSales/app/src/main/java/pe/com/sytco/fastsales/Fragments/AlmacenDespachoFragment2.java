package pe.com.sytco.fastsales.Fragments;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import java.util.List;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Almacen.ImplParteDespacho;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanArticuloMovProy;
import pe.com.sytco.fastsales.beans.Almacen.BeanCaja;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;


public class AlmacenDespachoFragment2 extends Fragment {

    private static final String ARG_PARAM1 = "param1";

    // TODO: Rename and change types of parameters
    private String mParam1;


    //Interfaz de usuario
    View view;
    private Spinner spOrdenVenta, spAlmacen, spAMP;
    private TextView tvSaldoUnd, tvUnd, tvSaldoUnd2, tvUnd2;


    //Listado de Almacenes
    List<BeanAlmacen> almacenes;
    List<BeanArticuloMovProy> listaAMP;
    List<BeanCaja> packingList;

    //VAriables para el trabajo
    private String _nroPallet;
    BeanOrdenVenta ovSelect;
    BeanAlmacen almacenSelect;
    BeanArticuloMovProy ampSelect;

    //Fragment de referencia
    AlmacenDespachoFragment1 _fragment1;

    // TODO: Rename and change types and number of parameters
    public static AlmacenDespachoFragment2 newInstance(String param1) {
        AlmacenDespachoFragment2 fragment = new AlmacenDespachoFragment2();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        fragment.setArguments(args);

        return fragment;
    }

    public AlmacenDespachoFragment2() {
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
        view = inflater.inflate(R.layout.fragment_almacen_despacho2, container, false);

        InitControllers();

        AsignarEventos();

        LoadDataDefault();

        return view;
    }

    private void InitControllers() {

        //Spinner
        spOrdenVenta = (Spinner)view.findViewById (R.id.spOrdenVenta);
        spAlmacen = (Spinner) view.findViewById(R.id.spAlmacen);
        spAMP = (Spinner) view.findViewById(R.id.spAMP);

        tvSaldoUnd = (TextView) view.findViewById(R.id.tvSaldoUnd);
        tvSaldoUnd2 = (TextView) view.findViewById(R.id.tvSaldoUnd2);
        tvUnd = (TextView) view.findViewById(R.id.tvUnd);
        tvUnd2 = (TextView) view.findViewById(R.id.tvUnd2);

    }

    private void AsignarEventos() {
        spOrdenVenta.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                ovSelect = (BeanOrdenVenta) adapterView.getItemAtPosition(position);

                if (ovSelect != null)
                    new AlmacenDespachoFragment2.LoadAlmacenesOVTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                ovSelect = null;
            }
        });

        spAlmacen.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                almacenSelect = (BeanAlmacen) adapterView.getItemAtPosition(position);

                if (almacenSelect != null)
                    new AlmacenDespachoFragment2.LoadArticulosMovProyTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                ovSelect = null;
            }
        });

        spAMP.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                ampSelect = (BeanArticuloMovProy) adapterView.getItemAtPosition(position);

                if (ampSelect != null)
                    new AlmacenDespachoFragment2.LoadPackingListTask().execute();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                ovSelect = null;
            }
        });


    }

    private void LoadDataDefault() {
        tvUnd.setText("");
        tvUnd2.setText("");
        tvSaldoUnd.setText("");
        tvSaldoUnd2.setText("");
    }

    public void setAdapterOV(ArrayAdapter<BeanOrdenVenta> value) {
        spOrdenVenta.setAdapter(value);
    }

    public void setNroPallet(String value) {
        this._nroPallet = value;
    }

    public void setFragment(AlmacenDespachoFragment1 value) {
        this._fragment1 = value;
    }

    public BeanArticuloMovProy getAMPSelect() {
        return (BeanArticuloMovProy) spAMP.getSelectedItem();
    }

    public BeanAlmacen getAlmacenSelect() {
        return (BeanAlmacen) spAlmacen.getSelectedItem();
    }

    public BeanOrdenVenta getOVSelect() {
        return (BeanOrdenVenta) spOrdenVenta.getSelectedItem();
    }

    //Clase Asincrona para tareas en segundo plano
    private class LoadAlmacenesOVTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteDespacho implParteDespacho = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(getActivity());
            pDialog.setMessage("Cargando Almacenes para OV: " + ovSelect.getNroOrdenVenta() + ", por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Creo los objetos necesarios
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                almacenes = implParteDespacho.getAlmacenesByOV(ovSelect.getNroOrdenVenta(), _nroPallet);




                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar datos iniciales: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteDespacho = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    ArrayAdapter<BeanAlmacen> adapter = new ArrayAdapter<BeanAlmacen>(getActivity(),
                            R.layout.support_simple_spinner_dropdown_item, almacenes);

                    spAlmacen.setAdapter(adapter);
                }else{
                    MessageBox.AlertDialog(getActivity(), "Error al selecionar Fecha del Servidor", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadArticulosMovProyTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteDespacho implParteDespacho = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(getActivity());
            pDialog.setMessage("Cargando Listado de Articulos para el pallet " + _nroPallet + " de la OV: " + ovSelect.getNroOrdenVenta() + ", por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Creo los objetos necesarios
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                listaAMP = implParteDespacho.getArticulosByOV(_nroPallet, ovSelect.getNroOrdenVenta(), almacenSelect.getAlmacen());




                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar datos iniciales: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteDespacho = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    //ImplParteDespacho.setListadoCajas(packingList);
                    //_fragment1.ListRefresh();
                    ArrayAdapter<BeanArticuloMovProy> adapter = new ArrayAdapter<BeanArticuloMovProy>(getActivity(),
                            R.layout.support_simple_spinner_dropdown_item, listaAMP);

                    spAMP.setAdapter(adapter);
                }else{
                    MessageBox.AlertDialog(getActivity(), "Error al obtener el Packing List", mensaje, false);
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

    //Clase Asincrona para tareas en segundo plano
    private class LoadPackingListTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;

        ImplParteDespacho implParteDespacho = null;

        private ProgressDialog pDialog;

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(getActivity());
            pDialog.setMessage("Cargando Packing List para el pallet " + _nroPallet + " de la OV: " + ovSelect.getNroOrdenVenta() + ", por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Creo los objetos necesarios
                implParteDespacho = new ImplParteDespacho(ImplEmpresa.empresaDefault.getCodigo());
                packingList = implParteDespacho.getCajasByPallet(_nroPallet, ovSelect.getNroOrdenVenta(), almacenSelect.getAlmacen(), ampSelect.getCodArticulo());




                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar datos iniciales: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implParteDespacho = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {

                    ImplParteDespacho.setListadoCajas(packingList);
                    _fragment1.ListRefresh();

                    //Actualizo los datos necesarios
                    tvUnd.setText(ImplParteDespacho.getUnd());
                    tvUnd2.setText(ImplParteDespacho.getUnd2());
                    tvSaldoUnd.setText(UTIL.ConvetToString(ImplParteDespacho.getSaldoUnd(), "###,##0.00"));
                    tvSaldoUnd2.setText(UTIL.ConvetToString(ImplParteDespacho.getSaldoUnd2(), "###,##0.00"));

                }else{
                    MessageBox.AlertDialog(getActivity(), "Error al obtener el Packing List", mensaje, false);
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
