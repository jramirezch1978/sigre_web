$PBExportHeader$w_pt703_control_presup_cc.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt703_control_presup_cc from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_pt703_control_presup_cc
end type
type rb_1 from radiobutton within w_pt703_control_presup_cc
end type
type rb_2 from radiobutton within w_pt703_control_presup_cc
end type
type cb_3 from commandbutton within w_pt703_control_presup_cc
end type
type rb_3 from radiobutton within w_pt703_control_presup_cc
end type
type rb_4 from radiobutton within w_pt703_control_presup_cc
end type
type gb_1 from groupbox within w_pt703_control_presup_cc
end type
type gb_2 from groupbox within w_pt703_control_presup_cc
end type
type gb_3 from groupbox within w_pt703_control_presup_cc
end type
end forward

global type w_pt703_control_presup_cc from w_report_smpl
integer width = 3648
integer height = 2372
string title = "Cuentas Presupuestales (PT703)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fechas uo_fechas
rb_1 rb_1
rb_2 rb_2
cb_3 cb_3
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pt703_control_presup_cc w_pt703_control_presup_cc

type variables
Long il_ano
end variables

on w_pt703_control_presup_cc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_3=create cb_3
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_pt703_control_presup_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_3)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;uo_fechas.event ue_output()
Delete from TT_PTO_TIPO_PRTDA;
end event

type dw_report from w_report_smpl`dw_report within w_pt703_control_presup_cc
integer x = 0
integer y = 204
integer width = 2606
integer height = 1020
string dataobject = "d_rpt_control_presupuestal_cc"
end type

type uo_fechas from u_ingreso_rango_fechas within w_pt703_control_presup_cc
integer x = 41
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

event ue_output();call super::ue_output;Date ld_fec_ini
ld_fec_ini = uo_fechas.of_get_fecha1()

il_ano = YEAR( ld_fec_ini)

end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type rb_1 from radiobutton within w_pt703_control_presup_cc
integer x = 2121
integer y = 84
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;long	ll_count

select count(*)
  into :ll_count
  from tt_pto_tipo_prtda;

if ll_count = 0 then
	MessageBox('Error', 'Debe indicar primero un tipo de partida presupuestal')
	this.checked = false
	return
end if
// Inserta todos los registros en tabla temporal

Delete from tt_pto_seleccion;

insert into tt_pto_seleccion ( cencos) 
	SELECT DISTINCT CENCOS
	FROM PRESUPUESTO_PARTIDA pp,
		  tt_pto_tipo_prtda	 tt
	WHERE tt.tipo_prtda_prsp = pp.tipo_prtda_prsp
	  and ANO =  :il_ano ;

Commit;
end event

type rb_2 from radiobutton within w_pt703_control_presup_cc
integer x = 2409
integer y = 84
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;str_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_sel_presup_partida_cencos_ano_tipo"	
sl_param.tipo = '1L'	
sl_param.long1 = il_ano
sl_param.titulo = "Centros de costo"
sl_param.opcion = 1

OpenWithParm( w_rpt_listas, sl_param)
end event

type cb_3 from commandbutton within w_pt703_control_presup_cc
integer x = 2894
integer y = 68
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

Setpointer(Hourglass!)

// genera archivo de articulos, solo los que se han movido segun compras

//create or replace procedure USP_PTO_CONTROL_PRESUP_CC(
//       an_ano     in number, 
//       ad_del     in date, 
//       ad_al      in date,
//       as_tipo    in presupuesto_partida.flag_tipo_cnta%TYPE
//) is   

DECLARE USP_PTO_CONTROL_PRESUP_CC PROCEDURE FOR 
	USP_PTO_CONTROL_PRESUP_CC(	:il_ano, 
										:ld_fec_ini, 
										:ld_fec_fin );
EXECUTE USP_PTO_CONTROL_PRESUP_CC;

If sqlca.sqlcode = -1 then
	messagebox("Error", sqlca.sqlerrtext)
	return 0
end if	

CLOSE USP_PTO_CONTROL_PRESUP_CC;

dw_report.visible = true
dw_report.retrieve()

dw_report.object.t_titulo1.text = 'Del ' + STRING(ld_fec_ini, "DD/MM/YYYY") + &
								' Al ' + STRING(ld_fec_fin, "DD/MM/YYYY")
dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
end event

type rb_3 from radiobutton within w_pt703_control_presup_cc
integer x = 1408
integer y = 84
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal

Delete from TT_PTO_TIPO_PRTDA;

insert into TT_PTO_TIPO_PRTDA ( TIPO_PRTDA_PRSP ) 
SELECT DISTINCT TIPO_PRTDA_PRSP
	FROM TIPO_PRTDA_PRSP_DET;            

Commit;
end event

type rb_4 from radiobutton within w_pt703_control_presup_cc
integer x = 1678
integer y = 88
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Long ll_count
str_parametros lstr_param

// Asigna valores a structura 
lstr_param.dw_master = 'd_lista_tipo_prtda_prsp_tbl'
lstr_param.dw1 	= "d_lista_tipo_prtda_prsp_det_tbl"
lstr_param.titulo = "Tipos de Partidas Presupuestales"
lstr_param.opcion = 1
lstr_param.tipo 	= ''

OpenWithParm( w_abc_seleccion_md, lstr_param)

select count(*)
  into :ll_count
  from tt_pto_tipo_prtda;

if ll_count = 0 then
	this.checked = false
	return
end if
end event

type gb_1 from groupbox within w_pt703_control_presup_cc
integer width = 1376
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_2 from groupbox within w_pt703_control_presup_cc
integer x = 2080
integer width = 773
integer height = 188
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo"
end type

type gb_3 from groupbox within w_pt703_control_presup_cc
integer x = 1376
integer width = 699
integer height = 188
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Prtda Prsp"
end type

