$PBExportHeader$w_pt775_proy_material.srw
forward
global type w_pt775_proy_material from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_pt775_proy_material
end type
type dw_report from u_dw_rpt within w_pt775_proy_material
end type
type rb_2 from radiobutton within w_pt775_proy_material
end type
type rb_1 from radiobutton within w_pt775_proy_material
end type
type cb_2 from commandbutton within w_pt775_proy_material
end type
type cb_1 from commandbutton within w_pt775_proy_material
end type
type gb_2 from groupbox within w_pt775_proy_material
end type
end forward

global type w_pt775_proy_material from w_rpt
integer width = 3575
integer height = 2192
string title = "Proyecciones de Material de OTs (PT775)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_1 uo_1
dw_report dw_report
rb_2 rb_2
rb_1 rb_1
cb_2 cb_2
cb_1 cb_1
gb_2 gb_2
end type
global w_pt775_proy_material w_pt775_proy_material

forward prototypes
public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
end prototypes

public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_slc PROCEDURE FOR usp_ope_orden_trabajo_slc
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_slc;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_slc ;
end subroutine

public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_rsp PROCEDURE FOR usp_ope_orden_trabajo_rsp
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_rsp;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_rsp ;
end subroutine

on w_pt775_proy_material.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.dw_report=create dw_report
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_pt775_proy_material.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.ii_zoom_actual = 80
THIS.Event ue_preview()
idw_1.object.datawindow.print.orientation = 1
//This.Event ue_retrieve()

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String ls_tipo_cencos
Long   ll_count
Date   ld_fecha_inicio,ld_fecha_final

//Seleccionar centro de costo
select count(*) 
	into :ll_count 
from tt_ope_cencos ;

IF ll_count = 0 THEN
	Messagebox('Aviso','Debe Seleccionar algun Centro de Costo , Verifique!')
	Return
END IF

//rango de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

IF rb_1.checked THEN     // Solicitante
	ls_tipo_cencos = '1'
ELSEIF rb_2.checked THEN // Responsable
	ls_tipo_cencos = '2'
END IF

dw_report.Settransobject(sqlca)
dw_report.ii_zoom_actual = 100
ib_preview = FALSE
this.TriggerEvent('ue_preview')

dw_report.retrieve(ld_fecha_inicio,ld_fecha_final,ls_tipo_cencos)

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_usuario.text 	= gs_user
dw_report.Object.t_empresa.text 	= gs_empresa
dw_report.object.datawindow.print.orientation = 1
idw_1.object.t_titulo1.text = 'Desde ' + string(ld_fecha_inicio, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha_final, 'dd/mm/yyyy')

end event

type uo_1 from u_ingreso_rango_fechas within w_pt775_proy_material
integer x = 41
integer y = 68
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_pt775_proy_material
integer y = 260
integer width = 3465
integer height = 1212
integer taborder = 40
string dataobject = "d_rpt_proyeccion_mat_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_2 from radiobutton within w_pt775_proy_material
integer x = 2213
integer y = 136
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Responsable"
end type

type rb_1 from radiobutton within w_pt775_proy_material
integer x = 2213
integer y = 44
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Solicitante"
end type

type cb_2 from commandbutton within w_pt775_proy_material
integer x = 3054
integer y = 148
integer width = 434
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;parent.event ue_retrieve( )
end event

type cb_1 from commandbutton within w_pt775_proy_material
integer x = 3054
integer y = 36
integer width = 434
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Centro de Costo"
end type

event clicked;Long ll_count
str_parametros sl_param 

delete from tt_ope_cencos ;

sl_param.dw1		= 'd_abc_lista_cencos_tbl'
sl_param.titulo	= 'Centros de Costo'
sl_param.opcion   = 1
sl_param.db1 		= 1600
sl_param.string1 	= ''

OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type gb_2 from groupbox within w_pt775_proy_material
integer x = 18
integer y = 8
integer width = 1371
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

