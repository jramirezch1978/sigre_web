$PBExportHeader$w_cm774_rpt_dscto_materiales.srw
forward
global type w_cm774_rpt_dscto_materiales from w_rpt_list
end type
type uo_1 from u_ingreso_rango_fechas_v within w_cm774_rpt_dscto_materiales
end type
type rb_prov from radiobutton within w_cm774_rpt_dscto_materiales
end type
type rb_art from radiobutton within w_cm774_rpt_dscto_materiales
end type
type gb_1 from groupbox within w_cm774_rpt_dscto_materiales
end type
end forward

global type w_cm774_rpt_dscto_materiales from w_rpt_list
integer width = 2638
integer height = 1592
string title = "Reporte de Descuentos Materiales (CM774)"
string menuname = "m_impresion"
boolean resizable = false
uo_1 uo_1
rb_prov rb_prov
rb_art rb_art
gb_1 gb_1
end type
global w_cm774_rpt_dscto_materiales w_cm774_rpt_dscto_materiales

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
Long 		ll_row
String 	ls_cod, ls_mensaje

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()



SetPointer( Hourglass!)

if dw_2.rowcount() = 0 then return

// Llena datos de dw seleccionados a tabla temporal

if rb_prov.checked=true then
		delete from tt_proveedor;
	//	commit ;
		FOR ll_row = 1 to dw_2.rowcount()
			ls_cod = dw_2.object.proveedor[ll_row]		
			insert into tt_proveedor(proveedor) values (:ls_cod);
		//	commit ;			
		NEXT	
elseif rb_art.checked=true then
	delete from tt_articulos_cmp;
	//	commit ;
		FOR ll_row = 1 to dw_2.rowcount()
			ls_cod = dw_2.object.articulo_mov_proy_cod_art[ll_row]		
			Insert into tt_articulos_cmp(cod_art) values (:ls_cod);
		//	commit ;			
		NEXT	
end iF;
	
	
dw_report.retrieve(ld_desde, ld_hasta)
dw_1.visible = false
dw_2.visible = false
this.Event ue_preview()		
dw_report.visible = true
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_objeto.text   = dw_report.dataobject
dw_report.object.t_texto.text = "Del: " + STRING(LD_DESDE, "DD/MM/YYYY") &
		+ " AL " + STRING(LD_HASTA, "DD/MM/YYYY")
end event

on w_cm774_rpt_dscto_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.rb_prov=create rb_prov
this.rb_art=create rb_art
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.rb_prov
this.Control[iCurrent+3]=this.rb_art
this.Control[iCurrent+4]=this.gb_1
end on

on w_cm774_rpt_dscto_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.rb_prov)
destroy(this.rb_art)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = False
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_cm774_rpt_dscto_materiales
boolean visible = false
integer x = 0
integer y = 260
integer width = 3342
integer height = 1592
end type

type dw_1 from w_rpt_list`dw_1 within w_cm774_rpt_dscto_materiales
integer width = 1115
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1 
end event

event dw_1::ue_selected_row_pro;//Override
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from w_rpt_list`pb_1 within w_cm774_rpt_dscto_materiales
integer x = 1152
integer y = 428
end type

event pb_1::clicked;call super::clicked;IF dw_2.RowCount() > 0 then
	cb_report.enabled = TRUE
END IF
end event

type pb_2 from w_rpt_list`pb_2 within w_cm774_rpt_dscto_materiales
integer x = 1152
integer y = 848
end type

event pb_2::clicked;call super::clicked;IF dw_2.RowCount() = 0 then
	cb_report.enabled = false
END IF
end event

type dw_2 from w_rpt_list`dw_2 within w_cm774_rpt_dscto_materiales
integer x = 1326
integer y = 284
integer width = 1106
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_2::ue_selected_row_pro;// Ancestor Script has been Override
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type cb_report from w_rpt_list`cb_report within w_cm774_rpt_dscto_materiales
integer x = 1477
integer y = 72
boolean enabled = false
boolean default = true
end type

event cb_report::clicked;call super::clicked;parent.event ue_retrieve()
end event

type uo_1 from u_ingreso_rango_fechas_v within w_cm774_rpt_dscto_materiales
integer x = 32
integer y = 24
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type rb_prov from radiobutton within w_cm774_rpt_dscto_materiales
integer x = 777
integer y = 68
integer width = 526
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
string text = "Por Proveedor"
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

if rb_prov.checked = true then
	dw_report.visible = false	
	dw_1.visible = true
	dw_2.visible = true
		
	dw_1.reset()
	dw_2.reset()
	
	SetPointer( Hourglass!)
	
	dw_1.DataObject= 'd_sel_proveedor_tb'
	dw_2.DataObject= 'd_sel_proveedor_tb'
	dw_report.dataobject = 'd_rpt_dscto_materiales_prov'
	dw_1.SetTransObject(sqlca)
	dw_2.SetTransObject(sqlca)
	dw_report.SetTransObject( sqlca)
	
	//dw_1.retrieve(ld_desde, ld_hasta)
	dw_1.retrieve()
	
	SetPointer( Arrow!)

end if;	

end event

type rb_art from radiobutton within w_cm774_rpt_dscto_materiales
integer x = 777
integer y = 140
integer width = 535
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
string text = "Por Articulo"
end type

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

if rb_art.checked = true then
	dw_report.visible = false	
	dw_1.visible = true
	dw_2.visible = true
		
	dw_1.reset()
	dw_2.reset()
	
	SetPointer( Hourglass!)
	
	dw_1.DataObject= 'd_sel_articulo_tb'
	dw_2.DataObject= 'd_sel_articulo_tb'
	dw_report.dataobject = 'd_rpt_dscto_materiales_art'
	dw_1.SetTransObject(sqlca)
	dw_2.SetTransObject(sqlca)
	dw_report.SetTransObject( sqlca)
	
	//dw_1.retrieve(ld_desde, ld_hasta)
	dw_1.retrieve()
	
	SetPointer( Arrow!)

end if;	

end event

type gb_1 from groupbox within w_cm774_rpt_dscto_materiales
integer x = 709
integer y = 12
integer width = 640
integer height = 240
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

