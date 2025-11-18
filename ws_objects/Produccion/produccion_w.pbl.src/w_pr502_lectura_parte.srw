$PBExportHeader$w_pr502_lectura_parte.srw
forward
global type w_pr502_lectura_parte from w_pr500_base
end type
type cbx_where from checkbox within w_pr502_lectura_parte
end type
type st_descripcion from statictext within w_pr502_lectura_parte
end type
type em_nro_parte from singlelineedit within w_pr502_lectura_parte
end type
type sle_desc_formato from singlelineedit within w_pr502_lectura_parte
end type
type st_1 from statictext within w_pr502_lectura_parte
end type
type em_control_hora from editmask within w_pr502_lectura_parte
end type
type st_2 from statictext within w_pr502_lectura_parte
end type
type em_lectura from editmask within w_pr502_lectura_parte
end type
type gb_2 from groupbox within w_pr502_lectura_parte
end type
end forward

global type w_pr502_lectura_parte from w_pr500_base
integer width = 3424
integer height = 2212
string title = "Lecturas por Parte de Piso(PR502)  "
cbx_where cbx_where
st_descripcion st_descripcion
em_nro_parte em_nro_parte
sle_desc_formato sle_desc_formato
st_1 st_1
em_control_hora em_control_hora
st_2 st_2
em_lectura em_lectura
gb_2 gb_2
end type
global w_pr502_lectura_parte w_pr502_lectura_parte

on w_pr502_lectura_parte.create
int iCurrent
call super::create
this.cbx_where=create cbx_where
this.st_descripcion=create st_descripcion
this.em_nro_parte=create em_nro_parte
this.sle_desc_formato=create sle_desc_formato
this.st_1=create st_1
this.em_control_hora=create em_control_hora
this.st_2=create st_2
this.em_lectura=create em_lectura
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_where
this.Control[iCurrent+2]=this.st_descripcion
this.Control[iCurrent+3]=this.em_nro_parte
this.Control[iCurrent+4]=this.sle_desc_formato
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_control_hora
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_lectura
this.Control[iCurrent+9]=this.gb_2
end on

on w_pr502_lectura_parte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_where)
destroy(this.st_descripcion)
destroy(this.em_nro_parte)
destroy(this.sle_desc_formato)
destroy(this.st_1)
destroy(this.em_control_hora)
destroy(this.st_2)
destroy(this.em_lectura)
destroy(this.gb_2)
end on

event ue_open_pre;//Override

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
idw_1.Visible = False
is_title_original = idw_1.object.t_2.text
end event

event ue_retrieve;call super::ue_retrieve;string 	ls_fecha, ls_nro_parte
long 		ll_cuenta
integer	li_control, li_lectura

ls_nro_parte   = trim(em_nro_parte.text)
li_control		= integer(em_control_hora.text)
li_lectura		= integer(em_lectura.text)

ll_cuenta 				= 0
dw_report.visible 	= false
dw_report.reset()

//declare usp_pr_valgrf procedure for 
	     //usp_pr_parte_piso_valgrf(:ls_nro_parte);
//execute usp_pr_valgrf;

//fetch usp_pr_valgrf into :ll_cuenta, :ls_fecha;

//if ll_cuenta >= 1 then
	dw_report.retrieve(ls_nro_parte, li_control, li_lectura)
	idw_1.Object.p_logo.filename 	= gs_logo
	idw_1.object.t_empresa.text 	= gs_empresa
	idw_1.object.t_user.text 		= 'Impreso por: ' + trim(gs_user)
	idw_1.object.t_date.text 		= 'Fecha de impresión: ' + trim(ls_fecha)
	dw_report.visible = true
	//close usp_pr_valgrf;
	
//else
	
	//messagebox(this.title,'No hay datos para mostrar',StopSign!)
//	close usp_pr_valgrf;
	//return
//end if

end event

event ue_retrieve_list;call super::ue_retrieve_list;date ld_fecha1, ld_fecha2
string ls_sql, ls_fecha1, ls_fecha2, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

ls_fecha1 = string(ld_fecha1,'dd/mm/yyyy')
ls_fecha2 = string(ld_fecha2,'dd/mm/yyyy')

ls_sql = "select nro_parte as parte, cod_maquina as maq_codi, desc_maq as maq_desc, atributo as atrib_codi, descripcion as atrib_desc from vw_pr_articulo_parte_piso"
if cbx_where.checked = true then
	ls_sql = ls_sql + " where fecha_parte >= to_date('"+ls_fecha1+"', 'dd/mm/yyyy') and fecha_parte <= to_date('"+ls_fecha2+"', 'dd/mm/yyyy')"
end if
f_lista_5ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, '3')

sle_code.text = trim(ls_return2)
em_nro_parte.text = trim(ls_return1)
st_descripcion.text = trim(ls_return3) +' - '+trim(ls_return5)
this.event ue_retrieve()
end event

event ue_query_retrieve;//long 		ll_cuenta
//string 	ls_nro_parte
//
//	ls_nro_parte = trim(em_nro_parte.text)
//	
//	
//	declare 	usp_medicion procedure for 
//		     	usp_tg_busca_medicion_parte(:ls_nro_parte);
//	execute 	usp_medicion;
//	fetch 	usp_medicion into :ll_cuenta;
//	close 	usp_medicion;
//	
//	if ll_cuenta >= 1 then
		this.event ue_retrieve()
//	else
//		messagebox(this.title,'No se han encontrado concidencia ~r para el parte '+ls_nro_parte,stopsign!)
//	end if

end event

type dw_report from w_pr500_base`dw_report within w_pr502_lectura_parte
integer x = 37
integer y = 436
integer width = 2578
integer height = 980
string dataobject = "d_pr_parte_diario_lec_cst"
end type

type uo_fecha from w_pr500_base`uo_fecha within w_pr502_lectura_parte
boolean visible = false
integer x = 2629
integer y = 80
integer width = 315
integer height = 64
end type

type st_confirm from w_pr500_base`st_confirm within w_pr502_lectura_parte
end type

type st_etiqueta from w_pr500_base`st_etiqueta within w_pr502_lectura_parte
integer x = 2629
integer y = 148
integer width = 315
end type

type sle_code from w_pr500_base`sle_code within w_pr502_lectura_parte
boolean visible = false
integer x = 2642
integer y = 308
integer width = 416
end type

type st_code from w_pr500_base`st_code within w_pr502_lectura_parte
integer x = 82
integer y = 88
integer width = 480
integer height = 76
integer weight = 700
long textcolor = 0
string text = "Nro. de Parte"
end type

type st_procesando from w_pr500_base`st_procesando within w_pr502_lectura_parte
integer x = 2629
integer y = 216
integer width = 315
end type

type cbx_where from checkbox within w_pr502_lectura_parte
boolean visible = false
integer x = 2629
integer y = 12
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtar busqueda"
boolean checked = true
end type

type st_descripcion from statictext within w_pr502_lectura_parte
boolean visible = false
integer x = 2629
integer y = 284
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type em_nro_parte from singlelineedit within w_pr502_lectura_parte
event dobleclick pbm_lbuttondblclk
integer x = 585
integer y = 80
integer width = 320
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select t.nro_parte as codigo, "& 
		  + "f.descripcion as Descripción "&
		  + "from tg_parte_piso t, tg_fmt_med_act f "&
		  + "where f.formato = t.formato and t.flag_estado = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_desc_formato.text = ls_data
end if
end event

event modified;String 	ls_nro_parte, ls_desc

ls_nro_parte = this.text
if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Parte')
	return
end if

SELECT F.DESCRIPCION INTO :ls_desc
  FROM TG_PARTE_PISO T, TG_FMT_MED_ACT F
 WHERE F.FORMATO = T.FORMATO 
       AND T.NRO_PARTE = :ls_nro_parte;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Parte no existe')
	return
end if

sle_desc_formato.text = ls_desc

end event

type sle_desc_formato from singlelineedit within w_pr502_lectura_parte
integer x = 905
integer y = 80
integer width = 1586
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pr502_lectura_parte
integer x = 82
integer y = 176
integer width = 480
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Control / Hora:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_control_hora from editmask within w_pr502_lectura_parte
integer x = 585
integer y = 164
integer width = 165
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
string minmax = "~~"
end type

type st_2 from statictext within w_pr502_lectura_parte
integer x = 82
integer y = 248
integer width = 480
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Lectura"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_lectura from editmask within w_pr502_lectura_parte
integer x = 585
integer y = 252
integer width = 165
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
end type

type gb_2 from groupbox within w_pr502_lectura_parte
integer x = 37
integer y = 32
integer width = 2551
integer height = 340
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

