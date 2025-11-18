$PBExportHeader$w_cm002_proveedor_ficha.srw
forward
global type w_cm002_proveedor_ficha from w_report_smpl
end type
end forward

global type w_cm002_proveedor_ficha from w_report_smpl
integer width = 2935
integer height = 2076
string title = "Ficha de Proveedor (CM002)"
string menuname = "m_impresion"
end type
global w_cm002_proveedor_ficha w_cm002_proveedor_ficha

on w_cm002_proveedor_ficha.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm002_proveedor_ficha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()

of_position(0,0)
this.height = w_main.height - 400
end event

event ue_retrieve;call super::ue_retrieve;String ls_prov

ls_prov = Message.Stringparm

idw_1.Retrieve(ls_prov)
idw_1.Object.p_logo.filename = gnvo_app.is_logo

uo_filter.of_set_dw( idw_1 )
uo_filter.of_retrieve_fields( )
uo_h.of_set_title( this.title + ". Nro de Registros: " + string(idw_1.RowCount()))

end event

type p_pie from w_report_smpl`p_pie within w_cm002_proveedor_ficha
end type

type ole_skin from w_report_smpl`ole_skin within w_cm002_proveedor_ficha
end type

type uo_h from w_report_smpl`uo_h within w_cm002_proveedor_ficha
end type

type st_box from w_report_smpl`st_box within w_cm002_proveedor_ficha
end type

type phl_logonps from w_report_smpl`phl_logonps within w_cm002_proveedor_ficha
end type

type p_mundi from w_report_smpl`p_mundi within w_cm002_proveedor_ficha
end type

type p_logo from w_report_smpl`p_logo within w_cm002_proveedor_ficha
end type

type uo_filter from w_report_smpl`uo_filter within w_cm002_proveedor_ficha
end type

type st_filtro from w_report_smpl`st_filtro within w_cm002_proveedor_ficha
end type

type dw_report from w_report_smpl`dw_report within w_cm002_proveedor_ficha
integer width = 2222
integer height = 1276
string dataobject = "d_rpt_ficha_proveedor"
end type

