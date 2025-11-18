$PBExportHeader$w_al904_act_saldo_consignacion.srw
forward
global type w_al904_act_saldo_consignacion from w_abc
end type
type sle_articulo from singlelineedit within w_al904_act_saldo_consignacion
end type
type rb_4 from radiobutton within w_al904_act_saldo_consignacion
end type
type rb_1 from radiobutton within w_al904_act_saldo_consignacion
end type
type st_1 from statictext within w_al904_act_saldo_consignacion
end type
type pb_2 from picturebutton within w_al904_act_saldo_consignacion
end type
type pb_1 from picturebutton within w_al904_act_saldo_consignacion
end type
end forward

global type w_al904_act_saldo_consignacion from w_abc
integer width = 2007
integer height = 804
string title = "Regenera Saldo Consignacion de Articulos (AL904)"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
sle_articulo sle_articulo
rb_4 rb_4
rb_1 rb_1
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al904_act_saldo_consignacion w_al904_act_saldo_consignacion

forward prototypes
public function boolean of_reproc_art (string as_cod_art)
public subroutine of_opcion1 ()
public subroutine of_opcion4 ()
end prototypes

event ue_aceptar();SetPointer (HourGlass!)

if rb_1.checked then
	this.of_opcion1()
elseif rb_4.checked then
	this.of_opcion4()
end if

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public function boolean of_reproc_art (string as_cod_art);string  ls_mensaje
integer li_ok

//create or replace procedure usp_alm_saldo_consig_x_art(
//       asi_cod_art   in articulo.cod_art%TYPE
//)is

DECLARE usp_alm_saldo_consig_x_art PROCEDURE FOR
	usp_alm_saldo_consig_x_art( :as_cod_art );

EXECUTE usp_alm_saldo_consig_x_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_saldo_consig_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE usp_alm_saldo_consig_x_art;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return false
end if
return true
end function

public subroutine of_opcion1 ();string 	ls_mensaje, ls_null

//create or replace procedure usp_alm_act_saldo_consig(
//       asi_nada   in string
//)is

DECLARE usp_alm_act_saldo_consig PROCEDURE FOR
	usp_alm_act_saldo_consig( :ls_null );

EXECUTE usp_alm_act_saldo_consig;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_consig: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE usp_alm_act_saldo_consig;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente', Exclamation!)
end subroutine

public subroutine of_opcion4 ();string ls_codigo, ls_mensaje
Long ll_count

ls_codigo = sle_articulo.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe definir Codigo de Articulo')
	return
end if

update articulo
	set SLDO_CONSIGNACION = 0
where cod_Art = :ls_codigo;

IF SQLCA.SQLCode <> 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return
end if

commit;

if of_reproc_art (ls_codigo) = false then
	ROLLBACK;
	return
end if

MessageBox('Aviso', 'Proceso Ejecutado Satisfactoriamente', Exclamation!)

end subroutine

on w_al904_act_saldo_consignacion.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.sle_articulo=create sle_articulo
this.rb_4=create rb_4
this.rb_1=create rb_1
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_articulo
this.Control[iCurrent+2]=this.rb_4
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_1
end on

on w_al904_act_saldo_consignacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_articulo)
destroy(this.rb_4)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type sle_articulo from singlelineedit within w_al904_act_saldo_consignacion
event ue_dobleclick pbm_lbuttondblclk
integer x = 832
integer y = 264
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

event ue_dobleclick;Str_articulo lstr_articulo

lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )

if lstr_articulo.b_Return then
	this.text = lstr_articulo.cod_art
end if
end event

type rb_4 from radiobutton within w_al904_act_saldo_consignacion
integer x = 302
integer y = 268
integer width = 512
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Un Solo Articulo"
end type

event clicked;sle_Articulo.enabled = true
end event

type rb_1 from radiobutton within w_al904_act_saldo_consignacion
integer x = 302
integer y = 148
integer width = 933
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los articulos"
boolean checked = true
end type

event clicked;sle_Articulo.enabled = false
end event

type st_1 from statictext within w_al904_act_saldo_consignacion
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
long backcolor = 67108864
string text = "Regenera el Saldo de consignacion"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al904_act_saldo_consignacion
integer x = 1079
integer y = 412
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
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al904_act_saldo_consignacion
integer x = 704
integer y = 412
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
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

