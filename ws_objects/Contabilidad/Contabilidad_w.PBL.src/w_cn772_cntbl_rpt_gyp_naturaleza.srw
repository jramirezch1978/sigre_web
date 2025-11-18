$PBExportHeader$w_cn772_cntbl_rpt_gyp_naturaleza.srw
forward
global type w_cn772_cntbl_rpt_gyp_naturaleza from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type sle_mes_desde from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type cb_1 from commandbutton within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type st_3 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type st_4 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type ddlb_2 from dropdownlistbox within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type st_2 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type st_7 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type st_1 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type sle_mes_hasta from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type em_nivel from editmask within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type cbx_1 from checkbox within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type gb_1 from groupbox within w_cn772_cntbl_rpt_gyp_naturaleza
end type
type gb_2 from groupbox within w_cn772_cntbl_rpt_gyp_naturaleza
end type
end forward

global type w_cn772_cntbl_rpt_gyp_naturaleza from w_report_smpl
integer width = 3397
integer height = 1624
string title = "(CN772) Ganancias y Pérdidas por Naturaleza"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes_desde sle_mes_desde
cb_1 cb_1
st_3 st_3
st_4 st_4
ddlb_2 ddlb_2
st_2 st_2
st_7 st_7
st_1 st_1
sle_mes_hasta sle_mes_hasta
em_nivel em_nivel
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn772_cntbl_rpt_gyp_naturaleza w_cn772_cntbl_rpt_gyp_naturaleza

on w_cn772_cntbl_rpt_gyp_naturaleza.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_desde=create sle_mes_desde
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_2=create ddlb_2
this.st_2=create st_2
this.st_7=create st_7
this.st_1=create st_1
this.sle_mes_hasta=create sle_mes_hasta
this.em_nivel=create em_nivel
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_desde
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_mes_hasta
this.Control[iCurrent+11]=this.em_nivel
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_cn772_cntbl_rpt_gyp_naturaleza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_desde)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_2)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.st_1)
destroy(this.sle_mes_hasta)
destroy(this.em_nivel)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer ln_ano, ln_mes_desde, ln_mes_hasta, ln_nivel, ln_niveles
string  ls_moneda, ls_nom_empresa

ls_moneda    = string(upper(ddlb_2.Text))
ln_ano       = integer(sle_ano.text)
ln_mes_desde = integer(sle_mes_desde.text)
ln_mes_hasta = integer(sle_mes_hasta.text)
ln_nivel	    = integer(em_nivel.text)

select nro_niveles into :ln_niveles from cntblparam
  where reckey = '1' ;
  
if (ln_nivel > ln_niveles) or isnull(ln_nivel) or ln_nivel = 0 then
	MessageBox('Aviso','Número de nivel no existe', StopSign!)
	return
end if

if isnull(ln_ano) or ln_ano = 0 then
	MessageBox('Aviso','Debe seleccionar año de proceso', StopSign!)
	return
end if

if isnull(ln_mes_hasta) or ln_mes_hasta = 0 then
	MessageBox('Aviso','Debe seleccionar mes de proceso', StopSign!)
	return
end if

if ln_mes_desde > ln_mes_hasta then
	MessageBox('Aviso','Rango de meses no es correcto, Verifique', StopSign!)
	return
end if

SetPointer(hourglass!)
  
DECLARE USP_CNTBL_RPT_GYP_NATURALEZA PROCEDURE FOR 
	USP_CNTBL_RPT_GYP_NATURALEZA( :ln_mes_desde, 
											:ln_mes_hasta, 
											:ln_ano, 
											:ls_moneda, 
											:ln_nivel ) ;
Execute USP_CNTBL_RPT_GYP_NATURALEZA ;

if gnvo_app.of_existserror( SQLCA, 'Proceduce USP_CNTBL_RPT_GYP_NATURALEZA') then
	rollback;
	return
end if

dw_report.retrieve()

close USP_CNTBL_RPT_GYP_NATURALEZA;

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_ruc.text = gs_ruc

Select nombre
	into :ls_nom_empresa
from empresa
where trim(sigla) = trim(:gs_empresa);
dw_report.object.t_empresa2.text  = ls_nom_empresa

IF gs_empresa = 'FISHOLG' then
	dw_report.object.t_14.text = 'ESTADO DE RESULTADOS POR NATURALEZA'
end if
end event

type dw_report from w_report_smpl`dw_report within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 0
integer y = 204
integer width = 3291
integer height = 1116
integer taborder = 70
string dataobject = "d_rpt_gyp_naturaleza_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;Long ll_ano, ll_mes_ini, ll_mes_fin, ll_nivel, ll_nro_dig
Long ln_niv1, ln_niv2, ln_niv3, ln_niv4, ln_niv5, ln_niv6, ln_niv7, &
	  ln_niv8, ln_niv9, ln_niv10

String ls_cnta_ctbl
sg_parametros_est lstr_rep

IF row = 0 THEN Return

IF this.Rowcount( ) = 0 then return

ll_ano 		= LONG(sle_ano.text)
ll_mes_ini 	= LONG(sle_mes_desde.text)
ll_mes_fin 	= LONG(sle_mes_hasta.text)
ll_nivel 	= LONG(em_nivel.text)
ls_cnta_ctbl = THIS.GetItemString(row, 'cnta_cntbl')

lstr_rep.long1 = ll_ano
lstr_rep.long2 = ll_mes_ini
lstr_rep.long3 = ll_mes_fin


SELECT c.nivel1, c.nivel2, c.nivel3, c.nivel4, 
       c.nivel5, c.nivel6, c.nivel7, c.nivel8, 
       c.nivel9, c.nivel10
  INTO :ln_niv1, :ln_niv2, :ln_niv3, :ln_niv4, 
       :ln_niv5, :ln_niv6, :ln_niv7, :ln_niv8, 
		 :ln_niv9, :ln_niv10
  FROM cntblparam c 
 WHERE reckey='1' ;

IF ll_nivel=1 THEN
	ll_nro_dig = ln_niv1
ELSEIF ll_nivel=2 THEN
	ll_nro_dig = ln_niv2	
ELSEIF ll_nivel=3 THEN
	ll_nro_dig = ln_niv3	
ELSEIF ll_nivel=4 THEN
	ll_nro_dig = ln_niv4	
ELSEIF ll_nivel=5 THEN
	ll_nro_dig = ln_niv5	
ELSEIF ll_nivel=6 THEN
	ll_nro_dig = ln_niv6	
ELSEIF ll_nivel=7 THEN
	ll_nro_dig = ln_niv7	
ELSEIF ll_nivel=8 THEN
	ll_nro_dig = ln_niv8	
ELSEIF ll_nivel=9 THEN
	ll_nro_dig = ln_niv9	
ELSEIF ll_nivel=10 THEN
	ll_nro_dig = ln_niv10	
END IF	

lstr_rep.long4 = ll_nro_dig
ls_cnta_ctbl = MID(ls_cnta_ctbl,1,ll_nro_dig)
lstr_rep.string1 = ls_cnta_ctbl
	
OpenSheetWithParm(w_cn712_cntbl_rpt_balance_comprob_det, lstr_rep, w_main, 2, layered!)	

end event

type sle_ano from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 1166
integer y = 76
integer width = 192
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes_desde from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 1701
integer y = 76
integer width = 105
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 2821
integer y = 68
integer width = 265
integer height = 84
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

type st_3 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 1381
integer y = 84
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 997
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_2 from dropdownlistbox within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 640
integer y = 68
integer width = 215
integer height = 352
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
string text = "none"
string item[] = {"S/.","US$"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 41
integer y = 84
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Nivel"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 393
integer y = 88
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 1847
integer y = 84
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mes_hasta from singlelineedit within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 2139
integer y = 76
integer width = 105
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type em_nivel from editmask within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 215
integer y = 76
integer width = 169
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type cbx_1 from checkbox within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 2341
integer y = 72
integer width = 462
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
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
end if
end event

type gb_1 from groupbox within w_cn772_cntbl_rpt_gyp_naturaleza
integer x = 965
integer width = 1339
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_cn772_cntbl_rpt_gyp_naturaleza
integer width = 910
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione "
end type

