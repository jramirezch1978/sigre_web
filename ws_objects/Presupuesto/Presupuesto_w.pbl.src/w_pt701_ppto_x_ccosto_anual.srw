$PBExportHeader$w_pt701_ppto_x_ccosto_anual.srw
forward
global type w_pt701_ppto_x_ccosto_anual from w_report_smpl
end type
type em_ano from editmask within w_pt701_ppto_x_ccosto_anual
end type
type ddlb_nivelcc from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
end type
type ddlb_nivelcp from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
end type
type st_1 from statictext within w_pt701_ppto_x_ccosto_anual
end type
type st_2 from statictext within w_pt701_ppto_x_ccosto_anual
end type
type cb_1 from commandbutton within w_pt701_ppto_x_ccosto_anual
end type
type ddlb_ingr_egr from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
end type
type rb_1 from radiobutton within w_pt701_ppto_x_ccosto_anual
end type
type rb_2 from radiobutton within w_pt701_ppto_x_ccosto_anual
end type
type gb_3 from groupbox within w_pt701_ppto_x_ccosto_anual
end type
type gb_5 from groupbox within w_pt701_ppto_x_ccosto_anual
end type
type gb_1 from groupbox within w_pt701_ppto_x_ccosto_anual
end type
type gb_2 from groupbox within w_pt701_ppto_x_ccosto_anual
end type
end forward

global type w_pt701_ppto_x_ccosto_anual from w_report_smpl
integer width = 3447
integer height = 3092
string title = "Presupuesto por C.C. Anual (PT701)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
ddlb_nivelcc ddlb_nivelcc
ddlb_nivelcp ddlb_nivelcp
st_1 st_1
st_2 st_2
cb_1 cb_1
ddlb_ingr_egr ddlb_ingr_egr
rb_1 rb_1
rb_2 rb_2
gb_3 gb_3
gb_5 gb_5
gb_1 gb_1
gb_2 gb_2
end type
global w_pt701_ppto_x_ccosto_anual w_pt701_ppto_x_ccosto_anual

type variables
//Integer   ii_zoom_actual = 80, ii_zi = 10, ii_sort = 0
String is_nivelcc, is_nivelcp

end variables

on w_pt701_ppto_x_ccosto_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.ddlb_nivelcc=create ddlb_nivelcc
this.ddlb_nivelcp=create ddlb_nivelcp
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.ddlb_ingr_egr=create ddlb_ingr_egr
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.ddlb_nivelcc
this.Control[iCurrent+3]=this.ddlb_nivelcp
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.ddlb_ingr_egr
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_5
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_pt701_ppto_x_ccosto_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.ddlb_nivelcc)
destroy(this.ddlb_nivelcp)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.ddlb_ingr_egr)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type dw_report from w_report_smpl`dw_report within w_pt701_ppto_x_ccosto_anual
integer x = 0
integer y = 220
integer width = 2537
integer height = 1512
end type

type em_ano from editmask within w_pt701_ppto_x_ccosto_anual
integer x = 55
integer y = 80
integer width = 206
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type ddlb_nivelcc from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
integer x = 1883
integer y = 88
integer width = 197
integer height = 432
integer taborder = 70
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

type ddlb_nivelcp from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
integer x = 2450
integer y = 88
integer width = 197
integer height = 432
integer taborder = 60
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

type st_1 from statictext within w_pt701_ppto_x_ccosto_anual
integer x = 1632
integer y = 88
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

type st_2 from statictext within w_pt701_ppto_x_ccosto_anual
integer x = 2149
integer y = 88
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

type cb_1 from commandbutton within w_pt701_ppto_x_ccosto_anual
integer x = 2743
integer y = 68
integer width = 306
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
boolean cancel = true
end type

event clicked;Long 		ll_ano
string	ls_mensaje, ls_ingr_egr
str_parametros sl_param

ib_preview = false
ll_ano = INTEGER( em_ano.text)

ls_ingr_egr = left(ddlb_ingr_egr.text, 1)

if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

if ls_ingr_egr = '' then
	MessageBox('Aviso', 'Debe especificar Si es de Ingreso o Egreso')
	return
end if

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
		sl_param.dw1 = "d_sel_centro_costo_niv4"
		sl_param.opcion = 6
End Choose
sl_param.titulo = "Centros de costo"
sl_param.nivel = is_nivelcc

OpenWithParm(w_rpt_listas, sl_param)


Setpointer(hourglass!)

//	dw_report.Event ue_preview()
   // Segun niveles
   Choose case is_nivelcc
	case '1'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_pto_anual_cc1_cp1_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc4 PROCEDURE FOR 
					USP_PTO_ANUAL_CC1_CP1( :ll_ano, 
												  :ls_ingr_egr);
				EXECUTE PB_USP_PROC4;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC4;
			case '2'
				dw_report.dataobject = "d_rpt_pto_anual_cc1_cp2_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc3 PROCEDURE FOR 
					USP_PTO_ANUAL_CC1_CP2(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC3;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC3;
			case '3'
				dw_report.dataobject = "d_rpt_pto_anual_cc1_cp3_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc2 PROCEDURE FOR 
					USP_PTO_ANUAL_CC1_CP3 ( :ll_ano, 
													:ls_ingr_egr);
				EXECUTE PB_USP_PROC2;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC2;
			case '4'
				dw_report.dataobject = "d_rpt_pto_anual_cc1_cp4_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc1 PROCEDURE FOR 
					USP_PTO_ANUAL_CC1_CP4 (:ll_ano, 
												  :ls_ingr_egr);
				EXECUTE PB_USP_PROC1;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC1;
		end choose
		
	case '2'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_pto_anual_cc2_cp1_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc21 PROCEDURE FOR 
					USP_PTO_ANUAL_CC2_CP1(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC21;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC21;
			case '2'
				dw_report.dataobject = "d_rpt_pto_anual_cc2_cp2_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc22 PROCEDURE FOR 
					USP_PTO_ANUAL_CC2_CP2 (:ll_ano, 
												  :ls_ingr_egr);
				EXECUTE PB_USP_PROC22;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC22;
			case '3'
				dw_report.dataobject = "d_rpt_pto_anual_cc2_cp3_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc23 PROCEDURE FOR 
					USP_PTO_ANUAL_CC2_CP3 ( :ll_ano, 
													:ls_ingr_egr);
				EXECUTE PB_USP_PROC23;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC23;
			case '4'
				dw_report.dataobject = "d_rpt_pto_anual_cc2_cp4_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc24 PROCEDURE FOR 
					USP_PTO_ANUAL_CC2_CP4(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC24;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC24;
		end choose
	case '3'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_pto_anual_cc3_cp1_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc31 PROCEDURE FOR 
					USP_PTO_ANUAL_CC3_CP1(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC31;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC31;
			case '2'
				dw_report.dataobject = "d_rpt_pto_anual_cc3_cp2_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc32 PROCEDURE FOR 
					USP_PTO_ANUAL_CC3_CP2(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC32;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC32;
			case '3'
				dw_report.dataobject = "d_rpt_pto_anual_cc3_cp3_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc33 PROCEDURE FOR 
					USP_PTO_ANUAL_CC3_CP3(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC33;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC33;
			case '4'
				dw_report.dataobject = "d_rpt_pto_anual_cc3_cp4_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc34 PROCEDURE FOR 
					USP_PTO_ANUAL_CC3_CP4 ( :ll_ano, 
													:ls_ingr_egr);
				EXECUTE PB_USP_PROC34;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC34;
		end choose		
	case '4'
		Choose case is_nivelcp
			case '1'
				dw_report.dataobject = "d_rpt_pto_anual_cc4_cp1_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc41 PROCEDURE FOR 
					USP_PTO_ANUAL_CC4_CP1(:ll_ano, 
												 :ls_ingr_egr);
				EXECUTE PB_USP_PROC41;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC41;
			case '2'
				dw_report.dataobject = "d_rpt_pto_anual_cc4_cp2_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc42 PROCEDURE FOR 
					USP_PTO_ANUAL_CC4_CP2 (:ll_ano, 
												  :ls_ingr_egr);
				EXECUTE PB_USP_PROC42;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC42;
			case '3'
				dw_report.dataobject = "d_rpt_pto_anual_cc4_cp3_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc43 PROCEDURE FOR 
					USP_PTO_ANUAL_CC4_CP3 ( :ll_ano, 
													:ls_ingr_egr);
				EXECUTE PB_USP_PROC43;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC43;
			case '4'
				dw_report.dataobject = "d_rpt_pto_anual_cc4_cp4_cc"
				// genera archivo de articulos, solo los que se han movido segun compras
				DECLARE PB_USP_proc44 PROCEDURE FOR 
					USP_PTO_ANUAL_CC4_CP4 ( :ll_ano, 
													:ls_ingr_egr);
				EXECUTE PB_USP_PROC44;
				If sqlca.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					messagebox("Error", ls_mensaje)
					return 0
				end if
				CLOSE PB_USP_PROC44;
		end choose
		
End Choose
COMMIT;

dw_report.SetTransObject(sqlca)
parent.event ue_preview()
dw_report.visible = true
dw_report.retrieve()

idw_1.object.t_titulo1.text 	= 'Año: ' + em_ano.text
idw_1.object.t_window.text 	= parent.ClassName( )
idw_1.object.t_usuario.text 	= gs_user
idw_1.object.p_logo.FileName 	= gs_logo
idw_1.object.t_empresa.text	= gs_empresa


end event

type ddlb_ingr_egr from dropdownlistbox within w_pt701_ppto_x_ccosto_anual
integer x = 1042
integer y = 88
integer width = 539
integer height = 388
integer taborder = 60
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
string item[] = {"I - Ingreso","E - Egreso","Z - Todos"}
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pt701_ppto_x_ccosto_anual
integer x = 347
integer y = 96
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

type rb_2 from radiobutton within w_pt701_ppto_x_ccosto_anual
integer x = 617
integer y = 100
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

type gb_3 from groupbox within w_pt701_ppto_x_ccosto_anual
integer x = 9
integer y = 12
integer width = 302
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
string text = "Año"
end type

type gb_5 from groupbox within w_pt701_ppto_x_ccosto_anual
integer x = 1614
integer y = 12
integer width = 1106
integer height = 192
integer taborder = 100
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

type gb_1 from groupbox within w_pt701_ppto_x_ccosto_anual
integer x = 1019
integer y = 12
integer width = 576
integer height = 192
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Ingr/Egreso"
end type

type gb_2 from groupbox within w_pt701_ppto_x_ccosto_anual
integer x = 315
integer y = 12
integer width = 699
integer height = 192
integer taborder = 10
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

