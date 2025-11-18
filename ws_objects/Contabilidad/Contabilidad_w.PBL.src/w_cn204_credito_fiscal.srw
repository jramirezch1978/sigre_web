$PBExportHeader$w_cn204_credito_fiscal.srw
forward
global type w_cn204_credito_fiscal from w_abc_master_smpl
end type
type sle_codrel from singlelineedit within w_cn204_credito_fiscal
end type
type sle_tipo_doc from singlelineedit within w_cn204_credito_fiscal
end type
type sle_nro_doc from singlelineedit within w_cn204_credito_fiscal
end type
type st_1 from statictext within w_cn204_credito_fiscal
end type
type st_2 from statictext within w_cn204_credito_fiscal
end type
type st_3 from statictext within w_cn204_credito_fiscal
end type
type cb_1 from commandbutton within w_cn204_credito_fiscal
end type
type gb_1 from groupbox within w_cn204_credito_fiscal
end type
end forward

global type w_cn204_credito_fiscal from w_abc_master_smpl
integer width = 3246
integer height = 1636
string title = "[CN204] Credito Fiscal "
string menuname = "m_abc_modifica"
sle_codrel sle_codrel
sle_tipo_doc sle_tipo_doc
sle_nro_doc sle_nro_doc
st_1 st_1
st_2 st_2
st_3 st_3
cb_1 cb_1
gb_1 gb_1
end type
global w_cn204_credito_fiscal w_cn204_credito_fiscal

on w_cn204_credito_fiscal.create
int iCurrent
call super::create
if this.MenuName = "m_abc_modifica" then this.MenuID = create m_abc_modifica
this.sle_codrel=create sle_codrel
this.sle_tipo_doc=create sle_tipo_doc
this.sle_nro_doc=create sle_nro_doc
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codrel
this.Control[iCurrent+2]=this.sle_tipo_doc
this.Control[iCurrent+3]=this.sle_nro_doc
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn204_credito_fiscal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codrel)
destroy(this.sle_tipo_doc)
destroy(this.sle_nro_doc)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_codrel, ls_tipo_doc, ls_nro_doc
Long ll_count
Boolean lb_ok

select count(*) into :ll_count from cntas_pagar_det ;

ii_lec_mst = 0
IF ll_count > 0 then
	// Abriendo el ultimo registro como asiento
	SELECT cod_relacion, tipo_doc, nro_doc
  	INTO :ls_codrel, :ls_tipo_doc, :ls_nro_doc
  	FROM cntas_pagar_det
 	WHERE (rowid IN (SELECT MAX(rowid) FROM cntas_pagar_det)) ;
	
	sle_codrel.text 	= ls_codrel
	sle_tipo_doc.text = ls_tipo_doc
	sle_nro_doc.text 	= ls_nro_doc
	
	dw_master.retrieve( ls_codrel, ls_tipo_doc, ls_nro_doc)
END IF;
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn204_credito_fiscal
integer y = 344
integer width = 3145
integer height = 976
string dataobject = "d_abc_credito_fiscal"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw

end event

type sle_codrel from singlelineedit within w_cn204_credito_fiscal
integer x = 585
integer y = 84
integer width = 416
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_tipo_doc from singlelineedit within w_cn204_credito_fiscal
integer x = 585
integer y = 156
integer width = 416
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_nro_doc from singlelineedit within w_cn204_credito_fiscal
integer x = 585
integer y = 232
integer width = 416
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn204_credito_fiscal
integer x = 27
integer y = 84
integer width = 539
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código de relación :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn204_credito_fiscal
integer x = 27
integer y = 160
integer width = 539
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn204_credito_fiscal
integer x = 27
integer y = 228
integer width = 539
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. documento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn204_credito_fiscal
integer x = 1285
integer y = 128
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;String ls_codrel, ls_tipo_doc, ls_nro_doc
Long ll_count

ls_codrel = sle_codrel.text
ls_tipo_doc = sle_tipo_doc.text
ls_nro_doc = sle_nro_doc.text

SELECT count(*)
INTO :ll_count
FROM cntas_pagar_det
WHERE cod_relacion = :ls_codrel 	 AND
		tipo_doc		 = :ls_tipo_doc AND
		nro_doc		 = :ls_nro_doc ;

IF ll_count = 0 THEN
	MESSAGEBOX('Aviso', 'Documento no existe')
	RETURN 
ELSE
	dw_master.retrieve( trim(ls_codrel), trim(ls_tipo_doc), trim(ls_nro_doc) )
END IF

end event

type gb_1 from groupbox within w_cn204_credito_fiscal
integer width = 1033
integer height = 328
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros de búsqueda"
end type

