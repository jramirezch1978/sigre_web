$PBExportHeader$w_cn785_costo_prod_x_plant_cc.srw
forward
global type w_cn785_costo_prod_x_plant_cc from w_report_smpl
end type
type sle_grupo from singlelineedit within w_cn785_costo_prod_x_plant_cc
end type
type sle_descripcion from singlelineedit within w_cn785_costo_prod_x_plant_cc
end type
type pb_1 from picturebutton within w_cn785_costo_prod_x_plant_cc
end type
type cb_1 from commandbutton within w_cn785_costo_prod_x_plant_cc
end type
type st_1 from statictext within w_cn785_costo_prod_x_plant_cc
end type
type st_2 from statictext within w_cn785_costo_prod_x_plant_cc
end type
type st_3 from statictext within w_cn785_costo_prod_x_plant_cc
end type
type st_4 from statictext within w_cn785_costo_prod_x_plant_cc
end type
type sle_nivel_c from singlelineedit within w_cn785_costo_prod_x_plant_cc
end type
type st_5 from statictext within w_cn785_costo_prod_x_plant_cc
end type
type sle_nivel_p from singlelineedit within w_cn785_costo_prod_x_plant_cc
end type
type em_ano from editmask within w_cn785_costo_prod_x_plant_cc
end type
type em_mes_ini from editmask within w_cn785_costo_prod_x_plant_cc
end type
type em_mes_fin from editmask within w_cn785_costo_prod_x_plant_cc
end type
type gb_1 from groupbox within w_cn785_costo_prod_x_plant_cc
end type
end forward

global type w_cn785_costo_prod_x_plant_cc from w_report_smpl
integer width = 3191
integer height = 2060
string title = "CN785 - Costo segun plantillas de centros de costos"
string menuname = "m_abc_report_smpl"
boolean maxbox = false
long backcolor = 12632256
sle_grupo sle_grupo
sle_descripcion sle_descripcion
pb_1 pb_1
cb_1 cb_1
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
sle_nivel_c sle_nivel_c
st_5 st_5
sle_nivel_p sle_nivel_p
em_ano em_ano
em_mes_ini em_mes_ini
em_mes_fin em_mes_fin
gb_1 gb_1
end type
global w_cn785_costo_prod_x_plant_cc w_cn785_costo_prod_x_plant_cc

on w_cn785_costo_prod_x_plant_cc.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_grupo=create sle_grupo
this.sle_descripcion=create sle_descripcion
this.pb_1=create pb_1
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.sle_nivel_c=create sle_nivel_c
this.st_5=create st_5
this.sle_nivel_p=create sle_nivel_p
this.em_ano=create em_ano
this.em_mes_ini=create em_mes_ini
this.em_mes_fin=create em_mes_fin
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_grupo
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_nivel_c
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.sle_nivel_p
this.Control[iCurrent+12]=this.em_ano
this.Control[iCurrent+13]=this.em_mes_ini
this.Control[iCurrent+14]=this.em_mes_fin
this.Control[iCurrent+15]=this.gb_1
end on

on w_cn785_costo_prod_x_plant_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_grupo)
destroy(this.sle_descripcion)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_nivel_c)
destroy(this.st_5)
destroy(this.sle_nivel_p)
destroy(this.em_ano)
destroy(this.em_mes_ini)
destroy(this.em_mes_fin)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_ano, ll_mes_ini, ll_mes_fin, ll_nivelc, ll_nivelp, ll_count
String ls_plant

ll_ano 		= Long(em_ano.text)
ll_mes_ini 	= Long(em_mes_ini.text)
ll_mes_fin 	= Long(em_mes_fin.text)
ls_plant 	= TRIM(sle_grupo.text)
ll_nivelc 	= Long(sle_nivel_c.text)
ll_nivelp 	= Long(sle_nivel_p.text)

DECLARE PB_usp_cnt_rpt_gastos_cc_produc PROCEDURE FOR usp_cnt_rpt_gastos_cc_produc
        ( :ll_ano, :ll_mes_ini, :ll_mes_fin, :ls_plant, :ll_nivelc ) ;
		  
Execute PB_usp_cnt_rpt_gastos_cc_produc ;

SELECT count(*) INTO :ll_count FROM tt_cnt_gastos_cc_produc ;

//MessageBox('Registros:', String(ll_count))

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_texto.text = ls_plant + ' Año:' + string(ll_ano)+' Rango mensual: ' + string(ll_mes_ini) + ' - ' + string(ll_mes_fin)
dw_report.object.t_user.text = gs_user

end event

event ue_open_pre;call super::ue_open_pre;sle_nivel_p.text = '2'
end event

type dw_report from w_report_smpl`dw_report within w_cn785_costo_prod_x_plant_cc
integer x = 46
integer y = 416
integer width = 987
integer height = 1436
string dataobject = "d_rpt_costo_prod_ctb"
end type

type sle_grupo from singlelineedit within w_cn785_costo_prod_x_plant_cc
integer x = 283
integer y = 96
integer width = 320
integer height = 88
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
end type

event modified;Long ll_count
String ls_grupo, ls_descripcion

ls_grupo = sle_grupo.text

SELECT count(*) into :ll_count
FROM cnt_plant_grp_cc_prod
WHERE cod_plant = :ls_grupo ;

IF ll_count = 0 THEN
	MessageBox('Aviso','Grupo no definido')
	sle_grupo.text = ''
	sle_descripcion.text = ''
ELSE
	SELECT desc_plant into :ls_descripcion
	FROM cnt_plant_grp_cc_prod
	WHERE cod_plant = :ls_grupo ;
	
	sle_descripcion.text = ls_descripcion
END IF

end event

type sle_descripcion from singlelineedit within w_cn785_costo_prod_x_plant_cc
integer x = 782
integer y = 96
integer width = 1495
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_cn785_costo_prod_x_plant_cc
integer x = 631
integer y = 88
integer width = 128
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT cnt_plant_grp_cc_prod.cod_plant AS CODIGO, '&
										 +'cnt_plant_grp_cc_prod.desc_plant AS DESCRIPCION '&
								 +'FROM cnt_plant_grp_cc_prod ' 
					
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_grupo.text = lstr_seleccionar.param1[1]
		sle_descripcion.text = lstr_seleccionar.param2[1]
	END IF

end event

type cb_1 from commandbutton within w_cn785_costo_prod_x_plant_cc
integer x = 2400
integer y = 148
integer width = 288
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;string  ls_grupo
Long ll_count

ls_grupo = sle_grupo.text

select count(*) into :ll_count from cnt_plant_grp_cc_prod where cod_plant=:ls_grupo ;

IF ll_count=0 THEN
	MessageBox('Aviso', 'Plantilla de producción no definida')
	return
END IF ;

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type st_1 from statictext within w_cn785_costo_prod_x_plant_cc
integer x = 59
integer y = 112
integer width = 215
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Plantilla:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn785_costo_prod_x_plant_cc
integer x = 1554
integer y = 260
integer width = 133
integer height = 80
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

type st_3 from statictext within w_cn785_costo_prod_x_plant_cc
integer x = 1925
integer y = 188
integer width = 357
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
string text = "Rango meses"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn785_costo_prod_x_plant_cc
integer x = 59
integer y = 256
integer width = 517
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "# digitos contable :"
boolean focusrectangle = false
end type

type sle_nivel_c from singlelineedit within w_cn785_costo_prod_x_plant_cc
integer x = 539
integer y = 248
integer width = 119
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_cn785_costo_prod_x_plant_cc
integer x = 773
integer y = 260
integer width = 489
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "# digitos plantilla :"
boolean focusrectangle = false
end type

type sle_nivel_p from singlelineedit within w_cn785_costo_prod_x_plant_cc
integer x = 1239
integer y = 248
integer width = 119
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type em_ano from editmask within w_cn785_costo_prod_x_plant_cc
integer x = 1701
integer y = 248
integer width = 155
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes_ini from editmask within w_cn785_costo_prod_x_plant_cc
integer x = 1957
integer y = 248
integer width = 119
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_mes_fin from editmask within w_cn785_costo_prod_x_plant_cc
integer x = 2117
integer y = 248
integer width = 119
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type gb_1 from groupbox within w_cn785_costo_prod_x_plant_cc
integer x = 32
integer y = 20
integer width = 2281
integer height = 340
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

