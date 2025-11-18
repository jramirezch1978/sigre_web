$PBExportHeader$w_pr714_costo_ot.srw
forward
global type w_pr714_costo_ot from w_rpt_general
end type
type cb_buscar from cb_aceptar within w_pr714_costo_ot
end type
type sle_orden from singlelineedit within w_pr714_costo_ot
end type
type st_1 from statictext within w_pr714_costo_ot
end type
end forward

global type w_pr714_costo_ot from w_rpt_general
integer width = 1865
integer height = 1920
string title = "Costo Orden Trabajo X Operaciones (PR714)"
windowstate windowstate = maximized!
cb_buscar cb_buscar
sle_orden sle_orden
st_1 st_1
end type
global w_pr714_costo_ot w_pr714_costo_ot

on w_pr714_costo_ot.create
int iCurrent
call super::create
this.cb_buscar=create cb_buscar
this.sle_orden=create sle_orden
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.sle_orden
this.Control[iCurrent+3]=this.st_1
end on

on w_pr714_costo_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.sle_orden)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje, ls_nro_orden

//create or replace procedure USP_PR_COSTO_OT(
//       asi_nro_orden orden_trabajo.nro_orden%type,
//       aso_mensaje   out varchar2, 
//       aio_ok 			 out number) is

ls_nro_orden = sle_orden.text

if ls_nro_orden = '' or IsNull(ls_nro_orden ) then
	MessageBox('PRODUCCION', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

DECLARE USP_PR_COSTO_OT PROCEDURE FOR
	USP_PR_COSTO_OT( :ls_nro_orden );

EXECUTE USP_PR_COSTO_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PR_COSTO_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_PR_COSTO_OT INTO :ls_mensaje, :li_ok;
CLOSE USP_PR_COSTO_OT;

if li_ok <> 1 then
	MessageBox('Error USP_PR_COSTO_OT', ls_mensaje, StopSign!)	
	return
end if

idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user


return
end event

type dw_report from w_rpt_general`dw_report within w_pr714_costo_ot
integer y = 176
integer width = 1815
integer height = 1536
string dataobject = "d_rpt_costo_ot_x_ope_tbl"
end type

type cb_buscar from cb_aceptar within w_pr714_costo_ot
integer x = 905
integer y = 28
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;parent.event dynamic ue_retrieve()
end event

type sle_orden from singlelineedit within w_pr714_costo_ot
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 475
integer y = 28
integer width = 416
integer height = 88
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
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
str_parametros sl_param

sl_param.dw1    = 'd_lista_ot_x_usuario_tbl'
sl_param.titulo = 'Orden de Trabajo'
				
sl_param.tipo    = '1SQL'                                                          
sl_param.string1 = "WHERE USUARIO= '" + gs_user  +"'"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
				
	This.Text = sl_param.field_ret[2]
	parent.event dynamic ue_retrieve()
			
END IF

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

type st_1 from statictext within w_pr714_costo_ot
integer x = 110
integer y = 40
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

