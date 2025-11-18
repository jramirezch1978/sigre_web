$PBExportHeader$w_ap723_recep_mp_x_transp_especie.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap723_recep_mp_x_transp_especie from w_rpt
end type
type cb_2 from commandbutton within w_ap723_recep_mp_x_transp_especie
end type
type st_descrip_especie from statictext within w_ap723_recep_mp_x_transp_especie
end type
type st_1 from statictext within w_ap723_recep_mp_x_transp_especie
end type
type sle_materia from singlelineedit within w_ap723_recep_mp_x_transp_especie
end type
type cb_1 from commandbutton within w_ap723_recep_mp_x_transp_especie
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap723_recep_mp_x_transp_especie
end type
type dw_report from u_dw_rpt within w_ap723_recep_mp_x_transp_especie
end type
end forward

global type w_ap723_recep_mp_x_transp_especie from w_rpt
integer width = 3136
integer height = 3208
string title = "Recepción de Materia Prima por Transportista y Especie  (AP723)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
cb_2 cb_2
st_descrip_especie st_descrip_especie
st_1 st_1
sle_materia sle_materia
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap723_recep_mp_x_transp_especie w_ap723_recep_mp_x_transp_especie

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();This.Event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
return lb_ok

end function

on w_ap723_recep_mp_x_transp_especie.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.cb_2=create cb_2
this.st_descrip_especie=create st_descrip_especie
this.st_1=create st_1
this.sle_materia=create sle_materia
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.st_descrip_especie
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_materia
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.dw_report
end on

on w_ap723_recep_mp_x_transp_especie.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.st_descrip_especie)
destroy(this.st_1)
destroy(this.sle_materia)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report

THIS.Event ue_preview()
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

event ue_retrieve;call super::ue_retrieve;date   ld_fecha_ini, ld_fecha_fin
String ls_empresa, ls_nombre, ls_especie, ls_descripcion

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))
ls_especie		= sle_materia.text
ls_descripcion	= st_descrip_especie.text

idw_1.SetTransObject(SQLCA)

Select g.cod_empresa Into :ls_empresa from genparam g where g.reckey = '1';
Select e.nombre Into :ls_nombre from empresa e where e.cod_empresa = :ls_empresa;

//idw_1.SetRedraw(false)

//Recupera los datos del reporte
idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_especie)
idw_1.object.t_user.text 		= gs_user
idw_1.object.t_comentario.text = ls_descripcion
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.t_desde.text 		= String(ld_fecha_ini)
idw_1.object.t_hasta.text 		= String(ld_fecha_fin)
idw_1.object.t_nombre.text	= ls_nombre
idw_1.Visible = True
//idw_1.SetRedraw(true)


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.xls),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
 
end event

type cb_2 from commandbutton within w_ap723_recep_mp_x_transp_especie
integer x = 1975
integer y = 28
integer width = 78
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String ls_codigo, ls_sql, ls_data
str_seleccionar lstr_seleccionar
Datawindow ldw
dwobject   dwo1
ls_sql = "Select Distinct apd.especie as codigo, " &
		 + "te.descr_especie as descripcion, " &
		 + "te.flag_estado as estado " &
		 + "From tg_especies te, " &
		 + "ap_pd_descarga_det apd "&
		 + "Where te.especie = apd.especie " &
		 + "and Nvl(te.flag_estado,'0')='1'"
	
if ls_sql <> '' then
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	if ls_codigo = '' then return 
end if

sle_materia.text = ls_codigo
st_descrip_especie.text = ls_data


end event

type st_descrip_especie from statictext within w_ap723_recep_mp_x_transp_especie
integer x = 2080
integer y = 28
integer width = 613
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ap723_recep_mp_x_transp_especie
integer x = 1422
integer y = 28
integer width = 229
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Especie:"
boolean focusrectangle = false
end type

type sle_materia from singlelineedit within w_ap723_recep_mp_x_transp_especie
integer x = 1655
integer y = 28
integer width = 320
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ap723_recep_mp_x_transp_especie
integer x = 2711
integer y = 20
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap723_recep_mp_x_transp_especie
integer x = 50
integer y = 24
integer height = 96
integer taborder = 10
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-7) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ap723_recep_mp_x_transp_especie
integer x = 50
integer y = 148
integer width = 2999
integer height = 1532
integer taborder = 80
string dataobject = "d_rpt_ap_recep_mp_x_transp_especie_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

