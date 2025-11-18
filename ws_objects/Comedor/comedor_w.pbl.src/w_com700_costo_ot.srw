$PBExportHeader$w_com700_costo_ot.srw
forward
global type w_com700_costo_ot from w_rpt_general
end type
type sle_orden from singlelineedit within w_com700_costo_ot
end type
type st_1 from statictext within w_com700_costo_ot
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_com700_costo_ot
end type
type sle_origen from singlelineedit within w_com700_costo_ot
end type
type st_2 from statictext within w_com700_costo_ot
end type
type pb_1 from picturebutton within w_com700_costo_ot
end type
type gb_2 from groupbox within w_com700_costo_ot
end type
type gb_1 from groupbox within w_com700_costo_ot
end type
end forward

global type w_com700_costo_ot from w_rpt_general
integer width = 2862
integer height = 2144
string title = "Costo Orden Trabajo (Comedores) - Detallado (COM700)"
string is_niveles = "0"
sle_orden sle_orden
st_1 st_1
uo_fecha uo_fecha
sle_origen sle_origen
st_2 st_2
pb_1 pb_1
gb_2 gb_2
gb_1 gb_1
end type
global w_com700_costo_ot w_com700_costo_ot

on w_com700_costo_ot.create
int iCurrent
call super::create
this.sle_orden=create sle_orden
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.sle_origen=create sle_origen
this.st_2=create st_2
this.pb_1=create pb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_orden
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_com700_costo_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_orden)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_nro_orden, ls_mov_sal
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

ls_origen 		= sle_origen.text
ls_nro_orden 	= sle_orden.text

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ls_nro_orden = '' or IsNull(ls_nro_orden ) then
	MessageBox('COMEDORES', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

// Para comprobar que solo ingresa un numero sin codigo de origen
IF Len(ls_nro_orden) < 10 THEN
	ls_nro_orden = trim(ls_origen) + string(integer(ls_nro_orden), '00000000')
	sle_orden.text = ls_nro_orden
END IF

idw_1.Retrieve(ls_origen, ls_nro_orden,ld_fecha1, ld_fecha2)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_fecha1.text	  = String(ld_fecha1, 'dd/mm/yyyy')
idw_1.Object.t_fecha2.text	  = String(ld_fecha2, 'dd/mm/yyyy')

end event

event ue_open_pre;call super::ue_open_pre;sle_origen.text = gs_origen
sle_origen.event modified( )
end event

type dw_report from w_rpt_general`dw_report within w_com700_costo_ot
integer y = 356
integer width = 2240
integer height = 1516
string dataobject = "d_rpt_costo_ot_com_tbl"
end type

type sle_orden from singlelineedit within w_com700_costo_ot
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 1783
integer y = 140
integer width = 407
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
sg_parametros sl_param
sl_param.dw1    = 'd_lista_ot_x_usuario_tbl'
sl_param.titulo = 'Orden de Trabajo'
sl_param.tipo    = '1SQL'                                                          
sl_param.string1 = "WHERE USUARIO= '" + gs_user  &
	+ "' AND COD_ORIGEN = '" + gs_origen + "'"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4
sl_param.field_ret_i[5] = 5
sl_param.field_ret_i[6] = 6
sl_param.field_ret_i[7] = 7
sl_param.field_ret_i[8] = 8
sl_param.field_ret_i[9] = 9
sl_param.field_ret_i[10] = 10

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
				
	This.Text = sl_param.field_ret[2]
	parent.event dynamic ue_retrieve()
			
END IF


end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

type st_1 from statictext within w_com700_costo_ot
integer x = 1801
integer y = 76
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Orden:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_com700_costo_ot
event destroy ( )
integer x = 105
integer y = 92
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))

of_set_fecha(date(ls_desde), today()) 			//	para setear la fecha inicial	

of_set_rango_inicio(date('01/01/1900')) 		// rango inicial
of_set_rango_fin(date('31/12/9999')) 			// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_origen from singlelineedit within w_com700_costo_ot
event ue_doubleclick pbm_lbuttondblclk
integer x = 946
integer y = 136
integer width = 206
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event ue_doubleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_ORIGEN AS CODIGO, " 	&
		 + "NOMBRE AS DESCRIPCION " 			&
		 + "FROM ORIGEN " 						&
		 + "WHERE FLAG_ESTADO = '1' " 		
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

IF ls_codigo <> '' THEN
	st_2.text = ls_data
	this.text = ls_codigo
END IF
	
end event

event modified;string ls_desc, ls_cod

ls_cod = this.text

select nombre
	into :ls_desc
from origen
where cod_origen = :ls_cod
  and flag_estado = '1';
 
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Origen no existe o no esta activo')
	this.text = ''
	st_2.text = ''
	return
end if

st_2.text = ls_desc
end event

type st_2 from statictext within w_com700_costo_ot
integer x = 1175
integer y = 136
integer width = 562
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_com700_costo_ot
integer x = 2277
integer y = 96
integer width = 430
integer height = 148
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve( )

end event

type gb_2 from groupbox within w_com700_costo_ot
integer x = 901
integer y = 68
integer width = 1353
integer height = 184
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_com700_costo_ot
integer x = 82
integer y = 36
integer width = 699
integer height = 280
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

