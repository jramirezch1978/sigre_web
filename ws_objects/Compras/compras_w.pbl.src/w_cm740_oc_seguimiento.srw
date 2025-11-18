$PBExportHeader$w_cm740_oc_seguimiento.srw
forward
global type w_cm740_oc_seguimiento from w_report_smpl
end type
type cb_1 from commandbutton within w_cm740_oc_seguimiento
end type
type st_1 from statictext within w_cm740_oc_seguimiento
end type
type sle_oc from u_sle_codigo within w_cm740_oc_seguimiento
end type
end forward

global type w_cm740_oc_seguimiento from w_report_smpl
integer width = 1979
integer height = 1332
string title = "OC seguimiento (CM740)"
string menuname = "m_impresion"
boolean controlmenu = false
long backcolor = 67108864
cb_1 cb_1
st_1 st_1
sle_oc sle_oc
end type
global w_cm740_oc_seguimiento w_cm740_oc_seguimiento

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

on w_cm740_oc_seguimiento.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_oc=create sle_oc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_oc
end on

on w_cm740_oc_seguimiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_oc)
end on

event ue_retrieve;call super::ue_retrieve;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

Long	ls_rc
String	ls_doc_oc

ls_rc = of_get_parametros(ls_doc_oc)

idw_1.Retrieve(ls_doc_oc, sle_oc.text)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM740'

end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False
dw_report.Object.Datawindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_cm740_oc_seguimiento
integer x = 27
integer y = 116
string dataobject = "d_oc_seguimiento_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_procesada" 
		lstr_1.DataObject = 'd_art_mov_alm_amp_tbl'
		lstr_1.Width = 4300
		lstr_1.Height= 700
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos de Ingreso Almacen'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_amp_ref"
		lstr_1.DataObject = 'd_art_mov_alm_amp_ot_tbl'
		lstr_1.Width = 3850
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'org_amp_ref')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_amp_ref'))
		lstr_1.Title = 'Movimientos Consumo del AMP'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE


end event

type cb_1 from commandbutton within w_cm740_oc_seguimiento
integer x = 914
integer y = 24
integer width = 315
integer height = 76
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

event clicked;PARENT.Event ue_retrieve()
end event

type st_1 from statictext within w_cm740_oc_seguimiento
integer x = 32
integer y = 24
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "NRO OC:"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_oc from u_sle_codigo within w_cm740_oc_seguimiento
integer x = 279
integer y = 20
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

