$PBExportHeader$w_sig756_compras_importantes.srw
forward
global type w_sig756_compras_importantes from w_report_smpl
end type
type cb_1 from commandbutton within w_sig756_compras_importantes
end type
type uo_fecha from u_ingreso_rango_fechas within w_sig756_compras_importantes
end type
type cbx_origen from checkbox within w_sig756_compras_importantes
end type
type ddlb_origen from u_ddlb within w_sig756_compras_importantes
end type
type rb_articulos from radiobutton within w_sig756_compras_importantes
end type
type rb_prov_oc from radiobutton within w_sig756_compras_importantes
end type
type rb_prov_os from radiobutton within w_sig756_compras_importantes
end type
type rb_comp_oc from radiobutton within w_sig756_compras_importantes
end type
type rb_comp_os from radiobutton within w_sig756_compras_importantes
end type
type gb_1 from groupbox within w_sig756_compras_importantes
end type
end forward

global type w_sig756_compras_importantes from w_report_smpl
integer width = 3662
integer height = 1620
string title = "Compras x Articulo Proveedor  (SIG756)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
cbx_origen cbx_origen
ddlb_origen ddlb_origen
rb_articulos rb_articulos
rb_prov_oc rb_prov_oc
rb_prov_os rb_prov_os
rb_comp_oc rb_comp_oc
rb_comp_os rb_comp_os
gb_1 gb_1
end type
global w_sig756_compras_importantes w_sig756_compras_importantes

type variables
String	is_doc_oc, is_cod_dol, is_origen[]
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_oc, ref string as_cod_dol)
end prototypes

public function integer of_get_parametros (ref string as_doc_oc, ref string as_cod_dol);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OC", "LOGPARAM"."COD_DOLARES"
    INTO :as_doc_oc, :as_cod_dol
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_sig756_compras_importantes.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
this.rb_articulos=create rb_articulos
this.rb_prov_oc=create rb_prov_oc
this.rb_prov_os=create rb_prov_os
this.rb_comp_oc=create rb_comp_oc
this.rb_comp_os=create rb_comp_os
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.ddlb_origen
this.Control[iCurrent+5]=this.rb_articulos
this.Control[iCurrent+6]=this.rb_prov_oc
this.Control[iCurrent+7]=this.rb_prov_os
this.Control[iCurrent+8]=this.rb_comp_oc
this.Control[iCurrent+9]=this.rb_comp_os
this.Control[iCurrent+10]=this.gb_1
end on

on w_sig756_compras_importantes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
destroy(this.rb_articulos)
destroy(this.rb_prov_oc)
destroy(this.rb_prov_os)
destroy(this.rb_comp_oc)
destroy(this.rb_comp_os)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_st_origen, ls_origen[]

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

// Determinar Origen
IF cbx_origen.checked = False THEN
	ls_origen = ddlb_origen.ia_key //is_origen
	ls_st_origen = 'Todos los Origenes'
ELSE
	ls_origen[1] = ddlb_origen.ia_id //ddlb_origen.text
	ls_st_origen = 'Origen:  ' + ddlb_origen.text
END IF

// Determinar Formato
IF rb_articulos.checked THEN // x Articulos
	idw_1.DataObject = 'd_oc_mas_compradas_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(is_doc_oc, is_cod_dol, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen )
ELSEIF rb_prov_oc.checked THEN // x Proveedores OC
	idw_1.DataObject = 'd_oc_prov_compradas_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(is_doc_oc, is_cod_dol, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen )
ELSEIF rb_prov_os.checked THEN // x Proveedores OS
	idw_1.DataObject = 'd_oc_prov_os_compradas_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(is_cod_dol, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen )
ELSEIF rb_comp_oc.checked THEN // x Comprador OC
	idw_1.DataObject = 'd_oc_usr_compradas_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(is_doc_oc, is_cod_dol, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen )
ELSEIF rb_comp_os.checked THEN // x Comprador OS
	idw_1.DataObject = 'd_oc_usr_os_compradas_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(is_cod_dol, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_origen )
END IF


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM756'
idw_1.object.t_subtitulo.text = ' Origen: ' + ls_st_origen + &
                                ' Desde: ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yyyy') + &
                                ' Hasta: ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yyyy')
                                
end event

event ue_open_pre;call super::ue_open_pre;of_get_parametros(is_doc_oc, is_cod_dol)
end event

type dw_report from w_report_smpl`dw_report within w_sig756_compras_importantes
integer x = 14
integer y = 228
string dataobject = "d_oc_mas_compradas_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1
DebugBreak()
CHOOSE CASE dwo.Name
	CASE "imp_dol"
		IF rb_articulos.checked THEN
			IF cbx_origen.checked THEN
				lstr_1.DataObject = 'd_oc_articulo_org_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'cod_art')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
				lstr_1.Arg[6] = ddlb_origen.ia_id
			ELSE
				lstr_1.DataObject = 'd_oc_articulo_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'cod_art')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
			END IF
			lstr_1.Width = 4600
			lstr_1.Height= 1600
			lstr_1.Title = 'Compras por Articulo'
			lstr_1.Tipo_Cascada = 'R'
			of_new_sheet(lstr_1)	
		ELSEIF rb_prov_oc.checked THEN
			IF cbx_origen.checked THEN
				lstr_1.DataObject = 'd_oc_proveedor_org_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'proveedor')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
				lstr_1.Arg[6] = ddlb_origen.ia_id
			ELSE
				lstr_1.DataObject = 'd_oc_proveedor_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'proveedor')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
			END IF
			lstr_1.Width = 4600
			lstr_1.Height= 1600
			lstr_1.Title = 'Compras por Proveedor'
			lstr_1.Tipo_Cascada = 'R'
			of_new_sheet(lstr_1)
		ELSEIF rb_prov_os.checked THEN
			IF cbx_origen.checked THEN
				lstr_1.DataObject = 'd_os_proveedor_org_tbl'
				lstr_1.Arg[1] = GetItemString(row,'proveedor')
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha2())
				lstr_1.Arg[5] = ddlb_origen.ia_id
			ELSE
				lstr_1.DataObject = 'd_os_proveedor_tbl'
				lstr_1.Arg[1] = GetItemString(row,'proveedor')
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha2())
			END IF
			lstr_1.Width = 4600
			lstr_1.Height= 1600
			lstr_1.Title = 'Compras por Proveedor'
			lstr_1.Tipo_Cascada = 'R'
			of_new_sheet(lstr_1)				
		ELSEIF rb_comp_oc.checked THEN
			IF cbx_origen.checked THEN
				lstr_1.DataObject = 'd_oc_usr_org_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'cod_usr')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
				lstr_1.Arg[6] = ddlb_origen.ia_id
			ELSE
				lstr_1.DataObject = 'd_oc_usuario_tbl'
				lstr_1.Arg[1] = is_doc_oc
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = GetItemString(row,'cod_usr')
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[5] = String(uo_fecha.of_get_fecha2())
			END IF
			lstr_1.Width = 4600
			lstr_1.Height= 1600
			lstr_1.Title = 'Compras por Comprador'
			lstr_1.Tipo_Cascada = 'R'
			of_new_sheet(lstr_1)
	 	ELSEIF rb_comp_os.checked THEN
			IF cbx_origen.checked THEN
				lstr_1.DataObject = 'd_os_comprador_org_tbl'
				lstr_1.Arg[1] = GetItemString(row,'cod_usr')
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha2())
				lstr_1.Arg[5] = ddlb_origen.ia_id
			ELSE
				lstr_1.DataObject = 'd_os_comprador_tbl'
				lstr_1.Arg[1] = GetItemString(row,'cod_usr')
				lstr_1.Arg[2] = is_cod_dol
				lstr_1.Arg[3] = String(uo_fecha.of_get_fecha1())
				lstr_1.Arg[4] = String(uo_fecha.of_get_fecha2())
			END IF
			lstr_1.Width = 4600
			lstr_1.Height= 1600
			lstr_1.Title = 'Compras por Proveedor'
			lstr_1.Tipo_Cascada = 'R'
			of_new_sheet(lstr_1)					
	 END IF
END CHOOSE

end event

type cb_1 from commandbutton within w_sig756_compras_importantes
integer x = 2889
integer y = 32
integer width = 261
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

type uo_fecha from u_ingreso_rango_fechas within w_sig756_compras_importantes
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

type cbx_origen from checkbox within w_sig756_compras_importantes
integer x = 9
integer y = 124
integer width = 256
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
string text = "Origen"
end type

event clicked;IF THIS.checked THEN
	ddlb_origen.enabled = true
ELSE
	ddlb_origen.enabled = false
END IF
end event

type ddlb_origen from u_ddlb within w_sig756_compras_importantes
integer x = 283
integer y = 120
integer width = 718
integer height = 352
integer taborder = 30
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

type rb_articulos from radiobutton within w_sig756_compras_importantes
integer x = 1339
integer y = 64
integer width = 343
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
string text = "Articulos"
boolean checked = true
end type

type rb_prov_oc from radiobutton within w_sig756_compras_importantes
integer x = 1691
integer y = 64
integer width = 507
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
string text = "Proveedores OC"
end type

type rb_prov_os from radiobutton within w_sig756_compras_importantes
integer x = 1691
integer y = 124
integer width = 507
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
string text = "Proveedores OS"
end type

type rb_comp_oc from radiobutton within w_sig756_compras_importantes
integer x = 2231
integer y = 64
integer width = 494
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
string text = "Comprador OC"
end type

type rb_comp_os from radiobutton within w_sig756_compras_importantes
integer x = 2231
integer y = 124
integer width = 494
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
string text = "Comprador OS"
end type

type gb_1 from groupbox within w_sig756_compras_importantes
integer x = 1317
integer y = 4
integer width = 1435
integer height = 204
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato"
end type

