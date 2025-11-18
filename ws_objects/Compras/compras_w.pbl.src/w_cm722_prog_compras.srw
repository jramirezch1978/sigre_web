$PBExportHeader$w_cm722_prog_compras.srw
forward
global type w_cm722_prog_compras from w_report_smpl
end type
type cb_3 from commandbutton within w_cm722_prog_compras
end type
type st_label from statictext within w_cm722_prog_compras
end type
type sle_input from singlelineedit within w_cm722_prog_compras
end type
type rb_programa from radiobutton within w_cm722_prog_compras
end type
type rb_comprador from radiobutton within w_cm722_prog_compras
end type
type rb_todo from radiobutton within w_cm722_prog_compras
end type
type rb_todo_ot from radiobutton within w_cm722_prog_compras
end type
type gb_1 from groupbox within w_cm722_prog_compras
end type
end forward

global type w_cm722_prog_compras from w_report_smpl
integer width = 3113
integer height = 1904
string title = "Programa de Compras (CM722)"
string menuname = "m_impresion"
long backcolor = 12632256
cb_3 cb_3
st_label st_label
sle_input sle_input
rb_programa rb_programa
rb_comprador rb_comprador
rb_todo rb_todo
rb_todo_ot rb_todo_ot
gb_1 gb_1
end type
global w_cm722_prog_compras w_cm722_prog_compras

type variables
String	is_doc_ot, is_doc_oc, is_doc_prc
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_doc_prc)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_doc_prc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."TIPO_DOC_PROG_CMP"  
    INTO :as_doc_ot, :as_doc_oc, :as_doc_prc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm722_prog_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.st_label=create st_label
this.sle_input=create sle_input
this.rb_programa=create rb_programa
this.rb_comprador=create rb_comprador
this.rb_todo=create rb_todo
this.rb_todo_ot=create rb_todo_ot
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.st_label
this.Control[iCurrent+3]=this.sle_input
this.Control[iCurrent+4]=this.rb_programa
this.Control[iCurrent+5]=this.rb_comprador
this.Control[iCurrent+6]=this.rb_todo
this.Control[iCurrent+7]=this.rb_todo_ot
this.Control[iCurrent+8]=this.gb_1
end on

on w_cm722_prog_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.st_label)
destroy(this.sle_input)
destroy(this.rb_programa)
destroy(this.rb_comprador)
destroy(this.rb_todo)
destroy(this.rb_todo_ot)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_input, ls_nombre

ls_input = trim(sle_input.text)

IF rb_progRama.checked THEN // x Nro de Programa
	idw_1.dataObject = "d_rpt_prog_compras_det"
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ls_input)
	idw_1.object.t_detalle.text = 'Nro Programa:  ' + ls_input
ELSEIF rb_comprador.checked = True THEN  // x Comprador
	idw_1.dataObject = "d_rpt_prog_compras_x_comprador"
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ls_input) 
	SELECT "COMPRADOR"."NOM_COMPRADOR"  INTO :ls_nombre  
    FROM "COMPRADOR"  
   WHERE "COMPRADOR"."COMPRADOR" = :ls_input   ;
	idw_1.object.t_detalle.text = 'Comprador:  ' + ls_input + '  ' + ls_nombre
ELSEIF rb_todo.checked THEN // Todo lo Pendiente
	idw_1.dataObject = "d_rpt_prog_compras_todo_pendiente"
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(is_doc_prc) 
	idw_1.object.t_detalle.text = 'Todo lo Pendiente'
ELSEIF rb_todo_ot.checked THEN // Todo lo Pendiente x OT
	idw_1.dataObject = "d_rpt_prog_compras_todo_pendiente_x_ot"
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(is_doc_prc, is_doc_ot, ls_input) 
	idw_1.object.t_detalle.text = 'Todo lo Pendiente'
END IF

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM722'


end event

event ue_open_pre;call super::ue_open_pre;// Leer tipo doc OT, cod operacion consumo interno
of_get_parametros(is_doc_ot, is_doc_oc, is_doc_prc)

end event

type dw_report from w_report_smpl`dw_report within w_cm722_prog_compras
integer x = 14
integer y = 256
integer width = 1865
integer height = 956
string dataobject = "d_rpt_prog_compras_det"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "almacen" 
		lstr_1.DataObject = 'd_art_mov_almacen_tbl'
		lstr_1.Width = 2850
		lstr_1.Height= 900
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Arg[2] = GetItemString(row,'almacen')
		lstr_1.Title = 'Ultimos Movimientos del Articulo en este Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "qnt_comp" 
		lstr_1.DataObject = 'd_oc_x_prog_comp_item_tbl'
		lstr_1.Width = 3500
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_prc
		lstr_1.Arg[2] = GetItemString(row,'nro_programa')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_item'))
		lstr_1.Title = 'OC Relacionadas al Item de Programa de Compras'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "qnt_ing" 
		lstr_1.DataObject = 'd_art_mov_prog_comp_tbl'
		lstr_1.Width = 2950
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_prc
		lstr_1.Arg[2] = GetItemString(row,'nro_programa')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_item'))
		lstr_1.Title = 'Mov de Almacen de OC Relacionadas'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
END CHOOSE
end event

type cb_3 from commandbutton within w_cm722_prog_compras
integer x = 2729
integer y = 48
integer width = 265
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;parent.Event ue_retrieve()

end event

type st_label from statictext within w_cm722_prog_compras
integer x = 32
integer y = 176
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro Programa:"
boolean focusrectangle = false
end type

type sle_input from singlelineedit within w_cm722_prog_compras
integer x = 521
integer y = 164
integer width = 613
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type rb_programa from radiobutton within w_cm722_prog_compras
integer x = 27
integer y = 56
integer width = 475
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro Programa"
boolean checked = true
end type

event clicked;
st_label.text = 'Nro Programa:'
st_label.visible = True
sle_input.visible = True
end event

type rb_comprador from radiobutton within w_cm722_prog_compras
integer x = 503
integer y = 56
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Comprador"
end type

event clicked;
st_label.text     = 'Cod Comprador :'
st_label.visible  = True
sle_input.visible = True

end event

type rb_todo from radiobutton within w_cm722_prog_compras
integer x = 914
integer y = 56
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todo lo Pendiente"
end type

event clicked;
st_label.visible = False
sle_input.visible = False

end event

type rb_todo_ot from radiobutton within w_cm722_prog_compras
integer x = 1509
integer y = 56
integer width = 955
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todo lo Pendiente x Orden Trabajo"
end type

event clicked;
st_label.visible  = True
sle_input.visible = True
st_label.text		= 'Orden Trabajo : '
end event

type gb_1 from groupbox within w_cm722_prog_compras
integer x = 9
integer width = 2482
integer height = 144
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Reporte Por:"
end type

