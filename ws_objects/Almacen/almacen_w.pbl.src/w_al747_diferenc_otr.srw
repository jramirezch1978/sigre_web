$PBExportHeader$w_al747_diferenc_otr.srw
forward
global type w_al747_diferenc_otr from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_al747_diferenc_otr
end type
type cb_3 from commandbutton within w_al747_diferenc_otr
end type
end forward

global type w_al747_diferenc_otr from w_report_smpl
integer width = 3570
integer height = 1740
string title = "[AL747] Trsalados Valorizados"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
uo_1 uo_1
cb_3 cb_3
end type
global w_al747_diferenc_otr w_al747_diferenc_otr

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al747_diferenc_otr.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_al747_diferenc_otr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
//String 	ls_alm

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

SetPointer( Hourglass!)

dw_report.visible = true

ib_preview=true
this.event ue_preview()

dw_report.SetTransObject( sqlca)
dw_report.retrieve(ld_desde, ld_hasta)	
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.datawindow.Print.Orientation = 1
	
SetPointer( Arrow!)	

end event

event ue_open_pre;call super::ue_open_pre;ib_preview = true

this.event ue_preview( )
end event

type dw_report from w_report_smpl`dw_report within w_al747_diferenc_otr
integer x = 0
integer y = 140
integer width = 3035
integer height = 1092
string dataobject = "d_rpt_diferencias_otr_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type uo_1 from u_ingreso_rango_fechas within w_al747_diferenc_otr
integer x = 14
integer y = 28
integer taborder = 50
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

type cb_3 from commandbutton within w_al747_diferenc_otr
integer x = 1349
integer y = 12
integer width = 402
integer height = 112
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

