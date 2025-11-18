$PBExportHeader$w_sig725_fce_sembradores.srw
forward
global type w_sig725_fce_sembradores from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig725_fce_sembradores
end type
type sle_dias from singlelineedit within w_sig725_fce_sembradores
end type
type sle_grp_codrel from singlelineedit within w_sig725_fce_sembradores
end type
type st_2 from statictext within w_sig725_fce_sembradores
end type
type st_3 from statictext within w_sig725_fce_sembradores
end type
type pb_3 from picturebutton within w_sig725_fce_sembradores
end type
type sle_desc_grp_codrel from singlelineedit within w_sig725_fce_sembradores
end type
type cb_param from commandbutton within w_sig725_fce_sembradores
end type
type gb_1 from groupbox within w_sig725_fce_sembradores
end type
end forward

global type w_sig725_fce_sembradores from w_report_smpl
integer width = 3465
integer height = 1828
string title = "Indicadores de gestión de sembradores (SIG725)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
sle_dias sle_dias
sle_grp_codrel sle_grp_codrel
st_2 st_2
st_3 st_3
pb_3 pb_3
sle_desc_grp_codrel sle_desc_grp_codrel
cb_param cb_param
gb_1 gb_1
end type
global w_sig725_fce_sembradores w_sig725_fce_sembradores

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

on w_sig725_fce_sembradores.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.sle_dias=create sle_dias
this.sle_grp_codrel=create sle_grp_codrel
this.st_2=create st_2
this.st_3=create st_3
this.pb_3=create pb_3
this.sle_desc_grp_codrel=create sle_desc_grp_codrel
this.cb_param=create cb_param
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.sle_dias
this.Control[iCurrent+3]=this.sle_grp_codrel
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.sle_desc_grp_codrel
this.Control[iCurrent+8]=this.cb_param
this.Control[iCurrent+9]=this.gb_1
end on

on w_sig725_fce_sembradores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.sle_dias)
destroy(this.sle_grp_codrel)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_3)
destroy(this.sle_desc_grp_codrel)
destroy(this.cb_param)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;// Antiguo datawindows, d_rpt_fce_comerc_tbl

String ls_dias

cb_param.enabled = false

// Asignando por defecto a los sle_textos
sle_dias.text = '540'


end event

type dw_report from w_report_smpl`dw_report within w_sig725_fce_sembradores
integer x = 50
integer y = 308
integer width = 3136
integer height = 1036
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_reporte, ls_grupo
Long ll_factor

sg_parametros lstr_rep

IF this.Rowcount( ) = 0 then return

ls_grupo = this.object.sig_fce[row]

IF ls_grupo = 'SDO_SEMB' THEN
	//lstr_rep.string1 = ls_grupo_art
	lstr_rep.long1 = LONG(sle_dias.text)
	OpenSheetWithParm(w_sig725_cnta_cobrar_sem_res, lstr_rep, w_main, 2, layered!)
	
END IF

end event

type cb_lectura from commandbutton within w_sig725_fce_sembradores
integer x = 2555
integer y = 48
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

event clicked;String ls_texto, ls_reporte, ls_msj_err
Long ll_factor

cb_lectura.enabled = false

ll_factor = LONG(sle_dias.text)

// Colocarlo en parametros
ls_reporte = 'SEMBR'

SetPointer(hourglass!)

DECLARE PB_USP_SIGA_IND_SEMBR PROCEDURE FOR USP_SIGA_IND_SEMBR
(:ls_reporte, :ll_factor );
EXECUTE PB_USP_SIGA_IND_SEMBR ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_SEMBR ;

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

type sle_dias from singlelineedit within w_sig725_fce_sembradores
integer x = 608
integer y = 116
integer width = 238
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

type sle_grp_codrel from singlelineedit within w_sig725_fce_sembradores
boolean visible = false
integer x = 818
integer y = 1404
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sig725_fce_sembradores
integer x = 91
integer y = 112
integer width = 503
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Dias considerados :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sig725_fce_sembradores
boolean visible = false
integer x = 325
integer y = 1404
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
boolean enabled = false
string text = "Grupo clientes :"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_sig725_fce_sembradores
boolean visible = false
integer x = 1202
integer y = 1404
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
boolean enabled = false
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;/*
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO_GRUPO.GRUPO_ART  AS GRUPO,'&
								+'ARTICULO_GRUPO.DESC_GRUPO_ART AS DESCRIPCION '&     	
								+'FROM ARTICULO_GRUPO ' 

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_grp_art.text = lstr_seleccionar.param1[1]
	sle_desc_grp_art.text = lstr_seleccionar.param2[1]
END IF
*/
//select grupo, descripcion from grupo_proveedor
end event

type sle_desc_grp_codrel from singlelineedit within w_sig725_fce_sembradores
boolean visible = false
integer x = 1367
integer y = 1404
integer width = 1431
integer height = 92
integer taborder = 60
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

type cb_param from commandbutton within w_sig725_fce_sembradores
integer x = 2555
integer y = 172
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

type gb_1 from groupbox within w_sig725_fce_sembradores
integer x = 41
integer y = 32
integer width = 837
integer height = 228
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Parametros de Lectura"
end type

