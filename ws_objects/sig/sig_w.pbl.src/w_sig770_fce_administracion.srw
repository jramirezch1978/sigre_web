$PBExportHeader$w_sig770_fce_administracion.srw
forward
global type w_sig770_fce_administracion from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig770_fce_administracion
end type
type sle_grp_codrel from singlelineedit within w_sig770_fce_administracion
end type
type st_3 from statictext within w_sig770_fce_administracion
end type
type pb_3 from picturebutton within w_sig770_fce_administracion
end type
type sle_desc_grp_codrel from singlelineedit within w_sig770_fce_administracion
end type
type cb_param from commandbutton within w_sig770_fce_administracion
end type
type st_1 from statictext within w_sig770_fce_administracion
end type
type em_ano from editmask within w_sig770_fce_administracion
end type
type st_2 from statictext within w_sig770_fce_administracion
end type
type em_grupo_cnt_38 from editmask within w_sig770_fce_administracion
end type
type em_grupo_cnt_66 from editmask within w_sig770_fce_administracion
end type
type st_4 from statictext within w_sig770_fce_administracion
end type
type st_5 from statictext within w_sig770_fce_administracion
end type
type em_cnta_ctbl from editmask within w_sig770_fce_administracion
end type
type gb_1 from groupbox within w_sig770_fce_administracion
end type
end forward

global type w_sig770_fce_administracion from w_report_smpl
integer width = 3072
integer height = 1828
string title = "Indicadores de gestión de Administración (SIG770)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
sle_grp_codrel sle_grp_codrel
st_3 st_3
pb_3 pb_3
sle_desc_grp_codrel sle_desc_grp_codrel
cb_param cb_param
st_1 st_1
em_ano em_ano
st_2 st_2
em_grupo_cnt_38 em_grupo_cnt_38
em_grupo_cnt_66 em_grupo_cnt_66
st_4 st_4
st_5 st_5
em_cnta_ctbl em_cnta_ctbl
gb_1 gb_1
end type
global w_sig770_fce_administracion w_sig770_fce_administracion

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

on w_sig770_fce_administracion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.sle_grp_codrel=create sle_grp_codrel
this.st_3=create st_3
this.pb_3=create pb_3
this.sle_desc_grp_codrel=create sle_desc_grp_codrel
this.cb_param=create cb_param
this.st_1=create st_1
this.em_ano=create em_ano
this.st_2=create st_2
this.em_grupo_cnt_38=create em_grupo_cnt_38
this.em_grupo_cnt_66=create em_grupo_cnt_66
this.st_4=create st_4
this.st_5=create st_5
this.em_cnta_ctbl=create em_cnta_ctbl
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.sle_grp_codrel
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.sle_desc_grp_codrel
this.Control[iCurrent+6]=this.cb_param
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_ano
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.em_grupo_cnt_38
this.Control[iCurrent+11]=this.em_grupo_cnt_66
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.em_cnta_ctbl
this.Control[iCurrent+15]=this.gb_1
end on

on w_sig770_fce_administracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.sle_grp_codrel)
destroy(this.st_3)
destroy(this.pb_3)
destroy(this.sle_desc_grp_codrel)
destroy(this.cb_param)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.em_grupo_cnt_38)
destroy(this.em_grupo_cnt_66)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.em_cnta_ctbl)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;// Antiguo datawindows, d_rpt_fce_comerc_tbl

String ls_grp_codrel, ls_desc_grp_codrel, ls_cnta_ctbl

cb_param.enabled = false

// Pasarlo a parametros
select TRIM(descripcion)
  into :ls_grp_codrel 
  from rpt_subgrupo rs
 where rs.reporte='PARAMET' and rs.grupo='ADMIN' and rs.subgrupo='GRCR' ;

select descripcion 
  into :ls_desc_grp_codrel 
  from grupo_proveedor gp
 where gp.grupo=:ls_grp_codrel ;
 
select i.cnta_ctbl
  into :ls_cnta_ctbl
  from logparam l, impuestos_tipo i
 where reckey='1' and
       l.cod_igv=i.tipo_impuesto ;

// Asignando por defecto a los sle_textos
sle_grp_codrel.text = ls_grp_codrel
sle_desc_grp_codrel.text = ls_desc_grp_codrel
em_ano.text = string(today(),'yyyy')
em_grupo_cnt_38.text = '38'
em_grupo_cnt_66.text = '66'
em_cnta_ctbl.text = ls_cnta_ctbl

end event

type dw_report from w_report_smpl`dw_report within w_sig770_fce_administracion
integer x = 55
integer y = 384
integer width = 2647
integer height = 1192
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_reporte, ls_grupo, ls_grupo_codrel, ls_grupo_contab_66, ls_grupo_contab_38, ls_cnta_ctbl
Long ll_ano

sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ls_grupo = this.object.sig_fce[row]
ls_grupo_codrel = sle_grp_codrel.text
ll_ano = Long(em_ano.text)
ls_grupo_contab_66 = em_grupo_cnt_66.text
ls_grupo_contab_38 = em_grupo_cnt_38.text
ls_cnta_ctbl = em_cnta_ctbl.text

IF ls_grupo = 'SDO_CODR' THEN		
	lstr_rep.string1 = ls_grupo_codrel
	OpenSheetWithParm(w_sig770_res_saldo_cta_cte, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo = 'SDO_CT38' THEN		
	lstr_rep.string1 = ls_grupo_contab_38
	lstr_rep.long1 = ll_ano
	OpenSheetWithParm(w_sig770_res_saldo_cta_38, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo = 'SDO_CNTA' THEN		
	lstr_rep.string1 = ls_grupo_contab_66
	lstr_rep.long1 = ll_ano
	OpenSheetWithParm(w_sig770_res_saldo_cta_cntbl, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo = 'REQ_VENC' THEN
	lstr_rep.string1 = ls_grupo_codrel
	OpenSheetWithParm(w_sig770_res_requer_n1_vencidos, lstr_rep, w_main, 2, layered!)
ELSEIF ls_grupo = 'IGV_CNTA' THEN
	lstr_rep.string1 = ls_cnta_ctbl
	lstr_rep.long1 = ll_ano
	OpenSheetWithParm(w_sig770_res_saldo_igv, lstr_rep, w_main, 2, layered!)
	
END IF

end event

type cb_lectura from commandbutton within w_sig770_fce_administracion
integer x = 2629
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

event clicked;String ls_grp_codrel, ls_grupo_contable_38, ls_grupo_contable_66, ls_texto, ls_reporte, &
		 ls_msj_err, ls_cnta_ctbl
Long ll_ano_contable

cb_lectura.enabled = false

ls_grp_codrel = sle_grp_codrel.text
ls_grupo_contable_38 = em_grupo_cnt_38.text
ls_grupo_contable_66 = em_grupo_cnt_66.text
ll_ano_contable = LONG(em_ano.text)
ls_cnta_ctbl = em_cnta_ctbl.text
ls_reporte = 'ADMIN'

SetPointer(hourglass!)

DECLARE PB_USP_SIGA_IND_ADMIN PROCEDURE FOR USP_SIGA_IND_ADMIN
(:ls_reporte, TRIM(:ls_grp_codrel), TRIM(:ls_grupo_contable_38), TRIM(:ls_grupo_contable_66), 
 :ll_ano_contable, :ls_cnta_ctbl);
EXECUTE PB_USP_SIGA_IND_ADMIN ;


cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_ADMIN ;

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

type sle_grp_codrel from singlelineedit within w_sig770_fce_administracion
integer x = 736
integer y = 72
integer width = 343
integer height = 88
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

type st_3 from statictext within w_sig770_fce_administracion
integer x = 91
integer y = 72
integer width = 622
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grupo códigos relación :"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_sig770_fce_administracion
integer x = 1083
integer y = 72
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

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO_GRUPO.GRUPO_ART  AS GRUPO,'&
								+'ARTICULO_GRUPO.DESC_GRUPO_ART AS DESCRIPCION '&     	
								+'FROM ARTICULO_GRUPO ' 

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_grp_codrel.text = lstr_seleccionar.param1[1]
	sle_desc_grp_codrel.text = lstr_seleccionar.param2[1]
END IF

//select grupo, descripcion from grupo_proveedor
end event

type sle_desc_grp_codrel from singlelineedit within w_sig770_fce_administracion
integer x = 1225
integer y = 72
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

type cb_param from commandbutton within w_sig770_fce_administracion
integer x = 2629
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

lstr_rep.string1 = 'ADMIN'
OpenSheetWithParm(w_sig714_fce_comerc_niveles, lstr_rep, w_main, 2, layered!)


end event

type st_1 from statictext within w_sig770_fce_administracion
integer x = 87
integer y = 204
integer width = 146
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Año :"
boolean focusrectangle = false
end type

type em_ano from editmask within w_sig770_fce_administracion
integer x = 251
integer y = 204
integer width = 178
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_2 from statictext within w_sig770_fce_administracion
integer x = 544
integer y = 204
integer width = 434
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grp contab (CC) :"
boolean focusrectangle = false
end type

type em_grupo_cnt_38 from editmask within w_sig770_fce_administracion
integer x = 992
integer y = 204
integer width = 142
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_grupo_cnt_66 from editmask within w_sig770_fce_administracion
integer x = 1609
integer y = 196
integer width = 142
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_4 from statictext within w_sig770_fce_administracion
integer x = 1289
integer y = 200
integer width = 325
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grp contab :"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sig770_fce_administracion
integer x = 1856
integer y = 200
integer width = 311
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Cnta. Ctbl. :"
boolean focusrectangle = false
end type

type em_cnta_ctbl from editmask within w_sig770_fce_administracion
integer x = 2162
integer y = 196
integer width = 343
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type gb_1 from groupbox within w_sig770_fce_administracion
integer x = 41
integer width = 2533
integer height = 352
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

