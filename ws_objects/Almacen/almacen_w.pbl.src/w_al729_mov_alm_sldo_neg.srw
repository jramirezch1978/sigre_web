$PBExportHeader$w_al729_mov_alm_sldo_neg.srw
forward
global type w_al729_mov_alm_sldo_neg from w_report_smpl
end type
type cb_3 from commandbutton within w_al729_mov_alm_sldo_neg
end type
type hpb_1 from hprogressbar within w_al729_mov_alm_sldo_neg
end type
type st_2 from statictext within w_al729_mov_alm_sldo_neg
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al729_mov_alm_sldo_neg
end type
type sle_almacen from singlelineedit within w_al729_mov_alm_sldo_neg
end type
type sle_descrip from singlelineedit within w_al729_mov_alm_sldo_neg
end type
type st_1 from statictext within w_al729_mov_alm_sldo_neg
end type
type cbx_1 from checkbox within w_al729_mov_alm_sldo_neg
end type
type st_left_time from statictext within w_al729_mov_alm_sldo_neg
end type
type gb_fechas from groupbox within w_al729_mov_alm_sldo_neg
end type
type gb_1 from groupbox within w_al729_mov_alm_sldo_neg
end type
end forward

global type w_al729_mov_alm_sldo_neg from w_report_smpl
integer width = 3515
integer height = 1612
string title = "[AL729] Movimientos de Almacen Con Saldo o Valor Negativo"
string menuname = "m_impresion"
event ue_retrieve2 ( )
cb_3 cb_3
hpb_1 hpb_1
st_2 st_2
uo_fecha uo_fecha
sle_almacen sle_almacen
sle_descrip sle_descrip
st_1 st_1
cbx_1 cbx_1
st_left_time st_left_time
gb_fechas gb_fechas
gb_1 gb_1
end type
global w_al729_mov_alm_sldo_neg w_al729_mov_alm_sldo_neg

type variables

end variables

forward prototypes
public function boolean of_reproc_art (string as_cod_art, date ad_fecha1, date ad_fecha2)
end prototypes

event ue_retrieve2();Date 		ld_fecha1, ld_fecha2
String	ls_mensaje, ls_codigo
Long 		ll_count, ll_max

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

SetPointer(HourGlass!)

select count(distinct am.cod_art )
 	into :ll_max
 from articulo_mov am,
		vale_mov     vm,
		articulo     a
where am.nro_vale = vm.nro_vale
  and am.cod_art  = a.cod_art
  and vm.flag_estado <> '0'
  and am.flag_estado <> '0'
  and NVL(a.flag_estado, '0') = '1'
  and NVL(a.flag_inventariable,'0') = '1'
  and trunc(vm.fec_registro) between trunc(:ld_fecha1) and trunc(:ld_fecha2);

hpb_1.visible 	= true
st_2.Visible 	= true
hpb_1.MaxPosition = ll_max

// recorrido de los articulos
DECLARE c_articulos CURSOR FOR  
	select distinct am.cod_art
	 from articulo_mov am,
			vale_mov     vm,
			articulo     a
	where am.nro_vale = vm.nro_vale
	  and am.cod_art  = a.cod_art
	  and vm.flag_estado <> '0'
	  and am.flag_estado <> '0'
	  and NVL(a.flag_estado, '0') = '1'
	  and NVL(a.flag_inventariable,'0') = '1'
	  and trunc(vm.fec_registro) >= trunc(:ld_fecha1)
	  and trunc(vm.fec_registro) <= trunc(:ld_fecha2);

open c_articulos;

fetch c_articulos into :ls_codigo;

ll_count = 0
do while SQLCA.SQLCode <> 100 
	if SQLCA.SQlCode = -1 then
		ls_mensaje =SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		SetPointer(Arrow!)
		return
	end if
	ll_count ++
	hpb_1.Position = ll_count
	if of_reproc_art (ls_codigo, ld_fecha1, ld_fecha2) = false then
		ROLLBACK;
		SetPointer(Arrow!)
		return
	end if
	st_2.text = string(ll_count) + ' / ' + string(ll_max)
	fetch c_articulos into :ls_codigo;
loop

hpb_1.visible 	= false
st_2.Visible 	= false

idw_1.Object.DataWindow.Print.Orientation = 1
idw_1.Retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(ld_fecha1, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_fecha2, "DD/MM/YYYY")		
idw_1.object.t_user.text 		= gs_user
idw_1.Object.p_logo.filename = gs_logo

SetPointer(Arrow!)
end event

public function boolean of_reproc_art (string as_cod_art, date ad_fecha1, date ad_fecha2);string ls_mensaje
//CREATE OR REPLACE PROCEDURE usp_alm_verf_saldos_alm(
//       asi_cod_art          in  articulo.cod_art%TYPE,
//       adi_fecha1           in  date,
//       adi_fecha2           in  date
//) is

DECLARE usp_alm_verf_saldos_alm PROCEDURE FOR
	usp_alm_verf_saldos_alm( :as_cod_art,
									 :ad_fecha1, 
									 :ad_fecha2 );

EXECUTE usp_alm_verf_saldos_alm;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_verf_saldos_alm:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE usp_alm_verf_saldos_alm;

return true
end function

on w_al729_mov_alm_sldo_neg.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.hpb_1=create hpb_1
this.st_2=create st_2
this.uo_fecha=create uo_fecha
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_1=create st_1
this.cbx_1=create cbx_1
this.st_left_time=create st_left_time
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.hpb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.sle_almacen
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.st_left_time
this.Control[iCurrent+10]=this.gb_fechas
this.Control[iCurrent+11]=this.gb_1
end on

on w_al729_mov_alm_sldo_neg.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.hpb_1)
destroy(this.st_2)
destroy(this.uo_fecha)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.st_left_time)
destroy(this.gb_fechas)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.SetTransObject( sqlca)


end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

event ue_retrieve;call super::ue_retrieve;Date 		ld_fecha1, ld_fecha2
String	ls_mensaje, ls_codigo, ls_almacen
Long 		ll_count, ll_max

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if



//create or replace procedure usp_alm_verif_saldos_art(
//       adi_fecha1  in date,
//       adi_fecha2  in date,
//       asi_almacen in almacen.almacen%TYPE
//) is

DECLARE usp_alm_verif_saldos_art PROCEDURE FOR
	usp_alm_verif_saldos_art( :ld_fecha1, 
									  :ld_fecha2,
									  :ls_almacen);

EXECUTE usp_alm_verif_saldos_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_verif_saldos_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', "Error al ejecutar procedure usp_alm_verif_saldos_art. Mensaje: " + ls_mensaje, StopSign!)
	Return
END IF

CLOSE usp_alm_verif_saldos_art;

ib_preview = true
event ue_preview()

idw_1.SetFilter('')
idw_1.Filter()

idw_1.Object.DataWindow.Print.Orientation = 1
idw_1.Retrieve()


idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(ld_fecha1, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_fecha2, "DD/MM/YYYY")		
idw_1.object.t_user.text 		= gs_user
idw_1.Object.p_logo.filename = gs_logo

SetPointer(Arrow!)
end event

type dw_report from w_report_smpl`dw_report within w_al729_mov_alm_sldo_neg
integer x = 0
integer y = 312
integer width = 2761
integer height = 1060
string dataobject = "d_rpt_mov_alm_sldo_neg"
end type

type cb_3 from commandbutton within w_al729_mov_alm_sldo_neg
integer x = 2446
integer y = 36
integer width = 731
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;
this.enabled = false

SetPointer(HourGlass!)
parent.Event ue_retrieve()
SetPointer(Arrow!)

this.enabled = true
end event

type hpb_1 from hprogressbar within w_al729_mov_alm_sldo_neg
boolean visible = false
integer x = 2446
integer y = 232
integer width = 731
integer height = 64
boolean bringtotop = true
integer setstep = 1
boolean smoothscroll = true
end type

type st_2 from statictext within w_al729_mov_alm_sldo_neg
boolean visible = false
integer x = 2446
integer y = 160
integer width = 731
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_al729_mov_alm_sldo_neg
event destroy ( )
integer x = 18
integer y = 60
integer taborder = 40
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_almacen from singlelineedit within w_al729_mov_alm_sldo_neg
event dobleclick pbm_lbuttondblclk
integer x = 1015
integer y = 48
integer width = 224
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al729_mov_alm_sldo_neg
integer x = 1243
integer y = 48
integer width = 1157
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al729_mov_alm_sldo_neg
integer x = 709
integer y = 60
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_al729_mov_alm_sldo_neg
integer x = 722
integer y = 136
integer width = 677
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type st_left_time from statictext within w_al729_mov_alm_sldo_neg
integer x = 695
integer y = 232
integer width = 1705
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_fechas from groupbox within w_al729_mov_alm_sldo_neg
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_al729_mov_alm_sldo_neg
integer x = 677
integer width = 1746
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

