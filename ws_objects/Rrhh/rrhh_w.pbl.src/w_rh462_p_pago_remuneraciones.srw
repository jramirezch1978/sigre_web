$PBExportHeader$w_rh462_p_pago_remuneraciones.srw
forward
global type w_rh462_p_pago_remuneraciones from w_report_smpl
end type
type cb_2 from commandbutton within w_rh462_p_pago_remuneraciones
end type
type em_origen from editmask within w_rh462_p_pago_remuneraciones
end type
type em_descripcion from editmask within w_rh462_p_pago_remuneraciones
end type
type st_2 from statictext within w_rh462_p_pago_remuneraciones
end type
type em_fecha from editmask within w_rh462_p_pago_remuneraciones
end type
type cb_1 from commandbutton within w_rh462_p_pago_remuneraciones
end type
type st_3 from statictext within w_rh462_p_pago_remuneraciones
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh462_p_pago_remuneraciones
end type
type st_4 from statictext within w_rh462_p_pago_remuneraciones
end type
type dw_banco from datawindow within w_rh462_p_pago_remuneraciones
end type
type rb_boleta from radiobutton within w_rh462_p_pago_remuneraciones
end type
type rb_quincena from radiobutton within w_rh462_p_pago_remuneraciones
end type
type rb_cts from radiobutton within w_rh462_p_pago_remuneraciones
end type
type rb_gratificacion from radiobutton within w_rh462_p_pago_remuneraciones
end type
type cbx_cencos from checkbox within w_rh462_p_pago_remuneraciones
end type
type sle_cencos from singlelineedit within w_rh462_p_pago_remuneraciones
end type
type sle_desc_cencos from singlelineedit within w_rh462_p_pago_remuneraciones
end type
type rb_lbs from radiobutton within w_rh462_p_pago_remuneraciones
end type
type uo_fechas from u_ingreso_rango_fechas within w_rh462_p_pago_remuneraciones
end type
type em_fpago from editmask within w_rh462_p_pago_remuneraciones
end type
type st_1 from statictext within w_rh462_p_pago_remuneraciones
end type
type gb_1 from groupbox within w_rh462_p_pago_remuneraciones
end type
type gb_2 from groupbox within w_rh462_p_pago_remuneraciones
end type
end forward

global type w_rh462_p_pago_remuneraciones from w_report_smpl
integer width = 4667
integer height = 1824
string title = "(RH462) Genera Pagos por Remuneraciones"
string menuname = "m_impresion"
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
st_2 st_2
em_fecha em_fecha
cb_1 cb_1
st_3 st_3
uo_1 uo_1
st_4 st_4
dw_banco dw_banco
rb_boleta rb_boleta
rb_quincena rb_quincena
rb_cts rb_cts
rb_gratificacion rb_gratificacion
cbx_cencos cbx_cencos
sle_cencos sle_cencos
sle_desc_cencos sle_desc_cencos
rb_lbs rb_lbs
uo_fechas uo_fechas
em_fpago em_fpago
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_rh462_p_pago_remuneraciones w_rh462_p_pago_remuneraciones

type variables
n_Cst_utilitario	invo_util
end variables

on w_rh462_p_pago_remuneraciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.st_2=create st_2
this.em_fecha=create em_fecha
this.cb_1=create cb_1
this.st_3=create st_3
this.uo_1=create uo_1
this.st_4=create st_4
this.dw_banco=create dw_banco
this.rb_boleta=create rb_boleta
this.rb_quincena=create rb_quincena
this.rb_cts=create rb_cts
this.rb_gratificacion=create rb_gratificacion
this.cbx_cencos=create cbx_cencos
this.sle_cencos=create sle_cencos
this.sle_desc_cencos=create sle_desc_cencos
this.rb_lbs=create rb_lbs
this.uo_fechas=create uo_fechas
this.em_fpago=create em_fpago
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_fecha
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.dw_banco
this.Control[iCurrent+11]=this.rb_boleta
this.Control[iCurrent+12]=this.rb_quincena
this.Control[iCurrent+13]=this.rb_cts
this.Control[iCurrent+14]=this.rb_gratificacion
this.Control[iCurrent+15]=this.cbx_cencos
this.Control[iCurrent+16]=this.sle_cencos
this.Control[iCurrent+17]=this.sle_desc_cencos
this.Control[iCurrent+18]=this.rb_lbs
this.Control[iCurrent+19]=this.uo_fechas
this.Control[iCurrent+20]=this.em_fpago
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
end on

on w_rh462_p_pago_remuneraciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.st_2)
destroy(this.em_fecha)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.uo_1)
destroy(this.st_4)
destroy(this.dw_banco)
destroy(this.rb_boleta)
destroy(this.rb_quincena)
destroy(this.rb_cts)
destroy(this.rb_gratificacion)
destroy(this.cbx_cencos)
destroy(this.sle_cencos)
destroy(this.sle_desc_cencos)
destroy(this.rb_lbs)
destroy(this.uo_fechas)
destroy(this.em_fpago)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_mensaje, ls_tipo_trabaj, ls_nro_cuenta, &
			ls_tipo_pago, ls_directorio, ls_file, &
			ls_cencos, ls_desc_banco_cnta

date ld_fecha, ld_fecha1, ld_Fecha2, ld_fec_pago

//Obtengo el nro de cuenta
ls_nro_cuenta = dw_banco.object.cod_ctabco[1]

if ls_nro_cuenta = '' or IsNull(ls_nro_cuenta) then
	MessageBox('Error', 'Debe Elegir un numero de cuenta')
	return
end if

//Obtengo le descripcion de la cuenta bancaria
select bc.descripcion
	into :ls_desc_banco_cnta
from banco_cnta bc
where bc.cod_ctabco = :ls_nro_cuenta
  and bc.flag_estado = '1';

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Error', 'La cuenta ingresada ' + ls_nro_cuenta + ' no existe o no se encuentra activa, por favor verifique!')
	return
end if

//Creo el directorio en caso no existe
ls_directorio = 'i:\telecredito\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '\' + invo_util.of_replace(ls_nro_cuenta, 'S/.', 'SOLES') + '\'
If not DirectoryExists ( ls_directorio ) Then
	//CREACION DE CARPETA
	if not invo_util.of_CreateDirectory ( ls_directorio ) then return
End If

//Obtengo el resto de datos necesarios
ls_origen   = string(em_origen.text)
ld_fecha    = date(em_fecha.text)
ld_fec_pago = date(em_fpago.text)

ld_fecha1 	= uo_fechas.of_get_fecha1()
ld_fecha2 	= uo_fechas.of_get_fecha2()

//Valido que la fecha de pago no sea menor a la fecha de hoy día
if ld_fec_pago < date(gnvo_app.of_fecha_Actual()) then
	ROLLBACK;
	MessageBox('Error', 'La fecha de pago ingresada ' + String(ld_fec_pago, 'dd/mm/yyyy') &
							+ ' no puede ser menor a la fecha actual. Por favor corrija!')
	em_fpago.text = String(Date(gnvo_app.of_fecha_actual()), 'dd/mm/yyyy')
	em_fpago.SetFocus()
	return
end if

//Obtengo el tipo de trabajador
ls_tipo_trabaj = uo_1.of_get_value()

if uo_1.cbx_todos.checked = false then
	if ls_tipo_trabaj = '' then
		MessageBox('Error', 'DEbe elegir un tipo de trabajador', StopSign!)
		return
	end if
	ls_file = ls_tipo_trabaj
else
	ls_tipo_trabaj = ''
	ls_file = 'TODOS'
end if

//Añado el origen
ls_file += "_" + ls_origen + "_"

//Obtengo el CEntro de costos
if cbx_cencos.checked then
	ls_cencos = '%%'
else
	if trim(sle_cencos.text) = "" then
		gnvo_app.of_mensaje_error("Debe especificar un centro de costos, por favor verifique!", "")
		return
	end if
	
	ls_cencos = trim(sle_cencos.text) + '%'
end if

//Obtengo el tipo de pago
if rb_boleta.checked then
	ls_tipo_pago = '0'
	if cbx_cencos.checked then
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_HABER_' + ls_file
	else
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_HABER_' + trim(sle_cencos.text) + "_" + ls_file
	end if
	
elseif rb_quincena.checked then
	ls_tipo_pago = '1'
	if cbx_cencos.checked then
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_QUINCENA_' + ls_file
	else
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_QUINCENA_' + trim(sle_cencos.text) + "_" + ls_file
	end if

	
elseif rb_cts.checked = true then
	
	ls_tipo_pago = '2'
	if cbx_cencos.checked then
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_CTS_' + ls_file
	else
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_CTS_' + trim(sle_cencos.text) + "_" + ls_file
	end if
	
elseif rb_gratificacion.checked = true then
	
	ls_tipo_pago = '3'
	if cbx_cencos.checked then
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_GRATIFICACION_' + ls_file
	else
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_GRATIFICACION_' + trim(sle_cencos.text) + "_" + ls_file
	end if
	
elseif rb_lbs.checked = true then
	
	ls_tipo_pago = '4'
	if cbx_cencos.checked then
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_LIQUIDACION_' + ls_file
	else
		ls_file = gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '_LIQUIDACION_' + trim(sle_cencos.text) + "_" + ls_file
	end if

end if

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

//No debe procesar ni CTS ni Liquidacion de Beneficios
if ls_tipo_pago <> '2' and ls_tipo_pago <> '4' then
	
	//create or replace procedure USP_RH_HABERES_TELECREDITO (
	//  asi_origen       in origen.cod_origen%TYPE,
	//  adi_fec_proceso  in date,
	//  adi_fec_pago     in date,
	//  asi_tipo_trabaj  in tipo_trabajador.tipo_trabajador%TYPE,
	//  asi_cta_banco    IN banco_cnta.cod_ctabco%TYPE,
	//  asi_cencos       in centros_costo.cencos%TYPE,
	//  asi_quincena     in varchar2
	//) is
	
	
	DECLARE USP_RH_HABERES_TELECREDITO PROCEDURE FOR 
		USP_RH_HABERES_TELECREDITO( :ls_origen, 
											 :ld_fecha, 
											 :ld_fec_pago,
											 :ls_tipo_trabaj,
											 :ls_nro_cuenta,
											 :ls_cencos,
											 :ls_tipo_pago) ;
											 
	EXECUTE USP_RH_HABERES_TELECREDITO ;
	
	IF gnvo_app.of_ExistsError(SQLCA, "USP_RH_HABERES_TELECREDITO") THEN 
		rollback ;
		return
	end if
	
	commit ;
	
	CLOSE USP_RH_HABERES_TELECREDITO;

elseif ls_tipo_pago = '4' then
	
	//create or replace procedure USP_RH_LBS_TELECREDITO (
	//  asi_origen       in origen.cod_origen%TYPE,
	//  adi_fecha1       in date,
	//  adi_fecha2       in date,        
	//  asi_tipo_trabaj  in tipo_trabajador.tipo_trabajador%TYPE,
	//  asi_cta_banco    IN banco_cnta.cod_ctabco%TYPE,
	//  asi_cencos       in centros_costo.cencos%TYPE
	//) is
	
	
	DECLARE USP_RH_LBS_TELECREDITO PROCEDURE FOR 
		USP_RH_LBS_TELECREDITO( :ls_origen, 
										:ld_fecha1, 
										:ld_fecha2,
										:ls_tipo_trabaj,
										:ls_nro_cuenta,
										:ls_cencos) ;
											 
	EXECUTE USP_RH_LBS_TELECREDITO ;
	
	IF gnvo_app.of_ExistsError(SQLCA, "USP_RH_LBS_TELECREDITO") THEN 
		rollback ;
		return
	end if
	
	commit ;
	
	CLOSE USP_RH_LBS_TELECREDITO;

elseif ls_tipo_pago = '2' then
	
	//create or replace procedure usp_rh_pago_cts_semestral (
	//  asi_origen       in origen.cod_origen%TYPE,
	//  adi_fec_proceso  in date,
	//  asi_tipo_trabaj  in tipo_trabajador.tipo_trabajador%TYPE,
	//  asi_cta_banco    IN banco_cnta.cod_ctabco%TYPE,
	//  asi_cencos       in centros_costo.cencos%TYPE
	//) is
	
	DECLARE usp_rh_pago_cts_semestral PROCEDURE FOR 
		usp_rh_pago_cts_semestral( :ls_origen, 
											:ld_fecha, 
											:ls_tipo_trabaj,
											:ls_nro_cuenta,
											:ls_cencos) ;
											 
	EXECUTE usp_rh_pago_cts_semestral ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		rollback ;
		MessageBox("Error en usp_rh_pago_cts_semestral", ls_mensaje)
		return
	end if
	
	commit ;
	
	CLOSE usp_rh_pago_cts_semestral;
	
	dw_report.dataobject = 'd_texto_cts_semestral_tbl'
	dw_report.setTransObject( SQLCA )

end if

dw_report.retrieve()

if dw_report.RowCount() = 0 then
	MessageBox('Error', 'No hay datos que recuperar')
	return
end if


//Genero el path completo del archivo
ls_file = ls_directorio + ls_file + '_' + string(ld_fec_pago, 'yyyymmdd') + '.txt'

if dw_report.saveas( ls_file, Text!, false) = -1 then
	MessageBox('Error', 'No se ha podido generar archivo de telecredito ' + ls_file, StopSign!)
else
	MessageBox('Aviso', 'Archivo de telecredito ' + ls_file + ' generado satisfactoriamente', Information!)
end if


end event

event ue_open_pre;//Override
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

dw_banco.SetTransobject( SQLCA )
dw_banco.Retrieve()
dw_banco.insertrow( 0 )
end event

type dw_report from w_report_smpl`dw_report within w_rh462_p_pago_remuneraciones
integer x = 0
integer y = 440
integer width = 3264
integer height = 1012
integer taborder = 60
string dataobject = "d_txt_telecredito_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type cb_2 from commandbutton within w_rh462_p_pago_remuneraciones
integer x = 608
integer y = 12
integer width = 87
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

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh462_p_pago_remuneraciones
integer x = 453
integer y = 12
integer width = 151
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh462_p_pago_remuneraciones
integer x = 699
integer y = 12
integer width = 576
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_rh462_p_pago_remuneraciones
integer y = 24
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha from editmask within w_rh462_p_pago_remuneraciones
integer x = 453
integer y = 188
integer width = 370
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

event modified;em_fpago.text = this.text
end event

type cb_1 from commandbutton within w_rh462_p_pago_remuneraciones
integer x = 3598
integer y = 8
integer width = 411
integer height = 188
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve() 
end event

type st_3 from statictext within w_rh462_p_pago_remuneraciones
integer y = 200
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha Proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh462_p_pago_remuneraciones
integer x = 2633
integer width = 928
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type st_4 from statictext within w_rh462_p_pago_remuneraciones
integer y = 112
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Cuenta Banco :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_banco from datawindow within w_rh462_p_pago_remuneraciones
integer x = 453
integer y = 104
integer width = 832
integer height = 80
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_banco_cta_tbl"
boolean border = false
boolean livescroll = true
end type

type rb_boleta from radiobutton within w_rh462_p_pago_remuneraciones
integer x = 1403
integer y = 80
integer width = 613
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
string text = "Pago de Boleta"
boolean checked = true
end type

event clicked;if this.checked then
	
	st_3.text = 'Fecha Proceso :'
	em_fecha.enabled  = true
	em_fecha.visible = true
	
	uo_fechas.enabled = false
	uo_fechas.visible = false
	
end if
end event

type rb_quincena from radiobutton within w_rh462_p_pago_remuneraciones
integer x = 1403
integer y = 168
integer width = 613
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
string text = "Adelanto de Quincena"
end type

event clicked;if this.checked then
	
	st_3.text = 'Fecha Proceso :'
	em_fecha.enabled  = true
	em_fecha.visible = true
	
	uo_fechas.enabled = false
	uo_fechas.visible = false
	
end if
end event

type rb_cts from radiobutton within w_rh462_p_pago_remuneraciones
integer x = 2030
integer y = 80
integer width = 558
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
string text = "CTS"
end type

event clicked;if this.checked then
	
	st_3.text = 'Fecha Proceso :'
	em_fecha.enabled  = true
	em_fecha.visible = true
	
	uo_fechas.enabled = false
	uo_fechas.visible = false
	
end if
end event

type rb_gratificacion from radiobutton within w_rh462_p_pago_remuneraciones
integer x = 2030
integer y = 168
integer width = 558
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
string text = "Gratificacion"
end type

event clicked;if this.checked then
	
	st_3.text = 'Fecha Proceso :'
	em_fecha.enabled  = true
	em_fecha.visible = true
	
	uo_fechas.enabled = false
	uo_fechas.visible = false
	
end if
end event

type cbx_cencos from checkbox within w_rh462_p_pago_remuneraciones
integer x = 2679
integer y = 304
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_cencos.enabled = false
	sle_desc_cencos.enabled = false
else
	sle_cencos.enabled = true
	sle_desc_cencos.enabled = true
end if
end event

type sle_cencos from singlelineedit within w_rh462_p_pago_remuneraciones
event ue_dobleclick pbm_lbuttondblclk
integer x = 2912
integer y = 304
integer width = 261
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_fec_proceso

ls_fec_proceso = em_fecha.text

if trim(ls_fec_proceso) = "" or IsNull(ls_fec_proceso) then
	gnvo_app.of_mensaje_error("Debe ingresar una fecha de proceso", "")
	em_fecha.setFocus()
	return
end if

ls_sql = "select distinct cc.cencos as cencos, " &
		 + "cc.desc_cencos as desc_cencos " &
		 + "from historico_calculo hc, " &
		 + "     centros_costo     cc " &
		 + "where hc.cencos = cc.cencos  " //&
		 //+ "and trunc(hc.fec_calc_plan) = to_date('" + ls_fec_proceso + "', 'dd/mm/yyyy')"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_cencos.text = ls_codigo
	sle_desc_cencos.text = ls_data
end if

end event

type sle_desc_cencos from singlelineedit within w_rh462_p_pago_remuneraciones
integer x = 3177
integer y = 304
integer width = 814
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type rb_lbs from radiobutton within w_rh462_p_pago_remuneraciones
integer x = 2030
integer y = 256
integer width = 558
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
string text = "LBS Trabajador"
end type

event clicked;if this.checked then
	
	st_3.text = 'Rango de Fecha :'
	em_fecha.enabled  = false
	em_fecha.visible = false
	
	uo_fechas.enabled = true
	uo_fechas.visible = true
	
else
	
	st_3.text = 'Fecha Proceso :'
	em_fecha.enabled  = true
	em_fecha.visible = true
	
	uo_fechas.enabled = false
	uo_fechas.visible = false
	
end if
end event

type uo_fechas from u_ingreso_rango_fechas within w_rh462_p_pago_remuneraciones
boolean visible = false
integer x = 1339
integer y = 324
integer width = 1271
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
end type

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type em_fpago from editmask within w_rh462_p_pago_remuneraciones
integer x = 453
integer y = 276
integer width = 370
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_rh462_p_pago_remuneraciones
integer y = 280
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha Pago :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh462_p_pago_remuneraciones
integer x = 1330
integer y = 8
integer width = 1298
integer height = 416
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Pago"
end type

type gb_2 from groupbox within w_rh462_p_pago_remuneraciones
integer x = 2633
integer y = 224
integer width = 1403
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por Centro de Costo"
end type

