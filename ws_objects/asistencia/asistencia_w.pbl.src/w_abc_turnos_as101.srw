$PBExportHeader$w_abc_turnos_as101.srw
forward
global type w_abc_turnos_as101 from w_abc_master_smpl
end type
type st_1 from statictext within w_abc_turnos_as101
end type
type st_2 from statictext within w_abc_turnos_as101
end type
type st_3 from statictext within w_abc_turnos_as101
end type
end forward

global type w_abc_turnos_as101 from w_abc_master_smpl
integer width = 3223
integer height = 1468
string title = "Horario de Trabajo Para los Diferentes Turnos (AS101)"
string menuname = "m_abc_master_smpl_print"
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_abc_turnos_as101 w_abc_turnos_as101

on w_abc_turnos_as101.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl_print" then this.MenuID = create m_abc_master_smpl_print
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
end on

on w_abc_turnos_as101.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("turno.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('turno')
END IF
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(200,200)
end event

type dw_master from w_abc_master_smpl`dw_master within w_abc_turnos_as101
integer x = 14
integer y = 172
integer width = 3168
integer height = 1112
string dataobject = "d_turnos_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1  // Columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;string ls_turno
decimal ln_marc_nor, ln_marc_sab, ln_marc_dom
choose case dwo.name
	case 'turno'
		ls_turno = Trim(dw_master.GetText())
		If Len(ls_turno) <> 4 Then
			Messagebox("Atención","El TURNO debe ser de "+&
			           "4 Dígitos")
			dw_master.SetColumn("turno")
			dw_master.SetFocus()
			return 1
		End if 
		if Mid(ls_turno,1,2) <> "TN" and Mid(ls_turno,1,2) <> "TR" then
			Messagebox("Atención","Verifique Codificación del "+&
			           "Tipo de Turno")
			dw_master.SetColumn("turno")
			dw_master.SetFocus()
			return 1
		End if 
	case 'marc_diaria_norm'
		ln_marc_nor = Dec(dw_master.GetText())
		If ln_marc_nor > 4 Then
			Messagebox("Atención","Número de marcaciones no debe exceder de 4")
			dw_master.SetColumn("marc_diaria_norm")
			dw_master.SetFocus()
			return 1
		End if 
	case 'marc_diaria_sab'
		ln_marc_sab = Dec(dw_master.GetText())
		If ln_marc_sab > 4 Then
			Messagebox("Atención","Número de marcaciones no debe exceder de 4")
			dw_master.SetColumn("marc_diaria_sab")
			dw_master.SetFocus()
			return 1
		End if 
	case 'marc_diaria_dom'
		ln_marc_dom = Dec(dw_master.GetText())
		If ln_marc_dom > 2 Then
			Messagebox("Atención","Número de marcaciones no debe exceder de 2")
			dw_master.SetColumn("marc_diaria_dom")
			dw_master.SetFocus()
			return 1
		End if 
End Choose 
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("turno.Protect='1~tIf(IsRowNew(),0,1)'")
this.setitem(al_row,"cod_usr",gs_user)

end event

type st_1 from statictext within w_abc_turnos_as101
integer x = 1006
integer y = 52
integer width = 1175
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "PROGRAMACION  DE  TURNOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_abc_turnos_as101
integer x = 165
integer y = 24
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "TN = Turno Normal"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_abc_turnos_as101
integer x = 165
integer y = 88
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "TR = Turno Rotativo"
alignment alignment = center!
boolean focusrectangle = false
end type

