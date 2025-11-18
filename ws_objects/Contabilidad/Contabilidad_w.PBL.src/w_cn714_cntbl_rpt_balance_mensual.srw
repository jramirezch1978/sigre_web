$PBExportHeader$w_cn714_cntbl_rpt_balance_mensual.srw
forward
global type w_cn714_cntbl_rpt_balance_mensual from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
end type
type sle_mesd from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
end type
type cb_1 from commandbutton within w_cn714_cntbl_rpt_balance_mensual
end type
type st_3 from statictext within w_cn714_cntbl_rpt_balance_mensual
end type
type st_4 from statictext within w_cn714_cntbl_rpt_balance_mensual
end type
type ddlb_2 from dropdownlistbox within w_cn714_cntbl_rpt_balance_mensual
end type
type st_2 from statictext within w_cn714_cntbl_rpt_balance_mensual
end type
type st_7 from statictext within w_cn714_cntbl_rpt_balance_mensual
end type
type st_6 from statictext within w_cn714_cntbl_rpt_balance_mensual
end type
type sle_mesh from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
end type
type em_nivel from editmask within w_cn714_cntbl_rpt_balance_mensual
end type
type cbx_1 from checkbox within w_cn714_cntbl_rpt_balance_mensual
end type
type gb_1 from groupbox within w_cn714_cntbl_rpt_balance_mensual
end type
type gb_2 from groupbox within w_cn714_cntbl_rpt_balance_mensual
end type
end forward

global type w_cn714_cntbl_rpt_balance_mensual from w_report_smpl
integer width = 3429
integer height = 1604
string title = "Balance General de Comprobación Comparativo (CN714)"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mesd sle_mesd
cb_1 cb_1
st_3 st_3
st_4 st_4
ddlb_2 ddlb_2
st_2 st_2
st_7 st_7
st_6 st_6
sle_mesh sle_mesh
em_nivel em_nivel
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn714_cntbl_rpt_balance_mensual w_cn714_cntbl_rpt_balance_mensual

on w_cn714_cntbl_rpt_balance_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mesd=create sle_mesd
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_2=create ddlb_2
this.st_2=create st_2
this.st_7=create st_7
this.st_6=create st_6
this.sle_mesh=create sle_mesh
this.em_nivel=create em_nivel
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mesd
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.sle_mesh
this.Control[iCurrent+11]=this.em_nivel
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_cn714_cntbl_rpt_balance_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mesd)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_2)
destroy(this.st_2)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_mesh)
destroy(this.em_nivel)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_moneda, ls_nombre_mes_desde, ls_nombre_mes_hasta, ls_mensaje
Integer 	li_longitud, li_niveles, li_nivel, li_year, li_mes1, li_mes2

li_nivel  = Integer(em_nivel.text)
ls_moneda = upper(ddlb_2.Text)
li_year   = Integer(sle_ano.text)
li_mes1   = Integer(sle_mesd.text)
li_mes2   = Integer(sle_mesh.text)

select nro_niveles into :li_niveles from cntblparam
  where reckey = '1' ;
  
if (li_nivel > li_niveles) or isnull(li_nivel) or li_nivel = 0 then
	MessageBox('Aviso','Número de Nivel no Existe')
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
  
dw_report.retrieve(li_year, li_mes1, li_mes2, ls_moneda, li_longitud)



CHOOSE CASE string(li_mes1, '00')
			
	  	CASE '0'
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
		CASE '00'
			  ls_nombre_mes_desde = 'MES CERO'
		CASE '1'
			  ls_nombre_mes_desde = '01 ENERO'
		CASE '2'
			  ls_nombre_mes_desde = '02 FEBRERO'
	   CASE '3'
			  ls_nombre_mes_desde = '03 MARZO'
      CASE '4'
			  ls_nombre_mes_desde = '04 ABRIL'
		CASE '5'
			  ls_nombre_mes_desde = '05 MAYO'
	   CASE '6'
			  ls_nombre_mes_desde = '06 JUNIO'
		CASE '7'
			  ls_nombre_mes_desde = '07 JULIO'
		CASE '8'
			  ls_nombre_mes_desde = '08 AGOSTO'
	   CASE '9'
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
	CASE '00'
		  ls_nombre_mes_hasta = 'MES CERO'
	CASE '1'
		  ls_nombre_mes_hasta = '01 ENERO'
	CASE '2'
		  ls_nombre_mes_hasta = '02 FEBRERO'
	CASE '3'
		  ls_nombre_mes_hasta = '03 MARZO'
	CASE '4'
		  ls_nombre_mes_hasta = '04 ABRIL'
	CASE '5'
		  ls_nombre_mes_hasta = '05 MAYO'
	CASE '6'
		  ls_nombre_mes_hasta = '06 JUNIO'
	CASE '7'
		  ls_nombre_mes_hasta = '07 JULIO'
	CASE '8'
		  ls_nombre_mes_hasta = '08 AGOSTO'
	CASE '9'
		  ls_nombre_mes_hasta = '09 SEPTIEMBRE'
END CHOOSE


dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_ruc.text		= gs_ruc
dw_report.object.t_desde.text 	= ls_nombre_mes_desde
dw_report.object.t_hasta.text 	= ls_nombre_mes_hasta

end event

type dw_report from w_report_smpl`dw_report within w_cn714_cntbl_rpt_balance_mensual
integer x = 0
integer y = 220
integer width = 3360
integer height = 1120
integer taborder = 70
string dataobject = "d_cntbl_balance_mensual_tbl"
end type

type sle_ano from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
integer x = 210
integer y = 84
integer width = 192
integer height = 72
integer taborder = 10
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

type sle_mesd from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
integer x = 754
integer y = 84
integer width = 105
integer height = 72
integer taborder = 20
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

type cb_1 from commandbutton within w_cn714_cntbl_rpt_balance_mensual
integer x = 2875
integer y = 56
integer width = 297
integer height = 92
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

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_cn714_cntbl_rpt_balance_mensual
integer x = 430
integer y = 92
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
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn714_cntbl_rpt_balance_mensual
integer x = 41
integer y = 92
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

type ddlb_2 from dropdownlistbox within w_cn714_cntbl_rpt_balance_mensual
integer x = 2071
integer y = 68
integer width = 215
integer height = 352
integer taborder = 50
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

type st_2 from statictext within w_cn714_cntbl_rpt_balance_mensual
integer x = 1472
integer y = 84
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

type st_7 from statictext within w_cn714_cntbl_rpt_balance_mensual
integer x = 1824
integer y = 88
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

type st_6 from statictext within w_cn714_cntbl_rpt_balance_mensual
integer x = 891
integer y = 92
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
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mesh from singlelineedit within w_cn714_cntbl_rpt_balance_mensual
integer x = 1193
integer y = 84
integer width = 105
integer height = 72
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

type em_nivel from editmask within w_cn714_cntbl_rpt_balance_mensual
integer x = 1650
integer y = 76
integer width = 160
integer height = 80
integer taborder = 40
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

type cbx_1 from checkbox within w_cn714_cntbl_rpt_balance_mensual
integer x = 2382
integer y = 64
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

type gb_1 from groupbox within w_cn714_cntbl_rpt_balance_mensual
integer y = 4
integer width = 1362
integer height = 196
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

type gb_2 from groupbox within w_cn714_cntbl_rpt_balance_mensual
integer x = 1431
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

