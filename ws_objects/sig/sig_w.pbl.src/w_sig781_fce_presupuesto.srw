$PBExportHeader$w_sig781_fce_presupuesto.srw
forward
global type w_sig781_fce_presupuesto from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig781_fce_presupuesto
end type
type cb_param from commandbutton within w_sig781_fce_presupuesto
end type
type st_1 from statictext within w_sig781_fce_presupuesto
end type
type em_ano from editmask within w_sig781_fce_presupuesto
end type
type st_2 from statictext within w_sig781_fce_presupuesto
end type
type st_3 from statictext within w_sig781_fce_presupuesto
end type
type em_mes_ini from editmask within w_sig781_fce_presupuesto
end type
type em_mes_fin from editmask within w_sig781_fce_presupuesto
end type
type cbx_no_fondos from checkbox within w_sig781_fce_presupuesto
end type
type gb_1 from groupbox within w_sig781_fce_presupuesto
end type
end forward

global type w_sig781_fce_presupuesto from w_report_smpl
integer width = 3035
integer height = 1828
string title = "Indicadores de gestión de Presupuesto (SIG781)"
string menuname = "m_rpt_simple"
long backcolor = 15793151
cb_lectura cb_lectura
cb_param cb_param
st_1 st_1
em_ano em_ano
st_2 st_2
st_3 st_3
em_mes_ini em_mes_ini
em_mes_fin em_mes_fin
cbx_no_fondos cbx_no_fondos
gb_1 gb_1
end type
global w_sig781_fce_presupuesto w_sig781_fce_presupuesto

type variables
Decimal id_tipo_cambio
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

on w_sig781_fce_presupuesto.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.cb_param=create cb_param
this.st_1=create st_1
this.em_ano=create em_ano
this.st_2=create st_2
this.st_3=create st_3
this.em_mes_ini=create em_mes_ini
this.em_mes_fin=create em_mes_fin
this.cbx_no_fondos=create cbx_no_fondos
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.cb_param
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_mes_ini
this.Control[iCurrent+8]=this.em_mes_fin
this.Control[iCurrent+9]=this.cbx_no_fondos
this.Control[iCurrent+10]=this.gb_1
end on

on w_sig781_fce_presupuesto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.cb_param)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_mes_ini)
destroy(this.em_mes_fin)
destroy(this.cbx_no_fondos)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;cb_param.enabled = false
em_ano.text = STRING(today(), 'yyyy')
em_mes_ini.text = '1'
em_mes_fin.text = STRING(today(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_sig781_fce_presupuesto
integer x = 50
integer y = 252
integer width = 2834
integer height = 1200
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_grupo
Long ll_ano, ll_mes_ini, ll_mes_fin

sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ls_grupo 	= this.object.sig_fce[row]
ll_ano 		= LONG(em_ano.text)
ll_mes_ini 	= LONG(em_mes_ini.text)
ll_mes_fin 	= LONG(em_mes_fin.text)

lstr_rep.string1 = TRIM(ls_grupo)

OpenSheetWithParm(w_sig781_fce_presup_res_total, lstr_rep, w_main, 2, layered!)	

end event

type cb_lectura from commandbutton within w_sig781_fce_presupuesto
integer x = 2267
integer y = 72
integer width = 315
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

event clicked;String ls_reporte, ls_msj_err, ls_no_fondos 
Long ll_ano, ll_mes_ini, ll_mes_fin

cb_lectura.enabled = false

// Colocarlo en parametros
ls_reporte = 'PRESUP'

ll_ano 		= LONG(em_ano.text)
ll_mes_ini 	= LONG(em_mes_ini.text)
ll_mes_fin 	= LONG(em_mes_fin.text)

SetPointer(hourglass!)

IF cbx_no_fondos.checked THEN
	ls_no_fondos = 'S'
ELSE
	ls_no_fondos = 'N' 
END IF 

DECLARE PB_USP_SIGA_IND_PRESUP PROCEDURE FOR USP_SIGA_IND_PRESUP
(:ls_reporte, :ll_ano, :ll_mes_ini, :ll_mes_fin, :ls_no_fondos );

EXECUTE PB_USP_SIGA_IND_PRESUP ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_PRESUP ;

idw_1.retrieve(ls_reporte)

SetPointer(Arrow!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Factores críticos de éxito'
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

cb_param.enabled = true

idw_1.visible=false
ib_preview = false
idw_1.ii_zoom_actual = 100
idw_1.visible=true

parent.event ue_preview()
end event

type cb_param from commandbutton within w_sig781_fce_presupuesto
integer x = 2606
integer y = 68
integer width = 343
integer height = 72
integer taborder = 40
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

lstr_rep.string1 = 'PRESUP'
OpenSheetWithParm(w_sig791_fce_finanzas_niveles, lstr_rep, w_main, 2, layered!)


end event

type st_1 from statictext within w_sig781_fce_presupuesto
integer x = 82
integer y = 92
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Año :"
boolean focusrectangle = false
end type

type em_ano from editmask within w_sig781_fce_presupuesto
integer x = 229
integer y = 80
integer width = 160
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
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_2 from statictext within w_sig781_fce_presupuesto
integer x = 498
integer y = 96
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Mes inicio :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sig781_fce_presupuesto
integer x = 1120
integer y = 92
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Mes fin :"
boolean focusrectangle = false
end type

type em_mes_ini from editmask within w_sig781_fce_presupuesto
integer x = 809
integer y = 80
integer width = 160
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
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_mes_fin from editmask within w_sig781_fce_presupuesto
integer x = 1353
integer y = 80
integer width = 160
integer height = 100
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
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type cbx_no_fondos from checkbox within w_sig781_fce_presupuesto
integer x = 1637
integer y = 76
integer width = 375
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No fondos"
boolean checked = true
end type

type gb_1 from groupbox within w_sig781_fce_presupuesto
integer x = 46
integer y = 16
integer width = 1495
integer height = 176
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 15793151
string text = "Parámetros"
end type

