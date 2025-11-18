$PBExportHeader$w_pr713_comp_insumos_x_ot.srw
forward
global type w_pr713_comp_insumos_x_ot from w_rpt_general
end type
type sle_desc_ot from singlelineedit within w_pr713_comp_insumos_x_ot
end type
type pb_1 from picturebutton within w_pr713_comp_insumos_x_ot
end type
type sle_ot from singlelineedit within w_pr713_comp_insumos_x_ot
end type
type gb_1 from groupbox within w_pr713_comp_insumos_x_ot
end type
end forward

global type w_pr713_comp_insumos_x_ot from w_rpt_general
integer width = 2437
integer height = 1696
string title = "Costo Orden Trabajo X Labor - Ejecutor (PR713)"
boolean center = false
sle_desc_ot sle_desc_ot
pb_1 pb_1
sle_ot sle_ot
gb_1 gb_1
end type
global w_pr713_comp_insumos_x_ot w_pr713_comp_insumos_x_ot

on w_pr713_comp_insumos_x_ot.create
int iCurrent
call super::create
this.sle_desc_ot=create sle_desc_ot
this.pb_1=create pb_1
this.sle_ot=create sle_ot
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_ot
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.sle_ot
this.Control[iCurrent+4]=this.gb_1
end on

on w_pr713_comp_insumos_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_ot)
destroy(this.pb_1)
destroy(this.sle_ot)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_ot, ls_mov_sal

ls_ot = sle_ot.text

if ls_ot = '' or IsNull(ls_ot) then
	MessageBox('PRODUCCION', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

select oper_cons_interno 
	into :ls_mov_sal
from logparam 
where reckey = '1';

idw_1.Retrieve(ls_ot, ls_mov_sal)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user

return
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

type dw_report from w_rpt_general`dw_report within w_pr713_comp_insumos_x_ot
integer x = 9
integer y = 288
integer width = 2304
integer height = 1180
string dataobject = "d_rpt_comp_insumos_ot_tbl"
end type

type sle_desc_ot from singlelineedit within w_pr713_comp_insumos_x_ot
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 498
integer y = 96
integer width = 1275
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;//this.event dynamic ue_display()
end event

event ue_display();/// Asigna valores a structura 
//sg_parametros sl_param
//
//sl_param.dw1    = 'd_ot_por_usuario_tbl'
//sl_param.titulo = 'Orden de Trabajo'
//				
//sl_param.tipo    = '1SQL'                                                          
//sl_param.string1 = "WHERE USUARIO= '" + gs_user  +"'"
//sl_param.field_ret_i[1] = 1
//sl_param.field_ret_i[2] = 2
//
//
//OpenWithParm( w_lista, sl_param)
//
//sl_param = Message.PowerObjectParm
//IF sl_param.titulo <> 'n' THEN
//				
//	This.Text = sl_param.field_ret[2]
//	parent.event dynamic ue_retrieve()
//			
//END IF


end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

type pb_1 from picturebutton within w_pr713_comp_insumos_x_ot
integer x = 1819
integer y = 32
integer width = 457
integer height = 184
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type sle_ot from singlelineedit within w_pr713_comp_insumos_x_ot
event dobleclick pbm_lbuttondblclk
integer x = 82
integer y = 100
integer width = 402
integer height = 72
integer taborder = 90
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

ls_sql = "SELECT ot.nro_orden as Nro_orden, "&
		   + "ot.descripcion as Descripción "&
			+ "FROM orden_trabajo  ot, ot_adm_usuario ota "&
			+ "WHERE ota.ot_adm   = ot.ot_adm and ot.flag_estado in ('1','3') "&
			+ "and ota.cod_usr = '" + gs_user + "'"

			
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

sle_desc_ot.text = ls_data

end if

end event

event modified;String ls_ot, ls_desc

ls_ot = this.text
if ls_ot = '' or IsNull(ls_ot) then
	MessageBox('Aviso', 'Debe Ingresar una Orden de Trabajo')
	return
end if

SELECT descripcion INTO :ls_desc
  FROM orden_trabajo 
WHERE  nro_orden =:ls_ot
   and flag_estado in ('1','3');

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Orden de Trabajo no existe')
	return
end if

sle_desc_ot.text = ls_desc


end event

type gb_1 from groupbox within w_pr713_comp_insumos_x_ot
integer x = 18
integer y = 20
integer width = 1801
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Orden de Trabajo"
end type

