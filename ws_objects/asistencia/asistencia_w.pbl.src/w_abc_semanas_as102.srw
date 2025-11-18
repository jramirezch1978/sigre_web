$PBExportHeader$w_abc_semanas_as102.srw
forward
global type w_abc_semanas_as102 from w_abc_master_smpl
end type
type st_1 from statictext within w_abc_semanas_as102
end type
end forward

global type w_abc_semanas_as102 from w_abc_master_smpl
int Width=1179
int Height=1436
boolean TitleBar=true
string Title="Semanas del Año (AS102)"
string MenuName="m_abc_master_smpl_print"
st_1 st_1
end type
global w_abc_semanas_as102 w_abc_semanas_as102

on w_abc_semanas_as102.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl_print" then this.MenuID = create m_abc_master_smpl_print
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_abc_semanas_as102.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('ano')
END IF

String ls_protect1
ls_protect1=dw_master.Describe("semana.protect")
IF ls_protect1='0' THEN
   dw_master.of_column_protect('semana')
END IF
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(1200,250)
end event

type dw_master from w_abc_master_smpl`dw_master within w_abc_semanas_as102
int X=5
int Y=136
int Width=1125
int Height=1112
boolean BringToTop=true
string DataObject="d_semanas_tbl"
boolean VScrollBar=true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1  // Columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;Decimal ln_semana
choose case dwo.name
	case 'semana'
		ln_semana = Dec(dw_master.GetText())
		if ln_semana < 1 or ln_semana > 53 then
			Messagebox("Atención","Número de Semana no es Válido")
			dw_master.SetColumn("semana")
			dw_master.SetFocus()
			return 1
		End if 
End Choose 

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("semana.Protect='1~tIf(IsRowNew(),0,1)'")
end event

type st_1 from statictext within w_abc_semanas_as102
int X=5
int Y=24
int Width=1125
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="SEMANAS"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
boolean Underline=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

