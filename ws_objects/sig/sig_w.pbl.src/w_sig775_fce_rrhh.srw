$PBExportHeader$w_sig775_fce_rrhh.srw
forward
global type w_sig775_fce_rrhh from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig775_fce_rrhh
end type
type cb_param from commandbutton within w_sig775_fce_rrhh
end type
type st_1 from statictext within w_sig775_fce_rrhh
end type
type em_ano from editmask within w_sig775_fce_rrhh
end type
type gb_1 from groupbox within w_sig775_fce_rrhh
end type
end forward

global type w_sig775_fce_rrhh from w_report_smpl
integer width = 3109
integer height = 2004
string title = "Indicadores de gestión de RRHH (SIG775)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
cb_param cb_param
st_1 st_1
em_ano em_ano
gb_1 gb_1
end type
global w_sig775_fce_rrhh w_sig775_fce_rrhh

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

on w_sig775_fce_rrhh.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.cb_param=create cb_param
this.st_1=create st_1
this.em_ano=create em_ano
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.cb_param
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.gb_1
end on

on w_sig775_fce_rrhh.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.cb_param)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//sle_desc_grp_codrel.text = ls_desc_grp_codrel
em_ano.text = string(today(),'yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_sig775_fce_rrhh
integer x = 55
integer y = 220
integer width = 2816
integer height = 1356
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_reporte, ls_grupo
Long ll_ano

sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ll_ano = Long(em_ano.text)

ls_grupo = this.object.sig_fce[row]

IF ls_grupo = 'SDO_RRHH' THEN		
	lstr_rep.long1 = ll_ano
	OpenSheetWithParm(w_sig775_fce_res_cnta_crte, lstr_rep, w_main, 2, layered!)
//ELSEIF ls_grupo = 'IGV_CNTA' THEN
//	lstr_rep.string1 = ls_cnta_ctbl
//	lstr_rep.long1 = ll_ano
//	OpenSheetWithParm(w_sig770_res_saldo_igv, lstr_rep, w_main, 2, layered!)
//	
END IF

end event

type cb_lectura from commandbutton within w_sig775_fce_rrhh
integer x = 2702
integer y = 32
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

event clicked;Long ll_ano_contable
String ls_reporte, ls_msj_err

cb_lectura.enabled = false

ll_ano_contable = LONG(em_ano.text)
ls_reporte = 'RRHH'

SetPointer(hourglass!)

DECLARE PB_USP_SIGA_IND_RRHH PROCEDURE FOR USP_SIGA_IND_RRHH
(:ls_reporte, :ll_ano_contable);
EXECUTE PB_USP_SIGA_IND_RRHH ;


cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_RRHH ;

idw_1.ii_zoom_actual = 110
ib_preview = false

event ue_preview()

idw_1.retrieve(ls_reporte)

SetPointer(Arrow!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Indicadores de gestión'
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

cb_param.enabled = true

idw_1.visible=true

end event

type cb_param from commandbutton within w_sig775_fce_rrhh
integer x = 2706
integer y = 120
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

type st_1 from statictext within w_sig775_fce_rrhh
integer x = 87
integer y = 64
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

type em_ano from editmask within w_sig775_fce_rrhh
integer x = 251
integer y = 64
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

type gb_1 from groupbox within w_sig775_fce_rrhh
integer x = 41
integer y = 4
integer width = 645
integer height = 176
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

