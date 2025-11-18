$PBExportHeader$n_dwr_worksheet.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_worksheet from nonvisualobject
end type
end forward

global type n_dwr_worksheet from nonvisualobject
end type
global n_dwr_worksheet n_dwr_worksheet

type prototypes
public function long addcelldouble (ulong ws,double value,long x1,long x2,long y1,long y2,long format,long unit)  library "pb2xls.dll" alias for "ws_addCellDouble"
public function long addcellstring (ulong ws,readonly string value,long x1,long x2,long y1,long y2,long format,long unit)  library "pb2xls.dll" alias for "ws_addCellString"
public function long addhbreak (ulong ws,long y,long unit)  library "pb2xls.dll" alias for "ws_addHBreak"
public function long updatex (ulong ws)  library "pb2xls.dll" alias for "ws_updateX"
public function long updatey (ulong ws)  library "pb2xls.dll" alias for "ws_updateY"
public subroutine beginband (ulong ws)  library "pb2xls.dll" alias for "ws_beginBand"
public subroutine setprintgridlines (ulong ws,boolean value)  library "pb2xls.dll" alias for "ws_setPrintGridLines"
public subroutine setscreengridlines (ulong ws,boolean value)  library "pb2xls.dll" alias for "ws_setScreenGridLines"
public function long endband (ulong ws,long units)  library "pb2xls.dll" alias for "ws_endBand"
public subroutine setalign (ulong ws,double x,double y)  library "pb2xls.dll" alias for "ws_setAlign"
public subroutine setunitxcoef (ulong ws,long unit,double coef)  library "pb2xls.dll" alias for "ws_setUnitXCoef"
public subroutine setunitycoef (ulong ws,long unit,double coef)  library "pb2xls.dll" alias for "ws_setUnitYCoef"
public function long getcellcount (ulong ws)  library "pb2xls.dll" alias for "ws_getCellCount"
public function long writecells (ulong ws,long al_begin,long al_end,long millisecs,boolean merge)  library "pb2xls.dll" alias for "ws_writeCells"
public subroutine setcolwidth (ulong ws,long col,double width)  library "pb2xls.dll" alias for "ws_setColWidth"
public subroutine setrowheight (ulong ws,long row,double height)  library "pb2xls.dll" alias for "ws_setRowHeight"
public subroutine excel97_appenddata (ulong ws,readonly blob buf,long len)  library "pb2xls.dll" alias for "ws_excel97_appendData"
public subroutine excel97_appendheaderdata (ulong ws,readonly blob buf,long len)  library "pb2xls.dll" alias for "ws_excel97_appendHeaderData"
public function ulong excel97_getrowheight (ulong ws,long al_row)  library "pb2xls.dll" alias for "ws_excel97_getRowHeight"
public function ulong excel97_getcolwidth (ulong ws,long al_col)  library "pb2xls.dll" alias for "ws_excel97_getColWidth"
end prototypes

type variables
public ulong handle
public n_xls_subroutines_v97 invo_sub
end variables

forward prototypes
public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,date aa_value,long al_format,integer ai_units)
public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,datetime aa_value,long al_format,integer ai_units)
public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,double aa_value,long al_format,integer ai_units)
public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,string aa_value,long al_format,integer ai_units)
public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,time aa_value,long al_format,integer ai_units)
public subroutine of_initunitconvertor ()
public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename)
public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename,readonly long ai_x,readonly long ai_y)
public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename,readonly long ai_x,readonly long ai_y,readonly double ad_scale_width,readonly double ad_scale_height)
public function integer of_position_image (long ai_col_start,long ai_row_start,long ai_x1,long ai_y1,long ai_width,long ai_height)
protected function integer of_process_bitmap (readonly string as_bitmap_filename,ref long al_width,ref long al_height,ref long al_size,ref blob ab_data)
public function ulong of_size_col (ulong ai_col)
public function ulong of_size_row (ulong ai_row)
protected function integer of_store_obj_picture (readonly long ai_col_start,readonly long ai_x1,readonly long ai_row_start,readonly long ai_y1,readonly long ai_col_end,readonly long ai_x2,readonly long ai_row_end,readonly long ai_y2)
end prototypes

public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,date aa_value,long al_format,integer ai_units);double ld_val
long lul_cell

ld_val = daysafter(1899-12-30,aa_value)
lul_cell = addcelldouble(handle,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,al_format,ai_units)
return 1
end function

public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,datetime aa_value,long al_format,integer ai_units);double ld_val
time lt_time
string ls_time
integer li_hour
integer li_minute
integer li_second
long lul_cell

lt_time = time(aa_value)
ls_time = string(lt_time)
lt_time = time(ls_time)
li_hour = hour(lt_time)
li_minute = minute(lt_time)
li_second = second(lt_time)
ld_val = daysafter(1899-12-30,date(aa_value)) + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
lul_cell = addcelldouble(handle,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,al_format,ai_units)
return 1
end function

public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,double aa_value,long al_format,integer ai_units);long lul_cell

lul_cell = addcelldouble(handle,aa_value,ai_x1,ai_x2,ai_y1,ai_y2,al_format,ai_units)
return 1
end function

public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,string aa_value,long al_format,integer ai_units);long lul_cell

lul_cell = addcellstring(handle,aa_value,ai_x1,ai_x2,ai_y1,ai_y2,al_format,ai_units)
return 1
end function

public function integer of_create_cell (long ai_x1,long ai_x2,long ai_y1,long ai_y2,time aa_value,long al_format,integer ai_units);double ld_val
integer li_hour
integer li_minute
integer li_second
long lul_cell

li_hour = hour(aa_value)
li_minute = minute(aa_value)
li_second = second(aa_value)
ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
lul_cell = addcelldouble(handle,ld_val,ai_x1,ai_x2,ai_y1,ai_y2,al_format,ai_units)
return 1
end function

public subroutine of_initunitconvertor ();n_dwr_sub lsub
long li_unit

lsub = create n_dwr_sub

for li_unit = 0 to 3
	setunitxcoef(handle,li_unit,lsub.of_get_coef_x(li_unit))
	setunitycoef(handle,li_unit,lsub.of_get_coef_y(li_unit))
next
end subroutine

public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename);return of_insert_bitmap(ai_row,ai_col,as_bitmap_filename,0,0,1,1)
end function

public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename,readonly long ai_x,readonly long ai_y);return of_insert_bitmap(ai_row,ai_col,as_bitmap_filename,ai_x,ai_y,1,1)
end function

public function integer of_insert_bitmap (readonly long ai_row,readonly long ai_col,readonly string as_bitmap_filename,readonly long ai_x,readonly long ai_y,readonly double ad_scale_width,readonly double ad_scale_height);integer li_ret = 1
long li_width
long li_height
long li_size
blob lb_data
blob lb_header

li_ret = of_process_bitmap(as_bitmap_filename,li_width,li_height,li_size,lb_data)

if li_ret = 1 then
	li_width = li_width * ad_scale_width
	li_height = li_height * ad_scale_height
	li_ret = of_position_image(ai_col,ai_row,ai_x,ai_y,li_width,li_height)
end if

if li_ret = 1 then
	lb_header = invo_sub.of_pack("v",127) + invo_sub.of_pack("v",8 + li_size) + invo_sub.of_pack("v",9) + invo_sub.of_pack("v",1) + invo_sub.of_pack("V",li_size)
	excel97_appenddata(handle,lb_header + lb_data,len(lb_header) + len(lb_data))
end if

return li_ret
end function

public function integer of_position_image (long ai_col_start,long ai_row_start,long ai_x1,long ai_y1,long ai_width,long ai_height);integer li_ret = 1
uint li_col_end
uint li_row_end
uint li_x2
uint li_y2

li_col_end = ai_col_start
li_row_end = ai_row_start

if ai_x1 >= of_size_col(ai_col_start) then
	ai_x1 = 0
end if

if ai_y1 >= of_size_row(ai_row_start) then
	ai_y1 = 0
end if

ai_width = ai_width + ai_x1 - 1
ai_height = ai_height + ai_y1 - 1

do while ai_width >= of_size_col(li_col_end)
	ai_width = ai_width - of_size_col(li_col_end)
	li_col_end ++
loop

do while ai_height >= of_size_row(li_row_end)
	ai_height = ai_height - of_size_row(li_row_end)
	li_row_end ++
loop

if of_size_col(ai_col_start) = 0 then
	return -1
end if

if of_size_col(li_col_end) = 0 then
	return -1
end if

if of_size_row(ai_row_start) = 0 then
	return -1
end if

if of_size_row(li_row_end) = 0 then
	return -1
end if

ai_x1 = (ai_x1 / of_size_col(ai_col_start)) * 1024
ai_y1 = (ai_y1 / of_size_row(ai_row_start)) * 256
li_x2 = (ai_width / of_size_col(li_col_end)) * 1024
li_y2 = (ai_height / of_size_row(li_row_end)) * 256
li_ret = of_store_obj_picture(ai_col_start,ai_x1,ai_row_start,ai_y1,li_col_end,li_x2,li_row_end,li_y2)
return li_ret
end function

protected function integer of_process_bitmap (readonly string as_bitmap_filename,ref long al_width,ref long al_height,ref long al_size,ref blob ab_data);integer li_ret = 1
integer li_file
blob lb_data_item
blob lb_data
ulong ll_size
uint li_planes
uint li_bitcount
ulong ll_compression
blob lb_header

li_file = fileopen(as_bitmap_filename,streammode!,read!,lockwrite!)

if li_file <> -1 then
	setnull(lb_data)

	do while fileread(li_file,lb_data_item) > 0

		if isnull(lb_data) then
			lb_data = lb_data_item
		else
			lb_data = lb_data + lb_data_item
		end if

	loop

	if isnull(lb_data) then
		li_ret = -1
	end if

	fileclose(li_file)
else
	li_ret = -1
	messagebox("Error","Couldn't open " + as_bitmap_filename,stopsign!)
end if

if li_ret = 1 then

	if len(lb_data) <= 54 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + " doesn't contain enough data",stopsign!)
	end if

end if

if li_ret = 1 then

	if string(blobmid(lb_data,1,2)) <> "BM" then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + " doesn't appear to to be a valid bitmap image",stopsign!)
	end if

end if

if li_ret = 1 then
	ll_size = long(blobmid(lb_data,3,4))
	ll_size -= (54 - 12)
	al_width = long(blobmid(lb_data,19,4))
	al_height = long(blobmid(lb_data,23,4))

	if al_width > 65535 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + ": largest image width supported is 65535",stopsign!)
	end if

end if

if li_ret = 1 then

	if al_height > 65535 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + ": largest image height supported is 65535",stopsign!)
	end if

end if

if li_ret = 1 then
	li_planes = integer(blobmid(lb_data,27,2))
	li_bitcount = integer(blobmid(lb_data,29,2))

	if li_bitcount <> 24 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + " isn't a 24bit true color bitmap",stopsign!)
	end if

end if

if li_ret = 1 then

	if li_planes <> 1 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + ": only 1 plane supported in bitmap image",stopsign!)
	end if

end if

if li_ret = 1 then
	ll_compression = long(blobmid(lb_data,31,4))

	if ll_compression <> 0 then
		li_ret = -1
		messagebox("Error",as_bitmap_filename + ": compression not supported in bitmap image",stopsign!)
	end if

end if

if li_ret = 1 then
	lb_header = invo_sub.of_pack("V",12) + invo_sub.of_pack("v",al_width) + invo_sub.of_pack("v",al_height) + invo_sub.of_pack("v",1) + invo_sub.of_pack("v",24)
	ab_data = lb_header + blobmid(lb_data,55,len(lb_data) - 55 + 1)
	al_size = ll_size
end if

return li_ret
end function

public function ulong of_size_col (ulong ai_col);return excel97_getcolwidth(handle,ai_col)
end function

public function ulong of_size_row (ulong ai_row);return excel97_getrowheight(handle,ai_row)
end function

protected function integer of_store_obj_picture (readonly long ai_col_start,readonly long ai_x1,readonly long ai_row_start,readonly long ai_y1,readonly long ai_col_end,readonly long ai_x2,readonly long ai_row_end,readonly long ai_y2);integer li_ret = 1
blob lb_header

lb_header = invo_sub.of_pack("v",93) + invo_sub.of_pack("v",60) + invo_sub.of_pack("V",1) + invo_sub.of_pack("v",8) + invo_sub.of_pack("v",1) + invo_sub.of_pack("v",1556) + invo_sub.of_pack("v",ai_col_start) + invo_sub.of_pack("v",ai_x1) + invo_sub.of_pack("v",ai_row_start) + invo_sub.of_pack("v",ai_y1) + invo_sub.of_pack("v",ai_col_end) + invo_sub.of_pack("v",ai_x2) + invo_sub.of_pack("v",ai_row_end) + invo_sub.of_pack("v",ai_y2) + invo_sub.of_pack("v",0) + invo_sub.of_pack("V",0) + invo_sub.of_pack("v",0) + invo_sub.of_pack("C",9) + invo_sub.of_pack("C",9) + invo_sub.of_pack("C",0) + invo_sub.of_pack("C",0) + invo_sub.of_pack("C",8) + invo_sub.of_pack("C",255) + invo_sub.of_pack("C",1) + invo_sub.of_pack("C",0) + invo_sub.of_pack("v",0) + invo_sub.of_pack("V",9) + invo_sub.of_pack("v",0) + invo_sub.of_pack("v",0) + invo_sub.of_pack("v",0) + invo_sub.of_pack("v",1) + invo_sub.of_pack("V",0)
excel97_appenddata(handle,lb_header,len(lb_header))
return li_ret
end function

event constructor;invo_sub = create n_xls_subroutines_v97
return
end event

on n_dwr_worksheet.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_worksheet.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;return
end event

