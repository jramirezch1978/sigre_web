$PBExportHeader$w_cm024_estados_atencion_req.srw
forward
global type w_cm024_estados_atencion_req from w_abc_master_smpl
end type
type st_1 from statictext within w_cm024_estados_atencion_req
end type
end forward

global type w_cm024_estados_atencion_req from w_abc_master_smpl
integer width = 2583
integer height = 1736
string title = "[CM024] Estados de atención de requerimientos de compra"
string menuname = "m_mantto_smpl"
st_1 st_1
end type
global w_cm024_estados_atencion_req w_cm024_estados_atencion_req

on w_cm024_estados_atencion_req.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cm024_estados_atencion_req.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.flag_urgencia.Protect)

IF li_protect = 0 THEN
   dw_master.Object.flag_urgencia.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 

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

type dw_master from w_abc_master_smpl`dw_master within w_cm024_estados_atencion_req
event ue_display ( string as_columna,  long al_row )
integer y = 152
integer width = 2528
integer height = 1260
string dataobject = "d_estado_atencion_requerim_tbl"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.object.flag_estado[al_row]='1'
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type st_1 from statictext within w_cm024_estados_atencion_req
integer x = 18
integer y = 32
integer width = 2354
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "ESTADO DE ATENCION DE REQUERIMIENTOS DE COMPRA"
alignment alignment = center!
boolean focusrectangle = false
end type

