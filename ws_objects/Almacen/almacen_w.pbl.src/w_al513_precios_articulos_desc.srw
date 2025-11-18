$PBExportHeader$w_al513_precios_articulos_desc.srw
forward
global type w_al513_precios_articulos_desc from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_al513_precios_articulos_desc
end type
type cb_procesar from commandbutton within w_al513_precios_articulos_desc
end type
type uo_fecha from u_ingreso_fecha within w_al513_precios_articulos_desc
end type
end forward

global type w_al513_precios_articulos_desc from w_abc_master_smpl
integer height = 1140
string title = "Saldos Descuadrados (AL513)"
string menuname = "m_salir"
event ue_procesar ( )
event ue_reporte ( )
cb_1 cb_1
cb_procesar cb_procesar
uo_fecha uo_fecha
end type
global w_al513_precios_articulos_desc w_al513_precios_articulos_desc

forward prototypes
public function boolean of_procesar (string as_cod_art)
end prototypes

event ue_procesar();string 	ls_mensaje, ls_cod_art
Long		ll_i, ll_count

SetPointer(HourGlass!)
ll_count = dw_master.RowCount()
for ll_i = 1 to ll_Count 
	ls_cod_art = dw_master.object.cod_art[ll_i]
	SetMicroHelp('Procesando: ' + string(ll_i/ll_count * 100, '###.000') + '%')
	if of_procesar(dw_master.object.cod_art[ll_i])= false then return 
	
next

SetPointer(Arrow!)
end event

event ue_reporte();SetPointer(HourGlass!)
dw_master.Retrieve()
if dw_master.RowCount() > 0 then
	cb_procesar.enabled = true
	uo_fecha.enabled = true
end if
SetPointer(Arrow!)
end event

public function boolean of_procesar (string as_cod_art);string  	ls_mensaje
integer 	li_ok
date 		ld_fecha

ld_fecha = uo_fecha.of_get_fecha()

// Calcula el precio Promedio del Articulo x Almacen
// Revaloriza los movimientos de almacen desde una determinada fecha

//CREATE OR REPLACE PROCEDURE usp_alm_act_valor_x_art_alm(
//       asi_cod_art          in  articulo.cod_art%TYPE,
//       adi_fecha            in  date,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_valor_x_art_alm PROCEDURE FOR
	usp_alm_act_valor_x_art_alm( :as_cod_art, :ld_fecha );

EXECUTE usp_alm_act_valor_x_art_alm;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_valor_x_art_alm:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH usp_alm_act_valor_x_art_alm INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_valor_x_art_alm;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso usp_alm_act_valor_x_art_alm', ls_mensaje)
	return false
end if

// Calcula el precio Promedio del Articulo en General
// No hace reemplazo en ningun Movimiento de Almacen

//CREATE OR REPLACE PROCEDURE usp_alm_act_valor_x_art(
//       asi_cod_art          in  articulo.cod_art%TYPE,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_valor_x_art PROCEDURE FOR
	usp_alm_act_valor_x_art( :as_cod_art );

EXECUTE usp_alm_act_valor_x_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_valor_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH usp_alm_act_valor_x_art INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_valor_x_art;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso usp_alm_act_valor_x_art', ls_mensaje)
	return false
end if
return true
end function

on w_al513_precios_articulos_desc.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.uo_fecha
end on

on w_al513_precios_articulos_desc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_procesar)
destroy(this.uo_fecha)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

type dw_master from w_abc_master_smpl`dw_master within w_al513_precios_articulos_desc
integer x = 0
integer y = 120
string dataobject = "d_rpt_dif_prec_prom_grd"
end type

type cb_1 from commandbutton within w_al513_precios_articulos_desc
integer y = 8
integer width = 402
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event dynamic ue_reporte()
end event

type cb_procesar from commandbutton within w_al513_precios_articulos_desc
integer x = 421
integer y = 8
integer width = 402
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;parent.event dynamic ue_procesar()
end event

type uo_fecha from u_ingreso_fecha within w_al513_precios_articulos_desc
integer x = 983
integer y = 16
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
end type

event constructor;call super::constructor;string ls_fecha

ls_fecha = '01/01/' + string(year(Today()))

of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date(ls_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

