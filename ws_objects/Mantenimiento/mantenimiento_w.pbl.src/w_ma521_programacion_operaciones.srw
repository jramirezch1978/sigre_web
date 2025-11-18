$PBExportHeader$w_ma521_programacion_operaciones.srw
forward
global type w_ma521_programacion_operaciones from w_rpt
end type
type cb_6 from commandbutton within w_ma521_programacion_operaciones
end type
type uo_fechas from u_ingreso_rango_fechas within w_ma521_programacion_operaciones
end type
type cb_5 from commandbutton within w_ma521_programacion_operaciones
end type
type cb_4 from commandbutton within w_ma521_programacion_operaciones
end type
type cb_3 from commandbutton within w_ma521_programacion_operaciones
end type
type cb_2 from commandbutton within w_ma521_programacion_operaciones
end type
type cb_1 from commandbutton within w_ma521_programacion_operaciones
end type
type dw_report from u_dw_rpt within w_ma521_programacion_operaciones
end type
type gb_1 from groupbox within w_ma521_programacion_operaciones
end type
end forward

global type w_ma521_programacion_operaciones from w_rpt
integer width = 3314
integer height = 1528
string title = "Programacion de Operaciones (MA521)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_6 cb_6
uo_fechas uo_fechas
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ma521_programacion_operaciones w_ma521_programacion_operaciones

type variables
String is_opcion
end variables

on w_ma521_programacion_operaciones.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_6=create cb_6
this.uo_fechas=create uo_fechas
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_6
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_5
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_ma521_programacion_operaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_6)
destroy(this.uo_fechas)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;//Configuracion de rango de fechas
uo_fechas.of_set_label('Desde:','Hasta:') //para setear la fecha inicial
uo_fechas.of_set_rango_inicio(date('01/01/1900')) // rango inicial
uo_fechas.of_set_rango_fin(date('31/12/9999')) // rango final
uo_fechas.of_set_fecha(Today(),Today())
//

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
Trigger Event ue_preview()


// ii_help = 101           // help topic
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type cb_6 from commandbutton within w_ma521_programacion_operaciones
integer x = 96
integer y = 320
integer width = 759
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Fechas"
end type

event clicked;is_opcion = '5'
end event

type uo_fechas from u_ingreso_rango_fechas within w_ma521_programacion_operaciones
integer x = 1993
integer y = 60
integer taborder = 50
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_5 from commandbutton within w_ma521_programacion_operaciones
integer x = 2898
integer y = 376
integer width = 361
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;String ls_codigo,ls_opcion
Date ld_fec_ini, ld_fec_fin



ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

IF Isnull(is_opcion) THEN
	Messagebox('Aviso','Debe Escoger Un tipo de Filtro')
	Return
END IF


CHOOSE CASE is_opcion
		 CASE '1'
				dw_report.dataobject = 'd_rpt_programacion_ope_x_ot_ccs'
		 CASE '2'
				dw_report.dataobject = 'd_rpt_programacion_ope_x_ot_ccr'
		 CASE '3'	
				dw_report.dataobject = 'd_rpt_programacion_ope_x_ot_maq'
		 CASE '4'	
				dw_report.dataobject = 'd_rpt_programacion_ope_x_ot_lab'
		 CASE '5'
				dw_report.dataobject = 'd_rpt_programacion_ope_x_ot_fec'
END CHOOSE

dw_report.Settransobject(sqlca)
dw_report.retrieve(gs_empresa,gs_user,ld_fec_ini,ld_fec_fin)
dw_report.Object.p_logo.filename = gs_logo
Parent.Trigger Event ue_preview()





end event

type cb_4 from commandbutton within w_ma521_programacion_operaciones
integer x = 475
integer y = 216
integer width = 379
integer height = 104
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Labor"
end type

event clicked;
sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_cam_labores ;

sl_param.dw1		= 'd_abc_lista_labor_tbl'
sl_param.titulo	= 'Labores '
sl_param.opcion   = 3
sl_param.db1 		= 1600
sl_param.string1 	= 'RPL'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

is_opcion = '4' //labor

end event

type cb_3 from commandbutton within w_ma521_programacion_operaciones
integer x = 96
integer y = 216
integer width = 379
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Maquina"
end type

event clicked;sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_cam_maquina ;

sl_param.dw1		= 'd_abc_lista_maquinas_tbl'
sl_param.titulo	= 'Maquina '
sl_param.opcion   = 2
sl_param.db1 		= 1600
sl_param.string1 	= 'RPM'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

is_opcion = '2' //maquina
end event

type cb_2 from commandbutton within w_ma521_programacion_operaciones
integer x = 475
integer y = 112
integer width = 379
integer height = 104
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "C.Costo &Sol."
end type

event clicked;
sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_man_cencos ;

sl_param.dw1		= 'd_abc_lista_ccostos_tbl'
sl_param.titulo	= 'Centros Costo '
sl_param.opcion   = 1
sl_param.db1 		= 1400
sl_param.string1 	= 'RPCC'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

is_opcion = '2' //centro de costo solicitante
end event

type cb_1 from commandbutton within w_ma521_programacion_operaciones
integer x = 96
integer y = 112
integer width = 379
integer height = 104
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "C.Costo &Resp."
end type

event clicked;
sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_man_cencos ;

sl_param.dw1		= 'd_abc_lista_ccostos_tbl'
sl_param.titulo	= 'Centros Costo '
sl_param.opcion   = 1
sl_param.db1 		= 1400
sl_param.string1 	= 'RPCC'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

is_opcion = '1' //centro de costo responsable
end event

type dw_report from u_dw_rpt within w_ma521_programacion_operaciones
integer x = 23
integer y = 544
integer width = 3250
integer height = 1112
string dataobject = "d_rpt_programacion_ope_x_ot_fec"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ma521_programacion_operaciones
integer x = 69
integer y = 28
integer width = 818
integer height = 432
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipos de Filtro"
end type

