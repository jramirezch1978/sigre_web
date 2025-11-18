$PBExportHeader$w_al005_motivos_traslado.srw
forward
global type w_al005_motivos_traslado from w_abc_master_smpl
end type
type st_1 from statictext within w_al005_motivos_traslado
end type
end forward

global type w_al005_motivos_traslado from w_abc_master_smpl
integer width = 1623
integer height = 1152
string title = "Motivos de traslado"
string menuname = "m_mantenimiento_sl"
st_1 st_1
end type
global w_al005_motivos_traslado w_al005_motivos_traslado

on w_al005_motivos_traslado.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_al005_motivos_traslado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.motivo_traslado.Protect)

IF li_protect = 0 THEN
   dw_master.Object.motivo_traslado.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_al005_motivos_traslado
integer x = 18
integer y = 164
integer width = 1536
string dataobject = "d_dddw_motivo_traslado"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_al005_motivos_traslado
integer x = 352
integer y = 28
integer width = 919
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
boolean enabled = false
string text = "MOTIVOS DE TRASLADO."
alignment alignment = center!
boolean focusrectangle = false
end type

