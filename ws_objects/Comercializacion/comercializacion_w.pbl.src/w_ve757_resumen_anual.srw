$PBExportHeader$w_ve757_resumen_anual.srw
forward
global type w_ve757_resumen_anual from w_rpt
end type
type cbx_fecha from checkbox within w_ve757_resumen_anual
end type
type dw_origen from datawindow within w_ve757_resumen_anual
end type
type st_3 from statictext within w_ve757_resumen_anual
end type
type ddlb_mes from dropdownlistbox within w_ve757_resumen_anual
end type
type dw_reporte from u_dw_rpt within w_ve757_resumen_anual
end type
type cb_1 from commandbutton within w_ve757_resumen_anual
end type
type em_ano from editmask within w_ve757_resumen_anual
end type
type st_2 from statictext within w_ve757_resumen_anual
end type
type st_1 from statictext within w_ve757_resumen_anual
end type
type gb_1 from groupbox within w_ve757_resumen_anual
end type
end forward

global type w_ve757_resumen_anual from w_rpt
integer width = 3511
integer height = 2208
string title = "[VE721] REPORTE DE REGISTRO DE VENTAS"
string menuname = "m_reporte"
cbx_fecha cbx_fecha
dw_origen dw_origen
st_3 st_3
ddlb_mes ddlb_mes
dw_reporte dw_reporte
cb_1 cb_1
em_ano em_ano
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_ve757_resumen_anual w_ve757_resumen_anual

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//

IF len(em_ano.text) < 4 OR em_ano.text = '0000' THEN 
	Messagebox('EL INGRESO DEL AÑO ESTA MAL','EL AÑO DEBE SER DE 4 DIGITOS')
	em_ano.SetFocus()
	RETURN FALSE
END IF 

IF ddlb_mes.text = '' or IsNull(ddlb_mes.text) THEN
	Messagebox('EL INGRESO DEL MES ESTA MAL','EL MES DEBE SER DE 2 DIGITOS')
	ddlb_mes.SetFocus()
	RETURN FALSE
END IF	

RETURN TRUE
end function

on w_ve757_resumen_anual.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_fecha=create cbx_fecha
this.dw_origen=create dw_origen
this.st_3=create st_3
this.ddlb_mes=create ddlb_mes
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.em_ano=create em_ano
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_fecha
this.Control[iCurrent+2]=this.dw_origen
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_mes
this.Control[iCurrent+5]=this.dw_reporte
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.em_ano
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_ve757_resumen_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_fecha)
destroy(this.dw_origen)
destroy(this.st_3)
destroy(this.ddlb_mes)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_ano, ls_origen, ls_desc_origen, &
			ls_desc_origen_rpt,ls_flag_sel, ls_nombre_mes, &
			ls_mensaje

Integer	li_year, li_mes			

li_year 	= Integer(em_ano.text)
li_mes 	= Integer(LEFT(ddlb_mes.text,2))

// Evalua el tipo de origen selecionado
if dw_origen.GetItemString(1,'flag') = '1'  then
	
	ls_origen = '%'
	ls_desc_origen  = ' Todos los Origenes'
	ls_desc_origen_rpt = ls_desc_origen
	
else
	
	ls_origen =  dw_origen.GetItemString(dw_origen.getrow(),'cod_origen')
	select r.nombre 
		into :ls_desc_origen 
	from origen r 
	where r.cod_origen = : ls_origen ; 	
	
	ls_desc_origen_rpt = ls_origen+' - '+ls_desc_origen

end if

IF not of_validacion_rpt() THen return

CHOOSE CASE trim(string(li_mes, '00'))

	CASE '01'
		  ls_nombre_mes = '01 ENERO'
	CASE '02'
		  ls_nombre_mes = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes = '03 MARZO'
	CASE '04'
		  ls_nombre_mes = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes = '05 MAYO'
	CASE '06'
		  ls_nombre_mes = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes = '07 JULIO'
	CASE '08'
		  ls_nombre_mes = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes = '12 DICIEMBRE'
END CHOOSE
//--

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_ano.text      = String(li_year)
idw_1.object.t_mes.text      = ls_nombre_mes
idw_1.object.t_origen.text   = ls_desc_origen_rpt // Descripcion del origen

idw_1.object.t_nombre.text   = gnvo_app.empresa.nombre()
idw_1.object.t_ruc.text		  = gnvo_app.empresa.ruc()

idw_1.retrieve(li_year, li_mes)

if idw_1.RowCount( ) = 0 then
	MessageBox('Numero de Filas Recuperadas','No Hay Datos')
end if

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

dw_origen.SetTransObject(sqlca)
dw_origen.retrieve()
dw_origen.insertrow(0)

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

event resize;call super::resize;dw_reporte.width  = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

event open;call super::open;DateTime ldt_now

ldt_now = gnvo_app.of_fecha_actual()
em_ano.text = string(year(date(ldt_now))) 
ddlb_mes.SelectItem(month(date(ldt_now) ) )
end event

type cbx_fecha from checkbox within w_ve757_resumen_anual
integer x = 2167
integer y = 168
integer width = 526
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Imprimir Fecha"
boolean checked = true
end type

event clicked;if this.checked then
	idw_1.object.t_fecha.visible = 'yes'
	idw_1.object.txt_fecha.visible = 'yes'
else
	idw_1.object.t_fecha.visible = 'no'
	idw_1.object.txt_fecha.visible = 'no'
end if
end event

type dw_origen from datawindow within w_ve757_resumen_anual
integer x = 1344
integer y = 72
integer width = 1399
integer height = 84
integer taborder = 40
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

type st_3 from statictext within w_ve757_resumen_anual
integer x = 1111
integer y = 80
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ORIGEN :"
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_ve757_resumen_anual
integer x = 539
integer y = 72
integer width = 517
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type dw_reporte from u_dw_rpt within w_ve757_resumen_anual
integer y = 272
integer width = 3383
integer height = 1680
integer taborder = 0
string dataobject = "d_rpt_reg_ventas_tbl"
end type

type cb_1 from commandbutton within w_ve757_resumen_anual
integer x = 2848
integer y = 48
integer width = 343
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;SetPointer(HourGlass!)
Event ue_retrieve()
SetPointer(Arrow!)
end event

type em_ano from editmask within w_ve757_resumen_anual
integer x = 169
integer y = 72
integer width = 174
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type st_2 from statictext within w_ve757_resumen_anual
integer x = 384
integer y = 80
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve757_resumen_anual
integer x = 37
integer y = 80
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ve757_resumen_anual
integer width = 2775
integer height = 256
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Periodo  y  Selecciona Origen"
end type

