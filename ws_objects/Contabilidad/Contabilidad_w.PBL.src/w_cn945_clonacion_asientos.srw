$PBExportHeader$w_cn945_clonacion_asientos.srw
forward
global type w_cn945_clonacion_asientos from w_prc
end type
type em_fecha from editmask within w_cn945_clonacion_asientos
end type
type st_10 from statictext within w_cn945_clonacion_asientos
end type
type st_9 from statictext within w_cn945_clonacion_asientos
end type
type sle_origen2 from singlelineedit within w_cn945_clonacion_asientos
end type
type sle_mes1 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_8 from statictext within w_cn945_clonacion_asientos
end type
type sle_year1 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_7 from statictext within w_cn945_clonacion_asientos
end type
type st_6 from statictext within w_cn945_clonacion_asientos
end type
type sle_origen1 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_2 from statictext within w_cn945_clonacion_asientos
end type
type sle_year2 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_3 from statictext within w_cn945_clonacion_asientos
end type
type sle_mes2 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_4 from statictext within w_cn945_clonacion_asientos
end type
type sle_libro1 from singlelineedit within w_cn945_clonacion_asientos
end type
type st_5 from statictext within w_cn945_clonacion_asientos
end type
type sle_asiento1 from singlelineedit within w_cn945_clonacion_asientos
end type
type cb_cancelar from commandbutton within w_cn945_clonacion_asientos
end type
type cb_generar from commandbutton within w_cn945_clonacion_asientos
end type
type st_1 from statictext within w_cn945_clonacion_asientos
end type
type gb_1 from groupbox within w_cn945_clonacion_asientos
end type
type gb_2 from groupbox within w_cn945_clonacion_asientos
end type
end forward

global type w_cn945_clonacion_asientos from w_prc
integer width = 2359
integer height = 1004
string title = "[CN945] Clonación de Asientos Contables"
string menuname = "m_prc"
boolean maxbox = false
boolean resizable = false
boolean center = true
em_fecha em_fecha
st_10 st_10
st_9 st_9
sle_origen2 sle_origen2
sle_mes1 sle_mes1
st_8 st_8
sle_year1 sle_year1
st_7 st_7
st_6 st_6
sle_origen1 sle_origen1
st_2 st_2
sle_year2 sle_year2
st_3 st_3
sle_mes2 sle_mes2
st_4 st_4
sle_libro1 sle_libro1
st_5 st_5
sle_asiento1 sle_asiento1
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn945_clonacion_asientos w_cn945_clonacion_asientos

on w_cn945_clonacion_asientos.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.em_fecha=create em_fecha
this.st_10=create st_10
this.st_9=create st_9
this.sle_origen2=create sle_origen2
this.sle_mes1=create sle_mes1
this.st_8=create st_8
this.sle_year1=create sle_year1
this.st_7=create st_7
this.st_6=create st_6
this.sle_origen1=create sle_origen1
this.st_2=create st_2
this.sle_year2=create sle_year2
this.st_3=create st_3
this.sle_mes2=create sle_mes2
this.st_4=create st_4
this.sle_libro1=create sle_libro1
this.st_5=create st_5
this.sle_asiento1=create sle_asiento1
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fecha
this.Control[iCurrent+2]=this.st_10
this.Control[iCurrent+3]=this.st_9
this.Control[iCurrent+4]=this.sle_origen2
this.Control[iCurrent+5]=this.sle_mes1
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.sle_year1
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.sle_origen1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_year2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.sle_mes2
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.sle_libro1
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.sle_asiento1
this.Control[iCurrent+19]=this.cb_cancelar
this.Control[iCurrent+20]=this.cb_generar
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
end on

on w_cn945_clonacion_asientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fecha)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.sle_origen2)
destroy(this.sle_mes1)
destroy(this.st_8)
destroy(this.sle_year1)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_origen1)
destroy(this.st_2)
destroy(this.sle_year2)
destroy(this.st_3)
destroy(this.sle_mes2)
destroy(this.st_4)
destroy(this.sle_libro1)
destroy(this.st_5)
destroy(this.sle_asiento1)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;sle_year1.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')
sle_year2.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')

sle_mes1.text = string(gnvo_app.of_fecha_Actual(), 'mm')
sle_mes2.text = string(gnvo_app.of_fecha_Actual(), 'mm')

sle_origen1.text = gs_origen
sle_origen2.text = gs_origen

em_fecha.text = string(gnvo_app.of_fecha_actual( ), 'dd/mm/yyyy')


end event

type em_fecha from editmask within w_cn945_clonacion_asientos
integer x = 1842
integer y = 444
integer width = 389
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
boolean dropdowncalendar = true
end type

type st_10 from statictext within w_cn945_clonacion_asientos
integer x = 1609
integer y = 448
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha:"
alignment alignment = right!
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_9 from statictext within w_cn945_clonacion_asientos
integer x = 55
integer y = 452
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_origen2 from singlelineedit within w_cn945_clonacion_asientos
integer x = 256
integer y = 440
integer width = 197
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_mes1 from singlelineedit within w_cn945_clonacion_asientos
integer x = 1001
integer y = 184
integer width = 197
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_8 from statictext within w_cn945_clonacion_asientos
integer x = 859
integer y = 192
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_year1 from singlelineedit within w_cn945_clonacion_asientos
integer x = 626
integer y = 184
integer width = 197
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within w_cn945_clonacion_asientos
integer x = 489
integer y = 192
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_6 from statictext within w_cn945_clonacion_asientos
integer x = 55
integer y = 192
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_origen1 from singlelineedit within w_cn945_clonacion_asientos
integer x = 256
integer y = 184
integer width = 197
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn945_clonacion_asientos
integer x = 489
integer y = 452
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_year2 from singlelineedit within w_cn945_clonacion_asientos
integer x = 626
integer y = 444
integer width = 197
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn945_clonacion_asientos
integer x = 859
integer y = 452
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_cn945_clonacion_asientos
integer x = 1001
integer y = 444
integer width = 197
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn945_clonacion_asientos
integer x = 1230
integer y = 192
integer width = 155
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_libro1 from singlelineedit within w_cn945_clonacion_asientos
integer x = 1403
integer y = 184
integer width = 197
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_cn945_clonacion_asientos
integer x = 1627
integer y = 192
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Asiento"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_asiento1 from singlelineedit within w_cn945_clonacion_asientos
integer x = 1838
integer y = 184
integer width = 334
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn945_clonacion_asientos
integer x = 1170
integer y = 624
integer width = 347
integer height = 184
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn945_clonacion_asientos
integer x = 786
integer y = 624
integer width = 347
integer height = 184
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clonar"
end type

event clicked;Integer	li_year1, li_year2,  li_mes1, li_mes2, li_nro_libro1, li_nro_asiento1, li_nro_asiento2
string  	ls_origen1, ls_origen2, ls_msj
date		ld_fecha

//Valido datos del origen
if trim(sle_origen1.text) = '' then
	MessageBox('Error', 'Debe Especificar el ORIGEN del voucher de origen, por favor verifique!')
	sle_origen1.setFocus()
	return
end if

if trim(sle_year1.text) = '' then
	MessageBox('Error', 'Debe Especificar el AÑO del voucher de origen, por favor verifique!')
	sle_year1.setFocus()
	return
end if

if trim(sle_mes1.text) = '' then
	MessageBox('Error', 'Debe Especificar el MES del voucher de origen, por favor verifique!')
	sle_mes1.setFocus()
	return
end if

if trim(sle_libro1.text) = '' then
	MessageBox('Error', 'Debe Especificar el LIBRO del voucher de origen, por favor verifique!')
	sle_libro1.setFocus()
	return
end if

if trim(sle_asiento1.text) = '' then
	MessageBox('Error', 'Debe Especificar el NRO DE ASIENTO del voucher de origen, por favor verifique!')
	sle_asiento1.setFocus()
	return
end if

//Valido datos del destino
if trim(sle_origen2.text) = '' then
	MessageBox('Error', 'Debe Especificar el origen del destino, por favor verifique!')
	sle_origen2.setFocus()
	return
end if

if trim(sle_year2.text) = '' then
	MessageBox('Error', 'Debe Especificar el AÑO del destino, por favor verifique!')
	sle_year2.setFocus()
	return
end if

if trim(sle_mes2.text) = '' then
	MessageBox('Error', 'Debe Especificar el MES del destino, por favor verifique!')
	sle_mes2.setFocus()
	return
end if

//Obtengo los valores necesarios
ls_origen1 	= trim(sle_origen1.text)
ls_origen2 	= trim(sle_origen2.text)

li_year1 	= Integer(sle_year1.text)
li_year2 	= Integer(sle_year2.text)

li_mes1 		= Integer(sle_mes1.text)
li_mes2 		= Integer(sle_mes2.text)

li_nro_libro1		= Integer(sle_libro1.text)
li_nro_asiento1	= Integer(sle_asiento1.text)

em_fecha.getdata( ld_fecha )

//Valido periodos
if li_year1 = li_year2 and li_mes1 = li_mes2 then
	if MessageBox('Aviso', 'El periodo del ORIGEN y del DESTINO son el mismo, desea continuar?', Information!, YesNo!, 2) = 2 then return
end if

if MessageBox('Aviso', '¿Desea clonar el voucher origen: [' + ls_origen1 + string(li_year1, '0000') + string(li_mes1, '00') &
	+ string(li_nro_libro1, '00') + string(li_nro_asiento1, '000000') + '] al destino [' + ls_origen2 + '-' + string(li_year2, '0000') + '-' + string(li_mes2, '00')+'] ?', Information!, YesNo!, 2) = 2 then return

// Generacion de asientos contables de almacen de materiales
/*
	create or replace procedure usp_cntbl_clonar_asientos (
			 asi_origen1     in cntbl_asiento.origen%TYPE,
			 ani_year1       in cntbl_asiento.ano%TYPE,
			 ani_mes1        in cntbl_asiento.mes%TYPE,
			 ani_nro_libro1  in cntbl_asiento.nro_libro%TYPE,
			 ani_nro_asiento in cntbl_asiento.nro_asiento%TYPE,
			 asi_origen2     in cntbl_asiento.origen%TYPE,
			 ani_year2       in cntbl_asiento.ano%TYPE,
			 ani_mes2        in cntbl_asiento.mes%TYPE,
			 adi_Fecha       in date,
			 asi_user        in cntbl_asiento.cod_usr%TYPE,
			 ano_nro_asiento out cntbl_asiento.nro_asiento%TYPE
	) is
*/
DECLARE usp_cntbl_clonar_asientos PROCEDURE FOR 
	usp_cntbl_clonar_asientos (:ls_origen1,
									   :li_year1, 
								 		:li_mes1, 
								 		:li_nro_libro1,
										:li_nro_asiento1,
										:ls_origen2,
										:li_year2,
										:li_mes2,
										:ld_fecha,
								 		:gs_user) ;
								 
EXECUTE usp_cntbl_clonar_asientos  ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error usp_cntbl_clonar_asientos', 'Error en procedimiento usp_cntbl_clonar_asientos' + ls_msj, StopSign! )
	return
END IF

fetch usp_cntbl_clonar_asientos into :li_nro_Asiento2;

Close usp_cntbl_clonar_asientos;

MessageBox( 'Mensaje', "Proceso de CLONACION de Asiento CONTABLE concluido satisfactoriamente" )
		

end event

type st_1 from statictext within w_cn945_clonacion_asientos
integer width = 2336
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CLONACIÓN DE ASIENTOS CONTABLES"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn945_clonacion_asientos
integer y = 356
integer width = 2336
integer height = 224
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Destino"
end type

type gb_2 from groupbox within w_cn945_clonacion_asientos
integer y = 96
integer width = 2336
integer height = 224
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voucher Origen"
end type

