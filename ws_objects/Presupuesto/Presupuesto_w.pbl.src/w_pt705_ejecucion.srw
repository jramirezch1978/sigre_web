$PBExportHeader$w_pt705_ejecucion.srw
$PBExportComments$Detalle de ejecucion mensual
forward
global type w_pt705_ejecucion from w_report_smpl
end type
type em_ano from editmask within w_pt705_ejecucion
end type
type ddlb_mes from dropdownlistbox within w_pt705_ejecucion
end type
type st_3 from statictext within w_pt705_ejecucion
end type
type st_4 from statictext within w_pt705_ejecucion
end type
type ddlb_nivelcc from dropdownlistbox within w_pt705_ejecucion
end type
type ddlb_nivelcp from dropdownlistbox within w_pt705_ejecucion
end type
type st_1 from statictext within w_pt705_ejecucion
end type
type st_2 from statictext within w_pt705_ejecucion
end type
type cb_1 from commandbutton within w_pt705_ejecucion
end type
type rb_5 from radiobutton within w_pt705_ejecucion
end type
type rb_6 from radiobutton within w_pt705_ejecucion
end type
type gb_1 from groupbox within w_pt705_ejecucion
end type
type gb_3 from groupbox within w_pt705_ejecucion
end type
type gb_5 from groupbox within w_pt705_ejecucion
end type
end forward

global type w_pt705_ejecucion from w_report_smpl
integer width = 3973
integer height = 2912
string title = "Ejecucion Presupuestal  (PT705)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
ddlb_mes ddlb_mes
st_3 st_3
st_4 st_4
ddlb_nivelcc ddlb_nivelcc
ddlb_nivelcp ddlb_nivelcp
st_1 st_1
st_2 st_2
cb_1 cb_1
rb_5 rb_5
rb_6 rb_6
gb_1 gb_1
gb_3 gb_3
gb_5 gb_5
end type
global w_pt705_ejecucion w_pt705_ejecucion

type variables
String is_nivelcc, is_nivelcp, is_rep
Integer ii_mes
end variables

on w_pt705_ejecucion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_nivelcc=create ddlb_nivelcc
this.ddlb_nivelcp=create ddlb_nivelcp
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.rb_5=create rb_5
this.rb_6=create rb_6
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.ddlb_nivelcc
this.Control[iCurrent+6]=this.ddlb_nivelcp
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rb_5
this.Control[iCurrent+11]=this.rb_6
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_5
end on

on w_pt705_ejecucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_nivelcc)
destroy(this.ddlb_nivelcp)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_5)
end on

event ue_open_pre;call super::ue_open_pre;is_rep = message.Stringparm

if is_rep = 'M' then
	this.title = "Ejecucion Presupuestal Mensual (PT705)"
else
	this.title = "Ejecucion Presupuestal Acumulado (PT705)"
end if
end event

type dw_report from w_report_smpl`dw_report within w_pt705_ejecucion
integer y = 228
end type

type em_ano from editmask within w_pt705_ejecucion
integer x = 206
integer y = 64
integer width = 247
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type ddlb_mes from dropdownlistbox within w_pt705_ejecucion
integer x = 654
integer y = 64
integer width = 498
integer height = 660
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	ii_mes = index
end if
end event

type st_3 from statictext within w_pt705_ejecucion
integer x = 46
integer y = 80
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pt705_ejecucion
integer x = 489
integer y = 76
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type ddlb_nivelcc from dropdownlistbox within w_pt705_ejecucion
integer x = 1467
integer y = 68
integer width = 197
integer height = 432
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"1","2","3","4"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;is_nivelcc = LEFT( this.text,1)   // Solo toma un caracter.


end event

type ddlb_nivelcp from dropdownlistbox within w_pt705_ejecucion
integer x = 1998
integer y = 68
integer width = 197
integer height = 432
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"1","2","3","4"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;is_nivelcp = LEFT( this.text,1)   // Solo toma un caracter.


end event

type st_1 from statictext within w_pt705_ejecucion
integer x = 1207
integer y = 84
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt705_ejecucion
integer x = 1705
integer y = 84
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta.Pres.:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt705_ejecucion
integer x = 2971
integer y = 80
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

event clicked;Int 		li_mes, li_ano
string	ls_mensaje
str_parametros sl_param

li_mes = INTEGER( LEFT( ddlb_mes.text,2))
li_ano = INTEGER( em_ano.text)

ib_preview = false
// Asigna valores a structura 
Choose case is_nivelcc
	case '1'
		sl_param.dw1 = "d_abc_cencos_n1"		
		sl_param.opcion = 3		
	case '2'
		sl_param.dw1 = "d_sel_centro_costo_niv2"		
		sl_param.opcion = 4
	case '3'
		sl_param.dw1 = "d_sel_centro_costo_niv3"		
		sl_param.opcion = 5
	case '4'
		sl_param.dw1 = "d_sel_presup_partida_cencos_ano_all"		
		sl_param.opcion = 1
		sl_param.tipo = '1L1S'
		sl_param.long1 = li_ano
		sl_param.string1 = '%%'
End Choose
sl_param.titulo = "Centros de costo"
sl_param.nivel = is_nivelcc

OpenWithParm( w_rpt_listas, sl_param)

Setpointer(hourglass!)

//	dw_report.Event ue_preview()
   // Segun niveles
   Choose case is_nivelcc
	case '1'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_ejecucion_cc1_cp1"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC1_CP1 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC1_CP1 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC1_CP1;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC1_CP1', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC1_CP1;
				
			case '2'
				dw_report.dataobject = "d_rpt_ejecucion_cc1_cp2"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC1_CP2 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC1_CP2 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC1_CP2;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC1_CP2', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC1_CP2;
				
			case '3'
				dw_report.dataobject = "d_rpt_ejecucion_cc1_cp3"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC1_CP3 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC1_CP3 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC1_CP3;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC1_CP3', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC1_CP3;
				
			case '4'
				dw_report.dataobject = "d_rpt_ejecucion_cc1_cp4"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC1_CP4 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC1_CP4 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC1_CP4;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC1_CP4', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC1_CP4;
				
		end choose
		
	case '2'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_ejecucion_cc2_cp1"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC2_CP1 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC2_CP1 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC2_CP1;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC2_CP1', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC2_CP1;
				
			case '2'
				dw_report.dataobject = "d_rpt_ejecucion_cc2_cp2"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC2_CP2 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC2_CP2 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC2_CP2;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC2_CP2', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC2_CP2;
								
			case '3'
				dw_report.dataobject = "d_rpt_ejecucion_cc2_cp3"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC2_CP3 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC2_CP3 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC2_CP3;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC2_CP3', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC2_CP3;
								
			case '4'
				dw_report.dataobject = "d_rpt_ejecucion_cc2_cp4"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC2_CP4 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC2_CP4 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC2_CP4;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC2_CP4', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC2_CP4;
								
		end choose
	case '3'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_ejecucion_cc3_cp1"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC3_CP1 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC3_CP1 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC3_CP1;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC3_CP1', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC3_CP1;
								
			case '2'
				dw_report.dataobject = "d_rpt_ejecucion_cc3_cp2"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC3_CP2 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC3_CP2 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC3_CP2;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC3_CP2', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC3_CP2;
							
			case '3'
				dw_report.dataobject = "d_rpt_ejecucion_cc3_cp3"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC3_CP3 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC3_CP3 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC3_CP3;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC3_CP3', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC3_CP3;
								
			case '4'
				dw_report.dataobject = "d_rpt_ejecucion_cc3_cp4"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC3_CP4 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC3_CP4 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC3_CP4;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC3_CP4', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC3_CP4;
								
		end choose
	case '4'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_ejecucion_cc4_cp1"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC4_CP1 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC4_CP1 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC4_CP1;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC4_CP1', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC4_CP1;
									
			case '2'
				dw_report.dataobject = "d_rpt_ejecucion_cc4_cp2"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC4_CP2 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC4_CP2 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC4_CP2;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC4_CP2', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC4_CP2;
									
			case '3'
				dw_report.dataobject = "d_rpt_ejecucion_cc4_cp3"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC4_CP3 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC4_CP3 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC4_CP3;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC4_CP3', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC4_CP3;
									
			case '4'
				dw_report.dataobject = "d_rpt_ejecucion_cc4_cp4"				
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE USP_PTO_EJECUCION_CC4_CP4 PROCEDURE FOR 
					USP_PTO_EJECUCION_CC4_CP4 (:li_ano, 
														:li_mes, 
														:is_rep);
				EXECUTE USP_PTO_EJECUCION_CC4_CP4;
				if SQLCA.SQLCOde = -1 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox('Error en USP_PTO_EJECUCION_CC4_CP4', ls_mensaje)
					return
				end if
				
				close USP_PTO_EJECUCION_CC4_CP4;
										
		end choose
End Choose

dw_report.SetTransObject(sqlca)
dw_report.visible = true
parent.event ue_preview()
dw_report.retrieve()

dw_report.object.t_usuario.text = gs_user
if is_rep = 'A' then
	dw_report.object.t_titulo.text = 'EJECUCION PRESUPUESTAL ACUMULADA EN M/E'
	dw_report.object.t_titulo1.text = 'Año: ' + em_ano.text + &
							'Acumulado hasta el Mes: ' + ddlb_mes.text 
else
	dw_report.object.t_titulo.text = 'EJECUCION PRESUPUESTAL MENSUAL EN M/E'
	dw_report.object.t_titulo1.text = 'Año: ' + em_ano.text + &
							'Mes: ' + ddlb_mes.text 
end if

dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
end event

type rb_5 from radiobutton within w_pt705_ejecucion
integer x = 2537
integer y = 92
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

type rb_6 from radiobutton within w_pt705_ejecucion
integer x = 2267
integer y = 88
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

type gb_1 from groupbox within w_pt705_ejecucion
integer width = 1175
integer height = 192
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type gb_3 from groupbox within w_pt705_ejecucion
integer x = 1184
integer y = 4
integer width = 1038
integer height = 192
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nivel "
end type

type gb_5 from groupbox within w_pt705_ejecucion
integer x = 2235
integer y = 4
integer width = 699
integer height = 192
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

