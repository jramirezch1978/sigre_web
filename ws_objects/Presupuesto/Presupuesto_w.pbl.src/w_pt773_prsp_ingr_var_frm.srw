$PBExportHeader$w_pt773_prsp_ingr_var_frm.srw
forward
global type w_pt773_prsp_ingr_var_frm from w_abc_master
end type
end forward

global type w_pt773_prsp_ingr_var_frm from w_abc_master
integer width = 2455
integer height = 1492
string title = "Variaciones Plan de Ventas (PT773)"
string menuname = "m_impresion"
boolean resizable = false
windowtype windowtype = popup!
boolean toolbarvisible = false
event ue_preview ( )
event ue_saveas ( )
end type
global w_pt773_prsp_ingr_var_frm w_pt773_prsp_ingr_var_frm

type variables
Boolean ib_preview
Integer ii_zoom
end variables

event ue_preview();IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(ii_zoom))
	idw_1.title = "Reporte " + " (Zoom: " + String(ii_zoom) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(ii_zoom))
	idw_1.title = "Reporte " + " (Zoom: " + String(ii_zoom) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_saveas();dw_master.EVENT dynamic ue_saveas()
end event

on w_pt773_prsp_ingr_var_frm.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt773_prsp_ingr_var_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;str_parametros 	sl_param

idw_1 = dw_master
IF Not ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM	
	
	idw_1.dataObject = sl_param.dw1
	idw_1.settransobject( SQLCA )
	
	idw_1.retrieve(sl_param.string1)
	
	idw_1.object.p_logo.FileName 	= gs_logo
	idw_1.object.t_empresa.text	= gs_empresa
	idw_1.object.t_usuario.text	= gs_user
	idw_1.object.t_objeto.text		= this.Classname( )
	
	idw_1.object.datawindow.print.preview = 'Yes'
	
	idw_1.object.datawindow.Print.Orientation	= 2
	
END IF
end event

event ue_open_pre;idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master
//is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a 

THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton     
end event

type dw_master from w_abc_master`dw_master within w_pt773_prsp_ingr_var_frm
event ue_saveas ( )
integer width = 2391
integer height = 1248
string dataobject = "d_rpt_prsp_ingr_var"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_saveas();THIS.saveas()
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
is_dwform = 'tabular'	// tabular, form (default)
end event

event dw_master::doubleclicked;call super::doubleclicked;this.GroupCalc()
end event

