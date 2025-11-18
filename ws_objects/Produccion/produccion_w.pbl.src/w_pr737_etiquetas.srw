$PBExportHeader$w_pr737_etiquetas.srw
forward
global type w_pr737_etiquetas from w_report_smpl
end type
type cb_1 from commandbutton within w_pr737_etiquetas
end type
type cb_2 from commandbutton within w_pr737_etiquetas
end type
type cb_3 from commandbutton within w_pr737_etiquetas
end type
type st_1 from statictext within w_pr737_etiquetas
end type
type st_2 from statictext within w_pr737_etiquetas
end type
type em_area from editmask within w_pr737_etiquetas
end type
type em_desc_area from editmask within w_pr737_etiquetas
end type
type em_seccion from editmask within w_pr737_etiquetas
end type
type em_desc_seccion from editmask within w_pr737_etiquetas
end type
type cbx_todos from checkbox within w_pr737_etiquetas
end type
type st_3 from statictext within w_pr737_etiquetas
end type
type ddlb_nro from dropdownlistbox within w_pr737_etiquetas
end type
type cbx_lote from checkbox within w_pr737_etiquetas
end type
type sle_lote from singlelineedit within w_pr737_etiquetas
end type
type rb_1 from radiobutton within w_pr737_etiquetas
end type
type rb_2 from radiobutton within w_pr737_etiquetas
end type
type cb_listado from commandbutton within w_pr737_etiquetas
end type
type sle_desde from singlelineedit within w_pr737_etiquetas
end type
type sle_hasta from singlelineedit within w_pr737_etiquetas
end type
type gb_1 from groupbox within w_pr737_etiquetas
end type
type gb_2 from groupbox within w_pr737_etiquetas
end type
type gb_5 from groupbox within w_pr737_etiquetas
end type
type gb_3 from groupbox within w_pr737_etiquetas
end type
end forward

global type w_pr737_etiquetas from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(PR737) Etiquetas para producción"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
st_1 st_1
st_2 st_2
em_area em_area
em_desc_area em_desc_area
em_seccion em_seccion
em_desc_seccion em_desc_seccion
cbx_todos cbx_todos
st_3 st_3
ddlb_nro ddlb_nro
cbx_lote cbx_lote
sle_lote sle_lote
rb_1 rb_1
rb_2 rb_2
cb_listado cb_listado
sle_desde sle_desde
sle_hasta sle_hasta
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
gb_3 gb_3
end type
global w_pr737_etiquetas w_pr737_etiquetas

type variables
string is_codigo
end variables

on w_pr737_etiquetas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_1=create st_1
this.st_2=create st_2
this.em_area=create em_area
this.em_desc_area=create em_desc_area
this.em_seccion=create em_seccion
this.em_desc_seccion=create em_desc_seccion
this.cbx_todos=create cbx_todos
this.st_3=create st_3
this.ddlb_nro=create ddlb_nro
this.cbx_lote=create cbx_lote
this.sle_lote=create sle_lote
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_listado=create cb_listado
this.sle_desde=create sle_desde
this.sle_hasta=create sle_hasta
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_area
this.Control[iCurrent+7]=this.em_desc_area
this.Control[iCurrent+8]=this.em_seccion
this.Control[iCurrent+9]=this.em_desc_seccion
this.Control[iCurrent+10]=this.cbx_todos
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.ddlb_nro
this.Control[iCurrent+13]=this.cbx_lote
this.Control[iCurrent+14]=this.sle_lote
this.Control[iCurrent+15]=this.rb_1
this.Control[iCurrent+16]=this.rb_2
this.Control[iCurrent+17]=this.cb_listado
this.Control[iCurrent+18]=this.sle_desde
this.Control[iCurrent+19]=this.sle_hasta
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_5
this.Control[iCurrent+23]=this.gb_3
end on

on w_pr737_etiquetas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_area)
destroy(this.em_desc_area)
destroy(this.em_seccion)
destroy(this.em_desc_seccion)
destroy(this.cbx_todos)
destroy(this.st_3)
destroy(this.ddlb_nro)
destroy(this.cbx_lote)
destroy(this.sle_lote)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_listado)
destroy(this.sle_desde)
destroy(this.sle_hasta)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_area, ls_seccion, ls_desde, ls_hasta, ls_mensaje
integer	li_nro_trabaj, li_i

ls_area    = string (em_area.text)
ls_seccion = string (em_seccion.text)

if not cbx_todos.checked then
	ls_desde = sle_desde.text
	ls_hasta = sle_hasta.text
else
	ls_desde = '10000000'
	ls_hasta = '99999999'
end if

if isnull(ls_desde) or (ls_desde > ls_hasta) then
	MessageBox('Aviso','rango es incorrecto. Verifique')
	return
end if

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%%'

li_nro_trabaj = integer(ddlb_nro.text)

if li_nro_trabaj <= 0 then
	MEssageBox('Error', 'Debe seleccionar una cantidad de etiquetas por trabajador')
	return
end if

if not cbx_lote.checked then
	dw_report.object.lote_t.text = ''
	dw_report.object.r_lote.Pen.Style = 5
	dw_report.object.nro_lote_t.text = ''
else
	dw_report.object.lote_t.text = 'Lote / Cuartel'
	dw_report.object.r_lote.Pen.Style = 0
	dw_report.object.nro_lote_t.text = sle_lote.text
end if

delete tt_telecredito;
for li_i = 1 to li_nro_trabaj
	insert into tt_telecredito(col_telecredito) values ('1');
next

//Inserto los trabajadores
if rb_1.checked or cbx_todos.checked then
	delete tt_proveedor;
	
	insert into tt_proveedor(proveedor)
	select cod_trabajador
	from maestro
	where flag_estado = '1'
	  and cod_trabajador between :ls_desde and :ls_hasta;
	  
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en insert', 'No se pudo insertar datos en tt_proveedor: ' &
							+ ls_mensaje)
		return
	end if
end if
	
dw_report.retrieve(ls_area, ls_seccion, ls_desde, ls_hasta)

dw_report.Object.DataWindow.Print.Paper.Size = 256
dw_report.Object.DataWindow.Print.CustomPage.Length = 28
dw_report.Object.DataWindow.Print.CustomPage.Width = 109



dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text   = gs_empresa
//dw_report.object.t_user.text     = gs_user


end event

event open;call super::open;String ls_Dir = "C:\WINDOWS\Fonts\", ls_fileFont = "IDAutomationHC39M_Free.ttf"


if not FileExists(ls_dir + ls_FileFont) then
	FileCopy(ls_fileFont, ls_dir + ls_FileFont, false)
	MessageBox('Error', 'No tiene instalado la fuente ' + ls_dir + ls_FileFont &
				+ "~r~nLa aplicación está copiando la fuente en " + ls_dir &
				+ "~r~nLa Aplicación se cerrará, debe volverla a cargar nuevamente ")
	Halt Close
end if
end event

type dw_report from w_report_smpl`dw_report within w_pr737_etiquetas
integer x = 9
integer y = 536
integer width = 3451
integer height = 900
integer taborder = 70
string dataobject = "d_trabajadores_packing_lbl"
end type

type cb_1 from commandbutton within w_pr737_etiquetas
integer x = 3145
integer y = 292
integer width = 279
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cb_2 from commandbutton within w_pr737_etiquetas
integer x = 398
integer y = 112
integer width = 87
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_rh_area_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_area.text = sl_param.field_ret[1]
	em_desc_area.text = sl_param.field_ret[2]
END IF

end event

type cb_3 from commandbutton within w_pr737_etiquetas
integer x = 2030
integer y = 112
integer width = 87
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_seccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = em_area.text

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_seccion.text = sl_param.field_ret[1]
	em_desc_seccion.text = sl_param.field_ret[2]
END IF

end event

type st_1 from statictext within w_pr737_etiquetas
integer x = 475
integer y = 332
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr737_etiquetas
integer x = 1029
integer y = 332
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type em_area from editmask within w_pr737_etiquetas
integer x = 119
integer y = 112
integer width = 283
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_area from editmask within w_pr737_etiquetas
integer x = 494
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_seccion from editmask within w_pr737_etiquetas
integer x = 1710
integer y = 112
integer width = 283
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_seccion from editmask within w_pr737_etiquetas
integer x = 2153
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_todos from checkbox within w_pr737_etiquetas
integer x = 119
integer y = 348
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if not this.checked then
	rb_1.enabled = true
	rb_2.enabled = true
else
	rb_1.enabled = false
	rb_2.enabled = false
end if
end event

type st_3 from statictext within w_pr737_etiquetas
integer x = 1655
integer y = 300
integer width = 571
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cantidad por trabajador"
boolean focusrectangle = false
end type

type ddlb_nro from dropdownlistbox within w_pr737_etiquetas
integer x = 1655
integer y = 388
integer width = 571
integer height = 680
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"1","10","20","30","40","50","60","100","200","300","400"}
borderstyle borderstyle = stylelowered!
end type

type cbx_lote from checkbox within w_pr737_etiquetas
integer x = 2309
integer y = 356
integer width = 274
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Incluir"
boolean checked = true
end type

event clicked;if this.checked then
	sle_lote.enabled = true
else
	sle_lote.enabled = false
end if
end event

type sle_lote from singlelineedit within w_pr737_etiquetas
integer x = 2587
integer y = 344
integer width = 279
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type rb_1 from radiobutton within w_pr737_etiquetas
integer x = 370
integer y = 328
integer width = 87
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
end type

event clicked;if this.checked then
	sle_desde.enabled = true
	sle_hasta.enabled = true
	cb_listado.enabled = false
end if
end event

type rb_2 from radiobutton within w_pr737_etiquetas
integer x = 370
integer y = 416
integer width = 87
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
end type

event clicked;if this.checked then
	sle_desde.enabled = false
	sle_hasta.enabled = false
	cb_listado.enabled = true
end if
end event

type cb_listado from commandbutton within w_pr737_etiquetas
integer x = 521
integer y = 408
integer width = 955
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Listado de trabajadores"
end type

event clicked;str_parametros lstr_param
string ls_area, ls_seccion

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%%'


// Si es una salida x consumo interno
lstr_param.w1				= parent
lstr_param.dw1      		= 'd_list_trabajadores_grd'
lstr_param.titulo    	= 'Consumo Interno '
lstr_param.tipo		 	= '2S'     // con un parametro del tipo string
lstr_param.string1   	= ls_area
lstr_param.string2	 		= ls_seccion
	
lstr_param.opcion    	= 2

OpenWithParm( w_abc_seleccion, lstr_param)

end event

type sle_desde from singlelineedit within w_pr737_etiquetas
integer x = 704
integer y = 324
integer width = 311
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "10000000"
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type sle_hasta from singlelineedit within w_pr737_etiquetas
integer x = 1193
integer y = 324
integer width = 311
integer height = 80
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
string text = "99999999"
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type gb_1 from groupbox within w_pr737_etiquetas
integer x = 55
integer y = 36
integer width = 1518
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Area "
end type

type gb_2 from groupbox within w_pr737_etiquetas
integer x = 1646
integer y = 36
integer width = 1609
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Sección "
end type

type gb_5 from groupbox within w_pr737_etiquetas
integer x = 73
integer y = 268
integer width = 1536
integer height = 252
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Trabajadores"
end type

type gb_3 from groupbox within w_pr737_etiquetas
integer x = 2263
integer y = 264
integer width = 846
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro de Lote/Cuartel"
end type

