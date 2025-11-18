$PBExportHeader$w_rh371_rpt_certificados_quinta.srw
forward
global type w_rh371_rpt_certificados_quinta from w_report_smpl
end type
type cb_3 from commandbutton within w_rh371_rpt_certificados_quinta
end type
type em_descripcion from editmask within w_rh371_rpt_certificados_quinta
end type
type em_origen from editmask within w_rh371_rpt_certificados_quinta
end type
type em_desc_tipo from editmask within w_rh371_rpt_certificados_quinta
end type
type em_tipo from editmask within w_rh371_rpt_certificados_quinta
end type
type cb_2 from commandbutton within w_rh371_rpt_certificados_quinta
end type
type cb_1 from commandbutton within w_rh371_rpt_certificados_quinta
end type
type sle_codigo from singlelineedit within w_rh371_rpt_certificados_quinta
end type
type sle_nombres from singlelineedit within w_rh371_rpt_certificados_quinta
end type
type cb_4 from commandbutton within w_rh371_rpt_certificados_quinta
end type
type cbx_todos from checkbox within w_rh371_rpt_certificados_quinta
end type
type em_year from editmask within w_rh371_rpt_certificados_quinta
end type
type gb_2 from groupbox within w_rh371_rpt_certificados_quinta
end type
type gb_3 from groupbox within w_rh371_rpt_certificados_quinta
end type
type gb_4 from groupbox within w_rh371_rpt_certificados_quinta
end type
type gb_1 from groupbox within w_rh371_rpt_certificados_quinta
end type
end forward

global type w_rh371_rpt_certificados_quinta from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH371) Certificados de Retenciones de Quinta Categoría"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
sle_codigo sle_codigo
sle_nombres sle_nombres
cb_4 cb_4
cbx_todos cbx_todos
em_year em_year
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
end type
global w_rh371_rpt_certificados_quinta w_rh371_rpt_certificados_quinta

on w_rh371_rpt_certificados_quinta.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_codigo=create sle_codigo
this.sle_nombres=create sle_nombres
this.cb_4=create cb_4
this.cbx_todos=create cbx_todos
this.em_year=create em_year
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.sle_codigo
this.Control[iCurrent+9]=this.sle_nombres
this.Control[iCurrent+10]=this.cb_4
this.Control[iCurrent+11]=this.cbx_todos
this.Control[iCurrent+12]=this.em_year
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_4
this.Control[iCurrent+16]=this.gb_1
end on

on w_rh371_rpt_certificados_quinta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_codigo)
destroy(this.sle_nombres)
destroy(this.cb_4)
destroy(this.cbx_todos)
destroy(this.em_year)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tiptra, ls_descripcion, ls_codigo
Integer	li_year

ls_origen 		= string(em_origen.text)
li_year			= Integer(em_year.text)
ls_tiptra 		= string(em_tipo.text)

if cbx_todos.checked then
	ls_codigo 		= "%%"
else
	ls_codigo 		= trim(sle_codigo.text) +'%'
end if

//create or replace procedure usp_rh_rpt_certificados_quinta (
//  ani_year             in number, 
//  asi_tipo_trabajador  in tipo_trabajador.tipo_trabajador%TYPE, 
//  asi_origen           in origen.cod_origen%TYPE,
//  asi_codtra           in maestro.cod_trabajador%TYPE 
//) is
DECLARE USP_RH_RPT_CERTIFICADOS_QUINTA PROCEDURE FOR 
	USP_RH_RPT_CERTIFICADOS_QUINTA( :li_year, 
											  :ls_tiptra, 
											  :ls_origen, 
											  :ls_codigo) ;
EXECUTE USP_RH_RPT_CERTIFICADOS_QUINTA ;

if gnvo_app.of_existserror( SQLCA, 'USP_RH_RPT_CERTIFICADOS_QUINTA' ) then 
	ROLLBACK;
	return
end if

dw_report.retrieve()

close USP_RH_RPT_CERTIFICADOS_QUINTA;

dw_report.object.p_logo.filename 		= gs_logo
dw_report.object.t_nombre.text 			= gs_empresa
dw_report.object.t_fecha_emision.text 	= string(gnvo_app.of_fecha_actual(), 'dd/mm/yyyy')
end event

event ue_open_pre;call super::ue_open_pre;Date 		ld_Fecha
Integer 	li_year

idw_1.Visible = true

ld_fecha = Date(gnvo_app.of_fecha_actual())

li_year  = Integer(string(ld_fecha, 'yyyy')) - 1

em_year.text = string(li_year)
end event

type dw_report from w_report_smpl`dw_report within w_rh371_rpt_certificados_quinta
integer x = 0
integer y = 348
integer width = 3369
integer height = 844
integer taborder = 60
string dataobject = "d_rpt_certificados_quinta_tbl"
end type

type cb_3 from commandbutton within w_rh371_rpt_certificados_quinta
integer x = 165
integer y = 76
integer width = 87
integer height = 68
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

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion from editmask within w_rh371_rpt_certificados_quinta
integer x = 288
integer y = 72
integer width = 718
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh371_rpt_certificados_quinta
integer x = 50
integer y = 72
integer width = 96
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh371_rpt_certificados_quinta
integer x = 1413
integer y = 72
integer width = 667
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh371_rpt_certificados_quinta
integer x = 1115
integer y = 72
integer width = 151
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh371_rpt_certificados_quinta
integer x = 1285
integer y = 76
integer width = 87
integer height = 68
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

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh371_rpt_certificados_quinta
integer x = 2971
integer y = 32
integer width = 325
integer height = 192
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_codigo from singlelineedit within w_rh371_rpt_certificados_quinta
integer x = 302
integer y = 232
integer width = 247
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_nombres from singlelineedit within w_rh371_rpt_certificados_quinta
integer x = 722
integer y = 232
integer width = 1326
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh371_rpt_certificados_quinta
integer x = 581
integer y = 240
integer width = 87
integer height = 72
integer taborder = 40
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

event clicked;// Abre ventana de ayuda 

//str_parametros lstr_param

//lstr_param.dw1 = "d_rpt_select_codigo_tbl"
//lstr_param.titulo = "Seleccionar Búsqueda"
//lstr_param.field_ret_i[1] 	= 1
//lstr_param.field_ret_i[2] 	= 2
//lstr_param.param_def 		= 2
//lstr_param.tipo				= '1S'
//lstr_param.string1			= em_origen.text
//
//OpenWithParm( w_search, lstr_param)		
//lstr_param = MESSAGE.POWEROBJECTPARM
//IF lstr_param.titulo <> 'n' THEN
//	sle_codigo.text  = lstr_param.field_ret[1]
//	sle_nombres.text = lstr_param.field_ret[2]
//END IF
//

boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabajador

ls_origen = trim(em_origen.text)

if ls_origen = '' then
	gnvo_App.of_mensaje_error("Debe especificar un codigo de origen antes de continuar", "Error")
	em_origen.setFocus()
	return
end if

ls_tipo_trabajador = trim(em_tipo.text) 

if ls_tipo_trabajador = '' then
	gnvo_App.of_mensaje_error("Debe especificar un TIPO DE TRABAJADOR antes de continuar", "Error")
	em_tipo.setFocus()
	return
end if


ls_sql = "SELECT distinct m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "m.DNI as dni " &
		 + "from vw_pr_trabajador m "&
		 + "where m.cod_origen = '" + ls_origen + "'" &
		 + "  and m.tipo_trabajador = '" + ls_tipo_trabajador + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_codigo.text 	= ls_codigo
	sle_nombres.text = ls_data
end if

end event

type cbx_todos from checkbox within w_rh371_rpt_certificados_quinta
integer x = 37
integer y = 240
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos"
boolean checked = true
end type

event clicked;if cbx_todos.checked then
	cb_4.enabled = false
else
	cb_4.enabled = true
end if
end event

type em_year from editmask within w_rh371_rpt_certificados_quinta
integer x = 2208
integer y = 60
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type gb_2 from groupbox within w_rh371_rpt_certificados_quinta
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh371_rpt_certificados_quinta
integer x = 2135
integer width = 480
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año de Retención"
end type

type gb_4 from groupbox within w_rh371_rpt_certificados_quinta
integer y = 168
integer width = 2130
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

type gb_1 from groupbox within w_rh371_rpt_certificados_quinta
integer x = 1070
integer width = 1056
integer height = 172
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

