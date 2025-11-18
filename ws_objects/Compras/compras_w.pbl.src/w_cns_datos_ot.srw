$PBExportHeader$w_cns_datos_ot.srw
$PBExportComments$Consulta que muestra los movimientos de un articulo por almacen.
forward
global type w_cns_datos_ot from w_report_smpl
end type
end forward

global type w_cns_datos_ot from w_report_smpl
integer width = 2336
integer height = 1992
string title = "Consulta de movimientos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
end type
global w_cns_datos_ot w_cns_datos_ot

type variables
integer ii_tipo
end variables

on w_cns_datos_ot.create
call super::create
end on

on w_cns_datos_ot.destroy
call super::destroy
end on

event ue_open_pre;call super::ue_open_pre;str_parametros sl_param

If IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then
	post event closequery() 
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros no son del tipo str_parametros')
	post event closequery() 
	return
end if

sl_param = message.PowerObjectParm

idw_1.DataObject = sl_param.dw1
idw_1.SetTransObject(SQLCA)

idw_1 = dw_report
ib_preview = true
Event ue_preview()
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
idw_1.Retrieve(sl_param.string1)
//idw_1.Object.p_logo.filename = gs_logo
//idw_1.object.t_user.text = gs_user
end event

type dw_report from w_report_smpl`dw_report within w_cns_datos_ot
integer y = 0
integer width = 2299
integer height = 1892
string dataobject = "d_abc_datos_oper_sec_frm"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

