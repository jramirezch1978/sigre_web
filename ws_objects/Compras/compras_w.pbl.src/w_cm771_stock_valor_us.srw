$PBExportHeader$w_cm771_stock_valor_us.srw
forward
global type w_cm771_stock_valor_us from w_report_smpl
end type
type cb_1 from commandbutton within w_cm771_stock_valor_us
end type
type rb_gen from radiobutton within w_cm771_stock_valor_us
end type
type rb_alm from radiobutton within w_cm771_stock_valor_us
end type
type ddlb_1 from u_ddlb within w_cm771_stock_valor_us
end type
type gb_1 from groupbox within w_cm771_stock_valor_us
end type
end forward

global type w_cm771_stock_valor_us from w_report_smpl
integer width = 2382
integer height = 1164
string title = "w_cm771_stock_valor_us"
string menuname = "m_impresion"
long backcolor = 134217750
cb_1 cb_1
rb_gen rb_gen
rb_alm rb_alm
ddlb_1 ddlb_1
gb_1 gb_1
end type
global w_cm771_stock_valor_us w_cm771_stock_valor_us

type variables
integer ii_index
end variables

on w_cm771_stock_valor_us.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_gen=create rb_gen
this.rb_alm=create rb_alm
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_gen
this.Control[iCurrent+3]=this.rb_alm
this.Control[iCurrent+4]=this.ddlb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_cm771_stock_valor_us.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_gen)
destroy(this.rb_alm)
destroy(this.ddlb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Decimal{6} ld_tipo_cambio
String ls_clase_ppt, ls_clase_spt, ls_almacen

select clase_prod_term, clase_sub_prod 
  into :ls_clase_ppt, :ls_clase_spt
from sig_agricola 
where reckey =1;

select vta_dol_prom 
 into :ld_tipo_cambio
from calendario
where fecha = trunc(sysdate);

IF rb_gen.checked = TRUE THEN
	
	
	idw_1.DataObject = 'd_rpt_stock_val_us_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_clase_ppt,ls_clase_spt,ld_tipo_cambio)
ELSE
	ls_almacen = string(ddlb_1.ia_id )
	
	if ls_almacen = '' or isnull(ls_almacen) then
		messagebox('Aviso','Debe de ingresar un Almacen')
		return
	end if
	idw_1.DataObject = 'd_rpt_stock_val_x_alm_us_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ld_tipo_cambio, ls_almacen, ls_clase_ppt, ls_clase_spt)
end if	
ib_preview = FALSE
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_objeto.text   = dw_report.dataobject
idw_1.object.t_texto.text   = ls_almacen

TriggerEvent ("ue_preview")
end event

type dw_report from w_report_smpl`dw_report within w_cm771_stock_valor_us
integer x = 73
integer y = 320
integer width = 2085
integer height = 416
string dataobject = "d_rpt_stock_val_alm_us_tbl"
end type

type cb_1 from commandbutton within w_cm771_stock_valor_us
integer x = 1728
integer y = 92
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Parent.event ue_retrieve()


end event

type rb_gen from radiobutton within w_cm771_stock_valor_us
integer x = 110
integer y = 76
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
boolean checked = true
end type

event clicked;if rb_gen.checked = true then
	ddlb_1.enabled = false
end if
end event

type rb_alm from radiobutton within w_cm771_stock_valor_us
integer x = 110
integer y = 160
integer width = 416
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por almacen"
end type

event clicked;if rb_alm.checked = true then
	ddlb_1.enabled = true
end if
end event

type ddlb_1 from u_ddlb within w_cm771_stock_valor_us
integer x = 549
integer y = 160
integer width = 1061
integer height = 640
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
boolean enabled = false
end type

event modified;call super::modified;Double ll_count
String ls_codalm
Int li_val = 1

IF ii_index = -1 THEN RETURN



end event

event selectionchanged;call super::selectionchanged;ii_index = index
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_dddw_almacen'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 8                    // Longitud del campo 1
ii_lc2 = 40							// Longitud del campo 2

end event

type gb_1 from groupbox within w_cm771_stock_valor_us
integer x = 69
integer y = 12
integer width = 1586
integer height = 272
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

