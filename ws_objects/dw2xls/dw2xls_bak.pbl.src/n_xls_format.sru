$PBExportHeader$n_xls_format.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_format from nonvisualobject
end type
end forward

global type n_xls_format from nonvisualobject
end type
global n_xls_format n_xls_format

type variables
public n_xls_subroutines_v97 invo_sub
public integer ii_xf_index
end variables

forward prototypes
public function integer of_copy (n_xls_format anvo_format)
public function string of_get_format_key ()
public function integer of_set_align (string as_align)
public function integer of_set_bg_color (long al_colorindex)
public function integer of_set_bg_color (string as_color)
public function integer of_set_bold (boolean ab_bold)
public function integer of_set_border (integer ai_border_style)
public function integer of_set_border_color (long al_color_index)
public function integer of_set_border_color (string as_color)
public function integer of_set_bottom (integer ai_border_style)
public function integer of_set_bottom_color (long al_color_index)
public function integer of_set_bottom_color (string as_color)
public function integer of_set_color (long al_colorindex)
public function integer of_set_color (string as_color)
public function integer of_set_fg_color (long al_colorindex)
public function integer of_set_fg_color (string as_color)
public function integer of_set_font (blob ab_fontname)
public function integer of_set_font (string as_fontname)
public function integer of_set_hidden (boolean ab_option)
public function integer of_set_italic (boolean ab_italic)
public function integer of_set_left (integer ai_border_style)
public function integer of_set_left_color (long al_color_index)
public function integer of_set_left_color (string as_color)
public function integer of_set_locked (boolean ab_option)
public function integer of_set_merge ()
public function integer of_set_merge_range ()
public function integer of_set_num_format (blob ab_num_format)
public function integer of_set_num_format (integer ai_builtin_format)
public function integer of_set_num_format (string as_num_format)
public function integer of_set_outline (boolean ab_option)
public function integer of_set_pattern (integer ai_pattern)
public function integer of_set_right (integer ai_border_style)
public function integer of_set_right_color (long al_color_index)
public function integer of_set_right_color (string as_color)
public function integer of_set_rotation (integer ai_rotation)
public function integer of_set_script (integer ai_script)
public function integer of_set_size (integer ai_size)
public function integer of_set_strikeout (boolean ab_option)
public function integer of_set_text_justlast ()
public function integer of_set_text_wrap (boolean ab_text_wrap)
public function integer of_set_top (integer ai_border_style)
public function integer of_set_top_color (long al_color_index)
public function integer of_set_top_color (string as_color)
public function integer of_set_underline (integer ai_style)
end prototypes

public function integer of_copy (n_xls_format anvo_format);integer retvar

return retvar
end function

public function string of_get_format_key ();return ""
end function

public function integer of_set_align (string as_align);integer retvar

return retvar
end function

public function integer of_set_bg_color (long al_colorindex);integer retvar

return retvar
end function

public function integer of_set_bg_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_bold (boolean ab_bold);integer retvar

return retvar
end function

public function integer of_set_border (integer ai_border_style);integer retvar

return retvar
end function

public function integer of_set_border_color (long al_color_index);integer retvar

return retvar
end function

public function integer of_set_border_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_bottom (integer ai_border_style);integer retvar

return retvar
end function

public function integer of_set_bottom_color (long al_color_index);integer retvar

return retvar
end function

public function integer of_set_bottom_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_color (long al_colorindex);integer retvar

return retvar
end function

public function integer of_set_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_fg_color (long al_colorindex);integer retvar

return retvar
end function

public function integer of_set_fg_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_font (blob ab_fontname);return of_set_font(invo_sub.to_ansi(ab_fontname))
end function

public function integer of_set_font (string as_fontname);integer retvar

return retvar
end function

public function integer of_set_hidden (boolean ab_option);integer retvar

return retvar
end function

public function integer of_set_italic (boolean ab_italic);integer retvar

return retvar
end function

public function integer of_set_left (integer ai_border_style);integer retvar

return retvar
end function

public function integer of_set_left_color (long al_color_index);integer retvar

return retvar
end function

public function integer of_set_left_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_locked (boolean ab_option);integer retvar

return retvar
end function

public function integer of_set_merge ();integer retvar

return retvar
end function

public function integer of_set_merge_range ();return 1
end function

public function integer of_set_num_format (blob ab_num_format);return of_set_num_format(invo_sub.to_ansi(ab_num_format))
end function

public function integer of_set_num_format (integer ai_builtin_format);integer retvar

return retvar
end function

public function integer of_set_num_format (string as_num_format);integer retvar

return retvar
end function

public function integer of_set_outline (boolean ab_option);integer retvar

return retvar
end function

public function integer of_set_pattern (integer ai_pattern);integer retvar

return retvar
end function

public function integer of_set_right (integer ai_border_style);integer retvar

return retvar
end function

public function integer of_set_right_color (long al_color_index);integer retvar

return retvar
end function

public function integer of_set_right_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_rotation (integer ai_rotation);integer retvar

return retvar
end function

public function integer of_set_script (integer ai_script);integer retvar

return retvar
end function

public function integer of_set_size (integer ai_size);integer retvar

return retvar
end function

public function integer of_set_strikeout (boolean ab_option);integer retvar

return retvar
end function

public function integer of_set_text_justlast ();integer retvar

return retvar
end function

public function integer of_set_text_wrap (boolean ab_text_wrap);integer retvar

return retvar
end function

public function integer of_set_top (integer ai_border_style);integer retvar

return retvar
end function

public function integer of_set_top_color (long al_color_index);integer retvar

return retvar
end function

public function integer of_set_top_color (string as_color);integer retvar

return retvar
end function

public function integer of_set_underline (integer ai_style);integer retvar

return retvar
end function

event constructor;invo_sub = create n_xls_subroutines_v97
return
end event

on n_xls_format.create
call super::create;

triggerevent("constructor")
end on

on n_xls_format.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;destroy(invo_sub)
return
end event

