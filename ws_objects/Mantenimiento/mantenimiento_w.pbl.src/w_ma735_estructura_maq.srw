$PBExportHeader$w_ma735_estructura_maq.srw
forward
global type w_ma735_estructura_maq from w_report_smpl
end type
type cb_1 from commandbutton within w_ma735_estructura_maq
end type
type st_1 from statictext within w_ma735_estructura_maq
end type
type st_registros from statictext within w_ma735_estructura_maq
end type
end forward

global type w_ma735_estructura_maq from w_report_smpl
integer width = 3104
integer height = 1692
string title = "Estructura de Maquina (MA735)"
string menuname = "m_impresion"
cb_1 cb_1
st_1 st_1
st_registros st_registros
end type
global w_ma735_estructura_maq w_ma735_estructura_maq

type variables
String 	is_articulo
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

on w_ma735_estructura_maq.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.st_registros=create st_registros
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_registros
end on

on w_ma735_estructura_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_registros)
end on

event ue_open_pre;Long	ll_rc


idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//idw_1.Visible = False
end event

event ue_retrieve;call super::ue_retrieve;
ib_preview = false
event ue_preview()

idw_1.Retrieve()


idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_nombre.text 	= gs_empresa
idw_1.object.t_user.text 		= gs_user
idw_1.object.t_objeto.text 	= 'MA730'

st_registros.text = String(idw_1.RowCount())



end event

type dw_report from w_report_smpl`dw_report within w_ma735_estructura_maq
integer x = 0
integer y = 112
integer width = 3040
integer height = 1304
string dataobject = "d_maq_estructura_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//
//CHOOSE CASE dwo.Name
//	CASE "nro_doc_oc" 
//		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
//		lstr_1.Width = 3800
//		lstr_1.Height= 900
//		lstr_1.Arg[1] = is_doc_oc
//		lstr_1.Arg[2] = GetItemString(row,'cod_origen')
//		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_mov'))
//		lstr_1.Title = 'OC Asociadas a este Requerimiento'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)
//	CASE "cant_procesada"
//		lstr_1.DataObject = 'd_art_mov_alm_amp_ot_tbl'
//		lstr_1.Width = 3850
//		lstr_1.Height= 1000
//		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
//		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
//		lstr_1.Title = 'Movimientos Consumo del AMP'
//		lstr_1.Tipo_Cascada = 'C'
//		of_new_sheet(lstr_1)	
//END CHOOSE

end event

type cb_1 from commandbutton within w_ma735_estructura_maq
integer x = 2761
integer y = 28
integer width = 238
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;
//IF cbx_origen.enabled AND cbx_origen.checked THEN
//	IF ddlb_origen.text = "" THEN
//		MessageBox('Error', 'Tiene que seleccionar Origen')
//		RETURN
//	END IF
//END IF

PARENT.Event ue_retrieve()
end event

type st_1 from statictext within w_ma735_estructura_maq
integer x = 2528
integer y = 28
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

type st_registros from statictext within w_ma735_estructura_maq
integer x = 2299
integer y = 28
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

