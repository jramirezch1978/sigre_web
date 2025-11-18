$PBExportHeader$w_sig791_fce_finanzas.srw
forward
global type w_sig791_fce_finanzas from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig791_fce_finanzas
end type
type cb_param from commandbutton within w_sig791_fce_finanzas
end type
type em_dias_atrazo from editmask within w_sig791_fce_finanzas
end type
type st_1 from statictext within w_sig791_fce_finanzas
end type
type em_grupo_cp from editmask within w_sig791_fce_finanzas
end type
type st_2 from statictext within w_sig791_fce_finanzas
end type
type em_ano from editmask within w_sig791_fce_finanzas
end type
type st_3 from statictext within w_sig791_fce_finanzas
end type
type em_grp_codrel from editmask within w_sig791_fce_finanzas
end type
type st_5 from statictext within w_sig791_fce_finanzas
end type
type uo_1 from u_ingreso_rango_fechas within w_sig791_fce_finanzas
end type
type st_4 from statictext within w_sig791_fce_finanzas
end type
type em_flag_cc from editmask within w_sig791_fce_finanzas
end type
type st_6 from statictext within w_sig791_fce_finanzas
end type
type gb_1 from groupbox within w_sig791_fce_finanzas
end type
end forward

global type w_sig791_fce_finanzas from w_report_smpl
integer width = 3269
integer height = 2180
string title = "Indicadores de gestión de Finanzas (SIG791)"
string menuname = "m_rpt_simple"
long backcolor = 15793151
cb_lectura cb_lectura
cb_param cb_param
em_dias_atrazo em_dias_atrazo
st_1 st_1
em_grupo_cp em_grupo_cp
st_2 st_2
em_ano em_ano
st_3 st_3
em_grp_codrel em_grp_codrel
st_5 st_5
uo_1 uo_1
st_4 st_4
em_flag_cc em_flag_cc
st_6 st_6
gb_1 gb_1
end type
global w_sig791_fce_finanzas w_sig791_fce_finanzas

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

on w_sig791_fce_finanzas.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.cb_param=create cb_param
this.em_dias_atrazo=create em_dias_atrazo
this.st_1=create st_1
this.em_grupo_cp=create em_grupo_cp
this.st_2=create st_2
this.em_ano=create em_ano
this.st_3=create st_3
this.em_grp_codrel=create em_grp_codrel
this.st_5=create st_5
this.uo_1=create uo_1
this.st_4=create st_4
this.em_flag_cc=create em_flag_cc
this.st_6=create st_6
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.cb_param
this.Control[iCurrent+3]=this.em_dias_atrazo
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_grupo_cp
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.em_ano
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.em_grp_codrel
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.uo_1
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.em_flag_cc
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.gb_1
end on

on w_sig791_fce_finanzas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.cb_param)
destroy(this.em_dias_atrazo)
destroy(this.st_1)
destroy(this.em_grupo_cp)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.em_grp_codrel)
destroy(this.st_5)
destroy(this.uo_1)
destroy(this.st_4)
destroy(this.em_flag_cc)
destroy(this.st_6)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_grp_doc, ls_grp_codrel
Long ll_count

// Grupo de documentos de cuentas por pagar
SELECT count(*) 
  INTO :ll_count 
  FROM rpt_subgrupo_det r 
 WHERE r.reporte='PARAMET' and 
 		 r.grupo='FINANZ' and 
		 r.subgrupo='GCNTAP' ;

IF ll_count>0 THEN
	SELECT trim(cnta_ctbl)
	  INTO :ls_grp_doc
	  FROM rpt_subgrupo_det r 
	 WHERE r.reporte='PARAMET' and 
			 r.grupo='FINANZ' and 
			 r.subgrupo='GCNTAP' ;
ELSE
	ls_grp_doc = 'CP'
END IF


// Grupo de codigos de relacion
SELECT count(*) 
  INTO :ll_count 
  FROM rpt_subgrupo_det r 
 WHERE r.reporte='PARAMET' and 
 		 r.grupo='FINANZ' and 
		 r.subgrupo='GCODRE' ;

IF ll_count>0 THEN
	SELECT trim(cnta_ctbl)
	  INTO :ls_grp_codrel
	  FROM rpt_subgrupo_det r 
	 WHERE r.reporte='PARAMET' and 
			 r.grupo='FINANZ' and 
			 r.subgrupo='GCODRE' ;
ELSE
	ls_grp_codrel = 'ADMIN'
END IF

cb_param.enabled = false
// Colocar en parametros
em_dias_atrazo.text = '30'
em_grupo_cp.text = ls_grp_doc
em_ano.text = string(today(),'yyyy')
em_grp_codrel.text = ls_grp_codrel
em_flag_cc.text = 'P'
end event

type dw_report from w_report_smpl`dw_report within w_sig791_fce_finanzas
integer x = 50
integer y = 316
integer width = 2930
integer height = 1136
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_grupo, ls_doc_anticipo_oc, ls_doc_anticipo_os, &
		 ls_doc_anticipo_og, ls_letra_pagar, ls_grupo_cnta_pagar, &
		 ls_ano, ls_msj_err, ls_tipo_ciclo_caja
Long ln_dias

sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

ls_grupo = this.object.sig_fce[row]
ls_ano = em_ano.text
ln_dias = LONG(em_dias_atrazo.text)
ls_grupo_cnta_pagar = em_grupo_cp.text

select f.doc_anticipo_oc, f.doc_anticipo_os, f.doc_sol_giro, f.doc_letra_pagar
  into :ls_doc_anticipo_oc, :ls_doc_anticipo_os, :ls_doc_anticipo_og, :ls_letra_pagar
  from finparam f 
 where reckey='1' ;

IF ls_grupo = 'SDO_BCOS' THEN
	OpenSheet(w_sig791_indicador_bancos_det, w_main, 2, layered!)

ELSEIF ls_grupo = 'ANT_CPAG' THEN

	DECLARE PB_USP_SIG_ANTICIPOS_PAGAR PROCEDURE FOR USP_SIG_ANTICIPOS_PAGAR
	(:ln_dias, :ls_ano );

	EXECUTE PB_USP_SIG_ANTICIPOS_PAGAR ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
		Messagebox('Error',ls_msj_err)
		Return
	END IF
	
	CLOSE PB_USP_SIG_ANTICIPOS_PAGAR ;
	
	lstr_rep.long1 = ln_dias
	lstr_rep.string1 = ls_ano
	OpenSheetWithParm(w_sig791_res_saldo_anticipos, lstr_rep, w_main, 2, layered!)	

ELSEIF ls_grupo = 'SDO_LTRP' THEN
	lstr_rep.string1 = ls_letra_pagar
	OpenSheetWithParm(w_sig791_res_saldo_letras_pagar, lstr_rep, w_main, 2, layered!)		

ELSEIF ls_grupo = 'SDO_FACP' THEN
	lstr_rep.string1 = ls_grupo_cnta_pagar
	OpenSheetWithParm(w_sig791_res_cntas_pagar, lstr_rep, w_main, 2, layered!)	
	
ELSEIF ls_grupo = 'ANT_CNTP' THEN
	lstr_rep.long1 = LONG(ls_ano)
	OpenSheetWithParm(w_sig791_res_antic_x_pagar_cont, lstr_rep, w_main, 2, layered!)

ELSEIF ls_grupo = 'CC1_SQUI' THEN
	lstr_rep.string1 = 'C'
	OpenSheetWithParm(w_sig791_res_ciclo_caja, lstr_rep, w_main, 2, layered!)

ELSEIF ls_grupo = 'CP1_SQUI' THEN 
	lstr_rep.string1 = 'P'
	OpenSheetWithParm(w_sig791_res_ciclo_caja, lstr_rep, w_main, 2, layered!)

END IF

end event

type cb_lectura from commandbutton within w_sig791_fce_finanzas
integer x = 2894
integer y = 56
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

event clicked;String ls_reporte, ls_msj_err, ls_doc_anticipo_oc, ls_doc_anticipo_os, ls_doc_anticipo_og, &
	    ls_grp_codrel
String ls_grupo_cp, ls_ano, ls_flag_cc
Long ll_factor, ll_dias
Date ld_fec_ini, ld_fec_fin

cb_lectura.enabled = false

// Colocarlo en parametros
ls_reporte = 'FINANZ'

select f.doc_anticipo_oc, f.doc_anticipo_os, f.doc_sol_giro 
  into :ls_doc_anticipo_oc, :ls_doc_anticipo_os, :ls_doc_anticipo_og
  from finparam f 
 where reckey='1' ;

ll_dias				 = LONG(em_dias_atrazo.text)
ls_ano				 = em_ano.text
ls_grupo_cp			 = em_grupo_cp.text
ls_grp_codrel		 = em_grp_codrel.text
ls_flag_cc			 = em_flag_cc.text
ld_fec_ini			 = uo_1.of_get_fecha1()
ld_fec_fin			 = uo_1.of_get_fecha2() 

SetPointer(hourglass!)

DECLARE PB_USP_SIGA_IND_FINAN PROCEDURE FOR USP_SIGA_IND_FINAN
(:ls_reporte, :ll_dias, :ls_grupo_cp, :ls_ano, :ls_grp_codrel, :ls_flag_cc, :ld_fec_ini, :ld_fec_fin );

EXECUTE PB_USP_SIGA_IND_FINAN ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_FINAN ;

//idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
//idw_1.SetTransObject(sqlca)

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


//ib_preview = false
//idw_1.visible=true
//idw_1.ii_zoom_actual = 100

parent.event ue_preview()
end event

type cb_param from commandbutton within w_sig791_fce_finanzas
integer x = 2894
integer y = 140
integer width = 315
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

lstr_rep.string1 = 'FINANZ'
OpenSheetWithParm(w_sig791_fce_finanzas_niveles, lstr_rep, w_main, 2, layered!)


end event

type em_dias_atrazo from editmask within w_sig791_fce_finanzas
integer x = 1211
integer y = 80
integer width = 178
integer height = 84
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
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type st_1 from statictext within w_sig791_fce_finanzas
integer x = 658
integer y = 88
integer width = 549
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
string text = "Días atraso anticipos :"
boolean focusrectangle = false
end type

type em_grupo_cp from editmask within w_sig791_fce_finanzas
integer x = 1897
integer y = 80
integer width = 174
integer height = 84
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
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_sig791_fce_finanzas
integer x = 1422
integer y = 88
integer width = 475
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
string text = "Grp cntas x pagar :"
boolean focusrectangle = false
end type

type em_ano from editmask within w_sig791_fce_finanzas
integer x = 457
integer y = 76
integer width = 178
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_3 from statictext within w_sig791_fce_finanzas
integer x = 78
integer y = 80
integer width = 379
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
string text = "Año contable :"
boolean focusrectangle = false
end type

type em_grp_codrel from editmask within w_sig791_fce_finanzas
integer x = 2565
integer y = 80
integer width = 274
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!"
end type

type st_5 from statictext within w_sig791_fce_finanzas
integer x = 2089
integer y = 76
integer width = 466
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
string text = "Grp cód. relación :"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_sig791_fce_finanzas
integer x = 1550
integer y = 184
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;Date ld_fec_ini

select trunc(sysdate,'yyyy') into :ld_fec_ini from dual ;

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fec_ini, today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_4 from statictext within w_sig791_fce_finanzas
integer x = 361
integer y = 188
integer width = 837
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
string text = "[P]=pptt, [S]=sub pptt, [T]=todos :"
boolean focusrectangle = false
end type

type em_flag_cc from editmask within w_sig791_fce_finanzas
integer x = 1221
integer y = 180
integer width = 114
integer height = 84
integer taborder = 50
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
maskdatatype maskdatatype = stringmask!
string mask = "!"
end type

type st_6 from statictext within w_sig791_fce_finanzas
integer x = 78
integer y = 196
integer width = 279
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 15793151
string text = "Ciclo caja:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sig791_fce_finanzas
integer x = 46
integer y = 16
integer width = 2825
integer height = 280
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

