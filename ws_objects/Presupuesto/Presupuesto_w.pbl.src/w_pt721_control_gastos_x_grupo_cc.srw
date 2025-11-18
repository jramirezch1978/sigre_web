$PBExportHeader$w_pt721_control_gastos_x_grupo_cc.srw
$PBExportComments$Control presupuestario por cuenta presupuestal
forward
global type w_pt721_control_gastos_x_grupo_cc from w_report_smpl
end type
type rb_todos from radiobutton within w_pt721_control_gastos_x_grupo_cc
end type
type rb_sel from radiobutton within w_pt721_control_gastos_x_grupo_cc
end type
type cb_3 from commandbutton within w_pt721_control_gastos_x_grupo_cc
end type
type sle_ano from singlelineedit within w_pt721_control_gastos_x_grupo_cc
end type
type sle_mes_ini from singlelineedit within w_pt721_control_gastos_x_grupo_cc
end type
type sle_mes_fin from singlelineedit within w_pt721_control_gastos_x_grupo_cc
end type
type st_1 from statictext within w_pt721_control_gastos_x_grupo_cc
end type
type st_2 from statictext within w_pt721_control_gastos_x_grupo_cc
end type
type st_3 from statictext within w_pt721_control_gastos_x_grupo_cc
end type
type st_4 from statictext within w_pt721_control_gastos_x_grupo_cc
end type
type sle_grupo from singlelineedit within w_pt721_control_gastos_x_grupo_cc
end type
type pb_1 from picturebutton within w_pt721_control_gastos_x_grupo_cc
end type
type sle_descrip_cencos from singlelineedit within w_pt721_control_gastos_x_grupo_cc
end type
type rb_tipo from radiobutton within w_pt721_control_gastos_x_grupo_cc
end type
type ddlb_1 from dropdownlistbox within w_pt721_control_gastos_x_grupo_cc
end type
type gb_1 from groupbox within w_pt721_control_gastos_x_grupo_cc
end type
type gb_2 from groupbox within w_pt721_control_gastos_x_grupo_cc
end type
end forward

global type w_pt721_control_gastos_x_grupo_cc from w_report_smpl
integer width = 3145
integer height = 1472
string title = "Control  x Cuentas Presupuestales (PT721)"
string menuname = "m_impresion"
boolean maxbox = false
long backcolor = 67108864
rb_todos rb_todos
rb_sel rb_sel
cb_3 cb_3
sle_ano sle_ano
sle_mes_ini sle_mes_ini
sle_mes_fin sle_mes_fin
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
sle_grupo sle_grupo
pb_1 pb_1
sle_descrip_cencos sle_descrip_cencos
rb_tipo rb_tipo
ddlb_1 ddlb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_pt721_control_gastos_x_grupo_cc w_pt721_control_gastos_x_grupo_cc

type variables
Long il_ano
end variables

on w_pt721_control_gastos_x_grupo_cc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_todos=create rb_todos
this.rb_sel=create rb_sel
this.cb_3=create cb_3
this.sle_ano=create sle_ano
this.sle_mes_ini=create sle_mes_ini
this.sle_mes_fin=create sle_mes_fin
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.sle_grupo=create sle_grupo
this.pb_1=create pb_1
this.sle_descrip_cencos=create sle_descrip_cencos
this.rb_tipo=create rb_tipo
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_todos
this.Control[iCurrent+2]=this.rb_sel
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.sle_mes_ini
this.Control[iCurrent+6]=this.sle_mes_fin
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.sle_grupo
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.sle_descrip_cencos
this.Control[iCurrent+14]=this.rb_tipo
this.Control[iCurrent+15]=this.ddlb_1
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
end on

on w_pt721_control_gastos_x_grupo_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_todos)
destroy(this.rb_sel)
destroy(this.cb_3)
destroy(this.sle_ano)
destroy(this.sle_mes_ini)
destroy(this.sle_mes_fin)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_grupo)
destroy(this.pb_1)
destroy(this.sle_descrip_cencos)
destroy(this.rb_tipo)
destroy(this.ddlb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;ddlb_1.visible=false
ddlb_1.enabled=false

end event

type dw_report from w_report_smpl`dw_report within w_pt721_control_gastos_x_grupo_cc
integer x = 41
integer y = 360
integer width = 2217
integer height = 748
integer taborder = 90
string dataobject = "d_rpt_gastos_x_cp_tbl"
end type

type rb_todos from radiobutton within w_pt721_control_gastos_x_grupo_cc
integer x = 1998
integer y = 92
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

ddlb_1.visible=false
ddlb_1.enabled=false


//Commit;
end event

type rb_sel from radiobutton within w_pt721_control_gastos_x_grupo_cc
integer x = 1998
integer y = 224
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

event clicked;str_parametros sl_param

ddlb_1.visible=false
ddlb_1.enabled=false

il_ano = integer(sle_ano.text)
// Asigna valores a structura 
sl_param.dw1 = "d_sel_presupuesto_partida_cnta_pres_ano"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 2
sl_param.tipo = '1L'
sl_param.long1 = il_ano

OpenWithParm( w_rpt_listas, sl_param)
end event

type cb_3 from commandbutton within w_pt721_control_gastos_x_grupo_cc
integer x = 2702
integer y = 200
integer width = 224
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;String ls_ano, ls_mes_ini, ls_mes_fin, ls_tipo_partida, ls_grupo_cencos
Long ll_ano, ll_mes_ini, ll_mes_fin, ll_count

ls_ano = sle_ano.text
ls_mes_ini = sle_mes_ini.text
ls_mes_fin = sle_mes_fin.text

ll_ano = Long(ls_ano)
ll_mes_ini = Long(ls_mes_ini)
ll_mes_fin = Long(ls_mes_fin)

IF rb_tipo.checked=true then

	ls_tipo_partida = trim(left(ddlb_1.text,1))

	Delete from tt_pto_seleccion;

	insert into tt_pto_seleccion ( cnta_prsp ) 
 		(SELECT DISTINCT pp.cnta_prsp
    	FROM PRESUPUESTO_PARTIDA pp, PRESUPUESTO_CUENTA pc
   	WHERE pp.cnta_prsp=pc.cnta_prsp and
				pc.flag_tipo_cnta=:ls_tipo_partida and
				pp.ANO = :ll_ano) ;
ELSEIF rb_todos.checked=TRUE THEN
	Delete from tt_pto_seleccion;
	
	insert into tt_pto_seleccion ( cnta_prsp ) 
 		(SELECT DISTINCT cnta_prsp
    	FROM PRESUPUESTO_PARTIDA            
   	WHERE ANO = :ll_ano) ;				
end if


select count(*) into :ll_count from tt_pto_seleccion ;

IF ll_count=0 THEN
	messagebox('Aviso', 'No hay registros')
	return
end if

ls_grupo_cencos = sle_grupo.text

SetPointer(Hourglass!)
// genera archivo de articulos, solo los que se han movido segun compras
DECLARE PB_USP_proc1 PROCEDURE FOR USP_PTO_RPT_CENCOS_GRUPO
				  (:ls_grupo_cencos, :ll_ano, :ll_mes_ini, :ll_mes_fin);
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

type sle_ano from singlelineedit within w_pt721_control_gastos_x_grupo_cc
integer x = 206
integer y = 96
integer width = 155
integer height = 64
integer taborder = 10
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

type sle_mes_ini from singlelineedit within w_pt721_control_gastos_x_grupo_cc
integer x = 526
integer y = 96
integer width = 96
integer height = 64
integer taborder = 20
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

type sle_mes_fin from singlelineedit within w_pt721_control_gastos_x_grupo_cc
integer x = 745
integer y = 96
integer width = 96
integer height = 64
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

type st_1 from statictext within w_pt721_control_gastos_x_grupo_cc
integer x = 69
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

type st_2 from statictext within w_pt721_control_gastos_x_grupo_cc
integer x = 393
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

type st_3 from statictext within w_pt721_control_gastos_x_grupo_cc
integer x = 654
integer y = 96
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

type st_4 from statictext within w_pt721_control_gastos_x_grupo_cc
integer x = 960
integer y = 96
integer width = 416
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
string text = "Grupo CenCos:"
boolean focusrectangle = false
end type

type sle_grupo from singlelineedit within w_pt721_control_gastos_x_grupo_cc
integer x = 1385
integer y = 96
integer width = 357
integer height = 64
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

type pb_1 from picturebutton within w_pt721_control_gastos_x_grupo_cc
integer x = 1783
integer y = 84
integer width = 110
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_grupo_cencos

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT CENTRO_COSTO_GRUPO.GRUPO AS GRUPO, '&
								 +'CENTRO_COSTO_GRUPO.DESCRIPCION AS DESCRIPCION '&
								 +'FROM CENTRO_COSTO_GRUPO ' 
									  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_grupo.text=lstr_seleccionar.param1[1]
		sle_descrip_cencos.text=lstr_seleccionar.param2[1]
	END IF

end event

type sle_descrip_cencos from singlelineedit within w_pt721_control_gastos_x_grupo_cc
integer x = 87
integer y = 204
integer width = 1787
integer height = 64
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

type rb_tipo from radiobutton within w_pt721_control_gastos_x_grupo_cc
integer x = 1998
integer y = 152
integer width = 507
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
string text = "x tipo de cuenta"
end type

event clicked;ddlb_1.visible=true
ddlb_1.enabled=true
end event

type ddlb_1 from dropdownlistbox within w_pt721_control_gastos_x_grupo_cc
integer x = 2601
integer y = 64
integer width = 480
integer height = 324
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean hscrollbar = true
string item[] = {"F - Fijo","V - Variable","P - Proyecto","T - Parada","A - Activos","N - No gastos","E - Exportación","X - Fondos","O - Otros"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pt721_control_gastos_x_grupo_cc
integer x = 37
integer y = 32
integer width = 1893
integer height = 280
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

type gb_2 from groupbox within w_pt721_control_gastos_x_grupo_cc
integer x = 1966
integer y = 32
integer width = 608
integer height = 284
integer taborder = 60
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

