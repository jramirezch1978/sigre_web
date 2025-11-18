$PBExportHeader$w_fi704_resumen_bancario.srw
forward
global type w_fi704_resumen_bancario from w_rpt
end type
type st_6 from statictext within w_fi704_resumen_bancario
end type
type st_5 from statictext within w_fi704_resumen_bancario
end type
type st_4 from statictext within w_fi704_resumen_bancario
end type
type st_3 from statictext within w_fi704_resumen_bancario
end type
type st_2 from statictext within w_fi704_resumen_bancario
end type
type st_1 from statictext within w_fi704_resumen_bancario
end type
type sle_hasta from singlelineedit within w_fi704_resumen_bancario
end type
type sle_desde from singlelineedit within w_fi704_resumen_bancario
end type
type sle_libro from singlelineedit within w_fi704_resumen_bancario
end type
type sle_mes from singlelineedit within w_fi704_resumen_bancario
end type
type sle_ano from singlelineedit within w_fi704_resumen_bancario
end type
type sle_origen from singlelineedit within w_fi704_resumen_bancario
end type
type dw_reporte from u_dw_rpt within w_fi704_resumen_bancario
end type
type cb_1 from commandbutton within w_fi704_resumen_bancario
end type
type gb_1 from groupbox within w_fi704_resumen_bancario
end type
end forward

global type w_fi704_resumen_bancario from w_rpt
integer width = 3657
integer height = 2208
string title = "Resumen Bancario"
string menuname = "m_reporte"
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
sle_hasta sle_hasta
sle_desde sle_desde
sle_libro sle_libro
sle_mes sle_mes
sle_ano sle_ano
sle_origen sle_origen
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_fi704_resumen_bancario w_fi704_resumen_bancario

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//
/*
IF (  len(sle_origen.text) <> 2 OR 
		len(sle_ano) <> 4 OR
		len(sle_mes) <> 2 OR
		len(sle_libro) <> 2 OR
		len(sle_desde) <> 0 OR
		len(sle_hasta) <> 0 ) THEN 
	Messagebox('AVISO','DATOS REQUERIDOS INCOMPLETOS')
	sle_origen.SetFocus()
	RETURN FALSE
END IF 
*/

RETURN TRUE
end function

on w_fi704_resumen_bancario.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_hasta=create sle_hasta
this.sle_desde=create sle_desde
this.sle_libro=create sle_libro
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.sle_origen=create sle_origen
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_hasta
this.Control[iCurrent+8]=this.sle_desde
this.Control[iCurrent+9]=this.sle_libro
this.Control[iCurrent+10]=this.sle_mes
this.Control[iCurrent+11]=this.sle_ano
this.Control[iCurrent+12]=this.sle_origen
this.Control[iCurrent+13]=this.dw_reporte
this.Control[iCurrent+14]=this.cb_1
this.Control[iCurrent+15]=this.gb_1
end on

on w_fi704_resumen_bancario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_hasta)
destroy(this.sle_desde)
destroy(this.sle_libro)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.sle_origen)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long   ll_ano, ll_mes, ll_libro, ll_desde, ll_hasta
String ls_origen

ls_origen = trim(sle_origen.text)
ll_ano    = Long (sle_ano.text  )
ll_mes    = Long (sle_mes.text  )
ll_libro  = Long (sle_libro.text)
ll_desde  = Long (sle_desde.text)
ll_hasta  = Long (sle_hasta.text)

IF of_validacion_rpt() THEN

	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_empresa.text   = gs_empresa
	idw_1.object.t_user.text     = gs_user
	//idw_1.object.t_texto.text      = ls_ano
	
	CHOOSE CASE idw_1.retrieve(ls_origen, ll_ano, ll_mes, ll_libro, ll_desde, ll_hasta)
		CASE 0 
			MessageBox('Numero de Filas Recuperadas','No Hay Datos')
		CASE -1
			Messagebox('Numero de Filas Recuperadas','Ocurrio un ERROR en Store Procedure')
	END CHOOSE		
	
END IF	

end event

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type st_6 from statictext within w_fi704_resumen_bancario
integer x = 960
integer y = 196
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Al Asiento :"
boolean focusrectangle = false
end type

type st_5 from statictext within w_fi704_resumen_bancario
integer x = 933
integer y = 92
integer width = 338
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Del Asiento : "
boolean focusrectangle = false
end type

type st_4 from statictext within w_fi704_resumen_bancario
integer x = 69
integer y = 196
integer width = 306
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro cont. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi704_resumen_bancario
integer x = 585
integer y = 196
integer width = 146
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi704_resumen_bancario
integer x = 590
integer y = 92
integer width = 128
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi704_resumen_bancario
integer x = 69
integer y = 92
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_hasta from singlelineedit within w_fi704_resumen_bancario
integer x = 1285
integer y = 196
integer width = 201
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_desde from singlelineedit within w_fi704_resumen_bancario
integer x = 1285
integer y = 92
integer width = 201
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_fi704_resumen_bancario
integer x = 393
integer y = 196
integer width = 142
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_fi704_resumen_bancario
integer x = 741
integer y = 196
integer width = 133
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_fi704_resumen_bancario
integer x = 713
integer y = 92
integer width = 160
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_fi704_resumen_bancario
integer x = 393
integer y = 92
integer width = 142
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_reporte from u_dw_rpt within w_fi704_resumen_bancario
integer x = 14
integer y = 300
integer width = 3589
integer height = 1492
integer taborder = 0
string dataobject = "d_rpt_res_mov_bancario_tbl"
end type

type cb_1 from commandbutton within w_fi704_resumen_bancario
integer x = 2139
integer y = 164
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_fi704_resumen_bancario
integer x = 23
integer y = 24
integer width = 1682
integer height = 268
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos de entrada"
end type

