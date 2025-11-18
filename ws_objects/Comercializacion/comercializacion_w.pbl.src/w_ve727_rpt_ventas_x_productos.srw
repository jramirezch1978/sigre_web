$PBExportHeader$w_ve727_rpt_ventas_x_productos.srw
forward
global type w_ve727_rpt_ventas_x_productos from w_rpt
end type
type dw_1 from datawindow within w_ve727_rpt_ventas_x_productos
end type
type cb_2 from commandbutton within w_ve727_rpt_ventas_x_productos
end type
type cb_3 from commandbutton within w_ve727_rpt_ventas_x_productos
end type
type cbx_1 from checkbox within w_ve727_rpt_ventas_x_productos
end type
type dw_arg from datawindow within w_ve727_rpt_ventas_x_productos
end type
type cb_art from commandbutton within w_ve727_rpt_ventas_x_productos
end type
type dw_report from u_dw_rpt within w_ve727_rpt_ventas_x_productos
end type
type cb_1 from commandbutton within w_ve727_rpt_ventas_x_productos
end type
type gb_1 from groupbox within w_ve727_rpt_ventas_x_productos
end type
end forward

global type w_ve727_rpt_ventas_x_productos from w_rpt
integer width = 3589
integer height = 1452
string title = "[VE727] Reporte de Ventas Generadas"
string menuname = "m_reporte"
long backcolor = 12632256
dw_1 dw_1
cb_2 cb_2
cb_3 cb_3
cbx_1 cbx_1
dw_arg dw_arg
cb_art cb_art
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_ve727_rpt_ventas_x_productos w_ve727_rpt_ventas_x_productos

type variables
str_seleccionar istr_seleccionar
end variables

on w_ve727_rpt_ventas_x_productos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.dw_arg=create dw_arg
this.cb_art=create cb_art
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.dw_arg
this.Control[iCurrent+6]=this.cb_art
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_ve727_rpt_ventas_x_productos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.dw_arg)
destroy(this.cb_art)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
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

type dw_1 from datawindow within w_ve727_rpt_ventas_x_productos
boolean visible = false
integer x = 681
integer y = 800
integer width = 2203
integer height = 776
integer taborder = 50
boolean titlebar = true
string title = "Voucher"
string dataobject = "d_rpt_voucher_doc_x_cobrar_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

type cb_2 from commandbutton within w_ve727_rpt_ventas_x_productos
integer x = 3063
integer y = 256
integer width = 471
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cliente"
end type

event clicked;str_seleccionar lstr_seleccionar
Long ll_inicio



lstr_seleccionar.s_seleccion = 'M'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
				      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
				   					 +'PROVEEDOR.EMAIL			AS EMAIL ,'&
										 +'PROVEEDOR.RUC			   AS R_U_C '&
					   				 +'FROM PROVEEDOR '&
										 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
//			Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
		For ll_inicio = 1 TO UpperBound(lstr_seleccionar.param1)
			 Insert Into tt_fin_proveedor
			 (cod_proveedor)
			 Values
			 (:lstr_seleccionar.param1[ll_inicio]);
		Next
	END IF

end event

type cb_3 from commandbutton within w_ve727_rpt_ventas_x_productos
integer x = 3063
integer y = 24
integer width = 471
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = " Documento"
end type

event clicked;Long ll_inicio

delete from  tt_fin_tipo_doc ;

istr_seleccionar.s_seleccion = 'S'
istr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_VENTAS.TIPO_DOC AS TIPO_DOCUMENTO ,'&
				      				 +'VW_FIN_DOC_VENTAS.DESC_TIPO_DOC  AS DESCRIPCION '&
				   					 +'FROM VW_FIN_DOC_VENTAS '

														 
OpenWithParm(w_seleccionar,istr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN istr_seleccionar = message.PowerObjectParm
IF istr_seleccionar.s_action = "aceptar" THEN		

	For ll_inicio = 1 to UpperBound(istr_seleccionar.param1)
		 Insert Into tt_fin_tipo_doc
		 (tipo_doc)
		 Values
		 (:istr_seleccionar.param1[ll_inicio]) ;
	Next
	
END IF	
end event

type cbx_1 from checkbox within w_ve727_rpt_ventas_x_productos
integer x = 1170
integer y = 232
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

type dw_arg from datawindow within w_ve727_rpt_ventas_x_productos
integer x = 69
integer y = 108
integer width = 1760
integer height = 280
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_origen_doc_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
Accepttext()
//
//CHOOSE CASE dwo.name
//		 CASE 'b_tipo_doc'
//				istr_seleccionar.s_seleccion = 'S'
//				istr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_VENTAS.TIPO_DOC AS TIPO_DOCUMENTO ,'&
//								      				 +'VW_FIN_DOC_VENTAS.NRO_DOC  AS NUMERO_DOC '&
//								   					 +'FROM VW_FIN_DOC_VENTAS '
//
//														 
//				OpenWithParm(w_seleccionar,istr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN istr_seleccionar = message.PowerObjectParm
//		
//END CHOOSE
//
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

type cb_art from commandbutton within w_ve727_rpt_ventas_x_productos
integer x = 3063
integer y = 140
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

delete from tt_fin_rpt_art ;


sl_param.dw1		= 'd_rpt_art_temp_tbl'
sl_param.titulo	= 'Articulos'
sl_param.opcion   = 14
sl_param.db1 		= 1600
sl_param.string1 	= '1ART'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type dw_report from u_dw_rpt within w_ve727_rpt_ventas_x_productos
integer y = 512
integer width = 3511
integer height = 748
integer taborder = 120
string dataobject = "d_rpt_listado_cntas_x_cobrar_x_guia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_cod_relacion,ls_tipo_doc,ls_nro_doc

IF row = 0 THEN RETURN
IF dwo.name = 'cod_relacion' THEN
	ls_cod_relacion = This.object.cod_relacion [row]
	ls_tipo_doc     = This.object.tipo_doc		 [row]
	ls_nro_doc      = This.object.nro_doc		 [row]	
	dw_1.retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	dw_1.visible = TRUE
END IF
end event

type cb_1 from commandbutton within w_ve727_rpt_ventas_x_productos
integer x = 3063
integer y = 376
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
String ls_cod_origen,ls_soles,ls_dolares,ls_cod_moneda


SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares  
  FROM logparam
 WHERE (reckey = '1' );


dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]
ls_cod_origen   = dw_arg.object.cod_origen	   [1]




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




DECLARE PB_USP_FIN_RPT_COBRAR_X_GUIA PROCEDURE FOR USP_FIN_RPT_COBRAR_X_GUIA (:ld_fecha_inicio,:ld_fecha_final,:ls_cod_origen);
EXECUTE PB_USP_FIN_RPT_COBRAR_X_GUIA ;

IF SQLCA.SQLCode = -1 THEN 
	Rollback ;
	MessageBox('Error ', SQLCA.SQLErrText)
	Return
END IF
ib_preview = FALSE
Parent.Event ue_preview()


dw_report.Retrieve(String(ld_fecha_inicio),String(ld_fecha_final),gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo


//delete from tt_fin_tipo_doc ;
//delete from tt_fin_rpt_art ;
rollback ;

end event

type gb_1 from groupbox within w_ve727_rpt_ventas_x_productos
integer x = 37
integer y = 32
integer width = 1833
integer height = 376
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

