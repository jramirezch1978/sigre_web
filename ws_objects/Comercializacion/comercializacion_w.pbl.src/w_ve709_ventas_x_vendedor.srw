$PBExportHeader$w_ve709_ventas_x_vendedor.srw
forward
global type w_ve709_ventas_x_vendedor from w_report_smpl
end type
type cb_aceptar from commandbutton within w_ve709_ventas_x_vendedor
end type
type uo_1 from u_ingreso_rango_fechas within w_ve709_ventas_x_vendedor
end type
type rb_resumen from radiobutton within w_ve709_ventas_x_vendedor
end type
type rb_detalle from radiobutton within w_ve709_ventas_x_vendedor
end type
type cb_barra from commandbutton within w_ve709_ventas_x_vendedor
end type
type dw_canal from datawindow within w_ve709_ventas_x_vendedor
end type
type dw_vendedor from datawindow within w_ve709_ventas_x_vendedor
end type
type dw_cliente from datawindow within w_ve709_ventas_x_vendedor
end type
type st_etiqueta from statictext within w_ve709_ventas_x_vendedor
end type
type dw_zona from datawindow within w_ve709_ventas_x_vendedor
end type
type dw_sub_canal from datawindow within w_ve709_ventas_x_vendedor
end type
type gb_1 from groupbox within w_ve709_ventas_x_vendedor
end type
type gb_4 from groupbox within w_ve709_ventas_x_vendedor
end type
end forward

global type w_ve709_ventas_x_vendedor from w_report_smpl
integer width = 3694
integer height = 2304
string title = "[VE709] Detalle de Ventas por Vendedor"
string menuname = "m_reporte"
cb_aceptar cb_aceptar
uo_1 uo_1
rb_resumen rb_resumen
rb_detalle rb_detalle
cb_barra cb_barra
dw_canal dw_canal
dw_vendedor dw_vendedor
dw_cliente dw_cliente
st_etiqueta st_etiqueta
dw_zona dw_zona
dw_sub_canal dw_sub_canal
gb_1 gb_1
gb_4 gb_4
end type
global w_ve709_ventas_x_vendedor w_ve709_ventas_x_vendedor

type variables
string is_canal, is_sub_canal, is_zona, is_flag_opc, is_desc_opc, is_categ, is_serie, &
		 is_vendedor
date id_fec_ini, id_fec_fin
end variables

on w_ve709_ventas_x_vendedor.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.rb_resumen=create rb_resumen
this.rb_detalle=create rb_detalle
this.cb_barra=create cb_barra
this.dw_canal=create dw_canal
this.dw_vendedor=create dw_vendedor
this.dw_cliente=create dw_cliente
this.st_etiqueta=create st_etiqueta
this.dw_zona=create dw_zona
this.dw_sub_canal=create dw_sub_canal
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_resumen
this.Control[iCurrent+4]=this.rb_detalle
this.Control[iCurrent+5]=this.cb_barra
this.Control[iCurrent+6]=this.dw_canal
this.Control[iCurrent+7]=this.dw_vendedor
this.Control[iCurrent+8]=this.dw_cliente
this.Control[iCurrent+9]=this.st_etiqueta
this.Control[iCurrent+10]=this.dw_zona
this.Control[iCurrent+11]=this.dw_sub_canal
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_4
end on

on w_ve709_ventas_x_vendedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.uo_1)
destroy(this.rb_resumen)
destroy(this.rb_detalle)
destroy(this.cb_barra)
destroy(this.dw_canal)
destroy(this.dw_vendedor)
destroy(this.dw_cliente)
destroy(this.st_etiqueta)
destroy(this.dw_zona)
destroy(this.dw_sub_canal)
destroy(this.gb_1)
destroy(this.gb_4)
end on

event resize;call super::resize;cb_barra.height = newheight - cb_barra.y - 32

//Grafico Principal VENDEDOR
dw_vendedor.width = ( dw_report.width / 2 )
dw_vendedor.height = ( dw_report.height / 3 ) * 2

//Grafico Detalle CANAL
dw_canal.x 	    = ( dw_vendedor.x + dw_vendedor.width ) + 10
dw_canal.width  = ( dw_report.width / 2 ) - 10
dw_canal.height = ( dw_report.height / 3 )

//Grafico Detalle SUB - CANAL
dw_sub_canal.y		  = ( dw_canal.y + dw_canal.height )
dw_sub_canal.x		  = ( dw_vendedor.x + dw_vendedor.width ) + 10
dw_sub_canal.width  = ( dw_report.width / 2 ) - 10
dw_sub_canal.height = ( dw_report.height / 3 )

//Grafico Detalle DISTRITO
dw_zona.y		  = ( dw_sub_canal.y + dw_sub_canal.height )
dw_zona.x		  = ( dw_vendedor.x + dw_vendedor.width ) + 10
dw_zona.width	  = ( dw_report.width / 2 ) - 10
dw_zona.height   = ( dw_report.height / 3 )

//Graficos Detalle CLIENTE
dw_cliente.y		  = ( dw_vendedor.y + dw_vendedor.height )
dw_cliente.width	  = ( dw_report.width / 2 )
dw_cliente.height   = ( dw_report.height / 3 )
end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2

ld_fecha1 = uo_1.of_get_fecha1( )
ld_fecha2 = uo_1.of_get_fecha2( )


if rb_resumen.checked = false then
	dw_report.dataobject = 'd_rpt_ventas_x_vendedor_tbl'
else
	dw_report.dataobject = 'd_rpt_ventas_x_vendedor_res_tbl'
end if

ib_preview = false
event ue_preview()

dw_report.settransobject( sqlca )
dw_report.retrieve( ld_fecha1, ld_fecha2 )

dw_report.object.t_fechas.text   = 'Del: ' + string( ld_fecha1,'dd/mm/yyyy') + ' Al: ' + string( ld_fecha2,'dd/mm/yyyy')
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text   	= gs_user
//dw_report.object.t_ventana.text 	= parent.classname( )


//if cb_barra.text = '<<' then
//	cb_barra.triggerevent(Clicked!)
//end if
end event

type dw_report from w_report_smpl`dw_report within w_ve709_ventas_x_vendedor
integer x = 123
integer y = 200
integer width = 3406
integer height = 964
string dataobject = "d_rpt_ventas_x_vendedor_tbl"
integer ii_zoom_actual = 100
end type

type cb_aceptar from commandbutton within w_ve709_ventas_x_vendedor
integer x = 1984
integer width = 352
integer height = 196
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

type uo_1 from u_ingreso_rango_fechas within w_ve709_ventas_x_vendedor
event destroy ( )
integer x = 27
integer y = 68
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

type rb_resumen from radiobutton within w_ve709_ventas_x_vendedor
integer x = 1390
integer y = 92
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

type rb_detalle from radiobutton within w_ve709_ventas_x_vendedor
integer x = 1696
integer y = 92
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

type cb_barra from commandbutton within w_ve709_ventas_x_vendedor
integer y = 200
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
	
	dw_vendedor.visible	= true
	dw_canal.visible		= true
	dw_sub_canal.visible	= true
	dw_zona.visible	   = true
	dw_cliente.visible	= true
	
	dw_report.visible = false
	
	this.text = '<<'
	
else

	dw_vendedor.visible	= false
	dw_canal.visible		= false
	dw_sub_canal.visible	= false
	dw_zona.visible	   = false
	dw_cliente.visible	= false
	
	dw_report.visible = true
	
	this.text = '>>'
	
end if
end event

type dw_canal from datawindow within w_ve709_ventas_x_vendedor
event ue_graphcreate pbm_dwngraphcreate
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 256
integer width = 1605
integer height = 320
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_rpt_graf_vendedor_canal_cantidad"
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
	
	if ls_categ <> is_categ then
		
		is_categ = ls_categ
	
		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		
		select descripcion 
		  into :ls_serie
		  from canal_distribucion
		 where trim(canal) = trim(:ls_categ);
		
		if isnull(ls_serie) or ls_serie = '' then
			ls_serie = 'S/Canal'
		end if
		
		ls_mensaje = trim(ls_cantidad) + ' ( '+trim(ls_serie)+' )'
		
		st_etiqueta.BringToTop = TRUE 
		
		st_etiqueta.text = ls_mensaje 
		
		st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
		
	end if
	
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
	
	is_canal = this.CategoryName('gr_1', li_Category)

	dw_sub_canal.retrieve( id_fec_ini, id_fec_fin, is_Vendedor, is_canal )
	dw_zona.reset( )
	dw_cliente.reset( )
	
end if
end event

event doubleclicked;string ls_parametros[4]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_vendedor
ls_parametros[2] = is_canal
ls_parametros[3] = is_sub_canal
ls_parametros[4] = is_zona

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'CA'

opensheetwithparm(w_ve709_ventas_x_vendedor_det,lstr_parametros,parent,1,Layered!)
end event

type dw_vendedor from datawindow within w_ve709_ventas_x_vendedor
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 183
integer y = 256
integer width = 1797
integer height = 648
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_vendedor_vendedor_cantidad"
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
	
	if ls_categ <> is_categ then
		
		is_categ = ls_Categ
	
		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		
		select nvl(nombre,'S/V')
		  into :ls_serie
		  from usuario
		 where trim(cod_usr) = trim(:ls_Categ);
		
		if isnull(ls_serie) or ls_serie = '' then
			ls_serie = 'S/Vendedor'
		end if
		
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
		
		st_etiqueta.BringToTop = TRUE 
		
		st_etiqueta.text = ls_mensaje 
		
		st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
		
	end if
	
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
	
	is_vendedor = this.CategoryName('gr_1', li_Category)
	
	dw_canal.retrieve( id_fec_ini, id_fec_fin, is_vendedor )
	
	dw_sub_canal.reset( )
	dw_zona.reset( )
	dw_cliente.reset( )
		
end if
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;string ls_parametros[4]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_vendedor
ls_parametros[2] = is_canal
ls_parametros[3] = is_sub_canal
ls_parametros[4] = is_zona

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'VE'

opensheetwithparm(w_ve709_ventas_x_vendedor_det,lstr_parametros,parent,1,Layered!)
end event

type dw_cliente from datawindow within w_ve709_ventas_x_vendedor
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 183
integer y = 908
integer width = 1797
integer height = 312
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_vendedor_cliente_cantidad"
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
	
	if ls_categ <> is_categ then
		
		is_Categ = ls_categ
	
		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		
		select nom_proveedor
		  into :ls_nombre
		  from proveedor
		 where trim(proveedor) = :ls_categ;
		
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_categ)+' - '+trim(ls_nombre)+' )'
		st_etiqueta.BringToTop = TRUE 
		st_etiqueta.text = ls_mensaje 
		
		st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
		
	end if
	
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
			
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	
END IF
end event

event clicked;//if row = 0 then return
//
//st_espere.bringtotop = true
//st_espere.visible = true
//setpointer(HourGlass!)
//
//date ld_fec_ini, ld_fec_fin
//decimal{2} ldc_mayor, ldc_menor
//
//ld_fec_ini = date(uo_1.of_get_fecha1())
//ld_fec_fin = date(uo_1.of_get_fecha2())
//
////is_cliente = this.object.comprador_final[row]
//
////if trim(is_cliente) = 'TODOS' then 
////	is_cliente = '%'
////end if
//
////llena la tabla temporal para el grafico
////declare usp_proc procedure for USP_VE_RPT_ESTRUCT_COSTO(:ld_fec_ini, :ld_fec_fin, :is_articulo, :is_flag, :is_cliente, :is_flag_canal);
////execute usp_proc;
//
//if sqlca.sqlcode = -1 then
//	Messagebox('Aviso',string(sqlca.sqlcode)+ ' ' + string(sqlca.sqlerrtext) )
//	rollback;
//	st_espere.bringtotop = false
//	st_espere.visible = false
//	setpointer(Arrow!)
//	return
//end if
//
////dw_grafico.retrieve( is_estados[] )
//dw_grafico.event ue_graphcreate()
//
////MOdificando escala del grafico
//select max(valor)
//  into :ldc_mayor
//  from tt_ve_graf_asignacion_costo;
//
//select min(valor)
//  into :ldc_menor
//  from tt_ve_graf_asignacion_costo;
//  
//dw_grafico.object.gr_1.Values.autoscale = 0
//
//dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)
//
//if integer(ldc_menor - 1) < 0 then
//	dw_grafico.object.gr_1.Values.MinimumValue = 0
//else
//	dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
//end if
//
//st_espere.bringtotop = false
//st_espere.visible = false
//setpointer(Arrow!)
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;string ls_parametros[4]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_vendedor
ls_parametros[2] = is_canal
ls_parametros[3] = is_sub_canal
ls_parametros[4] = is_zona

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'CL'

opensheetwithparm(w_ve709_ventas_x_vendedor_det,lstr_parametros,parent,1,Layered!)
end event

type st_etiqueta from statictext within w_ve709_ventas_x_vendedor
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

type dw_zona from datawindow within w_ve709_ventas_x_vendedor
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 900
integer width = 1605
integer height = 320
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_vendedor_zona_cantidad"
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
	
	if ls_categ <> is_categ then
		
		is_categ = ls_categ
	
		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		
		select descripcion
		  into :ls_serie
		  from zona_comercial
		 where trim(zona_com) = trim(:ls_categ);
		 
		if isnull(ls_serie) or ls_serie = '' then
			ls_serie = 'S/Zona'
		end if
		
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
		
		st_etiqueta.BringToTop = TRUE 
		
		st_etiqueta.text = ls_mensaje 
		
		st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
		
	end if
	
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
	
	dw_cliente.retrieve( id_fec_ini, id_fec_fin, is_vendedor, is_canal, is_sub_canal , is_zona)
	
end if
end event

event doubleclicked;string ls_parametros[4]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_vendedor
ls_parametros[2] = is_canal
ls_parametros[3] = is_sub_canal
ls_parametros[4] = is_zona

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'ZO'

opensheetwithparm(w_ve709_ventas_x_vendedor_det,lstr_parametros,parent,1,Layered!)
end event

type dw_sub_canal from datawindow within w_ve709_ventas_x_vendedor
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 1984
integer y = 580
integer width = 1605
integer height = 320
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_graf_vendedor_subcanal_cantidad"
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
	
	if ls_categ <> is_categ then
		
		is_categ = ls_categ
	
		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		
		select descripcion 
		  into :ls_serie
		  from canal_distribucion_det
		 where trim(canal) = trim(:is_canal)
			and trim(sub_canal) = trim(:ls_categ);
		
		if ls_serie = '' or isnull(ls_serie) then
			ls_serie = 'S/Sub Canal'
		end if
		
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' )'
		
		st_etiqueta.BringToTop = TRUE 
		
		st_etiqueta.text = ls_mensaje 
		
		st_etiqueta.width = len(trim(st_etiqueta.text)) * 30
		
	end if
	
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
	
	dw_zona.retrieve( id_fec_ini, id_fec_fin, is_vendedor, is_canal , is_sub_canal )
	dw_cliente.reset( )
	
end if
end event

event doubleclicked;string ls_parametros[4]
str_parametros lstr_parametros

lstr_parametros.fecha1  = id_fec_ini
lstr_parametros.fecha2  = id_fec_fin

ls_parametros[1] = is_vendedor
ls_parametros[2] = is_canal
ls_parametros[3] = is_sub_canal
ls_parametros[4] = is_zona

lstr_parametros.str_array[] = ls_parametros[]

lstr_parametros.dw_master	= this.dataobject
lstr_parametros.tipo			= 'SC'

opensheetwithparm(w_ve709_ventas_x_vendedor_det,lstr_parametros,parent,1,Layered!)
end event

type gb_1 from groupbox within w_ve709_ventas_x_vendedor
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

type gb_4 from groupbox within w_ve709_ventas_x_vendedor
integer x = 1376
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

