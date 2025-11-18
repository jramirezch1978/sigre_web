$PBExportHeader$w_fi729_rpt_saldo_cta_cte.srw
forward
global type w_fi729_rpt_saldo_cta_cte from w_rpt
end type
type rb_detalle from radiobutton within w_fi729_rpt_saldo_cta_cte
end type
type rb_resumen from radiobutton within w_fi729_rpt_saldo_cta_cte
end type
type cb_2 from commandbutton within w_fi729_rpt_saldo_cta_cte
end type
type cb_1 from commandbutton within w_fi729_rpt_saldo_cta_cte
end type
type cb_buscar from commandbutton within w_fi729_rpt_saldo_cta_cte
end type
type dw_reporte from u_dw_rpt within w_fi729_rpt_saldo_cta_cte
end type
type gb_1 from groupbox within w_fi729_rpt_saldo_cta_cte
end type
end forward

global type w_fi729_rpt_saldo_cta_cte from w_rpt
integer width = 3387
integer height = 1672
string title = "[FI729] Reporte de Analítico de Cuenta Corriente"
string menuname = "m_impresion"
long backcolor = 67108864
rb_detalle rb_detalle
rb_resumen rb_resumen
cb_2 cb_2
cb_1 cb_1
cb_buscar cb_buscar
dw_reporte dw_reporte
gb_1 gb_1
end type
global w_fi729_rpt_saldo_cta_cte w_fi729_rpt_saldo_cta_cte

type variables
String is_cod_rel[], is_tipo_doc[]
String is_flag_rel = '2', is_flag_tipo = '2'  // 0 (Ninguno), 1 (Selectiva), 2(Todos) 

//***** VARIABLES VENTANA POP ******//
Integer    ii_lista = 0
//**********************************//
end variables

forward prototypes
public function integer of_new_rpt (str_cns_pop astr_1)
end prototypes

public function integer of_new_rpt (str_cns_pop astr_1);Integer li_rc
w_rpt_pop	lw_sheet

li_rc = OpenSheetWithParm(lw_sheet, astr_1, this, 0, Original!)
ii_x ++
iw_sheet[ii_x]  = lw_sheet

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 =
end function

on w_fi729_rpt_saldo_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_buscar=create cb_buscar
this.dw_reporte=create dw_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_detalle
this.Control[iCurrent+2]=this.rb_resumen
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_buscar
this.Control[iCurrent+6]=this.dw_reporte
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi729_rpt_saldo_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_buscar)
destroy(this.dw_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10
end event

event ue_retrieve;call super::ue_retrieve;Decimal{3} ldc_tasa_cambio
String ls_tipo

IF rb_resumen.checked = TRUE THEN
	idw_1.DataObject='d_rpt_sldo_cta_cte_res_tbl'
ELSEIF rb_detalle.checked = TRUE THEN
	idw_1.DataObject='d_rpt_sldo_cta_cte_detalle_tbl'
ELSE
	MessageBox('Aviso', 'Seleccione una opción en parámetros')
	return 
END IF 

idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.Object.p_logo.filename = gnvo_app.is_logo
idw_1.Object.t_nombre.text   = gnvo_app.invo_empresa.is_empresa
idw_1.Object.t_user.Text     = gnvo_app.is_user
idw_1.Object.t_tasa.Text     = 'Tasa Cambio HOY: '+String(ldc_tasa_cambio, '#0.000')

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

event ue_open_pre;call super::ue_open_pre;dw_reporte.Settransobject(sqlca)
idw_1 = dw_reporte
ib_preview = FALSE
Trigger Event ue_preview()

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

type ole_skin from w_rpt`ole_skin within w_fi729_rpt_saldo_cta_cte
end type

type rb_detalle from radiobutton within w_fi729_rpt_saldo_cta_cte
integer x = 128
integer y = 188
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type rb_resumen from radiobutton within w_fi729_rpt_saldo_cta_cte
integer x = 128
integer y = 108
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type cb_2 from commandbutton within w_fi729_rpt_saldo_cta_cte
integer x = 2894
integer y = 124
integer width = 398
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Codigo Relación"
end type

event clicked;Long   ll_inicio
String ls_cod_relacion
str_seleccionar lstr_seleccionar

//elimina la informacion temporal
delete from tt_fin_proveedor ;


lstr_seleccionar.s_seleccion = 'M'
lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS COD_RELACION ,'&
										 +'CODIGO_RELACION.NOMBRE       AS DESCRIPCION '&
										 +'FROM CODIGO_RELACION	'	 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		For ll_inicio = 1 TO UpperBound(lstr_seleccionar.param1) 
			 ls_cod_relacion = lstr_seleccionar.param1[ll_inicio]
			 //tabla temporal de tipo de documento
			 Insert Into tt_fin_proveedor
			 (cod_proveedor)
			 Values
			 (:ls_cod_relacion);
			 
		Next
	END IF		
end event

type cb_1 from commandbutton within w_fi729_rpt_saldo_cta_cte
integer x = 2894
integer y = 16
integer width = 398
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Documentos"
end type

event clicked;Long   ll_inicio
String ls_tipo_doc
str_seleccionar lstr_seleccionar

//elimina la informacion temporal
delete from tt_fin_tipo_doc ;


lstr_seleccionar.s_seleccion = 'M'
lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC      AS CODIGO,     '&
										 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
										 +'FROM DOC_TIPO '

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		For ll_inicio = 1 TO UpperBound(lstr_seleccionar.param1) 
			 ls_tipo_doc = lstr_seleccionar.param1[ll_inicio]
			 //tabla temporal de tipo de documento
			 Insert Into tt_fin_tipo_doc
			 (tipo_doc)
			 Values
			 (:ls_tipo_doc);
			 
		Next
	END IF		
end event

type cb_buscar from commandbutton within w_fi729_rpt_saldo_cta_cte
integer x = 2894
integer y = 228
integer width = 398
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;
Event ue_retrieve()

end event

type dw_reporte from u_dw_rpt within w_fi729_rpt_saldo_cta_cte
integer x = 14
integer y = 352
integer width = 3305
integer height = 1108
string dataobject = "d_rpt_sldo_cta_cte_res_tbl"
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;call super::doubleclicked;IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
END IF

IF row = 0 THEN RETURN

STR_CNS_POP lstr_1
CHOOSE CASE dwo.Name
	CASE 'cod_relacion'  
		lstr_1.DataObject = 'd_rpt_sldo_cta_cte_res_det_tbl'
		lstr_1.Width = 3100
		lstr_1.Height= 1300
		lstr_1.Title = 'Reporte Saldo de Cuenta Corriente Resumen - Detalle'
		lstr_1.arg[1] = String(GetItemString(row,'cod_relacion'))
		of_new_rpt(lstr_1)
END CHOOSE
end event

type gb_1 from groupbox within w_fi729_rpt_saldo_cta_cte
integer x = 82
integer y = 40
integer width = 453
integer height = 244
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

