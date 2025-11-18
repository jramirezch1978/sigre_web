$PBExportHeader$n_xls_format_v97.sru
forward
global type n_xls_format_v97 from n_xls_format
end type
end forward

shared variables

end variables

global type n_xls_format_v97 from n_xls_format
end type
global n_xls_format_v97 n_xls_format_v97

type variables
public uint ii_font_index = 0
public int ii_num_format = 0
public blob   ib_num_format
public string is_num_format = ''
public string is_font = 'Arial'
public blob ib_font
public int ii_size = 10
public uint ii_bold = 400
public int ii_italic = 0
public uint ii_color = 32767
public int ii_underline = 0
public int ii_font_strikeout = 0
public int ii_font_outline = 0
public int ii_font_shadow = 0
public int ii_font_script = 0
public int ii_font_family = 0
public int ii_font_charset = 0
public int ii_hidden = 0
public int ii_locked = 1
public int ii_text_h_align = 0
public int ii_text_wrap = 0
public int ii_text_v_align = 2
public int ii_text_justlast = 0
public int ii_rotation = 0
public int ii_fg_color = 64
public int ii_bg_color = 65
public int ii_pattern = 0
public int ii_bottom = 0
public int ii_top = 0
public int ii_left = 0
public int ii_right = 0
public int ii_bottom_color = 64
public int ii_top_color = 64
public int ii_left_color = 64
public int ii_right_color = 64
public int ii_merge_range = 0


end variables

forward prototypes
public function int of_set_font(string AS_FONTNAME)
public function int of_set_font(blob AB_FONTNAME)
public function int of_set_size(int AI_SIZE)
protected function uint of_get_color(string as_color)
public function integer of_set_color (long al_colorindex)
public function integer of_set_color(string AS_COLOR)
public function int of_set_bold(boolean AB_BOLD)
public function int of_set_italic(boolean AB_ITALIC)
public function int of_set_num_format(blob AB_NUM_FORMAT)
public function int of_set_num_format(string AS_NUM_FORMAT)
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
public function blob of_get_font ()
public function string of_get_font_key ()
public function blob of_get_xf (string as_style)
public function int of_set_merge_range()
public function uint of_get_xf_index()
protected function int of_set_text_v_align(uint ai_align)
protected function int of_set_text_h_align(uint ai_align)
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
public function integer of_copy (n_xls_format anvo_format)
public function int of_set_num_format(int ai_builtin_format)
public function string of_get_format_key ()
end prototypes

public function int of_set_font(string AS_FONTNAME);int li_ret = 1
is_font = as_fontname 
ib_font = invo_sub.to_unicode(as_fontname)
return li_ret

end function

public function int of_set_font(blob AB_FONTNAME);int li_ret = 1
ib_font = ab_fontname 
is_font = invo_sub.to_ansi(ab_fontname)
return li_ret

end function

public function int of_set_size(int AI_SIZE);int li_ret = 1
ii_size = ai_size
return li_ret

end function

protected function uint of_get_color(string as_color);choose case trim(lower(as_color))
  case 'aqua'    
         return 15  //0x0F
  case 'cyan'    
         return 15  //0x0F
  case 'black'   
         return 8   //0x08
  case 'blue'    
         return 12  //0x0C
  case 'brown'   
         return 16  //0x10
  case 'magenta' 
         return 14  //0x0E
  case 'fuchsia' 
         return 14  //0x0E
  case 'gray'    
         return 23  //0x17
  case 'grey'    
         return 23  //0x17
  case 'green'   
         return 17  //0x11
  case 'lime'    
         return 11  //0x0B
  case 'navy'    
         return 18  //0x12
  case 'orange'  
         return 53  //0x35
  case 'purple'  
         return 20  //0x14
  case 'red'     
         return 10  //0x0A
  case 'silver'  
         return 22  //0x16
  case 'white'   
         return 9   //0x09
  case 'yellow'  
         return 13  //0x0D
end choose

return 32767 //0x7FFF

end function

public function integer of_set_color (long al_colorindex);int li_ret = 1
if al_colorindex < 8 then al_colorindex += 8
if al_colorindex > 63 then al_colorindex = 32767 //0x7FFF
ii_color = al_colorindex
return li_ret

end function

public function integer of_set_color(string AS_COLOR);int li_ret = 1
 of_set_color(of_get_color(AS_COLOR))
return li_ret

end function

public function int of_set_bold(boolean AB_BOLD);int li_ret = 1
if ab_bold then ii_bold = 700 else ii_bold = 400
return li_ret

end function

public function int of_set_italic(boolean AB_ITALIC);int li_ret = 1
if ab_italic then ii_italic = 1 else ii_italic = 0
return li_ret

end function

public function int of_set_num_format(blob AB_NUM_FORMAT);int li_ret = 1
ib_num_format = ab_num_format
is_num_format = invo_sub.to_ansi(ab_num_format)
ii_num_format = 0
return li_ret
end function

public function int of_set_num_format(string AS_NUM_FORMAT);
int li_ret = 1
ib_num_format = invo_sub.to_unicode(as_num_format)
is_num_format = as_num_format
ii_num_format = 0
return li_ret
end function

public function int of_set_align(string AS_ALIGN);int li_ret = 1
choose case trim(lower(as_align))
   case 'left'              
       of_set_text_h_align(1)
   case 'centre', 'center' 
       of_set_text_h_align(2)
   case 'right'   
       of_set_text_h_align(3)
   case 'fill' 
       of_set_text_h_align(4)
   case 'justify' 
       of_set_text_h_align(5)
   case 'merge' 
       of_set_text_h_align(6)
   case 'equal_space'
       of_set_text_h_align(7)
   case 'top'
       of_set_text_v_align(0)
   case 'vcentre', 'vcenter'
       of_set_text_v_align(1)
   case 'bottom'
       of_set_text_v_align(2)
   case 'vjustify'
       of_set_text_v_align(3)
   case 'vequal_space'
       of_set_text_v_align(4)
   case else 
       return -1
end choose

return li_ret

end function

public function int of_set_text_wrap(boolean AB_TEXT_WRAP);int li_ret = 1
if ab_text_wrap then ii_text_wrap = 1 else ii_text_wrap = 0
return li_ret

end function

public function int of_set_bg_color(string AS_COLOR);int li_ret = 1
 of_set_bg_color(of_get_color(AS_COLOR))
return li_ret

end function

public function int of_set_bg_color(long AL_COLORINDEX);int li_ret = 1
if al_colorindex < 8 then al_colorindex += 8
if al_colorindex > 63 then al_colorindex = 32767 //0x7FFF
ii_bg_color = al_colorindex
return li_ret

end function

public function int of_set_border(int AI_BORDER_STYLE);of_set_left(ai_border_style)
of_set_right(ai_border_style)
of_set_top(ai_border_style)
of_set_bottom(ai_border_style)
return 1

end function

public function int of_set_border_color(long AL_COLOR_INDEX);of_set_left_color(al_color_index)
of_set_right_color(al_color_index)
of_set_top_color(al_color_index)
of_set_bottom_color(al_color_index)
return 1

end function

public function integer of_set_border_color(string AS_COLOR);of_set_left_color(as_color)
of_set_right_color(as_color)
of_set_top_color(as_color)
of_set_bottom_color(as_color)
return 1

end function

public function int of_set_bottom(int AI_BORDER_STYLE);ii_bottom = ai_border_style
return 1

end function

public function int of_set_right(int AI_BORDER_STYLE);ii_right = ai_border_style
return 1

end function

public function int of_set_left(int AI_BORDER_STYLE);ii_left = ai_border_style
return 1

end function

public function int of_set_top(int AI_BORDER_STYLE);ii_top = ai_border_style
return 1

end function

public function int of_set_bottom_color(long AL_COLOR_INDEX);int li_ret = 1
if al_color_index < 8 then al_color_index += 8
if al_color_index > 63 then al_color_index = 32767 //0x7FFF
ii_bottom_color = al_color_index
return li_ret

end function

public function integer of_set_bottom_color(string AS_COLOR);int li_ret = 1
 of_set_bottom_color(of_get_color(AS_COLOR))
return li_ret

end function

public function int of_set_left_color(long AL_COLOR_INDEX);int li_ret = 1
if al_color_index < 8 then al_color_index += 8
if al_color_index > 63 then al_color_index = 32767 //0x7FFF
ii_left_color = al_color_index
return li_ret

end function

public function integer of_set_left_color(string AS_COLOR);int li_ret = 1
 of_set_left_color(of_get_color(AS_COLOR))
return li_ret

end function

public function int of_set_right_color(long AL_COLOR_INDEX);int li_ret = 1
if al_color_index < 8 then al_color_index += 8
if al_color_index > 63 then al_color_index = 32767 //0x7FFF
ii_right_color = al_color_index
return li_ret

end function

public function integer of_set_right_color(string AS_COLOR);int li_ret = 1
 of_set_right_color(of_get_color(AS_COLOR))
return li_ret

end function

public function int of_set_top_color(long AL_COLOR_INDEX);int li_ret = 1
if al_color_index < 8 then al_color_index += 8
if al_color_index > 63 then al_color_index = 32767 //0x7FFF
ii_top_color = al_color_index
return li_ret

end function

public function integer of_set_top_color(string AS_COLOR);int li_ret = 1
 of_set_top_color(of_get_color(AS_COLOR))
return li_ret

end function

public function blob of_get_font ();uint li_record    //Record identifier
uint li_length    //Record length

uint li_dyHeight   // Height of font (1/20 of a point)
uint li_grbit      // Font attributes
uint li_icv        // Index to color palette
uint li_bls        // Bold style
uint li_sss        // Superscript/subscript
uint li_uls        // Underline
uint li_bFamily    // Font family
uint li_bCharSet   // Character set
uint li_reserved   // Reserved
uint li_cch        // Length of font name
//string ls_rgch     // Font name

blob lb_data


li_dyHeight   = ii_size * 20
li_icv        = ii_color
li_bls        = ii_bold
li_sss        = ii_font_script
li_uls        = ii_underline
li_bFamily    = ii_font_family
li_bCharSet   = ii_font_charset
//ls_rgch       = is_font

li_cch        = len(ib_font)/2;
li_record     = 49            //0x31
li_length     = 16 + li_cch*2 //0x0F + li_cch
li_reserved   = 0             //0x00;


li_grbit  = 0                 //0x00
li_grbit +=  ii_italic          *  2
li_grbit +=  ii_font_strikeout  *  8
li_grbit +=  ii_font_outline    * 16
li_grbit +=  ii_font_shadow     * 32

lb_data    = invo_sub.of_pack('v', li_record) +&
             invo_sub.of_pack('v', li_length) +&
             invo_sub.of_pack('v', li_dyHeight) +&
             invo_sub.of_pack('v', li_grbit) +&
             invo_sub.of_pack('v', li_icv) +&
             invo_sub.of_pack('v', li_bls) +&
             invo_sub.of_pack('v', li_sss) +&
             invo_sub.of_pack('C', li_uls) +&
             invo_sub.of_pack('C', li_bFamily) +&
             invo_sub.of_pack('C', li_bCharSet) +&
             invo_sub.of_pack('C', li_reserved) +&
             invo_sub.of_pack('C', li_cch) + /*number of chars*/&
             invo_sub.of_pack('C', 1) + /*unicode option*/&
				 ib_font 

return lb_data

end function

public function string of_get_font_key ();string ls_ret
uint li_pos
//The following elements are arranged to increase the probability of
//generating a unique key. Elements that hold a large range of numbers
//eg. ii_color are placed between two binary elements such as ii_italic
ls_ret = string(len(is_font), '000') +&
         is_font + &
         trim(string(ii_size, '0000')) + &
         trim(string(ii_font_script, '00')) +&
         trim(string(ii_underline, '00')) +&
         trim(string(ii_font_strikeout, '00')) +&
         trim(string(ii_bold, '000')) +&
         trim(string(ii_font_outline, '00')) +&
         trim(string(ii_font_family, '0000')) +&
         trim(string(ii_font_charset, '000000')) +&
         trim(string(ii_font_shadow, '00')) +&
         trim(string(ii_color, '000')) +&
         trim(string(ii_italic, '0')) 
			
li_pos = pos(ls_ret, ' ')
do while li_pos > 0
   ls_ret = replace(ls_ret, li_pos, 1, '_')
   li_pos = pos(ls_ret, ' ')
loop

return ls_ret

end function

public function blob of_get_xf (string as_style);uint li_record    //Record identifier
uint li_length    //Number of bytes to follow

uint li_ifnt       // Index to FONT record
uint li_ifmt       // Index to FORMAT record
uint li_style      // Style and other options
uint li_align      // Alignment
ulong ll_border1   // Fill and border line style 1   
ulong ll_border2   // Fill and border line style 2   
uint li_pcolor      // Pattern colors

uint li_atr_num = 0
uint li_atr_fnt = 0
uint li_atr_alc = 0
uint li_atr_bdr = 0
uint li_atr_pat = 0
uint li_atr_prot= 0

uint li_rotation=0
uint li_grbit8=0
uint li_usedattr=0

blob lb_data

//Set the type of the XF record and some of the attributes
if as_style = 'style' then
   li_style =  65525 //0xFFF5
else
   li_style = ii_locked + ii_hidden * 2
end if

//Flags to indicate if attributes have been set
if ii_num_format <> 0 then li_atr_num = 1

if ii_font_index <> 0 then li_atr_fnt = 1

if (ii_text_h_align <> 0) or &
   (ii_text_v_align <> 2) or &
   (ii_text_wrap    <> 0) then li_atr_alc = 1

if (ii_bottom <> 0) or &
   (ii_top <> 0) or &
   (ii_left <> 0) or &
   (ii_right <> 0) then li_atr_bdr = 1

if (ii_fg_color <>  64) or &
   (ii_bg_color <> 65) or &
   (ii_pattern <> 0) then li_atr_pat = 1

if (ii_hidden <>  0) or &
   (ii_locked <> 1) then li_atr_prot = 1

//Reset the default colours for the non-font properties
if ii_fg_color     =  32767 then ii_fg_color     = 64
if ii_bg_color     =  32767 then ii_bg_color     = 65
if ii_bottom_color =  32767 then ii_bottom_color = 64
if ii_top_color    =  32767 then ii_top_color    = 64
if ii_left_color   =  32767 then ii_left_color   = 64
if ii_right_color  =  32767 then ii_right_color  = 64

//Zero the default border colour if the border has not been set
if ii_bottom = 0 then ii_bottom_color = 0
if ii_top    = 0 then ii_top_color    = 0
if ii_left   = 0 then ii_left_color   = 0
if ii_right  = 0 then ii_right_color  = 0


//The following 2 logical statements take care of special cases in relation
//to cell colours and patterns:
// 1. For a solid fill (ii_pattern == 1) Excel reverses the role of foreground
//    and background colours.
// 2. If the user specifies a foreground or background colour without a
//    pattern they probably wanted a solid fill, so we fill in the defaults.
//
if (ii_pattern <= 1) and &
   (ii_bg_color <> 65) and &
   (ii_fg_color = 64) then
   ii_fg_color = ii_bg_color
   ii_bg_color = 64
   ii_pattern = 1
end if


if (ii_pattern <= 1) and &
   (ii_bg_color = 65) and &
   (ii_fg_color <> 64) then
   ii_bg_color = 64
   ii_pattern = 1
end if

choose case ii_rotation 
  case 0
    li_rotation = 0
  case 1
    li_rotation = 255
  case 2
    li_rotation = 90
  case 3
    li_rotation = 180
end choose

li_ifnt = ii_font_index
li_ifmt = ii_num_format
li_align = ii_text_h_align +&
           ii_text_wrap      * 8 +&
           ii_text_v_align   * 16 +&
           ii_text_justlast  * 128

li_grbit8 = 0       /*Indent level 0-3 bit*/ +&  
            0 * 16  /*Shrink content to fit into cell 4 bit*/ +&
            0 * 64  /*Text direction 7-6 bit*/ 

li_usedattr = li_atr_num       /*Flag for number format*/  +&
              li_atr_fnt  * 2  /*Flag for font*/  +&
              li_atr_alc  * 4  /*Flag for horizontal and 
                              vertical alignment, 
                              text wrap, indentation, 
                              orientation, rotation, 
                              and text direction*/  +&
           li_atr_bdr  * 8  /*Flag for border lines*/  +&
           li_atr_pat  * 16 /*Flag for background area style*/ +&
           li_atr_prot * 32 /*Flag for cell protection 
                              (cell locked and formula hidden)*/

ll_border1 = ii_left                   /*0-3*/   +&
             ii_right        * 16      /*4-7*/   +&  
             ii_top          * 256     /*8-11*/  +&  
             ii_bottom       * 4096    /*12-15*/ +&    
             ii_left_color   * 65536   /*16-22*/ +&  
             ii_right_color  * 8388608 /*23-29*/   

ll_border2 = ii_top_color                 /*0-6*/   +&
             ii_bottom_color * 128        /*7-13*/  +&  
             0               * 16384      /*14-20*/ +&  
             0               * 2097152    /*21-24*/ +&    
             ii_pattern      * 67108864   /*26-31*/ 

li_pcolor =  ii_fg_color + &
             ii_bg_color * 128

li_record =  224 //0x00E0
li_length = 20   //0x0014

lb_data   = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) +&
            invo_sub.of_pack('v', li_ifnt) +&
            invo_sub.of_pack('v', li_ifmt) +&
            invo_sub.of_pack('v', li_style) +&
            invo_sub.of_pack('C', li_align) +&
            invo_sub.of_pack('C', li_rotation) +&
            invo_sub.of_pack('C', li_grbit8) +&
            invo_sub.of_pack('C', li_usedattr * 4) +&
            invo_sub.of_pack('V', ll_border1) +&
            invo_sub.of_pack('V', ll_border2) +&
            invo_sub.of_pack('v', li_pcolor) 

return lb_data

end function

public function int of_set_merge_range();ii_merge_range = 1
return 1

end function

public function uint of_get_xf_index();return ii_xf_index

end function

protected function int of_set_text_v_align(uint ai_align);ii_text_v_align = ai_align
return 1

end function

protected function int of_set_text_h_align(uint ai_align);ii_text_h_align = ai_align
return 1

end function

public function int of_set_underline(int AI_STYLE);ii_underline = ai_style
return 1

end function

public function int of_set_rotation(int ai_rotation);integer li_ret = 1

//0 No rotation
//1 Letters run from top to bottom
//2 90° anticlockwise
//3 90° clockwise

if ((ai_rotation >= 0) and (ai_rotation <= 180)) or (ai_rotation = 255) then
   ii_rotation = ai_rotation
else
   li_ret = -1
end if

return li_ret

   


end function

public function int of_set_script(int ai_script);integer li_ret = 1

// 0  = Normal
// 1  = Superscript
// 2  = Subscript

if (ai_script < 0) or (ai_script > 2) then
   li_ret = -1
else
   ii_font_script = ai_script
end if

return li_ret

   


end function

public function int of_set_outline(boolean ab_option);if ab_option then
   ii_font_outline = 1
else 
   ii_font_outline = 0
end if

return 1
end function

public function int of_set_hidden(boolean ab_option);if ab_option then
   ii_hidden = 1
else 
   ii_hidden = 0
end if

return 1
end function

public function int of_set_locked(boolean ab_option);if ab_option then
   ii_locked = 1
else 
   ii_locked = 0
end if

return 1
end function

public function int of_set_strikeout(boolean ab_option);if ab_option then
   ii_font_strikeout = 1
else 
   ii_font_strikeout = 0
end if

return 1
end function

public function int of_set_text_justlast();ii_text_justlast = 1
return 1
end function

public function int of_set_pattern(int ai_pattern);integer li_ret = 1

if (ai_pattern < 0) or (ai_pattern > 18) then
   li_ret = -1
else
   ii_pattern = ai_pattern
end if

return li_ret

   


end function

public function int of_set_fg_color(string AS_COLOR);return of_set_fg_color(of_get_color(AS_COLOR))

end function

public function int of_set_fg_color(long AL_COLORINDEX);int li_ret = 1
if al_colorindex < 8 then al_colorindex += 8
if al_colorindex > 63 then al_colorindex = 32767 //0x7FFF
ii_fg_color = al_colorindex
return li_ret

end function

public function int of_set_merge();return of_set_text_h_align(6)
end function

public function integer of_copy (n_xls_format anvo_format);n_xls_format_v97 lnvo_format
lnvo_format = anvo_format

this.ii_font_index = lnvo_format.ii_font_index
this.is_num_format = lnvo_format.is_num_format
this.ii_num_format = lnvo_format.ii_num_format
this.ib_num_format = lnvo_format.ib_num_format
this.is_font = lnvo_format.is_font
this.ib_font = lnvo_format.ib_font
this.ii_size = lnvo_format.ii_size
this.ii_bold = lnvo_format.ii_bold
this.ii_italic = lnvo_format.ii_italic
this.ii_color = lnvo_format.ii_color
this.ii_underline = lnvo_format.ii_underline
this.ii_font_strikeout = lnvo_format.ii_font_strikeout
this.ii_font_outline = lnvo_format.ii_font_outline
this.ii_font_shadow = lnvo_format.ii_font_shadow
this.ii_font_script = lnvo_format.ii_font_script
this.ii_font_family = lnvo_format.ii_font_family
this.ii_font_charset = lnvo_format.ii_font_charset
this.ii_hidden = lnvo_format.ii_hidden
this.ii_locked = lnvo_format.ii_locked
this.ii_text_h_align = lnvo_format.ii_text_h_align
this.ii_text_wrap = lnvo_format.ii_text_wrap
this.ii_text_v_align = lnvo_format.ii_text_v_align
this.ii_text_justlast = lnvo_format.ii_text_justlast
this.ii_rotation = lnvo_format.ii_rotation
this.ii_fg_color = lnvo_format.ii_fg_color
this.ii_bg_color = lnvo_format.ii_bg_color
this.ii_pattern = lnvo_format.ii_pattern
this.ii_bottom = lnvo_format.ii_bottom
this.ii_top = lnvo_format.ii_top
this.ii_left = lnvo_format.ii_left
this.ii_right = lnvo_format.ii_right
this.ii_bottom_color = lnvo_format.ii_bottom_color
this.ii_top_color = lnvo_format.ii_top_color
this.ii_left_color = lnvo_format.ii_left_color
this.ii_right_color = lnvo_format.ii_right_color
this.ii_merge_range = lnvo_format.ii_merge_range

return 1
end function

public function int of_set_num_format(int ai_builtin_format);ii_num_format = ai_builtin_format
setnull(ib_num_format)
return 1
end function

public function string of_get_format_key ();string ls_ret
uint li_pos

ls_ret = string(ii_num_format,'00000') +&
         string(len(is_num_format),'000') +&
         is_num_format +&
         string(ii_hidden, '0') +&
         string(ii_locked, '0') +&
         string(ii_text_h_align, '00') +&
         string(ii_text_wrap, '0') +&
         string(ii_text_v_align, '00') +&
         string(ii_text_justlast, '00') +&
         string(ii_rotation, '000') +&
         string(ii_fg_color, '000') +&
         string(ii_bg_color, '000') +&
         string(ii_pattern, '000') +&
         string(ii_bottom, '000') +&
         string(ii_top, '000') +&
         string(ii_left, '000') +&
         string(ii_right, '000') +&
         string(ii_bottom_color, '000') +&
         string(ii_top_color, '000') +&
         string(ii_left_color, '000') +&
         string(ii_right_color, '000') +&
         string(ii_merge_range, '0') +&
			of_get_font_key()

li_pos = pos(ls_ret, ' ')
do while li_pos > 0
   ls_ret = replace(ls_ret, li_pos, 1, '_')
   li_pos = pos(ls_ret, ' ')
loop

return ls_ret

end function

event constructor;call super::constructor;ib_font = invo_sub.to_unicode(is_font)

end event

on n_xls_format_v97.create
TriggerEvent( this, "constructor" )
end on

on n_xls_format_v97.destroy
TriggerEvent( this, "destructor" )
end on

