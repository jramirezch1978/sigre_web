$PBExportHeader$w_fi751_rpt_doc_x_cobrar_sin_ref.srw
forward
global type w_fi751_rpt_doc_x_cobrar_sin_ref from w_rpt
end type
type dw_origen from datawindow within w_fi751_rpt_doc_x_cobrar_sin_ref
end type
type st_1 from statictext within w_fi751_rpt_doc_x_cobrar_sin_ref
end type
type cb_1 from commandbutton within w_fi751_rpt_doc_x_cobrar_sin_ref
end type
type dw_report from u_dw_rpt within w_fi751_rpt_doc_x_cobrar_sin_ref
end type
type gb_1 from groupbox within w_fi751_rpt_doc_x_cobrar_sin_ref
end type
end forward

global type w_fi751_rpt_doc_x_cobrar_sin_ref from w_rpt
integer width = 3008
integer height = 1948
string title = "[FI751] Reporte de Cntas x Cobrar Cancelados Sin Referencia"
string menuname = "m_reporte_filter"
long backcolor = 12632256
dw_origen dw_origen
st_1 st_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi751_rpt_doc_x_cobrar_sin_ref w_fi751_rpt_doc_x_cobrar_sin_ref

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_fi751_rpt_doc_x_cobrar_sin_ref.create
int iCurrent
call super::create
if this.MenuName = "m_reporte_filter" then this.MenuID = create m_reporte_filter
this.dw_origen=create dw_origen
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_origen
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi751_rpt_doc_x_cobrar_sin_ref.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_origen)
destroy(this.st_1)
destroy(this.cb_1)
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

event ue_retrieve;call super::ue_retrieve;String ls_origen,ls_mensaje,ls_flag

dw_origen.Accepttext()

ls_flag   = dw_origen.object.flag		 [1]

if ls_flag = '1' then
	ls_origen = '%'	
else
	ls_origen = dw_origen.object.cod_origen [1] + '%'
	
	if isnull(ls_origen) or trim(ls_origen) = '' then
		Messagebox('Aviso','Debe Ingresar Codigo de Origen,Verifique!')
		Return
	end if
end if

dw_report.retrieve(ls_origen)
end event

type dw_origen from datawindow within w_fi751_rpt_doc_x_cobrar_sin_ref
integer x = 334
integer y = 104
integer width = 1399
integer height = 84
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

type st_1 from statictext within w_fi751_rpt_doc_x_cobrar_sin_ref
integer x = 96
integer y = 116
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Origen :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi751_rpt_doc_x_cobrar_sin_ref
integer x = 2048
integer y = 72
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fi751_rpt_doc_x_cobrar_sin_ref
integer x = 27
integer y = 276
integer width = 2926
integer height = 1456
string dataobject = "d_rpt_doc_x_cobrar_sin_ref"
boolean hscrollbar = true
boolean vscrollbar = true
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
		
		UPDATE CNTAS_cobrar CP 
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

type gb_1 from groupbox within w_fi751_rpt_doc_x_cobrar_sin_ref
integer x = 32
integer y = 32
integer width = 1737
integer height = 188
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Ingrese Datos"
end type

