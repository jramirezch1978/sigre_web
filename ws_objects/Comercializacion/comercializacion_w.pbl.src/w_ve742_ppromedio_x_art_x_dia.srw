$PBExportHeader$w_ve742_ppromedio_x_art_x_dia.srw
forward
global type w_ve742_ppromedio_x_art_x_dia from w_rpt
end type
type sle_desc_art from singlelineedit within w_ve742_ppromedio_x_art_x_dia
end type
type cb_2 from commandbutton within w_ve742_ppromedio_x_art_x_dia
end type
type sle_cod_art from singlelineedit within w_ve742_ppromedio_x_art_x_dia
end type
type st_2 from statictext within w_ve742_ppromedio_x_art_x_dia
end type
type cb_1 from commandbutton within w_ve742_ppromedio_x_art_x_dia
end type
type uo_1 from u_ingreso_rango_fechas within w_ve742_ppromedio_x_art_x_dia
end type
type dw_report from u_dw_rpt within w_ve742_ppromedio_x_art_x_dia
end type
type gb_1 from groupbox within w_ve742_ppromedio_x_art_x_dia
end type
end forward

global type w_ve742_ppromedio_x_art_x_dia from w_rpt
integer width = 3122
integer height = 1932
string title = "Promedio de Ventas por Dia(VE742)"
string menuname = "m_reporte"
long backcolor = 67108864
sle_desc_art sle_desc_art
cb_2 cb_2
sle_cod_art sle_cod_art
st_2 st_2
cb_1 cb_1
uo_1 uo_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve742_ppromedio_x_art_x_dia w_ve742_ppromedio_x_art_x_dia

on w_ve742_ppromedio_x_art_x_dia.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_desc_art=create sle_desc_art
this.cb_2=create cb_2
this.sle_cod_art=create sle_cod_art
this.st_2=create st_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_art
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_cod_art
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve742_ppromedio_x_art_x_dia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_art)
destroy(this.cb_2)
destroy(this.sle_cod_art)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()




end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_retrieve;call super::ue_retrieve;String  ls_fecha_inicial,ls_fecha_final,ls_cod_art,ls_nom_art,ls_und
Date    ld_fecha_prox
Long    ll_found,ll_row_insert
Integer lin = 0
String  ls_expresion


ls_fecha_inicial = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final   = String(uo_1.of_get_fecha2(),'yyyymmdd')

ls_cod_art		  = sle_cod_art.text



dw_report.retrieve(ls_fecha_inicial,ls_fecha_final,ls_cod_art)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user
dw_report.accepttext()
//asiganr fechas en blanco

ld_fecha_prox = uo_1.of_get_fecha1()


//datos del articulo
select nom_articulo,und into :ls_nom_art,:ls_und from articulo
 where cod_art = :ls_cod_art ;


do 
	lin = lin + 1
	
	if lin <> 1 then
	   ld_fecha_prox = RelativeDate(ld_fecha_prox, 1)
	end if
	
	//busco si existe
	ls_expresion = "String(fecha_documento,'yyyymmdd') = " + "'"+String(ld_fecha_prox,'yyyymmdd')  +"'"
	ll_found = dw_report.find(ls_expresion,1,dw_report.rowcount())
	
	if ll_found <= 0 then
		//inserta fecha
		ll_row_insert = dw_report.insertrow(0)

		dw_report.object.cod_art			[ll_row_insert] = ls_cod_art
		dw_report.object.und					[ll_row_insert] = ls_und
		dw_report.object.nom_articulo    [ll_row_insert] = ls_nom_art
		dw_report.object.fecha_documento [ll_row_insert] = ld_fecha_prox
		dw_report.object.precio_promedio [ll_row_insert] = 0.00
	end if
	
		

loop while ld_fecha_prox < uo_1.of_get_fecha2()

//reordenar
dw_report.SetSort('fecha_documento asc')
dw_report.Sort( )
end event

type sle_desc_art from singlelineedit within w_ve742_ppromedio_x_art_x_dia
integer x = 965
integer y = 124
integer width = 1413
integer height = 84
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217752
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ve742_ppromedio_x_art_x_dia
integer x = 841
integer y = 124
integer width = 101
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'

lstr_seleccionar.s_sql =  'SELECT ART.COD_ART AS CODIGO, '&
   							        +'ART.NOM_ARTICULO AS DESCRIPCION '&
										  +'FROM ARTICULO ART '
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cod_art.text  = lstr_seleccionar.param1[1]
	sle_desc_art.text = lstr_seleccionar.param2[1]
ELSE
	sle_cod_art.text  = ''
	sle_desc_art.text = '' 
END IF

end event

type sle_cod_art from singlelineedit within w_ve742_ppromedio_x_art_x_dia
integer x = 352
integer y = 124
integer width = 466
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve742_ppromedio_x_art_x_dia
integer x = 37
integer y = 128
integer width = 279
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Articulo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve742_ppromedio_x_art_x_dia
integer x = 2711
integer y = 292
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "P&rocesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type uo_1 from u_ingreso_rango_fechas within w_ve742_ppromedio_x_art_x_dia
integer x = 69
integer y = 236
integer height = 88
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type dw_report from u_dw_rpt within w_ve742_ppromedio_x_art_x_dia
integer y = 420
integer width = 3063
integer height = 1320
string dataobject = "d_abc_ppromedio_x_dia_tbl"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ve742_ppromedio_x_art_x_dia
integer x = 18
integer y = 52
integer width = 2469
integer height = 320
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ingrese Datos"
end type

