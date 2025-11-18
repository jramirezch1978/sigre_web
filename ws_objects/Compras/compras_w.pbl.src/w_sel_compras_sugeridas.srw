$PBExportHeader$w_sel_compras_sugeridas.srw
forward
global type w_sel_compras_sugeridas from window
end type
type st_1 from statictext within w_sel_compras_sugeridas
end type
type sle_almacen from singlelineedit within w_sel_compras_sugeridas
end type
type uo_fecha from u_ingreso_fecha within w_sel_compras_sugeridas
end type
type pb_2 from picturebutton within w_sel_compras_sugeridas
end type
type pb_1 from picturebutton within w_sel_compras_sugeridas
end type
type gb_1 from groupbox within w_sel_compras_sugeridas
end type
type rb_1 from radiobutton within w_sel_compras_sugeridas
end type
type rb_2 from radiobutton within w_sel_compras_sugeridas
end type
type rb_3 from radiobutton within w_sel_compras_sugeridas
end type
end forward

global type w_sel_compras_sugeridas from window
integer x = 1371
integer y = 840
integer width = 1618
integer height = 640
boolean titlebar = true
string title = "Compras Sugeridas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
boolean center = true
st_1 st_1
sle_almacen sle_almacen
uo_fecha uo_fecha
pb_2 pb_2
pb_1 pb_1
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_sel_compras_sugeridas w_sel_compras_sugeridas

type variables

end variables

on w_sel_compras_sugeridas.create
this.st_1=create st_1
this.sle_almacen=create sle_almacen
this.uo_fecha=create uo_fecha
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.Control[]={this.st_1,&
this.sle_almacen,&
this.uo_fecha,&
this.pb_2,&
this.pb_1,&
this.gb_1,&
this.rb_1,&
this.rb_2,&
this.rb_3}
end on

on w_sel_compras_sugeridas.destroy
destroy(this.st_1)
destroy(this.sle_almacen)
destroy(this.uo_fecha)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

type st_1 from statictext within w_sel_compras_sugeridas
integer x = 709
integer y = 60
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacén:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_sel_compras_sugeridas
event dobleclick pbm_lbuttondblclk
integer x = 1065
integer y = 56
integer width = 402
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
		  + "desc_almacen AS descripcion_almacen " &
		  + "FROM almacen " &
		  + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type uo_fecha from u_ingreso_fecha within w_sel_compras_sugeridas
event destroy ( )
integer x = 50
integer y = 56
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;string ls_inicio 
date ld_fec_ini, ld_Fec_fin
integer li_dia

of_set_label('Hasta:') //para setear la fecha inicial
of_set_fecha(today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1()  para leer las fechas

end event

type pb_2 from picturebutton within w_sel_compras_sugeridas
integer x = 837
integer y = 352
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
boolean originalsize = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;str_parametros lstr_param

lstr_param.string1 = 'N'   // No Proceso las compras sugeridas
closewithreturn(parent, lstr_param)
end event

type pb_1 from picturebutton within w_sel_compras_sugeridas
integer x = 466
integer y = 352
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
boolean originalsize = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Date 		ld_fecha_proc
string	ls_almacen, ls_msg, ls_est_amp
str_parametros lstr_param

if rb_1.checked then
	ls_est_amp = '1'
elseif rb_2.checked then
	ls_est_amp = '2'
elseif rb_3.checked then
	ls_est_amp = '3'
else
	MessageBox('Aviso', 'Debe seleccionar alguna de las ' &
			+ 'opciones de los estados de los articulos ' &
			+ 'proyectados')
	return
end if

ld_fecha_proc 	= uo_fecha.of_get_fecha()  //lst_param.fecha1  
ls_almacen		= sle_almacen.text

if trim(ls_almacen) = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe colocar algun almacen')
	return
end if

SetPointer(Hourglass!)

// Genera archivo temporal 
//create or replace procedure USP_CMP_SUGERIDAS_RES_X_ALM(
//       adi_fecha     in date,
//       asi_almacen   in almacen.almacen%TYPE,
//       asi_est_amp   in char
//) is

DECLARE USP_CMP_SUGERIDAS_RES_X_ALM PROCEDURE FOR 
	USP_CMP_SUGERIDAS_RES_X_ALM( :ld_fecha_proc, 
										  :ls_almacen, 
										  :ls_est_amp);
	
EXECUTE USP_CMP_SUGERIDAS_RES_X_ALM;

IF SQLCA.SQLCODE < 0 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_msg)
	SetPointer(Arrow!)
	Return
END IF

CLOSE USP_CMP_SUGERIDAS_RES_X_ALM;

lstr_param.string1 = 'P'   				// Proceso las compras sugeridas
lstr_param.almacen = ls_almacen
SetPointer(Arrow!)
closewithreturn(parent, lstr_param)
end event

type gb_1 from groupbox within w_sel_compras_sugeridas
integer x = 87
integer y = 156
integer width = 1463
integer height = 164
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado de los Art. proyectados"
end type

type rb_1 from radiobutton within w_sel_compras_sugeridas
integer x = 105
integer y = 220
integer width = 343
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
string text = "Abiertos"
boolean checked = true
end type

type rb_2 from radiobutton within w_sel_compras_sugeridas
integer x = 489
integer y = 220
integer width = 622
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
string text = "Abiertos + Planeados"
end type

type rb_3 from radiobutton within w_sel_compras_sugeridas
integer x = 1152
integer y = 220
integer width = 343
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
string text = "Planeados"
end type

