$PBExportHeader$w_pt003_presupuesto_grupo.srw
forward
global type w_pt003_presupuesto_grupo from w_abc_mastdet
end type
end forward

global type w_pt003_presupuesto_grupo from w_abc_mastdet
integer width = 1605
integer height = 1740
string title = "Grupos - Cuentas Presupuestales"
string menuname = "m_mantenimiento_cl"
end type
global w_pt003_presupuesto_grupo w_pt003_presupuesto_grupo

on w_pt003_presupuesto_grupo.create
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
end on

on w_pt003_presupuesto_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;// carga datos
Long ll_row

dwobject dwo

f_centrar( this)
ll_row = dw_master.retrieve()
if ll_row > 0 then
	dw_master.event clicked(0,0,1,dwo)
end if
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet`dw_master within w_pt003_presupuesto_grupo
integer width = 1550
integer height = 752
string dataobject = "d_abc_presupuesto_grupo"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
ii_dk[1] = 1
ii_ss = 1
is_dwform = 'tabular'	// tabular, form (default)
end event

event dw_master::clicked;call super::clicked;// lee datos del detalle
IF row > 0 then
	dw_detail.retrieve(this.object.grupo[this.getrow()])
end if
end event

type dw_detail from w_abc_mastdet`dw_detail within w_pt003_presupuesto_grupo
integer y = 780
integer width = 1550
integer height = 756
string dataobject = "d_abc_presupuesto_grupo_cuenta"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1	
ii_rk[1] = 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param

if this.Describe( "cnta_prsp.Protect") <> '1' then

		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_cntas_presupuestal"
		sl_param.titulo = "Cuentas Presupuestales"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cnta_prsp		[row] = sl_param.field_ret[1]
			this.object.desc_cnta_prsp	[row] = sl_param.field_ret[2]
		END IF
end if
end event

event dw_detail::itemchanged;String ls_desc

Select descripcion 
	into :ls_desc 
from presupuesto_cuenta 
where cnta_prsp = :data;		

if SQLCA.SQLCode = 100 then
	Messagebox( "Error", "Cuenta Presupuestal no existe", Exclamation!)		
	this.object.cnta_prsp[row] = ""
	Return 1
end if

this.object.desc_cnta_prsp[row] = ls_desc
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

