$PBExportHeader$w_cm753_atencion_requerimientos.srw
forward
global type w_cm753_atencion_requerimientos from w_report_smpl
end type
type cb_1 from commandbutton within w_cm753_atencion_requerimientos
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm753_atencion_requerimientos
end type
type cbx_origen from checkbox within w_cm753_atencion_requerimientos
end type
type ddlb_origen from u_ddlb within w_cm753_atencion_requerimientos
end type
end forward

global type w_cm753_atencion_requerimientos from w_report_smpl
integer width = 3291
integer height = 1604
string title = "Atencion Req Materiales (CM753)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
cbx_origen cbx_origen
ddlb_origen ddlb_origen
end type
global w_cm753_atencion_requerimientos w_cm753_atencion_requerimientos

type variables
String is_doc_ot, is_doc_oc, is_oper_cons, is_origen[], is_ot_adm
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

on w_cm753_atencion_requerimientos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.ddlb_origen
end on

on w_cm753_atencion_requerimientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_origen[], ls_st_origen
Long		ll_rc


IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

IF cbx_origen.checked = False THEN
	ls_origen = ddlb_origen.ia_key //is_origen
	ls_st_origen = 'Todos los Origenes'
ELSE
	ls_origen[1] = ddlb_origen.ia_id //ddlb_origen.text
	ls_st_origen = 'Origen:  ' + ddlb_origen.text
END IF
		

idw_1.Retrieve(is_doc_ot, is_oper_cons, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen)

idw_1.object.t_fecha.text = 'Fecha De Aprobacion :  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_objeto.text   = 'CM753'
end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

// Leer tipo doc OT, cod operacion consumo interno
ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)


end event

type dw_report from w_report_smpl`dw_report within w_cm753_atencion_requerimientos
integer x = 14
integer y = 136
integer width = 1454
integer height = 844
string dataobject = "d_art_mov_proy_atencion_tbl"
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
	CASE "articulo_almacen_sldo_total" 
		lstr_1.DataObject = 'd_art_mov_almacen_tbl'
		lstr_1.Width = 2850
		lstr_1.Height= 900
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Arg[2] = GetItemString(row,'almacen')
		lstr_1.Title = 'Ultimos Movimientos del Articulo en este Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "nro_doc" 
		lstr_1.DataObject = 'd_amp_pendiente_ot_cascada_tbl'
		lstr_1.Width = 3750
		lstr_1.Height= 1000
		lstr_1.Arg[1] = is_doc_ot
		lstr_1.Arg[2] = is_doc_oc
		lstr_1.Arg[3] = is_oper_cons
		lstr_1.Arg[4] = GetItemString(row,'nro_doc')
		lstr_1.Title = 'Movimientos Pendientes por OT'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "fec_proyect" 
		lstr_1.DataObject = 'd_articulo_desc_ff'
		lstr_1.Width = 3200
		lstr_1.Height= 700		
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Datos del Articulo'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_cm753_atencion_requerimientos
integer x = 2519
integer y = 8
integer width = 315
integer height = 80
integer taborder = 40
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

type uo_fecha from u_ingreso_rango_fechas within w_cm753_atencion_requerimientos
integer x = 14
integer y = 12
integer taborder = 30
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

type cbx_origen from checkbox within w_cm753_atencion_requerimientos
integer x = 1394
integer y = 12
integer width = 375
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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

type ddlb_origen from u_ddlb within w_cm753_atencion_requerimientos
integer x = 1678
integer y = 16
integer width = 718
integer height = 352
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;Long	ll_x

is_dataobject = 'd_dddw_origen'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 20							// Longitud del campo 2


end event

event constructor;call super::constructor;Long	ll_x

FOR ll_x = 1 TO THIS.ids_data.RowCount()
	is_origen[ll_x] = ids_data.GetItemString(ll_x, 'cod_origen')
NEXT

end event

