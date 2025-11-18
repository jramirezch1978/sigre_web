$PBExportHeader$w_sig713_azucar_produccion_categoria.srw
forward
global type w_sig713_azucar_produccion_categoria from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig713_azucar_produccion_categoria
end type
type cb_grafico from commandbutton within w_sig713_azucar_produccion_categoria
end type
type uo_1 from u_ingreso_rango_fechas within w_sig713_azucar_produccion_categoria
end type
type st_1 from statictext within w_sig713_azucar_produccion_categoria
end type
type em_hora from editmask within w_sig713_azucar_produccion_categoria
end type
type cbx_origen from checkbox within w_sig713_azucar_produccion_categoria
end type
type ddlb_origen from u_ddlb within w_sig713_azucar_produccion_categoria
end type
type cbx_resumen_origen from checkbox within w_sig713_azucar_produccion_categoria
end type
type rb_prod_term from radiobutton within w_sig713_azucar_produccion_categoria
end type
type rb_sub_prod from radiobutton within w_sig713_azucar_produccion_categoria
end type
type gb_1 from groupbox within w_sig713_azucar_produccion_categoria
end type
type gb_2 from groupbox within w_sig713_azucar_produccion_categoria
end type
end forward

global type w_sig713_azucar_produccion_categoria from w_report_smpl
integer width = 3337
integer height = 2728
string title = "Produccion de Prod Terminado (SIG713)"
string menuname = "m_rpt_simple"
cb_lectura cb_lectura
cb_grafico cb_grafico
uo_1 uo_1
st_1 st_1
em_hora em_hora
cbx_origen cbx_origen
ddlb_origen ddlb_origen
cbx_resumen_origen cbx_resumen_origen
rb_prod_term rb_prod_term
rb_sub_prod rb_sub_prod
gb_1 gb_1
gb_2 gb_2
end type
global w_sig713_azucar_produccion_categoria w_sig713_azucar_produccion_categoria

type variables
String	is_oper, is_clase_prod_term, is_clase_sub_prod, is_origen
end variables

forward prototypes
public function string of_get_origen (string as_origen)
public function integer of_get_parametros (ref string as_clase_prod_term, ref string as_clase_sub_prod, ref string as_hora_ini, ref string as_oper_ing_prod)
end prototypes

public function string of_get_origen (string as_origen);Long		ll_rc = 0
String	ls_nombre


SELECT NOMBRE
  INTO :ls_nombre
  FROM ORIGEN
 WHERE COD_ORIGEN = :as_origen ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer Tabla origen')
	lL_rc = -1
END IF

RETURN ls_nombre

end function

public function integer of_get_parametros (ref string as_clase_prod_term, ref string as_clase_sub_prod, ref string as_hora_ini, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM, CLASE_SUB_PROD, HR_INI_DIA_PROD
  INTO :as_clase_prod_term, :as_clase_sub_prod, :as_hora_ini
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF

SELECT OPER_ING_PROD
  INTO :as_oper_ing_prod
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig713_azucar_produccion_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.cb_grafico=create cb_grafico
this.uo_1=create uo_1
this.st_1=create st_1
this.em_hora=create em_hora
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
this.cbx_resumen_origen=create cbx_resumen_origen
this.rb_prod_term=create rb_prod_term
this.rb_sub_prod=create rb_sub_prod
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.cb_grafico
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_hora
this.Control[iCurrent+6]=this.cbx_origen
this.Control[iCurrent+7]=this.ddlb_origen
this.Control[iCurrent+8]=this.cbx_resumen_origen
this.Control[iCurrent+9]=this.rb_prod_term
this.Control[iCurrent+10]=this.rb_sub_prod
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_sig713_azucar_produccion_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.cb_grafico)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.em_hora)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
destroy(this.cbx_resumen_origen)
destroy(this.rb_prod_term)
destroy(this.rb_sub_prod)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

ll_rc = of_get_parametros(is_clase_prod_term, is_clase_sub_prod, em_hora.text, is_oper)


end event

type dw_report from w_report_smpl`dw_report within w_sig713_azucar_produccion_categoria
integer x = 23
integer y = 244
string dataobject = "d_articulo_mov_x_categ_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;//d_templa_analisis_tbl

IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "nro_lote" 
		lstr_1.DataObject = 'd_templa_analisis_tbl'
		lstr_1.Width = 2500
		lstr_1.Height= 2000
		lstr_1.Arg[1] = GetItemString(row,'nro_lote')
		lstr_1.Title = 'Analisis por Templa/Lote'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_lectura from commandbutton within w_sig713_azucar_produccion_categoria
integer x = 2665
integer y = 48
integer width = 402
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;DateTime	ldt_inicio, ldt_fin
String	ls_clase, ls_mov_tipo
Date	ld_fecha1, ld_fecha2
Time	lt_fecha1, lt_fecha2
String	ls_origen, ls_nombre, ls_titulo

ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2 = uo_1.of_get_fecha2()
lt_fecha1 = Time(em_hora.text)
lt_fecha2 = Relativetime(lt_fecha1, -1)

ldt_inicio = DateTime(ld_fecha1, lt_fecha1)
ldt_fin    = DateTime(ld_fecha2, lt_fecha2)

IF rb_prod_term.checked THEN
	ls_clase = is_clase_prod_term
	ls_titulo = 'PRODUCCION DE PRODUCTOS TERMINADOS'
ELSE
	ls_clase = is_clase_sub_prod
	ls_titulo = 'PRODUCCION DE SUB PRODUCTOS'
END IF

IF UPPER(gs_lpp) = 'S' THEN PARENT.EVENT ue_set_retrieve_as_needed('S')

IF cbx_origen.checked THEN
	idw_1.Retrieve(ls_clase, is_oper, ldt_inicio, ldt_fin, is_origen)
	ls_nombre = of_get_origen(is_origen)
	ls_origen = 'Origen:  ' + is_origen + '    ' + ls_nombre
ELSE
	idw_1.Retrieve(ls_clase, is_oper, ldt_inicio, ldt_fin)
	ls_origen = 'Todos los Origenes'
END IF

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_fecha1.text = String(ldt_inicio, 'dd/mm/yyyy hh:mm:ss')
idw_1.object.t_fecha2.text = String(ldt_fin, 'dd/mm/yyyy hh:mm:ss')
idw_1.object.t_titulo.text = ls_titulo
idw_1.object.t_subtitulo.text = ls_origen

idw_1.Visible = True
end event

type cb_grafico from commandbutton within w_sig713_azucar_produccion_categoria
integer x = 2665
integer y = 148
integer width = 402
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grafico"
end type

event clicked;DateTime	ldt_inicio, ldt_fin
String	ls_clase, ls_mov_tipo, ls_titulo
Integer li_rc
STR_SIG713_GRF_POP lstr_1
Date	ld_fecha1, ld_fecha2
Time	lt_fecha1, lt_fecha2

ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2 = uo_1.of_get_fecha2()
lt_fecha1 = Time(em_hora.text)
lt_fecha2 = Relativetime(lt_fecha1, -1)

ldt_inicio = DateTime(ld_fecha1, lt_fecha1)
ldt_fin    = DateTime(ld_fecha2, lt_fecha2)

IF rb_prod_term.checked THEN
	ls_clase = is_clase_prod_term
	ls_titulo = 'PRODUCCION DE PRODUCTOS TERMINADOS'
ELSE
	ls_clase = is_clase_sub_prod
	ls_titulo = 'PRODUCCION DE SUB PRODUCTOS'
END IF

lstr_1.DataObject = 'd_azucar_producida_subcat_grf'
lstr_1.Width = 2500
lstr_1.Height= 1300
lstr_1.Arg_S[1] = TRIM(ls_clase)
lstr_1.Arg_S[2] = TRIM(is_oper)
lstr_1.Arg_DT[1] = ldt_inicio
lstr_1.Arg_DT[2] = ldt_fin
lstr_1.Title = 'PT Producido entre: ' + String(lstr_1.Arg_DT[1]) + ' y ' + String(lstr_1.Arg_DT[2])

lstr_1.grf_val_index = 3

li_rc = OpenSheetWithParm(w_sig713_consulta_grf_pop, lstr_1, Parent, 0, Original!)


end event

type uo_1 from u_ingreso_rango_fechas within w_sig713_azucar_produccion_categoria
integer x = 37
integer y = 132
integer height = 96
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
of_set_fecha(RelativeDate(Today(),-1), Today()) //para setear la fecha inicial

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_1 from statictext within w_sig713_azucar_produccion_categoria
integer x = 1358
integer y = 140
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hora Inicio"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type em_hora from editmask within w_sig713_azucar_produccion_categoria
integer x = 1669
integer y = 132
integer width = 242
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm:ss"
end type

type cbx_origen from checkbox within w_sig713_azucar_produccion_categoria
integer x = 2021
integer y = 52
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "x Origen"
end type

event clicked;IF THIS.checked THEN
	idw_1.DataObject = 'd_articulo_mov_x_categ_org_tbl'
   idw_1.SetTransObject(SQLCA)
	cb_grafico.enabled = false
	cbx_resumen_origen.enabled = false
ELSE
	idw_1.DataObject = 'd_articulo_mov_x_categ_tbl'
	idw_1.SetTransObject(SQLCA)
	cb_grafico.enabled = true
	cbx_resumen_origen.enabled = true
END IF
end event

type ddlb_origen from u_ddlb within w_sig713_azucar_produccion_categoria
integer x = 2016
integer y = 124
integer width = 558
integer height = 344
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_origen'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 6                     // Longitud del campo 1
ii_lc2 = 40							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_origen = aa_key
end event

type cbx_resumen_origen from checkbox within w_sig713_azucar_produccion_categoria
integer x = 1358
integer y = 56
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen por Origen"
end type

event clicked;IF THIS.checked THEN
	idw_1.DataObject = 'd_articulo_mov_x_categ_res_tbl'
   idw_1.SetTransObject(SQLCA)
	cbx_origen.enabled = false
ELSE
	idw_1.DataObject = 'd_articulo_mov_x_categ_tbl'
	idw_1.SetTransObject(SQLCA)
	cbx_origen.enabled = true
END IF
end event

type rb_prod_term from radiobutton within w_sig713_azucar_produccion_categoria
integer x = 50
integer y = 64
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porducto Terminado"
boolean checked = true
end type

type rb_sub_prod from radiobutton within w_sig713_azucar_produccion_categoria
integer x = 635
integer y = 64
integer width = 402
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sub Producto"
end type

type gb_1 from groupbox within w_sig713_azucar_produccion_categoria
integer x = 18
integer width = 1925
integer height = 232
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parametros de Lectura"
end type

type gb_2 from groupbox within w_sig713_azucar_produccion_categoria
integer x = 1979
integer width = 622
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen"
end type

