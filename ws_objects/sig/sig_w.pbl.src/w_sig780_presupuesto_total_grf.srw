$PBExportHeader$w_sig780_presupuesto_total_grf.srw
forward
global type w_sig780_presupuesto_total_grf from w_cns
end type
type rb_ingresos from radiobutton within w_sig780_presupuesto_total_grf
end type
type rb_egresos from radiobutton within w_sig780_presupuesto_total_grf
end type
type cb_ejecutar from commandbutton within w_sig780_presupuesto_total_grf
end type
type ddlb_seleccion from dropdownlistbox within w_sig780_presupuesto_total_grf
end type
type cbx_fondos from checkbox within w_sig780_presupuesto_total_grf
end type
type cb_resize from commandbutton within w_sig780_presupuesto_total_grf
end type
type dw_detalle from u_dw_cns within w_sig780_presupuesto_total_grf
end type
type cb_partidas from commandbutton within w_sig780_presupuesto_total_grf
end type
type cb_niveles from commandbutton within w_sig780_presupuesto_total_grf
end type
type dw_resumen from u_dw_cns within w_sig780_presupuesto_total_grf
end type
type sle_cuenta from singlelineedit within w_sig780_presupuesto_total_grf
end type
type st_9 from statictext within w_sig780_presupuesto_total_grf
end type
type st_etiqueta from statictext within w_sig780_presupuesto_total_grf
end type
type st_2 from statictext within w_sig780_presupuesto_total_grf
end type
type sle_ano from singlelineedit within w_sig780_presupuesto_total_grf
end type
type sle_dato from singlelineedit within w_sig780_presupuesto_total_grf
end type
type cb_mostrar from commandbutton within w_sig780_presupuesto_total_grf
end type
type st_dato from statictext within w_sig780_presupuesto_total_grf
end type
type dw_master from u_dw_cns within w_sig780_presupuesto_total_grf
end type
type gb_1 from groupbox within w_sig780_presupuesto_total_grf
end type
end forward

global type w_sig780_presupuesto_total_grf from w_cns
integer width = 4046
integer height = 2424
string title = "Consulta del Presupuesto Total (SIG780)"
string menuname = "m_cns_simple"
event ue_proceso ( )
event ue_set_ran_detalle ( string as_parametro )
rb_ingresos rb_ingresos
rb_egresos rb_egresos
cb_ejecutar cb_ejecutar
ddlb_seleccion ddlb_seleccion
cbx_fondos cbx_fondos
cb_resize cb_resize
dw_detalle dw_detalle
cb_partidas cb_partidas
cb_niveles cb_niveles
dw_resumen dw_resumen
sle_cuenta sle_cuenta
st_9 st_9
st_etiqueta st_etiqueta
st_2 st_2
sle_ano sle_ano
sle_dato sle_dato
cb_mostrar cb_mostrar
st_dato st_dato
dw_master dw_master
gb_1 gb_1
end type
global w_sig780_presupuesto_total_grf w_sig780_presupuesto_total_grf

type variables
Datastore ids_total, ids_nivel1, ids_nivel2, ids_nivel3, ids_cencos
Datastore ids_total_cuenta, ids_nivel1_cuenta, ids_nivel2_cuenta, ids_nivel3_cuenta, ids_cencos_cuenta
String is_resize = 'N', is_no_tipo, is_tipo_partida = 'E'
String is_doc_ot, is_data_obj_par, is_data_obj_eje
end variables

forward prototypes
public function string of_get_nombre (string as_nivel1)
public function string of_get_nombre (string as_nivel1, string as_nivel2)
public function string of_get_nombre (string as_nivel1, string as_nivel2, string as_nivel3)
public function string of_get_cencos (string as_cencos)
public function string of_get_nom_cuenta (string as_cuenta)
public subroutine of_set_grf (ref datastore ads_data, ref datawindow adw_grf, datawindow adw_grf2)
public function string of_get_cadena (string as_ano, string as_mes)
public function boolean of_verificar_acceso ()
public function integer of_get_parametros (ref string as_doc_ot)
end prototypes

event ue_proceso();Long		ll_total, ll_ano

ll_ano = Year(Today())
sle_ano.Text = String(ll_ano)
is_data_obj_par = 'd_total_partidas_tbl'

ll_total = ids_total.Retrieve(ll_ano, is_no_tipo, is_tipo_partida)

of_set_grf(ids_total, idw_1, dw_resumen)


end event

event ue_set_ran_detalle(string as_parametro);String	ls_setting

ls_setting = dw_detalle.Object.DataWindow.Retrieve.AsNeeded

IF Upper(as_parametro) = 'S' THEN
	dw_detalle.Object.DataWindow.Retrieve.AsNeeded = 'Yes'
ELSE
	IF Upper(as_parametro) = 'N' THEN
		dw_detalle.Object.DataWindow.Retrieve.AsNeeded = 'No'
	END IF
END IF

end event

public function string of_get_nombre (string as_nivel1);String	ls_nombre


  SELECT "CENCOS_NIV1"."DESCRIPCION"  
    INTO :ls_nombre  
    FROM "CENCOS_NIV1"  
   WHERE "CENCOS_NIV1"."COD_N1" = :as_nivel1 ;

RETURN ls_nombre
end function

public function string of_get_nombre (string as_nivel1, string as_nivel2);String	ls_nombre



  SELECT "CENCOS_NIV2"."DESCRIPCION"  
    INTO :ls_nombre  
    FROM "CENCOS_NIV2"  
   WHERE ( "CENCOS_NIV2"."COD_N1" = :as_nivel1 ) AND  
         ( "CENCOS_NIV2"."COD_N2" = :as_nivel2 ) ;



RETURN ls_nombre
end function

public function string of_get_nombre (string as_nivel1, string as_nivel2, string as_nivel3);String	ls_nombre


  SELECT "CENCOS_NIV3"."DESCRIPPCION"  
    INTO :ls_nombre  
    FROM "CENCOS_NIV3"  
   WHERE ( "CENCOS_NIV3"."COD_N1" = :as_nivel1 ) AND  
         ( "CENCOS_NIV3"."COD_N2" = :as_nivel2 ) AND  
         ( "CENCOS_NIV3"."COD_N3" = :as_nivel3 )   
           ;


RETURN ls_nombre
end function

public function string of_get_cencos (string as_cencos);String	ls_nombre



  SELECT "CENTROS_COSTO"."DESC_CENCOS"  
    INTO :ls_nombre  
    FROM "CENTROS_COSTO"  
   WHERE "CENTROS_COSTO"."CENCOS" = :as_cencos   
           ;
			  
			  
RETURN ls_nombre

end function

public function string of_get_nom_cuenta (string as_cuenta);String	ls_nombre


  SELECT "PRESUPUESTO_CUENTA"."DESCRIPCION"  
    INTO :ls_nombre  
    FROM "PRESUPUESTO_CUENTA"  
   WHERE "PRESUPUESTO_CUENTA"."CNTA_PRSP" = :as_cuenta   ;



RETURN ls_nombre
end function

public subroutine of_set_grf (ref datastore ads_data, ref datawindow adw_grf, datawindow adw_grf2);String	ls_mes
Long		ll_row
Decimal	ldc_valor, ldc_res[3]

// Enero
ls_mes = ' 1'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_en')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_en')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_en')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Febrero
ls_mes = ' 2'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_fb')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_fb')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_fb')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Marzo
ls_mes = ' 3'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_mr')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_mr')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_mr')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Abril
ls_mes = ' 4'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_ab')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_ab')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_ab')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Mayo
ls_mes = ' 5'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_my')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_my')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_my')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Junio
ls_mes = ' 6'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_jn')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_jn')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_jn')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Julio
ls_mes = ' 7'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_jl')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_jl')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_jl')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Agosto
ls_mes = ' 8'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_ag')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_ag')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_ag')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Setiembre
ls_mes = ' 9'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_st')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_st')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_st')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Octubre
ls_mes = '10'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_oc')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_oc')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_oc')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Noviembre
ls_mes = '11'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_nv')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_nv')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_nv')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')

// Diciembre
ls_mes = '12'
ll_row = adw_grf.InsertRow(0)
ldc_valor = ads_data.GetItemDecimal(1, 'p_dc')
ldc_res[1] = ldc_res[1] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = ldc_valor + ads_data.GetItemDecimal(1, 'v_dc')
ldc_res[2] = ldc_res[2] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Presupuesto + Var')
//------------------------
ll_row = adw_grf.InsertRow(0)
ldc_valor = - ads_data.GetItemDecimal(1, 'e_dc')
ldc_res[3] = ldc_res[3] + ldc_valor
adw_grf.SetItem(ll_row,'valor', ldc_valor)
adw_grf.SetItem(ll_row, 'mes', ls_mes)
adw_grf.SetItem(ll_row, 'tipo', 'Ejecutado')


// Grafico resumen
ll_row = adw_grf2.InsertRow(0)
adw_grf2.SetItem(ll_row,'valor', ldc_res[1]/1000)
adw_grf2.SetItem(ll_row, 'tipo', 'Pres')
//------------------------
ll_row = adw_grf2.InsertRow(0)
adw_grf2.SetItem(ll_row,'valor', ldc_res[2]/1000)
adw_grf2.SetItem(ll_row, 'tipo', 'Pres+Var')
//------------------------
ll_row = adw_grf2.InsertRow(0)
adw_grf2.SetItem(ll_row,'valor', ldc_res[3]/1000)
adw_grf2.SetItem(ll_row, 'tipo', 'Ejec')

end subroutine

public function string of_get_cadena (string as_ano, string as_mes);String	ls_nivel, ls_nivel1, ls_nivel2, ls_nivel3, ls_cuenta
String	ls_cencos, ls_cadena
Integer	li_len

ls_nivel = TRIM(sle_dato.Text)

ls_cadena = ' AND ( "PRESUPUESTO_PARTIDA"."FLAG_INGR_EGR" = '+"'"+ is_tipo_partida + "' )"
ls_cadena = ls_cadena + ' AND ( "PRESUPUESTO_PARTIDA"."FLAG_TIPO_CNTA" <> '+"'"+ is_no_tipo + "' )"
ls_cadena = ls_cadena + ' AND ( "PRESUPUESTO_PARTIDA"."FLAG_ESTADO" <> '+"'0' )"
//ls_cadena = ls_cadena + " AND  ( "+'"PRESUPUESTO_PARTIDA"."FLAG_CONTAB" = '+"'1' )"
ls_cadena = ls_cadena + ' AND ( to_char( "PRESUPUESTO_EJEC"."FECHA",'+"'yyyy') = "+"'"+as_ano+"')"
ls_cadena = ls_cadena + ' AND ( to_char( "PRESUPUESTO_EJEC"."FECHA",'+"'mm' ) = " +"'"+as_mes+"')"

IF LEN(sle_cuenta.Text) > 0 THEN
	ls_cuenta = TRIM(sle_cuenta.Text)
	ls_cadena = ls_cadena + ' AND ("PRESUPUESTO_EJEC"."CNTA_PRSP" ='+"'"+ls_cuenta+"')"
END IF

li_len  = Len(ls_nivel)

CHOOSE CASE ddlb_seleccion.text
	CASE 'Centro Costo'
		ls_cencos = ls_nivel
		ls_cadena = ls_cadena + ' AND ("PRESUPUESTO_EJEC"."CENCOS" ='+"'"+ls_cencos+"')"
	CASE 'Nivel 1'
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N1" ='+"'"+ls_nivel+"')"
	CASE 'Nivel 2'
		ls_nivel1 = Left(ls_nivel,2)
		ls_nivel2 = Right(ls_nivel,2)
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N1" ='+"'"+ls_nivel1+"')"
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N2" ='+"'"+ls_nivel2+"')"
	CASE 'Nivel 3'
		ls_nivel1 = Left(ls_nivel,2)
		ls_nivel2 = Mid(ls_nivel,3,2)
		ls_nivel3 = Right(ls_nivel,2)
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N1" ='+"'"+ls_nivel1+"')"
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N2" ='+"'"+ls_nivel2+"')"
		ls_cadena = ls_cadena + ' AND ("CENTROS_COSTO"."COD_N3" ='+"'"+ls_nivel3+"')"
END CHOOSE

RETURN	ls_cadena



end function

public function boolean of_verificar_acceso ();Boolean	lbo_acceso


lbo_acceso = True

	//IF ls_acceso = 'Basico' THEN 
		//IF ls_nivel <> ls_cencos_usr THEN
		 //MessageBox('Error en el Acceso', Solo puede usar su Propio Centro de Costo')
		 //GOTO SALIDA
		//END IF
   //END IF





RETURN lbo_acceso
end function

public function integer of_get_parametros (ref string as_doc_ot);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT"
    INTO :as_doc_ot
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

idw_1 = dw_master
dw_detalle.SetTransObject(SQLCA)
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_ran_detalle('S')

is_no_tipo = '0'

ll_rc = of_get_parametros(is_doc_ot)

ddlb_seleccion.text = 'Total'

// Crear Datastores
// __Presupuesto Total       
ids_total = CREATE Datastore
ids_total.Dataobject = 'd_presupuesto_total_tbl'
ll_rc = ids_total.SetTransObject(SQLCA)
// __Presupuesto a Nivel 1       
ids_nivel1 = CREATE Datastore
ids_nivel1.Dataobject = 'd_presupuesto_nivel1_tbl'
ll_rc = ids_nivel1.SetTransObject(SQLCA)
// __Presupuesto a Nivel 2       
ids_nivel2 = CREATE Datastore
ids_nivel2.Dataobject = 'd_presupuesto_nivel2_tbl'
ll_rc = ids_nivel2.SetTransObject(SQLCA)
// __Presupuesto a Nivel 3       
ids_nivel3 = CREATE Datastore
ids_nivel3.Dataobject = 'd_presupuesto_nivel3_tbl'
ll_rc = ids_nivel3.SetTransObject(SQLCA)
// __Presupuesto a Centro Costo       
ids_cencos = CREATE Datastore
ids_cencos.Dataobject = 'd_presupuesto_cencos_tbl'
ll_rc = ids_cencos.SetTransObject(SQLCA)
// __Presupuesto Total_Cuenta
ids_total_cuenta = CREATE Datastore
ids_total_cuenta.Dataobject = 'd_presupuesto_total_cuenta_tbl'
ll_rc = ids_total_cuenta.SetTransObject(SQLCA)
// __Presupuesto a Nivel 1 Cuenta  
ids_nivel1_cuenta = CREATE Datastore
ids_nivel1_cuenta.Dataobject = 'd_presupuesto_nivel1_cuenta_tbl'
ll_rc = ids_nivel1_cuenta.SetTransObject(SQLCA)
// __Presupuesto a Nivel 2 Cuenta    
ids_nivel2_cuenta = CREATE Datastore
ids_nivel2_cuenta.Dataobject = 'd_presupuesto_nivel2_cuenta_tbl'
ll_rc = ids_nivel2_cuenta.SetTransObject(SQLCA)
// __Presupuesto a Nivel 3 Cuenta      
ids_nivel3_cuenta = CREATE Datastore
ids_nivel3_cuenta.Dataobject = 'd_presupuesto_nivel3_cuenta_tbl'
ll_rc = ids_nivel3_cuenta.SetTransObject(SQLCA)
// __Presupuesto a Centro Costo Cuenta 
ids_cencos_cuenta = CREATE Datastore
ids_cencos_cuenta.Dataobject = 'd_presupuesto_cencos_cuenta_tbl'
ll_rc = ids_cencos_cuenta.SetTransObject(SQLCA)

THIS.EVENT ue_proceso()
end event

on w_sig780_presupuesto_total_grf.create
int iCurrent
call super::create
if this.MenuName = "m_cns_simple" then this.MenuID = create m_cns_simple
this.rb_ingresos=create rb_ingresos
this.rb_egresos=create rb_egresos
this.cb_ejecutar=create cb_ejecutar
this.ddlb_seleccion=create ddlb_seleccion
this.cbx_fondos=create cbx_fondos
this.cb_resize=create cb_resize
this.dw_detalle=create dw_detalle
this.cb_partidas=create cb_partidas
this.cb_niveles=create cb_niveles
this.dw_resumen=create dw_resumen
this.sle_cuenta=create sle_cuenta
this.st_9=create st_9
this.st_etiqueta=create st_etiqueta
this.st_2=create st_2
this.sle_ano=create sle_ano
this.sle_dato=create sle_dato
this.cb_mostrar=create cb_mostrar
this.st_dato=create st_dato
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ingresos
this.Control[iCurrent+2]=this.rb_egresos
this.Control[iCurrent+3]=this.cb_ejecutar
this.Control[iCurrent+4]=this.ddlb_seleccion
this.Control[iCurrent+5]=this.cbx_fondos
this.Control[iCurrent+6]=this.cb_resize
this.Control[iCurrent+7]=this.dw_detalle
this.Control[iCurrent+8]=this.cb_partidas
this.Control[iCurrent+9]=this.cb_niveles
this.Control[iCurrent+10]=this.dw_resumen
this.Control[iCurrent+11]=this.sle_cuenta
this.Control[iCurrent+12]=this.st_9
this.Control[iCurrent+13]=this.st_etiqueta
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.sle_ano
this.Control[iCurrent+16]=this.sle_dato
this.Control[iCurrent+17]=this.cb_mostrar
this.Control[iCurrent+18]=this.st_dato
this.Control[iCurrent+19]=this.dw_master
this.Control[iCurrent+20]=this.gb_1
end on

on w_sig780_presupuesto_total_grf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ingresos)
destroy(this.rb_egresos)
destroy(this.cb_ejecutar)
destroy(this.ddlb_seleccion)
destroy(this.cbx_fondos)
destroy(this.cb_resize)
destroy(this.dw_detalle)
destroy(this.cb_partidas)
destroy(this.cb_niveles)
destroy(this.dw_resumen)
destroy(this.sle_cuenta)
destroy(this.st_9)
destroy(this.st_etiqueta)
destroy(this.st_2)
destroy(this.sle_ano)
destroy(this.sle_dato)
destroy(this.cb_mostrar)
destroy(this.st_dato)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_detalle.height = newheight - dw_detalle.y - 10
end event

type rb_ingresos from radiobutton within w_sig780_presupuesto_total_grf
integer x = 2990
integer y = 12
integer width = 311
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingresos"
end type

event clicked;is_tipo_partida = 'I'
end event

type rb_egresos from radiobutton within w_sig780_presupuesto_total_grf
integer x = 2674
integer y = 12
integer width = 311
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Egresos"
boolean checked = true
end type

event clicked;is_tipo_partida = 'E'
end event

type cb_ejecutar from commandbutton within w_sig780_presupuesto_total_grf
integer x = 3625
integer y = 1132
integer width = 265
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "x Ejecutar"
end type

event clicked;STR_CNS_POP lstr_1

lstr_1.sle = sle_cuenta
lstr_1.DataObject = is_data_obj_eje
lstr_1.Width = 3400
lstr_1.Height= 1600
lstr_1.Arg[1] = is_doc_ot
lstr_1.Arg[2] = Trim(sle_dato.Text)
lstr_1.Title = 'Materiales Pendientes de Retiro'
lstr_1.Tipo_Cascada = 'C'
of_new_sheet(lstr_1)
end event

type ddlb_seleccion from dropdownlistbox within w_sig780_presupuesto_total_grf
integer x = 329
integer width = 453
integer height = 492
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Centro Costo","Nivel 1","Nivel 2","Nivel 3","Total"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;

CHOOSE CASE THIS.text
	CASE 'Centro Costo'
		cb_partidas.enabled = true
		cb_ejecutar.enabled = true
		cb_niveles.enabled = true
		st_dato.text = 'Centro Costo:'
		sle_dato.enabled = True
		is_data_obj_par = 'd_cencos_partidas_tbl'
		is_data_obj_eje = 'd_amp_x_ejecutar_tbl'
	CASE 'Total'
		cb_partidas.enabled = true
		cb_ejecutar.enabled = false
		cb_niveles.enabled = true
		st_dato.text = ''
		sle_dato.enabled = False
		is_data_obj_par = 'd_total_partidas_tbl'
	CASE 'Nivel 1'
		cb_partidas.enabled = true
		cb_ejecutar.enabled = false
		cb_niveles.enabled = True
		st_dato.text = 'Nivel 1:'
		sle_dato.enabled = True
		is_data_obj_par = 'd_n1_partidas_tbl'
	CASE 'Nivel 2'
		cb_partidas.enabled = true
		cb_ejecutar.enabled = false
		cb_niveles.enabled = True
		st_dato.text = 'Nivel 2:'
		sle_dato.enabled = True
		is_data_obj_par = 'd_n2_partidas_tbl'
	CASE 'Nivel 3'
		cb_partidas.enabled = true
		cb_ejecutar.enabled = false
		cb_niveles.enabled = True
		st_dato.text = 'Nivel 3:'
		sle_dato.enabled = True
		is_data_obj_par = 'd_n3_partidas_tbl'
END CHOOSE

end event

type cbx_fondos from checkbox within w_sig780_presupuesto_total_grf
integer x = 2263
integer y = 8
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sin Fondos"
boolean righttoleft = true
end type

event clicked;IF cbx_fondos.Checked THEN
	is_no_tipo = 'X'
ELSE
	is_no_tipo = '0'
END IF

end event

type cb_resize from commandbutton within w_sig780_presupuesto_total_grf
integer x = 3602
integer y = 8
integer width = 315
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ampliar Det"
end type

event clicked;Integer	li_height, li_height2

li_height = Parent.height - dw_detalle.y - 144

IF is_resize = 'N' THEN
	is_resize = 'S'
	dw_detalle.y = 76
	dw_detalle.height = li_height + 1145
	THIS.text = 'Reducir Det'
ELSE
	is_resize = 'N'
	dw_detalle.y = 1228
	dw_detalle.height = li_height - 1145
	THIS.text = 'Ampliar Det'
END IF
end event

type dw_detalle from u_dw_cns within w_sig780_presupuesto_total_grf
integer y = 1228
integer width = 3918
integer height = 620
integer taborder = 80
string dataobject = "d_presupuesto_ejecutado_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

type cb_partidas from commandbutton within w_sig780_presupuesto_total_grf
integer x = 3301
integer y = 1132
integer width = 242
integer height = 64
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Partidas"
end type

event clicked;STR_CNS_POP lstr_1

lstr_1.sle = sle_cuenta
lstr_1.rtn_field = 'cnta_prsp'
lstr_1.DataObject = is_data_obj_par
lstr_1.Width = 4200
lstr_1.Height= 1600
lstr_1.Arg[1] = Trim(sle_ano.Text)
lstr_1.Arg[2] = Trim(sle_dato.Text)
lstr_1.Arg[3] = is_no_tipo
lstr_1.Arg[4] = is_tipo_partida
lstr_1.Title = 'Partidas de Centro de Costo'
lstr_1.Tipo_Cascada = 'T'
of_new_sheet(lstr_1)
end event

type cb_niveles from commandbutton within w_sig780_presupuesto_total_grf
integer x = 2981
integer y = 1132
integer width = 242
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Niveles"
end type

event clicked;STR_CNS_POP lstr_1
Integer		ls_len

CHOOSE CASE ddlb_seleccion.text
	CASE 'Total'
		lstr_1.DataObject = 'd_niveles_cencos_tbl'
		lstr_1.rtn_field = 'cod_niv1'
	CASE 'Nivel 1'
		lstr_1.DataObject = 'd_niveles_cencos_n1_tbl'
		lstr_1.Arg[1] = Mid(sle_dato.Text,1,2)
		lstr_1.rtn_field = 'retorno'
	CASE 'Nivel 2'
		lstr_1.DataObject = 'd_niveles_cencos_n2_tbl'
		lstr_1.Arg[1] = Mid(sle_dato.Text,1,2)
		lstr_1.Arg[2] = Mid(sle_dato.Text,3,2)
		lstr_1.rtn_field = 'retorno'
	CASE 'Nivel 3'
		lstr_1.DataObject = 'd_niveles_cencos_n3_tbl'
		lstr_1.Arg[1] = Mid(sle_dato.Text,1,2)
		lstr_1.Arg[2] = Mid(sle_dato.Text,3,2)
		lstr_1.Arg[3] = Mid(sle_dato.Text,5,2)
		lstr_1.rtn_field = 'cencos'
	CASE 'Centro Costo'
		lstr_1.DataObject = 'd_niveles_cencos_tbl'
		lstr_1.rtn_field = 'cencos'	
END CHOOSE


lstr_1.sle = sle_dato
//lstr_1.rtn_field = 'cencos'
lstr_1.Width = 2200
lstr_1.Height= 1600
lstr_1.Title = 'Estructura de Niveles de Centro de Costo'
lstr_1.Tipo_Cascada = 'T'
of_new_sheet(lstr_1)


end event

type dw_resumen from u_dw_cns within w_sig780_presupuesto_total_grf
event ue_mousemove pbm_mousemove
integer x = 2834
integer y = 88
integer width = 1083
integer height = 956
integer taborder = 60
string dataobject = "d_presupuesto_total_resumen_grf"
end type

event ue_mousemove;	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos + 2500
 		st_etiqueta.y = ypos 
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF



end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

type sle_cuenta from singlelineedit within w_sig780_presupuesto_total_grf
integer x = 1797
integer y = 8
integer width = 439
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_sig780_presupuesto_total_grf
integer x = 1582
integer y = 8
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta:"
boolean focusrectangle = false
end type

type st_etiqueta from statictext within w_sig780_presupuesto_total_grf
boolean visible = false
integer x = 3168
integer y = 28
integer width = 105
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type st_2 from statictext within w_sig780_presupuesto_total_grf
integer y = 8
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_sig780_presupuesto_total_grf
integer x = 128
integer y = 8
integer width = 169
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_dato from singlelineedit within w_sig780_presupuesto_total_grf
integer x = 1216
integer y = 8
integer width = 329
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_mostrar from commandbutton within w_sig780_presupuesto_total_grf
integer x = 3319
integer y = 8
integer width = 261
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;String	ls_nivel, ls_nivel1, ls_nivel2, ls_nivel3, ls_nombre
String	ls_cuenta, ls_nom_cuenta, ls_tipo
Integer	li_ano
Long		ll_total
Boolean	lbo_cuenta

//IF Not(of_verificar_acceso)THEN GOTO SALIDA

ls_nivel = TRIM(sle_dato.Text)
li_ano	= Integer(sle_ano.Text)

IF Len(sle_cuenta.Text) > 0 THEN
	lbo_cuenta = True
	ls_cuenta = TRIM(sle_cuenta.Text)
	ls_nom_cuenta = of_get_nom_cuenta(ls_cuenta)
	IF ls_nom_cuenta = "" THEN lbo_cuenta = False
ELSE	
	lbo_cuenta = False
END IF

IF is_tipo_partida = 'E' THEN
	ls_tipo = 'Egresos'
ELSE
	ls_tipo = 'Ingresos'
END IF

CHOOSE CASE ddlb_seleccion.text
	CASE 'Total'
		idw_1.Reset()
		dw_resumen.Reset()
		IF lbo_cuenta THEN
			idw_1.Object.gr_1.Title = 'Presupuesto Total de ' + ls_tipo + ' Cta: ' + ls_nom_cuenta
			ll_total = ids_total_cuenta.Retrieve(li_ano, ls_cuenta, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_total_cuenta, idw_1, dw_resumen)
		ELSE
			idw_1.Object.gr_1.Title = 'Presupuesto Total de ' + ls_tipo
			ll_total = ids_total.Retrieve(li_ano, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_total, idw_1, dw_resumen)
		END IF	
	CASE 'Centro Costo'
		idw_1.Reset()
		dw_resumen.Reset()
		ls_nombre = of_get_cencos(ls_nivel)
		IF lbo_cuenta THEN
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' : ' + ls_nombre + ' Cta: ' + ls_nom_cuenta
			ll_total = ids_cencos_cuenta.Retrieve(li_ano, ls_nivel, ls_cuenta, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_cencos_cuenta, idw_1, dw_resumen)
		ELSE
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' : ' + ls_nombre
			ll_total = ids_cencos.Retrieve(li_ano, ls_nivel, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_cencos, idw_1, dw_resumen)
		END IF
	CASE 'Nivel 1'
		idw_1.Reset()
		dw_resumen.Reset()
		ls_nivel1 = Mid(ls_nivel, 1, 2)
		ls_nombre = of_get_nombre(ls_nivel1)
		IF lbo_cuenta THEN
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre + ' Cta: ' + ls_nom_cuenta
			ll_total = ids_nivel1_cuenta.Retrieve(li_ano, ls_nivel1, ls_cuenta, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel1_cuenta, idw_1, dw_resumen)
		ELSE
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre
			ll_total = ids_nivel1.Retrieve(li_ano, ls_nivel1, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel1, idw_1, dw_resumen)
		END IF
	CASE 'Nivel 2'
		idw_1.Reset()
		dw_resumen.Reset()
		ls_nivel1 = Mid(ls_nivel, 1, 2)
		ls_nivel2 = Mid(ls_nivel, 3, 2)
		ls_nombre = of_get_nombre(ls_nivel1, ls_nivel2)
		IF lbo_cuenta THEN
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre + ' Cta: ' + ls_nom_cuenta
			ll_total = ids_nivel2_cuenta.Retrieve(li_ano, ls_nivel1, ls_nivel2, ls_cuenta, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel2_cuenta, idw_1, dw_resumen)
		ELSE
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre
			ll_total = ids_nivel2.Retrieve(li_ano, ls_nivel1, ls_nivel2, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel2, idw_1, dw_resumen)
		END IF
	CASE 'Nivel 3'
		idw_1.Reset()
		dw_resumen.Reset()
		ls_nivel1 = Mid(ls_nivel, 1, 2)
		ls_nivel2 = Mid(ls_nivel, 3, 2)
		ls_nivel3 = Mid(ls_nivel, 5, 2)
		ls_nombre = of_get_nombre(ls_nivel1, ls_nivel2, ls_nivel3)
		IF lbo_cuenta THEN
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre + ' Cta: ' + ls_nom_cuenta
			ll_total = ids_nivel3_cuenta.Retrieve(li_ano, ls_nivel1, ls_nivel2, ls_nivel3, ls_cuenta, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel3_cuenta, idw_1, dw_resumen)
		ELSE
			idw_1.Object.gr_1.Title = 'Presupuesto de ' + ls_tipo + ' Nivel: ' + ls_nombre
			ll_total = ids_nivel3.Retrieve(li_ano, ls_nivel1, ls_nivel2, ls_nivel3, is_no_tipo, is_tipo_partida)
			IF ll_total =1 THEN of_set_grf(ids_nivel3, idw_1, dw_resumen)
		END IF
END CHOOSE



dw_detalle.Reset()

end event

type st_dato from statictext within w_sig780_presupuesto_total_grf
integer x = 814
integer y = 8
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_sig780_presupuesto_total_grf
event ue_mousemove pbm_mousemove
integer y = 88
integer width = 2802
integer height = 1128
integer taborder = 0
string dataobject = "d_presupuesto_total_ano_grf"
end type

event ue_mousemove;	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos 
 		st_etiqueta.y = ypos 
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF



end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

event doubleclicked;call super::doubleclicked;grObjectType	lgr_click_obj
string			ls_categoria, ls_serie, ls_grgraphname="gr_1"
String			ls_cadena, ls_sql_old, ls_sql_new, ls_mes, ls_ano
int				li_series, li_category, li_mes
Long				ll_rc, ll_row, ll_plantas
STR_CNS_POP 	lstr_1


// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)
// Determinar que categoria se Clicko
If lgr_click_obj = TypeData!  or &
   lgr_click_obj = TypeCategory!  then
	ls_categoria = THIS.CategoryName (ls_grgraphname, li_category)
	ls_serie     = THIS.SeriesName(ls_grgraphname, li_series)
	IF ls_serie = 'Ejecutado' THEN
		ls_mes = Trim(ls_categoria)
		ls_ano = Trim(sle_ano.Text)
		IF Len(ls_mes) = 1 THEN ls_mes = '0' + ls_mes
		ls_sql_old = dw_detalle.getsqlselect()
		ls_cadena = of_get_cadena(ls_ano, ls_mes)
		ls_sql_new = ls_sql_old + ls_cadena
		dw_detalle.setsqlselect(ls_sql_new)
		dw_detalle.Retrieve()
		dw_detalle.setsqlselect(ls_sql_old)
	END IF
Else
	MessageBox (Parent.Title, "Haga Click sobre el Presupuesto Ejecutado")
End If


end event

type gb_1 from groupbox within w_sig780_presupuesto_total_grf
integer x = 2834
integer y = 1056
integer width = 1083
integer height = 160
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consultas"
end type

