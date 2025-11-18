$PBExportHeader$n_xls_format.sru
$PBExportComments$C:\some\excel\builder\n_xls_format.sru
forward
global type n_xls_format from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_format from nonvisualobject
end type
global n_xls_format n_xls_format

type variables
public n_xls_subroutines_v97 invo_sub
integer ii_xf_index = 0

end variables

forward prototypes
public function int of_set_font(string AS_FONTNAME)
public function int of_set_font(blob AB_FONTNAME)
public function int of_set_size(int AI_SIZE)
public function int of_set_color(long AL_COLORINDEX)
public function integer of_set_color(string AS_COLOR)
public function int of_set_bold(boolean AB_BOLD)
public function int of_set_italic(boolean AB_ITALIC)
public function int of_set_num_format(int ai_builtin_format)
public function int of_set_num_format(string AS_NUM_FORMAT)
public function int of_set_num_format(blob AB_NUM_FORMAT)
public function int of_set_align(string AS_ALIGN)
public function int of_set_text_wrap(boolean AB_TEXT_WRAP)
public function int of_set_bg_color(string AS_COLOR)
public function int of_set_bg_color(long AL_COLORINDEX)
public function int of_set_border(int AI_BORDER_STYLE)
public function int of_set_border_color(long AL_COLOR_INDEX)
public function integer of_set_border_color(string AS_COLOR)
public function int of_set_bottom(int AI_BORDER_STYLE)
public function int of_set_right(int AI_BORDER_STYLE)
public function int of_set_left(int AI_BORDER_STYLE)
public function int of_set_top(int AI_BORDER_STYLE)
public function int of_set_bottom_color(long AL_COLOR_INDEX)
public function integer of_set_bottom_color(string AS_COLOR)
public function int of_set_left_color(long AL_COLOR_INDEX)
public function integer of_set_left_color(string AS_COLOR)
public function int of_set_right_color(long AL_COLOR_INDEX)
public function integer of_set_right_color(string AS_COLOR)
public function int of_set_top_color(long AL_COLOR_INDEX)
public function integer of_set_top_color(string AS_COLOR)
public function int of_set_underline(int AI_STYLE)
public function int of_set_rotation(int ai_rotation)
public function int of_set_script(int ai_script)
public function int of_set_outline(boolean ab_option)
public function int of_set_hidden(boolean ab_option)
public function int of_set_locked(boolean ab_option)
public function int of_set_strikeout(boolean ab_option)
public function int of_set_text_justlast()
public function int of_set_pattern(int ai_pattern)
public function int of_set_fg_color(string AS_COLOR)
public function int of_set_fg_color(long AL_COLORINDEX)
public function int of_set_merge()
public function int of_copy(n_xls_format anvo_format)
public function string of_get_format_key ()
end prototypes

public function int of_set_font(string AS_FONTNAME);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_font(blob AB_FONTNAME);
   return of_set_font(invo_sub.to_ansi(AB_FONTNAME))
end function

public function int of_set_size(int AI_SIZE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_color(long AL_COLORINDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_bold(boolean AB_BOLD);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_italic(boolean AB_ITALIC);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_num_format(int ai_builtin_format);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_num_format(string AS_NUM_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_num_format(blob AB_NUM_FORMAT);
   return of_set_num_format(invo_sub.to_ansi(AB_NUM_FORMAT))
end function

public function int of_set_align(string AS_ALIGN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_text_wrap(boolean AB_TEXT_WRAP);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_bg_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_bg_color(long AL_COLORINDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_border(int AI_BORDER_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_border_color(long AL_COLOR_INDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_border_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_bottom(int AI_BORDER_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_right(int AI_BORDER_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_left(int AI_BORDER_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_top(int AI_BORDER_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_bottom_color(long AL_COLOR_INDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_bottom_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_left_color(long AL_COLOR_INDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_left_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_right_color(long AL_COLOR_INDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_right_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_top_color(long AL_COLOR_INDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_top_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_underline(int AI_STYLE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_rotation(int ai_rotation);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_script(int ai_script);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_outline(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_hidden(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_locked(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_strikeout(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_text_justlast();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_pattern(int ai_pattern);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_fg_color(string AS_COLOR);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_fg_color(long AL_COLORINDEX);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_merge();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_copy(n_xls_format anvo_format);   // Generated default script
   int retVar;
   return retVar;
end function

public function string of_get_format_key ();return ''
end function

on n_xls_format.create
TriggerEvent( this, "constructor" )
end on

on n_xls_format.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;invo_sub = create n_xls_subroutines_v97
end event

event destructor;destroy invo_sub
end event

