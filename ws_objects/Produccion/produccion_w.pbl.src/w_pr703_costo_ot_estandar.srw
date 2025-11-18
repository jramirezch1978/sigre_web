$PBExportHeader$w_pr703_costo_ot_estandar.srw
forward
global type w_pr703_costo_ot_estandar from w_rpt_general
end type
type cb_buscar from cb_aceptar within w_pr703_costo_ot_estandar
end type
type st_1 from statictext within w_pr703_costo_ot_estandar
end type
type sle_nro_orden from singlelineedit within w_pr703_costo_ot_estandar
end type
end forward

global type w_pr703_costo_ot_estandar from w_rpt_general
integer width = 2441
integer height = 1920
string title = "Costo Orden Trabajo X Estándar (PR703)"
cb_buscar cb_buscar
st_1 st_1
sle_nro_orden sle_nro_orden
end type
global w_pr703_costo_ot_estandar w_pr703_costo_ot_estandar

on w_pr703_costo_ot_estandar.create
int iCurrent
call super::create
this.cb_buscar=create cb_buscar
this.st_1=create st_1
this.sle_nro_orden=create sle_nro_orden
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_nro_orden
end on

on w_pr703_costo_ot_estandar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.st_1)
destroy(this.sle_nro_orden)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_orden, ls_mensaje, ls_und_costo
integer 	li_ok
Decimal	ldc_costo_ot, ldc_costo_unit

ls_nro_orden = sle_nro_orden.text

if ls_nro_orden = '' or IsNull(ls_nro_orden ) then
	MessageBox('PRODUCCION', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

//create or replace procedure usp_pr_costo_x_oper(
//       asi_nro_orden orden_trabajo.nro_orden%type,
//       aso_mensaje   out varchar2, 
//       aio_ok 	    out number) is

//DECLARE usp_pr_costo_x_oper PROCEDURE FOR
//	usp_pr_costo_x_oper( :ls_nro_orden );
//
//EXECUTE usp_pr_costo_x_oper;
//
//IF SQLCA.sqlcode = -1 THEN
//	ls_mensaje = "PROCEDURE usp_pr_costo_x_oper: " + SQLCA.SQLErrText
//	Rollback ;
//	MessageBox('SQL error', ls_mensaje, StopSign!)	
//	return
//END IF

//FETCH usp_pr_costo_x_oper INTO :ls_mensaje, :li_ok;
//CLOSE usp_pr_costo_x_oper;
//
//if li_ok <> 1 then
//	MessageBox('Error usp_pr_costo_x_oper', ls_mensaje, StopSign!)	
//	return
//end if

//create or replace procedure usp_pr_calc_varios(
//       asi_nro_orden     orden_Trabajo.Nro_Orden%TYPE,
//       aso_mensaje       out varchar2, 
//       aio_ok 			     out number  ,
//       ano_costo_ot      out number  ,
//       ano_costo_unit    out number
//) is

DECLARE usp_pr_calc_varios PROCEDURE FOR
	usp_pr_calc_varios( :ls_nro_orden );

EXECUTE usp_pr_calc_varios;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_pr_calc_varios: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_pr_calc_varios INTO :ls_mensaje, :li_ok, 
					:ldc_costo_ot, :ldc_costo_unit, :ls_und_costo;
CLOSE usp_pr_calc_varios;

if li_ok <> 1 then
	MessageBox('Error usp_pr_calc_varios', ls_mensaje, StopSign!)	
	return
end if

If IsNull(ldc_costo_ot) then ldc_costo_ot = 0

idw_1.Retrieve(ls_nro_orden)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.Total_Costo_t.Text = String(ldc_costo_ot, '###,##0.00')

if ldc_costo_unit <> -1 then
	idw_1.Object.Costo_unit_t.Text = 'Costo por Unidad: ' + String(ldc_costo_unit, '###,##0.000') &
		+ ' ' + ls_und_costo
else
	idw_1.Object.Costo_unit_t.Text = 'Se produjo mas de un Producto Final'
end if

end event

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic

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

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type dw_report from w_rpt_general`dw_report within w_pr703_costo_ot_estandar
integer y = 192
integer width = 2322
integer height = 1500
string dataobject = "d_rpt_costo_ot_estandar"
end type

type cb_buscar from cb_aceptar within w_pr703_costo_ot_estandar
integer x = 864
integer y = 28
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;parent.event dynamic ue_retrieve()
end event

type st_1 from statictext within w_pr703_costo_ot_estandar
integer x = 59
integer y = 44
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Orden:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro_orden from singlelineedit within w_pr703_costo_ot_estandar
event dobleclick pbm_lbuttondblclk
integer x = 411
integer y = 40
integer width = 434
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql


ls_sql = "SELECT ot.nro_orden as Nro_Orden, ot.cod_origen, " & 
		  +"ot.descripcion as Descripción " &
		  +"FROM orden_trabajo ot " &
		  +"WHERE ot.flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql,ls_codigo,ls_data,'1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	//em_descripcion.text = ls_data
end if
end event

event modified;//String 	ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT nombre INTO :ls_desc
//FROM origen
//WHERE cod_origen =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
////em_descripcion.text = ls_desc
//
end event

