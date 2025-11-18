$PBExportHeader$w_fi510_cns_doc_x_plla_cobranza.srw
forward
global type w_fi510_cns_doc_x_plla_cobranza from w_cns
end type
type st_3 from statictext within w_fi510_cns_doc_x_plla_cobranza
end type
type st_2 from statictext within w_fi510_cns_doc_x_plla_cobranza
end type
type st_1 from statictext within w_fi510_cns_doc_x_plla_cobranza
end type
type sle_nro_doc from singlelineedit within w_fi510_cns_doc_x_plla_cobranza
end type
type sle_tipo_doc from singlelineedit within w_fi510_cns_doc_x_plla_cobranza
end type
type pb_1 from picturebutton within w_fi510_cns_doc_x_plla_cobranza
end type
type dw_1 from u_dw_cns within w_fi510_cns_doc_x_plla_cobranza
end type
type gb_1 from groupbox within w_fi510_cns_doc_x_plla_cobranza
end type
end forward

global type w_fi510_cns_doc_x_plla_cobranza from w_cns
integer width = 3072
integer height = 1324
string title = "(FI510) Documentos en planillas de cobranza"
st_3 st_3
st_2 st_2
st_1 st_1
sle_nro_doc sle_nro_doc
sle_tipo_doc sle_tipo_doc
pb_1 pb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_fi510_cns_doc_x_plla_cobranza w_fi510_cns_doc_x_plla_cobranza

on w_fi510_cns_doc_x_plla_cobranza.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_nro_doc=create sle_nro_doc
this.sle_tipo_doc=create sle_tipo_doc
this.pb_1=create pb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_nro_doc
this.Control[iCurrent+5]=this.sle_tipo_doc
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_fi510_cns_doc_x_plla_cobranza.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nro_doc)
destroy(this.sle_tipo_doc)
destroy(this.pb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject( sqlca)

end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event ue_retrieve_list;call super::ue_retrieve_list;String ls_cod, ls_nro_doc

ls_cod 		= sle_tipo_doc.Text
ls_nro_doc 	= sle_nro_doc.Text

dw_1.Retrieve(ls_cod, ls_nro_doc )
end event

type st_3 from statictext within w_fi510_cns_doc_x_plla_cobranza
integer x = 1371
integer y = 116
integer width = 133
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi510_cns_doc_x_plla_cobranza
integer x = 119
integer y = 116
integer width = 137
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi510_cns_doc_x_plla_cobranza
integer x = 466
integer y = 104
integer width = 809
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_fi510_cns_doc_x_plla_cobranza
integer x = 1513
integer y = 100
integer width = 379
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type sle_tipo_doc from singlelineedit within w_fi510_cns_doc_x_plla_cobranza
event ue_doubleclick pbm_lbuttondblclk
integer x = 270
integer y = 100
integer width = 183
integer height = 92
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event ue_doubleclick;String ls_sql, ls_codigo, ls_data
Boolean lb_ret

ls_sql = "SELECT TIPO_DOC AS CODIGO, " 	&
	    + "DESC_TIPO_DOC AS DESCRIPCION " 	&
		 + "FROM DOC_TIPO " 						
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
IF ls_codigo <> '' THEN
	This.Text = ls_codigo
	St_1.Text = ls_data
END IF


end event

event modified;String ls_data, ls_cod

ls_cod = This.Text

SELECT desc_tipo_doc
 INTO :ls_data
FROM	doc_tipo
WHERE tipo_doc 	= :ls_cod;
		
IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', "Codigo de Documento no existe o no esta activo, Verifique", StopSign!)
	This.Text = ''
	St_1.Text = ''
	RETURN 1
END IF
		
st_1.Text = ls_data

end event

type pb_1 from picturebutton within w_fi510_cns_doc_x_plla_cobranza
integer x = 2007
integer y = 76
integer width = 306
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve_list( )
end event

type dw_1 from u_dw_cns within w_fi510_cns_doc_x_plla_cobranza
integer x = 32
integer y = 272
integer width = 2962
integer height = 712
integer taborder = 50
string dataobject = "d_cns_planilla_cobranza_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
end event

type gb_1 from groupbox within w_fi510_cns_doc_x_plla_cobranza
integer x = 78
integer y = 20
integer width = 1888
integer height = 200
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento a Buscar"
end type

