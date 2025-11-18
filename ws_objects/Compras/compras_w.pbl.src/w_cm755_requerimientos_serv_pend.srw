$PBExportHeader$w_cm755_requerimientos_serv_pend.srw
forward
global type w_cm755_requerimientos_serv_pend from w_report_smpl
end type
type cb_1 from commandbutton within w_cm755_requerimientos_serv_pend
end type
type rb_fecha_estim from radiobutton within w_cm755_requerimientos_serv_pend
end type
type rb_una_ot from radiobutton within w_cm755_requerimientos_serv_pend
end type
type sle_ot from singlelineedit within w_cm755_requerimientos_serv_pend
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm755_requerimientos_serv_pend
end type
type cbx_origen from checkbox within w_cm755_requerimientos_serv_pend
end type
type ddlb_origen from u_ddlb within w_cm755_requerimientos_serv_pend
end type
type rb_fecha_aprob from radiobutton within w_cm755_requerimientos_serv_pend
end type
type rb_ot_adm from radiobutton within w_cm755_requerimientos_serv_pend
end type
type ddlb_ot_adm from u_ddlb within w_cm755_requerimientos_serv_pend
end type
type cbx_sin_os from checkbox within w_cm755_requerimientos_serv_pend
end type
type st_registros from statictext within w_cm755_requerimientos_serv_pend
end type
type st_1 from statictext within w_cm755_requerimientos_serv_pend
end type
type gb_1 from groupbox within w_cm755_requerimientos_serv_pend
end type
type gb_destino from groupbox within w_cm755_requerimientos_serv_pend
end type
end forward

global type w_cm755_requerimientos_serv_pend from w_report_smpl
integer width = 3141
integer height = 2864
string title = "Requerimientos de Servicios Pendientes (CM755)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
rb_fecha_estim rb_fecha_estim
rb_una_ot rb_una_ot
sle_ot sle_ot
uo_fecha uo_fecha
cbx_origen cbx_origen
ddlb_origen ddlb_origen
rb_fecha_aprob rb_fecha_aprob
rb_ot_adm rb_ot_adm
ddlb_ot_adm ddlb_ot_adm
cbx_sin_os cbx_sin_os
st_registros st_registros
st_1 st_1
gb_1 gb_1
gb_destino gb_destino
end type
global w_cm755_requerimientos_serv_pend w_cm755_requerimientos_serv_pend

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

on w_cm755_requerimientos_serv_pend.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_fecha_estim=create rb_fecha_estim
this.rb_una_ot=create rb_una_ot
this.sle_ot=create sle_ot
this.uo_fecha=create uo_fecha
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
this.rb_fecha_aprob=create rb_fecha_aprob
this.rb_ot_adm=create rb_ot_adm
this.ddlb_ot_adm=create ddlb_ot_adm
this.cbx_sin_os=create cbx_sin_os
this.st_registros=create st_registros
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_destino=create gb_destino
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_fecha_estim
this.Control[iCurrent+3]=this.rb_una_ot
this.Control[iCurrent+4]=this.sle_ot
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.cbx_origen
this.Control[iCurrent+7]=this.ddlb_origen
this.Control[iCurrent+8]=this.rb_fecha_aprob
this.Control[iCurrent+9]=this.rb_ot_adm
this.Control[iCurrent+10]=this.ddlb_ot_adm
this.Control[iCurrent+11]=this.cbx_sin_os
this.Control[iCurrent+12]=this.st_registros
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_destino
end on

on w_cm755_requerimientos_serv_pend.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_fecha_estim)
destroy(this.rb_una_ot)
destroy(this.sle_ot)
destroy(this.uo_fecha)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
destroy(this.rb_fecha_aprob)
destroy(this.rb_ot_adm)
destroy(this.ddlb_ot_adm)
destroy(this.cbx_sin_os)
destroy(this.st_registros)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_destino)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_cod_art, ls_almacen, ls_origen[], ls_st_origen, ls_sql
Decimal	ldec_pendiente
Long		ll_rc, ll_saldomin, ll_x, ll_row, ll_pos
Datastore	lds_saldomin

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

st_registros.text = ''

IF rb_fecha_estim.checked THEN
	IF cbx_origen.checked = False THEN
		ls_origen = ddlb_origen.ia_key //is_origen
		ls_st_origen = 'Todos los Origenes'
	ELSE
		ls_origen[1] = ddlb_origen.ia_id //ddlb_origen.text
		ls_st_origen = 'Origen:  ' + ddlb_origen.text
	END IF
	IF cbx_sin_os.checked = True THEN
		idw_1.DataObject = 'd_oper_servicios_terceros_sin_os_tbl'
	ELSE
		idw_1.DataObject = 'd_oper_servicios_terceros_tbl'
	END IF
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve( uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen)
	idw_1.object.t_fecha.text = 'Fecha Uso Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen

ELSEIF rb_fecha_aprob.checked THEN
	IF cbx_origen.checked = False THEN
		ls_origen = ddlb_origen.ia_key
		ls_st_origen = 'Todos los Origenes'
	ELSE
		ls_origen[1] = ddlb_origen.ia_id
		ls_st_origen = 'Origen:  ' + ddlb_origen.text
	END IF
	IF cbx_sin_os.checked = True THEN
		idw_1.DataObject = 'd_oper_serv_terc_fecha_aprob_sin_os_tbl'
	ELSE
		idw_1.DataObject = 'd_oper_servicios_terc_fecha_aprob_tbl'
	END IF
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen)
	idw_1.object.t_fecha.text = 'Fecha Aprobacion Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen

ELSEIF rb_una_ot.checked THEN
	idw_1.DataObject = 'd_oper_servicios_terc_pend_x_ot_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(sle_ot.text, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2())
	idw_1.object.t_fecha.text = 'OT:  ' + sle_ot.text + '  Fecha Uso Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen

ELSEIF rb_ot_adm.checked THEN
	IF cbx_origen.checked = False THEN
		ls_origen = ddlb_origen.ia_key
		ls_st_origen = 'Todos los Origenes'
	ELSE
		ls_origen[1] = ddlb_origen.ia_id
		ls_st_origen = 'Origen:  ' + ddlb_origen.text
	END IF
	idw_1.DataObject = 'd_oper_servicios_terc_pend_x_ot_adm_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve( uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen, is_ot_adm)
	idw_1.object.t_fecha.text = 'OT_ADM: ' + is_ot_adm + '   Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen
END IF

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM755'
st_registros.text = String(idw_1.RowCount())


end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

// Leer tipo doc OT, cod operacion consumo interno
ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)
end event

type dw_report from w_report_smpl`dw_report within w_cm755_requerimientos_serv_pend
integer x = 32
integer y = 372
integer width = 1454
integer height = 844
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "nro_doc_oc" 
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 3700
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'oper_sec')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
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
END CHOOSE

end event

type cb_1 from commandbutton within w_cm755_requerimientos_serv_pend
integer x = 2610
integer y = 276
integer width = 320
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

type rb_fecha_estim from radiobutton within w_cm755_requerimientos_serv_pend
integer x = 69
integer y = 76
integer width = 535
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
string text = "Fecha Estimada"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	uo_fecha.enabled = true
	sle_ot.enabled = false
	ddlb_ot_adm.enabled = false
	cbx_origen.enabled = True
	ddlb_origen.enabled = false
	gb_destino.enabled = True
	cbx_sin_os.enabled = True
	cbx_sin_os.checked = False
END IF

end event

type rb_una_ot from radiobutton within w_cm755_requerimientos_serv_pend
integer x = 69
integer y = 252
integer width = 411
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
string text = "Una Sola OT"
end type

event clicked;IF THIS.checked THEN
	uo_fecha.enabled = true
	sle_ot.enabled = true
	cbx_origen.enabled = false
	ddlb_origen.enabled = false
	gb_destino.enabled = false
	ddlb_ot_adm.enabled = false
	cbx_sin_os.enabled = False
END IF
end event

type sle_ot from singlelineedit within w_cm755_requerimientos_serv_pend
integer x = 480
integer y = 252
integer width = 347
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type uo_fecha from u_ingreso_rango_fechas within w_cm755_requerimientos_serv_pend
integer x = 805
integer y = 68
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

type cbx_origen from checkbox within w_cm755_requerimientos_serv_pend
integer x = 2185
integer y = 68
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

type ddlb_origen from u_ddlb within w_cm755_requerimientos_serv_pend
integer x = 2190
integer y = 152
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

type rb_fecha_aprob from radiobutton within w_cm755_requerimientos_serv_pend
integer x = 69
integer y = 156
integer width = 517
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
string text = "Fecha Aprobacion"
end type

event clicked;IF THIS.checked THEN
	uo_fecha.enabled = true
	sle_ot.enabled = false
	ddlb_ot_adm.enabled = false
	cbx_origen.enabled = True
	ddlb_origen.enabled = false
	gb_destino.enabled = true
	cbx_sin_os.enabled = True
	cbx_sin_os.checked = False
END IF

end event

type rb_ot_adm from radiobutton within w_cm755_requerimientos_serv_pend
integer x = 901
integer y = 256
integer width = 411
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
string text = "OT Adm"
end type

event clicked;IF THIS.checked THEN
	uo_fecha.enabled = true
	cbx_origen.enabled = true
	sle_ot.enabled = false
	ddlb_origen.enabled = false
	gb_destino.enabled = true
	ddlb_ot_adm.enabled = true
	cbx_sin_os.enabled = False
END IF
end event

type ddlb_ot_adm from u_ddlb within w_cm755_requerimientos_serv_pend
integer x = 1225
integer y = 252
integer width = 869
integer height = 556
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;Long	ll_x

is_dataobject = 'd_dddw_ot_adm'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 14                     // Longitud del campo 1
ii_lc2 = 40							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_ot_adm = aa_key
end event

type cbx_sin_os from checkbox within w_cm755_requerimientos_serv_pend
integer x = 1746
integer y = 156
integer width = 306
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sin OS"
end type

type st_registros from statictext within w_cm755_requerimientos_serv_pend
integer x = 2162
integer y = 280
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

type st_1 from statictext within w_cm755_requerimientos_serv_pend
integer x = 2395
integer y = 280
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

type gb_1 from groupbox within w_cm755_requerimientos_serv_pend
integer x = 32
integer y = 16
integer width = 2098
integer height = 344
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requerimientos de:"
end type

type gb_destino from groupbox within w_cm755_requerimientos_serv_pend
integer x = 2158
integer y = 16
integer width = 773
integer height = 240
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar Destino Por:"
end type

