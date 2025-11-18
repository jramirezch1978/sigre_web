$PBExportHeader$w_ma022_med_acum_maq.srw
forward
global type w_ma022_med_acum_maq from w_abc_master_smpl
end type
type st_campo from statictext within w_ma022_med_acum_maq
end type
type dw_text from datawindow within w_ma022_med_acum_maq
end type
end forward

global type w_ma022_med_acum_maq from w_abc_master_smpl
integer width = 2117
integer height = 1440
string title = "Actualizar Horómetros de Equipos (MA022)"
string menuname = "m_abc_master_smpl"
st_campo st_campo
dw_text dw_text
end type
global w_ma022_med_acum_maq w_ma022_med_acum_maq

type variables
string is_col
end variables

on w_ma022_med_acum_maq.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_campo=create st_campo
this.dw_text=create dw_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
end on

on w_ma022_med_acum_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_text)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//Help
ii_help = 5
end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_maquina.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('tipo_maquina')
END IF
end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma022_med_acum_maq
integer x = 0
integer y = 116
integer width = 2048
integer height = 1040
string dataobject = "d_abc_lista_maquinas"
end type

event dw_master::constructor;call super::constructor;ii_ck[1]=1
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = this.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type st_campo from statictext within w_ma022_med_acum_maq
integer x = 23
integer y = 20
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_ma022_med_acum_maq
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 16
integer width = 1449
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if



end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_master.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando
Long 		ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

