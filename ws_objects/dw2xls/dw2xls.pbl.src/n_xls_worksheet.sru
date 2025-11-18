$PBExportHeader$n_xls_worksheet.sru
$PBExportComments$C:\some\excel\builder\n_xls_worksheet.sru
forward
global type n_xls_worksheet from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_worksheet from nonvisualobject
end type
global n_xls_worksheet n_xls_worksheet

type variables
public string is_worksheetname
public n_xls_subroutines_v97 invo_sub;
end variables

forward prototypes
public function int of_write(uint AI_ROW, uint AI_COL, double ADB_NUM)
public function int of_write(uint AI_ROW, uint AI_COL, string AS_STR)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str)
public function int of_write(uint ai_row, uint ai_col, time at_time)
public function int of_write(uint AI_ROW, uint AI_COL, datetime ADT_DATETIME)
public function int of_write(uint AI_ROW, uint AI_COL, date AD_DATE)
public function int of_write(uint AI_ROW, uint AI_COL)
public function int of_write(uint AI_ROW, uint AI_COL, double ADB_NUM, n_xls_format ANVO_FORMAT)
public function int of_write(uint AI_ROW, uint AI_COL, string AS_STR, n_xls_format ANVO_FORMAT)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str, n_xls_format anvo_format)
public function int of_write(uint ai_row, uint ai_col, time at_time, n_xls_format anvo_format)
public function int of_write(uint AI_ROW, uint AI_COL, datetime ADT_DATETIME, n_xls_format ANVO_FORMAT)
public function int of_write(uint AI_ROW, uint AI_COL, date AD_DATE, n_xls_format ANVO_FORMAT)
public function int of_write(uint AI_ROW, uint AI_COL, n_xls_format ANVO_FORMAT)
public function int of_set_row_height(long AL_ROW, long AL_HEIGHT)
public function int of_set_row_format(long AL_ROW, n_xls_format ANVO_FORMAT)
public function int of_set_row_hidden(long AL_ROW, boolean AB_HIDDEN)
public function int of_set_column_width(long AL_COL, long AL_WIDTH)
public function int of_set_column_format(long AL_COL, n_xls_format ANVO_FORMAT)
public function int of_set_column_hidden(long AL_COL, boolean AB_HIDDEN)
public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, double ADB_NUM, n_xls_format ANVO_FORMAT)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, blob ab_unicode_str, n_xls_format anvo_format)
public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, string AS_STR, n_xls_format ANVO_FORMAT)
public function int of_merge_write(uint ai_first_row, uint ai_first_col, uint ai_last_row, uint ai_last_col, time at_time, n_xls_format anvo_format)
public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, datetime ADT_DATETIME, n_xls_format ANVO_FORMAT)
public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, date AD_DATE, n_xls_format ANVO_FORMAT)
public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, n_xls_format ANVO_FORMAT)
public function string of_get_name()
public function blob of_get_name_unicode ()
public function int of_select()
public function int of_activate()
public function int of_set_first_sheet()
public function int of_protect(string AS_PASSWORD)
public function int of_set_column(uint AI_FIRSTCOL, uint AI_LASTCOL, double AD_WIDTH, n_xls_format ANVO_FORMAT, boolean AB_HIDDEN)
public function int of_set_selection(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL)
public function int of_set_selection(uint AI_ROW, uint AI_COL)
public function int of_thaw_panes(double AD_Y, double AD_X, uint AI_ROWTOP, uint AI_COLLEFT)
public function int of_freeze_panes(uint AI_ROW, uint AI_COL, uint AI_ROWTOP, uint AI_COLLEFT)
public function int of_set_portrait()
public function int of_set_landscape()
public function int of_set_paper(uint AI_PAPER_SIZE)
public function int of_set_paper()
public function int of_set_header(string AS_HEADER, double AD_MARGIN_HEAD)
public function int of_set_footer(string AS_FOOTER, double AD_MARGIN_FOOT)
public function integer of_set_header (blob ab_header, double ad_margin_head)
public function integer of_set_footer (blob ab_footer, double ad_margin_foot)
public function int of_center_horizontally()
public function int of_center_horizontally(boolean ab_option)
public function int of_center_vertically()
public function int of_center_vertically(boolean ab_option)
public function int of_set_margins(double AD_MARGIN)
public function int of_set_margins_lr(double AD_MARGIN)
public function int of_set_margins_tb(double AD_MARGIN)
public function int of_set_margin_left(double AD_MARGIN)
public function int of_set_margin_right(double AD_MARGIN)
public function int of_set_margin_top(double AD_MARGIN)
public function int of_set_margin_bottom(double AD_MARGIN)
public function int of_repeat_rows(uint AI_FIRST_ROW, uint AI_LAST_ROW)
public function int of_repeat_columns(uint AI_FIRST_COL, uint AI_LAST_COL)
public function int of_print_area(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL)
public function int of_hide_gridlines(uint AI_OPTION)
public function int of_print_row_col_headers(boolean AB_PRINT_HEADERS)
public function int of_fit_to_pages(uint AI_WIDTH, uint AI_HEIGHT)
public function int of_add_h_pagebreak(uint AI_HBREAK)
public function int of_add_v_pagebreak(uint AI_VBREAK)
public function int of_set_zoom(uint AI_SCALE)
public function int of_set_print_scale(uint AI_SCALE)
public function integer of_set_row_height (long al_row, double ad_height)
public function integer of_set_column_width (long al_col, double ad_width)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y)
end prototypes

public function int of_write(uint AI_ROW, uint AI_COL, double ADB_NUM);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, string AS_STR);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str);
  return of_write(ai_row, ai_col, invo_sub.to_ansi(ab_unicode_str))
end function

public function int of_write(uint ai_row, uint ai_col, time at_time);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, datetime ADT_DATETIME);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, date AD_DATE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, double ADB_NUM, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, string AS_STR, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str, n_xls_format anvo_format);
  return of_write(ai_row, ai_col, invo_sub.to_ansi(ab_unicode_str), anvo_format)
end function

public function int of_write(uint ai_row, uint ai_col, time at_time, n_xls_format anvo_format);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, datetime ADT_DATETIME, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, date AD_DATE, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_write(uint AI_ROW, uint AI_COL, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_row_height(long AL_ROW, long AL_HEIGHT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_row_format(long AL_ROW, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_row_hidden(long AL_ROW, boolean AB_HIDDEN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_column_width(long AL_COL, long AL_WIDTH);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_column_format(long AL_COL, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_column_hidden(long AL_COL, boolean AB_HIDDEN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, double ADB_NUM, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, blob ab_unicode_str, n_xls_format anvo_format);
   return of_merge_write(ai_first_row, ai_first_col, ai_last_row, ai_last_col, invo_sub.to_ansi(ab_unicode_str), anvo_format)
end function

public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, string AS_STR, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_merge_write(uint ai_first_row, uint ai_first_col, uint ai_last_row, uint ai_last_col, time at_time, n_xls_format anvo_format);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, datetime ADT_DATETIME, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, date AD_DATE, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_merge_write(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL, n_xls_format ANVO_FORMAT);   // Generated default script
   int retVar;
   return retVar;
end function

public function string of_get_name();   // Generated default script
   string retVar;
   return retVar;
end function

public function blob of_get_name_unicode ();
  return invo_sub.to_unicode(of_get_name());
end function

public function int of_select();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_activate();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_first_sheet();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_protect(string AS_PASSWORD);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_column(uint AI_FIRSTCOL, uint AI_LASTCOL, double AD_WIDTH, n_xls_format ANVO_FORMAT, boolean AB_HIDDEN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_selection(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_selection(uint AI_ROW, uint AI_COL);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_thaw_panes(double AD_Y, double AD_X, uint AI_ROWTOP, uint AI_COLLEFT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_freeze_panes(uint AI_ROW, uint AI_COL, uint AI_ROWTOP, uint AI_COLLEFT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_portrait();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_landscape();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_paper(uint AI_PAPER_SIZE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_paper();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_header(string AS_HEADER, double AD_MARGIN_HEAD);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_footer(string AS_FOOTER, double AD_MARGIN_FOOT);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_header (blob ab_header, double ad_margin_head);
  return of_set_header(invo_sub.to_ansi(ab_header), ad_margin_head)
end function

public function integer of_set_footer (blob ab_footer, double ad_margin_foot);
  return of_set_footer(invo_sub.to_ansi(ab_footer), ad_margin_foot)
end function

public function int of_center_horizontally();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_center_horizontally(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_center_vertically();   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_center_vertically(boolean ab_option);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margins(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margins_lr(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margins_tb(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margin_left(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margin_right(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margin_top(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_margin_bottom(double AD_MARGIN);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_repeat_rows(uint AI_FIRST_ROW, uint AI_LAST_ROW);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_repeat_columns(uint AI_FIRST_COL, uint AI_LAST_COL);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_print_area(uint AI_FIRST_ROW, uint AI_FIRST_COL, uint AI_LAST_ROW, uint AI_LAST_COL);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_hide_gridlines(uint AI_OPTION);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_print_row_col_headers(boolean AB_PRINT_HEADERS);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_fit_to_pages(uint AI_WIDTH, uint AI_HEIGHT);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_add_h_pagebreak(uint AI_HBREAK);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_add_v_pagebreak(uint AI_VBREAK);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_zoom(uint AI_SCALE);   // Generated default script
   int retVar;
   return retVar;
end function

public function int of_set_print_scale(uint AI_SCALE);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_row_height (long al_row, double ad_height);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_set_column_width (long al_col, double ad_width);   // Generated default script
   int retVar;
   return retVar;
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y);integer li_ret = 1

return li_ret
end function

on n_xls_worksheet.create
TriggerEvent( this, "constructor" )
end on

on n_xls_worksheet.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;invo_sub = create n_xls_subroutines_v97
end event

event destructor;destroy invo_sub
end event

