$PBExportHeader$w_fl700_bitacora.srw
forward
global type w_fl700_bitacora from w_report_smpl
end type
type st_state from statictext within w_fl700_bitacora
end type
type uo_fechas from u_ingreso_rango_fechas within w_fl700_bitacora
end type
type st_1 from statictext within w_fl700_bitacora
end type
type cb_2 from commandbutton within w_fl700_bitacora
end type
type sle_nave from singlelineedit within w_fl700_bitacora
end type
type st_nomb_nave from statictext within w_fl700_bitacora
end type
end forward

global type w_fl700_bitacora from w_report_smpl
integer width = 3470
integer height = 1352
string title = "Reportes"
string menuname = "m_impresion"
event ue_copiar ( )
event ue_query_retrieve ( )
st_state st_state
uo_fechas uo_fechas
st_1 st_1
cb_2 cb_2
sle_nave sle_nave
st_nomb_nave st_nomb_nave
end type
global w_fl700_bitacora w_fl700_bitacora

type variables

end variables

event ue_copiar();dw_report.Clipboard("gr_1")

end event

on w_fl700_bitacora.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_state=create st_state
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.cb_2=create cb_2
this.sle_nave=create sle_nave
this.st_nomb_nave=create st_nomb_nave
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_state
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.sle_nave
this.Control[iCurrent+6]=this.st_nomb_nave
end on

on w_fl700_bitacora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_state)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.sle_nave)
destroy(this.st_nomb_nave)
end on

event ue_open_pre;call super::ue_open_pre;//This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 2    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;string ls_nave, ls_titulo
date  ld_fecha1, ld_fecha2

ls_nave = trim(sle_nave.text)

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

if ld_fecha1 = ld_fecha2 then
	ls_titulo = 'correspondiente al '+ string(ld_fecha1, 'dd/mm/yyyy')
else
	ls_titulo = 'comprendido entre el ' + string(ld_fecha1, 'dd/mm/yyyy') +' y el '+ string(ld_fecha2, 'dd/mm/yyyy')
end if

idw_1.Retrieve(ls_nave, ld_fecha1, ld_fecha2)
dw_report.object.t_13.text = Upper(ls_titulo)

idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gnvo_app.empresa.is_empresa
idw_1.object.t_ventana.text = this.ClassName()
idw_1.Object.p_logo.filename = gs_logo


end event

type dw_report from w_report_smpl`dw_report within w_fl700_bitacora
integer x = 0
integer y = 92
integer width = 3419
integer height = 1028
string dataobject = "d_bitacora_resumen_tbl"
end type

type st_state from statictext within w_fl700_bitacora
boolean visible = false
integer x = 343
integer y = 144
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_fl700_bitacora
event destroy ( )
integer x = 1435
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type st_1 from statictext within w_fl700_bitacora
integer width = 357
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Embarcacion :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_fl700_bitacora
integer x = 2729
integer width = 489
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type sle_nave from singlelineedit within w_fl700_bitacora
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 370
integer width = 293
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 10
integer accelerator = 110
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
		 + "WHERE FLAG_TIPO_FLOTA= 'P'"
				 
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

end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

select nomb_nave
	into :ls_data
from tg_naves
where nave = :ls_codigo
  and flag_tipo_flota = 'P';
		
if ls_data = ""  or IsNull(ls_data) then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE O NO ES UNA NAVE PROPIA", StopSign!)
	this.text = ''
	st_nomb_nave.text = ''
	return
end if
		
st_nomb_nave.text = ls_data


end event

type st_nomb_nave from statictext within w_fl700_bitacora
integer x = 681
integer width = 731
integer height = 80
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

