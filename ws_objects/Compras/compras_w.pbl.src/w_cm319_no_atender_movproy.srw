$PBExportHeader$w_cm319_no_atender_movproy.srw
forward
global type w_cm319_no_atender_movproy from w_abc_master
end type
type st_1 from statictext within w_cm319_no_atender_movproy
end type
type st_2 from statictext within w_cm319_no_atender_movproy
end type
type sle_1 from singlelineedit within w_cm319_no_atender_movproy
end type
type sle_2 from singlelineedit within w_cm319_no_atender_movproy
end type
type cb_1 from commandbutton within w_cm319_no_atender_movproy
end type
end forward

global type w_cm319_no_atender_movproy from w_abc_master
integer width = 3657
integer height = 1544
string title = "Movimientos proyectados a no atenderse (CM319)"
string menuname = "m_anulacion"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
st_2 st_2
sle_1 sle_1
sle_2 sle_2
cb_1 cb_1
end type
global w_cm319_no_atender_movproy w_cm319_no_atender_movproy

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

on w_cm319_no_atender_movproy.create
int iCurrent
call super::create
if this.MenuName = "m_anulacion" then this.MenuID = create m_anulacion
this.st_1=create st_1
this.st_2=create st_2
this.sle_1=create sle_1
this.sle_2=create sle_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.sle_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_cm319_no_atender_movproy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.cb_1)
end on

event ue_open_pre();call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

//idw_1.Retrieve()


end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master`dw_master within w_cm319_no_atender_movproy
integer x = 41
integer y = 312
integer width = 3442
integer height = 820
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

type st_1 from statictext within w_cm319_no_atender_movproy
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
string text = "MOVIMIENTOS PROYECTADOS A NO ATENDERSE"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm319_no_atender_movproy
integer x = 101
integer y = 172
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_cm319_no_atender_movproy
integer x = 475
integer y = 160
integer width = 169
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_cm319_no_atender_movproy
integer x = 667
integer y = 160
integer width = 398
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cm319_no_atender_movproy
integer x = 1115
integer y = 144
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve( sle_1.text, sle_2.text)
end event

