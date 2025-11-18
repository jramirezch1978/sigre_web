$PBExportHeader$w_ve732_rpt_doc_pend_x_cobrar.srw
forward
global type w_ve732_rpt_doc_pend_x_cobrar from w_rpt
end type
type cbx_detracciones from checkbox within w_ve732_rpt_doc_pend_x_cobrar
end type
type st_3 from statictext within w_ve732_rpt_doc_pend_x_cobrar
end type
type pb_4 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
end type
type st_4 from statictext within w_ve732_rpt_doc_pend_x_cobrar
end type
type pb_3 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
end type
type st_2 from statictext within w_ve732_rpt_doc_pend_x_cobrar
end type
type pb_1 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
end type
type st_1 from statictext within w_ve732_rpt_doc_pend_x_cobrar
end type
type pb_2 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
end type
type cbx_4 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
end type
type sle_titulo from singlelineedit within w_ve732_rpt_doc_pend_x_cobrar
end type
type cbx_2 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
end type
type cbx_1 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
end type
type cbx_3 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
end type
type dw_arg from datawindow within w_ve732_rpt_doc_pend_x_cobrar
end type
type dw_report from u_dw_rpt within w_ve732_rpt_doc_pend_x_cobrar
end type
type gb_1 from groupbox within w_ve732_rpt_doc_pend_x_cobrar
end type
end forward

global type w_ve732_rpt_doc_pend_x_cobrar from w_rpt
integer width = 3579
integer height = 1808
string title = "[VE732] Reporte de Ventas de Productos"
string menuname = "m_reporte"
cbx_detracciones cbx_detracciones
st_3 st_3
pb_4 pb_4
st_4 st_4
pb_3 pb_3
st_2 st_2
pb_1 pb_1
st_1 st_1
pb_2 pb_2
cbx_4 cbx_4
sle_titulo sle_titulo
cbx_2 cbx_2
cbx_1 cbx_1
cbx_3 cbx_3
dw_arg dw_arg
dw_report dw_report
gb_1 gb_1
end type
global w_ve732_rpt_doc_pend_x_cobrar w_ve732_rpt_doc_pend_x_cobrar

type variables
str_seleccionar istr_seleccionar
end variables

on w_ve732_rpt_doc_pend_x_cobrar.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_detracciones=create cbx_detracciones
this.st_3=create st_3
this.pb_4=create pb_4
this.st_4=create st_4
this.pb_3=create pb_3
this.st_2=create st_2
this.pb_1=create pb_1
this.st_1=create st_1
this.pb_2=create pb_2
this.cbx_4=create cbx_4
this.sle_titulo=create sle_titulo
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cbx_3=create cbx_3
this.dw_arg=create dw_arg
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_detracciones
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.pb_4
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.cbx_4
this.Control[iCurrent+11]=this.sle_titulo
this.Control[iCurrent+12]=this.cbx_2
this.Control[iCurrent+13]=this.cbx_1
this.Control[iCurrent+14]=this.cbx_3
this.Control[iCurrent+15]=this.dw_arg
this.Control[iCurrent+16]=this.dw_report
this.Control[iCurrent+17]=this.gb_1
end on

on w_ve732_rpt_doc_pend_x_cobrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_detracciones)
destroy(this.st_3)
destroy(this.pb_4)
destroy(this.st_4)
destroy(this.pb_3)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.cbx_4)
destroy(this.sle_titulo)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cbx_3)
destroy(this.dw_arg)
destroy(this.dw_report)
destroy(this.gb_1)
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

type cbx_detracciones from checkbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 50
integer y = 468
integer width = 1184
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "No Considerar Detracciones"
boolean checked = true
end type

type st_3 from statictext within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2889
integer y = 484
integer width = 617
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
string text = "Procesar"
boolean focusrectangle = false
end type

type pb_4 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2683
integer y = 436
integer width = 183
integer height = 144
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\BMP\procesos.bmp"
alignment htextalign = left!
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_tipo = 'V',ls_msj,ls_flag_detrac

dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]

SetPointer(hourglass!)


IF cbx_1.Checked THEN //todos los clientes
	//
	delete from tt_fin_proveedor ;
	//
	insert into tt_fin_proveedor
	(cod_proveedor)
	select cod_relacion from codigo_relacion ;
END IF	

IF cbx_2.Checked THEN //todos los articulos
	//
	delete from tt_fin_rpt_art ;
	//
	insert into tt_fin_rpt_art
	(cod_art)
	select cod_art from articulo ;
END IF	

IF cbx_3.Checked THEN
	ls_tipo = 'T' //TODOS LOS DOCUMENTOS
END IF	

//no considerar detracciones 
IF cbx_detracciones.Checked THEN
	ls_flag_detrac = '0'
ELSE
	ls_flag_detrac = '1'
END IF	


DECLARE PB_USP_FIN_RPT_CNTAS_COB_SALDO_AR PROCEDURE FOR USP_FIN_RPT_CNTAS_COB_SALDO_AR 
(:ld_fecha_inicio,:ld_fecha_final,:ls_tipo,:ls_flag_detrac);
EXECUTE PB_USP_FIN_RPT_CNTAS_COB_SALDO_AR ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj = SQLCA.SQLErrText
	MessageBox('Error ', ls_msj)
END IF





dw_report.Retrieve(String(ld_fecha_inicio,'dd/mm/yyyy'),String(ld_fecha_final,'dd/mm/yyyy'),gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo
//con titulo
if cbx_4.checked = true then
	dw_report.Object.t_tit.text = sle_titulo.text
end if


sle_titulo.text = ''

rollback ;
SetPointer(Arrow!)

end event

type st_4 from statictext within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2889
integer y = 340
integer width = 617
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
string text = "Por Grupo de Articulos"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2683
integer y = 296
integer width = 183
integer height = 144
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\BMP\productos.bmp"
string disabledname = "Move!"
alignment htextalign = left!
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_fin_rpt_art ;

sl_param.dw1		= 'd_abc_lista_grupo_art_tbl'
sl_param.titulo	= 'Grupo de Articulo'
sl_param.opcion   = 18
sl_param.db1 		= 1100
sl_param.string1 	= '1GAR'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)


sl_param = message.powerobjectparm

sle_titulo.text = sl_param.titulo
end event

type st_2 from statictext within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2889
integer y = 200
integer width = 617
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
string text = "Por Grupo de Clientes"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2683
integer y = 156
integer width = 183
integer height = 144
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\BMP\CLIENTES_GRU.bmp"
alignment htextalign = left!
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_fin_proveedor ;

sl_param.dw1		= 'd_abc_lista_grupo_rel_tbl'
sl_param.titulo	= 'Grupo de C. Relación'
sl_param.opcion   = 17
sl_param.db1 		= 1500
sl_param.string1 	= '1GCR'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type st_1 from statictext within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2889
integer y = 60
integer width = 617
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
string text = "Por Cliente"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_ve732_rpt_doc_pend_x_cobrar
integer x = 2683
integer y = 16
integer width = 183
integer height = 144
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\BMP\cliente.bmp"
alignment htextalign = left!
end type

event clicked;String ls_fecha_inicio,ls_fecha_final
Long   ll_count
str_parametros sl_param 

dw_arg.accepttext()

ls_fecha_inicio = String(dw_arg.object.ad_fecha_inicio [1],'yyyymmdd')
ls_fecha_final  = String(dw_arg.object.ad_fecha_final  [1],'yyyymmdd')


delete from tt_fin_proveedor ;

sl_param.dw1		= 'd_abc_lista_clientes_proveedores_tbl'
sl_param.titulo	= 'Lista de Clientes y Proveedores'
sl_param.opcion   = 1

sl_param.db1 		= 1500
sl_param.string1 	= '1RPP'
sl_param.string2 	= ls_fecha_inicio
sl_param.string3 	= ls_fecha_final
sl_param.tipo	 	= 'CPFEC'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cbx_4 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 50
integer y = 372
integer width = 1184
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Reporte Con titulo x Grupo de Articulo "
end type

type sle_titulo from singlelineedit within w_ve732_rpt_doc_pend_x_cobrar
boolean visible = false
integer x = 1157
integer y = 464
integer width = 1019
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 1184
integer y = 108
integer width = 814
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos Los Articulos"
end type

event clicked;IF this.checked THEN
	pb_3.enabled = FALSE
ELSE
	pb_3.enabled = TRUE
END IF
end event

type cbx_1 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 1184
integer y = 32
integer width = 814
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos Los Clientes"
end type

event clicked;IF this.checked THEN
	pb_1.enabled = FALSE
	pb_2.enabled = FALSE
ELSE
	pb_1.enabled = TRUE
	pb_2.enabled = TRUE
	
END IF
end event

type cbx_3 from checkbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 1184
integer y = 184
integer width = 814
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Incluye Letras x Cobrar"
end type

type dw_arg from datawindow within w_ve732_rpt_doc_pend_x_cobrar
integer x = 69
integer y = 108
integer width = 946
integer height = 196
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_tbl"
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

type dw_report from u_dw_rpt within w_ve732_rpt_doc_pend_x_cobrar
integer x = 14
integer y = 588
integer width = 3511
integer height = 936
integer taborder = 120
string dataobject = "d_rpt_doc_x_cobrar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ve732_rpt_doc_pend_x_cobrar
integer x = 37
integer y = 28
integer width = 1033
integer height = 320
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

