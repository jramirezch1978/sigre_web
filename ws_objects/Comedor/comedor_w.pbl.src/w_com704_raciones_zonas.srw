$PBExportHeader$w_com704_raciones_zonas.srw
forward
global type w_com704_raciones_zonas from w_rpt_general
end type
type uo_fecha from u_ingreso_rango_fechas within w_com704_raciones_zonas
end type
type em_origen from singlelineedit within w_com704_raciones_zonas
end type
type em_descripcion from editmask within w_com704_raciones_zonas
end type
type pb_1 from picturebutton within w_com704_raciones_zonas
end type
type gb_2 from groupbox within w_com704_raciones_zonas
end type
end forward

global type w_com704_raciones_zonas from w_rpt_general
integer width = 2697
integer height = 1232
string title = "Facturas de Comedores (COM704)"
uo_fecha uo_fecha
em_origen em_origen
em_descripcion em_descripcion
pb_1 pb_1
gb_2 gb_2
end type
global w_com704_raciones_zonas w_com704_raciones_zonas

on w_com704_raciones_zonas.create
int iCurrent
call super::create
this.uo_fecha=create uo_fecha
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.pb_1=create pb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_com704_raciones_zonas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.pb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string   ls_origen

ls_origen	= em_origen.text
ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ld_fecha2 < ld_fecha1 then
	MessageBox('COMEDORES', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

idw_1.Retrieve(ls_origen, ld_fecha1, ld_fecha2)
idw_1.Object.DataWindow.Print.Orientation = '1'
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Visible = True


end event

type dw_report from w_rpt_general`dw_report within w_com704_raciones_zonas
integer y = 212
integer width = 2601
integer height = 768
string dataobject = "d_rpt_factura_conciliacion_cpm"
end type

type uo_fecha from u_ingreso_rango_fechas within w_com704_raciones_zonas
integer x = 933
integer y = 64
integer height = 80
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type em_origen from singlelineedit within w_com704_raciones_zonas
event dobleclick pbm_lbuttondblclk
integer x = 73
integer y = 68
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

type em_descripcion from editmask within w_com704_raciones_zonas
integer x = 215
integer y = 68
integer width = 663
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type pb_1 from picturebutton within w_com704_raciones_zonas
integer x = 2281
integer y = 20
integer width = 315
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type gb_2 from groupbox within w_com704_raciones_zonas
integer x = 32
integer y = 8
integer width = 882
integer height = 164
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

