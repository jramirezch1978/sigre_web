$PBExportHeader$w_al306_no_atender_movproy.srw
forward
global type w_al306_no_atender_movproy from w_abc_master
end type
type st_1 from statictext within w_al306_no_atender_movproy
end type
type sle_tipo_doc from singlelineedit within w_al306_no_atender_movproy
end type
type st_2 from statictext within w_al306_no_atender_movproy
end type
type cb_1 from commandbutton within w_al306_no_atender_movproy
end type
type uo_1 from u_ingreso_fecha within w_al306_no_atender_movproy
end type
end forward

global type w_al306_no_atender_movproy from w_abc_master
integer width = 3657
integer height = 1544
string title = "Movimientos proyectados a no atenderse (AL306)"
string menuname = "m_only_grabar"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
sle_tipo_doc sle_tipo_doc
st_2 st_2
cb_1 cb_1
uo_1 uo_1
end type
global w_al306_no_atender_movproy w_al306_no_atender_movproy

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

on w_al306_no_atender_movproy.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.st_1=create st_1
this.sle_tipo_doc=create sle_tipo_doc
this.st_2=create st_2
this.cb_1=create cb_1
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_tipo_doc
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
end on

on w_al306_no_atender_movproy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_tipo_doc)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.uo_1)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

//idw_1.Retrieve(TODAY())


end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master`dw_master within w_al306_no_atender_movproy
integer x = 41
integer y = 380
integer width = 3442
integer height = 752
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

type st_1 from statictext within w_al306_no_atender_movproy
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

type sle_tipo_doc from singlelineedit within w_al306_no_atender_movproy
integer x = 613
integer y = 188
integer width = 151
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al306_no_atender_movproy
integer x = 82
integer y = 200
integer width = 517
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de documento:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al306_no_atender_movproy
integer x = 1577
integer y = 172
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;String ls_tipo_doc
Date ld_fecha

ld_fecha = uo_1.of_get_fecha() 

ls_tipo_doc = sle_tipo_doc.text

idw_1.Retrieve(ls_tipo_doc, ld_fecha)
end event

type uo_1 from u_ingreso_fecha within w_al306_no_atender_movproy
integer x = 859
integer y = 184
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Al:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

