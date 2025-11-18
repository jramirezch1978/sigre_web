$PBExportHeader$w_com900_prorratear_costo.srw
forward
global type w_com900_prorratear_costo from w_abc
end type
type st_1 from statictext within w_com900_prorratear_costo
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_com900_prorratear_costo
end type
type pb_1 from picturebutton within w_com900_prorratear_costo
end type
type em_descripcion from editmask within w_com900_prorratear_costo
end type
type em_origen from singlelineedit within w_com900_prorratear_costo
end type
type gb_3 from groupbox within w_com900_prorratear_costo
end type
type gb_1 from groupbox within w_com900_prorratear_costo
end type
end forward

global type w_com900_prorratear_costo from w_abc
integer width = 1362
integer height = 1148
string title = "Prorrateo de Costos (COM900)"
string menuname = "m_smpl"
boolean maxbox = false
event ue_aceptar ( )
event ue_cancelar ( )
st_1 st_1
uo_fecha uo_fecha
pb_1 pb_1
em_descripcion em_descripcion
em_origen em_origen
gb_3 gb_3
gb_1 gb_1
end type
global w_com900_prorratear_costo w_com900_prorratear_costo

event ue_aceptar();integer 	li_ok
string 	ls_mensaje, ls_origen
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))
ls_origen		   = em_origen.text

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO')
	return
end if

DECLARE USP_COM_PROCESA_COSTOS_RANGO PROCEDURE FOR
	USP_COM_PROCESA_COSTOS_RANGO( :ls_origen, 
											:ld_fecha_ini, 
											:ld_fecha_fin);

EXECUTE USP_COM_PROCESA_COSTOS_RANGO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_COM_PROCESA_COSTOS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_COM_PROCESA_COSTOS_RANGO INTO :ls_mensaje, :li_ok;
CLOSE USP_COM_PROCESA_COSTOS_RANGO;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE USP_COM_PROCESA_COSTOS_RANGO', ls_mensaje, StopSign!)	
	return
end if

MessageBox('COMEDORES', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)
return

end event

event ue_cancelar();close(this)
end event

on w_com900_prorratear_costo.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_1
end on

on w_com900_prorratear_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//em_ano.text = string( year( today() ) )
end event

event closequery;call super::closequery;// Ancestor Script has been Override

THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

Destroy	im_1

of_close_sheet()

end event

type st_1 from statictext within w_com900_prorratear_costo
integer x = 192
integer y = 332
integer width = 937
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_com900_prorratear_costo
integer x = 311
integer y = 420
integer width = 654
integer height = 220
integer taborder = 50
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type pb_1 from picturebutton within w_com900_prorratear_costo
integer x = 389
integer y = 708
integer width = 457
integer height = 164
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event ue_aceptar()
end event

type em_descripcion from editmask within w_com900_prorratear_costo
integer x = 279
integer y = 164
integer width = 923
integer height = 72
integer taborder = 30
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

type em_origen from singlelineedit within w_com900_prorratear_costo
event dobleclick pbm_lbuttondblclk
integer x = 137
integer y = 164
integer width = 128
integer height = 72
integer taborder = 30
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

type gb_3 from groupbox within w_com900_prorratear_costo
integer x = 78
integer y = 80
integer width = 1157
integer height = 216
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_com900_prorratear_costo
integer x = 14
integer y = 20
integer width = 1280
integer height = 920
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16777215
long backcolor = 67108864
end type

