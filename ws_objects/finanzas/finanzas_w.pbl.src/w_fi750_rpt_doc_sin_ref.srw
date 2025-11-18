$PBExportHeader$w_fi750_rpt_doc_sin_ref.srw
forward
global type w_fi750_rpt_doc_sin_ref from w_rpt
end type
type em_descripcion from editmask within w_fi750_rpt_doc_sin_ref
end type
type cb_origen from commandbutton within w_fi750_rpt_doc_sin_ref
end type
type em_origen from editmask within w_fi750_rpt_doc_sin_ref
end type
type cbx_origen from checkbox within w_fi750_rpt_doc_sin_ref
end type
type cb_retrieve from commandbutton within w_fi750_rpt_doc_sin_ref
end type
type dw_report from u_dw_rpt within w_fi750_rpt_doc_sin_ref
end type
type gb_1 from groupbox within w_fi750_rpt_doc_sin_ref
end type
end forward

global type w_fi750_rpt_doc_sin_ref from w_rpt
integer width = 3008
integer height = 1948
string title = "[FI750] Reporte de Documentos Cancelados Sin Referencia"
string menuname = "m_reporte_filter"
em_descripcion em_descripcion
cb_origen cb_origen
em_origen em_origen
cbx_origen cbx_origen
cb_retrieve cb_retrieve
dw_report dw_report
gb_1 gb_1
end type
global w_fi750_rpt_doc_sin_ref w_fi750_rpt_doc_sin_ref

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_fi750_rpt_doc_sin_ref.create
int iCurrent
call super::create
if this.MenuName = "m_reporte_filter" then this.MenuID = create m_reporte_filter
this.em_descripcion=create em_descripcion
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.cbx_origen=create cbx_origen
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.cb_origen
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cbx_origen
this.Control[iCurrent+5]=this.cb_retrieve
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi750_rpt_doc_sin_ref.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_descripcion)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.cbx_origen)
destroy(this.cb_retrieve)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = true
THIS.Event ue_preview()


end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_mensaje

if cbx_origen.checked then
	ls_origen = '%%'
else
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debe especificar un ORIGEN, por favor corrija', StopSign!)
		em_origen.setFocus()
		return
	end if
	
	ls_origen = trim(em_origen.text) + '%'
end if

dw_report.retrieve(ls_origen)
end event

type em_descripcion from editmask within w_fi750_rpt_doc_sin_ref
integer x = 951
integer y = 76
integer width = 1065
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_fi750_rpt_doc_sin_ref
integer x = 841
integer y = 76
integer width = 87
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

type em_origen from editmask within w_fi750_rpt_doc_sin_ref
integer x = 549
integer y = 76
integer width = 270
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_descripcion.text = ls_null
end if

em_descripcion.text = ls_data


end event

type cbx_origen from checkbox within w_fi750_rpt_doc_sin_ref
integer x = 32
integer y = 72
integer width = 494
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los origenes"
boolean checked = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	em_origen.enabled = false
	cb_origen.enabled = false
else
	em_origen.enabled = true
	cb_origen.enabled = true
end if
end event

type cb_retrieve from commandbutton within w_fi750_rpt_doc_sin_ref
integer x = 2039
integer y = 56
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Consultar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fi750_rpt_doc_sin_ref
integer y = 228
integer width = 2926
integer height = 1456
string dataobject = "d_rpt_doc_sin_ref"
end type

event buttonclicked;call super::buttonclicked;String ls_prov, ls_tipo_doc, ls_nro_doc, ls_cod_mon
Decimal{4} ld_tc, ld_importe_doc, ld_saldo_sol, ld_saldo_dol

CHOOSE CASE lower(dwo.name)
		
	CASE "b_recup"

		ls_prov 				= this.object.cod_relacion	[row]
		ls_tipo_doc 			= this.object.tipo_doc			[row]
		ls_nro_doc			= this.object.nro_doc			[row]
		ls_cod_mon			= this.object.cod_moneda	[row]
		ld_importe_doc		= this.object.importe_doc	[row]
		ld_tc					= this.object.tasa_cambio	[row]
		
		IF ls_cod_mon = 'US$' THEN
			ld_saldo_dol = ld_importe_doc
			ld_saldo_sol = ld_importe_doc * ld_tc
		ELSEIF ls_cod_mon = 'S/.' THEN
			ld_saldo_sol = ld_importe_doc
			ld_saldo_dol = ld_importe_doc / ld_tc
		END IF
		
		UPDATE CNTAS_PAGAR CP 
				 SET CP.SALDO_SOL = :ld_saldo_sol, CP.SALDO_DOL = :ld_saldo_dol, CP.flag_estado = 1
				 WHERE CP.COD_RELACION = :ls_prov AND
						 CP.TIPO_DOC     = :ls_tipo_doc AND
						 CP.NRO_DOC      = :ls_nro_doc ;

		IF SQLCA.SQlCode = 100 THEN
			ROLLBACK;
			MessageBox("Error", "No se pudo Recuperar el Documento")
		ELSEIF SQLCA.SQlCode = 0 THEN
			MessageBox("Aviso", "El Documento se Recuperó Satisfactoriamente")
			COMMIT;
		END IF
				
		Parent.Event ue_retrieve()
		
END CHOOSE
end event

type gb_1 from groupbox within w_fi750_rpt_doc_sin_ref
integer width = 2697
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ingrese Datos"
end type

