$PBExportHeader$w_cm001_proveedor_tipo.srw
forward
global type w_cm001_proveedor_tipo from w_abc_master_smpl
end type
type st_1 from statictext within w_cm001_proveedor_tipo
end type
end forward

global type w_cm001_proveedor_tipo from w_abc_master_smpl
integer width = 3008
integer height = 1772
string title = "[CM101] Tipo de proveedores "
string menuname = "m_mantto_smpl"
st_1 st_1
end type
global w_cm001_proveedor_tipo w_cm001_proveedor_tipo

on w_cm001_proveedor_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cm001_proveedor_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_proveedor.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_proveedor.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm001_proveedor_tipo
integer y = 100
integer width = 2930
integer height = 1400
string dataobject = "d_abc_proveedor_tipo_grd"
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_cm001_proveedor_tipo
integer width = 2930
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "TIPO DE PROVEEDORES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

