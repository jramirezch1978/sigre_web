$PBExportHeader$w_pt501_variaciones_detalle.srw
forward
global type w_pt501_variaciones_detalle from w_abc_master
end type
end forward

global type w_pt501_variaciones_detalle from w_abc_master
integer width = 2455
integer height = 1492
string title = "Detalle de variaciones (PT501)"
string menuname = "m_impresion"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
boolean toolbarvisible = false
event ue_preview ( )
event ue_saveas ( )
end type
global w_pt501_variaciones_detalle w_pt501_variaciones_detalle

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

on w_pt501_variaciones_detalle.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt501_variaciones_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;str_parametros sl_param

idw_1 = dw_master
IF Not ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM	
	
	idw_1.DataObject = sl_param.dw1
	idw_1.SetTransObject( SQLCA)	
	
	if sl_param.long2 > 0 then
		idw_1.retrieve(sl_param.long1, sl_param.long2, sl_param.string1, sl_param.string2)
	else
		idw_1.retrieve(sl_param.long1, sl_param.string1, sl_param.string2)
	end if
	
	idw_1.object.p_logo.FileName 	= gs_logo
	idw_1.object.t_empresa.text	= gs_empresa
	idw_1.object.t_usuario.text	= gs_user
	
	idw_1.object.datawindow.print.preview = 'Yes'
	
	idw_1.object.datawindow.Print.Orientation	= sl_param.opcion
	
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

type dw_master from w_abc_master`dw_master within w_pt501_variaciones_detalle
event ue_saveas ( )
integer width = 2391
integer height = 1248
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

