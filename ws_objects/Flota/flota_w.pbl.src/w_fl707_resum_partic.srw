$PBExportHeader$w_fl707_resum_partic.srw
forward
global type w_fl707_resum_partic from w_rpt
end type
type em_ano from editmask within w_fl707_resum_partic
end type
type em_semana from editmask within w_fl707_resum_partic
end type
type st_3 from statictext within w_fl707_resum_partic
end type
type st_2 from statictext within w_fl707_resum_partic
end type
type dw_report from u_dw_rpt within w_fl707_resum_partic
end type
type sle_nave from singlelineedit within w_fl707_resum_partic
end type
type st_1 from statictext within w_fl707_resum_partic
end type
type st_nomb_nave from statictext within w_fl707_resum_partic
end type
type pb_recuperar from u_pb_std within w_fl707_resum_partic
end type
end forward

global type w_fl707_resum_partic from w_rpt
integer width = 2528
integer height = 2032
string title = "Planilla resumen de Participacion de Pesca (FL707)"
string menuname = "m_rep_grf"
long backcolor = 67108864
em_ano em_ano
em_semana em_semana
st_3 st_3
st_2 st_2
dw_report dw_report
sle_nave sle_nave
st_1 st_1
st_nomb_nave st_nomb_nave
pb_recuperar pb_recuperar
end type
global w_fl707_resum_partic w_fl707_resum_partic

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl707_resum_partic.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.em_ano=create em_ano
this.em_semana=create em_semana
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
this.sle_nave=create sle_nave
this.st_1=create st_1
this.st_nomb_nave=create st_nomb_nave
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.em_semana
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.sle_nave
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_nomb_nave
this.Control[iCurrent+9]=this.pb_recuperar
end on

on w_fl707_resum_partic.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.em_semana)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.st_nomb_nave)
destroy(this.pb_recuperar)
end on

event ue_retrieve;call super::ue_retrieve;integer li_semana, li_ano, li_ok
string ls_nave, ls_mensaje, ls_nnave
date ld_fecha1, ld_fecha2

ls_nave = trim(sle_nave.text)
li_ano = integer(em_ano.text)
li_semana = integer(em_semana.text)


//create or replace procedure USP_FL_RESUMEN_PART(
//		asi_nave		in tg_naves.nave%TYPE, 
//    aii_semana	in number,
//		aii_ano		in number,
//    aso_mensaje out varchar2, 
//    aio_ok 		out number) is

DECLARE USP_FL_RESUMEN_PART PROCEDURE FOR
	USP_FL_RESUMEN_PART( :ls_nave, :li_semana, :li_ano );

EXECUTE USP_FL_RESUMEN_PART;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_RESUMEN_PART: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_FL_RESUMEN_PART INTO :ls_mensaje, :li_ok;
CLOSE USP_FL_RESUMEN_PART;

if li_ok <> 1 then
	MessageBox('Error USP_FL_RESUMEN_PART', ls_mensaje, StopSign!)	
	return
end if

select nomb_nave
	into :ls_nnave
from tg_naves
where nave = :ls_nave;

select s.fecha_inicio, usf_fl_fecha_fin(s.fecha_inicio)
	into :ld_fecha1, :ld_fecha2
from semanas s
where s.ano = :li_ano
  and s.semana = :li_semana;

idw_1.SetRedraw(false)
idw_1.object.Datos.text = 'Embarcación: ' + ls_nnave &
		+ '~r~nSemana: ' + string(li_semana) + ' DEL ' &
		+ string(ld_fecha1, 'dd/mm/yyyy') + ' AL ' &
		+ string(ld_fecha2, 'dd/mm/yyyy')
idw_1.Retrieve()
idw_1.SetRedraw(true)
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 2

THIS.Event ue_preview()

iuo_parte = CREATE uo_parte_pesca

em_ano.text = string( year( today() ) )

end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type em_ano from editmask within w_fl707_resum_partic
integer x = 338
integer y = 28
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

type em_semana from editmask within w_fl707_resum_partic
integer x = 1307
integer y = 28
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

type st_3 from statictext within w_fl707_resum_partic
integer x = 137
integer y = 48
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

type st_2 from statictext within w_fl707_resum_partic
integer x = 928
integer y = 48
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Semana:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl707_resum_partic
integer y = 276
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_resumen_participacion_composite"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

type sle_nave from singlelineedit within w_fl707_resum_partic
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 164
integer width = 293
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " &
		 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

If not IsValid(iuo_parte) then
	return
end if

ls_codigo = trim(this.text)

ls_data = iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_report.reset()
	return
end if
		
if iuo_parte.of_get_tipo_flota( ls_codigo ) <> 'P' then
	Messagebox('Error', "SOLO SE IMPRIMIR ASISTENCIA EN EMBACARCIONES PROPIAS", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_report.reset()
	return
end if
st_nomb_nave.text = ls_data

parent.event dynamic ue_retrieve()
end event

type st_1 from statictext within w_fl707_resum_partic
integer x = 59
integer y = 176
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nomb_nave from statictext within w_fl707_resum_partic
integer x = 818
integer y = 164
integer width = 951
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type pb_recuperar from u_pb_std within w_fl707_resum_partic
integer x = 1915
integer y = 32
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
string powertiptext = "Recuperar Datos"
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

