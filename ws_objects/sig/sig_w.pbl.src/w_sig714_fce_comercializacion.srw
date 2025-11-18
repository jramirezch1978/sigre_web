$PBExportHeader$w_sig714_fce_comercializacion.srw
forward
global type w_sig714_fce_comercializacion from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig714_fce_comercializacion
end type
type sle_grp_art from singlelineedit within w_sig714_fce_comercializacion
end type
type sle_rubro from singlelineedit within w_sig714_fce_comercializacion
end type
type sle_grp_codrel from singlelineedit within w_sig714_fce_comercializacion
end type
type st_1 from statictext within w_sig714_fce_comercializacion
end type
type st_2 from statictext within w_sig714_fce_comercializacion
end type
type st_3 from statictext within w_sig714_fce_comercializacion
end type
type pb_1 from picturebutton within w_sig714_fce_comercializacion
end type
type pb_2 from picturebutton within w_sig714_fce_comercializacion
end type
type pb_3 from picturebutton within w_sig714_fce_comercializacion
end type
type sle_desc_grp_art from singlelineedit within w_sig714_fce_comercializacion
end type
type sle_desc_rubro from singlelineedit within w_sig714_fce_comercializacion
end type
type sle_desc_grp_codrel from singlelineedit within w_sig714_fce_comercializacion
end type
type cb_param from commandbutton within w_sig714_fce_comercializacion
end type
type st_4 from statictext within w_sig714_fce_comercializacion
end type
type st_5 from statictext within w_sig714_fce_comercializacion
end type
type st_6 from statictext within w_sig714_fce_comercializacion
end type
type em_num_fac from editmask within w_sig714_fce_comercializacion
end type
type em_num_bol from editmask within w_sig714_fce_comercializacion
end type
type em_kg_bol from editmask within w_sig714_fce_comercializacion
end type
type gb_1 from groupbox within w_sig714_fce_comercializacion
end type
end forward

global type w_sig714_fce_comercializacion from w_report_smpl
integer width = 3401
integer height = 1828
string title = "Indicadores de gestión de Comercialización (SIG714)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
sle_grp_art sle_grp_art
sle_rubro sle_rubro
sle_grp_codrel sle_grp_codrel
st_1 st_1
st_2 st_2
st_3 st_3
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
sle_desc_grp_art sle_desc_grp_art
sle_desc_rubro sle_desc_rubro
sle_desc_grp_codrel sle_desc_grp_codrel
cb_param cb_param
st_4 st_4
st_5 st_5
st_6 st_6
em_num_fac em_num_fac
em_num_bol em_num_bol
em_kg_bol em_kg_bol
gb_1 gb_1
end type
global w_sig714_fce_comercializacion w_sig714_fce_comercializacion

type variables
String	is_oper, is_clase
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
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

on w_sig714_fce_comercializacion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.sle_grp_art=create sle_grp_art
this.sle_rubro=create sle_rubro
this.sle_grp_codrel=create sle_grp_codrel
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.sle_desc_grp_art=create sle_desc_grp_art
this.sle_desc_rubro=create sle_desc_rubro
this.sle_desc_grp_codrel=create sle_desc_grp_codrel
this.cb_param=create cb_param
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.em_num_fac=create em_num_fac
this.em_num_bol=create em_num_bol
this.em_kg_bol=create em_kg_bol
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.sle_grp_art
this.Control[iCurrent+3]=this.sle_rubro
this.Control[iCurrent+4]=this.sle_grp_codrel
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.sle_desc_grp_art
this.Control[iCurrent+12]=this.sle_desc_rubro
this.Control[iCurrent+13]=this.sle_desc_grp_codrel
this.Control[iCurrent+14]=this.cb_param
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.em_num_fac
this.Control[iCurrent+19]=this.em_num_bol
this.Control[iCurrent+20]=this.em_kg_bol
this.Control[iCurrent+21]=this.gb_1
end on

on w_sig714_fce_comercializacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.sle_grp_art)
destroy(this.sle_rubro)
destroy(this.sle_grp_codrel)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.sle_desc_grp_art)
destroy(this.sle_desc_rubro)
destroy(this.sle_desc_grp_codrel)
destroy(this.cb_param)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.em_num_fac)
destroy(this.em_num_bol)
destroy(this.em_kg_bol)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_count

String ls_grp_art, ls_desc_grp_art, ls_rubro, ls_desc_rubro, &
		 ls_grp_codrel, ls_desc_grp_codrel

cb_param.enabled = false

// Asignado grupo de articulos principal de PPTT

em_num_fac.text = '12'
em_num_bol.text = '6'
em_kg_bol.text = '50'


end event

type dw_report from w_report_smpl`dw_report within w_sig714_fce_comercializacion
integer x = 41
integer y = 456
integer width = 3081
integer height = 1104
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_reporte, ls_grupo, ls_grupo_art, ls_grupo_codrel, ls_rubro, ls_cat_art
Long ll_factor
sg_parametros lstr_rep


if row=0 then  return

IF this.Rowcount( ) = 0 then return

ls_grupo = this.object.sig_fce[row]
ls_grupo_art = sle_grp_art.text
ls_grupo_codrel = sle_grp_codrel.text
ls_rubro = sle_rubro.text

IF ls_grupo = 'STK_PPTT' THEN
	lstr_rep.string1 = ls_grupo_art
	// Colocarlo como parametro el factor 50 (Kg por bolsa)
	lstr_rep.long1 = 50
	OpenSheetWithParm(w_sig714_indicador_azucar_detalle, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo = 'ATR_ORDT' THEN
	lstr_rep.string1 = ls_grupo_art	
	OpenSheetWithParm(w_sig714_atrazo_ord_traslado, lstr_rep, w_main, 2, layered!)	
ELSEIF ls_grupo='ATR_COBG' then
	lstr_rep.string1 = ls_grupo_codrel
	lstr_rep.string2 = ls_rubro
	
	OpenSheetWithParm(w_sig714_atrazo_cobrza_grupo, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo='ATR_COBO' then
	lstr_rep.string1 = ls_grupo_codrel
	lstr_rep.string2 = ls_rubro
	
	OpenSheetWithParm(w_sig714_atrazo_cobrza_otros, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo='PRC_REFI' then
	ls_cat_art = '141'
	lstr_rep.string1 = ls_cat_art
	
	OpenSheetWithParm(w_sig714_precio_azucar, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo='PRC_RUBI' then
	ls_cat_art = '143'
	lstr_rep.string1 = ls_cat_art
	
	OpenSheetWithParm(w_sig714_precio_azucar, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo='PRC_BDOM' then
	ls_cat_art = '142'
	lstr_rep.string1 = ls_cat_art
	
	OpenSheetWithParm(w_sig714_precio_azucar, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo='SDO_CCOB' then
	lstr_rep.string1 = ls_rubro
	
	OpenSheetWithParm(w_sig714_sdo_ccob_tot, lstr_rep, w_main, 2, layered!)	
END IF

end event

type cb_lectura from commandbutton within w_sig714_fce_comercializacion
integer x = 2981
integer y = 104
integer width = 343
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

event clicked;String ls_grp_art, ls_rubro, ls_grp_codrel, ls_texto, ls_reporte, ls_msj_err
Long ll_factor, ll_num_fac, ll_num_bol

cb_lectura.enabled = false

ls_grp_art 		= sle_grp_art.text
ls_rubro	  		= sle_rubro.text
ls_grp_codrel 	= sle_grp_codrel.text

// Colocarlo en parametros
ll_num_fac = LONG(em_num_fac.text)
ll_num_bol = LONG(em_num_bol.text)
ll_factor  = LONG(em_kg_bol.text) 

//ll_factor = 50
ls_reporte = 'COMER'

SetPointer(hourglass!)

DECLARE PB_USP_SIGA_IND_VENTA PROCEDURE FOR USP_SIGA_IND_VENTA
(:ls_reporte, TRIM(:ls_grp_art), TRIM(:ls_rubro), TRIM(:ls_grp_codrel), :ll_factor, :ll_num_fac, :ll_num_bol );
EXECUTE PB_USP_SIGA_IND_VENTA ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_VENTA ;

idw_1.ii_zoom_actual = 110
ib_preview = false

event ue_preview()

//idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
//idw_1.SetTransObject(sqlca)

idw_1.retrieve(ls_reporte)

SetPointer(Arrow!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Indicadores de gestión'
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

cb_param.enabled = true

idw_1.visible=true

//parent.event ue_preview()
end event

type sle_grp_art from singlelineedit within w_sig714_fce_comercializacion
integer x = 594
integer y = 76
integer width = 343
integer height = 92
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

type sle_rubro from singlelineedit within w_sig714_fce_comercializacion
integer x = 594
integer y = 192
integer width = 343
integer height = 92
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

type sle_grp_codrel from singlelineedit within w_sig714_fce_comercializacion
integer x = 594
integer y = 304
integer width = 343
integer height = 92
integer taborder = 50
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

type st_1 from statictext within w_sig714_fce_comercializacion
integer x = 101
integer y = 76
integer width = 425
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grupo artículos :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sig714_fce_comercializacion
integer x = 101
integer y = 192
integer width = 480
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Rubro facturación :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sig714_fce_comercializacion
integer x = 101
integer y = 304
integer width = 407
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grupo clientes :"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_sig714_fce_comercializacion
integer x = 937
integer y = 76
integer width = 128
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql

ls_sql = 'SELECT ARTICULO_GRUPO.GRUPO_ART  AS GRUPO,'&
								+'ARTICULO_GRUPO.DESC_GRUPO_ART AS DESCRIPCION '&     	
								+'FROM ARTICULO_GRUPO ' 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	sle_grp_art.text = ls_codigo
	sle_desc_grp_art.text = ls_data
end if


end event

type pb_2 from picturebutton within w_sig714_fce_comercializacion
integer x = 946
integer y = 192
integer width = 128
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql

ls_sql = 'SELECT FACTURA_RUBRO.RUBRO  AS RUBRO,'&
								+'FACTURA_RUBRO.DESCRIPCION AS DESCRIPCION '&     	
								+'FROM FACTURA_RUBRO ' 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	sle_rubro.text = ls_codigo
	sle_desc_rubro.text = ls_data
end if
end event

type pb_3 from picturebutton within w_sig714_fce_comercializacion
integer x = 942
integer y = 304
integer width = 128
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql

ls_sql =  'SELECT ARTICULO_GRUPO.GRUPO_ART  AS GRUPO,'&
								+'ARTICULO_GRUPO.DESC_GRUPO_ART AS DESCRIPCION '&     	
								+'FROM ARTICULO_GRUPO '

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	sle_grp_codrel.text = ls_codigo
	sle_desc_grp_codrel.text = ls_data
end if
end event

type sle_desc_grp_art from singlelineedit within w_sig714_fce_comercializacion
integer x = 1083
integer y = 76
integer width = 1285
integer height = 92
integer taborder = 50
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

type sle_desc_rubro from singlelineedit within w_sig714_fce_comercializacion
integer x = 1083
integer y = 192
integer width = 1285
integer height = 92
integer taborder = 60
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

type sle_desc_grp_codrel from singlelineedit within w_sig714_fce_comercializacion
integer x = 1083
integer y = 304
integer width = 1285
integer height = 92
integer taborder = 60
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

type cb_param from commandbutton within w_sig714_fce_comercializacion
integer x = 2981
integer y = 228
integer width = 343
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Níveles"
end type

event clicked;sg_parametros lstr_rep

IF dw_report.Rowcount( ) = 0 then return

lstr_rep.string1 = 'COMER'
OpenSheetWithParm(w_sig714_fce_comerc_niveles, lstr_rep, w_main, 2, layered!)


end event

type st_4 from statictext within w_sig714_fce_comercializacion
integer x = 2437
integer y = 76
integer width = 329
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "# Facturas :"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sig714_fce_comercializacion
integer x = 2437
integer y = 192
integer width = 329
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "# Bol. venta :"
boolean focusrectangle = false
end type

type st_6 from statictext within w_sig714_fce_comercializacion
integer x = 2423
integer y = 304
integer width = 329
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "# Kg/Bolsa :"
boolean focusrectangle = false
end type

type em_num_fac from editmask within w_sig714_fce_comercializacion
integer x = 2770
integer y = 76
integer width = 155
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_num_bol from editmask within w_sig714_fce_comercializacion
integer x = 2770
integer y = 192
integer width = 155
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_kg_bol from editmask within w_sig714_fce_comercializacion
integer x = 2770
integer y = 304
integer width = 155
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type gb_1 from groupbox within w_sig714_fce_comercializacion
integer x = 41
integer width = 2921
integer height = 424
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
string text = "Parámetros de Lectura"
end type

