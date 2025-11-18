$PBExportHeader$w_cm788_relacion_de_art_iqpf.srw
forward
global type w_cm788_relacion_de_art_iqpf from w_report_smpl
end type
type cb_3 from commandbutton within w_cm788_relacion_de_art_iqpf
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm788_relacion_de_art_iqpf
end type
type st_1 from statictext within w_cm788_relacion_de_art_iqpf
end type
type gb_2 from groupbox within w_cm788_relacion_de_art_iqpf
end type
end forward

global type w_cm788_relacion_de_art_iqpf from w_report_smpl
integer width = 2144
integer height = 2068
string title = "Relación de Articulos IQPF[CM788]"
string menuname = "m_consulta_impresion"
long backcolor = 67108864
cb_3 cb_3
uo_fecha uo_fecha
st_1 st_1
gb_2 gb_2
end type
global w_cm788_relacion_de_art_iqpf w_cm788_relacion_de_art_iqpf

on w_cm788_relacion_de_art_iqpf.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_impresion" then this.MenuID = create m_consulta_impresion
this.cb_3=create cb_3
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_2
end on

on w_cm788_relacion_de_art_iqpf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;//Override

date 		ld_fec_desde, ld_fec_hasta
String	ls_origen	

ld_fec_desde	=uo_fecha.of_get_fecha1()
ld_fec_hasta	=uo_fecha.of_get_fecha2()

idw_1.Retrieve(ld_fec_desde, ld_fec_hasta)
idw_1.Visible = True

dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_desde.text    = string(ld_fec_desde)
dw_report.object.t_hasta.text    = string(ld_fec_hasta)
dw_report.object.t_user.text     = gs_user
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_cm788_relacion_de_art_iqpf
integer x = 82
integer y = 472
integer width = 1911
integer height = 1328
string dataobject = "d_abc_rpt_articulos_iqpf_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;date				ld_fecha1, ld_fecha2
string 			ls_almacen, ls_cod_art

LONG 				ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento
str_parametros  lstr_param
w_rpt_preview	lw_1

if this.RowCount() = 0 or row = 0 then return

ld_fecha1 		= date(this.object.fecha_emision 		[row])
ld_fecha2		= date(this.object.fecha_vencimiento  	[row])
ls_cod_art		= this.object.cod_art  			   		[row]
ls_almacen		= this.object.almacen  			   		[row]
	    
	IF dwo.Name = 'cantidad_ingresada' THEN  //Nota de Ingreso 

			lstr_param.dw1     = 'd_abc_articulos_iqpf_ingresos_tbl'
			lstr_param.titulo  = "Resumen de Cantidades Ingresadas"
			lstr_param.tipo 	 = '1D2D1S2S'
			lstr_param.string1 = ls_cod_art
			lstr_param.string2 = ls_almacen
			lstr_param.fecha1  = ld_fecha1
			lstr_param.fecha2  = ld_fecha2
			
			lstr_param.opcion = 2
						
			OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
			
		ELSEIF dwo.Name = 'cantidad_despachada' OR dwo.Name = 'nro_doc' THEN //Cantidades Despachadas
			
			lstr_param.dw1     = 'd_abc_articulos_iqpf_despachos_tbl'
			lstr_param.titulo  = "Resumen de Cantidades Despachadas"
			lstr_param.tipo 	 = '1D2D1S2S'
			lstr_param.string1 = ls_cod_art
			lstr_param.string2 = ls_almacen
			lstr_param.fecha1  = ld_fecha1
			lstr_param.fecha2  = ld_fecha2
			
			lstr_param.opcion = 2
			
			OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)

	End IF
end event

type cb_3 from commandbutton within w_cm788_relacion_de_art_iqpf
integer x = 1454
integer y = 292
integer width = 562
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm788_relacion_de_art_iqpf
event destroy ( )
integer x = 105
integer y = 284
integer taborder = 70
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type st_1 from statictext within w_cm788_relacion_de_art_iqpf
integer x = 224
integer y = 96
integer width = 1467
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "RELACION DE ARTÍCULOS IQPF"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_cm788_relacion_de_art_iqpf
integer x = 78
integer y = 228
integer width = 1335
integer height = 184
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Ingrese Rango de Fechas "
end type

