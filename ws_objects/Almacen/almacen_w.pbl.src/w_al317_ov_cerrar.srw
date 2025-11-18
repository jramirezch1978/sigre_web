$PBExportHeader$w_al317_ov_cerrar.srw
forward
global type w_al317_ov_cerrar from w_abc_master
end type
type st_1 from statictext within w_al317_ov_cerrar
end type
end forward

global type w_al317_ov_cerrar from w_abc_master
integer width = 3657
integer height = 1544
string title = "Movimientos proyectados a no atenderse (AL317)"
string menuname = "m_only_grabar"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
end type
global w_al317_ov_cerrar w_al317_ov_cerrar

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

on w_al317_ov_cerrar.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_al317_ov_cerrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

idw_1.Retrieve(TODAY())


end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master`dw_master within w_al317_ov_cerrar
integer x = 41
integer y = 176
integer width = 3442
integer height = 956
string dataobject = "d_abc_no_atender_movproy"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,                    	
is_dwform = 'tabular'	
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_opcion

if row = 0 then return 
IF This.Object.flag_estado [row] = '1' THEN //
			li_opcion = MessageBox('Aviso' ,'Desea no atender este item?', Question!, YesNo!, 2)
			if li_opcion = 1 then
				This.Object.flag_estado [row] = '2'
	 			This.ii_update = 1
			end if
		elseif This.Object.flag_estado [row] = '2' THEN //
			li_opcion = MessageBox('Aviso' ,'Desea atender este item?', Question!, YesNo!, 2)
			if li_opcion = 1 then
				This.Object.flag_estado [row] = '1'
	 			This.ii_update = 1
			end if
		end if
end event

type st_1 from statictext within w_al317_ov_cerrar
integer x = 585
integer y = 44
integer width = 1801
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CERRAR ITEMS DE ORDENES DE VENTA"
alignment alignment = center!
boolean focusrectangle = false
end type

