$PBExportHeader$w_ope503_cns_atencion_mat_ot.srw
forward
global type w_ope503_cns_atencion_mat_ot from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ope503_cns_atencion_mat_ot
end type
type pb_1 from picturebutton within w_ope503_cns_atencion_mat_ot
end type
type cb_1 from commandbutton within w_ope503_cns_atencion_mat_ot
end type
type sle_1 from singlelineedit within w_ope503_cns_atencion_mat_ot
end type
type dw_cns from datawindow within w_ope503_cns_atencion_mat_ot
end type
type dw_report from u_dw_rpt within w_ope503_cns_atencion_mat_ot
end type
end forward

global type w_ope503_cns_atencion_mat_ot from w_rpt
integer width = 3442
integer height = 2004
string title = "Atencion de materiales por OT (OPE503)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
uo_1 uo_1
pb_1 pb_1
cb_1 cb_1
sle_1 sle_1
dw_cns dw_cns
dw_report dw_report
end type
global w_ope503_cns_atencion_mat_ot w_ope503_cns_atencion_mat_ot

on w_ope503_cns_atencion_mat_ot.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.pb_1=create pb_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_cns=create dw_cns
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.dw_cns
this.Control[iCurrent+6]=this.dw_report
end on

on w_ope503_cns_atencion_mat_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_cns)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report

idw_1.SettransObject(sqlca)
dw_cns.SettransObject(sqlca)

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

event ue_print;call super::ue_print;dw_report.EVENT ue_print()
end event

type uo_1 from u_ingreso_rango_fechas within w_ope503_cns_atencion_mat_ot
integer x = 603
integer y = 28
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_ope503_cns_atencion_mat_ot
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

type cb_1 from commandbutton within w_ope503_cns_atencion_mat_ot
integer x = 2016
integer y = 20
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
Date ld_fec_ini, ld_fec_fin

ls_nro_orden = sle_1.text


IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Orden ,Verifique!')
	Return
END IF

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  

/*
select min(o.fec_inicio), max(o.fec_inicio) 
  into :ld_fec_ini, :ld_fec_fin
  from operaciones o 
 where o.nro_orden=:ls_nro_orden ;
*/

DECLARE usp_ope_rpt_mat_atencion_ot  PROCEDURE FOR 
	usp_ope_rpt_mat_atencion_ot (:ls_nro_orden, :ld_fec_ini, :ld_fec_fin);
EXECUTE usp_ope_rpt_mat_atencion_ot ;

dw_report.Retrieve()

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox('Error',ls_msj_err)
	Return
END IF
CLOSE usp_ope_rpt_mat_atencion_ot ;

idw_1.ii_zoom_actual = 100
ib_preview = FALSE
Parent.Event ue_preview()


dw_cns.Retrieve(ls_nro_orden)


idw_1.Retrieve()
idw_1.Object.p_logo.filename = gs_logo



end event

type sle_1 from singlelineedit within w_ope503_cns_atencion_mat_ot
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
		
	//cb_1.TriggerEvent(Clicked!)
	
END IF
end event

type dw_cns from datawindow within w_ope503_cns_atencion_mat_ot
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

type dw_report from u_dw_rpt within w_ope503_cns_atencion_mat_ot
integer x = 5
integer y = 648
integer width = 3387
integer height = 1124
string dataobject = "d_rpt_atencion_material_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

