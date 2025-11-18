$PBExportHeader$w_ap902_presup_variac.srw
forward
global type w_ap902_presup_variac from w_rpt
end type
type st_1 from statictext within w_ap902_presup_variac
end type
type sle_especie from singlelineedit within w_ap902_presup_variac
end type
type cb_procesar from commandbutton within w_ap902_presup_variac
end type
type st_especie from statictext within w_ap902_presup_variac
end type
type dw_report from u_dw_rpt within w_ap902_presup_variac
end type
type uo_1 from u_ingreso_rango_fechas within w_ap902_presup_variac
end type
end forward

global type w_ap902_presup_variac from w_rpt
integer width = 2423
integer height = 1760
string title = "Variaciones Presupuestales (AP902)"
string menuname = "m_rpt"
long backcolor = 67108864
event ue_query_retrieve ( )
st_1 st_1
sle_especie sle_especie
cb_procesar cb_procesar
st_especie st_especie
dw_report dw_report
uo_1 uo_1
end type
global w_ap902_presup_variac w_ap902_presup_variac

event ue_query_retrieve();this.Post event Dynamic ue_retrieve()
end event

on w_ap902_presup_variac.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.sle_especie=create sle_especie
this.cb_procesar=create cb_procesar
this.st_especie=create st_especie
this.dw_report=create dw_report
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_especie
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.st_especie
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.uo_1
end on

on w_ap902_presup_variac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_especie)
destroy(this.cb_procesar)
destroy(this.st_especie)
destroy(this.dw_report)
destroy(this.uo_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
idw_1.object.Datawindow.Print.Orientation	= '2' // Portrait
THIS.Event ue_preview()


// ii_help = 101           // help topic
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ano, li_mes1, li_mes2
date 		ld_fecha1, ld_fecha2
string	ls_especie
integer 	li_ok, li_tipo_op
string 	ls_mensaje


ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2 = uo_1.of_get_fecha2()

if integer(string(ld_fecha1, 'yyyy')) &
	<> integer(string(ld_fecha2, 'yyyy')) then
	MessageBox('APROVISIONAMIENTO', 'EL RANGO DE FECHAS DEBEN SER DEL MISMO AÑO', stopSign!)
	return
end if

ls_especie = sle_especie.text
if ls_especie = '' or IsNull(ls_especie) then
	MessageBox('APROVISIONAMIENTO', 'EL CODIGO DE ESPECIE ESTA EN BLANCO, VERIFIQUE', stopSign!)
	return
end if

li_ano  = integer(string(ld_fecha1, 'yyyy'))
li_mes1 = integer(string(ld_fecha1, 'mm'))
li_mes2 = integer(string(ld_fecha2, 'mm'))
li_tipo_op = 1

//create or replace procedure usp_ap_presup_compara(
//       asi_origen     in origen.cod_origen%TYPE,
//       aii_mes1       in Integer,
//       aii_mes2       in Integer,
//       aii_ano        in Integer, 
//       asi_especie    in tg_especies.especie%TYPE,
//       asi_cod_usr    in usuario.cod_usr%TYPE,
//       aii_tipo_op		in number,
//       aso_mensaje    out varchar2, -- Mensaje de Error
//       aio_ok         out number ) is

DECLARE usp_ap_presup_compara PROCEDURE FOR
	usp_ap_presup_compara( :gs_origen, 
								  :li_mes1,
								  :li_mes2,
								  :li_ano,
								  :ls_especie,
								  :gs_user,
								  :li_tipo_op );

EXECUTE usp_ap_presup_compara;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_ap_presup_compara: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_ap_presup_compara INTO :ls_mensaje, :li_ok;
CLOSE usp_ap_presup_compara;

if li_ok <> 1 then
	MessageBox('Error usp_ap_presup_compara', ls_mensaje, StopSign!)	
	return
end if

idw_1.Retrieve()
idw_1.Visible = True
idw_1.object.usuario_t.text 	= gs_user
idw_1.object.p_logo.filename 	= gs_logo
cb_procesar.enabled = true

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type st_1 from statictext within w_ap902_presup_variac
integer x = 96
integer y = 136
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Especie"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_especie from singlelineedit within w_ap902_presup_variac
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 471
integer y = 120
integer width = 293
integer height = 88
integer taborder = 70
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

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar
boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = "SELECT ESPECIE AS CODIGO, " &
  	    + "DESCR_ESPECIE AS DESCRIPCION " &
		 + "FROM TG_ESPECIES " &
		 + "WHERE FLAG_ESTADO = '1' "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		 = ls_codigo
	st_especie.text = ls_data
	parent.event ue_retrieve()
end if

end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event ue_reset();cb_procesar.enabled = false
dw_report.Reset()
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

SetNull(ls_data)
select descr_especie
	into :ls_data
from tg_especies
where especie = :ls_codigo;

if ls_data = "" or IsNull(ls_data) then
	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
	this.text = ""
	st_especie.text = ""
	this.event dynamic ue_reset( )
	return
end if
		
st_especie.text = ls_data

parent.event dynamic ue_retrieve()
end event

type cb_procesar from commandbutton within w_ap902_presup_variac
integer x = 1989
integer y = 24
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;integer 	li_ano, li_mes1, li_mes2
date 		ld_fecha1, ld_fecha2
string	ls_especie
integer 	li_ok, li_tipo_op
string 	ls_mensaje

if MessageBox('APROVISION', 'Se procedera a recalcular el presupuesto, ' &
	+ '~r~n ¿Desea proceder?', Information!, YesNo!, 2) = 2 then
	return 
end if

ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2 = uo_1.of_get_fecha2()

if integer(string(ld_fecha1, 'yyyy')) &
	<> integer(string(ld_fecha2, 'yyyy')) then
	MessageBox('APROVISIONAMIENTO', 'EL RANGO DE FECHAS DEBEN SER DEL MISMO AÑO', stopSign!)
	return
end if

ls_especie = sle_especie.text
if ls_especie = '' or IsNull(ls_especie) then
	MessageBox('APROVISIONAMIENTO', 'EL CODIGO DE ESPECIE ESTA EN BLANCO, VERIFIQUE', stopSign!)
	return
end if

li_ano  = integer(string(ld_fecha1, 'yyyy'))
li_mes1 = integer(string(ld_fecha1, 'mm'))
li_mes2 = integer(string(ld_fecha2, 'mm'))
li_tipo_op = 2

//create or replace procedure usp_ap_presup_compara(
//       asi_origen     in origen.cod_origen%TYPE,
//       aii_mes1       in Integer,
//       aii_mes2       in Integer,
//       aii_ano        in Integer, 
//       asi_especie    in tg_especies.especie%TYPE,
//       asi_cod_usr    in usuario.cod_usr%TYPE,
//       aii_tipo_op		in number,
//       aso_mensaje    out varchar2, -- Mensaje de Error
//       aio_ok         out number ) is

DECLARE usp_ap_presup_compara PROCEDURE FOR
	usp_ap_presup_compara( :gs_origen, 
								  :li_mes1,
								  :li_mes2,
								  :li_ano,
								  :ls_especie,
								  :gs_user,
								  :li_tipo_op );

EXECUTE usp_ap_presup_compara;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_ap_presup_compara: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_ap_presup_compara INTO :ls_mensaje, :li_ok;
CLOSE usp_ap_presup_compara;

if li_ok <> 1 then
	MessageBox('Error usp_ap_presup_compara', ls_mensaje, StopSign!)	
	return
end if

idw_1.Retrieve()
idw_1.Visible = True
idw_1.object.usuario_t.text 	= gs_user
idw_1.object.p_logo.filename 	= gs_logo

MessageBox('APROVISIONAMIENTO', 'PROCESO EJECUTADO SATISFACTORIAMENTE', Exclamation!)	


end event

type st_especie from statictext within w_ap902_presup_variac
integer x = 832
integer y = 132
integer width = 864
integer height = 64
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

type dw_report from u_dw_rpt within w_ap902_presup_variac
integer y = 224
integer width = 2354
integer height = 1308
integer taborder = 60
string dataobject = "d_ap_rpt_prsp_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type uo_1 from u_ingreso_rango_fechas within w_ap902_presup_variac
integer x = 18
integer y = 12
integer taborder = 50
end type

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)
	
end if

this.of_set_fecha( ld_fecini, ld_fecfin)
end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

