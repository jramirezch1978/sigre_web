$PBExportHeader$w_al714_tablas.srw
forward
global type w_al714_tablas from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_al714_tablas
end type
type cb_3 from commandbutton within w_al714_tablas
end type
type cb_4 from commandbutton within w_al714_tablas
end type
type gb_1 from groupbox within w_al714_tablas
end type
end forward

global type w_al714_tablas from w_report_smpl
integer width = 1865
integer height = 848
string title = "Tablas (AL714)"
string menuname = "m_impresion"
uo_1 uo_1
cb_3 cb_3
cb_4 cb_4
gb_1 gb_1
end type
global w_al714_tablas w_al714_tablas

type variables

end variables

on w_al714_tablas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.gb_1
end on

on w_al714_tablas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;istr_rep = message.powerobjectparm
This.Title = istr_rep.titulo
idw_1.dataobject = istr_rep.dw1
idw_1.SetTransObject( sqlca)


//This.Event ue_retrieve()

end event

event ue_retrieve();call super::ue_retrieve;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

//this.event ue_preview()
idw_1.Retrieve(ld_desde, ld_hasta)
//idw_1.Object.p_logo.filename = gs_logo
end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

type dw_report from w_report_smpl`dw_report within w_al714_tablas
integer x = 37
integer y = 288
integer width = 1723
integer height = 292
end type

event dw_report::doubleclicked;call super::doubleclicked;//Codigo
end event

type uo_1 from u_ingreso_rango_fechas within w_al714_tablas
integer x = 73
integer y = 120
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_al714_tablas
integer x = 1426
integer y = 160
integer width = 334
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.Event ue_retrieve()
end event

type cb_4 from commandbutton within w_al714_tablas
integer x = 1426
integer y = 32
integer width = 334
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;str_parametros lstr_1

//lstr_1.dw_m = dw_report
openwithparm (w_filtros, lstr_1)
end event

type gb_1 from groupbox within w_al714_tablas
integer x = 37
integer y = 32
integer width = 1358
integer height = 228
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

