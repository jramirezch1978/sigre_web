$PBExportHeader$w_ve729_rpt_cobrar_x_art_cliente.srw
forward
global type w_ve729_rpt_cobrar_x_art_cliente from w_rpt
end type
type cbx_art from checkbox within w_ve729_rpt_cobrar_x_art_cliente
end type
type st_1 from statictext within w_ve729_rpt_cobrar_x_art_cliente
end type
type pb_1 from picturebutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type sle_cliente from singlelineedit within w_ve729_rpt_cobrar_x_art_cliente
end type
type rb_3 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type rb_2 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type rb_1 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type cbx_1 from checkbox within w_ve729_rpt_cobrar_x_art_cliente
end type
type dw_arg from datawindow within w_ve729_rpt_cobrar_x_art_cliente
end type
type cb_2 from commandbutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type dw_report from u_dw_rpt within w_ve729_rpt_cobrar_x_art_cliente
end type
type cb_1 from commandbutton within w_ve729_rpt_cobrar_x_art_cliente
end type
type gb_1 from groupbox within w_ve729_rpt_cobrar_x_art_cliente
end type
type gb_2 from groupbox within w_ve729_rpt_cobrar_x_art_cliente
end type
end forward

global type w_ve729_rpt_cobrar_x_art_cliente from w_rpt
integer width = 3589
integer height = 1452
string title = "[VE729] Reporte de Ventas de Productos"
string menuname = "m_reporte"
long backcolor = 12632256
cbx_art cbx_art
st_1 st_1
pb_1 pb_1
sle_cliente sle_cliente
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cbx_1 cbx_1
dw_arg dw_arg
cb_2 cb_2
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_ve729_rpt_cobrar_x_art_cliente w_ve729_rpt_cobrar_x_art_cliente

type variables
str_seleccionar istr_seleccionar
end variables

on w_ve729_rpt_cobrar_x_art_cliente.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_art=create cbx_art
this.st_1=create st_1
this.pb_1=create pb_1
this.sle_cliente=create sle_cliente
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_1=create cbx_1
this.dw_arg=create dw_arg
this.cb_2=create cb_2
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_art
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.sle_cliente
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.dw_arg
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_ve729_rpt_cobrar_x_art_cliente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_art)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.sle_cliente)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_1)
destroy(this.dw_arg)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
//
//
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type cbx_art from checkbox within w_ve729_rpt_cobrar_x_art_cliente
integer x = 1234
integer y = 164
integer width = 585
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Articulos"
end type

event clicked;
if this.checked = false then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if	
end event

type st_1 from statictext within w_ve729_rpt_cobrar_x_art_cliente
integer x = 1225
integer y = 268
integer width = 183
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente: "
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 1838
integer y = 256
integer width = 114
integer height = 84
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;Str_seleccionar lstr_seleccionar
Datawindow		 ldw	
				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR  AS CLIENTE ,'&
		      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
								 +'PROVEEDOR.RUC AS NUMERO_DE_RUC '&
			   				 +'FROM PROVEEDOR '

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cliente.text = lstr_seleccionar.param1[1]
ELSE
	sle_cliente.text = ''
END IF

end event

type sle_cliente from singlelineedit within w_ve729_rpt_cobrar_x_art_cliente
integer x = 1413
integer y = 256
integer width = 384
integer height = 84
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 2235
integer y = 252
integer width = 357
integer height = 72
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambos tipos "
end type

type rb_2 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 2235
integer y = 176
integer width = 343
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dolares"
end type

type rb_1 from radiobutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 2235
integer y = 104
integer width = 343
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
end type

type cbx_1 from checkbox within w_ve729_rpt_cobrar_x_art_cliente
integer x = 1234
integer y = 92
integer width = 539
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
end type

type dw_arg from datawindow within w_ve729_rpt_cobrar_x_art_cliente
integer x = 69
integer y = 108
integer width = 951
integer height = 272
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_origen_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE


end event

type cb_2 from commandbutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 3049
integer y = 40
integer width = 471
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Articulos"
end type

event clicked;Long ll_count
str_parametros sl_param 


Rollback ;

sl_param.dw1		= 'd_rpt_art_temp_tbl'
sl_param.titulo	= 'Articulos'
sl_param.opcion   = 14
sl_param.db1 		= 1600
sl_param.string1 	= '1ART'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type dw_report from u_dw_rpt within w_ve729_rpt_cobrar_x_art_cliente
integer x = 23
integer y = 408
integer width = 3511
integer height = 844
integer taborder = 120
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieverow;call super::retrieverow;setmicrohelp(string(row))
end event

event ue_filter;string	ls_filter

SetNull (ls_filter)
THIS.SetFilter (ls_filter)
THIS.Filter()


This.GroupCalc()
end event

type cb_1 from commandbutton within w_ve729_rpt_cobrar_x_art_cliente
integer x = 3049
integer y = 164
integer width = 471
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_origen, ls_soles, ls_dolares, ls_cod_moneda, ls_cliente


SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares  
  FROM logparam
 WHERE (reckey = '1' );


dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]
ls_cod_origen   = dw_arg.object.cod_origen	   [1]

ls_cliente = sle_cliente.text

IF rb_1.checked = FALSE and rb_2.checked = FALSE and rb_3.checked = FALSE THEN
	messagebox('Advertencia','Debe Seleccionar un tipo de Moneda')
	Return
END IF


IF cbx_1.CHECKED THEN
	ls_cod_origen = '%'
ELSE
	IF Isnull(ls_cod_origen) OR Trim(ls_cod_origen) = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Origen , Verifique!')
		Return
	ELSE
		ls_cod_origen = ls_cod_origen+'%'
	END IF
END IF


// Selecciona dw x tipo de Moneda
IF rb_1.checked = TRUE  THEN
	ls_cod_moneda = ls_soles
	dw_report.DataObject = 'd_rpt_prod_x_cobrar_x_moneda_cliente_tbl'
ELSEIF rb_2.checked = TRUE  THEN
   ls_cod_moneda = ls_dolares
	dw_report.DataObject = 'd_rpt_prod_x_cobrar_x_moneda_cliente_tbl'
ELSEIF rb_3.checked = TRUE  THEN
	dw_report.DataObject = 'd_rpt_cntas_cobrar_art_cliente_tbl'
END IF


idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
Parent.Event ue_preview()


/*se llena tabla temporal de articulos en caso escogan todos*/
if cbx_art.checked then
	//elimina informacion
	delete from tt_fin_rpt_art ;
	
	Insert Into tt_fin_rpt_art
	(cod_art)  
	select av.cod_art
	  from articulo_venta   av  ,articulo art,
	       cntas_cobrar_det ccd
	 where (art.cod_art = av.cod_art ) and  
	       (ccd.cod_art = av.cod_art )   
	group by av.cod_art ;
	
end if	




IF rb_3.checked = TRUE  THEN
	dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_origen,gs_empresa,gs_user,ls_soles,ls_dolares,ls_cliente)
ELSE
	dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_origen,gs_empresa,gs_user,ls_cod_moneda,ls_cliente)
END IF

dw_report.Object.p_logo.filename = gs_logo

end event

type gb_1 from groupbox within w_ve729_rpt_cobrar_x_art_cliente
integer x = 37
integer y = 32
integer width = 2130
integer height = 364
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

type gb_2 from groupbox within w_ve729_rpt_cobrar_x_art_cliente
integer x = 2185
integer y = 28
integer width = 480
integer height = 368
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Moneda"
end type

