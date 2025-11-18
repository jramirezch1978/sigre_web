$PBExportHeader$w_al764_ajuste_mensual.srw
forward
global type w_al764_ajuste_mensual from w_report_smpl
end type
type cb_reporte from commandbutton within w_al764_ajuste_mensual
end type
type cb_procesar from commandbutton within w_al764_ajuste_mensual
end type
type st_1 from statictext within w_al764_ajuste_mensual
end type
type sle_year from singlelineedit within w_al764_ajuste_mensual
end type
type sle_mes from singlelineedit within w_al764_ajuste_mensual
end type
type st_2 from statictext within w_al764_ajuste_mensual
end type
type gb_fechas from groupbox within w_al764_ajuste_mensual
end type
end forward

global type w_al764_ajuste_mensual from w_report_smpl
integer width = 4791
integer height = 1740
string title = "[AL764] Ajuste Mensual Almacén"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
event ue_select_clases ( )
cb_reporte cb_reporte
cb_procesar cb_procesar
st_1 st_1
sle_year sle_year
sle_mes sle_mes
st_2 st_2
gb_fechas gb_fechas
end type
global w_al764_ajuste_mensual w_al764_ajuste_mensual

type variables

end variables

forward prototypes
public function boolean of_procesar ()
end prototypes

public function boolean of_procesar ();Integer	li_year, li_mes
String	ls_mensaje

li_year 	= Integer(sle_year.text)
li_mes	= Integer(sle_mes.text)

//DECLARE USP_AJUSTE_MENSUAL PROCEDURE FOR
//	  pkg_almacen.sp_ajuste_mensual(:li_year,
//                                 :li_mes,
//                                 :gs_user);

DECLARE USP_AJUSTE_MENSUAL PROCEDURE FOR
	  pkg_almacen.sp_ajuste_mensual(:li_year,
                                	  :li_mes,
                                	  :gs_user);

EXECUTE USP_AJUSTE_MENSUAL;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE pkg_almacen.sp_ajuste_mensual(). Error:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_AJUSTE_MENSUAL;

MessageBox('Aviso', 'Proceso terminado satisfactoriamente', StopSign!)

return true
end function

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al764_ajuste_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_reporte=create cb_reporte
this.cb_procesar=create cb_procesar
this.st_1=create st_1
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.st_2=create st_2
this.gb_fechas=create gb_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_year
this.Control[iCurrent+5]=this.sle_mes
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_fechas
end on

on w_al764_ajuste_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.cb_procesar)
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.st_2)
destroy(this.gb_fechas)
end on

event ue_retrieve;call super::ue_retrieve;Integer	li_year, li_mes

li_year 	= Integer(sle_year.text)
li_mes	= Integer(sle_mes.text)

dw_report.visible = true
dw_report.retrieve(li_year, li_mes)	

dw_report.object.t_fechas.text = 'Año ' + string(li_year) + ' Mes ' + string(li_mes, '00')
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_ventana.text 	= this.classname( )
dw_report.Object.p_logo.filename = gs_logo

	

end event

event ue_open_pre;call super::ue_open_pre;Date 		ld_today

ld_today = Date(gnvo_app.of_fecha_actual())

sle_year.text 	= string(ld_today, 'yyyy')
sle_mes.text 	= string(ld_today, 'mm')

dw_report.Object.DataWindow.Print.Orientation = 1

ib_preview=false
this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al764_ajuste_mensual
integer x = 0
integer y = 312
integer width = 3429
integer height = 1128
string dataobject = "d_rpt_ajuste_mensual_tbl"
end type

type cb_reporte from commandbutton within w_al764_ajuste_mensual
integer x = 626
integer y = 60
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)

cb_procesar.enabled 	= false
cb_reporte.enabled 	= false

Parent.Event ue_retrieve()

cb_procesar.enabled 	= true
cb_reporte.enabled 	= true

SetPointer(Arrow!)
end event

type cb_procesar from commandbutton within w_al764_ajuste_mensual
integer x = 1102
integer y = 60
integer width = 471
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;setPointer(HourGlass!)

cb_reporte.enabled = false
cb_procesar.enabled = false


if of_procesar( ) then
	event ue_retrieve()
end if

cb_reporte.enabled = true
cb_procesar.enabled = true


setPointer(Arrow!)
end event

type st_1 from statictext within w_al764_ajuste_mensual
integer x = 37
integer y = 68
integer width = 238
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_al764_ajuste_mensual
integer x = 302
integer y = 68
integer width = 283
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_al764_ajuste_mensual
integer x = 302
integer y = 164
integer width = 283
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al764_ajuste_mensual
integer x = 37
integer y = 164
integer width = 238
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_fechas from groupbox within w_al764_ajuste_mensual
integer width = 3081
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

