$PBExportHeader$w_fl729_resumen_planilla.srw
forward
global type w_fl729_resumen_planilla from w_report_smpl
end type
type pb_reporte from picturebutton within w_fl729_resumen_planilla
end type
type st_nomb_nave from statictext within w_fl729_resumen_planilla
end type
type st_1 from statictext within w_fl729_resumen_planilla
end type
type sle_nave from singlelineedit within w_fl729_resumen_planilla
end type
type st_2 from statictext within w_fl729_resumen_planilla
end type
type sle_year from singlelineedit within w_fl729_resumen_planilla
end type
type sle_semana from singlelineedit within w_fl729_resumen_planilla
end type
type gb_1 from groupbox within w_fl729_resumen_planilla
end type
end forward

global type w_fl729_resumen_planilla from w_report_smpl
boolean visible = false
integer width = 2939
integer height = 2252
string title = "[FL729] Resumen Calculo de Participación"
string menuname = "m_impresion"
pb_reporte pb_reporte
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
st_2 st_2
sle_year sle_year
sle_semana sle_semana
gb_1 gb_1
end type
global w_fl729_resumen_planilla w_fl729_resumen_planilla

on w_fl729_resumen_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.pb_reporte=create pb_reporte
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.st_2=create st_2
this.sle_year=create sle_year
this.sle_semana=create sle_semana
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_reporte
this.Control[iCurrent+2]=this.st_nomb_nave
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_nave
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.sle_semana
this.Control[iCurrent+8]=this.gb_1
end on

on w_fl729_resumen_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_reporte)
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
destroy(this.st_2)
destroy(this.sle_year)
destroy(this.sle_semana)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date ld_hoy
Integer	li_year, li_semana

idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = true
THIS.Event ue_preview()

//em_Fecha1.text = '01/01/' + string(date(gnvo_app.of_fecha_actual( )), 'yyyy')
//em_Fecha2.text = string(date(gnvo_app.of_fecha_actual( )), 'dd/mm/yyyy')

ld_hoy = Date(gnvo_app.of_fecha_actual( ))

select ano, semana
	into :li_year, :li_Semana
from semanas
where :ld_hoy between fecha_inicio and fecha_fin;

sle_year.text = string(li_year)
sle_semana.text = string(li_semana)
end event

event ue_retrieve;call super::ue_retrieve;Date   ld_fecha1,ld_fecha2
Integer	li_year, li_Semana
String	ls_nave

//rango de fechas
dw_report.Settransobject(sqlca)

ib_preview = true
event ue_preview( )

ls_nave = sle_nave.text

if trim(ls_nave) = '' then
	gnvo_app.of_message_error("Debe Ingresar código de nave")
	sle_nave.setfocus( )	
	return
end if

li_year = Integer(sle_year.text)
li_semana = Integer(sle_semana.text)

select fecha_inicio, fecha_fin
	into :ld_fecha1, :ld_Fecha2
from semanas
where ano = :li_year
  and semana = :li_semana;

dw_report.Retrieve(ls_nave, ld_fecha1, ld_fecha2)
dw_report.object.datawindow.print.orientation = 1
//dw_report.object.datawindow.print.paper.size = 8

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_user.text 	= gs_user
dw_report.Object.t_empresa.text 	= gs_empresa
dw_report.Object.t_ventana.text 	= this.ClassName()
dw_report.object.t_stitulo1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_fl729_resumen_planilla
integer x = 0
integer y = 248
integer width = 2921
integer height = 1656
string dataobject = "d_rpt_consolidado_pesca_ctr"
end type

type pb_reporte from picturebutton within w_fl729_resumen_planilla
integer x = 2126
integer y = 48
integer width = 366
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\bmp\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
ib_preview = false
parent.event ue_preview( )
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type st_nomb_nave from statictext within w_fl729_resumen_planilla
integer x = 791
integer y = 56
integer width = 951
integer height = 72
boolean bringtotop = true
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

type st_1 from statictext within w_fl729_resumen_planilla
integer x = 32
integer y = 56
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nave : "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl729_resumen_planilla
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 480
integer y = 56
integer width = 293
integer height = 72
integer taborder = 20
boolean bringtotop = true
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
ls_codigo = this.text

select nomb_nave
	into :ls_Data
from tg_naves
where nave = :ls_codigo
  and flag_tipo_flota = 'P';

if SQLCA.SQLCode = 100 then
	gnvo_app.of_message_error("El código de nave ingresado no existe, o no esta activo o no corresponde a una embarcación propia")
	st_nomb_nave.text = ''
	this.setFocus()
	return
end if

st_nomb_nave.text = ls_data
end event

type st_2 from statictext within w_fl729_resumen_planilla
integer x = 37
integer y = 144
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana : "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_fl729_resumen_planilla
integer x = 475
integer y = 144
integer width = 229
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_semana from singlelineedit within w_fl729_resumen_planilla
integer x = 704
integer y = 144
integer width = 137
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fl729_resumen_planilla
integer width = 2514
integer height = 236
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtros de Busqueda"
end type

