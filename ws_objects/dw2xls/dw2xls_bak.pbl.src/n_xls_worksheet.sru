$PBExportHeader$n_xls_worksheet.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_worksheet from nonvisualobject
end type
type cell_coord from structure within n_xls_worksheet
end type
type cell_info from structure within n_xls_worksheet
end type
end forward

type cell_coord from structure
	long		x1
	long		x2
	long		y1
	long		y2
end type

type cell_info from structure
	long		valuetype
	long		valuesize
end type

global type n_xls_worksheet from nonvisualobject
end type
global n_xls_worksheet n_xls_worksheet

type prototypes
protected function long add_cell_double (ulong storage,double value,long x1,long x2,long y1,long y2,long format,long unit)  library "pb2xls" alias for "add_cell_double"
protected function long add_cell_string (ulong storage,readonly string value,long x1,long x2,long y1,long y2,long format,long unit)  library "pb2xls" alias for "add_cell_string"
protected function long add_h_break (ulong storage,long y,long unit)  library "pb2xls" alias for "add_h_break"
protected function long get_cell_info (ulong storage,long ix,ref cell_info info)  library "pb2xls" alias for "get_cell_info"
protected function long get_cell_double (ulong storage,long ix,ref double value,ref long format,ref cell_coord coord)  library "pb2xls" alias for "get_cell_double"
protected function long get_cell_string (ulong storage,long ix,ref string value,ref long format,ref cell_coord coord)  library "pb2xls" alias for "get_cell_string"
protected subroutine get_y_info (ulong storage,ref long baserow,ref long maxrow)  library "pb2xls" alias for "get_y_info"
protected subroutine get_x_info (ulong storage,ref long basecol,ref long maxcol)  library "pb2xls" alias for "get_x_info"
protected function double get_row_height (ulong storage,long row)  library "pb2xls" alias for "get_row_height"
protected function double get_col_width (ulong storage,long col)  library "pb2xls" alias for "get_col_width"
protected function long update_x (ulong storage)  library "pb2xls" alias for "update_x"
protected function long update_y (ulong storage)  library "pb2xls" alias for "update_y"
protected subroutine prepare_x (ulong storage)  library "pb2xls" alias for "prepare_x"
protected subroutine prepare_y (ulong storage)  library "pb2xls" alias for "prepare_y"
protected function long get_cell_count (ulong storage)  library "pb2xls" alias for "get_cell_count"
protected subroutine begin_band (ulong storage)  library "pb2xls" alias for "begin_band"
protected function long end_band (ulong storage,long units)  library "pb2xls" alias for "end_band"
protected function ulong create_cell_storage () library "pb2xls" alias for "create_cell_storage"
protected subroutine free_cell_storage (ulong storage)  library "pb2xls" alias for "free_cell_storage"
protected function ulong getmodulefilenamea (ulong hinstmodule,ref string lpszpath,ulong cchpath)  library "KERNEL32.DLL" alias for "GetModuleFileNameA"
protected function ulong getmodulefilenamew (ulong hinstmodule,ref string lpszpath,ulong cchpath)  library "KERNEL32.DLL" alias for "GetModuleFileNameW"
protected function ulong loadlibrarya (ref string lplibfilename)  library "KERNEL32.DLL" alias for "LoadLibraryA"
protected function ulong loadlibraryw (ref string lplibfilename)  library "KERNEL32.DLL" alias for "LoadLibraryW"
protected function boolean freelibrary (ref ulong hlibmodule)  library "KERNEL32.DLL" alias for "FreeLibrary"
protected subroutine set_align (ulong storage,double x,double y)  library "pb2xls" alias for "set_align"
protected subroutine set_unit_x_coef (ulong storage,long unit,double coef)  library "pb2xls" alias for "set_unit_x_coef"
protected subroutine set_unit_y_coef (ulong storage,long unit,double coef)  library "pb2xls" alias for "set_unit_y_coef"
end prototypes

type variables
public string is_worksheetname
public n_xls_subroutines_v97 invo_sub
protected ulong iul_cellstorage
protected long type_none
protected long type_double = 1
protected long type_string = 2
protected long type_blob = 3
protected long type_hbreak = 4
protected double id_x_zoom = 1
protected double id_y_zoom = 1
private string _is_value
protected n_dwr_sub inv_unitsub
end variables

forward prototypes
public function integer of_activate ()
public function integer of_add_h_pagebreak (uint ai_hbreak)
public function integer of_add_v_pagebreak (uint ai_vbreak)
public subroutine of_add_y_pagebreak (long al_y,integer ai_unit)
public subroutine of_begin_band ()
public function integer of_center_horizontally ()
public function integer of_center_horizontally (boolean ab_option)
public function integer of_center_vertically ()
public function integer of_center_vertically (boolean ab_option)
public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,date aa_value,n_xls_format anvo_format,integer ai_units)
public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,datetime aa_value,n_xls_format anvo_format,integer ai_units)
public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,double aa_value,n_xls_format anvo_format,integer ai_units)
public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,string aa_value,n_xls_format anvo_format,integer ai_units)
public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,time aa_value,n_xls_format anvo_format,integer ai_units)
public function long of_end_band (integer ai_units)
public function integer of_fit_to_pages (uint ai_width,uint ai_height)
public function integer of_freeze_panes (uint ai_row,uint ai_col,uint ai_rowtop,uint ai_colleft)
public function long of_get_cell_count ()
public function long of_get_column_count ()
public function string of_get_name ()
public function blob of_get_name_unicode ()
public function long of_get_row_count ()
private function string of_getexedir ()
public function integer of_hide_gridlines (uint ai_option)
public subroutine of_initdata ()
private subroutine of_initunitconvertor ()
public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename)
public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename,readonly uint ai_x,readonly uint ai_y)
public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename,readonly uint ai_x,readonly uint ai_y,readonly double ad_scale_width,readonly double ad_scale_height)
public function boolean of_iswidepb ()
private function ulong of_loadlibrary (string as_dll)
protected function integer of_merge_cells (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,blob ab_unicode_str,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,date ad_date,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,datetime adt_datetime,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,double adb_num,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,string as_str,n_xls_format anvo_format)
public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,time at_time,n_xls_format anvo_format)
public function integer of_print_area (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col)
public function integer of_print_row_col_headers (boolean ab_print_headers)
public function integer of_protect (string as_password)
public function integer of_repeat_columns (uint ai_first_col,uint ai_last_col)
public function integer of_repeat_rows (uint ai_first_row,uint ai_last_row)
public function integer of_select ()
public function integer of_set_column (uint ai_firstcol,uint ai_lastcol,double ad_width,n_xls_format anvo_format,boolean ab_hidden)
public function integer of_set_column_format (long al_col,n_xls_format anvo_format)
public function integer of_set_column_hidden (long al_col,boolean ab_hidden)
public function integer of_set_column_width (long al_col,double ad_width)
public function integer of_set_column_width (long al_col,long al_width)
public function integer of_set_first_sheet ()
public function integer of_set_footer (blob ab_footer,double ad_margin_foot)
public function integer of_set_footer (string as_footer,double ad_margin_foot)
public function integer of_set_header (blob ab_header,double ad_margin_head)
public function integer of_set_header (string as_header,double ad_margin_head)
public function integer of_set_landscape ()
public function integer of_set_margin_bottom (double ad_margin)
public function integer of_set_margin_left (double ad_margin)
public function integer of_set_margin_right (double ad_margin)
public function integer of_set_margin_top (double ad_margin)
public function integer of_set_margins (double ad_margin)
public function integer of_set_margins_lr (double ad_margin)
public function integer of_set_margins_tb (double ad_margin)
public subroutine of_set_merge_range (long ai_format)
public function integer of_set_paper ()
public function integer of_set_paper (uint ai_paper_size)
public subroutine of_set_point_to_row_zoom (double ad_x,double ad_y)
public function integer of_set_portrait ()
public function integer of_set_print_scale (uint ai_scale)
public function integer of_set_row_format (long al_row,n_xls_format anvo_format)
public function integer of_set_row_height (long al_row,double ad_height)
public function integer of_set_row_height (long al_row,long al_height)
public function integer of_set_row_hidden (long al_row,boolean ab_hidden)
public function integer of_set_selection (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col)
public function integer of_set_selection (uint ai_row,uint ai_col)
public function integer of_set_zoom (uint ai_scale)
public subroutine of_setalign (double ad_x,double ad_y)
public function integer of_thaw_panes (double ad_y,double ad_x,uint ai_rowtop,uint ai_colleft)
public function integer of_update_x ()
public function long of_update_y ()
public function integer of_write (long ai_row,long ai_col,blob aa_value,long ai_format)
public function integer of_write (long ai_row,long ai_col,double aa_value,long ai_format)
public function integer of_write (long ai_row,long ai_col,string aa_value,long ai_format)
public function integer of_write (uint ai_row,uint ai_col)
public function integer of_write (uint ai_row,uint ai_col,blob ab_unicode_str)
public function integer of_write (uint ai_row,uint ai_col,blob ab_unicode_str,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,date ad_date)
public function integer of_write (uint ai_row,uint ai_col,date ad_date,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,datetime adt_datetime)
public function integer of_write (uint ai_row,uint ai_col,datetime adt_datetime,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,double adb_num)
public function integer of_write (uint ai_row,uint ai_col,double adb_num,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,string as_str)
public function integer of_write (uint ai_row,uint ai_col,string as_str,n_xls_format anvo_format)
public function integer of_write (uint ai_row,uint ai_col,time at_time)
public function integer of_write (uint ai_row,uint ai_col,time at_time,n_xls_format anvo_format)
public function integer of_write_cell (long ai_cell,boolean ab_merge)
protected function integer of_xf (uint ai_row,uint ai_col,n_xls_format anvo_format)
end prototypes

public function integer of_activate ();integer retvar

return retvar
end function

public function integer of_add_h_pagebreak (uint ai_hbreak);integer retvar

return retvar
end function

public function integer of_add_v_pagebreak (uint ai_vbreak);integer retvar

return retvar
end function

public subroutine of_add_y_pagebreak (long al_y,integer ai_unit);add_h_break(iul_cellstorage,al_y,ai_unit)
end subroutine

public subroutine of_begin_band ();begin_band(iul_cellstorage)
end subroutine

public function integer of_center_horizontally ();integer retvar

return retvar
end function

public function integer of_center_horizontally (boolean ab_option);integer retvar

return retvar
end function

public function integer of_center_vertically ();integer retvar

return retvar
end function

public function integer of_center_vertically (boolean ab_option);integer retvar

return retvar
end function

public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,date aa_value,n_xls_format anvo_format,integer ai_units);long li_xf
double ld_val
long lul_cell

if (( not isnull(anvo_format)) and isvalid(anvo_format)) then
	li_xf = of_xf(-1,-1,anvo_format)
else
	return -1
end if

ld_val = daysafter(1899-12-30,aa_value)
lul_cell = add_cell_double(iul_cellstorage,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,li_xf,ai_units)
return 1
end function

public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,datetime aa_value,n_xls_format anvo_format,integer ai_units);long li_xf
double ld_val
time lt_time
string ls_time
integer li_hour
integer li_minute
integer li_second
long lul_cell

if (( not isnull(anvo_format)) and isvalid(anvo_format)) then
	li_xf = of_xf(-1,-1,anvo_format)
else
	return -1
end if

lt_time = time(aa_value)
ls_time = string(lt_time)
lt_time = time(ls_time)
li_hour = hour(lt_time)
li_minute = minute(lt_time)
li_second = second(lt_time)
ld_val = daysafter(1899-12-30,date(aa_value)) + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
lul_cell = add_cell_double(iul_cellstorage,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,li_xf,ai_units)
return 1
end function

public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,double aa_value,n_xls_format anvo_format,integer ai_units);long li_xf
long lul_cell

if (( not isnull(anvo_format)) and isvalid(anvo_format)) then
	li_xf = of_xf(-1,-1,anvo_format)
else
	return -1
end if

lul_cell = add_cell_double(iul_cellstorage,aa_value,ai_x1,ai_x2,ai_y1,ai_y2,li_xf,ai_units)
return 1
end function

public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,string aa_value,n_xls_format anvo_format,integer ai_units);long li_xf
long lul_cell

if (( not isnull(anvo_format)) and isvalid(anvo_format)) then
	li_xf = of_xf(-1,-1,anvo_format)
else
	return -1
end if

lul_cell = add_cell_string(iul_cellstorage,aa_value,ai_x1,ai_x2,ai_y1,ai_y2,li_xf,ai_units)
return 1
end function

public function integer of_create_cell (uint ai_x1,uint ai_x2,uint ai_y1,uint ai_y2,time aa_value,n_xls_format anvo_format,integer ai_units);long li_xf
double ld_val
integer li_hour
integer li_minute
integer li_second
long lul_cell

if (( not isnull(anvo_format)) and isvalid(anvo_format)) then
	li_xf = of_xf(-1,-1,anvo_format)
else
	return -1
end if

li_hour = hour(aa_value)
li_minute = minute(aa_value)
li_second = second(aa_value)
ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
lul_cell = add_cell_double(iul_cellstorage,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,li_xf,ai_units)
return 1
end function

public function long of_end_band (integer ai_units);return end_band(iul_cellstorage,ai_units)
end function

public function integer of_fit_to_pages (uint ai_width,uint ai_height);integer retvar

return retvar
end function

public function integer of_freeze_panes (uint ai_row,uint ai_col,uint ai_rowtop,uint ai_colleft);integer retvar

return retvar
end function

public function long of_get_cell_count ();return get_cell_count(iul_cellstorage)
end function

public function long of_get_column_count ();return 0
end function

public function string of_get_name ();string retvar

return retvar
end function

public function blob of_get_name_unicode ();return invo_sub.to_unicode(of_get_name())
end function

public function long of_get_row_count ();return 0
end function

private function string of_getexedir ();string ls_path
long li_max = 1024
long li_pos
classdefinition lcd

if handle(getapplication()) = 0 then
	//lcd = getclassdefinition()
	//ls_path = lcd.getlibraryname()
else
	ls_path = space(li_max)

	if of_iswidepb() then
		getmodulefilenamew(handle(getapplication()),ls_path,li_max)
	else
		getmodulefilenamea(handle(getapplication()),ls_path,li_max)
	end if

end if

li_pos = pos(reverse(ls_path),"\")

if li_pos > 0 then
	ls_path = left(ls_path,len(ls_path) - li_pos)
else
	ls_path = "."
end if

return ls_path
end function

public function integer of_hide_gridlines (uint ai_option);integer retvar

return retvar
end function

public subroutine of_initdata ();of_update_y()
of_update_x()
end subroutine

private subroutine of_initunitconvertor ();long li_unit

inv_unitsub = create n_dwr_sub

for li_unit = 0 to 3
	set_unit_x_coef(iul_cellstorage,li_unit,inv_unitsub.of_get_coef_x(li_unit))
	set_unit_y_coef(iul_cellstorage,li_unit,inv_unitsub.of_get_coef_y(li_unit))
next
end subroutine

public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename,readonly uint ai_x,readonly uint ai_y);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly uint ai_row,readonly uint ai_col,readonly string as_bitmap_filename,readonly uint ai_x,readonly uint ai_y,readonly double ad_scale_width,readonly double ad_scale_height);integer li_ret = 1

return li_ret
end function

public function boolean of_iswidepb ();return len(blob("*")) = 2
end function

private function ulong of_loadlibrary (string as_dll);string ls_dll

ls_dll = of_getexedir() + "\" + as_dll

if of_iswidepb() then
	return loadlibraryw(ls_dll)
else
	return loadlibrarya(ls_dll)
end if
end function

protected function integer of_merge_cells (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col);return 1
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,blob ab_unicode_str,n_xls_format anvo_format);return of_merge_write(ai_first_row,ai_first_col,ai_last_row,ai_last_col,invo_sub.to_ansi(ab_unicode_str),anvo_format)
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,date ad_date,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,datetime adt_datetime,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,double adb_num,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,string as_str,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_merge_write (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col,time at_time,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_print_area (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col);integer retvar

return retvar
end function

public function integer of_print_row_col_headers (boolean ab_print_headers);integer retvar

return retvar
end function

public function integer of_protect (string as_password);integer retvar

return retvar
end function

public function integer of_repeat_columns (uint ai_first_col,uint ai_last_col);integer retvar

return retvar
end function

public function integer of_repeat_rows (uint ai_first_row,uint ai_last_row);integer retvar

return retvar
end function

public function integer of_select ();integer retvar

return retvar
end function

public function integer of_set_column (uint ai_firstcol,uint ai_lastcol,double ad_width,n_xls_format anvo_format,boolean ab_hidden);integer retvar

return retvar
end function

public function integer of_set_column_format (long al_col,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_set_column_hidden (long al_col,boolean ab_hidden);integer retvar

return retvar
end function

public function integer of_set_column_width (long al_col,double ad_width);integer retvar

return retvar
end function

public function integer of_set_column_width (long al_col,long al_width);integer retvar

return retvar
end function

public function integer of_set_first_sheet ();integer retvar

return retvar
end function

public function integer of_set_footer (blob ab_footer,double ad_margin_foot);return of_set_footer(invo_sub.to_ansi(ab_footer),ad_margin_foot)
end function

public function integer of_set_footer (string as_footer,double ad_margin_foot);integer retvar

return retvar
end function

public function integer of_set_header (blob ab_header,double ad_margin_head);return of_set_header(invo_sub.to_ansi(ab_header),ad_margin_head)
end function

public function integer of_set_header (string as_header,double ad_margin_head);integer retvar

return retvar
end function

public function integer of_set_landscape ();integer retvar

return retvar
end function

public function integer of_set_margin_bottom (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margin_left (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margin_right (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margin_top (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margins (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margins_lr (double ad_margin);integer retvar

return retvar
end function

public function integer of_set_margins_tb (double ad_margin);integer retvar

return retvar
end function

public subroutine of_set_merge_range (long ai_format);return
end subroutine

public function integer of_set_paper ();integer retvar

return retvar
end function

public function integer of_set_paper (uint ai_paper_size);integer retvar

return retvar
end function

public subroutine of_set_point_to_row_zoom (double ad_x,double ad_y);id_x_zoom = ad_x
id_y_zoom = ad_y
end subroutine

public function integer of_set_portrait ();integer retvar

return retvar
end function

public function integer of_set_print_scale (uint ai_scale);integer retvar

return retvar
end function

public function integer of_set_row_format (long al_row,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_set_row_height (long al_row,double ad_height);integer retvar

return retvar
end function

public function integer of_set_row_height (long al_row,long al_height);integer retvar

return retvar
end function

public function integer of_set_row_hidden (long al_row,boolean ab_hidden);integer retvar

return retvar
end function

public function integer of_set_selection (uint ai_first_row,uint ai_first_col,uint ai_last_row,uint ai_last_col);integer retvar

return retvar
end function

public function integer of_set_selection (uint ai_row,uint ai_col);integer retvar

return retvar
end function

public function integer of_set_zoom (uint ai_scale);integer retvar

return retvar
end function

public subroutine of_setalign (double ad_x,double ad_y);set_align(iul_cellstorage,ad_x,ad_y)
end subroutine

public function integer of_thaw_panes (double ad_y,double ad_x,uint ai_rowtop,uint ai_colleft);integer retvar

return retvar
end function

public function integer of_update_x ();long li_base_col
long li_max_col
long li_col
double ld_col_w

prepare_x(iul_cellstorage)
get_x_info(iul_cellstorage,li_base_col,li_max_col)

for li_col = li_base_col to li_max_col
	ld_col_w = get_col_width(iul_cellstorage,li_col)
	of_set_column_width(li_col,ld_col_w)
next

return update_x(iul_cellstorage)
end function

public function long of_update_y ();long li_base_row
long li_max_row
long li_row
double ld_row_h

prepare_y(iul_cellstorage)
get_y_info(iul_cellstorage,li_base_row,li_max_row)

for li_row = li_base_row to li_max_row
	ld_row_h = get_row_height(iul_cellstorage,li_row)
	of_set_row_height(li_row,ld_row_h)
next

return update_y(iul_cellstorage)
end function

public function integer of_write (long ai_row,long ai_col,blob aa_value,long ai_format);return 1
end function

public function integer of_write (long ai_row,long ai_col,double aa_value,long ai_format);return 1
end function

public function integer of_write (long ai_row,long ai_col,string aa_value,long ai_format);return 1
end function

public function integer of_write (uint ai_row,uint ai_col);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,blob ab_unicode_str);return of_write(ai_row,ai_col,invo_sub.to_ansi(ab_unicode_str))
end function

public function integer of_write (uint ai_row,uint ai_col,blob ab_unicode_str,n_xls_format anvo_format);return of_write(ai_row,ai_col,invo_sub.to_ansi(ab_unicode_str),anvo_format)
end function

public function integer of_write (uint ai_row,uint ai_col,date ad_date);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,date ad_date,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,datetime adt_datetime);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,datetime adt_datetime,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,double adb_num);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,double adb_num,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,string as_str);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,string as_str,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,time at_time);integer retvar

return retvar
end function

public function integer of_write (uint ai_row,uint ai_col,time at_time,n_xls_format anvo_format);integer retvar

return retvar
end function

public function integer of_write_cell (long ai_cell,boolean ab_merge);cell_info info
cell_coord coord
long li_format
long li_ret = 1
long li_row
long li_col
string ls_value
double ld_value

ai_cell --
info.valuesize = -1
li_ret = get_cell_info(iul_cellstorage,ai_cell,info)

if li_ret < 0 then
	return -1
end if

choose case info.valuetype
	case 2
		ls_value = space(info.valuesize)
		li_ret = get_cell_string(iul_cellstorage,ai_cell,ls_value,li_format,coord)

		if li_ret < 0 then
			return -1
		end if

		li_ret = of_write(coord.y1,coord.x1,ls_value,li_format)
	case 1
		li_ret = get_cell_double(iul_cellstorage,ai_cell,ld_value,li_format,coord)

		if li_ret < 0 then
			return -1
		end if

		li_ret = of_write(coord.y1,coord.x1,ld_value,li_format)
	case 4
		li_ret = of_add_h_pagebreak(info.valuesize)
	case else
		return -1
end choose

if not ab_merge then
	return 1
end if

coord.y2 --
coord.x2 --

if coord.y1 >= coord.y2 and coord.x1 >= coord.x2 then
	return 1
end if

for li_row = coord.y1 to coord.y2

	for li_col = coord.x1 to coord.x2

		if li_row = coord.y1 and li_col = coord.x1 then
		else
			of_write(li_row,li_col,"",li_format)
		end if

	next

next

of_merge_cells(coord.y1,coord.x1,coord.y2,coord.x2)
return 1
end function

protected function integer of_xf (uint ai_row,uint ai_col,n_xls_format anvo_format);return -1
end function

event constructor;ulong h

invo_sub = create n_xls_subroutines_v97
h = of_loadlibrary("pb2xls.dll")

if h = 0 then
	return
end if

iul_cellstorage = create_cell_storage()
freelibrary(h)
of_initunitconvertor()
return
end event

on n_xls_worksheet.create
call super::create;

triggerevent("constructor")
end on

on n_xls_worksheet.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;if iul_cellstorage <> 0 then
	free_cell_storage(iul_cellstorage)
	iul_cellstorage = 0
end if

destroy(invo_sub)
return
end event

