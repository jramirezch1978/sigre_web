$PBExportHeader$w_cm765_saldos_reservados.srw
forward
global type w_cm765_saldos_reservados from w_report_smpl
end type
type cb_1 from commandbutton within w_cm765_saldos_reservados
end type
type rb_articulo from radiobutton within w_cm765_saldos_reservados
end type
type rb_cencos from radiobutton within w_cm765_saldos_reservados
end type
type rb_ot_adm from radiobutton within w_cm765_saldos_reservados
end type
type gb_1 from groupbox within w_cm765_saldos_reservados
end type
end forward

global type w_cm765_saldos_reservados from w_report_smpl
integer width = 1760
integer height = 1520
string title = "Saldos Reservados (CM765)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
rb_articulo rb_articulo
rb_cencos rb_cencos
rb_ot_adm rb_ot_adm
gb_1 gb_1
end type
global w_cm765_saldos_reservados w_cm765_saldos_reservados

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT"
    INTO :as_doc_ot
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm765_saldos_reservados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_articulo=create rb_articulo
this.rb_cencos=create rb_cencos
this.rb_ot_adm=create rb_ot_adm
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_articulo
this.Control[iCurrent+3]=this.rb_cencos
this.Control[iCurrent+4]=this.rb_ot_adm
this.Control[iCurrent+5]=this.gb_1
end on

on w_cm765_saldos_reservados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_articulo)
destroy(this.rb_cencos)
destroy(this.rb_ot_adm)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

Long	ls_rc
String	ls_doc_ot

ls_rc = of_get_parametros(ls_doc_ot)

IF rb_articulo.checked THEN // x Articulo
	idw_1.DataObject = 'd_saldos_reservados_articulo_tbl'
ELSEIF rb_cencos.checked THEN // x Centro de Costo
	idw_1.DataObject = 'd_saldos_reservados_articulo_cc_tbl'
ELSEIF rb_ot_adm.checked THEN // x OT_ADM Y OT
	idw_1.DataObject = 'd_saldos_reservados_articulo_ot_tbl'	
END IF

idw_1.SetTransObject(SQLCA)
idw_1.Retrieve(ls_doc_ot)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM765'
//idw_1.object.t_subtitulo.text = 
end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1


end event

type dw_report from w_report_smpl`dw_report within w_cm765_saldos_reservados
integer x = 9
integer y = 164
string dataobject = "d_saldos_reservados_articulo_tbl"
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

type cb_1 from commandbutton within w_cm765_saldos_reservados
integer x = 1422
integer y = 64
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

event clicked;PARENT.Event ue_retrieve()
end event

type rb_articulo from radiobutton within w_cm765_saldos_reservados
integer x = 50
integer y = 72
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo"
boolean checked = true
end type

type rb_cencos from radiobutton within w_cm765_saldos_reservados
integer x = 347
integer y = 72
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo"
end type

type rb_ot_adm from radiobutton within w_cm765_saldos_reservados
integer x = 768
integer y = 68
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT_ADM / OT"
end type

type gb_1 from groupbox within w_cm765_saldos_reservados
integer x = 9
integer y = 4
integer width = 1184
integer height = 152
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ordenado x"
end type

