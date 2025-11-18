$PBExportHeader$w_cn722_rpt_almacen.srw
forward
global type w_cn722_rpt_almacen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn722_rpt_almacen
end type
type uo_1 from u_ingreso_rango_fechas within w_cn722_rpt_almacen
end type
type gb_1 from groupbox within w_cn722_rpt_almacen
end type
end forward

global type w_cn722_rpt_almacen from w_report_smpl
integer width = 3410
integer height = 1760
string title = "Movimiento de almacenes a contabilizar (CN721)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
uo_1 uo_1
gb_1 gb_1
end type
global w_cn722_rpt_almacen w_cn722_rpt_almacen

type variables

end variables

on w_cn722_rpt_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_cn722_rpt_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event resize;call super::resize;// prueba

end event

type dw_report from w_report_smpl`dw_report within w_cn722_rpt_almacen
integer x = 9
integer y = 312
integer width = 3333
integer height = 1316
integer taborder = 50
string dataobject = "d_rpt_movim_almacenes_tbl"
end type

type cb_1 from commandbutton within w_cn722_rpt_almacen
integer x = 2821
integer y = 124
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
string text = "Imprime"
end type

event clicked;Date ld_fecini, ld_fecfin

ld_fecini = uo_1.of_get_fecha1()
ld_fecfin = uo_1.of_get_fecha2()  

//IF is_opcion='R' then
//	idw_1.DataObject='d_rpt_pre_asiento_codrel_error_tbl'
//ELSE
//	messagebox('Seleccione opcion','de los mostrados en pantalla')
//END IF
idw_1.SetTransObject(sqlca)
idw_1.retrieve(ld_fecini, ld_fecfin)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = 'Del : ' + string(ld_fecini,'dd/mm/yyyy') + ' al: ' + string(ld_fecfin,'dd/mm/yyyy')

idw_1.visible = true
parent.event ue_preview()

end event

type uo_1 from u_ingreso_rango_fechas within w_cn722_rpt_almacen
integer x = 96
integer y = 120
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_1 from groupbox within w_cn722_rpt_almacen
integer x = 37
integer y = 28
integer width = 1408
integer height = 236
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
borderstyle borderstyle = stylelowered!
end type

