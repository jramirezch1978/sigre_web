$PBExportHeader$w_cm712_oc_tipo_ref.srw
forward
global type w_cm712_oc_tipo_ref from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm712_oc_tipo_ref
end type
type cb_3 from commandbutton within w_cm712_oc_tipo_ref
end type
end forward

global type w_cm712_oc_tipo_ref from w_report_smpl
integer width = 3177
integer height = 1504
string title = "Orden de Compra - Referencia (CM712)"
string menuname = "m_impresion"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
end type
global w_cm712_oc_tipo_ref w_cm712_oc_tipo_ref

type variables
String is_doc_oc

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

on w_cm712_oc_tipo_ref.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_cm712_oc_tipo_ref.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

event ue_open_pre;call super::ue_open_pre;of_get_parametros(is_doc_oc)

if IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then return

If Message.PowerObjectParm.Classname( ) <> 'str_parametros' then return

istr_rep = message.powerobjectparm
This.Title = istr_rep.titulo
idw_1.dataobject = istr_rep.dw1
idw_1.SetTransObject(SQLCA)
end event

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

idw_1.Retrieve(ld_desde, ld_hasta, is_doc_oc)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_codigo.text   = dw_report.dataobject
idw_1.object.t_fecha.text    = string(ld_desde, 'dd/mm/yyyy') + ' AL ' + string(ld_hasta, 'dd/mm/yyyy')

end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

type dw_report from w_report_smpl`dw_report within w_cm712_oc_tipo_ref
integer x = 9
integer y = 152
integer width = 1701
integer height = 1100
string dataobject = "d_rpt_oc_tipo_ref_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm712_oc_tipo_ref
integer x = 14
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm712_oc_tipo_ref
integer x = 2651
integer y = 8
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.Event ue_retrieve()
end event

