$PBExportHeader$w_cm763_req_mat_exceso.srw
forward
global type w_cm763_req_mat_exceso from w_report_smpl
end type
type cb_1 from commandbutton within w_cm763_req_mat_exceso
end type
type cbx_origen from checkbox within w_cm763_req_mat_exceso
end type
type ddlb_origen from u_ddlb within w_cm763_req_mat_exceso
end type
type st_1 from statictext within w_cm763_req_mat_exceso
end type
type st_registros from statictext within w_cm763_req_mat_exceso
end type
type rb_tipo_art_todos from radiobutton within w_cm763_req_mat_exceso
end type
type rb_tipo_art_pedido from radiobutton within w_cm763_req_mat_exceso
end type
type rb_tipo_art_reposicion from radiobutton within w_cm763_req_mat_exceso
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm763_req_mat_exceso
end type
type gb_1 from groupbox within w_cm763_req_mat_exceso
end type
type gb_tipo_art from groupbox within w_cm763_req_mat_exceso
end type
end forward

global type w_cm763_req_mat_exceso from w_report_smpl
integer width = 3067
integer height = 1272
string title = "Requerimiento de Articulos en Exceso (CM763)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
cbx_origen cbx_origen
ddlb_origen ddlb_origen
st_1 st_1
st_registros st_registros
rb_tipo_art_todos rb_tipo_art_todos
rb_tipo_art_pedido rb_tipo_art_pedido
rb_tipo_art_reposicion rb_tipo_art_reposicion
uo_fecha uo_fecha
gb_1 gb_1
gb_tipo_art gb_tipo_art
end type
global w_cm763_req_mat_exceso w_cm763_req_mat_exceso

type variables
String is_doc_ot, is_doc_oc, is_oper_cons, is_origen[], is_reposicion[], is_ot_adm
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."OPER_CONS_INTERNO"  
    INTO :as_doc_ot, :as_doc_oc, :as_oper_cons
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm763_req_mat_exceso.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
this.st_1=create st_1
this.st_registros=create st_registros
this.rb_tipo_art_todos=create rb_tipo_art_todos
this.rb_tipo_art_pedido=create rb_tipo_art_pedido
this.rb_tipo_art_reposicion=create rb_tipo_art_reposicion
this.uo_fecha=create uo_fecha
this.gb_1=create gb_1
this.gb_tipo_art=create gb_tipo_art
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_origen
this.Control[iCurrent+3]=this.ddlb_origen
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_registros
this.Control[iCurrent+6]=this.rb_tipo_art_todos
this.Control[iCurrent+7]=this.rb_tipo_art_pedido
this.Control[iCurrent+8]=this.rb_tipo_art_reposicion
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_tipo_art
end on

on w_cm763_req_mat_exceso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
destroy(this.st_1)
destroy(this.st_registros)
destroy(this.rb_tipo_art_todos)
destroy(this.rb_tipo_art_pedido)
destroy(this.rb_tipo_art_reposicion)
destroy(this.uo_fecha)
destroy(this.gb_1)
destroy(this.gb_tipo_art)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_cod_art, ls_almacen, ls_origen[], ls_tipo_art[], ls_sql, ls_subtitulo
String	ls_st_origen, ls_st_tipo_art
Decimal	ldec_pendiente
Long		ll_rc, ll_saldomin, ll_x, ll_row, ll_pos

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

st_registros.text = ''

// Determinar Origen
IF cbx_origen.checked = False THEN
	ls_origen = ddlb_origen.ia_key //is_origen
	ls_st_origen = 'Todos los Origenes'
ELSE
	ls_origen[1] = ddlb_origen.ia_id //ddlb_origen.text
	ls_st_origen = 'Origen:  ' + ddlb_origen.text
END IF

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

idw_1.Retrieve(is_doc_ot, is_oper_cons, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen, ls_tipo_art) 
idw_1.object.t_fecha.text = 'Fecha Registro Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen		

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM763'
st_registros.text = String(idw_1.RowCount())


end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

// Leer tipo doc OT, cod operacion consumo interno
ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)

// Cargar arreglo de tipos de articulo

is_reposicion[1] = '0' // los de pedido
is_reposicion[2] = '1' // Los de reposicion

end event

type dw_report from w_report_smpl`dw_report within w_cm763_req_mat_exceso
integer x = 9
integer y = 292
string dataobject = "d_amp_exceso_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

//String		ls_tipo_doc
//STR_CNS_POP lstr_1
//
//CHOOSE CASE dwo.Name
//	CASE "nro_aprob" 
//		lstr_1.DataObject = 'd_articulo_mov_tbl'
//		lstr_1.Width = 1700
//		lstr_1.Height= 1000
//		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
//		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
//		lstr_1.Title = 'Movimientos Relacionados'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)
//END CHOOSE

end event

type cb_1 from commandbutton within w_cm763_req_mat_exceso
integer x = 2775
integer y = 48
integer width = 219
integer height = 80
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

event clicked;
IF cbx_origen.enabled AND cbx_origen.checked THEN
	IF ddlb_origen.text = "" THEN
		MessageBox('Error', 'Tiene que seleccionar Origen')
		RETURN
	END IF
END IF

PARENT.Event ue_retrieve()
end event

type cbx_origen from checkbox within w_cm763_req_mat_exceso
integer x = 873
integer y = 184
integer width = 288
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
end type

event clicked;IF THIS.checked THEN
	ddlb_origen.enabled = true
ELSE
	ddlb_origen.enabled = false
END IF
end event

type ddlb_origen from u_ddlb within w_cm763_req_mat_exceso
integer x = 1166
integer y = 176
integer width = 718
integer height = 352
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event constructor;call super::constructor;Long	ll_x

FOR ll_x = 1 TO THIS.ids_data.RowCount()
	is_origen[ll_x] = ids_data.GetItemString(ll_x, 'cod_origen')
NEXT

end event

event ue_open_pre;call super::ue_open_pre;Long	ll_x

is_dataobject = 'd_origen_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 20							// Longitud del campo 2


end event

type st_1 from statictext within w_cm763_req_mat_exceso
integer x = 2848
integer y = 208
integer width = 151
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Req."
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_registros from statictext within w_cm763_req_mat_exceso
integer x = 2619
integer y = 208
integer width = 219
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type rb_tipo_art_todos from radiobutton within w_cm763_req_mat_exceso
integer x = 1970
integer y = 76
integer width = 320
integer height = 72
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

type rb_tipo_art_pedido from radiobutton within w_cm763_req_mat_exceso
integer x = 1970
integer y = 144
integer width = 571
integer height = 72
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

type rb_tipo_art_reposicion from radiobutton within w_cm763_req_mat_exceso
integer x = 1970
integer y = 208
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Reposicion Aut"
end type

type uo_fecha from u_ingreso_rango_fechas within w_cm763_req_mat_exceso
integer x = 594
integer y = 76
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-90), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_1 from groupbox within w_cm763_req_mat_exceso
integer x = 14
integer y = 20
integer width = 1883
integer height = 264
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros:"
end type

type gb_tipo_art from groupbox within w_cm763_req_mat_exceso
integer x = 1943
integer y = 20
integer width = 640
integer height = 264
integer taborder = 10
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

