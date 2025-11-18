$PBExportHeader$w_cns_flujo_caja_eje_det_tbl.srw
forward
global type w_cns_flujo_caja_eje_det_tbl from w_cns
end type
type dw_cns from u_dw_cns within w_cns_flujo_caja_eje_det_tbl
end type
end forward

global type w_cns_flujo_caja_eje_det_tbl from w_cns
integer width = 3703
integer height = 1240
string title = "Consulta Detalle de Flujo de Caja"
string menuname = "m_consulta"
event ue_saveas ( )
dw_cns dw_cns
end type
global w_cns_flujo_caja_eje_det_tbl w_cns_flujo_caja_eje_det_tbl

event ue_saveas;dw_cns.event ue_saveas()
end event

on w_cns_flujo_caja_eje_det_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cns
end on

on w_cns_flujo_caja_eje_det_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cns)
end on

event ue_open_pre;call super::ue_open_pre;str_seleccionar lstr_param

f_centrar(this)
dw_cns.SetTransObject(sqlca)

IF IsValid(message.powerobjectparm) AND ClassName(message.powerobjectparm) = 'str_seleccionar' THEN
	lstr_param = message.powerobjectparm
ELSE
	messagebox('Aviso','Parámetros mal pasados')
	Return
END IF

			

dw_cns.retrieve(lstr_param.param1[1],lstr_param.param1[2],lstr_param.param1[3],lstr_param.param1[4])


idw_1 = dw_cns



end event

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 10
dw_cns.height = newheight - dw_cns.y - 10
end event

event open;//override
THIS.EVENT ue_open_pre()


end event

type dw_cns from u_dw_cns within w_cns_flujo_caja_eje_det_tbl
event ue_saveas ( )
integer x = 14
integer y = 8
integer width = 3643
integer height = 876
string dataobject = "d_abc_rpt_fcaja_eje_det_tbl"
boolean vscrollbar = true
end type

event ue_saveas;THIS.SAVEAS()
end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

