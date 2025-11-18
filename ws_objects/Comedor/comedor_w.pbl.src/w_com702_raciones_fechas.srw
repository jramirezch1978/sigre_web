$PBExportHeader$w_com702_raciones_fechas.srw
forward
global type w_com702_raciones_fechas from w_rpt_general
end type
type uo_fecha from u_ingreso_rango_fechas within w_com702_raciones_fechas
end type
type em_origen from singlelineedit within w_com702_raciones_fechas
end type
type em_descripcion from editmask within w_com702_raciones_fechas
end type
type pb_1 from picturebutton within w_com702_raciones_fechas
end type
type em_proveedor from singlelineedit within w_com702_raciones_fechas
end type
type em_nombre from editmask within w_com702_raciones_fechas
end type
type gb_2 from groupbox within w_com702_raciones_fechas
end type
type gb_1 from groupbox within w_com702_raciones_fechas
end type
type gb_3 from groupbox within w_com702_raciones_fechas
end type
end forward

global type w_com702_raciones_fechas from w_rpt_general
integer width = 3858
integer height = 1512
string title = "Raciones Brindadas (COM702)"
boolean center = false
uo_fecha uo_fecha
em_origen em_origen
em_descripcion em_descripcion
pb_1 pb_1
em_proveedor em_proveedor
em_nombre em_nombre
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_com702_raciones_fechas w_com702_raciones_fechas

on w_com702_raciones_fechas.create
int iCurrent
call super::create
this.uo_fecha=create uo_fecha
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.pb_1=create pb_1
this.em_proveedor=create em_proveedor
this.em_nombre=create em_nombre
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.em_proveedor
this.Control[iCurrent+6]=this.em_nombre
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_3
end on

on w_com702_raciones_fechas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.pb_1)
destroy(this.em_proveedor)
destroy(this.em_nombre)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string 	ls_origen, ls_proveedor

ls_origen		= em_origen.text
ls_proveedor	= em_proveedor.text
ld_fecha1 		= uo_fecha.of_get_fecha1( )
ld_fecha2 		= uo_fecha.of_get_fecha2( )

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ld_fecha2 < ld_fecha1 then
	MessageBox('COMEDORES', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_origen, ls_proveedor)
idw_1.Object.DataWindow.Print.Orientation = '1'
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Visible = True


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_rpt_general`dw_report within w_com702_raciones_fechas
integer x = 41
integer y = 268
integer width = 3707
integer height = 1016
string dataobject = "d_rpt_raciones_cmp"
end type

type uo_fecha from u_ingreso_rango_fechas within w_com702_raciones_fechas
integer x = 69
integer y = 96
integer taborder = 40
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

type em_origen from singlelineedit within w_com702_raciones_fechas
event dobleclick pbm_lbuttondblclk
integer x = 1417
integer y = 112
integer width = 128
integer height = 80
integer taborder = 20
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

type em_descripcion from editmask within w_com702_raciones_fechas
integer x = 1568
integer y = 108
integer width = 663
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type pb_1 from picturebutton within w_com702_raciones_fechas
integer x = 3442
integer y = 56
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
boolean originalsize = true
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type em_proveedor from singlelineedit within w_com702_raciones_fechas
event dobleclick pbm_lbuttondblclk
integer x = 2322
integer y = 120
integer width = 261
integer height = 76
integer taborder = 20
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
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT proveedor as codigo, " & 
		  +"nom_proveedor AS nombre " &
		  + "FROM proveedor " &
		  + "WHERE flag_estado = '1' and proveedor in (Select p.proveedor from com_parte_rac p) "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_nombre.text = ls_data
end if

end event

event modified;String 	ls_proveedor, ls_desc

ls_proveedor = this.text
if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe Ingresar un Proveedor')
	return
end if

SELECT nom_proveedor INTO :ls_desc
FROM proveedor
WHERE proveedor =:ls_proveedor;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	return
end if

em_nombre.text = ls_desc

end event

type em_nombre from editmask within w_com702_raciones_fechas
integer x = 2592
integer y = 120
integer width = 763
integer height = 76
integer taborder = 30
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

type gb_2 from groupbox within w_com702_raciones_fechas
integer x = 41
integer y = 40
integer width = 1335
integer height = 184
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Fechas"
end type

type gb_1 from groupbox within w_com702_raciones_fechas
integer x = 2295
integer y = 40
integer width = 1111
integer height = 184
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Proveedor"
end type

type gb_3 from groupbox within w_com702_raciones_fechas
integer x = 1385
integer y = 40
integer width = 901
integer height = 184
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

