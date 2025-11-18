$PBExportHeader$w_al900_act_prec_prom_art_all.srw
forward
global type w_al900_act_prec_prom_art_all from w_base
end type
type rb_5 from radiobutton within w_al900_act_prec_prom_art_all
end type
type st_2 from statictext within w_al900_act_prec_prom_art_all
end type
type uo_fecha from u_ingreso_fecha within w_al900_act_prec_prom_art_all
end type
type rb_4 from radiobutton within w_al900_act_prec_prom_art_all
end type
type sle_articulo from singlelineedit within w_al900_act_prec_prom_art_all
end type
type rb_3 from radiobutton within w_al900_act_prec_prom_art_all
end type
type rb_2 from radiobutton within w_al900_act_prec_prom_art_all
end type
type rb_1 from radiobutton within w_al900_act_prec_prom_art_all
end type
type st_1 from statictext within w_al900_act_prec_prom_art_all
end type
type pb_2 from picturebutton within w_al900_act_prec_prom_art_all
end type
type pb_1 from picturebutton within w_al900_act_prec_prom_art_all
end type
type hpb_1 from hprogressbar within w_al900_act_prec_prom_art_all
end type
end forward

global type w_al900_act_prec_prom_art_all from w_base
integer width = 2007
integer height = 1212
string title = "Recalculo del precio promedio (AL900)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
rb_5 rb_5
st_2 st_2
uo_fecha uo_fecha
rb_4 rb_4
sle_articulo sle_articulo
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
st_1 st_1
pb_2 pb_2
pb_1 pb_1
hpb_1 hpb_1
end type
global w_al900_act_prec_prom_art_all w_al900_act_prec_prom_art_all

forward prototypes
public function boolean of_reproc_art (string as_cod_art)
public subroutine of_opcion2 ()
public subroutine of_opcion1 ()
public subroutine of_opcion3 ()
public subroutine of_opcion4 ()
public subroutine of_opcion5 ()
end prototypes

event ue_aceptar();SetPointer (HourGlass!)

if rb_1.checked then
	this.of_opcion1()
elseif rb_2.checked then
	this.of_opcion2()
elseif rb_3.checked then
	this.of_opcion3()
elseif rb_4.checked then
	this.of_opcion4()
elseif rb_5.checked then

	this.of_opcion5()
end if

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public function boolean of_reproc_art (string as_cod_art);string  	ls_mensaje
integer 	li_ok
date 		ld_fecha

ld_fecha = uo_fecha.of_get_fecha()

// Calcula el precio Promedio del Articulo x Almacen
// Revaloriza los movimientos de almacen desde una determinada fecha

//CREATE OR REPLACE PROCEDURE usp_alm_act_valor_x_art_alm(
//       asi_cod_art          in  articulo.cod_art%TYPE,
//       adi_fecha            in  date,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_valor_x_art_alm PROCEDURE FOR
	usp_alm_act_valor_x_art_alm( :as_cod_art, :ld_fecha );

EXECUTE usp_alm_act_valor_x_art_alm;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_valor_x_art_alm:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH usp_alm_act_valor_x_art_alm INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_valor_x_art_alm;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso usp_alm_act_valor_x_art_alm', ls_mensaje)
	return false
end if

// Calcula el precio Promedio del Articulo en General
// No hace reemplazo en ningun Movimiento de Almacen

//CREATE OR REPLACE PROCEDURE usp_alm_act_valor_x_art(
//       asi_cod_art          in  articulo.cod_art%TYPE,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_valor_x_art PROCEDURE FOR
	usp_alm_act_valor_x_art( :as_cod_art );

EXECUTE usp_alm_act_valor_x_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_valor_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH usp_alm_act_valor_x_art INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_valor_x_art;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso usp_alm_act_valor_x_art', ls_mensaje)
	return false
end if
return true
end function

public subroutine of_opcion2 ();string ls_codigo, ls_mensaje
Long ll_count, ll_max

SELECT count(*)
	into :ll_max
    FROM ARTICULO  
WHERE FLAG_ESTADO = '1' 
  AND NVL(FLAG_INVENTARIABLE, '0') = '1'
  and sldo_total > 0
  and costo_prom_sol = 0;

hpb_1.MaxPosition = ll_max

// recorrido de los articulos
 DECLARE c_articulos CURSOR FOR  
  SELECT COD_ART  
    FROM ARTICULO  
	WHERE FLAG_ESTADO = '1' 
	  AND NVL(FLAG_INVENTARIABLE, '0') = '1'
	  and sldo_total > 0
	  and costo_prom_sol = 0;

open c_articulos;

fetch c_articulos into :ls_codigo;

ll_count = 0
do while SQLCA.SQLCode <> 100 
	if SQLCA.SQlCode = -1 then
		ls_mensaje =SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return
	end if
	ll_count ++
	hpb_1.Position = ll_count
	if of_reproc_art (ls_codigo) = false then
		ROLLBACK;
		return
	end if
	st_2.text = string(ll_count) + ' / ' + string(ll_max)
	fetch c_articulos into :ls_codigo;
loop

close c_articulos;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')
end subroutine

public subroutine of_opcion1 ();string ls_codigo, ls_mensaje
Long ll_count, ll_max

SELECT count(*)
	into :ll_max
    FROM ARTICULO  
WHERE FLAG_ESTADO = '1' 
  AND NVL(FLAG_INVENTARIABLE,'0') = '1';

hpb_1.MaxPosition = ll_max

// recorrido de los articulos
 DECLARE c_articulos CURSOR FOR  
  SELECT COD_ART  
    FROM ARTICULO  
   WHERE FLAG_ESTADO = '1' 
	  AND NVL(FLAG_INVENTARIABLE, '0') = '1';

open c_articulos;

fetch c_articulos into :ls_codigo;

ll_count = 0
do while SQLCA.SQLCode <> 100 
	if SQLCA.SQlCode = -1 then
		ls_mensaje =SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return
	end if
	ll_count ++
	hpb_1.Position = ll_count
	if of_reproc_art (ls_codigo) = false then
		ROLLBACK;
		return
	end if
	st_2.text = string(ll_count) + ' / ' + string(ll_max)
	fetch c_articulos into :ls_codigo;
loop

close c_articulos;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')
end subroutine

public subroutine of_opcion3 ();string ls_codigo, ls_mensaje
Long ll_count, ll_max

SELECT count(*)
	into :ll_max
    FROM ARTICULO  
WHERE FLAG_ESTADO = '1' 
  AND NVL(FLAG_INVENTARIABLE, '0') = '1'
  and cod_art in (select distinct a.cod_art 
  					   from articulo_mov a,
						  	  vale_mov		b
						where a.nro_vale 		= b.nro_vale
						  and a.cod_origen 	= b.cod_origen
						  and a.flag_estado 	<> '0'
						  and b.flag_estado 	<> '0');

hpb_1.MaxPosition = ll_max

// recorrido de los articulos
 DECLARE c_articulos CURSOR FOR  
  SELECT COD_ART  
    FROM ARTICULO  
	WHERE FLAG_ESTADO = '1' 
	  AND NVL(FLAG_INVENTARIABLE, '0') = '1'
	  and cod_art in (select distinct a.cod_art 
							from articulo_mov a,
								  vale_mov		b
							where a.nro_vale 		= b.nro_vale
							  and a.cod_origen 	= b.cod_origen
							  and a.flag_estado 	<> '0'
							  and b.flag_estado 	<> '0');
							  
open c_articulos;

fetch c_articulos into :ls_codigo;

ll_count = 0
do while SQLCA.SQLCode <> 100 
	if SQLCA.SQlCode = -1 then
		ls_mensaje =SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return
	end if
	
	ll_count ++
	hpb_1.Position = ll_count
	if of_reproc_art (ls_codigo) = false then
		ROLLBACK;
		return
	end if
	
	fetch c_articulos into :ls_codigo;
	st_2.text = string(ll_count) + ' / ' + string(ll_max)	+ ' SQLCA.SQLCode: ' + string(SQLCA.SQLCode)
	
loop

Close c_articulos;
MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')
end subroutine

public subroutine of_opcion4 ();string ls_codigo
Long ll_count

ls_codigo = sle_articulo.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe definir Codigo de Articulo')
	return
end if

hpb_1.Position = 0

if of_reproc_art (ls_codigo) = false then
	ROLLBACK;
	return
end if

MessageBox('Aviso', 'Proceso Ejecutado Satisfactoriamente', Exclamation!)

end subroutine

public subroutine of_opcion5 ();string ls_codigo, ls_mensaje
Long ll_count, ll_max

						  
 select Count(distinct(am.cod_art)) into :ll_max
   from tt_alm_mv_prec_unit a ,articulo_mov am,
        vale_mov            vm,articulo     ar
  where vm.nro_vale   = am.nro_vale   and
        vm.cod_origen = am.cod_origen and
		  am.nro_mov    = a.nro_mov     and
		  am.cod_origen = a.cod_origen  and
		  ar.cod_art    = am.cod_art    ;						  
						  

hpb_1.MaxPosition = ll_max

// recorrido de los articulos
DECLARE c_articulos CURSOR FOR  
 select distinct(am.cod_art)
   from tt_alm_mv_prec_unit a ,articulo_mov am,
        vale_mov            vm,articulo     ar
  where vm.nro_vale   = am.nro_vale   and
        vm.cod_origen = am.cod_origen and
		  am.nro_mov    = a.nro_mov     and
		  am.cod_origen = a.cod_origen  and
		  ar.cod_art    = am.cod_art    ;						  
						  
OPEN c_articulos;

FETCH c_articulos INTO :ls_codigo;

ll_count = 0

do while SQLCA.SQLCode <> 100 
	if SQLCA.SQlCode = -1 then
		ls_mensaje =SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return
	end if
	
	ll_count ++
	hpb_1.Position = ll_count
	
	if of_reproc_art (ls_codigo) = false then
		ROLLBACK;
		return
	end if
	
	fetch c_articulos into :ls_codigo;
	st_2.text = string(ll_count) + ' / ' + string(ll_max)	+ ' SQLCA.SQLCode: ' + string(SQLCA.SQLCode)
	
loop

Close c_articulos;
MessageBox('Aviso', 'Proceso ha sido Ejecutado satisfactoriamente')
end subroutine

on w_al900_act_prec_prom_art_all.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.rb_5=create rb_5
this.st_2=create st_2
this.uo_fecha=create uo_fecha
this.rb_4=create rb_4
this.sle_articulo=create sle_articulo
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.hpb_1=create hpb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_5
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.sle_articulo
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.hpb_1
end on

on w_al900_act_prec_prom_art_all.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_5)
destroy(this.st_2)
destroy(this.uo_fecha)
destroy(this.rb_4)
destroy(this.sle_articulo)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.hpb_1)
end on

event ue_open_pre;call super::ue_open_pre;


end event

type p_pie from w_base`p_pie within w_al900_act_prec_prom_art_all
end type

type ole_skin from w_base`ole_skin within w_al900_act_prec_prom_art_all
end type

type rb_5 from radiobutton within w_al900_act_prec_prom_art_all
integer x = 302
integer y = 508
integer width = 1362
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Articulos Por Reporte"
end type

type st_2 from statictext within w_al900_act_prec_prom_art_all
integer x = 1422
integer y = 616
integer width = 498
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_fecha within w_al900_act_prec_prom_art_all
integer x = 1175
integer y = 140
integer taborder = 20
long backcolor = 1073741824
end type

event constructor;call super::constructor;string ls_fecha

ls_fecha = '01/01/' + string(year(Today()))

of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date(ls_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type rb_4 from radiobutton within w_al900_act_prec_prom_art_all
integer x = 302
integer y = 408
integer width = 512
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Un Solo Articulo"
end type

event clicked;sle_Articulo.enabled = true
end event

type sle_articulo from singlelineedit within w_al900_act_prec_prom_art_all
event ue_dobleclick pbm_lbuttondblclk
integer x = 832
integer y = 404
integer width = 439
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;str_parametros sl_param

OpenWithParm (w_pop_articulos, parent)
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' then
	this.text = sl_param.field_ret[1]
END IF
end event

type rb_3 from radiobutton within w_al900_act_prec_prom_art_all
integer x = 297
integer y = 316
integer width = 1362
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Solo Articulos con movimiento"
end type

type rb_2 from radiobutton within w_al900_act_prec_prom_art_all
integer x = 297
integer y = 232
integer width = 1362
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Solo precio promedio = 0 y tengan saldo"
end type

type rb_1 from radiobutton within w_al900_act_prec_prom_art_all
integer x = 297
integer y = 148
integer width = 581
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Todos los articulos"
boolean checked = true
end type

type st_1 from statictext within w_al900_act_prec_prom_art_all
integer x = 46
integer y = 16
integer width = 1883
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
string text = "Recalculo de Precio Promedio"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al900_act_prec_prom_art_all
integer x = 1079
integer y = 804
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al900_act_prec_prom_art_all
integer x = 704
integer y = 804
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
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type hpb_1 from hprogressbar within w_al900_act_prec_prom_art_all
integer x = 46
integer y = 696
integer width = 1883
integer height = 64
integer setstep = 1
end type

