$PBExportHeader$w_cd707_rpt_doc_sin_provision.srw
forward
global type w_cd707_rpt_doc_sin_provision from w_report_smpl
end type
type cb_1 from commandbutton within w_cd707_rpt_doc_sin_provision
end type
type sle_origen from singlelineedit within w_cd707_rpt_doc_sin_provision
end type
type sle_nombre from singlelineedit within w_cd707_rpt_doc_sin_provision
end type
type pb_2 from picturebutton within w_cd707_rpt_doc_sin_provision
end type
type rb_1 from radiobutton within w_cd707_rpt_doc_sin_provision
end type
type rb_2 from radiobutton within w_cd707_rpt_doc_sin_provision
end type
type gb_1 from groupbox within w_cd707_rpt_doc_sin_provision
end type
end forward

global type w_cd707_rpt_doc_sin_provision from w_report_smpl
integer width = 3515
integer height = 2276
string title = "[CD707] Documentos sin provisionar"
string menuname = "m_impresion"
long backcolor = 12632256
cb_1 cb_1
sle_origen sle_origen
sle_nombre sle_nombre
pb_2 pb_2
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_cd707_rpt_doc_sin_provision w_cd707_rpt_doc_sin_provision

on w_cd707_rpt_doc_sin_provision.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.sle_nombre=create sle_nombre
this.pb_2=create pb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_nombre
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_cd707_rpt_doc_sin_provision.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.sle_nombre)
destroy(this.pb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_nombre

dw_report.SetTransObject( sqlca)
ib_preview = false
dw_report.ii_zoom_actual = 120
this.Event ue_preview()
ls_origen = TRIM(sle_origen.text)
ls_nombre = TRIM(sle_nombre.text)
dw_report.retrieve(ls_origen)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_texto.text = ls_nombre + ' al ' + STRING( today(), 'dd/mm/yyyy')
dw_report.object.t_user.text    = gs_user
dw_report.object.t_empresa.text = gs_empresa

end event

event ue_open_pre;call super::ue_open_pre;String ls_nombre

// Actualiza los documentos que ya han sido provisionados y el trigger no los ha considerado
update cd_doc_recibido c 
set c.flag_provisionado='P' 
where c.flag_provisionado='0' and 
      c.cod_relacion||trim(c.tipo_doc)||trim(c.nro_doc) in 
      (select cp.cod_relacion||trim(cp.tipo_doc)||trim(cp.nro_doc) from cntas_pagar cp where cp.cod_relacion=c.cod_relacion and 
                                          cp.tipo_doc=c.tipo_doc and 
                                          trim(cp.nro_doc)=trim(c.nro_doc) ) ;

commit ;

//

sle_origen.text = gs_origen

SELECT nombre 
  INTO :ls_nombre 
  FROM origen 
 WHERE cod_origen=:gs_origen ;

sle_nombre.text = ls_nombre 

dw_report.visible =  true
end event

type dw_report from w_report_smpl`dw_report within w_cd707_rpt_doc_sin_provision
integer x = 32
integer y = 272
integer width = 3374
integer height = 1664
string dataobject = "d_rpt_doc_sin_provision_tbl"
end type

type cb_1 from commandbutton within w_cd707_rpt_doc_sin_provision
integer x = 1751
integer y = 72
integer width = 288
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_origen
ls_origen = TRIM(sle_origen.text)

IF isnull(ls_origen) OR TRIM(ls_origen)='' THEN
	MessageBox('Aviso','Defina origen')
	Return 1
END IF	

commit ;

parent.event ue_retrieve()
end event

type sle_origen from singlelineedit within w_cd707_rpt_doc_sin_provision
integer x = 759
integer y = 84
integer width = 146
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_origen, ls_nombre
Long ll_count

ls_origen = TRIM(sle_origen.text)

SELECT count(*) INTO :ll_count FROM origen o where o.cod_origen=:ls_origen ;

IF ll_count = 0 THEN
	MESSAGEBOX('AVISO','ORIGEN INCORRECTO')
ELSE
	SELECT o.nombre INTO :ls_nombre FROM origen o WHERE cod_origen=:ls_origen ;
	sle_nombre.text = ls_nombre
END IF 

end event

type sle_nombre from singlelineedit within w_cd707_rpt_doc_sin_provision
integer x = 1074
integer y = 84
integer width = 594
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type pb_2 from picturebutton within w_cd707_rpt_doc_sin_provision
integer x = 942
integer y = 76
integer width = 114
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_origen, ls_nombre

str_seleccionar lstr_seleccionar

			
lstr_seleccionar.s_seleccion = 'S'

lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO, '&
										 +'ORIGEN.NOMBRE AS DESCRIPCION '&
										 +'FROM ORIGEN ' 
										 
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_origen 	= lstr_seleccionar.param1[1]
	ls_nombre 	= lstr_seleccionar.param2[1]
	sle_origen.text 	= ls_origen 
	sle_nombre.text	= ls_nombre
END IF

end event

type rb_1 from radiobutton within w_cd707_rpt_doc_sin_provision
integer x = 46
integer y = 52
integer width = 581
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Por origen"
boolean checked = true
end type

type rb_2 from radiobutton within w_cd707_rpt_doc_sin_provision
integer x = 46
integer y = 152
integer width = 581
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos los origenes"
end type

event clicked;sle_origen.text = '%%'
sle_nombre.text = 'Todos los origenes'
end event

type gb_1 from groupbox within w_cd707_rpt_doc_sin_provision
integer x = 731
integer y = 24
integer width = 969
integer height = 168
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Origen"
end type

