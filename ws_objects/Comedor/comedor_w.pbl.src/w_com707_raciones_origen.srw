$PBExportHeader$w_com707_raciones_origen.srw
forward
global type w_com707_raciones_origen from w_rpt_general
end type
type em_descripcion from editmask within w_com707_raciones_origen
end type
type em_origen from singlelineedit within w_com707_raciones_origen
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_com707_raciones_origen
end type
type pb_1 from picturebutton within w_com707_raciones_origen
end type
type gb_2 from groupbox within w_com707_raciones_origen
end type
end forward

global type w_com707_raciones_origen from w_rpt_general
integer width = 3200
string title = "Parte Raciones(COM707)"
em_descripcion em_descripcion
em_origen em_origen
uo_fecha uo_fecha
pb_1 pb_1
gb_2 gb_2
end type
global w_com707_raciones_origen w_com707_raciones_origen

on w_com707_raciones_origen.create
int iCurrent
call super::create
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_com707_raciones_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_parte, ls_origen, ls_mensaje, ls_year, ls_mes, ls_nombre_origen
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
ls_origen	= em_origen.text
//ls_year 		= em_year.Text
//ls_mes 		= left(ddlb_mes.Text,2)

select nombre 
into :ls_nombre_origen
from origen
where cod_origen = :ls_origen;

//if IsNull(ls_year) then
//	MessageBox('COMEDORES', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
//	return
//end if
//
//if IsNull(ls_mes) then
//	MessageBox('COMEDORES', 'NO HA INGRESO UNA SEMANA VÁLIDA',StopSign!)
//	return
//end if

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

idw_1.Retrieve(ls_origen, ld_fecha_ini, ld_fecha_fin)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)



end event

type dw_report from w_rpt_general`dw_report within w_com707_raciones_origen
integer y = 316
integer width = 2688
string dataobject = "d_com_parte_raciones_origen_tbl"
end type

type em_descripcion from editmask within w_com707_raciones_origen
integer x = 873
integer y = 124
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

type em_origen from singlelineedit within w_com707_raciones_origen
event dobleclick pbm_lbuttondblclk
integer x = 731
integer y = 124
integer width = 128
integer height = 72
integer taborder = 40
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

type uo_fecha from u_ingreso_rango_fechas_v within w_com707_raciones_origen
integer x = 27
integer y = 56
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type pb_1 from picturebutton within w_com707_raciones_origen
integer x = 2304
integer y = 64
integer width = 375
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

type gb_2 from groupbox within w_com707_raciones_origen
integer x = 690
integer y = 40
integer width = 923
integer height = 216
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

