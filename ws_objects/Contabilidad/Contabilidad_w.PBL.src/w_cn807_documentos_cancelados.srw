$PBExportHeader$w_cn807_documentos_cancelados.srw
forward
global type w_cn807_documentos_cancelados from w_report_smpl
end type
type cb_1 from commandbutton within w_cn807_documentos_cancelados
end type
type uo_1 from u_ingreso_rango_fechas within w_cn807_documentos_cancelados
end type
type sle_tipo from singlelineedit within w_cn807_documentos_cancelados
end type
type cb_buscar from commandbutton within w_cn807_documentos_cancelados
end type
type sle_desc_tipo from singlelineedit within w_cn807_documentos_cancelados
end type
type gb_1 from groupbox within w_cn807_documentos_cancelados
end type
type gb_2 from groupbox within w_cn807_documentos_cancelados
end type
end forward

global type w_cn807_documentos_cancelados from w_report_smpl
integer width = 2962
integer height = 1264
string title = "Documentos Cancelados (CN806)"
string menuname = "m_abc_report_smpl"
long backcolor = 67108864
cb_1 cb_1
uo_1 uo_1
sle_tipo sle_tipo
cb_buscar cb_buscar
sle_desc_tipo sle_desc_tipo
gb_1 gb_1
gb_2 gb_2
end type
global w_cn807_documentos_cancelados w_cn807_documentos_cancelados

type variables

end variables

on w_cn807_documentos_cancelados.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.sle_tipo=create sle_tipo
this.cb_buscar=create cb_buscar
this.sle_desc_tipo=create sle_desc_tipo
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.sle_tipo
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.sle_desc_tipo
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_cn807_documentos_cancelados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.sle_tipo)
destroy(this.cb_buscar)
destroy(this.sle_desc_tipo)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;// prueba

end event

type dw_report from w_report_smpl`dw_report within w_cn807_documentos_cancelados
integer x = 37
integer y = 256
integer width = 2857
integer height = 740
integer taborder = 50
string dataobject = "d_rpt_cnta_pag_canceladas_tbl"
end type

type cb_1 from commandbutton within w_cn807_documentos_cancelados
integer x = 2560
integer y = 128
integer width = 334
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Date ld_fecini, ld_fecfin
string ls_tipo_doc

ld_fecini = uo_1.of_get_fecha1()
ld_fecfin = uo_1.of_get_fecha2()  

ls_tipo_doc = trim(sle_tipo.text)

if ls_tipo_doc = '' or isnull(ls_tipo_doc) then
	
	messagebox('Aviso','Debe de ingresar un tipo de documento Valido')
	return
	
end if

idw_1.SetTransObject(sqlca)
idw_1.retrieve(ls_tipo_doc , ld_fecini, ld_fecfin)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = string(idw_1.dataobject)
idw_1.object.t_texto.text = ls_tipo_doc + ' ' + sle_desc_tipo.text + ' / ' + 'Del: ' + string(ld_fecini,'dd/mm/yyyy') + ' Al: ' + string(ld_fecfin,'dd/mm/yyyy')

idw_1.visible = true
ib_preview = false
parent.event ue_preview()

end event

type uo_1 from u_ingreso_rango_fechas within w_cn807_documentos_cancelados
integer x = 69
integer y = 104
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date(today()), date(today())) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_tipo from singlelineedit within w_cn807_documentos_cancelados
integer x = 1467
integer y = 108
integer width = 197
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_cn807_documentos_cancelados
integer x = 1678
integer y = 108
integer width = 105
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT DT.TIPO_DOC AS CODIGO, '&
								 +'DT.DESC_TIPO_DOC AS CIENTIFICO '&
								 +'FROM DOC_TIPO DT '&
								 +"WHERE DT.FLAG_ESTADO = '1'"

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_tipo.text = trim( lstr_seleccionar.param1[1])
	sle_desc_tipo.text = trim( lstr_seleccionar.param2[1])
END IF
end event

type sle_desc_tipo from singlelineedit within w_cn807_documentos_cancelados
integer x = 1797
integer y = 108
integer width = 686
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn807_documentos_cancelados
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_cn807_documentos_cancelados
integer x = 1426
integer y = 32
integer width = 1102
integer height = 196
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Tipo de Documento"
end type

