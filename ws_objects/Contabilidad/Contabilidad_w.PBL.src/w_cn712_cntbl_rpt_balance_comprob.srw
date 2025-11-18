$PBExportHeader$w_cn712_cntbl_rpt_balance_comprob.srw
forward
global type w_cn712_cntbl_rpt_balance_comprob from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
end type
type sle_mes_desde from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
end type
type cb_1 from commandbutton within w_cn712_cntbl_rpt_balance_comprob
end type
type st_3 from statictext within w_cn712_cntbl_rpt_balance_comprob
end type
type st_4 from statictext within w_cn712_cntbl_rpt_balance_comprob
end type
type ddlb_moneda from dropdownlistbox within w_cn712_cntbl_rpt_balance_comprob
end type
type st_2 from statictext within w_cn712_cntbl_rpt_balance_comprob
end type
type st_7 from statictext within w_cn712_cntbl_rpt_balance_comprob
end type
type st_1 from statictext within w_cn712_cntbl_rpt_balance_comprob
end type
type sle_mes_hasta from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
end type
type em_nivel from editmask within w_cn712_cntbl_rpt_balance_comprob
end type
type cbx_1 from checkbox within w_cn712_cntbl_rpt_balance_comprob
end type
type dp_fecha from datepicker within w_cn712_cntbl_rpt_balance_comprob
end type
type gb_2 from groupbox within w_cn712_cntbl_rpt_balance_comprob
end type
type gb_3 from groupbox within w_cn712_cntbl_rpt_balance_comprob
end type
end forward

global type w_cn712_cntbl_rpt_balance_comprob from w_report_smpl
integer width = 3918
integer height = 1604
string title = "[CN712] Contabilidad  -  Balance de Comprobación"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes_desde sle_mes_desde
cb_1 cb_1
st_3 st_3
st_4 st_4
ddlb_moneda ddlb_moneda
st_2 st_2
st_7 st_7
st_1 st_1
sle_mes_hasta sle_mes_hasta
em_nivel em_nivel
cbx_1 cbx_1
dp_fecha dp_fecha
gb_2 gb_2
gb_3 gb_3
end type
global w_cn712_cntbl_rpt_balance_comprob w_cn712_cntbl_rpt_balance_comprob

forward prototypes
public subroutine of_update_asientos ()
end prototypes

public subroutine of_update_asientos ();update cntbl_Asiento ca
   set ca.tot_soldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_soldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                                                                            
update cntbl_Asiento ca
   set ca.tot_solhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_solhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                           
update cntbl_Asiento ca
   set ca.tot_doldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_doldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);

update cntbl_Asiento ca
   set ca.tot_dolhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_dolhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);         

commit;

                           
end subroutine

on w_cn712_cntbl_rpt_balance_comprob.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_desde=create sle_mes_desde
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_moneda=create ddlb_moneda
this.st_2=create st_2
this.st_7=create st_7
this.st_1=create st_1
this.sle_mes_hasta=create sle_mes_hasta
this.em_nivel=create em_nivel
this.cbx_1=create cbx_1
this.dp_fecha=create dp_fecha
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_desde
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_moneda
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_mes_hasta
this.Control[iCurrent+11]=this.em_nivel
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.dp_fecha
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
end on

on w_cn712_cntbl_rpt_balance_comprob.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_desde)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_moneda)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.st_1)
destroy(this.sle_mes_hasta)
destroy(this.em_nivel)
destroy(this.cbx_1)
destroy(this.dp_fecha)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_moneda, &
			ls_nombre_mes_desde, ls_nombre_mes_hasta, ls_mensaje, ls_nom_empresa
Integer 	li_nivel, li_niveles, li_year, li_mes1, li_mes2, li_longitud

SetPointer(hourglass!)

ls_moneda	= upper(ddlb_moneda.Text)
li_year     = Integer(sle_ano.text)
li_mes1 		= Integer(sle_mes_desde.text)
li_mes2 		= Integer(sle_mes_hasta.text)
li_nivel	   = Integer(em_nivel.text)

select nro_niveles 
	into :li_niveles 
from cntblparam
where reckey = '1' ;
  
if (li_nivel > li_niveles) or isnull(li_nivel) or li_nivel = 0 then
	MessageBox('Aviso','Número de Nivel no Existe, por favor verifique')
	return
end if
 
if li_nivel = 1 then
	select nivel1 
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;
	
elseif li_nivel = 2 then
	
	select nivel2
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;
	
elseif li_nivel = 3 then
	
	select nivel3
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;
	
elseif li_nivel = 4 then
	
	select nivel4
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;
	
elseif li_nivel = 5 then
	
	select nivel5
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;
	
elseif li_nivel = 6 then
	
	select nivel6
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;

elseif li_nivel = 7 then
	
	select nivel7
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;

elseif li_nivel = 8 then
	
	select nivel8
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;

elseif li_nivel = 9 then
	
	select nivel9
		into :li_longitud 
	from cntblparam
	where reckey = '1' ;

end if

dw_report.retrieve(li_year, li_mes1, li_mes2, li_longitud, ls_moneda)

CHOOSE CASE string(li_mes1, '00')
			
	CASE '00'
		  ls_nombre_mes_desde = 'MES CERO'
	CASE '01'
		  ls_nombre_mes_desde = '01 ENERO'
	CASE '02'
		  ls_nombre_mes_desde = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes_desde = '03 MARZO'
	CASE '04'
		  ls_nombre_mes_desde = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes_desde = '05 MAYO'
	CASE '06'
		  ls_nombre_mes_desde = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes_desde = '07 JULIO'
	CASE '08'
		  ls_nombre_mes_desde = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes_desde = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes_desde = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes_desde = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes_desde = '12 DICIEMBRE'
END CHOOSE
	
CHOOSE CASE string(li_mes2, '00')
			
	CASE '0'
		  ls_nombre_mes_hasta = 'MES CERO'
	CASE '01'
		  ls_nombre_mes_hasta = '01 ENERO'
	CASE '02'
		  ls_nombre_mes_hasta = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes_hasta = '03 MARZO'
	CASE '04'
		  ls_nombre_mes_hasta = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes_hasta = '05 MAYO'
	CASE '06'
		  ls_nombre_mes_hasta = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes_hasta = '07 JULIO'
	CASE '08'
		  ls_nombre_mes_hasta = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes_hasta = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes_hasta = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes_hasta = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes_hasta = '12 DICIEMBRE'
END CHOOSE


dw_report.object.t_nom_empresa.text	= gnvo_app.empresa.is_nom_empresa
dw_report.object.p_logo.filename 	= gs_logo
dw_report.object.t_user.text 			= gs_user
dw_report.object.t_ruc.text      	= gnvo_app.empresa.is_ruc
dw_report.object.t_desde.text    	= ls_nombre_mes_desde
dw_report.object.t_hasta.text    	= ls_nombre_mes_hasta
dw_report.object.t_year.text    		= string(li_year, '0000')
dw_report.object.t_fecha.text    	= string(dp_fecha.Value, 'dd/mm/yyyy hh:mm:ss')

IF gs_empresa = 'FISHOLG' then
	dw_report.object.t_2.text = 'BALANCE DE COMPROBACIÓN'
end if
end event

event ue_open_pre;call super::ue_open_pre;
//of_update_asientos()

dp_fecha.Value = gnvo_app.of_fecha_actual()
end event

type dw_report from w_report_smpl`dw_report within w_cn712_cntbl_rpt_balance_comprob
integer x = 0
integer y = 224
integer width = 3291
integer height = 1116
integer taborder = 70
string dataobject = "d_cntbl_balance_comprob_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;Long 				ll_ano, ll_mes_ini, ll_mes_fin, ll_nivel, ll_nro_dig
Long				ln_niv1, ln_niv2, ln_niv3, ln_niv4, ln_niv5, ln_niv6, ln_niv7, &
	  				ln_niv8, ln_niv9, ln_niv10
String 			ls_cnta_ctbl, ls_moneda
str_parametros lstr_rep, lstr_tmp
w_cn712_cntbl_rpt_balance_comprob_det	lw_1

IF row = 0 THEN Return

IF this.Rowcount( ) = 0 then return

// Para elegir el tipo de reporte para la consulta
Open(w_cn712_eleccion_reporte)

if not IsValid(Message.powerObjectparm) or &
	IsNull(Message.powerObjectparm) then return

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then return

lstr_tmp = Message.PowerObjectParm

if lstr_tmp.titulo = '0' then return

//Tomo los datos necesarios para el reporte
ll_ano 			= LONG(sle_ano.text)
ll_mes_ini 		= LONG(sle_mes_desde.text)
ll_mes_fin 		= LONG(sle_mes_hasta.text)
ll_nivel 		= LONG(em_nivel.text)
ls_cnta_ctbl 	= this.object.cnta_ctbl[row]

lstr_rep.long1 	= ll_ano
lstr_rep.long2 	= ll_mes_ini
lstr_rep.long3 	= ll_mes_fin
lstr_rep.titulo 	= lstr_tmp.titulo
lstr_rep.moneda	= upper(ddlb_moneda.Text)

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

lstr_rep.long4 	= ll_nro_dig
ls_cnta_ctbl 		= MID(ls_cnta_ctbl,1,ll_nro_dig)
lstr_rep.string1 	= ls_cnta_ctbl
lstr_rep.string2	= lstr_tmp.string1


	
OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, layered!)	

end event

type sle_ano from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
integer x = 1125
integer y = 92
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

type sle_mes_desde from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
integer x = 1659
integer y = 92
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

type cb_1 from commandbutton within w_cn712_cntbl_rpt_balance_comprob
integer x = 2990
integer y = 56
integer width = 265
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;SetPointer(hourglass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type st_3 from statictext within w_cn712_cntbl_rpt_balance_comprob
integer x = 1339
integer y = 100
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
long backcolor = 67108864
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn712_cntbl_rpt_balance_comprob
integer x = 955
integer y = 100
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_moneda from dropdownlistbox within w_cn712_cntbl_rpt_balance_comprob
integer x = 640
integer y = 84
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

type st_2 from statictext within w_cn712_cntbl_rpt_balance_comprob
integer x = 41
integer y = 100
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 67108864
string text = "Nivel"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_cn712_cntbl_rpt_balance_comprob
integer x = 393
integer y = 100
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn712_cntbl_rpt_balance_comprob
integer x = 1806
integer y = 100
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mes_hasta from singlelineedit within w_cn712_cntbl_rpt_balance_comprob
integer x = 2098
integer y = 92
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

type em_nivel from editmask within w_cn712_cntbl_rpt_balance_comprob
integer x = 215
integer y = 92
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

type cbx_1 from checkbox within w_cn712_cntbl_rpt_balance_comprob
integer x = 2281
integer y = 32
integer width = 617
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
	dp_fecha.visible = true
else
	dw_report.object.t_fecha.visible = '0'
	dp_fecha.visible = false
end if
end event

type dp_fecha from datepicker within w_cn712_cntbl_rpt_balance_comprob
integer x = 2281
integer y = 116
integer width = 617
integer height = 88
integer taborder = 60
boolean bringtotop = true
datetimeformat format = dtfcustom!
string customformat = "dd/MM/yyyy hh:mm:ss"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2021-06-06"), Time("14:14:31.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type gb_2 from groupbox within w_cn712_cntbl_rpt_balance_comprob
integer y = 16
integer width = 910
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione "
end type

type gb_3 from groupbox within w_cn712_cntbl_rpt_balance_comprob
integer x = 923
integer y = 16
integer width = 1339
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

