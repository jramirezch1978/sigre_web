$PBExportHeader$w_ve504_cns_factura_cobrar.srw
forward
global type w_ve504_cns_factura_cobrar from w_abc_master_tab
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type st_1 from statictext within w_ve504_cns_factura_cobrar
end type
type cb_1 from commandbutton within w_ve504_cns_factura_cobrar
end type
type sle_tipo_doc from singlelineedit within w_ve504_cns_factura_cobrar
end type
type st_2 from statictext within w_ve504_cns_factura_cobrar
end type
type sle_nro_doc from singlelineedit within w_ve504_cns_factura_cobrar
end type
end forward

global type w_ve504_cns_factura_cobrar from w_abc_master_tab
integer width = 4192
integer height = 2492
string title = "[VE504] Consulta de cuenta por cobrar"
string menuname = "m_consulta"
long backcolor = 134217750
st_1 st_1
cb_1 cb_1
sle_tipo_doc sle_tipo_doc
st_2 st_2
sle_nro_doc sle_nro_doc
end type
global w_ve504_cns_factura_cobrar w_ve504_cns_factura_cobrar

type variables
String is_articulo
end variables

forward prototypes
public subroutine of_get_orden (string as_tipo_doc, string as_nro_doc)
end prototypes

public subroutine of_get_orden (string as_tipo_doc, string as_nro_doc);Long ll_count
String ls_doc_ov 
//
//ls_tipo_doc = TRIM (sle_tipo_doc.text)
//ls_nro_doc = TRIM(sle_nro_doc.text)

Select count(*) into :ll_count from cntas_cobrar where 
    tipo_doc = :as_tipo_doc AND nro_doc = :as_nro_doc ;
	 
if ll_count = 0 then
	Messagebox( "Error", "Cuenta por cobrar no existe")		
	Return
end if

Select doc_ov INTO :ls_doc_ov FROM logparam WHERE reckey='1' ;

dw_master.Retrieve(as_tipo_doc, as_nro_doc)
tab_1.SelectTab(1)

tab_1.tabpage_1.dw_1.Retrieve(as_tipo_doc, as_nro_doc)
tab_1.tabpage_2.dw_2.Retrieve(as_tipo_doc, as_nro_doc, ls_doc_ov)
tab_1.tabpage_3.dw_3.Retrieve(as_tipo_doc, as_nro_doc)
tab_1.tabpage_4.dw_4.Retrieve(as_tipo_doc, as_nro_doc)
tab_1.tabpage_5.dw_5.Retrieve(as_tipo_doc, as_nro_doc)

end subroutine

on w_ve504_cns_factura_cobrar.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_tipo_doc=create sle_tipo_doc
this.st_2=create st_2
this.sle_nro_doc=create sle_nro_doc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_tipo_doc
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_nro_doc
end on

on w_ve504_cns_factura_cobrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_tipo_doc)
destroy(this.st_2)
destroy(this.sle_nro_doc)
end on

event ue_open_pre;call super::ue_open_pre;//dw_orden.SetTransObject(sqlca)
//dw_oper.SetTransObject(sqlca)
tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_4.SetTransObject(sqlca)
tab_1.tabpage_5.dw_5.SetTransObject(sqlca)

tab_1.tabpage_5.dw_5.enabled = FALSE
end event

event ue_dw_share;// Override

end event

type dw_master from w_abc_master_tab`dw_master within w_ve504_cns_factura_cobrar
integer y = 192
integer width = 3397
integer height = 936
string dataobject = "d_cns_cntas_x_cobrar_cab_ff"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type tab_1 from w_abc_master_tab`tab_1 within w_ve504_cns_factura_cobrar
integer x = 59
integer y = 1188
integer width = 4023
integer height = 1088
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_5=create tabpage_5
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_5
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_5)
end on

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer width = 3986
integer height = 960
string text = "Detalle"
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer width = 3963
integer height = 912
string dataobject = "d_cns_cntas_x_cobrar_det_tab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectura de este dw

end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
integer width = 3986
integer height = 960
string text = "Orden de venta"
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer width = 3950
integer height = 924
string dataobject = "d_cns_oventa_cnta_cob_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectura de este dw

end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
integer width = 3986
integer height = 960
string text = "Guías de remisión"
end type

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
integer width = 3858
integer height = 884
string dataobject = "d_cns_guia_x_cnta_cobrar_grd"
boolean vscrollbar = true
end type

event dw_3::constructor;call super::constructor;is_mastdet = 'd'		
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
integer width = 3986
integer height = 960
string text = "Cobranza"
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
integer width = 3973
integer height = 920
string dataobject = "d_cns_cobranza_cnta_cob_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_4::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle, 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3986
integer height = 960
long backcolor = 79741120
string text = "Notas de venta"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_cns within tabpage_5
integer x = 69
integer y = 48
integer width = 3895
integer height = 884
integer taborder = 20
string dataobject = "d_cns_notas_venta_cnta_cobrar_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

end event

type st_1 from statictext within w_ve504_cns_factura_cobrar
integer x = 585
integer y = 44
integer width = 498
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
string text = "Nro documento:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve504_cns_factura_cobrar
integer x = 1472
integer y = 24
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_tipo_doc, ls_nro_doc 
ls_tipo_doc = TRIM(sle_tipo_doc.text)
ls_nro_doc 	= TRIM(sle_nro_doc.text)
of_get_orden( ls_tipo_doc, ls_nro_doc )


end event

type sle_tipo_doc from singlelineedit within w_ve504_cns_factura_cobrar
integer x = 370
integer y = 32
integer width = 151
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve504_cns_factura_cobrar
integer x = 41
integer y = 28
integer width = 311
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
string text = "Tipo doc:"
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_ve504_cns_factura_cobrar
integer x = 1083
integer y = 32
integer width = 343
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

