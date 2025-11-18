$PBExportHeader$w_cm707_tablas.srw
forward
global type w_cm707_tablas from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm707_tablas
end type
type cb_3 from commandbutton within w_cm707_tablas
end type
end forward

global type w_cm707_tablas from w_report_smpl
integer width = 2085
integer height = 1132
string title = "[CM707] Visor General de Reportes"
string menuname = "m_impresion"
uo_1 uo_1
cb_3 cb_3
end type
global w_cm707_tablas w_cm707_tablas

type variables

end variables

on w_cm707_tablas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_cm707_tablas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

This.Title = istr_rep.titulo

idw_1.dataobject = istr_rep.dw1
idw_1.SetTransObject( sqlca)


//This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

//this.event ue_preview()
idw_1.Retrieve(ld_desde, ld_hasta)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = istr_rep.dw1
end event

type dw_report from w_report_smpl`dw_report within w_cm707_tablas
integer x = 9
integer y = 152
end type

type uo_1 from u_ingreso_rango_fechas within w_cm707_tablas
integer x = 14
integer y = 28
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

type cb_3 from commandbutton within w_cm707_tablas
integer x = 1682
integer y = 32
integer width = 334
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.Event ue_retrieve()
end event

