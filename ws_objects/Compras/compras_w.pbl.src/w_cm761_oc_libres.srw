$PBExportHeader$w_cm761_oc_libres.srw
forward
global type w_cm761_oc_libres from w_report_smpl
end type
type cb_1 from commandbutton within w_cm761_oc_libres
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm761_oc_libres
end type
type rb_tipo_art_todos from radiobutton within w_cm761_oc_libres
end type
type rb_tipo_art_pedido from radiobutton within w_cm761_oc_libres
end type
type rb_tipo_art_reposicion from radiobutton within w_cm761_oc_libres
end type
type gb_tipo_art from groupbox within w_cm761_oc_libres
end type
end forward

global type w_cm761_oc_libres from w_report_smpl
integer width = 3040
integer height = 1700
string title = "OC Libres (CM761)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
rb_tipo_art_todos rb_tipo_art_todos
rb_tipo_art_pedido rb_tipo_art_pedido
rb_tipo_art_reposicion rb_tipo_art_reposicion
gb_tipo_art gb_tipo_art
end type
global w_cm761_oc_libres w_cm761_oc_libres

type variables
String is_reposicion[]
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_oc)
end prototypes

public function integer of_get_parametros (ref string as_doc_oc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OC"
    INTO :as_doc_oc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm761_oc_libres.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.rb_tipo_art_todos=create rb_tipo_art_todos
this.rb_tipo_art_pedido=create rb_tipo_art_pedido
this.rb_tipo_art_reposicion=create rb_tipo_art_reposicion
this.gb_tipo_art=create gb_tipo_art
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.rb_tipo_art_todos
this.Control[iCurrent+4]=this.rb_tipo_art_pedido
this.Control[iCurrent+5]=this.rb_tipo_art_reposicion
this.Control[iCurrent+6]=this.gb_tipo_art
end on

on w_cm761_oc_libres.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.rb_tipo_art_todos)
destroy(this.rb_tipo_art_pedido)
destroy(this.rb_tipo_art_reposicion)
destroy(this.gb_tipo_art)
end on

event ue_retrieve;call super::ue_retrieve;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

Long	ls_rc
String	ls_doc_oc, ls_tipo_art[], ls_st_tipo_art

ls_rc = of_get_parametros(ls_doc_oc)

// Determinar Tipo Articulo
IF rb_tipo_art_todos.checked = True THEN
	ls_tipo_art = is_reposicion
	ls_st_tipo_art = 'Todos los Articulos'
ELSEIF rb_tipo_art_pedido.checked = True THEN
	ls_tipo_art[1] = '0' 
	ls_st_tipo_art = 'Articulos solo de Pedido'
ELSEIF rb_tipo_art_reposicion.checked = True THEN
	ls_tipo_art[1] = '1' 
	ls_st_tipo_art = 'Articulos solo de Reposicion'	
END IF

idw_1.Retrieve(ls_doc_oc, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_tipo_art )

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM761'
idw_1.object.t_subtitulo.text = ls_st_tipo_art + &
                                ' Desde: ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + &
                                ' Hasta: ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy')
end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1

// Cargar arreglo de tipos de articulo
is_reposicion[1] = '0' // los de pedido
is_reposicion[2] = '1' // Los de reposicion

end event

type dw_report from w_report_smpl`dw_report within w_cm761_oc_libres
integer x = 9
integer y = 156
string dataobject = "d_oc_libres_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_tbl'
		lstr_1.Width = 1700
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Relacionados'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_doc"
		ls_tipo_doc = TRIM(GetItemString(row,'tipo_doc'))	
		CHOOSE CASE ls_tipo_doc
			CASE 'OT'
				lstr_1.DataObject = 'd_orden_trabajo_oper_sec_ff'
				lstr_1.Width = 2000
				lstr_1.Height= 1800
				lstr_1.Arg[1] = GetItemString(row,'nro_doc')
				lstr_1.Arg[2] = GetItemString(row,'oper_sec')
				lstr_1.Title = 'Orden de Trabajo'
			CASE 'SC'
				lstr_1.DataObject = 'd_sol_compra_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1200
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Compra'
			CASE 'SL'
				lstr_1.DataObject = 'd_solicitud_salida_ff'
				lstr_1.Width = 2100
				lstr_1.Height= 800
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Salida'
			CASE 'OC'
				lstr_1.DataObject = 'd_orden_compra_ff'
				lstr_1.Width = 2400
				lstr_1.Height= 1300
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Compra'
			CASE 'OV'
				lstr_1.DataObject = 'd_orden_venta_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1500
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Venta'
		END CHOOSE
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_cm761_oc_libres
integer x = 2683
integer y = 48
integer width = 261
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm761_oc_libres
event destroy ( )
integer x = 9
integer y = 8
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-90), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type rb_tipo_art_todos from radiobutton within w_cm761_oc_libres
integer x = 1335
integer y = 64
integer width = 261
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type rb_tipo_art_pedido from radiobutton within w_cm761_oc_libres
integer x = 1600
integer y = 64
integer width = 571
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo a Pedido"
boolean checked = true
end type

type rb_tipo_art_reposicion from radiobutton within w_cm761_oc_libres
integer x = 2048
integer y = 64
integer width = 485
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Reposicion"
end type

type gb_tipo_art from groupbox within w_cm761_oc_libres
integer x = 1307
integer y = 4
integer width = 1253
integer height = 132
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipos de Articulos"
end type

