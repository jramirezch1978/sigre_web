$PBExportHeader$w_al504_devoluciones_prestamos.srw
forward
global type w_al504_devoluciones_prestamos from w_report_smpl
end type
type ddlb_almacen from u_ddlb within w_al504_devoluciones_prestamos
end type
end forward

global type w_al504_devoluciones_prestamos from w_report_smpl
integer width = 1509
integer height = 1400
string title = "Articulos Prestados  (AL504)"
string menuname = "m_impresion"
long backcolor = 12632256
ddlb_almacen ddlb_almacen
end type
global w_al504_devoluciones_prestamos w_al504_devoluciones_prestamos

type variables

end variables

on w_al504_devoluciones_prestamos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_almacen=create ddlb_almacen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_almacen
end on

on w_al504_devoluciones_prestamos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_almacen)
end on

event ue_retrieve;call super::ue_retrieve;String ls_almacen, ls_cod_alm

ls_cod_alm = ddlb_almacen.ia_id

Select desc_almacen 
  into :ls_almacen 
  from almacen 
 where almacen = :ls_cod_alm;
 
 
idw_1.Retrieve(ls_cod_alm)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_almacen.text = ls_almacen
idw_1.object.t_cod_rpt.text = 'AL504'

end event

type dw_report from w_report_smpl`dw_report within w_al504_devoluciones_prestamos
integer x = 27
integer y = 176
integer width = 1042
integer height = 784
string dataobject = "d_artic_devolucion_prestamo_tbl"
end type

type ddlb_almacen from u_ddlb within w_al504_devoluciones_prestamos
integer x = 18
integer y = 16
integer width = 1390
integer height = 476
boolean bringtotop = true
integer textsize = -9
end type

event selectionchanged;call super::selectionchanged;if index > 0 then
	
	parent.Event ue_retrieve()   
end if
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_dddw_almacen'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 6                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2
end event

