$PBExportHeader$w_cm709_os_referencias_ord_serv.srw
forward
global type w_cm709_os_referencias_ord_serv from w_abc_mastdet_smpl
end type
end forward

global type w_cm709_os_referencias_ord_serv from w_abc_mastdet_smpl
integer width = 3264
integer height = 1924
string title = ""
string menuname = "m_impresion"
end type
global w_cm709_os_referencias_ord_serv w_cm709_os_referencias_ord_serv

on w_cm709_os_referencias_ord_serv.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm709_os_referencias_ord_serv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros	lstr_rep
String 			ls_origen, ls_nro_orden

dw_master.Visible = False
dw_detail.Visible = False

lstr_rep = message.powerobjectparm

ls_origen    = lstr_rep.string1
ls_nro_orden = lstr_rep.string2

dw_master.Retrieve(ls_origen, ls_nro_orden)
dw_detail.Retrieve(ls_origen, ls_nro_orden)
dw_master.Visible = True
dw_detail.Visible = True

// ii_help = 101           // help topic


end event

event ue_dw_share;// override

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm709_os_referencias_ord_serv
integer width = 2935
integer height = 800
string dataobject = "d_abc_orden_servicios_cm209"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm709_os_referencias_ord_serv
integer x = 18
integer y = 868
integer width = 3154
integer height = 856
string dataobject = "d_abc_orden_servicio_det1_cm209"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

