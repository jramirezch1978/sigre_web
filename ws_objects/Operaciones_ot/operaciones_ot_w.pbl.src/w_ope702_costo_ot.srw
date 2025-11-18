$PBExportHeader$w_ope702_costo_ot.srw
forward
global type w_ope702_costo_ot from w_rpt
end type
type dw_pd_ot_asistencia from datawindow within w_ope702_costo_ot
end type
type dw_articulos_det from datawindow within w_ope702_costo_ot
end type
type dw_parte_diario from datawindow within w_ope702_costo_ot
end type
type dw_costo_almacen from datawindow within w_ope702_costo_ot
end type
type dw_costo_real from datawindow within w_ope702_costo_ot
end type
type dw_costo_std from datawindow within w_ope702_costo_ot
end type
type dw_mat_real from datawindow within w_ope702_costo_ot
end type
type dw_mat_std from datawindow within w_ope702_costo_ot
end type
type pb_1 from picturebutton within w_ope702_costo_ot
end type
type cb_1 from commandbutton within w_ope702_costo_ot
end type
type sle_1 from singlelineedit within w_ope702_costo_ot
end type
type dw_cns from datawindow within w_ope702_costo_ot
end type
type dw_report from u_dw_rpt within w_ope702_costo_ot
end type
end forward

global type w_ope702_costo_ot from w_rpt
integer width = 3442
integer height = 2224
string title = "Reporte de Costo de OT (OPE702)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
dw_pd_ot_asistencia dw_pd_ot_asistencia
dw_articulos_det dw_articulos_det
dw_parte_diario dw_parte_diario
dw_costo_almacen dw_costo_almacen
dw_costo_real dw_costo_real
dw_costo_std dw_costo_std
dw_mat_real dw_mat_real
dw_mat_std dw_mat_std
pb_1 pb_1
cb_1 cb_1
sle_1 sle_1
dw_cns dw_cns
dw_report dw_report
end type
global w_ope702_costo_ot w_ope702_costo_ot

on w_ope702_costo_ot.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_pd_ot_asistencia=create dw_pd_ot_asistencia
this.dw_articulos_det=create dw_articulos_det
this.dw_parte_diario=create dw_parte_diario
this.dw_costo_almacen=create dw_costo_almacen
this.dw_costo_real=create dw_costo_real
this.dw_costo_std=create dw_costo_std
this.dw_mat_real=create dw_mat_real
this.dw_mat_std=create dw_mat_std
this.pb_1=create pb_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_cns=create dw_cns
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pd_ot_asistencia
this.Control[iCurrent+2]=this.dw_articulos_det
this.Control[iCurrent+3]=this.dw_parte_diario
this.Control[iCurrent+4]=this.dw_costo_almacen
this.Control[iCurrent+5]=this.dw_costo_real
this.Control[iCurrent+6]=this.dw_costo_std
this.Control[iCurrent+7]=this.dw_mat_real
this.Control[iCurrent+8]=this.dw_mat_std
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.dw_cns
this.Control[iCurrent+13]=this.dw_report
end on

on w_ope702_costo_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_pd_ot_asistencia)
destroy(this.dw_articulos_det)
destroy(this.dw_parte_diario)
destroy(this.dw_costo_almacen)
destroy(this.dw_costo_real)
destroy(this.dw_costo_std)
destroy(this.dw_mat_real)
destroy(this.dw_mat_std)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_cns)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
dw_cns.SettransObject(sqlca)
dw_mat_std.SettransObject(sqlca)
dw_mat_real.SettransObject(sqlca)
dw_costo_std.SettransObject(sqlca)
dw_costo_real.SettransObject(sqlca)
dw_costo_almacen.SettransObject(sqlca)
dw_parte_diario.SettransObject(sqlca)
dw_articulos_det.SettransObject(sqlca)
dw_pd_ot_asistencia.SettransObject(sqlca)
idw_1.ii_zoom_actual = 100
ib_preview = FALSE
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_pd_ot_asistencia from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 402
integer y = 760
integer width = 3346
integer height = 1084
integer taborder = 20
boolean titlebar = true
string title = "Asistencia de Parte Diario"
string dataobject = "d_pd_ot_asistencia_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_articulos_det from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 425
integer y = 792
integer width = 3406
integer height = 772
integer taborder = 20
boolean titlebar = true
string title = "Detalle de artículos"
string dataobject = "d_abc_art_x_ot_real_det_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_oper_sec
if row < 1 then return
ls_oper_sec = this.object.oper_sec[row]
dw_parte_diario.visible = true
dw_parte_diario.retrieve(ls_oper_sec)

end event

type dw_parte_diario from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 366
integer y = 776
integer width = 3314
integer height = 1044
integer taborder = 20
boolean titlebar = true
string title = "Parte diario"
string dataobject = "d_pd_ot_cns_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_nro_parte
long ll_nro_item
if row < 1 then return

ls_nro_parte = this.object.nro_parte[row]
ll_nro_item = this.object.nro_item[row]

dw_pd_ot_asistencia.visible = true
dw_pd_ot_asistencia.retrieve( ls_nro_parte, ll_nro_item )

end event

type dw_costo_almacen from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 389
integer y = 772
integer width = 3259
integer height = 832
integer taborder = 20
boolean titlebar = true
string title = "Costo por artículo :  referencia movimientos de almacén"
string dataobject = "d_abc_cns_almacen_x_ot_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_oper_sec
if row < 1 then return
ls_oper_sec = this.object.oper_sec[row]
dw_parte_diario.visible = true
dw_parte_diario.retrieve(ls_oper_sec)

end event

type dw_costo_real from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 407
integer y = 772
integer width = 1970
integer height = 728
integer taborder = 20
boolean titlebar = true
string title = "Operaciones (Real)"
string dataobject = "d_abc_cns_parte_x_ot_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean vscrollbar = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_oper_sec
if row < 1 then return
ls_oper_sec = this.object.oper_sec[row]
dw_parte_diario.visible = true
dw_parte_diario.retrieve(ls_oper_sec)

end event

type dw_costo_std from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 480
integer y = 792
integer width = 2112
integer height = 900
integer taborder = 30
boolean titlebar = true
string title = "Operaciones (Standart)"
string dataobject = "d_abc_cns_oper_x_ot_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean vscrollbar = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_oper_sec
if row < 1 then return
ls_oper_sec = this.object.oper_sec[row]
dw_parte_diario.visible = true
dw_parte_diario.retrieve(ls_oper_sec)

end event

type dw_mat_real from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 421
integer y = 800
integer width = 2711
integer height = 1168
integer taborder = 20
boolean titlebar = true
string title = "Articulos (Del parte diario de insumos)"
string dataobject = "d_abc_art_x_ot_real_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean vscrollbar = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_nro_orden, ls_cod_labor, ls_cod_ejecutor, ls_cod_art

if row < 1 then return

ls_nro_orden	 = this.object.nro_orden[row]
ls_cod_labor    = this.object.cod_labor[row]
ls_cod_ejecutor = this.object.cod_ejecutor[row]
ls_cod_art = this.object.cod_art[row]

dw_articulos_det.Visible = TRUE
dw_articulos_det.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor, ls_cod_art)
end event

type dw_mat_std from datawindow within w_ope702_costo_ot
boolean visible = false
integer x = 334
integer y = 756
integer width = 2569
integer height = 1192
integer taborder = 20
boolean titlebar = true
string title = "Articulos (Costo Standart)"
string dataobject = "d_abc_cns_art_x_ot_tbl"
boolean controlmenu = true
boolean maxbox = true
boolean vscrollbar = true
string icon = "Report5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_nro_orden, ls_cod_labor, ls_cod_ejecutor, ls_cod_art

if row < 1 then return

ls_nro_orden	 = this.object.nro_orden[row]
ls_cod_labor    = this.object.cod_labor[row]
ls_cod_ejecutor = this.object.cod_ejecutor[row]
ls_cod_art = this.object.cod_art[row]

dw_articulos_det.Visible = TRUE
dw_articulos_det.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor, ls_cod_art)
end event

type pb_1 from picturebutton within w_ope702_costo_ot
integer x = 421
integer y = 28
integer width = 128
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Search!"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.COD_ORIGEN AS ORIGEN , '&
								       +'ORDEN_TRABAJO.NRO_ORDEN  AS NRO_ORDEN , '&
										 +'ORDEN_TRABAJO.FEC_INICIO AS FECHA_INICIO , '&
										 +'ORDEN_TRABAJO.OT_ADM     AS ADMINISTRACION , '&
										 +'ORDEN_TRABAJO.OT_TIPO    AS TIPO_OT '&
				   				 	 +'FROM ORDEN_TRABAJO '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_1.text = lstr_seleccionar.param2[1]
END IF														 

end event

type cb_1 from commandbutton within w_ope702_costo_ot
integer x = 562
integer y = 28
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_nro_orden,ls_msj_err

ls_nro_orden = sle_1.text

IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Orden ,Verifique!')
	Return
END IF

DECLARE PB_USP_OPE_COSTO_OT  PROCEDURE FOR USP_OPE_COSTO_OT 
(:ls_nro_orden);
EXECUTE PB_USP_OPE_COSTO_OT  ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_OPE_COSTO_OT ;

idw_1.ii_zoom_actual = 100
ib_preview = FALSE
Parent.Event ue_preview()


dw_cns.Retrieve(ls_nro_orden)
dw_report.Retrieve(ls_nro_orden,gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo
Rollback ;

end event

type sle_1 from singlelineedit within w_ope702_costo_ot
event ue_tecla pbm_dwnkey
integer x = 5
integer y = 28
integer width = 398
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF Key = KeyEnter! THEN
	String ls_nro_orden 
	Long   ll_count
	
	ls_nro_orden = sle_1.text
	
	select count(*) into :ll_count 
	  from orden_trabajo 
	 where nro_orden = :ls_nro_orden ;

		 
   IF ll_count = 0 THEN
		Messagebox('Aviso','Orden de Trabajo No Existe ,Verifique!')
		Setnull(ls_nro_orden)
		sle_1.text = ls_nro_orden
		Return
	END IF
	
	cb_1.TriggerEvent(Clicked!)
	
END IF
end event

type dw_cns from datawindow within w_ope702_costo_ot
integer x = 5
integer y = 184
integer width = 2633
integer height = 456
integer taborder = 10
string title = "none"
string dataobject = "d_cns_ot_tbl"
boolean border = false
boolean livescroll = true
end type

type dw_report from u_dw_rpt within w_ope702_costo_ot
integer y = 668
integer width = 3387
integer height = 1352
string dataobject = "d_rpt_costo_x_orden_trabajo_tbl"
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN
String ls_cod_labor,ls_cod_ejecutor,ls_nro_orden


choose case dwo.name

			
		 case 'costo_man_std'
				
				ls_nro_orden	 = this.object.nro_orden    [row]
				ls_cod_labor    = this.object.cod_labor    [row]
				ls_cod_ejecutor = this.object.cod_ejecutor [row]

				dw_costo_std.Visible = TRUE
				dw_costo_std.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor)
		 case 'costo_man_real'
				ls_nro_orden	 = this.object.nro_orden    [row]
				ls_cod_labor    = this.object.cod_labor    [row]
				ls_cod_ejecutor = this.object.cod_ejecutor [row]

				dw_costo_real.Visible = TRUE
				dw_costo_real.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor)
		 case 'costo_mat_std'
				ls_nro_orden	 = this.object.nro_orden    [row]
				ls_cod_labor    = this.object.cod_labor    [row]
				ls_cod_ejecutor = this.object.cod_ejecutor [row]

				dw_mat_std.Visible = TRUE
				dw_mat_std.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor)
		 case 'costo_mat_real'
				ls_nro_orden	 = this.object.nro_orden    [row]
				ls_cod_labor    = this.object.cod_labor    [row]
				ls_cod_ejecutor = this.object.cod_ejecutor [row]

				dw_mat_real.Visible = TRUE
				dw_mat_real.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor)
		case 'costo_mat_alm'
				ls_nro_orden	 = this.object.nro_orden    [row]
				ls_cod_labor    = this.object.cod_labor    [row]
				ls_cod_ejecutor = this.object.cod_ejecutor [row]
				
				dw_costo_almacen.Visible = TRUE
				dw_costo_almacen.Retrieve(ls_nro_orden,ls_cod_labor,ls_cod_ejecutor)
end choose

end event

