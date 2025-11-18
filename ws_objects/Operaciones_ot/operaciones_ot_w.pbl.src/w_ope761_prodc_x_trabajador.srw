$PBExportHeader$w_ope761_prodc_x_trabajador.srw
forward
global type w_ope761_prodc_x_trabajador from w_report_smpl
end type
type cb_1 from commandbutton within w_ope761_prodc_x_trabajador
end type
type sle_trabajador from singlelineedit within w_ope761_prodc_x_trabajador
end type
type st_1 from statictext within w_ope761_prodc_x_trabajador
end type
type pb_1 from picturebutton within w_ope761_prodc_x_trabajador
end type
type st_nombre from statictext within w_ope761_prodc_x_trabajador
end type
type uo_1 from u_ingreso_rango_fechas within w_ope761_prodc_x_trabajador
end type
type cbx_trabajador from checkbox within w_ope761_prodc_x_trabajador
end type
type dw_detalle from datawindow within w_ope761_prodc_x_trabajador
end type
type st_2 from statictext within w_ope761_prodc_x_trabajador
end type
type st_3 from statictext within w_ope761_prodc_x_trabajador
end type
type em_bs from editmask within w_ope761_prodc_x_trabajador
end type
type em_sd from editmask within w_ope761_prodc_x_trabajador
end type
type gb_1 from groupbox within w_ope761_prodc_x_trabajador
end type
type gb_2 from groupbox within w_ope761_prodc_x_trabajador
end type
end forward

global type w_ope761_prodc_x_trabajador from w_report_smpl
integer width = 3214
integer height = 1948
string title = "(OPE761) Producion por Trabajador (Costo)"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
cb_1 cb_1
sle_trabajador sle_trabajador
st_1 st_1
pb_1 pb_1
st_nombre st_nombre
uo_1 uo_1
cbx_trabajador cbx_trabajador
dw_detalle dw_detalle
st_2 st_2
st_3 st_3
em_bs em_bs
em_sd em_sd
gb_1 gb_1
gb_2 gb_2
end type
global w_ope761_prodc_x_trabajador w_ope761_prodc_x_trabajador

on w_ope761_prodc_x_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.sle_trabajador=create sle_trabajador
this.st_1=create st_1
this.pb_1=create pb_1
this.st_nombre=create st_nombre
this.uo_1=create uo_1
this.cbx_trabajador=create cbx_trabajador
this.dw_detalle=create dw_detalle
this.st_2=create st_2
this.st_3=create st_3
this.em_bs=create em_bs
this.em_sd=create em_sd
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_trabajador
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.st_nombre
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.cbx_trabajador
this.Control[iCurrent+8]=this.dw_detalle
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.em_bs
this.Control[iCurrent+12]=this.em_sd
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_ope761_prodc_x_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_trabajador)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.st_nombre)
destroy(this.uo_1)
destroy(this.cbx_trabajador)
destroy(this.dw_detalle)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_bs)
destroy(this.em_sd)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;Decimal {2} ldc_factor_bf,ldc_factor_sd

idw_1.Visible = True

ib_preview = false
THIS.Event ue_preview()



//recupero dato de parametros
select factor_benef_social,factor_serv_destajo 
  into :ldc_factor_bf ,:ldc_factor_sd
  from prod_param where reckey = '1' ;
  
  
  
em_bs.text = String(ldc_factor_bf)
em_sd.text = String(ldc_factor_sd)
end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope761_prodc_x_trabajador
integer x = 27
integer y = 616
integer width = 3109
integer height = 1128
string dataobject = "d_abc_rrep_x_trabajador_dest_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_cod_trabajador,ls_cod_prod
Date	 ld_fecha_inicio,ld_fecha_final

this.Accepttext()

choose case dwo.name
		 case 'codprd'
				ls_cod_trabajador = this.object.cod_trabajador [row]
				ls_cod_prod			= this.object.codprd 		  [row]
				
				ld_fecha_inicio = uo_1.of_get_fecha1()
				ld_fecha_final  = uo_1.of_get_fecha2()
				
				dw_detalle.Visible =  TRUE
				dw_detalle.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_prod,ls_cod_trabajador)
				
				
end choose

end event

type cb_1 from commandbutton within w_ope761_prodc_x_trabajador
integer x = 2688
integer y = 72
integer width = 384
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_codigo,ls_cod_prod
Decimal {5} ldc_ben_soc,ldc_serv_terc

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
ls_codigo 		 = sle_trabajador.text
ls_cod_prod		 = '%'

ldc_ben_soc   = Dec(em_bs.text)
ldc_serv_terc = Dec(em_sd.text)


if ldc_ben_soc < 1 then
	Messagebox('Aviso','Factor de Beneficios Sociales debe ser Mayor o Igual a 1.00000 ')
	Return
end if	

if ldc_serv_terc < 1 then
	Messagebox('Aviso','Factor de Servicio de Terceros debe ser Mayor o Igual a 1.00000 ')
	Return
end if	


////recupera codigo de producto
if cbx_trabajador.checked then
	ls_codigo = '%'
else
	if isnull(ls_codigo) or trim(ls_codigo) = ''  then
		Messagebox('Aviso','Debe Ingresar Un codigo de Trabajador')
		Return
	end if
end if	

SetPointer(hourglass!)

DECLARE PB_usp_ope_rpt_prod_x_actividad PROCEDURE FOR usp_ope_rpt_prod_x_actividad 
(:ld_fecha_inicio,:ld_fecha_final,:ls_cod_prod);
EXECUTE PB_usp_ope_rpt_prod_x_actividad ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

dw_report.retrieve(ls_codigo,ld_fecha_inicio,ld_fecha_final,ldc_ben_soc,ldc_serv_terc)


dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa


SetPointer(Arrow!)



end event

type sle_trabajador from singlelineedit within w_ope761_prodc_x_trabajador
integer x = 425
integer y = 232
integer width = 384
integer height = 84
integer taborder = 120
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

type st_1 from statictext within w_ope761_prodc_x_trabajador
integer x = 82
integer y = 240
integer width = 343
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
string text = "Trabajador :"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope761_prodc_x_trabajador
integer x = 832
integer y = 232
integer width = 91
integer height = 80
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "..."
boolean originalsize = true
string picturename = "C:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;if cbx_trabajador.checked = false then
	Str_seleccionar lstr_seleccionar
	Datawindow		 ldw	
				
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT M.COD_TRABAJADOR  AS CLIENTE,'&
			      				 +'M.APEL_PATERNO AS APELLIDO_PATERNO,'&
									 +'M.APEL_MATERNO AS APELLIDO_MATERNO, '&
									 +'M.NOMBRE1 AS NOMBRE1,'&
									 +'M.NOMBRE2 AS NOMBRE2,'&
									 +'M.COD_ORIGEN AS ORIGEN '&
				   				 +'FROM MAESTRO M '&
									 +'WHERE M.FLAG_ESTADO = '+"'"+'1'+"'"

				
	OpenWithParm(w_seleccionar,lstr_seleccionar)
				
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

	IF lstr_seleccionar.s_action = "aceptar" THEN
		if isnull(lstr_seleccionar.param2[1])  then
			lstr_seleccionar.param2[1] = ''
		end if

		if isnull(lstr_seleccionar.param3[1]) then
			lstr_seleccionar.param3[1] = ''
		end if
	
		if isnull(lstr_seleccionar.param4[1])  then
			lstr_seleccionar.param4[1] = ''
		end if
	
		if isnull(lstr_seleccionar.param5[1])  then
			lstr_seleccionar.param5[1] = ''
		end if
		sle_trabajador.text = lstr_seleccionar.param1[1]
		st_nombre.text		  = lstr_seleccionar.param2[1]+' '+lstr_seleccionar.param3[1]+' '+lstr_seleccionar.param4[1]+' '+lstr_seleccionar.param5[1]
	ELSE
		sle_trabajador.text = ''
		st_nombre.text		  = ''
	END IF
end if
end event

type st_nombre from statictext within w_ope761_prodc_x_trabajador
integer x = 951
integer y = 232
integer width = 1280
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ope761_prodc_x_trabajador
integer x = 73
integer y = 96
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(),today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cbx_trabajador from checkbox within w_ope761_prodc_x_trabajador
integer x = 2267
integer y = 228
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_trabajador.text 	  = ''
	st_nombre.text			  = ''
	sle_trabajador.enabled = false
else
	sle_trabajador.text 	  = ''
	st_nombre.text			  = ''	
	sle_trabajador.enabled = true
end if	
end event

type dw_detalle from datawindow within w_ope761_prodc_x_trabajador
boolean visible = false
integer x = 1079
integer y = 460
integer width = 1637
integer height = 1092
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Detalle de Pesos"
string dataobject = "d_abc_detalle_peso_x_prod_x_trab_tbl"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

type st_2 from statictext within w_ope761_prodc_x_trabajador
integer x = 64
integer y = 420
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Factor Beneficios Sociales :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_ope761_prodc_x_trabajador
integer x = 64
integer y = 512
integer width = 722
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Factor Servicio Destajo :"
boolean focusrectangle = false
end type

type em_bs from editmask within w_ope761_prodc_x_trabajador
integer x = 809
integer y = 408
integer width = 270
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_sd from editmask within w_ope761_prodc_x_trabajador
integer x = 809
integer y = 500
integer width = 270
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_ope761_prodc_x_trabajador
integer x = 37
integer width = 2597
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

type gb_2 from groupbox within w_ope761_prodc_x_trabajador
integer x = 32
integer y = 376
integer width = 2610
integer height = 228
integer taborder = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

