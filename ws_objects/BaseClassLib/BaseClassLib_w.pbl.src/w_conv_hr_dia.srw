$PBExportHeader$w_conv_hr_dia.srw
$PBExportComments$Convierte horas a dias y viceversa
forward
global type w_conv_hr_dia from Window
end type
type cb_exit from commandbutton within w_conv_hr_dia
end type
type cb_hr_dia from commandbutton within w_conv_hr_dia
end type
type cb_dia_hr from commandbutton within w_conv_hr_dia
end type
type sle_display from singlelineedit within w_conv_hr_dia
end type
end forward

global type w_conv_hr_dia from Window
int X=439
int Y=456
int Width=722
int Height=300
long BackColor=12639424
WindowType WindowType=popup!
cb_exit cb_exit
cb_hr_dia cb_hr_dia
cb_dia_hr cb_dia_hr
sle_display sle_display
end type
global w_conv_hr_dia w_conv_hr_dia

type variables
str_calculos istr_calc
string is_num
string is_prevnum
string is_sign
Integer ii_len = 9
Boolean ib_ultsig = False
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
end event

on deactivate;close(this)
end on

on w_conv_hr_dia.create
this.cb_exit=create cb_exit
this.cb_hr_dia=create cb_hr_dia
this.cb_dia_hr=create cb_dia_hr
this.sle_display=create sle_display
this.Control[]={this.cb_exit,&
this.cb_hr_dia,&
this.cb_dia_hr,&
this.sle_display}
end on

on w_conv_hr_dia.destroy
destroy(this.cb_exit)
destroy(this.cb_hr_dia)
destroy(this.cb_dia_hr)
destroy(this.sle_display)
end on

type cb_exit from commandbutton within w_conv_hr_dia
int X=558
int Y=12
int Width=146
int Height=92
int TabOrder=20
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

type cb_hr_dia from commandbutton within w_conv_hr_dia
int X=9
int Y=172
int Width=315
int Height=108
int TabOrder=20
string Text="Hr > Dia"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String	ls_temp, ls_resultado, ls_hr, ls_min
INTEGER	li_2p

ls_temp = sle_display.Text

li_2p = Pos(ls_temp, ':')

IF li_2p > 0 THEN
	ls_hr  = Left(ls_temp, li_2p -1)
	ls_min = Mid(ls_temp, li_2p + 1, 2)
	ls_resultado = String((Dec(ls_hr) + Dec(ls_min)/60)/24)
ELSE
	ls_resultado = String(Dec(ls_temp)/24)
END IF

ls_resultado = of_trim(ls_resultado)
istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)
end event

type cb_dia_hr from commandbutton within w_conv_hr_dia
int X=384
int Y=172
int Width=315
int Height=108
int TabOrder=30
string Text="Hr < Dia"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String	ls_temp, ls_resultado, ls_hr, ls_min, ls_ent, ls_frac
INTEGER	li_2p, li_p
Dec		ldc_frac

ls_temp = String(Dec(sle_display.Text) * 24)

li_p	= Pos(ls_temp, '.')

IF li_p > 0 THEN
	ls_ent  = Left(ls_temp, li_p -1)
	ls_frac = Mid(ls_temp, li_p)
	ldc_frac = Dec(ls_frac)
	ls_resultado = String(Dec(ls_ent)) + ':' + Left(String(ldc_frac * 60),2)
ELSE
	ls_resultado = ls_temp
END IF


ls_resultado = of_trim(ls_resultado)
istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)
end event

type sle_display from singlelineedit within w_conv_hr_dia
int X=9
int Y=12
int Width=526
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

