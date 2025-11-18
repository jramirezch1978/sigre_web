$PBExportHeader$w_ve725_rpt_cobrar_x_art.srw
forward
global type w_ve725_rpt_cobrar_x_art from w_rpt
end type
type rb_2 from radiobutton within w_ve725_rpt_cobrar_x_art
end type
type rb_1 from radiobutton within w_ve725_rpt_cobrar_x_art
end type
type cbx_articulos from checkbox within w_ve725_rpt_cobrar_x_art
end type
type sle_moneda from singlelineedit within w_ve725_rpt_cobrar_x_art
end type
type st_1 from statictext within w_ve725_rpt_cobrar_x_art
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve725_rpt_cobrar_x_art
end type
type cbx_origenes from checkbox within w_ve725_rpt_cobrar_x_art
end type
type sle_desc from singlelineedit within w_ve725_rpt_cobrar_x_art
end type
type sle_origen from singlelineedit within w_ve725_rpt_cobrar_x_art
end type
type cb_articulos from commandbutton within w_ve725_rpt_cobrar_x_art
end type
type cb_1 from commandbutton within w_ve725_rpt_cobrar_x_art
end type
type gb_1 from groupbox within w_ve725_rpt_cobrar_x_art
end type
type dw_report from u_dw_rpt within w_ve725_rpt_cobrar_x_art
end type
type gb_2 from groupbox within w_ve725_rpt_cobrar_x_art
end type
end forward

global type w_ve725_rpt_cobrar_x_art from w_rpt
integer width = 4361
integer height = 1452
string title = "[VE725] Reporte de Ventas de Productos"
string menuname = "m_reporte"
rb_2 rb_2
rb_1 rb_1
cbx_articulos cbx_articulos
sle_moneda sle_moneda
st_1 st_1
uo_fechas uo_fechas
cbx_origenes cbx_origenes
sle_desc sle_desc
sle_origen sle_origen
cb_articulos cb_articulos
cb_1 cb_1
gb_1 gb_1
dw_report dw_report
gb_2 gb_2
end type
global w_ve725_rpt_cobrar_x_art w_ve725_rpt_cobrar_x_art

type variables
String	is_dolares, is_soles
str_seleccionar istr_seleccionar
end variables

on w_ve725_rpt_cobrar_x_art.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_articulos=create cbx_articulos
this.sle_moneda=create sle_moneda
this.st_1=create st_1
this.uo_fechas=create uo_fechas
this.cbx_origenes=create cbx_origenes
this.sle_desc=create sle_desc
this.sle_origen=create sle_origen
this.cb_articulos=create cb_articulos
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.cbx_articulos
this.Control[iCurrent+4]=this.sle_moneda
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.uo_fechas
this.Control[iCurrent+7]=this.cbx_origenes
this.Control[iCurrent+8]=this.sle_desc
this.Control[iCurrent+9]=this.sle_origen
this.Control[iCurrent+10]=this.cb_articulos
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.dw_report
this.Control[iCurrent+14]=this.gb_2
end on

on w_ve725_rpt_cobrar_x_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_articulos)
destroy(this.sle_moneda)
destroy(this.st_1)
destroy(this.uo_fechas)
destroy(this.cbx_origenes)
destroy(this.sle_desc)
destroy(this.sle_origen)
destroy(this.cb_articulos)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
//
//
// ii_help = 101           // help topic

SELECT cod_soles,cod_dolares
  INTO :is_soles,:is_dolares
  FROM logparam
 WHERE (reckey = '1' );

sle_moneda.text =is_dolares
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;Date   	ld_fecha1, ld_fecha2
String 	ls_origen, ls_moneda
Integer	li_count

ld_fecha1  = uo_fechas.of_get_fecha1()
ld_fecha2  = uo_fechas.of_get_fecha2()

if cbx_origenes.checked then
	ls_origen = '%%'
else
	if trim(sle_origen.text) = '' then
		f_mensaje('', 'Error, debe seleccionar un origen válido')
		sle_origen.SetFocus()
		return
	end if
	ls_origen = trim(sle_origen.text) + '%'
end if

if trim(sle_moneda.text) = '' then
	f_mensaje('', 'Error, debe seleccionar una moneda válido')
	sle_moneda.SetFocus()
	return
end if
ls_moneda = sle_moneda.text

if cbx_articulos.checked then
	delete tt_fin_rpt_art;
	if gnvo_app.of_ExistsError(SQLCA) then return
	
	Insert Into tt_fin_rpt_art(cod_art)  
	  select 'OTROS' from dual
	  union all
	  SELECT DISTINCT A.COD_ART
    FROM ARTICULO				A,   
         CNTAS_COBRAR_DET  CCD
   WHERE A.COD_ART   = CCD.COD_ART;
	
	if gnvo_app.of_ExistsError(SQLCA) then return 
	
else
	Select count(*)
	  into :li_count
	from tt_fin_rpt_art;
	
	if li_count = 0 then
		f_mensaje('No ha seleccionado ningún articulo para el reporte, por favor verifique!', '')
		return
	end if
end if


idw_1 = dw_report
idw_1.Visible = TRUE
ib_preview = FALSE
this.Event ue_preview()

if rb_2.checked then
	idw_1.dataObject = 'd_rpt_venta_x_producto_tv'
	idw_1.setTransObject(SQLCA)
else
	idw_1.dataObject = 'd_rpt_prod_x_cobrar_x_moneda_tbl'
	idw_1.setTransObject(SQLCA)
end if

dw_report.Retrieve(ld_fecha1, ld_fecha2, ls_origen, ls_moneda)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user

end event

type rb_2 from radiobutton within w_ve725_rpt_cobrar_x_art
integer x = 2423
integer y = 168
integer width = 654
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupado (Treeview)"
end type

type rb_1 from radiobutton within w_ve725_rpt_cobrar_x_art
integer x = 2423
integer y = 96
integer width = 654
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tabular"
boolean checked = true
end type

type cbx_articulos from checkbox within w_ve725_rpt_cobrar_x_art
integer x = 1353
integer y = 72
integer width = 585
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los articulos"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	cb_Articulos.enabled = false
else
	cb_Articulos.enabled = true
end if
end event

type sle_moneda from singlelineedit within w_ve725_rpt_cobrar_x_art
event dobleclick pbm_lbuttondblclk
integer x = 2126
integer y = 180
integer width = 233
integer height = 88
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;String ls_sql, ls_data, ls_codigo

ls_sql = "SELECT 	cod_moneda as codigo_moneda, " &
		 + "descripcion as descripcion_moneda " &
		 + "FROM moneda bc " &
		 + "where flag_estado = '1'"
		 
f_lista(ls_sql, ls_codigo, ls_data, "2")

if ls_codigo <> "" then
	this.text = ls_codigo
end if

end event

event modified;String ls_moneda
Long   ll_count


ls_moneda = this.text


select count(*) into :ll_count 
  from moneda 
 where cod_moneda = :ls_moneda ;
 
IF ll_count = 0 THEN
	MessageBox('Aviso', 'El código de moneda no existe, por favor verifique')
	sle_desc.text = gnvo_app.is_null
END IF
 

end event

type st_1 from statictext within w_ve725_rpt_cobrar_x_art
integer x = 1851
integer y = 192
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_ve725_rpt_cobrar_x_art
event destroy ( )
integer x = 27
integer y = 64
integer taborder = 100
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_Actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cbx_origenes from checkbox within w_ve725_rpt_cobrar_x_art
integer x = 27
integer y = 188
integer width = 599
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes "
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
	sle_origen.text = ""
	sle_desc.text = "TODAS"
else
	sle_origen.enabled = true
	sle_desc.text = ""
end if
end event

type sle_desc from singlelineedit within w_ve725_rpt_cobrar_x_art
integer x = 887
integer y = 180
integer width = 942
integer height = 88
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_ve725_rpt_cobrar_x_art
event dobleclick pbm_lbuttondblclk
integer x = 640
integer y = 180
integer width = 233
integer height = 88
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   this.text 		 =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type cb_articulos from commandbutton within w_ve725_rpt_cobrar_x_art
integer x = 1966
integer y = 60
integer width = 375
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "&Articulos"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete tt_fin_rpt_art ;
commit;

sl_param.dw1		= 'd_rpt_art_temp_tbl'
sl_param.titulo	= 'Articulos'
sl_param.opcion   = 14
sl_param.db1 		= 1600
sl_param.string1 	= '1ART'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_1 from commandbutton within w_ve725_rpt_cobrar_x_art
integer x = 3127
integer y = 16
integer width = 411
integer height = 236
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_ve725_rpt_cobrar_x_art
integer width = 2386
integer height = 284
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

type dw_report from u_dw_rpt within w_ve725_rpt_cobrar_x_art
integer y = 296
integer width = 3511
integer height = 844
integer taborder = 120
string dataobject = "d_rpt_prod_x_cobrar_x_moneda_tbl"
end type

event retrieverow;call super::retrieverow;setmicrohelp(string(row))
end event

event ue_filter;string	ls_filter

SetNull (ls_filter)
THIS.SetFilter (ls_filter)
THIS.Filter()


This.GroupCalc()
end event

type gb_2 from groupbox within w_ve725_rpt_cobrar_x_art
integer x = 2400
integer width = 699
integer height = 284
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

