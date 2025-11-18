$PBExportHeader$w_pr914_imp_file_packing.srw
forward
global type w_pr914_imp_file_packing from w_abc
end type
type em_2 from editmask within w_pr914_imp_file_packing
end type
type st_nro_asiento from statictext within w_pr914_imp_file_packing
end type
type st_3 from statictext within w_pr914_imp_file_packing
end type
type st_4 from statictext within w_pr914_imp_file_packing
end type
type uo_fecha from u_ingreso_fecha within w_pr914_imp_file_packing
end type
type ddlb_mes from dropdownlistbox within w_pr914_imp_file_packing
end type
type em_descripcion from editmask within w_pr914_imp_file_packing
end type
type em_origen from singlelineedit within w_pr914_imp_file_packing
end type
type st_1 from statictext within w_pr914_imp_file_packing
end type
type st_2 from statictext within w_pr914_imp_file_packing
end type
type cb_1 from commandbutton within w_pr914_imp_file_packing
end type
type cb_2 from commandbutton within w_pr914_imp_file_packing
end type
type em_year from editmask within w_pr914_imp_file_packing
end type
type gb_2 from groupbox within w_pr914_imp_file_packing
end type
type gb_1 from groupbox within w_pr914_imp_file_packing
end type
end forward

global type w_pr914_imp_file_packing from w_abc
integer width = 2464
integer height = 880
string title = "(PR914) Importar Archivo de Producción Packing"
string menuname = "m_smpl"
event ue_aceptar ( )
em_2 em_2
st_nro_asiento st_nro_asiento
st_3 st_3
st_4 st_4
uo_fecha uo_fecha
ddlb_mes ddlb_mes
em_descripcion em_descripcion
em_origen em_origen
st_1 st_1
st_2 st_2
cb_1 cb_1
cb_2 cb_2
em_year em_year
gb_2 gb_2
gb_1 gb_1
end type
global w_pr914_imp_file_packing w_pr914_imp_file_packing

event ue_aceptar();integer 	li_year, li_mes, li_nro_libro, li_nro_asiento
string 	ls_origen, ls_mensaje
date ld_fecha_asiento

ls_origen			= em_origen.text
li_year 				= integer(em_year.Text)
li_mes 				= integer(left(ddlb_mes.Text,2))
ld_fecha_asiento 	= uo_fecha.of_get_fecha()
//li_nro_libro		= integer(em_nro_libro.text)

if IsNull(li_year) then
	MessageBox('Producción', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if

if IsNull(li_mes) then
	MessageBox('Producción', 'NO HA INGRESO UNA SEMANA VÁLIDA',StopSign!)
	return
end if

DECLARE usp_prod_transporte_asiento PROCEDURE FOR
	usp_prod_transporte_asiento( :li_year, :li_mes, :ls_origen, :gs_user, :ld_fecha_asiento, :li_nro_libro );
EXECUTE usp_prod_transporte_asiento;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_prod_transporte_asiento: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_prod_transporte_asiento INTO :li_nro_asiento;
CLOSE usp_prod_transporte_asiento;

MessageBox('Producción', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)	
st_nro_asiento.text = string(li_nro_asiento)
return


end event

on w_pr914_imp_file_packing.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.em_2=create em_2
this.st_nro_asiento=create st_nro_asiento
this.st_3=create st_3
this.st_4=create st_4
this.uo_fecha=create uo_fecha
this.ddlb_mes=create ddlb_mes
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_year=create em_year
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_2
this.Control[iCurrent+2]=this.st_nro_asiento
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.ddlb_mes
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.em_year
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_1
end on

on w_pr914_imp_file_packing.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_2)
destroy(this.st_nro_asiento)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.uo_fecha)
destroy(this.ddlb_mes)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_year)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event closequery;call super::closequery;
THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

Destroy	im_1

of_close_sheet()
end event

event ue_cancelar;call super::ue_cancelar;close(this)
end event

event ue_open_pre;call super::ue_open_pre;em_year.text = string( year( today() ) )
end event

type em_2 from editmask within w_pr914_imp_file_packing
integer x = 955
integer y = 68
integer width = 315
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
end type

type st_nro_asiento from statictext within w_pr914_imp_file_packing
integer x = 2181
integer y = 516
integer width = 197
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 15780518
long backcolor = 134217734
alignment alignment = center!
boolean border = true
long bordercolor = 65280
boolean focusrectangle = false
end type

type st_3 from statictext within w_pr914_imp_file_packing
integer x = 1495
integer y = 536
integer width = 649
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Nro. del Asiento Contable"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pr914_imp_file_packing
integer x = 1275
integer y = 308
integer width = 494
integer height = 112
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Ingrese fecha del asiento contable"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_fecha within w_pr914_imp_file_packing
event destroy ( )
integer x = 1769
integer y = 328
integer taborder = 50
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Fecha') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
//of_get_fecha()  para leer las fechas


 
end event

type ddlb_mes from dropdownlistbox within w_pr914_imp_file_packing
integer x = 663
integer y = 316
integer width = 558
integer height = 352
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Lulio","08 - Agosto","09 - Septiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type em_descripcion from editmask within w_pr914_imp_file_packing
integer x = 165
integer y = 56
integer width = 663
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 10789024
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr914_imp_file_packing
event dobleclick pbm_lbuttondblclk
integer x = 23
integer y = 56
integer width = 128
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type st_1 from statictext within w_pr914_imp_file_packing
integer y = 328
integer width = 530
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Fecha de Producción"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr914_imp_file_packing
integer x = 475
integer y = 328
integer width = 160
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr914_imp_file_packing
integer x = 41
integer y = 524
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;parent.event ue_aceptar()

end event

type cb_2 from commandbutton within w_pr914_imp_file_packing
integer x = 398
integer y = 524
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ca&ncelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type em_year from editmask within w_pr914_imp_file_packing
integer x = 219
integer y = 312
integer width = 233
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type gb_2 from groupbox within w_pr914_imp_file_packing
integer width = 905
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_pr914_imp_file_packing
integer x = 933
integer width = 393
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de produccion"
end type

