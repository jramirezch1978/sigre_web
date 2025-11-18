$PBExportHeader$w_ma708_rpt_lab_pend_x_cc.srw
forward
global type w_ma708_rpt_lab_pend_x_cc from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ma708_rpt_lab_pend_x_cc
end type
type dw_report from u_dw_rpt within w_ma708_rpt_lab_pend_x_cc
end type
type cb_4 from commandbutton within w_ma708_rpt_lab_pend_x_cc
end type
type cb_3 from commandbutton within w_ma708_rpt_lab_pend_x_cc
end type
type cb_2 from commandbutton within w_ma708_rpt_lab_pend_x_cc
end type
type cb_1 from commandbutton within w_ma708_rpt_lab_pend_x_cc
end type
type gb_1 from groupbox within w_ma708_rpt_lab_pend_x_cc
end type
end forward

global type w_ma708_rpt_lab_pend_x_cc from w_rpt
integer width = 2825
integer height = 1300
string title = "Labores Pendientes / Taller (MA708))"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
uo_1 uo_1
dw_report dw_report
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_ma708_rpt_lab_pend_x_cc w_ma708_rpt_lab_pend_x_cc

on w_ma708_rpt_lab_pend_x_cc.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.dw_report=create dw_report
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_ma708_rpt_lab_pend_x_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
//This.Event ue_retrieve()




end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type uo_1 from u_ingreso_rango_fechas within w_ma708_rpt_lab_pend_x_cc
integer x = 55
integer y = 112
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today() )
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ma708_rpt_lab_pend_x_cc
integer x = 14
integer y = 488
integer width = 2080
integer height = 600
integer taborder = 50
string dataobject = "d_rpt_lab_pend_x_cc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_4 from commandbutton within w_ma708_rpt_lab_pend_x_cc
integer x = 2354
integer y = 360
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_descripcion
Date   ld_fini, ld_ffin

// Leyendo fechas de objeto fecha
ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  


/**/
DECLARE PB_USP_MTT_LABORES_PEND_X_CC PROCEDURE FOR USP_MTT_LABORES_PEND_X_CC_X ( :ld_fini, :ld_ffin ) ;
EXECUTE PB_USP_MTT_LABORES_PEND_X_CC ;
		
IF sqlca.sqlcode = -1 THEN
   MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
   GOTO ERROR
ELSE
   MessageBox( 'Aviso', "Fin de proceso")
END IF

ls_descripcion = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
idw_1.retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_subtitulo.text = ls_descripcion

ib_preview = FALSE
parent.event ue_preview()

//eliminacion de informacion de tabla temporal

ERROR:
delete from tt_mtt_ot_tipo ;
delete from tt_ope_ot_adm ;
delete from tt_man_cencos ;


end event

type cb_3 from commandbutton within w_ma708_rpt_lab_pend_x_cc
integer x = 2354
integer y = 244
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tipos de Ot"
end type

event clicked;sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_mtt_ot_tipo ;

sl_param.dw1		= 'd_abc_lista_ot_tipo_tbl'
sl_param.titulo	= 'Ot Tipo '
sl_param.opcion   = 27
sl_param.db1 		= 1480
sl_param.string1 	= '1OTIP'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_2 from commandbutton within w_ma708_rpt_lab_pend_x_cc
integer x = 2354
integer y = 128
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ot Adm."
end type

event clicked;
sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_ope_ot_adm ;

sl_param.dw1		= 'd_abc_lista_ot_adm_tbl'
sl_param.titulo	= 'Ot Administración '
sl_param.opcion   = 24
sl_param.db1 		= 1480
sl_param.string1 	= '1OADM'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_1 from commandbutton within w_ma708_rpt_lab_pend_x_cc
integer x = 2354
integer y = 12
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Centro de Costo"
end type

event clicked;
sg_parametros sl_param 


//Elimino informacion
DELETE FROM tt_man_cencos ;

sl_param.dw1		= 'd_abc_lista_ccostos_tbl'
sl_param.titulo	= 'Centros Costo '
sl_param.opcion   = 25
sl_param.db1 		= 1400
sl_param.string1 	= 'RPCC'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)


end event

type gb_1 from groupbox within w_ma708_rpt_lab_pend_x_cc
integer x = 23
integer y = 32
integer width = 1367
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda x Fechas"
end type

