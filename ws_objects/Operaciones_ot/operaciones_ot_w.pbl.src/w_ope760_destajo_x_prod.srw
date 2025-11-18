$PBExportHeader$w_ope760_destajo_x_prod.srw
forward
global type w_ope760_destajo_x_prod from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_ope760_destajo_x_prod
end type
type cb_1 from commandbutton within w_ope760_destajo_x_prod
end type
type st_1 from statictext within w_ope760_destajo_x_prod
end type
type sle_producto from singlelineedit within w_ope760_destajo_x_prod
end type
type pb_productos from picturebutton within w_ope760_destajo_x_prod
end type
type st_nombre from statictext within w_ope760_destajo_x_prod
end type
type cbx_valorizacion from checkbox within w_ope760_destajo_x_prod
end type
type cbx_productos from checkbox within w_ope760_destajo_x_prod
end type
type dw_detalle from datawindow within w_ope760_destajo_x_prod
end type
type st_2 from statictext within w_ope760_destajo_x_prod
end type
type st_3 from statictext within w_ope760_destajo_x_prod
end type
type em_bs from editmask within w_ope760_destajo_x_prod
end type
type em_sd from editmask within w_ope760_destajo_x_prod
end type
type gb_1 from groupbox within w_ope760_destajo_x_prod
end type
type gb_2 from groupbox within w_ope760_destajo_x_prod
end type
end forward

global type w_ope760_destajo_x_prod from w_report_smpl
integer width = 3579
integer height = 2156
string title = "(OPE760) Producion x Producto x Actividad"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
uo_1 uo_1
cb_1 cb_1
st_1 st_1
sle_producto sle_producto
pb_productos pb_productos
st_nombre st_nombre
cbx_valorizacion cbx_valorizacion
cbx_productos cbx_productos
dw_detalle dw_detalle
st_2 st_2
st_3 st_3
em_bs em_bs
em_sd em_sd
gb_1 gb_1
gb_2 gb_2
end type
global w_ope760_destajo_x_prod w_ope760_destajo_x_prod

on w_ope760_destajo_x_prod.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_producto=create sle_producto
this.pb_productos=create pb_productos
this.st_nombre=create st_nombre
this.cbx_valorizacion=create cbx_valorizacion
this.cbx_productos=create cbx_productos
this.dw_detalle=create dw_detalle
this.st_2=create st_2
this.st_3=create st_3
this.em_bs=create em_bs
this.em_sd=create em_sd
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_producto
this.Control[iCurrent+5]=this.pb_productos
this.Control[iCurrent+6]=this.st_nombre
this.Control[iCurrent+7]=this.cbx_valorizacion
this.Control[iCurrent+8]=this.cbx_productos
this.Control[iCurrent+9]=this.dw_detalle
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.em_bs
this.Control[iCurrent+13]=this.em_sd
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_ope760_destajo_x_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_producto)
destroy(this.pb_productos)
destroy(this.st_nombre)
destroy(this.cbx_valorizacion)
destroy(this.cbx_productos)
destroy(this.dw_detalle)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_bs)
destroy(this.em_sd)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;Decimal {2} ldc_factor_bf,ldc_factor_sd

idw_1.Visible = True

ib_preview = false
THIS.Event ue_preview()



//recupero dato de parametros
select factor_benef_social,factor_serv_destajo 
  into :ldc_factor_bf ,:ldc_factor_sd
  from prod_param where reckey = '1' ;
  
  
  
em_bs.text = String(ldc_factor_bf)
em_sd.text = String(ldc_factor_sd)

end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope760_destajo_x_prod
integer x = 37
integer y = 712
integer width = 3474
integer height = 1252
string dataobject = "d_rpt_pesaje_balanza_x_prod_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_cod_trabajador,ls_cod_prod
Date	 ld_fecha_inicio,ld_fecha_final

this.Accepttext()

choose case dwo.name
		 case 'cod_trabajador'
				ls_cod_trabajador = this.object.cod_trabajador [row]
				ls_cod_prod			= this.object.codprd 		  [row]
				
				ld_fecha_inicio = uo_1.of_get_fecha1()
				ld_fecha_final  = uo_1.of_get_fecha2()
				
				dw_detalle.Visible =  TRUE
				dw_detalle.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_prod,ls_cod_trabajador)
				
				
end choose

end event

type uo_1 from u_ingreso_rango_fechas within w_ope760_destajo_x_prod
integer x = 137
integer y = 120
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ope760_destajo_x_prod
integer x = 3145
integer y = 64
integer width = 384
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_prod,ls_mensaje
Decimal {5} ldc_ben_soc,ldc_serv_terc

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
ls_cod_prod		 = sle_producto.text	

ldc_ben_soc   = Dec(em_bs.text)
ldc_serv_terc = Dec(em_sd.text)




if ldc_ben_soc < 1 then
	Messagebox('Aviso','Factor de Beneficios Sociales debe ser Mayor o Igual a 1.00000 ')
	Return
end if	

if ldc_serv_terc < 1 then
	Messagebox('Aviso','Factor de Servicio de Terceros debe ser Mayor o Igual a 1.00000 ')
	Return
end if	

//recupera codigo de producto
if cbx_productos.checked then
	ls_cod_prod = '%'
else
	IF Isnull(ls_cod_prod) or Trim(ls_cod_prod) = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Producto ,Verifique!')
		Return
	END IF
end if	

SetPointer(hourglass!)

DECLARE PB_usp_ope_rpt_prod_x_actividad PROCEDURE FOR usp_ope_rpt_prod_x_actividad 
(:ld_fecha_inicio,:ld_fecha_final,:ls_cod_prod);
EXECUTE PB_usp_ope_rpt_prod_x_actividad ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


//asigna dw de acuerdo  a check
if cbx_valorizacion.checked then
	dw_report.dataobject = 'd_rpt_pesaje_balanza_x_prod_val_tbl'
else
	dw_report.dataobject = 'd_rpt_pesaje_balanza_x_prod_tbl'
end if


dw_report.settransobject(sqlca)
ib_preview = false
parent.Event ue_preview()
dw_report.retrieve(ld_fecha_inicio,ld_fecha_final,ldc_ben_soc,ldc_serv_terc)

//recupero ultima marcacion
ls_mensaje = f_ultima_marca_balanza(ld_fecha_final)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_ultima.text = ls_mensaje


SetPointer(Arrow!)
end event

type st_1 from statictext within w_ope760_destajo_x_prod
integer x = 73
integer y = 256
integer width = 649
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Producto - Actividad :"
boolean focusrectangle = false
end type

type sle_producto from singlelineedit within w_ope760_destajo_x_prod
integer x = 695
integer y = 256
integer width = 384
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type pb_productos from picturebutton within w_ope760_destajo_x_prod
integer x = 1097
integer y = 256
integer width = 91
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "..."
boolean originalsize = true
string picturename = "C:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;Str_seleccionar lstr_seleccionar
Datawindow		 ldw	
				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PRODUCTO_PESAJE.CODPRD AS CODIGO,'&
		      				 +'PRODUCTO_PESAJE.DESCRIPCION AS DESCRIPCION '&
			   				 +'FROM PRODUCTO_PESAJE '&


				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_producto.text = lstr_seleccionar.param1[1]
	st_nombre.text		= lstr_seleccionar.param2[1]
ELSE
	sle_producto.text = ''
	st_nombre.text		  = ''
END IF

end event

type st_nombre from statictext within w_ope760_destajo_x_prod
integer x = 1207
integer y = 256
integer width = 1426
integer height = 192
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_valorizacion from checkbox within w_ope760_destajo_x_prod
integer x = 2670
integer y = 128
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Valorizado"
end type

type cbx_productos from checkbox within w_ope760_destajo_x_prod
integer x = 2670
integer y = 256
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if cbx_productos.checked then
	sle_producto.text	 = ''
	st_nombre.text		 = ''
	sle_producto.enabled = false	
	pb_productos.enabled = false
else
	sle_producto.text	 = ''
	st_nombre.text 	 = ''
	sle_producto.enabled = true
	pb_productos.enabled = true
end if
end event

type dw_detalle from datawindow within w_ope760_destajo_x_prod
boolean visible = false
integer x = 1394
integer y = 676
integer width = 1637
integer height = 1092
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "Detalle de Pesos"
string dataobject = "d_abc_detalle_peso_x_prod_x_trab_tbl"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

type st_2 from statictext within w_ope760_destajo_x_prod
integer x = 78
integer y = 520
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Factor Beneficios Sociales :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_ope760_destajo_x_prod
integer x = 78
integer y = 612
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Factor Servicio Destajo :"
boolean focusrectangle = false
end type

type em_bs from editmask within w_ope760_destajo_x_prod
integer x = 823
integer y = 508
integer width = 270
integer height = 80
integer taborder = 40
boolean bringtotop = true
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
end type

type em_sd from editmask within w_ope760_destajo_x_prod
integer x = 823
integer y = 600
integer width = 270
integer height = 80
integer taborder = 60
boolean bringtotop = true
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
end type

type gb_1 from groupbox within w_ope760_destajo_x_prod
integer x = 46
integer width = 3067
integer height = 464
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_ope760_destajo_x_prod
integer x = 46
integer y = 476
integer width = 3067
integer height = 228
integer taborder = 150
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

