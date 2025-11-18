$PBExportHeader$w_aud711_salidas_pptt.srw
forward
global type w_aud711_salidas_pptt from w_report_smpl
end type
type st_1 from statictext within w_aud711_salidas_pptt
end type
type uo_1 from u_ingreso_rango_fechas within w_aud711_salidas_pptt
end type
type cb_3 from commandbutton within w_aud711_salidas_pptt
end type
type dw_1 from datawindow within w_aud711_salidas_pptt
end type
type rb_2 from radiobutton within w_aud711_salidas_pptt
end type
type rb_1 from radiobutton within w_aud711_salidas_pptt
end type
type gb_1 from groupbox within w_aud711_salidas_pptt
end type
type gb_2 from groupbox within w_aud711_salidas_pptt
end type
type gb_3 from groupbox within w_aud711_salidas_pptt
end type
end forward

global type w_aud711_salidas_pptt from w_report_smpl
integer width = 3465
integer height = 1656
string title = "Detalle de Productos Terminados[AUD711] "
string menuname = "m_reporte"
long backcolor = 12632256
st_1 st_1
uo_1 uo_1
cb_3 cb_3
dw_1 dw_1
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_aud711_salidas_pptt w_aud711_salidas_pptt

on w_aud711_salidas_pptt.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_3=create cb_3
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_aud711_salidas_pptt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve();call super::ue_retrieve;string ls_almacen

date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

IF rb_1.checked=true THEN
	ls_almacen = dw_1.object.almacen[1]
	
	DECLARE PB_USP_AUD_RPT_SALIDAS_PPTT_MM PROCEDURE FOR USP_AUD_RPT_SALIDAS_PPTT_MM
		  ( :ld_fec_desde, :ld_fec_hasta, :ls_almacen ) ;
	Execute PB_USP_AUD_RPT_SALIDAS_PPTT_MM ;
END IF ;

IF rb_2.checked=TRUE THEN
	DECLARE PB_USP_AUD_RPT_CORR_SAL_PPTT_MM PROCEDURE FOR USP_AUD_RPT_CORR_SAL_PPTT_MM
		  ( :ld_fec_desde, :ld_fec_hasta ) ;
	Execute PB_USP_AUD_RPT_CORR_SAL_PPTT_MM ;
END IF

idw_1.Retrieve()

dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.p_logo.filename = gs_logo

end event

event open;call super::open;dw_1.enabled = false

DataWindowChild state_child
dw_1.GetChild('almacen', state_child)

// Set the transaction object for the child
state_child.SetTransObject(SQLCA)

// Set transaction object for main DW and retrieve
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()
dw_1.insertrow(0)
end event

type dw_report from w_report_smpl`dw_report within w_aud711_salidas_pptt
integer x = 14
integer y = 476
integer width = 3401
integer height = 992
integer taborder = 30
string dataobject = "d_rpt_salidas_pptt_tbl_mm"
end type

type st_1 from statictext within w_aud711_salidas_pptt
integer x = 1061
integer y = 76
integer width = 2322
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
string text = " CONTROL DE SALIDAS PRODUCTOS TERMINADOS "
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_aud711_salidas_pptt
integer x = 279
integer y = 304
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

type cb_3 from commandbutton within w_aud711_salidas_pptt
integer x = 3122
integer y = 304
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

type dw_1 from datawindow within w_aud711_salidas_pptt
integer x = 1755
integer y = 308
integer width = 1262
integer height = 80
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_almacen_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_aud711_salidas_pptt
integer x = 645
integer y = 96
integer width = 274
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Todos"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_2.checked = true then
	dw_1.object.almacen[1] = ' '
	dw_1.enabled = false
end if

end event

type rb_1 from radiobutton within w_aud711_salidas_pptt
integer x = 297
integer y = 96
integer width = 329
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Almacen"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_1.checked = true then
	dw_1.enabled = true
end if


end event

type gb_1 from groupbox within w_aud711_salidas_pptt
integer x = 229
integer y = 236
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

type gb_2 from groupbox within w_aud711_salidas_pptt
integer x = 1687
integer y = 236
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

type gb_3 from groupbox within w_aud711_salidas_pptt
integer x = 233
integer y = 32
integer width = 722
integer height = 172
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Opción "
end type

