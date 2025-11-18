$PBExportHeader$w_ve710_ventas_general.srw
forward
global type w_ve710_ventas_general from w_report_smpl
end type
type cb_aceptar from commandbutton within w_ve710_ventas_general
end type
type uo_1 from u_ingreso_rango_fechas within w_ve710_ventas_general
end type
type rb_resumen from radiobutton within w_ve710_ventas_general
end type
type rb_detalle from radiobutton within w_ve710_ventas_general
end type
type cb_barra from commandbutton within w_ve710_ventas_general
end type
type dw_canal from datawindow within w_ve710_ventas_general
end type
type dw_distrito from datawindow within w_ve710_ventas_general
end type
type dw_cliente from datawindow within w_ve710_ventas_general
end type
type st_etiqueta from statictext within w_ve710_ventas_general
end type
type dw_zona from datawindow within w_ve710_ventas_general
end type
type dw_sub_canal from datawindow within w_ve710_ventas_general
end type
type gb_1 from groupbox within w_ve710_ventas_general
end type
type gb_4 from groupbox within w_ve710_ventas_general
end type
type gb_3 from groupbox within w_ve710_ventas_general
end type
type rb_cantidad from radiobutton within w_ve710_ventas_general
end type
type rb_importe from radiobutton within w_ve710_ventas_general
end type
type rb_importe_dol from radiobutton within w_ve710_ventas_general
end type
end forward

global type w_ve710_ventas_general from w_report_smpl
integer width = 3694
integer height = 1488
string title = "[VE710] Ventas Generales"
string menuname = "m_reporte"
long backcolor = 67108864
cb_aceptar cb_aceptar
uo_1 uo_1
rb_resumen rb_resumen
rb_detalle rb_detalle
cb_barra cb_barra
dw_canal dw_canal
dw_distrito dw_distrito
dw_cliente dw_cliente
st_etiqueta st_etiqueta
dw_zona dw_zona
dw_sub_canal dw_sub_canal
gb_1 gb_1
gb_4 gb_4
gb_3 gb_3
rb_cantidad rb_cantidad
rb_importe rb_importe
rb_importe_dol rb_importe_dol
end type
global w_ve710_ventas_general w_ve710_ventas_general

type variables
string is_canal, is_sub_canal, is_zona, is_distrito, is_desc_distrito, &
		 is_pais, is_dpto, is_prov, is_flag_opc, is_desc_opc, is_categ, is_serie
date id_fec_ini, id_fec_fin
end variables

on w_ve710_ventas_general.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.rb_resumen=create rb_resumen
this.rb_detalle=create rb_detalle
this.cb_barra=create cb_barra
this.dw_canal=create dw_canal
this.dw_distrito=create dw_distrito
this.dw_cliente=create dw_cliente
this.st_etiqueta=create st_etiqueta
this.dw_zona=create dw_zona
this.dw_sub_canal=create dw_sub_canal
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_3=create gb_3
this.rb_cantidad=create rb_cantidad
this.rb_importe=create rb_importe
this.rb_importe_dol=create rb_importe_dol
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_resumen
this.Control[iCurrent+4]=this.rb_detalle
this.Control[iCurrent+5]=this.cb_barra
this.Control[iCurrent+6]=this.dw_canal
this.Control[iCurrent+7]=this.dw_distrito
this.Control[iCurrent+8]=this.dw_cliente
this.Control[iCurrent+9]=this.st_etiqueta
this.Control[iCurrent+10]=this.dw_zona
this.Control[iCurrent+11]=this.dw_sub_canal
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_4
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.rb_cantidad
this.Control[iCurrent+16]=this.rb_importe
this.Control[iCurrent+17]=this.rb_importe_dol
end on

on w_ve710_ventas_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.uo_1)
destroy(this.rb_resumen)
destroy(this.rb_detalle)
destroy(this.cb_barra)
destroy(this.dw_canal)
destroy(this.dw_distrito)
destroy(this.dw_cliente)
destroy(this.st_etiqueta)
destroy(this.dw_zona)
destroy(this.dw_sub_canal)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.rb_cantidad)
destroy(this.rb_importe)
destroy(this.rb_importe_dol)
end on

event resize;call super::resize;cb_barra.height = newheight - cb_barra.y - 32

//Grafico Principal CANAL
dw_canal.width = ( dw_report.width / 2 )
dw_canal.height = ( dw_report.height / 3 ) * 2

//Grafico Detalle SUB - CANAL
dw_sub_canal.x 	  = ( dw_canal.x + dw_canal.width ) + 10
dw_sub_canal.width  = ( dw_report.width / 2 ) - 10
dw_sub_canal.height = ( dw_report.height / 3 )

//Grafico Detalle VENDEDOR
dw_zona.y		  = ( dw_sub_canal.y + dw_sub_canal.height )
dw_zona.x		  = ( dw_canal.x + dw_canal.width ) + 10
dw_zona.width	  = ( dw_report.width / 2 ) - 10
dw_zona.height  = ( dw_report.height / 3 )

//Grafico Detalle DISTRITO
dw_distrito.y		  = ( dw_zona.y + dw_zona.height )
dw_distrito.x		  = ( dw_canal.x + dw_canal.width ) + 10
dw_distrito.width	  = ( dw_report.width / 2 ) - 10
dw_distrito.height  = ( dw_report.height / 3 )

//Graficos Detalle CLIENTE
dw_cliente.y		  = ( dw_canal.y + dw_canal.height )
dw_cliente.width	  = ( dw_report.width / 2 )
dw_cliente.height   = ( dw_report.height / 3 )
end event

event ue_retrieve;call super::ue_retrieve;date ld_fec_ini, ld_fec_fin

id_fec_ini = uo_1.of_get_fecha1( )
id_fec_fin = uo_1.of_get_fecha2( )

setpointer(hourglass!)

if rb_importe.checked = true then //importe soles
	is_flag_opc = 'S'
	is_desc_opc = 'Importe [S/.]'
elseif rb_cantidad.checked = true then //cantidad ton
	is_flag_opc = 'C'
	is_desc_opc = 'Cantidad [TON]'
else //importe dolares
	is_flag_opc = 'D'
	is_desc_opc = 'Importe [$]'
end if

declare usp_proc procedure for USP_VE_RPT_VENTAS_GENERALES( :id_fec_ini, :id_fec_fin );
execute usp_proc;

if sqlca.sqlcode = -1 then
	messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
	rollback;
	return
end if

if rb_resumen.checked = false then
	dw_report.dataobject = 'd_rpt_ventas_general'
else
	dw_report.dataobject = 'd_rpt_ventas_general_res'
end if

dw_report.settransobject( sqlca )
dw_report.retrieve( id_fec_ini, id_fec_fin, gs_empresa, gs_user )
dw_report.object.p_logo.filename = gs_logo

dw_canal.settransobject( sqlca )
dw_canal.retrieve( is_flag_opc )
dw_canal.object.gr_1.Values.Label = is_desc_opc

dw_sub_canal.settransobject( sqlca )
dw_zona.settransobject( sqlca )
dw_distrito.settransobject( sqlca )
dw_cliente.settransobject( sqlca )

dw_distrito.reset( )
dw_cliente.reset( )

ib_preview = false
this.event ue_preview()

if cb_barra.text = '<<' then
	cb_barra.triggerevent(Clicked!)
end if

setpointer(arrow!)
end event

event close;call super::close;commit;

end event

type dw_report from w_report_smpl`dw_report within w_ve710_ventas_general
integer x = 183
integer y = 256
integer width = 3406
integer height = 964
string dataobject = "d_rpt_ventas_general"
integer ii_zoom_actual = 100
end type

type cb_aceptar from commandbutton within w_ve710_ventas_general
integer x = 3255
integer y = 128
integer width = 334
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_1 from u_ingreso_rango_fechas within w_ve710_ventas_general
event destroy ( )
integer x = 64
integer y = 100
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type rb_resumen from radiobutton within w_ve710_ventas_general
integer x = 2647
integer y = 124
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Resumen"
boolean checked = true
end type

type rb_detalle from radiobutton within w_ve710_ventas_general
integer x = 2953
integer y = 124
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Detalle"
end type

type cb_barra from commandbutton within w_ve710_ventas_general
integer x = 37
integer y = 256
integer width = 114
integer height = 964
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;if this.text = '>>' then
	
	dw_canal.visible		= true
	dw_sub_canal.visible	= true
	dw_zona.visible	= true
	dw_distrito.visible	= true
	dw_cliente.visible	= true
	
	dw_report.visible = false
	
	this.text = '<<'
	
else
	
	dw_canal.visible		= false
	dw_sub_canal.visible	= false
	dw_zona.visible	= false
	dw_distrito.visible	= false
	dw_cliente.visible	= false
	
	dw_report.visible = true
	
	this.text = '>>'
	
end if
end event

type dw_canal from datawindow within w_ve710_ventas_general
event ue_graphcreate pbm_dwngraphcreate
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 183
integer y = 256
integer width = 1783
integer height = 640
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_rpt_graf_ventas_canal"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_graphcreate;//this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',LineColor!, 255)
//this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',ForeGround!, 255)
//this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',Continuous!, 1)
//this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',Symbolx!)
//
//this.SetSeriesStyle("gr_1",'PRECIO VENTA',LineColor!, 16711680)
//this.SetSeriesStyle("gr_1",'PRECIO VENTA',ForeGround!, 16711680)
//this.SetSeriesStyle("gr_1",'PRECIO VENTA',Continuous!, 1)
//this.SetSeriesStyle("gr_1",'PRECIO VENTA',Symbolx!)
end event

event ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	ls_mensaje = trim(ls_cantidad) + ' ( '+trim(ls_serie)+' )'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
	
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

event constructor;settransobject(sqlca)
end event

event clicked;Integer li_Series, li_Category
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_Category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	is_canal = trim(this.CategoryName('gr_1', li_Category))

	dw_sub_canal.retrieve( is_canal, is_flag_opc )
	dw_sub_canal.object.gr_1.Values.Label = is_desc_opc
	dw_zona.reset( )
	dw_distrito.reset( )
	dw_cliente.reset( )
	
end if
end event

event doubleclicked;string ls_parametros[9]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_canal
ls_parametros[2] = is_sub_canal
ls_parametros[3] = is_zona
ls_parametros[4] = is_flag_opc
ls_parametros[5] = is_desc_opc
ls_parametros[6] = is_pais
ls_parametros[7] = is_dpto
ls_parametros[8] = is_prov
ls_parametros[9] = is_distrito

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'CA'

opensheetwithparm(w_ve710_ventas_general_det,lstr_parametros,parent,1,Layered!)
end event

type dw_distrito from datawindow within w_ve710_ventas_general
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 908
integer width = 1605
integer height = 312
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_ventas_distrito"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
			
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

event clicked;Integer li_Series, li_Category
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_Category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	is_distrito      = this.CategoryName('gr_1', li_Category)
	is_desc_distrito = this.SeriesName('gr_1', li_Series)
/*
	select cod_pais, cod_dpto, cod_prov
	  into :is_pais, :is_dpto, :is_prov
	  from distrito
	 where trim(cod_distr) = trim(:is_distrito)
	   and trim(desc_distrito) = trim(:is_desc_distrito);
	
	if isnull(is_pais) or isnull(is_dpto) or isnull(is_prov) then
		is_pais = 'S/Pa' ; is_dpto = 'S/Dp' ; is_prov = 'S/Pr'
	end if
	
	if is_pais = '' or is_dpto = '' or is_prov = '' then
		is_pais = 'S/Pa' ; is_dpto = 'S/Dp' ; is_prov = 'S/Pr'
	end if
	
	declare usp_proc procedure for USP_VE_RPT_VENTAS_DISTR_X_CLI( :id_fec_ini, :id_fec_fin, :is_canal, :is_sub_canal, :is_zona, :is_flag_opc, :is_pais, :is_dpto, :is_prov, :is_distrito );
	execute usp_proc;
	
	if sqlca.sqlcode = -1 then
		messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
		rollback;
		return
	end if
*/
	dw_cliente.retrieve( is_canal, is_sub_canal, is_zona, is_distrito, is_desc_distrito, is_flag_opc)
	dw_cliente.object.gr_1.Values.Label = is_desc_opc
	
end if
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;string ls_parametros[9]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_canal
ls_parametros[2] = is_sub_canal
ls_parametros[3] = is_zona
ls_parametros[4] = is_flag_opc
ls_parametros[5] = is_desc_opc
ls_parametros[6] = is_distrito
ls_parametros[7] = is_desc_distrito

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'DI'

opensheetwithparm(w_ve710_ventas_general_det,lstr_parametros,parent,1,Layered!)
end event

type dw_cliente from datawindow within w_ve710_ventas_general
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 183
integer y = 908
integer width = 1783
integer height = 312
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_ventas_cliente"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad, ls_nombre

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	
	select nom_proveedor
	  into :ls_nombre
	  from proveedor
	 where trim(proveedor) = :ls_categ;
	
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_categ)+' - '+trim(ls_nombre)+' )'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
			
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	
END IF
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;string ls_parametros[9]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_canal
ls_parametros[2] = is_sub_canal
ls_parametros[3] = is_zona
ls_parametros[4] = is_flag_opc
ls_parametros[5] = is_desc_opc
ls_parametros[6] = is_distrito
ls_parametros[7] = is_desc_distrito

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'CL'

opensheetwithparm(w_ve710_ventas_general_det,lstr_parametros,parent,1,Layered!)
end event

type st_etiqueta from statictext within w_ve710_ventas_general
boolean visible = false
integer x = 3255
integer y = 32
integer width = 334
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_zona from datawindow within w_ve710_ventas_general
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 580
integer width = 1605
integer height = 320
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_ventas_zona"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
			
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

event constructor;settransobject( sqlca )
end event

event clicked;Integer li_Series, li_Category
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_Category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	is_zona = this.CategoryName('gr_1', li_Category)
	
/*	declare usp_proc procedure for USP_VE_RPT_VENTAS_X_DISTRITOS( :id_fec_ini, :id_fec_fin, :is_canal, :is_sub_canal, :is_zona, :is_flag_opc);
	execute usp_proc;
	
	if sqlca.sqlcode = -1 then
		messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
		rollback;
		return
	end if
*/
	dw_distrito.retrieve( is_canal, is_sub_canal, is_zona, is_flag_opc )
	dw_distrito.object.gr_1.Values.Label = is_desc_opc
	dw_cliente.reset( )
	
end if
end event

event doubleclicked;string ls_parametros[9]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_canal
ls_parametros[2] = is_sub_canal
ls_parametros[3] = is_zona
ls_parametros[4] = is_flag_opc
ls_parametros[5] = is_desc_opc
ls_parametros[6] = is_pais
ls_parametros[7] = is_dpto
ls_parametros[8] = is_prov
ls_parametros[9] = is_distrito

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'ZO'

opensheetwithparm(w_ve710_ventas_general_det,lstr_parametros,parent,1,Layered!)
end event

type dw_sub_canal from datawindow within w_ve710_ventas_general
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 256
integer width = 1605
integer height = 320
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_ventas_sub_canal"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
		
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

event constructor;settransobject( sqlca )
end event

event clicked;Integer li_Series, li_Category
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_Category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	is_sub_canal = this.CategoryName('gr_1', li_Category)
	
	dw_zona.retrieve( is_canal , is_sub_canal, is_flag_opc )
	dw_zona.object.gr_1.Values.Label = is_desc_opc
	dw_distrito.reset( )
	dw_cliente.reset( )
	
end if
end event

event doubleclicked;string ls_parametros[9]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_canal
ls_parametros[2] = is_sub_canal
ls_parametros[3] = is_zona
ls_parametros[4] = is_flag_opc
ls_parametros[5] = is_desc_opc
ls_parametros[6] = is_pais
ls_parametros[7] = is_dpto
ls_parametros[8] = is_prov
ls_parametros[9] = is_distrito

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'SC'

opensheetwithparm(w_ve710_ventas_general_det,lstr_parametros,parent,1,Layered!)
end event

type gb_1 from groupbox within w_ve710_ventas_general
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_4 from groupbox within w_ve710_ventas_general
integer x = 2633
integer y = 32
integer width = 590
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opc. Reporte"
end type

type gb_3 from groupbox within w_ve710_ventas_general
integer x = 1426
integer y = 32
integer width = 1175
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opc. Grafico"
end type

type rb_cantidad from radiobutton within w_ve710_ventas_general
integer x = 1440
integer y = 124
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cantidad [TON]"
boolean checked = true
end type

type rb_importe from radiobutton within w_ve710_ventas_general
integer x = 1865
integer y = 124
integer width = 352
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Importe [S/.]"
end type

type rb_importe_dol from radiobutton within w_ve710_ventas_general
integer x = 2240
integer y = 124
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Importe [$]"
end type

