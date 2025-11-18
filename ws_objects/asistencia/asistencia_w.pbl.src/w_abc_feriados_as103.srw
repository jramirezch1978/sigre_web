$PBExportHeader$w_abc_feriados_as103.srw
forward
global type w_abc_feriados_as103 from w_abc_master_smpl
end type
type st_1 from statictext within w_abc_feriados_as103
end type
end forward

global type w_abc_feriados_as103 from w_abc_master_smpl
integer width = 1047
integer height = 1556
string title = "Feriados del Año (AS103)"
string menuname = "m_abc_master_smpl_print"
st_1 st_1
end type
global w_abc_feriados_as103 w_abc_feriados_as103

on w_abc_feriados_as103.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl_print" then this.MenuID = create m_abc_master_smpl_print
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_abc_feriados_as103.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(1100,200)
end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("fecha.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('fecha')
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_abc_feriados_as103
integer y = 152
integer width = 987
integer height = 1212
string dataobject = "d_feriado_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1  // Columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("fecha.Protect='1~tIf(IsRowNew(),0,1)'")
end event

type st_1 from statictext within w_abc_feriados_as103
integer x = 14
integer y = 36
integer width = 983
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
string text = "FERIADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

