$PBExportHeader$w_conv_und.srw
$PBExportComments$convierte unidades de acuerdo a tabla
forward
global type w_conv_und from Window
end type
type dw_list from u_dw_list_tbl within w_conv_und
end type
type cb_exit from commandbutton within w_conv_und
end type
type cb_convertir from commandbutton within w_conv_und
end type
type sle_display from singlelineedit within w_conv_und
end type
end forward

global type w_conv_und from Window
int X=439
int Y=456
int Width=722
int Height=848
long BackColor=12639424
WindowType WindowType=popup!
dw_list dw_list
cb_exit cb_exit
cb_convertir cb_convertir
sle_display sle_display
end type
global w_conv_und w_conv_und

type variables
str_calculos istr_calc
string is_num
string is_prevnum
string is_sign
Integer ii_len = 9
Boolean ib_ultsig = False
Dec  idc_factor
end variables

forward prototypes
public function string of_trim (string as_numero)
end prototypes

public function string of_trim (string as_numero);integer	li_len, i, li_dec, li_round

if Pos(as_numero, '.') = 0 then GOTO SALIDA

li_len = Len(as_numero)
FOR i = li_len TO 1 Step -1
	CHOOSE CASE Mid(as_numero, i, 1)
		CASE '0'
			as_numero = Replace(as_numero, i, 1, ' ')
		CASE '.'
			as_numero = Replace(as_numero, i, 1, ' ')
			EXIT
		CASE ELSE
			EXIT
	END CHOOSE
NEXT

as_numero = RightTrim(as_numero)

if Len(as_numero) < ii_len then GOTO SALIDA

li_dec = Pos(as_numero, '.')
if li_dec = 0 then GOTO SALIDA

li_round = 9 - li_dec
as_numero = String(Round(Dec(as_numero), li_round))

SALIDA:

RETURN as_numero

end function

event open;istr_calc = Message.PowerObjectParm
this.y = istr_calc.y
this.x = istr_calc.x

sle_display.text = istr_calc.valor

dw_list.SetTransObject(SQLCA)
dw_list.Retrieve()

end event

on deactivate;close(this)
end on

on w_conv_und.create
this.dw_list=create dw_list
this.cb_exit=create cb_exit
this.cb_convertir=create cb_convertir
this.sle_display=create sle_display
this.Control[]={this.dw_list,&
this.cb_exit,&
this.cb_convertir,&
this.sle_display}
end on

on w_conv_und.destroy
destroy(this.dw_list)
destroy(this.cb_exit)
destroy(this.cb_convertir)
destroy(this.sle_display)
end on

type dw_list from u_dw_list_tbl within w_conv_und
int X=9
int Y=120
int Width=686
int Height=560
int TabOrder=20
string DataObject="d_und_conv"
boolean HScrollBar=false
boolean LiveScroll=false
end type

event ue_output;call super::ue_output;idc_factor = dw_list.GetItemNumber(al_row,'factor_conv')
end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
end event

type cb_exit from commandbutton within w_conv_und
int X=9
int Y=712
int Width=174
int Height=108
int TabOrder=30
string Text="Exit"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(Parent)
end event

type cb_convertir from commandbutton within w_conv_und
int X=288
int Y=712
int Width=407
int Height=108
int TabOrder=20
string Text="Convertir"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String	ls_temp, ls_resultado
Dec		ldc_rc

ls_temp = sle_display.Text

ldc_rc = Dec(ls_temp) * idc_factor

ls_resultado = String(ldc_rc)

ls_resultado = of_trim(ls_resultado)
istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)
end event

type sle_display from singlelineedit within w_conv_und
int X=9
int Y=12
int Width=686
int Height=92
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

