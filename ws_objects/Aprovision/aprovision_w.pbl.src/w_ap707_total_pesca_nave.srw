$PBExportHeader$w_ap707_total_pesca_nave.srw
forward
global type w_ap707_total_pesca_nave from w_rpt
end type
type st_descripcion from statictext within w_ap707_total_pesca_nave
end type
type dw_origen from u_dw_abc within w_ap707_total_pesca_nave
end type
type sle_especie from singlelineedit within w_ap707_total_pesca_nave
end type
type cbx_especie from checkbox within w_ap707_total_pesca_nave
end type
type pb_1 from picturebutton within w_ap707_total_pesca_nave
end type
type st_1 from statictext within w_ap707_total_pesca_nave
end type
type rb_3 from radiobutton within w_ap707_total_pesca_nave
end type
type rb_2 from radiobutton within w_ap707_total_pesca_nave
end type
type rb_1 from radiobutton within w_ap707_total_pesca_nave
end type
type em_fecha from editmask within w_ap707_total_pesca_nave
end type
type dw_report from u_dw_rpt within w_ap707_total_pesca_nave
end type
type gb_1 from groupbox within w_ap707_total_pesca_nave
end type
type gb_2 from groupbox within w_ap707_total_pesca_nave
end type
end forward

global type w_ap707_total_pesca_nave from w_rpt
integer width = 3415
integer height = 2048
string title = "Reporte Mensual de Pesca por Embarcacion (AP707)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
st_descripcion st_descripcion
dw_origen dw_origen
sle_especie sle_especie
cbx_especie cbx_especie
pb_1 pb_1
st_1 st_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
em_fecha em_fecha
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
end type
global w_ap707_total_pesca_nave w_ap707_total_pesca_nave

type variables
string is_cod_origen
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();this.event dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

IF em_fecha.Text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una año')
	return lb_ok = False
END IF

IF sle_especie.Text = '' and Not cbx_especie.Checked THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una Especie')
	RETURN lb_ok = False
END IF

// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok



end function

on w_ap707_total_pesca_nave.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_descripcion=create st_descripcion
this.dw_origen=create dw_origen
this.sle_especie=create sle_especie
this.cbx_especie=create cbx_especie
this.pb_1=create pb_1
this.st_1=create st_1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.em_fecha=create em_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_descripcion
this.Control[iCurrent+2]=this.dw_origen
this.Control[iCurrent+3]=this.sle_especie
this.Control[iCurrent+4]=this.cbx_especie
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.em_fecha
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_ap707_total_pesca_nave.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_descripcion)
destroy(this.dw_origen)
destroy(this.sle_especie)
destroy(this.cbx_especie)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.em_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'

em_fecha.text = STRING(f_fecha_actual(),'yyyy')

THIS.Event ue_preview()


end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string ls_fecha, ls_tipoFlota, ls_especie

IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

ls_fecha = em_fecha.text

IF rb_1.Checked THEN     					//Flota Propia
	ls_tipoflota = 'P'
ELSEIF rb_2.Checked THEN
	ls_tipoflota = 'T'						//Flota Terceros
ELSE
	ls_tipoflota = '%%'
END IF

IF cbx_especie.Checked THEN
	ls_especie = '%%'							//Todas las especies
ELSE
	ls_especie = Trim(sle_especie.Text)	//Solo una especie
END IF

idw_1.Retrieve(ls_fecha, ls_tipoflota, ls_especie, is_cod_origen)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo

idw_1.Visible = True
idw_1.SetRedraw(true)





end event

type st_descripcion from statictext within w_ap707_total_pesca_nave
integer x = 622
integer y = 204
integer width = 983
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_origen from u_dw_abc within w_ap707_total_pesca_nave
integer x = 1691
integer y = 44
integer width = 1001
integer height = 268
integer taborder = 50
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type sle_especie from singlelineedit within w_ap707_total_pesca_nave
event dobleclick pbm_lbuttondblclk
integer x = 338
integer y = 204
integer width = 279
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT ESPECIE AS COD_ESPECIE, " &
		  + "DESCR_ESPECIE AS DESCRIPCION_ESPECIE " &
		  + "FROM TG_ESPECIES " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text 				= ls_codigo
	st_descripcion.text = ls_data
end if

end event

event modified;String 	ls_especie, ls_desc

ls_especie = sle_especie.text
if ls_especie = '' or IsNull(ls_especie) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de especie')
	return
end if

SELECT descr_especie
	INTO :ls_desc
FROM tg_especies
WHERE especie = :ls_especie;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Especie no existe')
	st_descripcion.text = ''
	This.text 			  = ''
	return
end if

st_descripcion.text = ls_desc

end event

type cbx_especie from checkbox within w_ap707_total_pesca_nave
integer x = 82
integer y = 212
integer width = 265
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todas"
boolean checked = true
end type

event clicked;IF THIS.CHECKED THEN
	sle_especie.Enabled 	= False
	sle_especie.Text 		= ''
	st_descripcion.Text = ''
ELSE
	sle_especie.Enabled = True
END IF
end event

type pb_1 from picturebutton within w_ap707_total_pesca_nave
integer x = 2917
integer y = 96
integer width = 306
integer height = 148
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()



end event

type st_1 from statictext within w_ap707_total_pesca_nave
integer x = 87
integer y = 60
integer width = 151
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_ap707_total_pesca_nave
integer x = 1317
integer y = 60
integer width = 279
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambas"
end type

type rb_2 from radiobutton within w_ap707_total_pesca_nave
integer x = 978
integer y = 60
integer width = 366
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terceros"
end type

type rb_1 from radiobutton within w_ap707_total_pesca_nave
integer x = 695
integer y = 60
integer width = 320
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Propia"
boolean checked = true
end type

type em_fecha from editmask within w_ap707_total_pesca_nave
integer x = 247
integer y = 44
integer width = 306
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
string minmax = "2000~~2090"
end type

type dw_report from u_dw_rpt within w_ap707_total_pesca_nave
integer x = 27
integer y = 356
integer width = 3319
integer height = 1472
integer taborder = 20
string dataobject = "d_ap_total_pesca_nave_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ap707_total_pesca_nave
integer x = 667
integer y = 20
integer width = 951
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Flota"
end type

type gb_2 from groupbox within w_ap707_total_pesca_nave
integer x = 64
integer y = 144
integer width = 1563
integer height = 172
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Especie:"
end type

