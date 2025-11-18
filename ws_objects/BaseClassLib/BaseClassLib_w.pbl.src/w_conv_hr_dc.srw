$PBExportHeader$w_conv_hr_dc.srw
$PBExportComments$Convierte horas a decimales y viceversa
forward
global type w_conv_hr_dc from Window
end type
type cb_exit from commandbutton within w_conv_hr_dc
end type
type cb_convertir from commandbutton within w_conv_hr_dc
end type
type sle_display from singlelineedit within w_conv_hr_dc
end type
end forward

global type w_conv_hr_dc from Window
int X=439
int Y=456
int Width=667
int Height=316
long BackColor=12639424
WindowType WindowType=popup!
cb_exit cb_exit
cb_convertir cb_convertir
sle_display sle_display
end type
global w_conv_hr_dc w_conv_hr_dc

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

on w_conv_hr_dc.create
this.cb_exit=create cb_exit
this.cb_convertir=create cb_convertir
this.sle_display=create sle_display
this.Control[]={this.cb_exit,&
this.cb_convertir,&
this.sle_display}
end on

on w_conv_hr_dc.destroy
destroy(this.cb_exit)
destroy(this.cb_convertir)
destroy(this.sle_display)
end on

type cb_exit from commandbutton within w_conv_hr_dc
int X=18
int Y=184
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

type cb_convertir from commandbutton within w_conv_hr_dc
int X=229
int Y=184
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

event clicked;String	ls_temp, ls_resultado, ls_hr, ls_min, ls_ent, ls_frac
INTEGER	li_2p, li_p
Dec		ldc_frac

ls_temp = sle_display.Text

li_2p = Pos(ls_temp, ':')
li_p	= Pos(ls_temp, '.')

IF li_2p > 0 AND li_p = 0 THEN
	ls_hr  = Left(ls_temp, li_2p -1)
	ls_min = Mid(ls_temp, li_2p + 1, 2)
	ls_resultado = String(Dec(ls_hr) + Dec(ls_min)/60)
ELSE
	IF li_p > 0 AND li_2p = 0 THEN
		ls_ent  = Left(ls_temp, li_p -1)
		ls_frac = Mid(ls_temp, li_p)
		ldc_frac = Dec(ls_frac)
//		IF ldc_frac > 59 THEN
//			MessageBox('Error', 'Los minutos estan errados')
//			ls_resultado = ls_temp
//		ELSE
			ls_resultado = String(Dec(ls_ent)) + ':' + Left(String(ldc_frac * 60),2)
//		END IF
	ELSE
		ls_resultado = ls_temp
	END IF
END IF

ls_resultado = of_trim(ls_resultado)
istr_calc.datawindow.SetText(ls_resultado)

Close(Parent)
end event

type sle_display from singlelineedit within w_conv_hr_dc
int X=9
int Y=12
int Width=626
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

