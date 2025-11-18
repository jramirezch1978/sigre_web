$PBExportHeader$w_ma717_rpt_agruphor.srw
forward
global type w_ma717_rpt_agruphor from w_rpt
end type
type rb_res from radiobutton within w_ma717_rpt_agruphor
end type
type rb_det from radiobutton within w_ma717_rpt_agruphor
end type
type cb_2 from commandbutton within w_ma717_rpt_agruphor
end type
type cb_1 from commandbutton within w_ma717_rpt_agruphor
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma717_rpt_agruphor
end type
type dw_report from u_dw_rpt within w_ma717_rpt_agruphor
end type
type gb_1 from groupbox within w_ma717_rpt_agruphor
end type
end forward

global type w_ma717_rpt_agruphor from w_rpt
integer width = 3278
integer height = 1632
string title = "Agruphor (MA717)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
rb_res rb_res
rb_det rb_det
cb_2 cb_2
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
end type
global w_ma717_rpt_agruphor w_ma717_rpt_agruphor

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.Visible = false

idw_1.SetTransObject(sqlca)

ib_preview = false
THIS.Event ue_preview()

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic

end event

on w_ma717_rpt_agruphor.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_res=create rb_res
this.rb_det=create rb_det
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_res
this.Control[iCurrent+2]=this.rb_det
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_ma717_rpt_agruphor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
end on

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

event ue_filter;call super::ue_filter;idw_1.Groupcalc()
end event

type rb_res from radiobutton within w_ma717_rpt_agruphor
integer x = 96
integer y = 196
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

event clicked;if this.checked then
	cb_2.enabled = false
else
	cb_2.enabled = true
end if
end event

type rb_det from radiobutton within w_ma717_rpt_agruphor
integer x = 96
integer y = 100
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
end type

event clicked;if this.checked then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if
end event

type cb_2 from commandbutton within w_ma717_rpt_agruphor
integer x = 2770
integer y = 52
integer width = 402
integer height = 104
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Maquina"
end type

event clicked;//
//sg_parametros sl_param 
//
//
////Elimino informacion
//DELETE FROM tt_ope_maquina ;
//
//sl_param.dw1		= 'd_list_equipos_grid'
//sl_param.titulo	= 'Maquina '
//sl_param.opcion   = 20
//sl_param.db1 		= 1400
//sl_param.string1 	= '1MAQ'
//
//
//
//OpenWithParm( w_abc_seleccion_lista_search, sl_param)
//delete tt_mtt_equipos;

Open(w_abc_seleccion_equipos)
end event

type cb_1 from commandbutton within w_ma717_rpt_agruphor
integer x = 2770
integer y = 160
integer width = 402
integer height = 104
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_fecha_inicio, ls_fecha_final, ls_texto
Date ld_fecha1, ld_fecha2
Long   ll_count


ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_texto  = ''
ls_fecha_inicio = String(uo_fecha.of_get_fecha1(),'yyyymmdd')
ls_fecha_final  = String(uo_fecha.of_get_fecha2(),'yyyymmdd')

IF rb_res.checked = false AND rb_det.checked = false then
	messagebox('Aviso','Defina tipo de reporte')
	return
END IF

IF rb_res.checked = true then
	
	DECLARE PB_USP_MTT_DISPONIB PROCEDURE FOR 
		usp_mtt_disponib_estruct_v2( :ld_fecha1, :ld_fecha2 ) ;
	EXECUTE PB_USP_MTT_DISPONIB ;

	IF sqlca.sqlcode = -1 THEN
		MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	//ELSE
		//MessageBox( 'Aviso', "Fin de proceso")
	END IF

	ls_texto = 'Del ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' + string(ld_fecha2, 'dd/mm/yyyy')
	idw_1.DataObject='d_rpt_disponib_estructura_res_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()

ELSE
	
	idw_1.DataObject='d_rpt_mtt_parte_agrupo_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ls_fecha_inicio,ls_fecha_final)
END IF

idw_1.Visible = true

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto
//ib_preview = FALSE
//parent.event ue_preview()

end event

type uo_fecha from u_ingreso_rango_fechas within w_ma717_rpt_agruphor
integer x = 681
integer y = 120
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 
of_set_rango_fin(date('31/12/9999')) 
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ma717_rpt_agruphor
integer x = 27
integer y = 320
integer width = 3145
integer height = 1060
string dataobject = "d_rpt_mtt_parte_agrupo_tbl"
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;Long ll_row
String ls_maq_padre
sg_parametros lstr_param

ll_row = this.getrow()

IF ll_row=0 THEN RETURN

IF rb_res.checked = TRUE THEN
	lstr_param.date1 = uo_fecha.of_get_fecha1()
	lstr_param.date2 = uo_fecha.of_get_fecha2()
	lstr_param.string1 = this.object.cod_estructura[row]
	OpenSheetWithParm ( w_ma717_rpt_agruphor_resumen, lstr_param, parent,0,layered!)
END IF 

end event

type gb_1 from groupbox within w_ma717_rpt_agruphor
integer x = 41
integer y = 28
integer width = 2002
integer height = 256
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

