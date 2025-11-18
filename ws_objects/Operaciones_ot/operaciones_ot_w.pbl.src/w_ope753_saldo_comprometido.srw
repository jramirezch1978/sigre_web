$PBExportHeader$w_ope753_saldo_comprometido.srw
forward
global type w_ope753_saldo_comprometido from w_report_smpl
end type
type st_1 from statictext within w_ope753_saldo_comprometido
end type
type st_2 from statictext within w_ope753_saldo_comprometido
end type
type st_3 from statictext within w_ope753_saldo_comprometido
end type
type em_ano from editmask within w_ope753_saldo_comprometido
end type
type em_cencos from editmask within w_ope753_saldo_comprometido
end type
type cb_cencos from commandbutton within w_ope753_saldo_comprometido
end type
type cb_2 from commandbutton within w_ope753_saldo_comprometido
end type
type em_cnta_prsp from editmask within w_ope753_saldo_comprometido
end type
type sle_cencos from singlelineedit within w_ope753_saldo_comprometido
end type
type sle_cnta_prsp from singlelineedit within w_ope753_saldo_comprometido
end type
type cb_1 from commandbutton within w_ope753_saldo_comprometido
end type
type uo_fecha from u_ingreso_rango_fechas within w_ope753_saldo_comprometido
end type
type sle_mes from singlelineedit within w_ope753_saldo_comprometido
end type
type st_4 from statictext within w_ope753_saldo_comprometido
end type
type sle_flag_ctrl from singlelineedit within w_ope753_saldo_comprometido
end type
end forward

global type w_ope753_saldo_comprometido from w_report_smpl
integer width = 3342
integer height = 2392
string title = "Saldo Comprometido en OT(OPE753)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
st_1 st_1
st_2 st_2
st_3 st_3
em_ano em_ano
em_cencos em_cencos
cb_cencos cb_cencos
cb_2 cb_2
em_cnta_prsp em_cnta_prsp
sle_cencos sle_cencos
sle_cnta_prsp sle_cnta_prsp
cb_1 cb_1
uo_fecha uo_fecha
sle_mes sle_mes
st_4 st_4
sle_flag_ctrl sle_flag_ctrl
end type
global w_ope753_saldo_comprometido w_ope753_saldo_comprometido

forward prototypes
public subroutine wf_set_cntap (integer ai_ano, string as_cencos, string as_cntap)
end prototypes

public subroutine wf_set_cntap (integer ai_ano, string as_cencos, string as_cntap);String ls_flag_ctrl
Integer li_ano, li_mes
Date ld_fec_ini, ld_fec_fin

select flag_ctrl into :ls_flag_ctrl
  from presupuesto_partida
 where ano 		  = :ai_ano
   and cencos 	  = :as_cencos
   and cnta_prsp = :as_cntap;

sle_flag_ctrl.Text = ls_flag_ctrl
if ls_flag_ctrl <> '1'  and ls_flag_ctrl <> '0' then//No es anual
	select to_number(to_char(sysdate,'yyyy')),
			 to_number(to_char(sysdate,'mm')) into :li_ano, :li_mes
	  from dual;
	If li_ano <> ai_ano then
		li_mes = 1
	end if
	
	sle_mes.Text = String(li_mes)

else
	li_ano = ai_ano
end if


DECLARE pb_periodo_control_pprsp PROCEDURE FOR usp_ope_periodo_control_pprsp
		  ( :ls_flag_ctrl, :li_ano, :li_mes) ;
EXECUTE pb_periodo_control_pprsp ;

IF sqlca.sqlcode = -1 Then
	rollback ;
	MessageBox( 'Error usp_ope_periodo_control_pprsp', sqlca.sqlerrtext, StopSign! )
	return
End If

FETCH pb_periodo_control_pprsp INTO :ld_fec_ini, :ld_fec_fin;
CLOSE pb_periodo_control_pprsp;

IF sqlca.sqlcode = -1 Then
	rollback ;
	MessageBox( 'Error Fetch01', sqlca.sqlerrtext, StopSign! )
	return
End If

uo_fecha.of_set_fecha(ld_fec_ini, ld_fec_fin) //pa
end subroutine

on w_ope753_saldo_comprometido.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.em_ano=create em_ano
this.em_cencos=create em_cencos
this.cb_cencos=create cb_cencos
this.cb_2=create cb_2
this.em_cnta_prsp=create em_cnta_prsp
this.sle_cencos=create sle_cencos
this.sle_cnta_prsp=create sle_cnta_prsp
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.sle_mes=create sle_mes
this.st_4=create st_4
this.sle_flag_ctrl=create sle_flag_ctrl
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_cencos
this.Control[iCurrent+6]=this.cb_cencos
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_cnta_prsp
this.Control[iCurrent+9]=this.sle_cencos
this.Control[iCurrent+10]=this.sle_cnta_prsp
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.uo_fecha
this.Control[iCurrent+13]=this.sle_mes
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.sle_flag_ctrl
end on

on w_ope753_saldo_comprometido.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_ano)
destroy(this.em_cencos)
destroy(this.cb_cencos)
destroy(this.cb_2)
destroy(this.em_cnta_prsp)
destroy(this.sle_cencos)
destroy(this.sle_cnta_prsp)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.sle_mes)
destroy(this.st_4)
destroy(this.sle_flag_ctrl)
end on

event ue_open_pre;call super::ue_open_pre;String ls_ano, ls_mes

Select to_char(sysdate,'yyyy'), to_char(sysdate,'mm') 
  into :ls_ano, :ls_mes
  from dual;
  
em_ano.Text  = ls_ano
sle_mes.Text = ls_mes
end event

event ue_retrieve;call super::ue_retrieve;Integer li_ano
String  ls_cencos, ls_cnta_prsp, ls_flag_ctrl
Date    ld_fec_ini, ld_fec_fin
Decimal lde_sldo, lde_prspini

li_ano = Integer(em_ano.text)
ls_cencos = trim(em_cencos.text)
ls_cnta_prsp = trim( em_cnta_prsp.text)
ls_flag_ctrl = sle_flag_ctrl.Text

if ls_cencos = '' then
	Messagebox( "Atencion", "Ingrese Centro de costo")
	em_cencos.Setfocus()
	return
end if	

if  ls_cnta_prsp = '' then
	Messagebox( "Atencion", "Ingrese Cuenta presupuestal")
	em_cnta_prsp.Setfocus()
	return
end if

ld_fec_ini = uo_fecha.of_get_fecha1()
ld_fec_fin = uo_fecha.of_get_fecha2()  

//Saldo Presupuesto
Select usf_pto_sldo_acumulado_anual(:li_ano, :ls_cencos, :ls_cnta_prsp)
  into :lde_sldo
  from dual;

//Presupuesto Inicial
Select usf_pto_presup_inicial(:li_ano, :ls_cencos, :ls_cnta_prsp)
  into :lde_prspini
  from dual;

dw_report.Retrieve(ld_fec_ini, ld_fec_fin, ls_cencos, ls_cnta_prsp, ls_flag_ctrl)
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.Text = gs_empresa
dw_report.object.t_user.Text = gs_user
dw_report.object.t_pptoini.Text = String(lde_prspini,"###,###,##0.00")
dw_report.object.t_saldoppto.Text = String(lde_sldo,"###,###,##0.00")
end event

type dw_report from w_report_smpl`dw_report within w_ope753_saldo_comprometido
integer x = 0
integer y = 328
integer width = 3237
integer height = 1324
string dataobject = "d_rpt_aprob_material_prsp_det"
integer ii_zoom_actual = 100
end type

type st_1 from statictext within w_ope753_saldo_comprometido
integer x = 64
integer y = 48
integer width = 128
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope753_saldo_comprometido
integer x = 613
integer y = 48
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ope753_saldo_comprometido
integer x = 439
integer y = 132
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta. Presup:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_ope753_saldo_comprometido
integer x = 187
integer y = 32
integer width = 238
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event modified;em_cencos.text=''
em_cnta_prsp.text=''
sle_cencos.text = ''
sle_cnta_prsp.text = ''
Date ld_fecha
SetNull(ld_fecha)
uo_fecha.of_set_fecha(ld_fecha, ld_fecha) //para setear la fecha inicial
//uo_fecha.of_set_fecha(date('00/00/0000'), date('00/00/0000')) //para setear la fecha inicial
end event

type em_cencos from editmask within w_ope753_saldo_comprometido
integer x = 846
integer y = 32
integer width = 402
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;String ls_cencos, ls_descri
Date ld_fecha

//
em_cnta_prsp.text=''
sle_cnta_prsp.text = ''
SetNull(ld_fecha)
uo_fecha.of_set_fecha(ld_fecha, ld_fecha)

ls_cencos = em_cencos.text

if ls_cencos <> '' then
	Select desc_cencos 
		into :ls_descri 
	from centros_costo
	where cencos = :ls_cencos;
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Atencion", "Centro de costo no existe")
		em_Cencos.text = ''
		return
	end if
	
	  
	sle_cencos.text = ls_descri
end if
end event

type cb_cencos from commandbutton within w_ope753_saldo_comprometido
integer x = 1257
integer y = 28
integer width = 78
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Asigna valores a structura 
string ls_codigo, ls_data, ls_sql, ls_year

if trim(em_Ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	em_ano.Setfocus()
	return
end if

ls_year = em_ano.text
		
ls_sql = "SELECT distinct cc.cencos as codigo_cencos, " &
		 + "cc.desc_cencos AS descripcion_cencos " &
		 + "FROM centros_costo cc, " &
		 + "presupuesto_partida b " &
		 + "where cc.cencos = b.cencos " &
		 + "and b.ano = " + ls_year
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	em_cencos.text 	= ls_codigo
	sle_cencos.text 	= ls_data
end if
end event

type cb_2 from commandbutton within w_ope753_saldo_comprometido
integer x = 1257
integer y = 120
integer width = 78
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Asigna valores a structura 
String ls_cencos, ls_year, ls_sql, ls_codigo, ls_data//, ls_flag_ctrl
//Integer li_ano, li_mes
//Date ld_fec_ini, ld_fec_fin

if trim( em_Ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	em_ano.Setfocus()
	return
end if

ls_year = trim(em_ano.text)

if trim( em_cencos.text) = '' then
	Messagebox( "Atencion", "Ingrese Centro de costo")
	em_cencos.Setfocus()
	return
end if	

ls_cencos = trim(em_cencos.text)

ls_sql = "SELECT distinct a.cnta_prsp as codigo_cuenta, " &
		 + "a.descripcion AS descripcion_cuenta " &
		 + "FROM presupuesto_cuenta a, " &
		 + "presupuesto_partida b " &
		 + "where a.cnta_prsp = b.cnta_prsp " &
		 + "and b.ano = " + ls_year + " " &
		 + "and b.cencos = '" + ls_cencos + "'"
				 
f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	em_cnta_prsp.text 	= ls_codigo
	sle_cnta_prsp.text 	= ls_data
	
	wf_set_cntap(Integer(ls_year), ls_cencos, ls_codigo)
	
end if
end event

type em_cnta_prsp from editmask within w_ope753_saldo_comprometido
integer x = 841
integer y = 124
integer width = 402
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;String ls_cnta, ls_desc

ls_cnta = em_cnta_prsp.text

if ls_cnta <> '' then
	Select descripcion 
		into :ls_desc
	from presupuesto_cuenta
	where cnta_prsp = :ls_cnta;
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Atencion", "Cuenta presupuestal no existe")
		em_cnta_prsp.text = ''
		return
	end if
	sle_cnta_prsp.text = ls_desc
end if
end event

type sle_cencos from singlelineedit within w_ope753_saldo_comprometido
integer x = 1353
integer y = 28
integer width = 1207
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type sle_cnta_prsp from singlelineedit within w_ope753_saldo_comprometido
integer x = 1353
integer y = 124
integer width = 1207
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ope753_saldo_comprometido
integer x = 1353
integer y = 228
integer width = 343
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;

//parent.of_reg_presup_ejec( ll_ano, ls_cencos, ls_cnta_prsp)
//parent.of_reg_prsp_var( ll_ano, ls_cencos, ls_cnta_prsp)

//dw_report.retrieve( ll_Ano, ls_cencos, ls_cnta_prsp)

event ue_retrieve()

//dw_report.object.t_texto.Text = ls_cadena

//ld_fec_inicio = uo_1.of_get_fecha1()
//ld_fec_final = uo_1.of_get_fecha2()  

//idw_1.Retrieve(ls_ot, ld_fec_inicio, ld_fec_final)
//idw_1.Object.p_logo.filename = gs_logo
end event

type uo_fecha from u_ingreso_rango_fechas within w_ope753_saldo_comprometido
integer x = 37
integer y = 236
integer taborder = 90
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
//of_set_fecha(date('01/01/1900'), date('31/12/9999') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_mes from singlelineedit within w_ope753_saldo_comprometido
boolean visible = false
integer x = 315
integer y = 124
integer width = 137
integer height = 100
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

type st_4 from statictext within w_ope753_saldo_comprometido
boolean visible = false
integer x = 73
integer y = 140
integer width = 178
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type sle_flag_ctrl from singlelineedit within w_ope753_saldo_comprometido
boolean visible = false
integer x = 1833
integer y = 216
integer width = 343
integer height = 100
integer taborder = 100
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

