$PBExportHeader$w_ap906_genera_grmp.srw
forward
global type w_ap906_genera_grmp from w_abc
end type
type st_7 from statictext within w_ap906_genera_grmp
end type
type sle_origen from singlelineedit within w_ap906_genera_grmp
end type
type st_origen from statictext within w_ap906_genera_grmp
end type
type st_2 from statictext within w_ap906_genera_grmp
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap906_genera_grmp
end type
type pb_1 from picturebutton within w_ap906_genera_grmp
end type
type pb_2 from picturebutton within w_ap906_genera_grmp
end type
type st_1 from statictext within w_ap906_genera_grmp
end type
end forward

global type w_ap906_genera_grmp from w_abc
integer width = 2208
integer height = 964
string title = "(AP906) Genera Guias de Recepción de MP"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
st_7 st_7
sle_origen sle_origen
st_origen st_origen
st_2 st_2
uo_fechas uo_fechas
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_ap906_genera_grmp w_ap906_genera_grmp

event ue_aceptar();// Para actualizar los costos de ultima compra
SetPointer (HourGlass!)
 
string 	ls_mensaje, ls_origen
date 		ld_fecha1, ld_fecha2

ls_origen = sle_origen.text
if ls_origen = '' then
	MessageBox('Error', 'Debe seleccionar un origen')
	sle_origen.setFocus( )
	return
end if

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )
 

//create or replace procedure usp_ap_gen_grmp_rango(
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE,
//       asi_origen    IN origen.cod_origen%TYPE,
//       asi_usr       IN usuario.cod_usr%TYPE
//) IS

DECLARE usp_ap_gen_grmp_rango PROCEDURE FOR
 				usp_ap_gen_grmp_rango( :ld_fecha1,
				 							  :ld_fecha2,
											  :ls_origen,
												:gs_user);
 
EXECUTE usp_ap_gen_grmp_rango;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE usp_ap_gen_grmp_rango: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 SetPointer (Arrow!)
	 RETURN 
END IF

CLOSE usp_ap_gen_grmp_rango;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
 
SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

on w_ap906_genera_grmp.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_origen=create st_origen
this.st_2=create st_2
this.uo_fechas=create uo_fechas
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_origen
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_fechas
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.st_1
end on

on w_ap906_genera_grmp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_origen)
destroy(this.st_2)
destroy(this.uo_fechas)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

type st_7 from statictext within w_ap906_genera_grmp
integer x = 41
integer y = 328
integer width = 370
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_ap906_genera_grmp
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 324
integer width = 352
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )


ls_sql = "SELECT DISTINCT o.cod_origen as codigo_origen, " &
		 + "o.nombre as nombre_origen " &
       + "FROM ap_pd_descarga a, " &
		 + "     ap_pd_descarga_det b, " &
		 + "     (SELECT b1.nro_parte, b1.item " &
		 + "        FROM ap_pd_descarga_det b1 " &
		 + "      MINUS " &
		 + "      SELECT b2.nro_parte, b2.item_parte " &
		 + "        FROM ap_guia_recepcion_det b2) c, " &
		 + "     tg_especies tg, " &
		 + "     origen o " &
		 + "WHERE a.nro_parte = b.nro_parte " &
		 + "  AND to_char(b.inicio_descarga, 'yyyymmdd') BETWEEN '" &
		 +	string(ld_fecha1, 'yyyymmdd') + "' AND '" &
		 +	string(ld_fecha2, 'yyyymmdd') + "' " &
       + "  AND o.cod_origen = a.cod_origen " &
		 + "  AND b.nro_parte  = c.nro_parte " &
		 + "  AND b.item       = c.item " &
		 + "  AND tg.especie   = b.especie "
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
end if

end event

type st_origen from statictext within w_ap906_genera_grmp
integer x = 814
integer y = 324
integer width = 1211
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap906_genera_grmp
integer x = 50
integer y = 176
integer width = 498
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_ap906_genera_grmp
integer x = 562
integer y = 172
integer taborder = 40
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type pb_1 from picturebutton within w_ap906_genera_grmp
integer x = 471
integer y = 520
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_ap906_genera_grmp
integer x = 1138
integer y = 520
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_ap906_genera_grmp
integer x = 55
integer y = 40
integer width = 2071
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Genera GRMP en un rango de Fecha"
alignment alignment = center!
boolean focusrectangle = false
end type

