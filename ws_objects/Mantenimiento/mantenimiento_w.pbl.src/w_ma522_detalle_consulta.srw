$PBExportHeader$w_ma522_detalle_consulta.srw
forward
global type w_ma522_detalle_consulta from w_abc_master
end type
end forward

global type w_ma522_detalle_consulta from w_abc_master
integer width = 2464
integer height = 1648
string title = "Detalle de variaciones (PT501)"
string menuname = "m_impresion"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
boolean toolbarvisible = false
event ue_preview ( )
event ue_saveas ( )
end type
global w_ma522_detalle_consulta w_ma522_detalle_consulta

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

on w_ma522_detalle_consulta.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_ma522_detalle_consulta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string ls_tipo
Long ll_row
sg_parametros sl_param

idw_1 = dw_master
IF Not ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM	
	
	idw_1.DataObject = sl_param.dw1
	idw_1.SetTransObject( SQLCA)	
	
	ls_tipo = sl_param.tipo
	
	IF TRIM(ls_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_master.retrieve()
	ELSE		// caso contrario hace un retrieve con parametros
		CHOOSE CASE ls_tipo
			CASE '1S'
				ll_row = dw_master.Retrieve( sl_param.string1)
			CASE '1S1D2D'				
				ll_row = dw_master.Retrieve( sl_param.string1, sl_param.date1, sl_param.date2)
		END CHOOSE
	END IF

	idw_1.object.p_logo.FileName 	= gs_logo
	idw_1.object.t_empresa.text	= gs_empresa
	idw_1.object.t_usuario.text	= gs_user
	idw_1.object.titulo_1.text	= sl_param.titulo1
	idw_1.object.titulo_2.text	= sl_param.titulo2
	
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

type dw_master from w_abc_master`dw_master within w_ma522_detalle_consulta
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

