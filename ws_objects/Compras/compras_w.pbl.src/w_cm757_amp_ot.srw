$PBExportHeader$w_cm757_amp_ot.srw
forward
global type w_cm757_amp_ot from w_report_smpl
end type
type sle_ot from u_sle_codigo within w_cm757_amp_ot
end type
type cb_1 from commandbutton within w_cm757_amp_ot
end type
type st_1 from statictext within w_cm757_amp_ot
end type
type st_registros from statictext within w_cm757_amp_ot
end type
type st_2 from statictext within w_cm757_amp_ot
end type
end forward

global type w_cm757_amp_ot from w_report_smpl
integer width = 2039
integer height = 1512
string title = "Requerimientos Totales x OT (CM757)"
string menuname = "m_impresion"
long backcolor = 67108864
sle_ot sle_ot
cb_1 cb_1
st_1 st_1
st_registros st_registros
st_2 st_2
end type
global w_cm757_amp_ot w_cm757_amp_ot

type variables
String 	is_doc_ot, is_doc_oc, is_oper_cons
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

on w_cm757_amp_ot.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_ot=create sle_ot
this.cb_1=create cb_1
this.st_1=create st_1
this.st_registros=create st_registros
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ot
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_registros
this.Control[iCurrent+5]=this.st_2
end on

on w_cm757_amp_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ot)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_registros)
destroy(this.st_2)
end on

event ue_open_pre;Long	ll_rc

// Leer tipo doc OT, cod operacion consumo interno
ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)


dw_report.Object.Datawindow.Print.Orientation = 1    

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//idw_1.Visible = False
end event

event ue_retrieve;call super::ue_retrieve;//idw_1.DataObject = 'd_art_mov_proy_pendiente_ot_tbl'
//idw_1.SetTransObject(SQLCA)

idw_1.Retrieve(is_doc_ot, is_oper_cons, sle_ot.text)
idw_1.object.t_fecha.text = 'OT:  ' + sle_ot.text

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM757'
st_registros.text = String(idw_1.RowCount())



end event

type dw_report from w_report_smpl`dw_report within w_cm757_amp_ot
integer x = 14
integer y = 120
string dataobject = "d_amp_ot_total_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "nro_doc_oc" 
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'cod_origen')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "cant_procesada"
		lstr_1.DataObject = 'd_art_mov_alm_amp_ot_tbl'
		lstr_1.Width = 3850
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Consumo del AMP'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
END CHOOSE

end event

type sle_ot from u_sle_codigo within w_cm757_amp_ot
integer x = 169
integer y = 32
integer width = 347
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type cb_1 from commandbutton within w_cm757_amp_ot
integer x = 1390
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

type st_1 from statictext within w_cm757_amp_ot
integer x = 1157
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

type st_registros from statictext within w_cm757_amp_ot
integer x = 928
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

type st_2 from statictext within w_cm757_amp_ot
integer x = 37
integer y = 36
integer width = 96
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT:"
boolean focusrectangle = false
end type

