$PBExportHeader$w_cm724_doc_compra_sin_vobo.srw
forward
global type w_cm724_doc_compra_sin_vobo from w_report_smpl
end type
type cb_1 from commandbutton within w_cm724_doc_compra_sin_vobo
end type
type rb_oc from radiobutton within w_cm724_doc_compra_sin_vobo
end type
type rb_os from radiobutton within w_cm724_doc_compra_sin_vobo
end type
type cb_2 from commandbutton within w_cm724_doc_compra_sin_vobo
end type
type cb_3 from commandbutton within w_cm724_doc_compra_sin_vobo
end type
type cb_4 from commandbutton within w_cm724_doc_compra_sin_vobo
end type
type cbx_compra from checkbox within w_cm724_doc_compra_sin_vobo
end type
type cbx_user from checkbox within w_cm724_doc_compra_sin_vobo
end type
type cbx_proc from checkbox within w_cm724_doc_compra_sin_vobo
end type
type gb_1 from groupbox within w_cm724_doc_compra_sin_vobo
end type
type gb_2 from groupbox within w_cm724_doc_compra_sin_vobo
end type
end forward

global type w_cm724_doc_compra_sin_vobo from w_report_smpl
integer width = 2999
integer height = 1644
string title = "(CM724) Documentos de compra sin VoBo"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
rb_oc rb_oc
rb_os rb_os
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cbx_compra cbx_compra
cbx_user cbx_user
cbx_proc cbx_proc
gb_1 gb_1
gb_2 gb_2
end type
global w_cm724_doc_compra_sin_vobo w_cm724_doc_compra_sin_vobo

type variables
String	is_dw = 'D'
end variables

on w_cm724_doc_compra_sin_vobo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_oc=create rb_oc
this.rb_os=create rb_os
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cbx_compra=create cbx_compra
this.cbx_user=create cbx_user
this.cbx_proc=create cbx_proc
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_oc
this.Control[iCurrent+3]=this.rb_os
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.cbx_compra
this.Control[iCurrent+8]=this.cbx_user
this.Control[iCurrent+9]=this.cbx_proc
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_cm724_doc_compra_sin_vobo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_oc)
destroy(this.rb_os)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cbx_compra)
destroy(this.cbx_user)
destroy(this.cbx_proc)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_tipo_os

IF rb_oc.Checked then //Rango de Fechas
	idw_1.DataObject = 'd_rpt_oc_sin_vobo_tbl'
	idw_1.SetTransObject(SQLCA)
	IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')		
	idw_1.Retrieve()
ELSE
	// X USUARIO
	IF cbx_user.checked THEN 
		ls_tipo_os='0'
	// Por comprador
	ELSEIF cbx_compra.checked THEN
		ls_tipo_os='1'		
	// Por proceso
	ELSEIF cbx_proc.checked THEN
		ls_tipo_os='2'
	END IF 
	idw_1.DataObject = 'd_rpt_os_sin_vobo_tbl'
	idw_1.SetTransObject(SQLCA)
	IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')	
	idw_1.Retrieve(ls_tipo_os)
END IF 

//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')
//
//idw_1.Retrieve()
//
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_empresa.text 	= gs_empresa
idw_1.object.t_user.text 		= gs_user
idw_1.Visible = True



end event

event ue_open_pre;call super::ue_open_pre;idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Object.DataWindow.Print.Paper.Size = 9


end event

type dw_report from w_report_smpl`dw_report within w_cm724_doc_compra_sin_vobo
integer x = 0
integer y = 380
integer width = 2903
integer height = 1008
integer taborder = 60
string dataobject = "d_rpt_oc_sin_vobo_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;str_parametros lstr_rep

IF dw_report.RowCount() = 0 THEN Return

// Formato de orden de compra
IF rb_oc.checked THEN
		lstr_rep.string1 = dw_report.object.cod_origen[dw_report.getrow()]
		lstr_rep.string2 = dw_report.object.nro_oc[dw_report.getrow()]
		
		OpenSheetWithParm(w_cm311_orden_compra_frm, lstr_rep, w_main, 2, Layered!)
END IF

// Formato de Orden de Servicio
IF rb_os.checked THEN
	lstr_rep.string1 = dw_report.object.cod_origen[dw_report.getrow()]
	lstr_rep.string2 = dw_report.object.nro_os[dw_report.getrow()]
	OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, w_main, 2, layered!)
END IF 


end event

type cb_1 from commandbutton within w_cm724_doc_compra_sin_vobo
integer x = 773
integer y = 120
integer width = 402
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()

end event

type rb_oc from radiobutton within w_cm724_doc_compra_sin_vobo
integer x = 50
integer y = 92
integer width = 539
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de compra"
boolean checked = true
end type

event clicked;cbx_compra.enabled = false
cbx_user.enabled = false
cbx_proc.enabled = false
cbx_compra.checked = false
cbx_user.checked = false
cbx_proc.checked = false
end event

type rb_os from radiobutton within w_cm724_doc_compra_sin_vobo
integer x = 50
integer y = 176
integer width = 549
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Servicio"
end type

event clicked;cbx_compra.enabled = true
cbx_user.enabled = true
cbx_proc.enabled = true
end event

type cb_2 from commandbutton within w_cm724_doc_compra_sin_vobo
integer x = 1531
integer y = 128
integer width = 357
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select all"
end type

event clicked;Long i
IF dw_report.RowCount()=0 THEN Return

FOR i=1 TO dw_report.RowCount() 
	dw_report.object.flag_estado[i]='1'
NEXT

end event

type cb_3 from commandbutton within w_cm724_doc_compra_sin_vobo
integer x = 1911
integer y = 124
integer width = 366
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Unselect all"
end type

event clicked;Long i
IF dw_report.RowCount()=0 THEN Return

FOR i=1 TO dw_report.RowCount() 
	dw_report.object.flag_estado[i]='3'
NEXT

end event

type cb_4 from commandbutton within w_cm724_doc_compra_sin_vobo
integer x = 2299
integer y = 124
integer width = 357
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aprueba"
end type

event clicked;Long i
String ls_tipo_doc, ls_origen, ls_nro_doc, ls_msj

IF dw_report.RowCount()=0 THEN Return

IF rb_oc.checked THEN
	SELECT doc_oc INTO :ls_tipo_doc FROM logparam WHERE reckey='1' ;
ELSE
	SELECT doc_os INTO :ls_tipo_doc FROM logparam WHERE reckey='1' ;	
END IF 

FOR i=1 TO dw_report.RowCount() 

	// Solo aprueba los marcados correctamente
	IF dw_report.object.flag_estado[i] = '1' THEN 
		ls_origen  = dw_report.object.cod_origen[i]
		ls_nro_doc = dw_report.object.nro_oc[i]
		
		DECLARE pb_usp_cmp_vobo_doc_compra PROCEDURE FOR 
		usp_cmp_vobo_doc_compra ( :ls_tipo_doc, 
										  :ls_origen, 
										  :ls_nro_doc, 	
										  :gs_user ) ;
		
		EXECUTE pb_usp_cmp_vobo_doc_compra ;
	
		IF sqlca.sqlcode = -1 THEN
			ls_msj = sqlca.sqlerrtext
			ROLLBACK ;
			MessageBox( 'Error usp_cmp_vobo_doc_compra', ls_msj, StopSign! )
			return
		END IF 
		Close pb_usp_cmp_vobo_doc_compra;
		
	END IF 
NEXT

MessageBox( 'Aviso','Proceso termino correctamente' )
dw_report.reset()
return


end event

type cbx_compra from checkbox within w_cm724_doc_compra_sin_vobo
integer x = 1527
integer y = 248
integer width = 352
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Compra"
end type

event clicked;cbx_user.checked=false
cbx_proc.checked=false
end event

type cbx_user from checkbox within w_cm724_doc_compra_sin_vobo
integer x = 1938
integer y = 248
integer width = 352
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "x usuario"
end type

event clicked;cbx_compra.checked=false
cbx_proc.checked=false
end event

type cbx_proc from checkbox within w_cm724_doc_compra_sin_vobo
integer x = 2327
integer y = 248
integer width = 352
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "x proceso"
end type

event clicked;cbx_compra.checked=false
cbx_user.checked=false
end event

type gb_1 from groupbox within w_cm724_doc_compra_sin_vobo
integer x = 18
integer y = 20
integer width = 622
integer height = 252
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

type gb_2 from groupbox within w_cm724_doc_compra_sin_vobo
integer x = 1490
integer y = 48
integer width = 1202
integer height = 300
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones para aprobar"
end type

