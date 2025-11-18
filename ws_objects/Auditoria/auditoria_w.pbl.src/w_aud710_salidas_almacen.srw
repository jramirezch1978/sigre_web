$PBExportHeader$w_aud710_salidas_almacen.srw
forward
global type w_aud710_salidas_almacen from w_report_smpl
end type
type st_1 from statictext within w_aud710_salidas_almacen
end type
type uo_1 from u_ingreso_rango_fechas within w_aud710_salidas_almacen
end type
type cb_3 from commandbutton within w_aud710_salidas_almacen
end type
type dw_1 from datawindow within w_aud710_salidas_almacen
end type
type gb_1 from groupbox within w_aud710_salidas_almacen
end type
type gb_2 from groupbox within w_aud710_salidas_almacen
end type
end forward

global type w_aud710_salidas_almacen from w_report_smpl
integer width = 3465
integer height = 1656
string title = "Control de Salidas del Almacen[AUD710] "
string menuname = "m_reporte"
long backcolor = 12632256
st_1 st_1
uo_1 uo_1
cb_3 cb_3
dw_1 dw_1
gb_1 gb_1
gb_2 gb_2
end type
global w_aud710_salidas_almacen w_aud710_salidas_almacen

on w_aud710_salidas_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_3=create cb_3
this.dw_1=create dw_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_aud710_salidas_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve();call super::ue_retrieve;string ls_almacen
ls_almacen = dw_1.object.almacen[1]

date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

DECLARE pb_usp_aud_rpt_salidas_almacen PROCEDURE FOR USP_AUD_RPT_SALIDAS_ALMACEN
		  ( :ld_fec_desde, :ld_fec_hasta, :ls_almacen ) ;
Execute pb_usp_aud_rpt_salidas_almacen ;

idw_1.Retrieve()

dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.p_logo.filename = gs_logo

end event

event open;call super::open;DataWindowChild state_child
dw_1.GetChild('almacen', state_child)

// Set the transaction object for the child
state_child.SetTransObject(SQLCA)

// Set transaction object for main DW and retrieve
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()
dw_1.insertrow(0)
end event

type dw_report from w_report_smpl`dw_report within w_aud710_salidas_almacen
integer x = 14
integer y = 404
integer width = 3401
integer height = 1064
integer taborder = 30
string dataobject = "d_rpt_salidas_almacen_tbl"
end type

type st_1 from statictext within w_aud710_salidas_almacen
integer x = 1221
integer y = 44
integer width = 1143
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = " SALIDAS DEL ALMACEN "
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_aud710_salidas_almacen
integer x = 279
integer y = 236
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio
uo_1.of_set_label('Desde','Hasta')

// obtenemos el primer dia del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

type cb_3 from commandbutton within w_aud710_salidas_almacen
integer x = 3122
integer y = 236
integer width = 274
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_1 from datawindow within w_aud710_salidas_almacen
integer x = 1755
integer y = 240
integer width = 1262
integer height = 80
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_almacen_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_aud710_salidas_almacen
integer x = 229
integer y = 168
integer width = 1381
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Ingrese Rango de Fechas "
end type

type gb_2 from groupbox within w_aud710_salidas_almacen
integer x = 1687
integer y = 168
integer width = 1376
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Almacen "
end type

