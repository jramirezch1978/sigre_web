$PBExportHeader$n_dwr_field.sru
forward
global type n_dwr_field from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_field from nonvisualobject
end type
global n_dwr_field n_dwr_field

type variables
public int ii_dwo_type
public string is_dwo_name
public string is_coltype
public integer ii_colsize
public long il_xsplit_ind_from
public long il_xsplit_ind_to
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public long il_base_x = 0
public long il_base_y = 0
private long il_cached_y1 = -1
private long il_cached_x1 = -1
private long il_cached_y2 = -1
private long il_cached_x2 = -1
public string is_text

//public datawindow idw_dw
public powerobject ipo_requestor
private object ipo_requestortype
private DataWindow idw_requestor
private DataStore ids_requestor
private DataWindowChild idwc_requestor

private int ii_column_display_type
public n_xls_format invo_format;

 public n_xls_workbook invo_writer;

 public n_dwr_colors invo_colors;

boolean ib_color_expr = false
boolean ib_bg_color_expr = false
boolean ib_format_expr = false
boolean ib_font_face_expr = false
boolean ib_font_height_expr = false
boolean ib_font_italic_expr = false
boolean ib_font_underline_expr = false
boolean ib_font_weight_expr = false
boolean ib_alignment_expr = false

string is_text_expr = ''
string is_color_expr = ''
string is_bg_color_expr = ''
string is_format_expr = ''
string is_font_face_expr = ''
string is_font_height_expr = ''
string is_font_italic_expr = ''
string is_font_underline_expr = ''
string is_font_weight_expr = ''
string is_alignment_expr = ''


boolean ib_custom_format = false
integer ii_row_in_detail = 1
long il_dw_row_count
private boolean ib_usetrc = false

private n_dwr_service_base inv_nestedservice
private n_dwr_nested_service_parm inv_nested_service_parm
private DataStore ids_reportdata
private DataWindowChild idwc_child_cache
private long il_child_cache_row = -1


//column display type
public constant int CDT_TEXT = 1
public constant int CDT_CHECKBOX = 2
public constant int CDT_DDDW = 3
public constant int CDT_DDLB = 4
public constant int CDT_CODETABLE = 5
public constant int CDT_REPORT = 6

//dwo type
public constant int DT_COLUMN = 1
public constant int DT_COMPUTE = 2
public constant int DT_TEXT = 3
public constant int DT_REPORT = 4

end variables

forward prototypes
public function any of_getvalue (long al_row)
public function integer of_setformat ()
public function long of_get_x1 ()
public function long of_get_y1 (long al_row)
public function long of_get_y2 (long al_row)
public function long of_get_y1 ()
public function integer of_get_visible (long al_row)
public function long of_get_y2 ()
public function string of_get_item_coltype ()
public function long of_describe_expr (string as_expr, long al_row)
private function string of_unquote(string AS_STR)
public function string of_change_format (ref string as_format, string as_type)
private function integer of_get_column_display_type ()
public function n_xls_format of_get_format (long al_row)
public function integer of_set_color (n_xls_format a_format, long al_row)
public function integer of_set_bg_color (n_xls_format a_format, long al_row)
public function integer of_check_property (string as_property_name, ref boolean ab_is_expression, ref string as_expression, ref string as_value)
public function string of_descr_numformat ()
public function string of_descr_font_face ()
public function long of_descr_font_height ()
public function boolean of_descr_font_italic ()
public function integer of_descr_font_underline ()
public function boolean of_descr_font_weight ()
public function string of_descr_alignment ()
public function integer of_descr_bg_color ()
public function integer of_descr_color ()
public function integer of_eval_bg_color (n_xls_format anvo_format, long al_row)
public function integer of_eval_color (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_face (n_xls_format anvo_format, long al_row)
public function integer of_eval_numformat (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_height (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_italic (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_underline (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_weight (n_xls_format anvo_format, long al_row)
public function integer of_eval_alignment (n_xls_format anvo_format, long al_row)
public function long of_get_x1 (long al_row)
public function long of_get_x2 ()
public function long of_get_x2 (readonly long al_row)
public function string of_describe (readonly string as_expr)
public function any of_getvalue_dw (long al_row)
public function any of_getvalue_ds (long al_row)
public function any of_getvalue_dwc (long al_row)
public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm, n_dwr_service_parm anvo_parm)
public function integer of_dynamic_horisontal_layout (long al_row, n_dwr_grid anvo_hgrid)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_init (string as_dwo_name, integer ai_dwo_type)
private function datastore of_dwc2ds (datawindowchild adwc_src, boolean ab_copydata)
public function integer of_register (powerobject apo_requestor, n_xls_workbook anvo_writer, n_dwr_colors anvo_colors, long al_base_x, long al_base_y)
public function long of_process_nested (long al_row, long al_writer_row, n_dwr_grid anvo_hgrid)
public function long of_get_band_y1 ()
public function long of_get_band_y2 ()
public function string of_describe_str_expr (string as_expr, long al_row)
end prototypes

public function any of_getvalue (long al_row);Choose Case ipo_requestortype 
	Case DataWindow!
		return of_GetValue_DW(al_row)
	Case DataStore!
		return of_GetValue_DS(al_row)
	Case DataWindowChild!
		return of_GetValue_DWC(al_row)
	Case Else
		// should not be here, see checks in of_register
End Choose   

end function

public function integer of_setformat ();integer li_ret = 1
string ls_format
integer li_color_index

invo_format = invo_writer.of_addformat()
if isNull(invo_format) then 
    li_ret = -1
else
    if Not(isValid(invo_format)) then li_ret = -1
end if
    
if li_ret = 1 then
	ls_format = of_descr_numformat()
	if ls_format = '' then ls_format = '[General]'
	ls_format = of_change_format(ls_format, is_coltype)

   invo_format.of_set_num_format(ls_format)  
	invo_format.of_set_font(of_descr_font_face())
	invo_format.of_set_size(of_descr_font_height())
   invo_format.of_set_italic(of_descr_font_italic())
   invo_format.of_set_underline(of_descr_font_underline())
   invo_format.of_set_bold(of_descr_font_weight())
   invo_format.of_set_align(of_descr_alignment())
   invo_format.of_set_align('top') 
   if is_coltype = 's' then invo_format.of_set_text_wrap(true) 
	li_color_index = of_descr_color()
	if li_color_index > 0 then invo_format.of_set_color(li_color_index)
	li_color_index = of_descr_bg_color()
   if li_color_index > 0 then invo_format.of_set_bg_color(li_color_index)
end if
	 
if li_ret = 1 then
//   ls_format = idw_dw.describe(is_dwo_name + '.format')
//   if (ls_format = '!') or (ls_format = '?') then ls_format = '[General]'
//   ls_format = of_change_format(ls_format, is_coltype)
//   invo_format.of_set_num_format(ls_format)
//   invo_format.of_set_font(idw_dw.describe(is_dwo_name + '.font.face'))
//   invo_format.of_set_size(abs(integer(idw_dw.describe(is_dwo_name + '.font.height'))))

//	string ls_italic
//	ls_italic = lower(idw_dw.describe(is_dwo_name + '.font.italic'))
//  invo_format.of_set_italic( (ls_italic = 'yes') or (ls_italic = '1'))

//	string ls_undl
//	ls_undl = lower(idw_dw.describe(is_dwo_name + '.font.underline'))
//	if (ls_undl = 'yes') or (ls_undl = '1') then invo_format.of_set_underline(1)
   
//	invo_format.of_set_bold(abs(integer(idw_dw.describe(is_dwo_name + '.font.weight'))) = 700)
//   ls_align = idw_dw.describe(is_dwo_name + '.Alignment ')
//	
//   choose case ls_align
//     case '0'
//       invo_format.of_set_align('left') 
//     case '1'
//       invo_format.of_set_align('right') 
//     case '2'
//       invo_format.of_set_align('center') 
//     case '3'
//       invo_format.of_set_align('justified') 
//   end choose
//   invo_format.of_set_align('top') 
//   if is_coltype = 's' then invo_format.of_set_text_wrap(true) 

//   long ll_color
//   integer li_color_index
//   ll_color = of_descr_color()
//   if ll_color >= 0 then
//      li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
//      if li_color_index > 0 then
//          invo_format.of_set_color(li_color_index)
//      end if
//   end if
//
//   ll_color = of_descr_bg_color()
//   if ll_color >= 0 then
//      li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
//      if li_color_index > 0 then
//          invo_format.of_set_bg_color(li_color_index)
//      end if
//   end if
	
	string ls_border_style
	 
	ls_border_style = of_describe(is_dwo_name + '.Border') 
	if isNumber(ls_border_style) and integer(ls_border_style) > 0 then
		invo_format.of_set_border(1)
	else
		if integer(of_describe ( 'Datawindow.Processing' )) = 1 then
			invo_format.of_set_border(7)
		end if
	end if
	ib_custom_format =  (ib_color_expr          or ib_bg_color_expr    or ib_alignment_expr or &
	                     ib_font_face_expr      or ib_font_height_expr or ib_font_italic_expr or &
								ib_font_underline_expr or ib_font_weight_expr or ib_format_expr)
end if  

return li_ret
end function

public function long of_get_x1 ();string ls_expr

if il_cached_x1 = -1 then 
	il_cached_x1 = of_describe_expr(is_dwo_name + '.x', 1)
end if

return il_base_x + il_cached_x1


end function

public function long of_get_y1 (long al_row);long ll_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
   ll_ret = il_base_y + of_describe_expr(is_dwo_name + '.y', al_row)
end if

return ll_ret


end function

public function long of_get_y2 (long al_row);long ll_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
   ll_ret = il_base_y + of_describe_expr(is_dwo_name + '.y', al_row) + of_describe_expr(is_dwo_name + '.height', al_row)
end if

return ll_ret

end function

public function long of_get_y1 ();if il_cached_y1 = -1 then 
	il_cached_y1 = of_describe_expr(is_dwo_name + '.y', 1)
end if
return il_base_y + il_cached_y1


end function

public function integer of_get_visible (long al_row);int li_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
    li_ret = of_describe_expr(is_dwo_name + '.visible', al_row)
end if

return li_ret

end function

public function long of_get_y2 ();if il_cached_y2 = -1 then 
	il_cached_y2 = of_describe_expr(is_dwo_name + '.y', 1) + of_describe_expr(is_dwo_name + '.height', 1)
end if
return il_base_y + il_cached_y2

end function

public function string of_get_item_coltype ();string ls_coltype
long ll_pos, ll_pos_dec

ls_coltype = trim(lower(of_describe(is_dwo_name + '.coltype')))
ll_pos = pos(ls_coltype, '(')
if ll_pos > 0 then 
	ll_pos_dec  = pos(ls_coltype, ',', ll_pos)
	if ll_pos_dec <= 0 then ll_pos_dec = pos(ls_coltype, ')', ll_pos)
	ii_colsize = integer(mid(ls_coltype, ll_pos + 1, ll_pos_dec - ll_pos - 1))
	ls_coltype = trim(left(ls_coltype, ll_pos - 1))
end if

choose case ls_coltype
	case 'char', 'string'
		ls_coltype = 's'
	case 'decimal','int','long','ulong','number','real','integer'
		ls_coltype = 'n'
	case 'date'
		ls_coltype = 'd'
	case 'datetime', 'timestamp'
		ls_coltype = 'dt'
	case 'time'
		ls_coltype = 't'
	case else 
		ls_coltype = '-'
end choose

return ls_coltype

end function

public function long of_describe_expr (string as_expr, long al_row);string ls_val
long ll_pos
n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return -1
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
   ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
   ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return -1
	End Choose   
	if isNumber(ls_val) then return long(ls_val)
else
  if isNumber(ls_val) then return long(ls_val)
end if

return -1
end function

private function string of_unquote(string AS_STR);long ll_pos

if left(as_str, 1) = '"' and &
   right(as_str, 1) = '"' then
   if (pos(as_str,'~r') > 0) or (pos(as_str,'~n') > 0) then
      as_str = mid(as_str, 2, len(as_str) - 2)   
   end if
end if

ll_pos = pos(as_str, '~~"')
do while ll_pos > 0 
   as_str = replace(as_str, ll_pos, 2, '"')
   ll_pos = pos(as_str, '~~"')
loop

return as_str   
end function

public function string of_change_format (ref string as_format, string as_type);long ll_pos
n_dwr_string lnvo_str
string ls_arr[], ls_emp[]
long ll_cnt, ll_i

//delete expression if exist
//ll_pos = pos(lower(as_format), '~t')
//if ll_pos > 0 then
//   as_format = left(as_format, ll_pos - 1) 
//   if left(as_format, 1) = '"' then
//      as_format = right(as_format, len(as_format) - 1) 
//   end if
//end if

//check text format with @
ll_pos = pos(as_format, '@')
if ll_pos > 0 then
   as_format = '[general]'
end if

//replace [general] to @
ll_pos = pos(lower(as_format), '[general]')
do while ll_pos >0
	if is_coltype = 'd' then
	   as_format = replace(as_format, ll_pos, 9, 'dd.mm.yyyy')
	elseif is_coltype = 'dt' then
	   as_format = replace(as_format, ll_pos, 9, 'dd.mm.yyyy hh:mm')
	elseif is_coltype = 't' then
	   as_format = replace(as_format, ll_pos, 9, 'hh:mm')
	else
	   as_format = replace(as_format, ll_pos, 9, '@')
	end if
   ll_pos = pos(lower(as_format), '[general]')
loop

//replace [currency] to $#,##0.00
ll_pos = pos(lower(as_format), '[currency]')
do while ll_pos >0
   as_format = replace(as_format, ll_pos, 10, '$#,##0.00')
   ll_pos = pos(lower(as_format), '[currency]')
loop

//replace [shortdate] to dd.mm.yyyy
ll_pos = pos(lower(as_format), '[shortdate]')
do while ll_pos >0
   as_format = replace(as_format, ll_pos, 11, 'dd.mm.yyyy')
   ll_pos = pos(lower(as_format), '[shortdate]')
loop

//replace [date] to dd.mm.yyyy
ll_pos = pos(lower(as_format), '[date]')
do while ll_pos >0
   as_format = replace(as_format, ll_pos, 6, 'dd.mm.yyyy')
   ll_pos = pos(lower(as_format), '[date]')
loop

//replace [time] to hh:mm
ll_pos = pos(lower(as_format), '[time]')
do while ll_pos >0
   as_format = replace(as_format, ll_pos, 6, 'hh:mm')
   ll_pos = pos(lower(as_format), '[time]')
loop

//check multipart format
if pos(as_format, ';') > 0 then
   ll_cnt = lnvo_str.of_parsetoarray(as_format, ';', ls_arr)
   
   choose case as_type
       case 'n'
            if (ll_cnt > 3) then ll_cnt = 3
         case else
            if (ll_cnt > 1) then ll_cnt = 1
   end choose      
   for ll_i = 1 to ll_cnt
      //change single qoutes to double
      ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_arr[ll_i], '~'', '"')
      //change number format to General
	  ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_emp[ll_i], '@', 'General')
   next
   lnvo_str.of_arraytostring(ls_emp, ';', as_format)
end if

if ii_colsize > 255 then as_format = ''

return as_format

end function

private function integer of_get_column_display_type ();string ls_str

choose case ii_dwo_type
   case 1 // column

      ls_str = of_describe(is_dwo_name + '.CheckBox.On')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_CHECKBOX
      end if

      ls_str = of_describe(is_dwo_name + '.DDDW.Name')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_DDDW
      end if

      ls_str = of_describe(is_dwo_name + '.DDLB.Required')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_DDLB
      end if

      ls_str = of_describe(is_dwo_name + '.RadioButtons.Columns')
      if (ls_str <> '0') and (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_TEXT
      end if
    
      ls_str = of_describe(is_dwo_name + '.Edit.CodeTable')
      if (lower(ls_str) = 'yes') then
         return CDT_CODETABLE
      end if
      return CDT_TEXT
    
   case 2,3 // compute, text
     return CDT_TEXT
   case 4   // report
     return CDT_REPORT
   case else
	  return CDT_TEXT
end choose

end function

public function n_xls_format of_get_format (long al_row);integer li_ret =1
n_xls_format lnvo_temp_format

if ib_custom_format then
	
   al_row = al_row + ii_row_in_detail - 1
   if al_row <= il_dw_row_count then 
		lnvo_temp_format = invo_writer.of_addformat()
		if isNull(lnvo_temp_format) then 
			li_ret = -1
		else
			if Not(isValid(lnvo_temp_format)) then li_ret = -1
		end if
		if li_ret = 1 then
			lnvo_temp_format.of_copy(invo_format)
	
			if ib_bg_color_expr       then of_eval_bg_color(lnvo_temp_format, al_row)
			if ib_color_expr          then of_eval_color(lnvo_temp_format, al_row)
			if ib_format_expr         then of_eval_numformat(lnvo_temp_format, al_row)
			if ib_font_face_expr      then of_eval_font_face(lnvo_temp_format, al_row)
			if ib_font_underline_expr then of_eval_font_underline(lnvo_temp_format, al_row)
			if ib_font_italic_expr    then of_eval_font_italic(lnvo_temp_format, al_row)
			if ib_font_weight_expr    then of_eval_font_weight(lnvo_temp_format, al_row)
			if ib_alignment_expr      then of_eval_alignment(lnvo_temp_format, al_row)
			if ib_font_weight_expr    then of_eval_font_weight(lnvo_temp_format, al_row)
			if ib_font_height_expr    then of_eval_font_height(lnvo_temp_format, al_row)
			if ib_font_height_expr    then of_eval_font_height(lnvo_temp_format, al_row)		

   		return lnvo_temp_format
		end if
	else
		return invo_format
	end if
else
	return invo_format
end if
end function

public function integer of_set_color (n_xls_format a_format, long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = long(of_describe('evaluate("' + is_color_expr + '", ' + string(al_row) + ')'))
	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		if li_color_index > 0 then
			 a_format.of_set_color(li_color_index)
		end if
	end if
end if

return 1

end function

public function integer of_set_bg_color (n_xls_format a_format, long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = long(of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')'))
	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		if li_color_index > 0 then
			 a_format.of_set_bg_color(li_color_index)
		end if
	end if
end if

return 1

end function

public function integer of_check_property (string as_property_name, ref boolean ab_is_expression, ref string as_expression, ref string as_value);integer li_ret
string ls_str
long ll_pos


Choose Case ipo_requestortype 
	Case DataWindow!
		ls_str = idw_requestor.describe(is_dwo_name + '.' + as_property_name)
	Case DataStore!
		ls_str = ids_requestor.describe(is_dwo_name + '.' + as_property_name)
	Case DataWindowChild!
		ls_str = idwc_requestor.describe(is_dwo_name + '.' + as_property_name)
	Case Else
		Return -1
End Choose   
if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
   //check for expression
   ll_pos = pos(lower(ls_str), '~t')
   if ll_pos > 0 then
		 as_expression = right(ls_str, len(ls_str) - ll_pos) 
		 if right(as_expression, 1) = '"' then 
			 as_expression = left(as_expression, len(as_expression) - 1) 
//		 else
//			n_dwr_string s
//			as_expression = s.of_GlobalReplace(as_expression, "~~", "~~~~")
//			as_expression = s.of_GlobalReplace(as_expression, "~'", "~'~'")
//			as_expression = s.of_GlobalReplace(as_expression, "~"", "~"~"")
		 end if
		 ab_is_expression = (trim(as_expression) <> '')

      ls_str = left(ls_str, ll_pos - 1) 
      if left(ls_str, 1) = '"' then
         ls_str = right(ls_str, len(ls_str) - 1) 
      end if
   end if
	
	as_value = ls_str
	li_ret = 1
else
   li_ret = -1
end if

return li_ret
end function

public function string of_descr_numformat ();integer li_ret 
string ls_value

li_ret = of_check_property('Format', ib_format_expr, is_format_expr, ls_value)
if li_ret = 1 then
	return ls_value
else
	return ''
end if

end function

public function string of_descr_font_face ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Face', ib_font_face_expr, is_font_face_expr, ls_value)
if li_ret = 1 then
   return ls_value
else
	return 'Arial'
end if


end function

public function long of_descr_font_height ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Height', ib_font_height_expr, is_font_height_expr, ls_value)
if li_ret = 1 then
   if isNumber(ls_value) then
		return abs(integer(ls_value))
   else
      return 10
   end if
else
	return 10
end if

end function

public function boolean of_descr_font_italic ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Italic', ib_font_italic_expr, is_font_italic_expr, ls_value)
if li_ret = 1 then
	return ((lower(ls_value) = 'yes') or (ls_value = '1'))
else
	return false
end if
end function

public function integer of_descr_font_underline ();integer li_ret 
string ls_value

li_ret = of_check_property('font.underline', ib_font_underline_expr, is_font_underline_expr, ls_value)
if li_ret = 1 then
	if ((lower(ls_value) = 'yes') or (ls_value = '1')) then 
		return 1
	else
		return 0
	end if
else
	return 0
end if

end function

public function boolean of_descr_font_weight ();integer li_ret 
string ls_value

li_ret = of_check_property('font.weight', ib_font_weight_expr, is_font_weight_expr, ls_value)
if li_ret = 1 then
	if isNumber(ls_value) then
		return (abs(integer(ls_value)) = 700)
	else
		return false
	end if
else
	return false
end if

end function

public function string of_descr_alignment ();integer li_ret 
string ls_value = '-1'

li_ret = of_check_property('alignment', ib_alignment_expr, is_alignment_expr, ls_value)
if li_ret <> 1 then ls_value = '-1'
choose case ls_value
     case '0'
   		return 'left'
     case '1'
		   return 'right'
     case '2'
		   return 'center'
     case '3'
		   return 'justified'
	case else
		   if is_coltype = 'n' then
				return 'right'
			else
				return 'left'
			end if
end choose
		
	

end function

public function integer of_descr_bg_color ();integer li_ret 
string ls_str
string ls_value
long ll_color

ls_str = of_describe(is_dwo_name + '.Background.Mode')
if ls_str <> '1' then
   li_ret = of_check_property('Background.Color', ib_bg_color_expr, is_bg_color_expr, ls_value)
	if li_ret = 1 then
       if isNumber(ls_value) then
			 ll_color = invo_colors.of_get_color(long(ls_value))
			 return invo_colors.of_get_custom_color_index(ll_color) 
       else
          return -1
       end if
	else
		return -1
	end if
else
	return -1
end if



end function

public function integer of_descr_color ();integer li_ret 
string ls_value
long ll_color

li_ret = of_check_property('Color', ib_color_expr, is_color_expr, ls_value)
if li_ret = 1 then
   if isNumber(ls_value) then
		ll_color = invo_colors.of_get_color(long(ls_value))
		return invo_colors.of_get_custom_color_index(ll_color) 
   else
      return -1
   end if
else
	return -1
end if

end function

public function integer of_eval_bg_color (n_xls_format anvo_format, long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
       ll_color = invo_colors.of_get_color(long(ls_value))
		 li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		 if li_color_index > 0 then 
			 anvo_format.of_set_bg_color(li_color_index)
			 return 1
		end if
   end if
end if

return -1

end function

public function integer of_eval_color (n_xls_format anvo_format, long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_color_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
       ll_color = invo_colors.of_get_color(long(ls_value))
		 li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		 if li_color_index > 0 then 
			 anvo_format.of_set_color(li_color_index)
			 return 1
		end if
   end if
end if

return -1

end function

public function integer of_eval_font_face (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_font_face_expr + '", ' + string(al_row) + ')'))
	if ls_value <> '' then
		anvo_format.of_set_font(ls_value)
		return 1
	end if
end if

return -1

end function

public function integer of_eval_numformat (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_format_expr + '", ' + string(al_row) + ')'))
 	if ls_value = '' then ls_value = '[General]'
	ls_value = of_change_format(ls_value, is_coltype)
	anvo_format.of_set_num_format(ls_value)
	return 1
end if

return -1

end function

public function integer of_eval_font_height (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_height_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
      anvo_format.of_set_size(abs(integer(ls_value)))
      return 1
   end if
end if

return -1

end function

public function integer of_eval_font_italic (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_italic_expr + '", ' + string(al_row) + ')')
   anvo_format.of_set_italic((lower(ls_value) = 'yes') or (ls_value = '1'))
	return 1
end if

return -1


end function

public function integer of_eval_font_underline (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_underline_expr + '", ' + string(al_row) + ')')
	if ((lower(ls_value) = 'yes') or (ls_value = '1')) then
		anvo_format.of_set_underline(1)
	else
		anvo_format.of_set_underline(0)
	end if
	return 1
end if

return -1


end function

public function integer of_eval_font_weight (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_weight_expr + '", ' + string(al_row) + ')')
	if isNumber(ls_value) then
	   anvo_format.of_set_bold(abs(integer(ls_value)) = 700)
	else
		anvo_format.of_set_bold(false)
	end if
	
	return 1
end if

return -1


end function

public function integer of_eval_alignment (n_xls_format anvo_format, long al_row);string ls_value
string ls_align

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_alignment_expr + '", ' + string(al_row) + ')'))
	choose case ls_value
		  case '0'
				ls_align = 'left'
		  case '1'
				ls_align = 'right'
		  case '2'
				ls_align = 'center'
		  case '3'
				ls_align = 'justified'
		case else
				if is_coltype = 'n' then
					ls_align = 'right'
				else
					ls_align = 'left'
				end if
	end choose
	anvo_format.of_set_align(ls_align)
	return 1
end if

return -1

end function

public function long of_get_x1 (long al_row);//-- 10.09.2004
long ll_ret
string ls_expr

ll_ret = il_base_x + of_describe_expr(is_dwo_name + '.x', al_row)

return ll_ret


end function

public function long of_get_x2 ();if il_cached_x2 = -1 then 
	il_cached_x2 = of_describe_expr(is_dwo_name + '.x', 1) + of_describe_expr(is_dwo_name + '.width', 1)
end if
return il_base_x + il_cached_x2

end function

public function long of_get_x2 (readonly long al_row);//-- 10.09.2004
long ll_ret

ll_ret = il_base_x + of_describe_expr(is_dwo_name + '.x', al_row) + of_describe_expr(is_dwo_name + '.width', al_row)

return ll_ret

end function

public function string of_describe (readonly string as_expr);Choose Case ipo_requestortype 
	Case DataWindow!
		Return idw_requestor.describe(as_expr)
	Case DataStore!
		Return ids_requestor.describe(as_expr)
	Case DataWindowChild!
		Return idwc_requestor.describe(as_expr)
	Case Else
		Return "!"
End Choose   

end function

public function any of_getvalue_dw (long al_row);DataWindow lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case 1,2 // column, compute
		 if ii_column_display_type = 1 then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = 2 then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case 3 // text
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case 4 // report
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function any of_getvalue_ds (long al_row);DataStore lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case 1,2 // column, compute
		 if ii_column_display_type = 1 then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = 2 then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case 3 // text
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case 4 // report
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function any of_getvalue_dwc (long al_row);DataWindowChild lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case 1,2 // column, compute
		 if ii_column_display_type = 1 then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = 2 then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
						la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case 3 // text
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case 4 // report
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm, n_dwr_service_parm anvo_parm);int li_ret = -1

ids_reportdata = Create DataStore
blob lblob_1
Choose Case ipo_requestortype
Case DataWindow!, DataStore!
	Environment e
	GetEnvironment(e)
	If e.PbMajorRevision < 6 Then
		String ls_tmpfile = "dw2xls_tmp.psr"
		If idw_requestor.SaveAs(ls_tmpfile, PSReport!, True) <> 1 Then
			Return -1
		End If
		ids_reportdata.DataObject = ls_tmpfile
		FileDelete(ls_tmpfile)
	Else
		idw_requestor.Dynamic GetFullState(lblob_1)
		ids_reportdata.Dynamic SetFullState(lblob_1)
	End If
	ids_reportdata.Modify("Datawindow.Processing=5")
Case Else // DWC
	 // GetFullState, GetChild, SaveAs not supported
	 Return -1
End Choose

DataWindowChild ldwc_nested
DataStore lds_nested
li_ret = ids_reportdata.GetChild(is_dwo_name, ldwc_nested)
If li_ret = 1 Then
	lds_nested = of_dwc2ds(ldwc_nested, True)
	anvo_nested_parm.il_nested_x = of_get_x1()
	anvo_nested_parm.il_nested_y = of_get_y1()
	inv_nestedservice = Create Using "n_dwr_service"
	li_ret = inv_nestedservice.of_create(lds_nested, invo_writer, ":not applicable:", anvo_parm, anvo_nested_parm)
End If
If li_ret = 1 Then
	li_ret = inv_nestedservice.of_Analyse_DW(0)
End If
inv_nested_service_parm = anvo_nested_parm

Return li_ret
end function

public function integer of_dynamic_horisontal_layout (long al_row, n_dwr_grid anvo_hgrid);Return 1
end function

public function integer of_register_dynamic (powerobject apo_requestor);ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.RowCount()
	Case DataStore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.RowCount()
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.RowCount()
	Case Else
		Return -1
End Choose  

Return 1
end function

public function integer of_init (string as_dwo_name, integer ai_dwo_type);integer li_ret = 1

is_dwo_name = as_dwo_name
ii_dwo_type = ai_dwo_type
choose case ii_dwo_type
  case 1  //column
     is_coltype = of_get_item_coltype()
  case 2  //expression
     is_coltype = of_get_item_coltype()
  case 3  //text
     is_coltype = 's'
     is_text = of_describe(as_dwo_name + '.text')
     is_text = of_unquote(is_text)
	  //-- 04.10.2004
	  //support expression in text object
	  if pos(is_text, '~t') > 0 then is_text_expr = is_text
	  //--
  case 4  // report
      is_coltype = 'r'

	  
end choose

if li_ret = 1 then
	//MessageBox(as_dwo_name, idw_dw.describe(as_dwo_name + '.attributes'))
	//MessageBox(as_dwo_name, idw_dw.describe(as_dwo_name + '.row_in_detail'))
	//ii_row_in_detail = integer(idw_dw.describe(as_dwo_name + '.row_in_detail'))
	//if (ii_row_in_detail < 1) or isNull(ii_row_in_detail) then ii_row_in_detail = 1
	
	Choose Case ipo_requestortype 
		Case DataWindow!
			il_dw_row_count = idw_requestor.RowCount()
		Case DataStore!
			il_dw_row_count = ids_requestor.RowCount()
		Case DataWindowChild!
			il_dw_row_count = idwc_requestor.RowCount()
		Case Else
			Return -1
	End Choose  

   
	ii_column_display_type = of_get_column_display_type()
   li_ret = of_setformat()
end if


return li_ret
end function

private function datastore of_dwc2ds (datawindowchild adwc_src, boolean ab_copydata);DataStore lds_res
lds_res = Create DataStore

//TODO: check for processing=4 and cache the result
adwc_src.Modify('DataWindow.Crosstab.StaticMode=Yes') 

lds_res.Create(adwc_src.Describe("Datawindow.Syntax"))
If ab_copydata Then
	adwc_src.RowsCopy(1, adwc_src.RowCount(), Primary!, lds_res, 1, Primary!)
	lds_res.GroupCalc()
End If

Return lds_res
end function

public function integer of_register (powerobject apo_requestor, n_xls_workbook anvo_writer, n_dwr_colors anvo_colors, long al_base_x, long al_base_y);il_base_x = al_base_x
il_base_y = al_base_y
ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
	Case DataStore!
		ids_requestor = ipo_requestor
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
	Case Else
		Return -1
End Choose   

invo_writer = anvo_writer
invo_colors = anvo_colors
return 1
end function

public function long of_process_nested (long al_row, long al_writer_row, n_dwr_grid anvo_hgrid);
// returns written rows count 

long ll_rown = 0, li_ret = 1
If ib_usetrc Then
	// some trick code for PB :-)
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 1
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	
End If

DataWindowChild ldwc_nested
If il_child_cache_row <> al_row Then
	il_child_cache_row = al_row
	If al_row > 1 Then
		ids_reportdata.RowsMove(al_row, al_row,  Primary!, ids_reportdata, 1, Primary!)
	End IF
	li_ret = ids_reportdata.GetChild(is_dwo_name, idwc_child_cache)
	If li_ret <> 1 Then
		Return 0
	End IF
End If
ldwc_nested = idwc_child_cache
DataStore lds_nested
lds_nested = of_dwc2ds(ldwc_nested, True)


inv_nested_service_parm.il_writer_row = al_writer_row
inv_nested_service_parm.il_parent_row = al_row
inv_nested_service_parm.ipo_dynamic_requestor = lds_nested
inv_nested_service_parm.invo_dynamic_hgrid = anvo_hgrid

li_ret = inv_nestedservice.of_process_work()
If li_ret = 1 Then
	ll_rown = inv_nested_service_parm.il_writer_row - al_writer_row
else
End IF
Return ll_rown

end function

public function long of_get_band_y1 ();if il_cached_y1 = -1 then 
	il_cached_y1 = of_describe_expr(is_dwo_name + '.y', 1)
end if
return il_cached_y1


end function

public function long of_get_band_y2 ();if il_cached_y2 = -1 then 
	il_cached_y2 = of_describe_expr(is_dwo_name + '.y', 1) + of_describe_expr(is_dwo_name + '.height', 1)
end if
return il_cached_y2

end function

public function string of_describe_str_expr (string as_expr, long al_row);string ls_val
long ll_pos
n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return ""
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
   ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
   ls_val = lnvo_str.of_globalreplace(ls_val, '~~', '~~~~')
   ls_val = lnvo_str.of_globalreplace(ls_val, '"', '~~~"')
   ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return ""
	End Choose   
	return ls_val
else
  return ls_val
end if

end function

on n_dwr_field.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_field.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

