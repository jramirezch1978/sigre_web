$PBExportHeader$n_xls_worksheet_v5.sru
forward
global type n_xls_worksheet_v5 from n_xls_worksheet
end type
end forward

shared variables

end variables

global type n_xls_worksheet_v5 from n_xls_worksheet
end type
global n_xls_worksheet_v5 n_xls_worksheet_v5

type variables
public uint ii_index = 0
public boolean ib_selected = false
public ulong il_offset = 0
public ulong il_datasize = 0
protected blob ib_data
public uint ii_print_rowmin
public uint ii_print_rowmax
public int ii_print_colmin
public uint ii_title_rowmin
public uint ii_title_rowmax
public int ii_title_colmin
public int ii_title_colmax
public int ii_print_colmax
protected ulong il_xls_rowmax = 65536
protected ulong il_xls_colmax = 256
protected ulong il_xls_strmax = 255
protected ulong il_dim_rowmin
protected ulong il_dim_colmin
protected ulong il_dim_rowmax = 0
protected ulong il_dim_colmax = 0
protected boolean ib_dim_changed = false
protected int ii_active_pane = 3
protected boolean ib_frozen = false
protected uint ii_paper_size = 0
protected int ii_orientation = 1
protected string is_header = ''
protected string is_footer = ''
protected uint ii_vcenter = 0
protected uint ii_hcenter = 0
protected double id_margin_head = 0.50
protected double id_margin_foot = 0.50
protected double id_margin_left = 0.75
protected double id_margin_right = 0.75
protected double id_margin_top = 1.00
protected double id_margin_bottom = 1.00
protected boolean ib_print_gridlines = true
protected boolean ib_screen_gridlines = true
protected boolean ib_print_headers = false
protected boolean ib_fit_page = false
protected uint ii_fit_width = 0
protected uint ii_fit_height = 0
protected uint ii_hbreaks[]
protected uint ii_vbreaks[]
protected boolean ib_protect = false
protected string is_password
protected double id_col_sizes[]
protected double id_row_sizes[]
protected int ii_zoom = 100
protected int ii_print_scale = 100
protected boolean ib_leading_zeros = false
protected uint ii_limit = 2080
protected boolean ib_col_hiddens[]
protected boolean ib_row_hiddens[]
 public n_xls_format_v5 invo_url_format;

 public n_xls_workbook invo_workbook;

 public n_xls_colinfo invo_colinfo[];

 public n_xls_selection invo_selection;

 public n_xls_panes invo_panes;

 public n_associated_ulong_srv invo_key_col_sizes;

 public n_associated_ulong_srv invo_key_row_sizes;

 public n_associated_ulong_srv invo_key_col_formats;

 public n_associated_ulong_srv invo_key_row_formats;

 protected n_xls_format_v5 invo_col_formats[];

 protected n_xls_format_v5 invo_row_formats[];

 protected n_associated_ulong_srv invo_key_col_hiddens;

 protected n_associated_ulong_srv invo_key_row_hiddens;

 protected n_xls_data invo_data;

 protected n_xls_data invo_header;


end variables

forward prototypes
public function integer of_close ()
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, double adb_num, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, string as_str, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, datetime adt_datetime, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, date ad_date, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, n_xls_format anvo_format)
protected function integer of_xf (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format_v5 anvo_format)
protected function integer of_append_data (blob ab_data)
protected function blob of_add_continue (blob ab_data)
protected function integer of_sort_pagebreaks (ref unsignedinteger ai_page_breaks[])
protected function integer of_check_dimensions (unsignedlong al_row, unsignedlong al_col)
protected function integer of_store_dimensions ()
protected function integer of_store_window2 ()
protected function integer of_store_defcol ()
protected function integer of_store_colinfo (n_xls_colinfo anvo_colinfo)
protected function integer of_store_selection (n_xls_selection anvo_selection)
protected function integer of_store_externcount (unsignedinteger ai_count)
protected function integer of_store_externsheet (string as_sheetname)
protected function integer of_store_panes (n_xls_panes anvo_panes)
protected function integer of_store_setup ()
protected function integer of_store_header ()
protected function integer of_store_footer ()
protected function integer of_store_hcenter ()
protected function integer of_store_vcenter ()
protected function integer of_store_margin_left ()
protected function integer of_store_margin_right ()
protected function integer of_store_margin_top ()
protected function integer of_store_margin_bottom ()
protected function integer of_merge_cells (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
protected function integer of_store_print_headers ()
protected function integer of_store_print_gridlines ()
protected function integer of_store_gridset ()
protected function integer of_store_wsbool ()
protected function integer of_store_hbreak ()
protected function integer of_store_vbreak ()
protected function integer of_store_protect ()
protected function integer of_store_password ()
public function unsignedinteger of_size_col (unsignedinteger ai_col)
public function unsignedinteger of_size_row (unsignedinteger ai_row)
protected function integer of_store_zoom ()
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format)
protected function integer of_store_bof (unsignedinteger ai_type)
protected function integer of_store_eof ()
protected function integer of_append_header (blob ab_data)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, time at_time, n_xls_format anvo_format)
public function integer of_set_row_format (long al_row, n_xls_format anvo_format)
public function integer of_set_row_hidden (long al_row, boolean ab_hidden)
public function integer of_set_column_format (long al_col, n_xls_format anvo_format)
public function integer of_set_column_hidden (long al_col, boolean ab_hidden)
public function integer of_write_data (olestream astr_book)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col)
public function string of_get_name ()
public function integer of_activate ()
public function integer of_set_first_sheet ()
public function integer of_protect (string as_password)
public function integer of_set_selection (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
public function integer of_set_selection (unsignedinteger ai_row, unsignedinteger ai_col)
public function integer of_thaw_panes (double ad_y, double ad_x, unsignedinteger ai_rowtop, unsignedinteger ai_colleft)
public function integer of_freeze_panes (unsignedinteger ai_row, unsignedinteger ai_col, unsignedinteger ai_rowtop, unsignedinteger ai_colleft)
public function integer of_set_portrait ()
public function integer of_set_landscape ()
public function integer of_set_paper (unsignedinteger ai_paper_size)
public function integer of_set_paper ()
public function integer of_set_header (string as_header, double ad_margin_head)
public function integer of_set_footer (string as_footer, double ad_margin_foot)
public function integer of_center_horizontally ()
public function integer of_center_horizontally (boolean ab_option)
public function integer of_center_vertically ()
public function integer of_center_vertically (boolean ab_option)
public function integer of_set_margins (double ad_margin)
public function integer of_set_margins_lr (double ad_margin)
public function integer of_set_margins_tb (double ad_margin)
public function integer of_set_margin_left (double ad_margin)
public function integer of_set_margin_right (double ad_margin)
public function integer of_set_margin_top (double ad_margin)
public function integer of_set_margin_bottom (double ad_margin)
public function integer of_repeat_rows (unsignedinteger ai_first_row, unsignedinteger ai_last_row)
public function integer of_repeat_columns (unsignedinteger ai_first_col, unsignedinteger ai_last_col)
public function integer of_print_area (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
public function integer of_hide_gridlines (unsignedinteger ai_option)
public function integer of_print_row_col_headers (boolean ab_print_headers)
public function integer of_fit_to_pages (unsignedinteger ai_width, unsignedinteger ai_height)
public function integer of_add_h_pagebreak (unsignedinteger ai_hbreak)
public function integer of_add_v_pagebreak (unsignedinteger ai_vbreak)
public function integer of_set_zoom (unsignedinteger ai_scale)
public function integer of_set_print_scale (unsignedinteger ai_scale)
public function blob of_get_data ()
protected function unsignedlong of_encode_password (string as_password)
public function integer of_set_row_height (long al_row, double ad_height)
public function integer of_set_row (unsignedinteger ai_row, double ad_height, n_xls_format_v5 anvo_format, boolean ab_hidden)
public function integer of_set_column_width (long al_col, double ad_width)
public function integer of_set_column (unsignedinteger ai_firstcol, unsignedinteger ai_lastcol, double ad_width, n_xls_format anvo_format, boolean ab_hidden)
public function integer of_set_column_width (long al_col, long al_width)
public function integer of_set_row_height (long al_row, long al_height)
protected function integer of_process_bitmap (readonly string as_bitmap_filename, ref long al_width, ref long al_height, ref long al_size, ref blob ab_data)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename)
public function integer of_position_image (unsignedinteger ai_col_start, unsignedinteger ai_row_start, unsignedinteger ai_x1, unsignedinteger ai_y1, unsignedinteger ai_width, unsignedinteger ai_height)
protected function unsignedinteger of_get_excel_height (double ad_value)
protected function unsignedinteger of_get_excel_width (double ad_value)
public function integer of_select ()
protected function integer of_store_obj_picture (readonly unsignedinteger ai_col_start, readonly unsignedinteger ai_x1, readonly unsignedinteger ai_row_start, readonly unsignedinteger ai_y1, readonly unsignedinteger ai_col_end, readonly unsignedinteger ai_x2, readonly unsignedinteger ai_row_end, readonly unsignedinteger ai_y2)
end prototypes

public function integer of_close ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_close
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////


integer li_ret = 1
uint li_i, li_cnt
long ll_i

//Append to header
//<<<<<<<<<<---------------------

//Append the BOF record
of_store_bof(16) //0x0010

//Append the COLINFO records if they exist
li_cnt = UpperBound(invo_colinfo)
if li_cnt > 0 then
  of_store_defcol()
  for li_i = li_cnt to  1 step -1
    of_store_colinfo(invo_colinfo[li_i])
  next 
end if 

//Append the EXTERNCOUNT of external references.
of_store_externcount(invo_workbook.il_worksheetindex)

//Append EXTERNSHEET references
for ll_i = 1 to invo_workbook.il_worksheetindex
   of_store_externsheet(invo_workbook.invo_worksheets[ll_i].is_worksheetname)     
next 

//Append PRINTHEADERS
of_store_print_headers()           
//Append PRINTGRIDLINES
of_store_print_gridlines()           
//Append GRIDSET
of_store_gridset()
//Append WSBOOL
of_store_wsbool()               
//Append the horizontal page breaks
of_store_hbreak()               
//Append the vertical page breaks
of_store_vbreak()               
//Append the page setup
of_store_setup()       
//Append the sheet protection
of_store_protect()       
//Append the sheet password
of_store_password()    
//Append the sheet dimensions
of_store_dimensions()    

//End of header
//<<<<<<<<<<---------------------

//Append to data
//<<<<<<<<<<---------------------

//Append the bottom margin
of_store_margin_bottom()       
//Append the top margin
of_store_margin_top()       
//Append the right margin
of_store_margin_right()       
//Append the left margin
of_store_margin_left()       

//Append the page vertical centering
of_store_vcenter()       
//Append the page horizontal centering
of_store_hcenter()              

//Append the page footer
of_store_footer()               
//Append the page header
of_store_header()

of_store_window2()
of_store_zoom()
if Not(isNull(invo_panes)) then
   if isValid(invo_panes) then
      of_store_panes(invo_panes)
   end if
end if  
of_store_selection(invo_selection)
of_store_eof()
//End of data
//<<<<<<<<<<---------------------

return li_ret

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, double adb_num, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                adb_num      double
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Write data to the merged cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_rwFirst
uint li_colFirst
uint li_rwLast
uint li_colLast
uint li_i, li_j
n_xls_format_v5 lnvo_format

li_rwFirst  = ai_first_row             
li_colFirst = ai_first_col             
li_rwLast   = ai_last_row              
li_colLast  = ai_last_col            

if (li_rwFirst = li_rwLast) and (li_colFirst = li_colLast) then 
   	 
   	
      MessageBox('Error','Can~'t merge single cell', StopSign!)
   	
  //Can't merge single cell
  return -1
end if

if li_rwFirst > li_rwLast then
   li_rwFirst  = ai_last_row 
   li_rwLast   = ai_first_row             
end if

if li_colFirst > li_colLast then
   li_colFirst  = ai_last_col
   li_colLast   = ai_first_col             
end if

//Set the merge_range property of the format object. For BIFF8+
if not(isNull(anvo_format)) then
   if isValid(anvo_format) then
      lnvo_format = anvo_format
      lnvo_format.of_set_merge_range()
   end if
end if

//Write the first cell
of_write(li_rwFirst, li_colFirst, adb_num, anvo_format)

//Pad out the rest of the area with formatted blank cells
for li_i = li_rwFirst to li_rwLast
    for li_j = li_colFirst to li_colLast
        if (li_i = li_rwFirst) and (li_j = li_colFirst) then continue
        of_write(li_i, li_j, anvo_format)
    next
next

of_merge_cells(li_rwFirst, li_colFirst, li_rwLast, li_colLast)

return li_ret

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, string as_str, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                as_str       string
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Write data to the merged cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_rwFirst
uint li_colFirst
uint li_rwLast
uint li_colLast
uint li_i, li_j
n_xls_format_v5 lnvo_format

li_rwFirst  = ai_first_row             
li_colFirst = ai_first_col             
li_rwLast   = ai_last_row              
li_colLast  = ai_last_col            


if (li_rwFirst = li_rwLast) and (li_colFirst = li_colLast) then 
   	 
   	
      MessageBox('Error','Can~'t merge single cell', StopSign!)
   	
  //Can't merge single cell
  return -1
end if

if li_rwFirst > li_rwLast then
   li_rwFirst  = ai_last_row 
   li_rwLast   = ai_first_row             
end if

if li_colFirst > li_colLast then
   li_colFirst  = ai_last_col
   li_colLast   = ai_first_col             
end if

//Set the merge_range property of the format object. For BIFF8+
if not(isNull(anvo_format)) then
   if isValid(anvo_format) then
      lnvo_format = anvo_format
      lnvo_format.of_set_merge_range()
   end if
end if

//Write the first cell
of_write(li_rwFirst, li_colFirst, as_str, anvo_format)

//Pad out the rest of the area with formatted blank cells
for li_i = li_rwFirst to li_rwLast
    for li_j = li_colFirst to li_colLast
        if (li_i = li_rwFirst) and (li_j = li_colFirst) then continue
        of_write(li_i, li_j, anvo_format)
    next
next

of_merge_cells(li_rwFirst, li_colFirst, li_rwLast, li_colLast)

return li_ret

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, datetime adt_datetime, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                adt_datetime datetime
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Write data to the merged cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

double ld_val
time lt_time
string ls_time
int li_hour, li_minute, li_second

lt_time = time(adt_datetime)
//-- 09.09.2004 bug fixed function time(...)
ls_time = string(lt_time)
lt_time = time(ls_time)
//--
li_hour   = hour(lt_time)
li_minute = minute(lt_time)
li_second = second(lt_time)

ld_val = daysafter(1899-12-30, date(adt_datetime)) + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
return of_merge_write(ai_first_row, ai_first_col, ai_last_row, ai_last_col, ld_val, anvo_format)

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, date ad_date, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                ad_date      date
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Write data to the merged cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

double ld_val
ld_val = daysafter(1899-12-30, ad_date)
return of_merge_write(ai_first_row, ai_first_col, ai_last_row, ai_last_col, ld_val, anvo_format)

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  to merge cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_rwFirst
uint li_colFirst
uint li_rwLast
uint li_colLast
uint li_i, li_j
n_xls_format_v5 lnvo_format

li_rwFirst  = ai_first_row             
li_colFirst = ai_first_col             
li_rwLast   = ai_last_row              
li_colLast  = ai_last_col            

if (li_rwFirst = li_rwLast) and (li_colFirst = li_colLast) then 
   	 
   	
      MessageBox('Error','Can~'t merge single cell', StopSign!)
   	
  //Can't merge single cell
  return -1
end if

if li_rwFirst > li_rwLast then
   li_rwFirst  = ai_last_row 
   li_rwLast   = ai_first_row             
end if

if li_colFirst > li_colLast then
   li_colFirst  = ai_last_col
   li_colLast   = ai_first_col             
end if

//Set the merge_range property of the format object. For BIFF8+
if not(isNull(anvo_format)) then
   if isValid(anvo_format) then
      lnvo_format = anvo_format
      lnvo_format.of_set_merge_range()
   end if
end if

//Write the first cell
of_write(li_rwFirst, li_colFirst, anvo_format)

//Pad out the rest of the area with formatted blank cells
for li_i = li_rwFirst to li_rwLast
    for li_j = li_colFirst to li_colLast
        if (li_i = li_rwFirst) and (li_j = li_colFirst) then continue
        of_write(li_i, li_j, anvo_format)
    next
next

of_merge_cells(li_rwFirst, li_colFirst, li_rwLast, li_colLast)

return li_ret

end function

protected function integer of_xf (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format_v5 anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_xf
//
//	Access: 			protected
//
//	Arguments:	   ai_row      uint
//                ai_col      uint
//                anvo_format n_xlas_format_v5
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_xf = 15  //0x0F
ulong ll_key

if Not(isNull(anvo_format)) then
   if isValid(anvo_format) then 
		return invo_workbook.of_reg_format(anvo_format)
//      return anvo_format.of_get_xf_index()
   end if
end if

ll_key = invo_key_row_formats.of_get_key_index(ai_row)
if ll_key > 0 then
   return invo_workbook.of_reg_format(invo_row_formats[ll_key])
end if

ll_key = invo_key_col_formats.of_get_key_index(ai_col)
if ll_key > 0 then
   return invo_workbook.of_reg_format(invo_col_formats[ll_key])
end if

return li_xf

end function

protected function integer of_append_data (blob ab_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_append_data
//
//	Access: 			protected
//
//	Arguments:	   
//                ab_data blob
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1

if len(ab_data) > ii_limit then
   ab_data = of_add_continue(ab_data)
end if

il_datasize += len(ab_data)
invo_data.of_append(ab_data)

return li_ret

end function

protected function blob of_add_continue (blob ab_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_add_continue
//
//	Access: 			protected
//
//	Arguments:	   
//                ab_data  blob       
//       
//	
//	Returns:  		blob
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_record =  60 //0x003C Record identifier
//uint li_length       //Number of bytes to follow
blob lb_header
blob lb_tmp
ulong ll_start_pos = 1

//The first 2080/8224 bytes remain intact. However, we have to change
//the length field of the record

lb_tmp  = blobmid(ab_data, 1, ii_limit)
ab_data = blobmid(ab_data, ii_limit + 1, len(ab_data) - ii_limit)  

blobedit(lb_tmp, 3, invo_sub.of_pack('v', ii_limit - 4))

do while len(ab_data) > ii_limit 
	
   lb_header =  invo_sub.of_pack('v', li_record) + &
                invo_sub.of_pack('v', ii_limit) 
   lb_tmp += lb_header
	
   lb_tmp += blobmid(ab_data, 1, ii_limit) 
   ab_data = blobmid(ab_data, ii_limit + 1, len(ab_data) - ii_limit)  
	
loop

//Mop up the last of the data
if len(ab_data) > 0 then
	lb_header =  invo_sub.of_pack('v', li_record) + &
					 invo_sub.of_pack('v', len(ab_data))
	lb_tmp += lb_header
	lb_tmp += ab_data
end if

return lb_tmp

end function

protected function integer of_sort_pagebreaks (ref unsignedinteger ai_page_breaks[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_sort_pagebreaks
//
//	Access: 			protected
//
//	Arguments:	   ai_page_breaks[] uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
n_associated_ulong_srv invo_key_breaks
uint li_cnt, li_i
ulong ll_ind
uint li_new[]

invo_key_breaks = create n_associated_ulong_srv
li_cnt = UpperBound(ai_page_breaks)

for li_i = 1 to li_cnt
    if ai_page_breaks[li_i] > 0 then
       ll_ind = invo_key_breaks.of_get_key_index(ai_page_breaks[li_i])
       if ll_ind = 0 then
          invo_key_breaks.of_add_key(ai_page_breaks[li_i])
       end if                                                             
   end if
next

invo_key_breaks.of_sort_keys()
li_cnt = invo_key_breaks.of_get_keys_count()
for li_i = 1 to li_cnt
    li_new[li_i] = invo_key_breaks.of_get_key(li_i)
next

ai_page_breaks = li_new

return li_ret

end function

protected function integer of_check_dimensions (unsignedlong al_row, unsignedlong al_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_check_dimension
//
//	Access: 			protected
//
//	Arguments:	   
//                al_row ulong
//                al_col ulong
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
if al_row > il_xls_rowmax then return -2
if al_col > il_xls_colmax then return -2

ib_dim_changed = true
if al_row < il_dim_rowmin then il_dim_rowmin = al_row
if al_row > il_dim_rowmax then il_dim_rowmax = al_row
if al_col < il_dim_colmin then il_dim_colmin = al_col
if al_col > il_dim_colmax then il_dim_colmax = al_col

return li_ret

end function

protected function integer of_store_dimensions ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_dimensions
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   0    //0x0000 Record identifier
uint li_length =   10   //0x000A Number of bytes to follow
uint li_row_min
uint li_row_max
uint li_col_min
uint li_col_max
uint li_reserved   = 0   //0x0000
blob lb_header
blob lb_data

//Set the data range if data has been written to the worksheet
if ib_dim_changed then
  li_row_min = il_dim_rowmin
  li_row_max = il_dim_rowmax + 1
  li_col_min = il_dim_colmin
  li_col_max = il_dim_colmax + 1
else
  li_row_min = 0
  li_row_max = 0
  li_col_min = 0
  li_col_max = 256
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_row_min) +&
            invo_sub.of_pack('v', li_row_max) +&
            invo_sub.of_pack('v', li_col_min) +&
            invo_sub.of_pack('v', li_col_max) +& 
            invo_sub.of_pack('v', li_reserved) 
of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_window2 ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_window2
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =  574   //0x023E Record identifier
uint li_length =   10   //0x000A Number of bytes to follow
blob lb_header
blob lb_data
uint li_grbit   =  182  //0x00B6 Option flags
uint li_rwTop   =    0  //0x0000 Top row visible in window     
uint li_colLeft =    0  //0x0000 Leftmost column visible in window
ulong ll_rgbHdr =    0  //0x00000000 Row/column heading and gridline color

int li_fDspFmla       = 0   //0 - bit
int li_fDspGrid       = 0   //1 - bit
int li_fDspRwCol      = 1   //2 - bit
int li_fFrozen        = 0   //3 - bit
int li_fDspZeros      = 1   //4 - bit
int li_fDefaultHdr    = 1   //5 - bit
int li_fArabic        = 0   //6 - bit
int li_fDspGuts       = 1   //7 - bit
int li_fFrozenNoSplit = 0   //0 - bit
int li_fSelected      = 0   //1 - bit
int li_fPaged         = 1   //2 - bit

if ib_screen_gridlines then   li_fDspGrid  = 1
if ib_frozen           then   li_fFrozen   = 1
if ib_selected         then   li_fSelected = 1

li_grbit  = li_fDspFmla
li_grbit += li_fDspGrid       * 2
li_grbit += li_fDspRwCol      * 4
li_grbit += li_fFrozen        * 8
li_grbit += li_fDspZeros      * 16
li_grbit += li_fDefaultHdr    * 32
li_grbit += li_fArabic        * 64
li_grbit += li_fDspGuts       * 128
li_grbit += li_fFrozenNoSplit * 256
li_grbit += li_fSelected      * 512
li_grbit += li_fPaged         * 1024


lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('v', li_rwtop) +&
            invo_sub.of_pack('v', li_colLeft) +&
            invo_sub.of_pack('V', ll_rgbHdr) 
of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_defcol ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_defcol
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////



int li_ret = 1
uint li_record =   85   //0x0055 Record identifier
uint li_length =    2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data

uint li_colwidth = 8   //0x0008 Default column width

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_colwidth)
of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_colinfo (n_xls_colinfo anvo_colinfo);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_colinfo
//
//	Access: 			protected
//
//	Arguments:	   anvo_colinfo n_xls_colinfo
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =  125   //0x007D Record identifier
uint li_length =   11   //0x000B Number of bytes to follow
blob lb_header
blob lb_data
uint li_coldx
uint li_ixfe     = 15   //0x0F XF index
uint li_grbit    = 0    //     Option flags
uint li_reserved = 0    //0x00 Reserved
n_xls_format_v5 lnvo_format

li_coldx = of_get_excel_width(anvo_colinfo.id_width)


if anvo_colinfo.ib_hidden then li_grbit = 1


//Check for a format object
if Not(isNull(anvo_colinfo.invo_format)) then
   if isValid(anvo_colinfo.invo_format) then
		lnvo_format = anvo_colinfo.invo_format
      li_ixfe = invo_workbook.of_get_xf(lnvo_format)
   end if
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', anvo_colinfo.ii_firstcol) +&
            invo_sub.of_pack('v', anvo_colinfo.ii_lastcol) +&
            invo_sub.of_pack('v', li_coldx) +&
            invo_sub.of_pack('v', li_ixfe) +&
            invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('C', li_reserved) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_selection (n_xls_selection anvo_selection);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_selection
//
//	Access: 			protected
//
//	Arguments:	   anvo_selection n_xls_selection
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   29   //0x001D Record identifier
uint li_length =   15   //0x000F Number of bytes to follow
blob lb_header
blob lb_data
uint li_pnn
uint li_irefAct  = 0   //Active cell ref
uint li_cref     = 1   //Number of refs
uint li_rwAct          // Active row
uint li_colAct         // Active column

uint li_rwFirst
uint li_rwLast
uint li_colFirst
uint li_colLast

li_pnn = ii_active_pane
li_rwAct = anvo_selection.ii_first_row
li_colAct = anvo_selection.ii_first_col

if anvo_selection.ii_first_row > anvo_selection.ii_last_row then
  li_rwFirst = anvo_selection.ii_last_row
  li_rwLast = anvo_selection.ii_first_row
else
  li_rwFirst = anvo_selection.ii_first_row
  li_rwLast = anvo_selection.ii_last_row
end if

if anvo_selection.ii_first_col > anvo_selection.ii_last_col then
  li_colFirst = anvo_selection.ii_last_col
  li_colLast = anvo_selection.ii_first_col
else
  li_colFirst = anvo_selection.ii_first_col
  li_colLast = anvo_selection.ii_last_col
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('C', li_pnn) +&
            invo_sub.of_pack('v', li_rwAct) +&
            invo_sub.of_pack('v', li_colAct) +&
            invo_sub.of_pack('v', li_irefAct) +&
            invo_sub.of_pack('v', li_cref) +&
            invo_sub.of_pack('v', li_rwFirst) +&
            invo_sub.of_pack('v', li_rwLast) +&
            invo_sub.of_pack('C', li_colFirst) +&
            invo_sub.of_pack('C', li_colLast) 

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_externcount (unsignedinteger ai_count);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_externcount
//
//	Access: 			protected
//
//	Arguments:	   ai_count uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   22   //0x0016 Record identifier
uint li_length =    2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', ai_count)

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_externsheet (string as_sheetname);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_extersheet
//
//	Access: 			protected
//
//	Arguments:	   as_sheetname string
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   23   //0x0017 Record identifier
uint li_length          // Number of bytes to follow
blob lb_header
blob lb_data
uint li_cch  // Length of sheet name
uint li_rgch // Filename encoding

//References to the current sheet are encoded differently to references to
//external sheets.
if is_worksheetname = as_sheetname then
   as_sheetname = ''
   li_length = 2  //0x02 The following 2 bytes
   li_cch = 1     //The following byte
   li_rgch = 2    //0x02  Self reference
else
   li_length = 2 + len(as_sheetname)
   li_cch    = len(as_sheetname)
   li_rgch   = 3          //0x03 Reference to a sheet in the current workbook
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('C', li_cch) +&
            invo_sub.of_pack('C', li_rgch) 
if len(as_sheetname) > 0 then lb_data = lb_data + blob(as_sheetname)

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_panes (n_xls_panes anvo_panes);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_panes
//
//	Access: 			protected
//
//	Arguments:	   anvo_panes n_xls_panes
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   65   //0x0041 Record identifier
uint li_length =   10   //0x000A Number of bytes to follow
blob lb_header
blob lb_data

uint li_y       // Vertical split position
uint li_x       // Horizontal split position
uint li_rwTop   // Top row visible
uint li_colLeft // Leftmost column visible
uint li_pnnAct  // Active pane

//Code specific to frozen or thawed panes.
if ib_frozen then
   //Set default values for $rwTop and $colLeft
   li_y = anvo_panes.id_y
   li_x = anvo_panes.id_x
   if isNull(anvo_panes.ii_rowTop) then
      li_rwTop = li_y
   else
      li_rwTop = anvo_panes.ii_rowTop
   end if
   if isNull(anvo_panes.ii_colLeft) then
      li_colLeft = li_x
   else
      li_colLeft = anvo_panes.ii_colLeft
   end if
else
   //Set default values for li_rwTop and li_colLeft
   if isNull(anvo_panes.ii_rowTop) then
      li_rwTop   = 0
   else
      li_rwTop = anvo_panes.ii_rowTop
   end if

   if isNull(anvo_panes.ii_colLeft) then
      li_colLeft   = 0
   else
      li_colLeft = anvo_panes.ii_colLeft
   end if
   //Convert Excel's row and column units to the internal units.
   //The default row height is 12.75
   //The default column width is 8.43
   //The following slope and intersection values were interpolated
   li_y = 20*anvo_panes.id_y + 255
   li_x = 113.879*anvo_panes.id_x + 390
end if

// Determine which pane should be active. There is also the undocumented
// option to override this should it be necessary: may be removed later.
if (li_x <> 0) and (li_y <> 0)  then li_pnnAct = 0  //Bottom right
if (li_x <> 0) and (li_y = 0)   then li_pnnAct = 1  //Top right
if (li_x = 0)  and (li_y <> 0)  then li_pnnAct = 2  //Bottom left
if (li_x = 0)  and (li_y = 0)   then li_pnnAct = 3  //Top left

ii_active_pane = li_pnnAct //Used in _store_selection

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_x) +&
            invo_sub.of_pack('v', li_y) +&
            invo_sub.of_pack('v', li_rwTop) +&
            invo_sub.of_pack('v', li_colLeft) +&
            invo_sub.of_pack('v', li_pnnAct) 

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_setup ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_setup
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   161   //0x00A1 Record identifier
uint li_length =    34   //0x0022 Number of bytes to follow
blob lb_header
blob lb_data

uint li_iPageStart = 1      //0x01     Starting page number
uint li_grbit      = 0      //0x00     Option flags
uint li_iRes       = 600    //0x0258   Print resolution
uint li_iVRes      = 600    //0x0258   Vertical print resolution
uint li_iCopies    = 1      //0x01     Number of copies

uint li_fLeftToRight = 0  // Print over then down
uint li_fLandscape   = 0  // Page orientation
uint li_fNoPls       = 0  // Setup not read from printer
uint li_fNoColor     = 0  // Print black and white
uint li_fDraft       = 0  // Print draft quality
uint li_fNotes       = 0  // Print notes
uint li_fNoOrient    = 0  // Orientation not set
uint li_fUsePage     = 0  // Use custom starting page

li_fLandscape = ii_orientation

li_grbit  = li_fLeftToRight 
li_grbit += li_fLandscape   * 2
li_grbit += li_fNoPls       * 4
li_grbit += li_fNoColor     * 8
li_grbit += li_fDraft       * 16
li_grbit += li_fNotes       * 32
li_grbit += li_fNoOrient    * 64
li_grbit += li_fUsePage     * 128

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', ii_paper_size) +&
            invo_sub.of_pack('v', ii_print_scale) +&
            invo_sub.of_pack('v', li_iPageStart) +&
            invo_sub.of_pack('v', ii_fit_width) +&
            invo_sub.of_pack('v', ii_fit_height) +&
            invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('v', li_iRes) +&
            invo_sub.of_pack('v', li_iVRes) +&
            invo_sub.of_pack('d', id_margin_head) +&
            invo_sub.of_pack('d', id_margin_foot) +&
            invo_sub.of_pack('v', li_iCopies)

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_header ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_header
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    20   //0x0014 Record identifier
uint li_length           //Number of bytes to follow
blob lb_header
blob lb_data
uint li_cch

li_cch = len(is_header)
li_length  = 1 + li_cch

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('C', li_cch)
lb_data = lb_data + blob(is_header)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_footer ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_footer
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    21   //0x0015 Record identifier
uint li_length           //Number of bytes to follow
blob lb_header
blob lb_data
uint li_cch

li_cch = len(is_footer)
li_length  = 1 + li_cch

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('C', li_cch)
lb_data = lb_data + blob(is_footer)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_hcenter ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_hcenter
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   131   //0x0083 Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', ii_hcenter)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_vcenter ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_vcenter
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   132   //0x0084 Record identifier

uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', ii_vcenter)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_margin_left ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_margin_left
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////
int li_ret = 1
uint li_record =    38   //0x0026 Record identifier
uint li_length =     8   //0x0008 Number of bytes to follow
blob lb_header
blob lb_data
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('d', id_margin_left)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_margin_right ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_margin_right
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    39   //0x0027 Record identifier
uint li_length =     8   //0x0008 Number of bytes to follow
blob lb_header
blob lb_data
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('d', id_margin_right)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_margin_top ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_margin_top
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    40   //0x0028 Record identifier
uint li_length =     8   //0x0008 Number of bytes to follow
blob lb_header
blob lb_data
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('d', id_margin_top)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_margin_bottom ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_margin_bottom
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    41   //0x0029 Record identifier
uint li_length =     8   //0x0008 Number of bytes to follow
blob lb_header
blob lb_data
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('d', id_margin_bottom)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_merge_cells (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_cells
//
//	Access: 			protected
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint 
//                ai_last_row  uint
//                ai_last_col  uint
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   229   //0x00E5 Record identifier
uint li_length =    10   //0x000A Number of bytes to follow
blob lb_header
blob lb_data
uint li_clref = 1

uint li_rwFirst
uint li_colFirst
uint li_rwLast
uint li_colLast

li_rwFirst  = ai_first_row             
li_colFirst = ai_first_col             
li_rwLast   = ai_last_row              
li_colLast  = ai_last_col            

if (li_rwFirst = li_rwLast) and (li_colFirst = li_colLast) then return -1

if li_rwFirst > li_rwLast then
   li_rwFirst  = ai_last_row 
   li_rwLast   = ai_first_row             
end if

if li_colFirst > li_colLast then
   li_colFirst  = ai_last_col
   li_colLast   = ai_first_col             
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_clref) +&
            invo_sub.of_pack('v', li_rwFirst) +&
            invo_sub.of_pack('v', li_rwLast) +&
            invo_sub.of_pack('v', li_colFirst) +&
            invo_sub.of_pack('v', li_colLast)

of_append_data(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_print_headers ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_print_headers
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    42   //0x002A Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_fPrintRwCol = 0

if ib_print_headers then li_fPrintRwCol = 1

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_fPrintRwCol) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_print_gridlines ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_print_gridlines
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    43   //0x002B Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_fPrintGrid = 0

if ib_print_gridlines then li_fPrintGrid = 1

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_fPrintGrid) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_gridset ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_gridset
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   130   //0x0082 Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_fGridSet = 0

if not(ib_print_gridlines) then li_fGridSet = 1

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_fGridSet) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_wsbool ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_wsbool
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   129   //0x0081 Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_grbit

//The only option that is of interest is the flag for fit to page. So we
//set all the options in one go.
if ib_fit_page then
   li_grbit =  1473   //0x05c1
else
   li_grbit =   1217   //0x04c1
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_grbit) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_hbreak ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_hbreak
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_tmp[]
uint li_record =    27   //0x001B Record identifier
uint li_length           //  Number of bytes to follow
blob lb_header
blob lb_data
uint li_cbrk
uint li_i

li_tmp = ii_hbreaks
of_sort_pagebreaks(li_tmp)

li_cbrk = UpperBound(li_tmp)
if li_cbrk = 0 then return li_ret
li_length = (li_cbrk + 1) * 2

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_cbrk) 

for li_i = 1 to li_cbrk
    lb_data = lb_data + invo_sub.of_pack('v', li_tmp[li_i]) 
next

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_vbreak ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_vbreak
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_tmp[]
uint li_record =    26   //0x001A Record identifier
uint li_length           //  Number of bytes to follow
blob lb_header
blob lb_data
uint li_cbrk
uint li_i

li_tmp = ii_vbreaks
of_sort_pagebreaks(li_tmp)

li_cbrk = UpperBound(li_tmp)
if li_cbrk = 0 then return li_ret
li_length = (li_cbrk + 1) * 2

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_cbrk) 
for li_i = 1 to li_cbrk
    lb_data = lb_data + invo_sub.of_pack('v', li_tmp[li_i]) 
next

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_protect ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_protect
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    18   //0x0012 Record identifier
uint li_length =      2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_fLock = 0
 
if not(ib_protect) then return li_ret
li_fLock = 1
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_fLock) 

of_append_header(lb_header + lb_data)

return li_ret

end function

protected function integer of_store_password ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_password
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =    19   //0x0013 Record identifier
uint li_length =     2   //0x0002 Number of bytes to follow
blob lb_header
blob lb_data
uint li_wPassword

if not(ib_protect) then return li_ret

li_wPassword = of_encode_password(is_password)

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_wPassword) 

of_append_header(lb_header + lb_data)

return li_ret

end function

public function unsignedinteger of_size_col (unsignedinteger ai_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_size_col
//
//	Access: 			public
//
//	Arguments:	   ai_col uint The number of column
//	
//	Returns:  		uint
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_ind
li_ind = invo_key_col_sizes.of_get_key_index(ai_col)
if li_ind > 0 then
   if id_col_sizes[li_ind] = 0 then 
      return 0
   else
      return ( id_col_sizes[li_ind] * 7 + 5 )
   end if
else
   return 64
end if

end function

public function unsignedinteger of_size_row (unsignedinteger ai_row);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_size_row
//
//	Access: 			public
//
//	Arguments:	   ai_row uint The number of row
//	
//	Returns:  		uint
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_ind
li_ind = invo_key_row_sizes.of_get_key_index(ai_row)
if li_ind > 0 then
   if id_row_sizes[li_ind] = 0 then 
      return 0
   else
      return id_row_sizes[li_ind] * 4/3
   end if
else
   return 17
end if

end function

protected function integer of_store_zoom ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_zoom
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   160   //0x00A0 Record identifier
uint li_length =     4   //0x0004 Number of bytes to follow
blob lb_header
blob lb_data

//If scale is 100 we don't need to write a record
if ii_zoom = 100 then return li_ret

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', ii_zoom) +&
            invo_sub.of_pack('v', 100) 

of_append_data(lb_header + lb_data)

return li_ret

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                adb_num     double
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   515  //0x0203 Record identifier
uint li_length =   14   //0x000E Number of bytes to follow
uint li_xf
blob lb_header
blob lb_data


n_xls_format_v5 lnvo_format

lnvo_format = anvo_format
li_xf = of_xf(ai_row, ai_col, lnvo_format )

if of_check_dimensions(ai_row, ai_col) <> 1 then li_ret = -2

if li_ret = 1 then
   lb_header = invo_sub.of_pack('v', li_record) +&
               invo_sub.of_pack('v', li_length) 
   lb_data   = invo_sub.of_pack('v', ai_row) +&
               invo_sub.of_pack('v', ai_col) +&
               invo_sub.of_pack('v', li_xf) +&
               invo_sub.of_pack('d', adb_num) 
   of_append_data(lb_header + lb_data)
end if
return li_ret

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                as_str      string
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   516  //0x0204 Record identifier
uint li_length          //Number of bytes to follow 8 + len(as_str)
uint li_xf
uint li_strlen

blob lb_header
blob lb_data
n_xls_format_v5 lnvo_format

if isNull(as_str) then as_str = ''
as_str = invo_sub.of_str2xls(as_str)
li_strlen = len(as_str)

if (li_strlen > il_xls_strmax) then //LABEL must be < 255 chars
    li_strlen = il_xls_strmax
    as_str = left(as_str, li_strlen)
end if

li_length = 8 + li_strlen

lnvo_format = anvo_format
li_xf = of_xf(ai_row, ai_col, lnvo_format )

if of_check_dimensions(ai_row, ai_col) <> 1 then li_ret = -2


if li_ret = 1 then
   lb_header = invo_sub.of_pack('v', li_record) +&
               invo_sub.of_pack('v', li_length) 
   lb_data   = invo_sub.of_pack('v', ai_row) +&
               invo_sub.of_pack('v', ai_col) +&
               invo_sub.of_pack('v', li_xf) +&
               invo_sub.of_pack('v', li_strlen) 
   lb_data =  lb_data + blob(as_str)
   of_append_data(lb_header + lb_data)
end if

return li_ret

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                ad_datetime datetime
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

double ld_val
time lt_time
string ls_time
int li_hour, li_minute, li_second

lt_time = time(adt_datetime)
//-- 09.09.2004 bug fixed function time(...)
ls_time = string(lt_time)
lt_time = time(ls_time)
//--
li_hour   = hour(lt_time)
li_minute = minute(lt_time)
li_second = second(lt_time)

ld_val = daysafter(1899-12-30, date(adt_datetime)) + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
return of_write(ai_row, ai_col,ld_val, anvo_format)

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                ad_date     date
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

double ld_val = 0        
ld_val = daysafter(1899-12-30, ad_date)
                      
return of_write(ai_row, ai_col, ld_val, anvo_format)

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record =   513  //0x0201 Record identifier
uint li_length =   6   //0x0006 Number of bytes to follow
uint li_xf
blob lb_header
blob lb_data

n_xls_format_v5 lnvo_format

lnvo_format = anvo_format
li_xf = of_xf(ai_row, ai_col, lnvo_format )

if of_check_dimensions(ai_row, ai_col) <> 1 then li_ret = -2

if li_ret = 1 then
   lb_header = invo_sub.of_pack('v', li_record) +&
               invo_sub.of_pack('v', li_length) 
   lb_data   = invo_sub.of_pack('v', ai_row) +&
               invo_sub.of_pack('v', ai_col) +&
               invo_sub.of_pack('v', li_xf) 
   of_append_data(lb_header + lb_data)
end if
return li_ret

end function

protected function integer of_store_bof (unsignedinteger ai_type);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_bof
//
//	Access: 			protected
//
//	Arguments:	   ai_type uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
uint li_record =  2057   //0x0809 Record identifier
uint li_length =     8   //0x0008 Number of bytes to follow
blob lb_header
blob lb_data
uint li_version

//According to the SDK build and year should be set to zero.
//However, this throws a warning in Excel 5. So, use these
//magic numbers

uint li_build   =  2412    //0x096C
uint li_year    =  1993    //0x07C9

li_version = invo_workbook.ii_biff_version

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', li_version) +&
            invo_sub.of_pack('v', ai_type) +&
            invo_sub.of_pack('v', li_build) +&
            invo_sub.of_pack('v', li_year) 

of_append_header(lb_header + lb_data)
return li_ret

end function

protected function integer of_store_eof ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_eof
//
//	Access: 			protected
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
uint li_record =  10   //0x000A Record identifier
uint li_length =   0   //0x0000 Number of bytes to follow
blob lb_header
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
of_append_data(lb_header)
return li_ret

end function

protected function integer of_append_header (blob ab_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_append_header
//
//	Access: 			protected
//
//	Arguments:	   
//                ab_data blob 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
if len(ab_data) > ii_limit then
   ab_data = of_add_continue(ab_data)
end if
il_datasize += len(ab_data)
invo_header.of_append(ab_data)
return li_ret


end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                at_time     time
//                anvo_format n_xls_format
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

double ld_val
int li_hour, li_minute, li_second

li_hour   = hour(at_time)
li_minute = minute(at_time)
li_second = second(at_time)

ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
return of_write(ai_row, ai_col,ld_val, anvo_format)

end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, time at_time, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_merge_write
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint
//                ai_first_col uint
//                ai_last_row  uint
//                ai_last_col  uint
//                at_time      time
//                anvo_format  n_xls_format
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Write data to the merged cells 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////


double ld_val
int li_hour, li_minute, li_second

li_hour   = hour(at_time)
li_minute = minute(at_time)
li_second = second(at_time)

ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
return of_merge_write(ai_first_row, ai_first_col, ai_last_row, ai_last_col, ld_val, anvo_format)

end function

public function integer of_set_row_format (long al_row, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_row_format
//
//	Access: 			public
//
//	Arguments:	   al_row      long           The number of row
//                anvo_format n_xls_format   A reference to the n_xls_format object 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the default format of a single row 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
uint li_height
boolean lb_hidden

setNull(li_height)
setNull(lb_hidden)

li_ret = of_set_row(al_row, li_height, anvo_format, lb_hidden)

return li_ret

end function

public function integer of_set_row_hidden (long al_row, boolean ab_hidden);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_row_hidden
//
//	Access: 			public
//
//	Arguments:	   al_row      long      The number of row
//                ab_hidden   boolean   A boolean value that controls whether row is hidden 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the option to hide a row 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
uint li_height

setNull(li_height)
setNull(lnvo_format)

li_ret = of_set_row(al_row, li_height, lnvo_format, ab_hidden)
return li_ret

end function

public function integer of_set_column_format (long al_col, n_xls_format anvo_format);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_column_format
//
//	Access: 			public
//
//	Arguments:	   al_col      long          The number of column
//                anvo_format n_xls_format  A reference to the n_xls_format object
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the default format of a single column 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
uint li_width
boolean lb_hidden
ulong ll_i

//find stored col width 
ll_i = invo_key_col_sizes.of_get_key_index(al_col)
if ll_i > 0 then 
   li_width = id_col_sizes[ll_i]   
else
   setNull(li_width)
end if

//find stored col hidden flag
ll_i = invo_key_col_hiddens.of_get_key_index(al_col)
if ll_i > 0 then 
   lb_hidden = ib_col_hiddens[ll_i]   
else
   setNull(lb_hidden)
end if

li_ret = of_set_column(al_col, al_col, li_width, anvo_format, lb_hidden)

return li_ret

end function

public function integer of_set_column_hidden (long al_col, boolean ab_hidden);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_column_hidden
//
//	Access: 			public
//
//	Arguments:	   al_col      long     The number of column
//                ab_hidden   boolean  A boolean value that controls whether 
//                                     column is hidden
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the option to hide a column 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
uint li_width
ulong ll_i

//find stored col format
ll_i = invo_key_col_formats.of_get_key_index(al_col)
if ll_i > 0 then 
   lnvo_format = invo_col_formats[ll_i]   
else
   setNull(lnvo_format)
end if

//find stored col width 
ll_i = invo_key_col_sizes.of_get_key_index(al_col)
if ll_i > 0 then 
   li_width = id_col_sizes[ll_i]   
else
   setNull(li_width)
end if


li_ret = of_set_column(al_col, al_col, li_width, lnvo_format, ab_hidden)
return li_ret

end function

public function integer of_write_data (olestream astr_book);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write_data
//
//	Access: 			public
//
//	Arguments:	   astr_book olestream
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
 invo_header.of_write(astr_book)
 invo_data.of_write(astr_book)
return li_ret

end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                adb_num     double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, adb_num, lnvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                as_str      string
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, as_str, lnvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                at_time     time
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, at_time, lnvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                ad_datetime datetime
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, adt_datetime, lnvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//                ad_date     date
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, ad_date, lnvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_write
//
//	Access: 			public
//
//	Arguments:	   ai_row      uint   The number of row
//                ai_col      uint   The number of column
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Write data to the cell  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

n_xls_format_v5 lnvo_format
SetNull(lnvo_format)
return of_write(ai_row, ai_col, lnvo_format)
end function

public function string of_get_name ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_get_name
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		string
//
//	Description:  This method is used for retrieving worksheet's name
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return this.is_worksheetname
end function

public function integer of_activate ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_activate
//
//	Access: 			public
//
//	Arguments:	   No
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Specify which worksheet is initially visible in a multi-sheet workbook.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret 
li_ret = of_select()
if li_ret = 1 then
   invo_workbook.ii_activesheet = this.ii_index
end if
return li_ret

end function

public function integer of_set_first_sheet ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_first_sheet
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Specify which worksheet is the leftmost visible 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
invo_workbook.ii_firstsheet = this.ii_index 
return li_ret

end function

public function integer of_protect (string as_password);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_protect
//
//	Access: 			public
//
//	Arguments:	   as_password string 
//       
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Protect a worksheet from modification
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
ib_protect = true
is_password = as_password
return li_ret

end function

public function integer of_set_selection (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_selection
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint The number of first row in the range
//                ai_first_col uint The number of first column in the range
//                ai_last_row  uint The number of last row in the range
//                ai_last_col  uint The number of last column in the range
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Specify which cell or cells are selected in a worksheet  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
invo_selection.ii_first_row = ai_first_row
invo_selection.ii_last_row = ai_last_row
invo_selection.ii_first_col = ai_first_col
invo_selection.ii_last_col = ai_last_col
return li_ret

end function

public function integer of_set_selection (unsignedinteger ai_row, unsignedinteger ai_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_selection
//
//	Access: 			public
//
//	Arguments:	   ai_row uint The number of row
//                ai_col uint The number of column
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Specify which cell is selected in a worksheet  
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
invo_selection.ii_first_row = ai_row
invo_selection.ii_last_row = ai_row
invo_selection.ii_first_col = ai_col
invo_selection.ii_last_col = ai_col
return li_ret

end function

public function integer of_thaw_panes (double ad_y, double ad_x, unsignedinteger ai_rowtop, unsignedinteger ai_colleft);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_thaw_panes
//
//	Access: 			public
//
//	Arguments:	   ad_y        double  The vertical position of the split
//                ad_x        double  The horizontal position of the split
//                ai_rowtop   uint    The top-most visible row in the 
//                                    scrolling region of the panes 
//                ai_colleft  uint    The left-most visible column in the
//                                    scrolling region of the panes 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
// Description:   Divide a worksheet into horizontal or vertical regions known
//                as panes. This method is different from the of_freeze_panes()
//                method in that the splits between the panes will be visible 
//                to the user and each pane will have its own scroll bars
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////


int li_ret = 1
if isNull(invo_panes) then
   invo_panes = create n_xls_panes
end if

invo_panes.id_y = ad_y
invo_panes.id_x = ad_x
invo_panes.ii_rowTop = ai_rowTop
invo_panes.ii_colLeft = ai_colLeft

ib_frozen = false

return li_ret

end function

public function integer of_freeze_panes (unsignedinteger ai_row, unsignedinteger ai_col, unsignedinteger ai_rowtop, unsignedinteger ai_colleft);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_freeze_panes
//
//	Access: 			public
//
//	Arguments:	   
//                ai_row      uint
//                ai_col      uint  
//                ai_rowtop   uint
//                ai_colleft  uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description: Divide a worksheet into horizontal or vertical regions known
//              as panes and to also "freeze" these panes so that the splitter
//              bars are not visible 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
if isNull(invo_panes) then
   invo_panes = create n_xls_panes
end if

invo_panes.id_y = ai_row
invo_panes.id_x = ai_col
invo_panes.ii_rowTop = ai_rowTop
invo_panes.ii_colLeft = ai_colLeft

ib_frozen = true

return li_ret

end function

public function integer of_set_portrait ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_portrait
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the orientation of a worksheet's printed page to portrait
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
ii_orientation = 1
return li_ret

end function

public function integer of_set_landscape ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_landscape
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the orientation of a worksheet's printed page to landscape
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
ii_orientation = 0
return li_ret

end function

public function integer of_set_paper (unsignedinteger ai_paper_size);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_paper
//
//	Access: 			public
//
//	Arguments:	   ai_paper_size uint 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the paper format for the printed output 
//                of a worksheet 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
ii_paper_size = ai_paper_size

return li_ret

end function

public function integer of_set_paper ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_paper
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the printer default paper format for the printed output 
//                of a worksheet 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_set_paper(0)
end function

public function integer of_set_header (string as_header, double ad_margin_head);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_header
//
//	Access: 			public
//
//	Arguments:	   as_header      string  A string whose value is the page header
//                ad_margin_head double  A double whose value is the header
//                                       margin in inches
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the page header
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1

if len(as_header) >= 255 then
  //Header string must be less than 255 characters 
   	 
   	
      MessageBox('Error', 'Header string must be less than 255 characters', StopSign!)
   	
  li_ret = -1
end if  

if li_ret = 1 then
   is_header = as_header
   if isNull(ad_margin_head) then
      id_margin_head = 0.50
   else
      id_margin_head = ad_margin_head
   end if 
end if

return li_ret
end function

public function integer of_set_footer (string as_footer, double ad_margin_foot);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_footer
//
//	Access: 			public
//
//	Arguments:	   as_footer      string  A string whose value is the page footer
//                ad_margin_foot double  A double whose value is the footer
//                                       margin in inches
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the page footer 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1

if len(as_footer) >= 255 then
   	 
   	
      MessageBox('Error', 'Footer string must be less than 255 characters', StopSign!)
   	

  //Footer string must be less than 255 characters 
  li_ret = -1
end if  

if li_ret = 1 then
   is_footer = as_footer
   if isNull(ad_margin_foot) then
      id_margin_foot = 0.50
   else
      id_margin_foot = ad_margin_foot
   end if 
end if

return li_ret

end function

public function integer of_center_horizontally ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_center_horizontally
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Center the worksheet data horizontally between
//               the margins on the printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_center_horizontally ( true )

end function

public function integer of_center_horizontally (boolean ab_option);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_center_horizontally
//
//	Access: 			public
//
//	Arguments:	   ab_option boolean
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Center the worksheet data horizontally between
//               the margins on the printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
if ab_option then ii_hcenter = 1 else ii_hcenter = 0
return li_ret

end function

public function integer of_center_vertically ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_center_vertically
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Center the worksheet data vertically between the margins
//               on the printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_center_vertically ( true )


end function

public function integer of_center_vertically (boolean ab_option);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_center_vertically
//
//	Access: 			public
//
//	Arguments:	   ab_option boolean 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Center the worksheet data vertically between the margins
//               on the printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
if ab_option then ii_vcenter = 1 else ii_vcenter = 0
return li_ret


end function

public function integer of_set_margins (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margins
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the all worksheet margins to the same value
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

of_set_margin_left(ad_margin)
of_set_margin_right(ad_margin)
of_set_margin_top(ad_margin)
of_set_margin_bottom(ad_margin)
return 1

end function

public function integer of_set_margins_lr (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margins_lr
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the left and right worksheet margins to the same value
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

of_set_margin_left(ad_margin)
of_set_margin_right(ad_margin)

return 1

end function

public function integer of_set_margins_tb (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margins_tb
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the top and bottom worksheet margins to the same value
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

of_set_margin_top(ad_margin)
of_set_margin_bottom(ad_margin)

return 1

end function

public function integer of_set_margin_left (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margin_left
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the left margin of worksheet's printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

id_margin_left = ad_margin
return 1

end function

public function integer of_set_margin_right (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margin_right
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the right margin of worksheet's printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

id_margin_right = ad_margin
return 1

end function

public function integer of_set_margin_top (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margin_top
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the top margin of worksheet's printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

id_margin_top = ad_margin
return 1

end function

public function integer of_set_margin_bottom (double ad_margin);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_margin_bottom
//
//	Access: 			public
//
//	Arguments:	   ad_margin  double
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the bottom margin of worksheet's printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

id_margin_bottom = ad_margin
return 1

end function

public function integer of_repeat_rows (unsignedinteger ai_first_row, unsignedinteger ai_last_row);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_repeat_rows
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint  the number of first row
//                ai_last_row  uint  the number of last row  
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Set the number of rows to repeat at the top of each printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ii_title_rowmin = ai_first_row
ii_title_rowmax = ai_last_row
return 1

end function

public function integer of_repeat_columns (unsignedinteger ai_first_col, unsignedinteger ai_last_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_repeat_columns
//
//	Access: 			public
//
//	Arguments:	   ai_first_col uint  the number of first column
//                ai_last_col  uint  the number of last column  
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Set the columns to repeat at the left hand side of each printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ii_title_colmin = ai_first_col
ii_title_colmax = ai_last_col
return 1

end function

public function integer of_print_area (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_print_area
//
//	Access: 			public
//
//	Arguments:	   ai_first_row uint  The number of first row in the range
//                ai_first_col uint  The number of first column in the range
//                ai_last_row  uint  The number of last row in the range
//                ai_last_col  uint  The number of last column in the range
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Specify the area of the worksheet that will be printed 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1

ii_print_rowmin = ai_first_row
ii_print_colmin = ai_first_col
ii_print_rowmax = ai_last_row
ii_print_colmax = ai_last_col

return li_ret

end function

public function integer of_hide_gridlines (unsignedinteger ai_option);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_hide_gridlines
//
//	Access: 			public
//
//	Arguments:	   ai_option uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Hide the gridlines on the screen and printed page. 
//               Gridlines are the lines that divide the cells on a worksheet. 
//               Screen and printed gridlines are turned on by default in an Excel
//               worksheet. If you have defined your own cell borders you may wish
//               to hide the default gridlines
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
choose case ai_option
  case 0
    ib_print_gridlines = true
    ib_screen_gridlines= true
  case 1
    ib_print_gridlines = false
    ib_screen_gridlines= true
  case else 
    ib_print_gridlines = false
    ib_screen_gridlines= false
end choose
return li_ret

end function

public function integer of_print_row_col_headers (boolean ab_print_headers);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_print_row_col_headers
//
//	Access: 			public
//
//	Arguments:	   ab_print_headers boolean
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the option to print the row and column headers on
//                the printed page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ib_print_headers = ab_print_headers
return 1

end function

public function integer of_fit_to_pages (unsignedinteger ai_width, unsignedinteger ai_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_fit_to_pages
//
//	Access: 			public
//
//	Arguments:	   ai_width uint   The integer whose value is the number 
//                                of pages horizontally
//                ai_height uint  The integer whose value is the number 
//                                of pages vertically
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description: Fit the printed area to a specific number of pages both
//              vertically and horizontally. If the printed area exceeds
//              the specified number of pages it will be scaled down to fit.
//              This guarantees that the printed area will always appear on
//              the specified number of pages even if the page size or margins
//              change 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
ib_fit_page = true
ii_fit_width = ai_width
ii_fit_height = ai_height
return li_ret

end function

public function integer of_add_h_pagebreak (unsignedinteger ai_hbreak);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_add_h_pagebreak
//
//	Access: 			public
//
//	Arguments:	   
//                ai_hbreak uint - The unsigned integer whose value is the row 
//                                 of page break
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Add horizontal page break to a worksheet. 
//               A page break causes all the data that follows 
//               it to be printed on the next page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ii_hbreaks[upperbound(ii_hbreaks) + 1] = ai_hbreak
return 1

end function

public function integer of_add_v_pagebreak (unsignedinteger ai_vbreak);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_add_v_pagebreak
//
//	Access: 			public
//
//	Arguments:	   
//                ai_vbreak uint - The unsigned integer whose value is the column 
//                                 of page break
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Add vertical page break to a worksheet. 
//               A page break causes all the data that follows 
//               it to be printed on the next page
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ii_vbreaks[upperbound(ii_vbreaks) + 1] = ai_vbreak
return 1

end function

public function integer of_set_zoom (unsignedinteger ai_scale);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_zoom
//
//	Access: 			public
//
//	Arguments:	   ai_scale uint The unsigned integer whose value is the zoom
//                              factor. Zoom factors in the range
//                              10 <= scale <= 400 are valid
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Set the worksheet zoom factor in the range 10 <= scale <= 400
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
//Confine the scale to Excel's range
if (ai_scale < 10) or (ai_scale > 400) then
   	 
   	
      MessageBox('Error', 'Zoom factor outside range: 10-400', StopSign!)
   	
   //Zoom factor $scale outside range: 10 <= zoom <= 400
   li_ret = -1
end if
if li_ret = 1 then
  ii_zoom = ai_scale
end if 
return li_ret

end function

public function integer of_set_print_scale (unsignedinteger ai_scale);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_print_scale
//
//	Access: 			public
//
//	Arguments:	   ai_scale uint The unsigned integer whose value is the scale
//                factor. Scale factors in the range 10 <= scale <= 400 are valid
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Set the scale factor of the printed page 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
//Confine the scale to Excel's range
if (ai_scale < 10) or (ai_scale > 400) then
   	 
   	
      MessageBox('Error', 'Print scale scale outside range: 10-400', StopSign!)
   	
   //Print scale scale outside range: 10 <= zoom <= 400
   li_ret = -1
end if
if li_ret = 1 then
   //Turn off "fit to page" option
   ib_fit_page    = false
   ii_print_scale = ai_scale
end if 
return li_ret
end function

public function blob of_get_data ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_get_data
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		blob
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

blob lb_tmp
if isNull( ib_data ) then
   return ib_data
else
   lb_tmp = ib_data
   SetNull(ib_data)
   return lb_tmp
end if

end function

protected function unsignedlong of_encode_password (string as_password);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_encode_password
//
//	Access: 			protected
//
//	Arguments:	   as_password string
//       
//	Returns:  		unsignedlong
//
//	Description:  encode password string to unsigned long value
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

ulong ll_ret
ulong ll_chars[]
uint li_count
uint li_i
ulong ll_low, ll_high

li_count = len(as_password)
if li_count > 0 then
	for li_i = 1 to li_count
		 ll_chars[li_i] = uf_bitshl(asc(mid(as_password, li_i, 1)), li_i)
		 ll_low  = uf_bitand(ll_chars[li_i], 32767)
		 ll_high = uf_bitshr(uf_bitand(ll_chars[li_i], uf_bitshl(32767, 15)), 15)
		 ll_chars[li_i] = uf_bitor(ll_low, ll_high)
	next
	
	ll_ret = 0
	for li_i = 1 to li_count
		ll_ret = uf_bitxor(ll_ret, ll_chars[li_i])
	next
	ll_ret = uf_bitxor(ll_ret, li_count)
	ll_ret = uf_bitxor(ll_ret, 52811)   /*0xCE4B*/
else
	ll_ret = 0
end if

return ll_ret

end function

public function integer of_set_row_height (long al_row, double ad_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_row_height
//
//	Access: 			public
//
//	Arguments:	   al_row      long     The number of row
//                ad_height   double   The double whose value is the height 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the height of a single row
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
boolean lb_hidden

setNull(lnvo_format)
setNull(lb_hidden)

li_ret = of_set_row(al_row, ad_height, lnvo_format, lb_hidden)

return li_ret

end function

public function integer of_set_row (unsignedinteger ai_row, double ad_height, n_xls_format_v5 anvo_format, boolean ab_hidden);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_row
//
//	Access: 			public
//
//	Arguments:	   ai_firstrow uint
//                ai_lastrow  uint
//                ad_height   double
//                anvo_format n_xls_format_v5
//                ab_hidden   boolean
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
uint li_record  =  520 //0x0208 Record identifier
uint li_length  =   16 //0x0010 Number of bytes to follow
uint li_colMic  =    0 //0x0000 First defined column
uint li_colMac  =    0 //0x0000 Last defined column
uint li_irwMac  =    0 //0x0000 Used by Excel to optimise loading
uint li_reserved =   0 //0x0000 Reserved
uint li_grbit   =  320 //0x0140 Options: fUnsynced 
uint li_ixfe    =   15 //0x0F   XF index
uint li_miyRw   =  255 //0xFF 
blob lb_header
blob lb_data
ulong ll_i
boolean lb_format_undef = false

//Check for a format object
if Not(isNull(anvo_format)) then
   if isValid(anvo_format) then
      li_ixfe = invo_workbook.of_reg_format(anvo_format)
      li_grbit +=  128  //0x80
   else
      lb_format_undef = true
   end if
else
   lb_format_undef = true
end if

if lb_format_undef then
   //find stored row format
   ll_i = invo_key_row_formats.of_get_key_index(ai_row)
   if ll_i > 0 then 
      li_ixfe = invo_workbook.of_reg_format(invo_row_formats[ll_i])
      li_grbit +=  128  //0x80 
   end if
end if

if Not(isNull(ad_height)) then
   li_miyRw = of_get_excel_height(ad_height)
else 
   //find stored row height
   ll_i = invo_key_row_sizes.of_get_key_index(ai_row)
   if ll_i > 0 then 
      li_miyRw = id_row_sizes[ll_i] * 20
   end if
end if

if isNull(ab_hidden) then
   //find stored row hidden
   ll_i = invo_key_row_hiddens.of_get_key_index(ai_row)
   if ll_i > 0 then 
      if ib_row_hiddens[ll_i] then 
         //Set the options flags
         li_grbit +=  32  //0x20
      end if
   end if
else
   if ab_hidden then
      //Set the options flags
      li_grbit +=  32  //0x20
   end if
end if

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
lb_data   = invo_sub.of_pack('v', ai_row) +&
            invo_sub.of_pack('v', li_colMic) +&
            invo_sub.of_pack('v', li_colMac) +&
            invo_sub.of_pack('v', li_miyRw) +&
            invo_sub.of_pack('v', li_irwMac) +&
            invo_sub.of_pack('v', li_reserved) +&
            invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('v', li_ixfe)

of_append_data(lb_header + lb_data)

//Store the row sizes for use when calculating image vertices.
//Also store the column formats.

if not(isNull(ab_hidden)) then
   ll_i = invo_key_row_hiddens.of_get_key_index(ai_row)
   if ll_i = 0 then ll_i = invo_key_row_hiddens.of_add_key(ai_row) 
   ib_row_hiddens[ll_i] = ab_hidden
end if

if not(isNull(ad_height)) then
   ll_i = invo_key_row_sizes.of_get_key_index(ai_row)
   if ll_i = 0 then ll_i = invo_key_row_sizes.of_add_key(ai_row) 
   id_row_sizes[ll_i] = ad_height
end if

if not(isNull(anvo_format)) then
   if isValid(anvo_format) then
     ll_i = invo_key_row_formats.of_get_key_index(ai_row)
     if ll_i = 0 then ll_i = invo_key_row_formats.of_add_key(ai_row) 
     invo_row_formats[ll_i] = anvo_format
   end if
end if

return li_ret

end function

public function integer of_set_column_width (long al_col, double ad_width);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_column_width
//
//	Access: 			public
//
//	Arguments:	   al_col      long     The number of column
//                ad_width    double   The double whose value is the width 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the width of a single column
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
boolean lb_hidden
ulong ll_i

//find stored col format
ll_i = invo_key_col_formats.of_get_key_index(al_col)
if ll_i > 0 then 
   lnvo_format = invo_col_formats[ll_i]   
else
   setNull(lnvo_format)
end if


//find stored col hidden flag
ll_i = invo_key_col_hiddens.of_get_key_index(al_col)
if ll_i > 0 then 
   lb_hidden = ib_col_hiddens[ll_i]   
else
   setNull(lb_hidden)
end if

li_ret = of_set_column(al_col, al_col, ad_width, lnvo_format, lb_hidden)

return li_ret

end function

public function integer of_set_column (unsignedinteger ai_firstcol, unsignedinteger ai_lastcol, double ad_width, n_xls_format anvo_format, boolean ab_hidden);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_column
//
//	Access: 			public
//
//	Arguments:	   ai_firstcol uint
//                ai_lastcol  uint
//                ad_width    double
//                anvo_format n_xls_format
//                ab_hidden   boolean
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int li_ret = 1
double ld_width
uint li_i
ulong ll_key
n_xls_colinfo lnvo_colinfo
n_xls_format_v5 lnvo_format

lnvo_colinfo = create n_xls_colinfo
lnvo_colinfo.ii_firstcol = ai_firstcol
lnvo_colinfo.ii_lastcol  = ai_lastcol
lnvo_colinfo.id_width    = ad_width

if not(isNull(anvo_format)) then
	if isValid(anvo_format) then
		lnvo_format = create n_xls_format_v5
		lnvo_format.of_copy(anvo_format)
		invo_workbook.of_reg_format(lnvo_format)
	else
		setnull(lnvo_format)
	end if
else
	setnull(lnvo_format)
end if

lnvo_colinfo.invo_format = lnvo_format
lnvo_colinfo.ib_hidden   = ab_hidden

invo_colinfo[UpperBound(invo_colinfo) + 1] = lnvo_colinfo

//Store the col sizes for use when calculating image vertices taking
//hidden columns into account. Also store the column formats.
if ab_hidden then
   ld_width = 0
else
   ld_width = ad_width
end if

for li_i = ai_firstcol to ai_lastcol
    ll_key = invo_key_col_sizes.of_find_key(li_i)  
    if ll_key < 1 then ll_key = invo_key_col_sizes.of_add_key( li_i )  
    id_col_sizes[ll_key] = ad_width 
next

if not(isNull(ab_hidden)) then
   for li_i = ai_firstcol to ai_lastcol
        ll_key = invo_key_col_hiddens.of_find_key(li_i)  
        if ll_key < 1 then ll_key = invo_key_col_hiddens.of_add_key( li_i )  
        ib_col_hiddens[ll_key] = ab_hidden   //ld_width
   next
end if

if Not(isNull(anvo_format)) then
   if isValid(anvo_format) then
      for li_i = ai_firstcol to ai_lastcol
          ll_key = invo_key_col_formats.of_find_key(li_i)  
          if ll_key < 1 then ll_key = invo_key_col_formats.of_add_key( li_i )  
          invo_col_formats[ll_key] = anvo_format
      next
   end if
end if
return li_ret

end function

public function integer of_set_column_width (long al_col, long al_width);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_column_width
//
//	Access: 			public
//
//	Arguments:	   al_col      long     The number of column
//                al_width    long     The long whose value is the width 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the width of a single column
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
boolean lb_hidden
ulong ll_i

//find stored col format
ll_i = invo_key_col_formats.of_get_key_index(al_col)
if ll_i > 0 then 
   lnvo_format = invo_col_formats[ll_i]   
else
   setNull(lnvo_format)
end if


//find stored col hidden flag
ll_i = invo_key_col_hiddens.of_get_key_index(al_col)
if ll_i > 0 then 
   lb_hidden = ib_col_hiddens[ll_i]   
else
   setNull(lb_hidden)
end if

li_ret = of_set_column(al_col, al_col, al_width, lnvo_format, lb_hidden)

return li_ret

end function

public function integer of_set_row_height (long al_row, long al_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_set_row_height
//
//	Access: 			public
//
//	Arguments:	   al_row      long     The number of row
//                al_height   long     The long whose value is the height 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:   Set the height of a single row
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

int  li_ret = 1
n_xls_format_v5 lnvo_format
boolean lb_hidden

setNull(lnvo_format)
setNull(lb_hidden)

li_ret = of_set_row(al_row, al_height, lnvo_format, lb_hidden)

return li_ret

end function

protected function integer of_process_bitmap (readonly string as_bitmap_filename, ref long al_width, ref long al_height, ref long al_size, ref blob ab_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_process_bitmap
//
//	Access: 			protected
//
//	Arguments:	   as_bitmap_filename string
//                al_width           long
//                al_height          long
//                al_size            long
//                ab_data            blob
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////


integer li_ret = 1
integer li_file
blob lb_data_item
blob lb_data
ulong ll_size
uint li_planes, li_bitcount
ulong ll_compression
blob lb_header

//read bitmap into blob

li_file = FileOpen(as_bitmap_filename, StreamMode!, Read!, LockWrite!)
if li_file <> -1 then
	setnull(lb_data)
	
	do while FileRead(li_file, lb_data_item) > 0 
		if isNull(lb_data) then 
			lb_data = lb_data_item
		else
			lb_data +=  lb_data_item
		end if
	loop

   if isNull(lb_data) then li_ret = -1

	FileClose(li_file)
else
	li_ret = -1
	MessageBox('Error', 'Couldn~'t open ' + as_bitmap_filename, StopSign!)
end if


if li_ret = 1 then
	//check data size
   if len(lb_data) <= 54 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' doesn~'t contain enough data', StopSign!)
	end if
end if

if li_ret = 1 then
	//check bitmap header
	if string(blobmid(lb_data, 1, 2)) <> 'BM' then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' doesn~'t appear to to be a valid bitmap image', StopSign!)
	end if
end if

if li_ret = 1 then
	//read bitmap size
	ll_size = long(blobmid(lb_data, 3, 4)) 
	ll_size -= 54 - 12  //subtract size of bitmap header and add size of biff header
	
   
	//Read bitmap width and height
	al_width = long(blobmid(lb_data, 19, 4))
	al_height = long(blobmid(lb_data, 23, 4))
	
	if al_width > 65535 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': largest image width supported is 65535', StopSign!)
   end if
end if

if li_ret = 1 then
	if al_height > 65535 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': largest image height supported is 65535', StopSign!)
   end if
end if

if li_ret = 1 then
	li_planes = integer(blobmid(lb_data, 27, 2))
	li_bitcount = integer(blobmid(lb_data, 29, 2))

   if li_bitcount <> 24 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' isn~'t a 24bit true color bitmap', StopSign!)
   end if
end if

if li_ret = 1 then
   if li_planes <> 1 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': only 1 plane supported in bitmap image', StopSign!)
   end if
end if

if li_ret = 1 then
	ll_compression = long(blobmid(lb_data, 31, 4))
   if ll_compression <> 0 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': compression not supported in bitmap image', StopSign!)
   end if
end if

if li_ret = 1 then
	 
	lb_header = invo_sub.of_pack('V', 12)  /*0x000C*/ +&
	            invo_sub.of_pack('v', al_width) +&
	            invo_sub.of_pack('v', al_height) +&
	            invo_sub.of_pack('v', 1)  /*0x01*/ +&    
	            invo_sub.of_pack('v', 24) /*0x18*/ 
   ab_data = lb_header + blobmid(lb_data, 55, len(lb_data) - 55 + 1)
	al_size = ll_size
end if

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//                ai_x                uint    The unsigned integer whose value is the horizontal
//                                            offset from the top left hand corner of the the cell
//                                            specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ai_y                uint    The unsigned integer whose value is the vertical
//                                            offset from the top left hand corner of the the
//                                            cell specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ad_scale_width      double  The double whose value is the horizontal scale factor.
//                ad_scale_height     double  The double whose value is the vertical scale factor. 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
long li_width, li_height, li_size
blob lb_data
blob lb_header

li_ret = of_process_bitmap(as_bitmap_filename, li_width, li_height, li_size, lb_data)
   
if li_ret = 1 then
	li_width *= ad_scale_width
	li_height *= ad_scale_height
	li_ret = of_position_image(ai_col, ai_row, ai_x, ai_y, li_width , li_height)
end if

if li_ret = 1 then
	lb_header = invo_sub.of_pack('v', 127)           /*record 0x007f*/ +&
               invo_sub.of_pack('v', 8 + li_size)   /*length*/ +&
               invo_sub.of_pack('v', 9)             /*cf*/ +&
               invo_sub.of_pack('v', 1)             /*env*/ +&
               invo_sub.of_pack('V', li_size)       /*size*/ 
	of_append_data(lb_header + lb_data)				
end if

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//                ai_x                uint    The unsigned integer whose value is the horizontal
//                                            offset from the top left hand corner of the the cell
//                                            specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ai_y                uint    The unsigned integer whose value is the vertical
//                                            offset from the top left hand corner of the the
//                                            cell specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_insert_bitmap(ai_row, ai_col, as_bitmap_filename, ai_x, ai_y, 1, 1)
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_insert_bitmap(ai_row, ai_col, as_bitmap_filename, 0, 0, 1, 1)
end function

public function integer of_position_image (unsignedinteger ai_col_start, unsignedinteger ai_row_start, unsignedinteger ai_x1, unsignedinteger ai_y1, unsignedinteger ai_width, unsignedinteger ai_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_position_image
//
//	Access: 			public
//
//	Arguments:	   ai_col_start   uint
//                ai_row_start   uint
//                ai_x1          uint 
//                ai_y1          uint
//                ai_width       uint
//                ai_height      uint 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
uint li_col_end
uint li_row_end
uint li_x2, li_y2

li_col_end = ai_col_start
li_row_end = ai_row_start

if ai_x1 >= of_size_col(ai_col_start) then ai_x1 = 0
if ai_y1 >= of_size_row(ai_row_start) then ai_y1 = 0

ai_width = ai_width + ai_x1 - 1
ai_height = ai_height + ai_y1 - 1

//Subtract the underlying cell widths to find the end cell of the image
do while ai_width >= of_size_col(li_col_end)
   ai_width -= of_size_col(li_col_end)
   li_col_end ++
loop

//Subtract the underlying cell heights to find the end cell of the image
do while ai_height >= of_size_row(li_row_end)
   ai_height -= of_size_row(li_row_end)
   li_row_end ++
loop

//Bitmap isn't allowed to start or finish in a hidden cell, i.e. a cell
//with zero eight or width.

if of_size_col(ai_col_start) = 0 then return -1
if of_size_col(li_col_end) = 0 then return -1
if of_size_row(ai_row_start) = 0 then return -1
if of_size_row(li_row_end) = 0 then return -1

//Convert the pixel values to the percentage value expected by Excel
ai_x1 = (ai_x1 / of_size_col(ai_col_start)) * 1024
ai_y1 = (ai_y1 / of_size_row(ai_row_start)) *  256;
li_x2 = (ai_width / of_size_col(li_col_end)) * 1024
li_y2 = (ai_height / of_size_row(li_row_end)) *  256;

li_ret = of_store_obj_picture(ai_col_start, ai_x1, ai_row_start, ai_y1, li_col_end, li_x2, li_row_end, li_y2)

return li_ret
end function

protected function unsignedinteger of_get_excel_height (double ad_value);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_get_excel_height
//
//	Access: 			protected
//
//	Arguments:	   ad_value double
//	
//	Returns:  		unsignedinteger
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_w1
double ld_w1, ld_w2

li_w1 = truncate(ad_value, 0)
ld_w2 = ad_value - li_w1
ld_w2 = round(ld_w2*4, 0)/4

return (li_w1 + ld_w2) * 20

end function

protected function unsignedinteger of_get_excel_width (double ad_value);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_get_excel_width
//
//	Access: 			protected
//
//	Arguments:	   ad_value double
//	
//	Returns:  		unsignedinteger
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

uint li_w1
double ld_w1, ld_w2
double ld_w

li_w1 = truncate(ad_value, 0)
ld_w2 = ad_value - li_w1

if li_w1 > 0 then 
	ld_w1 = li_w1 + 0.72
else
	ld_w1 = 0
end if

if li_w1 > 0 then
	ld_w = (ld_w1 * 256 + ld_w2 * 256)
else
	ld_w = (ld_w1 * 256 + ld_w2 * 256 * 1.8)
end if
	

return ld_w

end function

public function integer of_select ();//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_select
//
//	Access: 			public
//
//	Arguments:	   No
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  Specify which worksheet is initially selected in a 
//               multi-sheet workbook
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
ib_selected = true
return li_ret

end function

protected function integer of_store_obj_picture (readonly unsignedinteger ai_col_start, readonly unsignedinteger ai_x1, readonly unsignedinteger ai_row_start, readonly unsignedinteger ai_y1, readonly unsignedinteger ai_col_end, readonly unsignedinteger ai_x2, readonly unsignedinteger ai_row_end, readonly unsignedinteger ai_y2);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_obj_picture
//
//	Access: 			protected
//
//	Arguments:	   ai_col_start  uint
//                ai_x1         uint 
//                ai_row_start  uint
//                ai_y1         uint
//                ai_col_end    uint
//                ai_x2         uint
//                ai_row_end    uint
//                ai_y2         uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
blob lb_header

  lb_header = invo_sub.of_pack('v', 93)           /*record 0x005D*/ +&
              invo_sub.of_pack('v', 60)           /*length 0x003С*/ +&
              invo_sub.of_pack('V', 1)            /*Count of objects in file (set to 1)*/ +&
              invo_sub.of_pack('v', 8)            /*Object type. 8 = Picture*/ +&
              invo_sub.of_pack('v', 1)            /*Object ID*/ +&
              invo_sub.of_pack('v', 1556)         /*Option flags 0x0614 */ +&
              invo_sub.of_pack('v', ai_col_start) /*Col containing upper left corner of object */ +&
              invo_sub.of_pack('v', ai_x1)        /*Distance from left side of cell*/ +&
              invo_sub.of_pack('v', ai_row_start) /*Row containing top left corner of object*/ +&
              invo_sub.of_pack('v', ai_y1)        /*Distance from top of cell*/ +&
              invo_sub.of_pack('v', ai_col_end)   /*Col containing lower right corner of object*/ +&
              invo_sub.of_pack('v', ai_x2)        /*Distance from right of cell*/ +&
              invo_sub.of_pack('v', ai_row_end)   /*Row containing bottom right corner of object*/ +&
              invo_sub.of_pack('v', ai_y2)        /*Distance bottom top of cell*/ +&
              invo_sub.of_pack('v', 0)            /*Length of FMLA structure*/ +&
              invo_sub.of_pack('V', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('C', 9)            /*Background colour*/ +&
              invo_sub.of_pack('C', 9)            /*Foreground colour*/ +&
              invo_sub.of_pack('C', 0)            /*Fill pattern*/ +&
              invo_sub.of_pack('C', 0)            /*Automatic fill*/ +&
              invo_sub.of_pack('C', 8)            /*Line colour*/ +&
              invo_sub.of_pack('C', 255)          /*Line style*/ +&
              invo_sub.of_pack('C', 1)            /*Line weight*/ +&
              invo_sub.of_pack('C', 0)            /*Automatic border*/ +&
              invo_sub.of_pack('v', 0)            /*Frame style*/ +&
              invo_sub.of_pack('V', 9)            /*Image format, 9 = bitmap*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 0)            /*Length of FMLA structure*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 1)            /*Option flags*/ +&
              invo_sub.of_pack('V', 0)            /*Reserved*/ 

    of_append_data(lb_header)
return li_ret
end function

event constructor;call super::constructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:   		constructor
//
//	Arguments:	   No
//       
//	Returns:  		Long
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

il_dim_rowmin = il_xls_rowmax + 1
il_dim_colmin = il_xls_colmax + 1

invo_selection = create n_xls_selection 
invo_data = create n_xls_data
invo_header = create n_xls_data
//selection
invo_selection.ii_first_row = 0
invo_selection.ii_last_row = 0
invo_selection.ii_first_col = 0
invo_selection.ii_last_col = 0

SetNull(invo_panes)

SetNull(ii_title_rowmin)
SetNull(ii_title_rowmax)
SetNull(ii_title_colmin)
SetNull(ii_title_colmax)

SetNull(ii_print_rowmin)
SetNull(ii_print_rowmax)
SetNull(ii_print_colmin)
SetNull(ii_print_colmax)

invo_key_col_sizes = create n_associated_ulong_srv 
invo_key_row_sizes = create n_associated_ulong_srv 
invo_key_col_formats = create n_associated_ulong_srv 
invo_key_row_formats = create n_associated_ulong_srv 
invo_key_col_hiddens = create n_associated_ulong_srv 
invo_key_row_hiddens = create n_associated_ulong_srv 

end event

on n_xls_worksheet_v5.create
TriggerEvent( this, "constructor" )
end on

on n_xls_worksheet_v5.destroy
TriggerEvent( this, "destructor" )
end on

