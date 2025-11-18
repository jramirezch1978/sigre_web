$PBExportHeader$w_fl715_pago_derecho_pesca.srw
forward
global type w_fl715_pago_derecho_pesca from w_rpt
end type
type uo_fecha from u_ingreso_fecha within w_fl715_pago_derecho_pesca
end type
type ddlb_mes from dropdownlistbox within w_fl715_pago_derecho_pesca
end type
type cb_2 from commandbutton within w_fl715_pago_derecho_pesca
end type
type cb_1 from commandbutton within w_fl715_pago_derecho_pesca
end type
type em_ano from editmask within w_fl715_pago_derecho_pesca
end type
type st_3 from statictext within w_fl715_pago_derecho_pesca
end type
type st_2 from statictext within w_fl715_pago_derecho_pesca
end type
type dw_report from u_dw_rpt within w_fl715_pago_derecho_pesca
end type
end forward

global type w_fl715_pago_derecho_pesca from w_rpt
integer width = 2994
integer height = 2392
string title = "Declaracion Derecho Pesca (FL715)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_generar_ce ( )
uo_fecha uo_fecha
ddlb_mes ddlb_mes
cb_2 cb_2
cb_1 cb_1
em_ano em_ano
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl715_pago_derecho_pesca w_fl715_pago_derecho_pesca

type variables
uo_parte_pesca iuo_parte
date 		id_fecha
Integer	ii_grab_fecha = 0
end variables

event ue_generar_ce();integer 	li_mes, li_ano
string	ls_mes, ls_mensaje

li_ano = integer(em_ano.text)
li_mes = integer(left(ddlb_mes.text,2))
ls_mes = MID(ddlb_mes.text, 5)

idw_1.Retrieve(li_ano, li_mes)
idw_1.Object.t_titulo1.text = ls_mes + ' - Año ' + string(li_ano)


if MessageBox('Aviso', 'Desea generar el comprobante de Egreso?', &
	Information!, YesNo!, 2) = 2 then return

SetPointer(HourGlass!)

//create or replace procedure USP_FL_GEN_CPD_DEREC_PESCA(
//       ani_year      in number,
//       ani_mes    	  in number,
//       asi_usuario   in usuario.cod_usr%TYPE,
//       asi_origen    in origen.cod_origen%TYPE
//) is

DECLARE USP_FL_GEN_CPD_DEREC_PESCA PROCEDURE FOR
	USP_FL_GEN_CPD_DEREC_PESCA( :li_ano,
								:li_mes,
								:gs_user,
								:gs_origen );

EXECUTE USP_FL_GEN_CPD_DEREC_PESCA;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_GEN_CPD_DEREC_PESCA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_GEN_CPD_DEREC_PESCA;

MessageBox('Aviso', 'Proceso realizado satisfactoriamente')

SetPointer(Arrow!)	
end event

on w_fl715_pago_derecho_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.uo_fecha=create uo_fecha
this.ddlb_mes=create ddlb_mes
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_ano=create em_ano
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_report
end on

on w_fl715_pago_derecho_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.ddlb_mes)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_mes, li_year
string	ls_mes, ls_banco, ls_nro_cta, ls_nom_banco, &
			ls_produce, ls_mensaje
date		ld_fecha

li_year = integer(em_ano.text)
li_mes  = integer(left(ddlb_mes.text,2))
ls_mes  = MID(ddlb_mes.text, 5)

ld_fecha = uo_fecha.of_get_fecha( )

if ld_fecha <> id_fecha or ii_grab_fecha = 1 then
	update fl_derecho_pesca
	   set fecha_pago = :ld_fecha
	 where ano = :li_year
	   and mes = :li_mes;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al momento de actualizar la fecha de pago', ls_mensaje)
		return
	end if
	
	COMMIT;
	
	ii_grab_fecha = 0
	id_fecha = ld_fecha
end if

select nom_banco
  into :ls_banco
  from banco a,
  		 fl_param b
where a.cod_banco = b.banco_pago_dp;

select NRO_CTA_BANCO_DP
  into :ls_nro_cta
  from fl_param
 where reckey = '1';

select nom_proveedor
  into :ls_produce
  from proveedor a,
  	    fl_param b
where a.proveedor = b.prov_produce;			

idw_1.Retrieve(li_year, li_mes)
idw_1.Object.t_titulo1.text = ls_mes + ' - Año ' + string(li_year)
idw_1.Object.t_titulo2.text = 'CTA CTE: ' + ls_produce
idw_1.Object.t_titulo3.text = ls_nro_cta + '   ' + ls_banco 
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 2

THIS.Event ue_preview()

iuo_parte = CREATE uo_parte_pesca

em_ano.text = string( year( today() ) )

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_empresa.text 	= gs_empresa
idw_1.object.t_usuario.text	= gs_user
idw_1.object.t_objeto.text		= this.classname()
end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type uo_fecha from u_ingreso_fecha within w_fl715_pago_derecho_pesca
integer x = 1426
integer y = 24
integer taborder = 40
end type

event constructor;call super::constructor; of_set_label('Pago:') // para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type ddlb_mes from dropdownlistbox within w_fl715_pago_derecho_pesca
integer x = 841
integer y = 20
integer width = 544
integer height = 512
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;integer 	li_year, li_mes


li_year = integer(em_ano.text)
li_mes  = Integer(left(this.text,2))

select fecha_pago
	into :id_fecha
from fl_derecho_pesca
where ano = :li_year
  and mes = :li_mes;

if IsNull(id_fecha) then 
	id_fecha = date(f_fecha_actual())
	ii_grab_fecha = 1
end if

uo_fecha.of_set_fecha( id_fecha )
end event

type cb_2 from commandbutton within w_fl715_pago_derecho_pesca
integer x = 2469
integer y = 20
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar CE"
end type

event clicked;Parent.event dynamic ue_generar_ce( )
end event

type cb_1 from commandbutton within w_fl715_pago_derecho_pesca
integer x = 2071
integer y = 20
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve( )
end event

type em_ano from editmask within w_fl715_pago_derecho_pesca
integer x = 233
integer y = 20
integer width = 375
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type st_3 from statictext within w_fl715_pago_derecho_pesca
integer x = 32
integer y = 20
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl715_pago_derecho_pesca
integer x = 622
integer y = 20
integer width = 178
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl715_pago_derecho_pesca
integer y = 168
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_pago_derecho_pesca"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

