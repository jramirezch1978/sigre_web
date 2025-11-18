$PBExportHeader$w_cn004_tasa_cambio_mensual.srw
forward
global type w_cn004_tasa_cambio_mensual from w_abc_master_smpl
end type
type st_1 from statictext within w_cn004_tasa_cambio_mensual
end type
end forward

global type w_cn004_tasa_cambio_mensual from w_abc_master_smpl
integer width = 1006
integer height = 1480
string title = "Tasa de Cambio Mensual (CN004)"
string menuname = "m_abc_master_smpl"
st_1 st_1
end type
global w_cn004_tasa_cambio_mensual w_cn004_tasa_cambio_mensual

on w_cn004_tasa_cambio_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cn004_tasa_cambio_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
idw_1.Retrieve()


end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("ano")
END IF
ls_protect=dw_master.Describe("mes.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("mes")
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn004_tasa_cambio_mensual
integer y = 96
integer width = 928
integer height = 1180
string dataobject = "d_tasa_cambio_mensual_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

type st_1 from statictext within w_cn004_tasa_cambio_mensual
integer x = 91
integer y = 16
integer width = 777
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tasa de cambio mensual"
alignment alignment = center!
boolean focusrectangle = false
end type

