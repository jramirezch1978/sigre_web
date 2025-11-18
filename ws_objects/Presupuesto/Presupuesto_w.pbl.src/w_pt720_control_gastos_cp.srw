$PBExportHeader$w_pt720_control_gastos_cp.srw
$PBExportComments$Control presupuestario por cuenta presupuestal
forward
global type w_pt720_control_gastos_cp from w_report_smpl
end type
type rb_1 from radiobutton within w_pt720_control_gastos_cp
end type
type rb_2 from radiobutton within w_pt720_control_gastos_cp
end type
type cb_3 from commandbutton within w_pt720_control_gastos_cp
end type
type sle_ano from singlelineedit within w_pt720_control_gastos_cp
end type
type sle_mes_ini from singlelineedit within w_pt720_control_gastos_cp
end type
type sle_mes_fin from singlelineedit within w_pt720_control_gastos_cp
end type
type st_1 from statictext within w_pt720_control_gastos_cp
end type
type st_2 from statictext within w_pt720_control_gastos_cp
end type
type st_3 from statictext within w_pt720_control_gastos_cp
end type
type gb_1 from groupbox within w_pt720_control_gastos_cp
end type
type gb_2 from groupbox within w_pt720_control_gastos_cp
end type
end forward

global type w_pt720_control_gastos_cp from w_report_smpl
integer width = 2939
integer height = 1472
string title = "Control  x Cuentas Presupuestales (PT720)"
string menuname = "m_impresion"
boolean maxbox = false
long backcolor = 67108864
rb_1 rb_1
rb_2 rb_2
cb_3 cb_3
sle_ano sle_ano
sle_mes_ini sle_mes_ini
sle_mes_fin sle_mes_fin
st_1 st_1
st_2 st_2
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_pt720_control_gastos_cp w_pt720_control_gastos_cp

type variables
Long il_ano
end variables

on w_pt720_control_gastos_cp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_3=create cb_3
this.sle_ano=create sle_ano
this.sle_mes_ini=create sle_mes_ini
this.sle_mes_fin=create sle_mes_fin
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.sle_mes_ini
this.Control[iCurrent+6]=this.sle_mes_fin
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_pt720_control_gastos_cp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_3)
destroy(this.sle_ano)
destroy(this.sle_mes_ini)
destroy(this.sle_mes_fin)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type dw_report from w_report_smpl`dw_report within w_pt720_control_gastos_cp
integer y = 252
integer height = 736
string dataobject = "d_rpt_gastos_x_cp_tbl"
end type

type rb_1 from radiobutton within w_pt720_control_gastos_cp
integer x = 1303
integer y = 108
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

Delete from tt_pto_seleccion;

	insert into tt_pto_seleccion ( cnta_prsp ) 
 		(SELECT DISTINCT cnta_prsp
    	FROM PRESUPUESTO_PARTIDA            
   	WHERE ANO =  :il_ano) ;
//Commit;
end event

type rb_2 from radiobutton within w_pt720_control_gastos_cp
integer x = 1595
integer y = 112
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

il_ano = integer(sle_ano.text)
// Asigna valores a structura 
sl_param.dw1 = "d_sel_presupuesto_partida_cnta_pres_ano"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 2
sl_param.tipo = '1L'
sl_param.long1 = il_ano

OpenWithParm( w_rpt_listas, sl_param)
end event

type cb_3 from commandbutton within w_pt720_control_gastos_cp
integer x = 2400
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

event clicked;String ls_ano, ls_mes_ini, ls_mes_fin
Long ll_ano, ll_mes_ini, ll_mes_fin

ls_ano = sle_ano.text
ls_mes_ini = sle_mes_ini.text
ls_mes_fin = sle_mes_fin.text

ll_ano = Long(ls_ano)
ll_mes_ini = Long(ls_mes_ini)
ll_mes_fin = Long(ls_mes_fin)

SetPointer(Hourglass!)
// genera archivo de articulos, solo los que se han movido segun compras
DECLARE PB_USP_proc1 PROCEDURE FOR USP_PTO_GASTOS_PRESUP_CP
				  (:ll_ano, :ll_mes_ini, :ll_mes_fin);
EXECUTE PB_USP_PROC1;
If sqlca.sqlcode = -1 then
	messagebox("Error", sqlca.sqlerrtext)
	return 0
end if

idw_1.visible = true
idw_1.retrieve()

idw_1.object.t_texto.text = 'Del mes ' + ls_mes_ini + ' al ' + &
								    ls_mes_fin + ' del año ' + ls_ano

idw_1.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo

end event

type sle_ano from singlelineedit within w_pt720_control_gastos_cp
integer x = 183
integer y = 80
integer width = 155
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_ini from singlelineedit within w_pt720_control_gastos_cp
integer x = 567
integer y = 80
integer width = 96
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_fin from singlelineedit within w_pt720_control_gastos_cp
integer x = 901
integer y = 80
integer width = 96
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pt720_control_gastos_cp
integer x = 46
integer y = 96
integer width = 133
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt720_control_gastos_cp
integer x = 434
integer y = 96
integer width = 114
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Del:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt720_control_gastos_cp
integer x = 809
integer y = 104
integer width = 82
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Al:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pt720_control_gastos_cp
integer x = 14
integer y = 20
integer width = 1033
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
string text = "Parámetros"
end type

type gb_2 from groupbox within w_pt720_control_gastos_cp
integer x = 1230
integer y = 24
integer width = 846
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
string text = "Cta. Presup."
end type

