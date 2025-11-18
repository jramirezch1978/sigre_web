$PBExportHeader$n_dwr_sub.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_sub from nonvisualobject
end type
end forward

global type n_dwr_sub from nonvisualobject
end type
global n_dwr_sub n_dwr_sub

type prototypes
public function ulong gettemppath (ulong nbufferlength,ref string lpbuffer)  library "KERNEL32.DLL" alias for "GetTempPathA"
public function uint getdc (uint hw)  library "User32" alias for "GetDC"
public function uint releasedc (uint hw,uint hdc)  library "User32" alias for "ReleaseDC"
public function long getdevicecaps (long hdc,long icapability)  library "Gdi32" alias for "GetDeviceCaps"
end prototypes

type variables
public double id_x_coef_0 = 32
public double id_y_coef_0 = 5.1
public double id_x_coef_1
public double id_x_coef_2
public double id_x_coef_3
public double id_y_coef_1
public double id_y_coef_2
public double id_y_coef_3
public double id_cur_x_coef
public double id_cur_y_coef
end variables

forward prototypes
public function double of_get_coef_x (integer a_units)
public function double of_get_coef_y (integer a_units)
public function double of_get_conv_x ()
public function double of_get_conv_y ()
public function double of_get_cur_coef_x ()
public function double of_get_cur_coef_y ()
public function string of_gettemppath ()
public subroutine of_set_cur_units (integer ai_units)
end prototypes

public function double of_get_coef_x (integer a_units);choose case a_units
	case 0
		return id_x_coef_0
	case 1
		return id_x_coef_1
	case 2
		return id_x_coef_2
	case 3
		return id_x_coef_3
	case else
		return id_x_coef_0
end choose
end function

public function double of_get_coef_y (integer a_units);choose case a_units
	case 0
		return id_y_coef_0
	case 1
		return id_y_coef_1
	case 2
		return id_y_coef_2
	case 3
		return id_y_coef_3
	case else
		return id_y_coef_0
end choose
end function

public function double of_get_conv_x ();return (of_get_cur_coef_x() / of_get_coef_x(0))
end function

public function double of_get_conv_y ();return (of_get_coef_y(0) / of_get_cur_coef_y())
end function

public function double of_get_cur_coef_x ();return id_cur_x_coef
end function

public function double of_get_cur_coef_y ();return id_cur_y_coef
end function

public function string of_gettemppath ();string ls_path
ulong ls_len
ulong ls_buff_size = 200

ls_path = space(ls_buff_size)
ls_len = gettemppath(ls_buff_size,ls_path)

if ls_len > 0 then
	return ""
else
	return ""
end if
end function

public subroutine of_set_cur_units (integer ai_units);id_cur_x_coef = of_get_coef_x(ai_units)
id_cur_y_coef = of_get_coef_y(ai_units)
end subroutine

event constructor;uint li_hdc
long lci_logpixelsx = 88
long lci_logpixelsy = 90
long ll_pixelsperinchx
long ll_pixelsperinchy

li_hdc = getdc(0)
ll_pixelsperinchx = getdevicecaps(li_hdc,88)
ll_pixelsperinchy = getdevicecaps(li_hdc,90)
li_hdc = releasedc(0,li_hdc)

if ll_pixelsperinchx = 0 then
	ll_pixelsperinchx = 96
end if

if ll_pixelsperinchy = 0 then
	ll_pixelsperinchy = 96
end if

id_x_coef_1 = (id_x_coef_0 * unitstopixels(100,xunitstopixels!)) / 100
id_x_coef_2 = (1000 * id_x_coef_1) / ll_pixelsperinchx
id_x_coef_3 = id_x_coef_2 * 2.54
id_y_coef_1 = (id_y_coef_0 * unitstopixels(100,yunitstopixels!)) / 100
id_y_coef_2 = (1000 * id_y_coef_1) / ll_pixelsperinchy
id_y_coef_3 = id_y_coef_2 * 2.54
return
end event

on n_dwr_sub.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_sub.destroy
triggerevent("destructor")
call super::destroy
end on

