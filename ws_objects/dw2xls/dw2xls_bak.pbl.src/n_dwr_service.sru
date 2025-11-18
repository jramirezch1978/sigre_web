$PBExportHeader$n_dwr_service.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_service from n_dwr_service_base
end type
end forward

global type n_dwr_service from n_dwr_service_base
event ue_cancel ()
event ue_process_work ()
end type
global n_dwr_service n_dwr_service

type variables
private powerobject ipo_requestor
private object ipo_requestortype
private datawindow idw_requestor
private datastore ids_requestor
private datawindowchild idwc_requestor
public integer ii_band_count
public long il_cur_writer_row
public boolean ib_show_progress = false
public n_dwr_progress ipo_progress
private integer ii_analyse_as_rowcount = 10
private long ii_percent_of_analyse = 5
private long ii_percent_of_stage1 = 70
private long ii_percent_of_stage2 = 25
private boolean ib_cancel = false
public boolean ib_modemultisheet = false
public boolean ib_multisheet = false
private integer ii_rows_per_detail = 1
public n_dwr_grid invo_global_vgrid
private boolean ib_group_newpage[]
public n_dwr_band invo_bands[]
private boolean ib_enable_merge_cells = true
public n_dwr_workbook inv_book
public n_dwr_worksheet inv_sheet
public n_dwr_service_parm invo_parm
public n_dwr_nested_service_parm invo_nested_parm
public n_dwr_sub invo_sub
public n_dwr_colors invo_colors
private boolean ib_nested = false
private long il_base_x
private long il_base_y
private long il_rowcount
private string is_object[]
private string is_object_band[]
private long il_object_nested_id[]
private long il_objectcount = -1
private long il_nested_weight = 50
public integer dt_column = 1
public integer dt_compute = 2
public integer dt_text = 3
public integer dt_report = 4
private boolean ib_defer_update_y = false
public integer ii_units
private w_dw2xls_dynref iw_dynref
end variables

forward prototypes
private function integer of_addband (string as_band_name,integer ai_band_type,integer ai_group_level)
private function integer of_addbands ()
public function integer of_analyse_dw (integer ai_percent_of_analyse)
private subroutine of_cache_metadata ()
public function integer of_cancel ()
public function integer of_close ()
public function long of_countnested ()
public function integer of_create (powerobject apo_requestor,n_dwr_workbook anv_book,string as_filename)
public function integer of_create (powerobject apo_requestor,n_dwr_workbook anv_book,string as_filename,n_dwr_service_parm anvo_parm,n_dwr_nested_service_parm anvo_nested_parm)
private function n_dwr_band of_createband (string as_band_name,integer ai_band_type,integer ai_group_level,long al_subband_y)
public function string of_describe (readonly string as_expr)
public function long of_describe_expr (string as_expr,long al_row,ref string as_prop_expr)
public function string of_describe_str_expr (string as_expr,long al_row)
private function integer of_getband (string as_bandname,ref n_dwr_band anvo_band)
private function integer of_groupcount ()
public function boolean of_is_newpage (long al_row)
public function string of_modify (readonly string as_expr)
public function integer of_process ()
public function integer of_process_work ()
public function integer of_register_dynamic (powerobject apo_requestor)
protected subroutine of_reset_metadata_cache ()
public function long of_rowcount ()
public function integer of_set_col_width ()
private function integer of_set_yield (boolean ab_yield_status)
private function integer of_show_progress (integer ai_progress)
private function integer of_splitband (string as_band_name,integer ai_band_type,integer ai_group_level)
end prototypes

event ue_cancel;of_cancel()
end event

event ue_process_work;of_process_work()
end event

private function integer of_addband (string as_band_name,integer ai_band_type,integer ai_group_level);return of_splitband(as_band_name,ai_band_type,ai_group_level)
end function

private function integer of_addbands ();integer li_groupcount
integer li_i
integer li_ret = 1
string ls_bands
string ls_band_arr[]
integer li_band_cnt
n_dwr_string lnvo_strsrv

li_groupcount = of_groupcount()
ls_bands = of_describe("datawindow.bands")
li_band_cnt = lnvo_strsrv.of_stringtoarray(ls_bands,"~t",ls_band_arr)

if invo_parm.ib_group_trailer then

	for li_i = li_groupcount to 1 step -1
		of_addband("trailer." + string(li_i),4,li_i)
	next

end if

if invo_parm.ib_footer then
	of_addband("footer",6,0)
end if

for li_i = 1 to li_band_cnt

	if left(ls_band_arr[li_i],6) = "header" and left(ls_band_arr[li_i],7) <> "header." then

		if invo_parm.ib_header then
			of_addband(ls_band_arr[li_i],1,0)
		end if

	end if

next

if invo_parm.ib_group_header then

	for li_i = 1 to li_groupcount
		of_addband("header." + string(li_i),2,li_i)
	next

end if

if invo_parm.ib_detail then
	of_addband("detail",3,0)
end if

if invo_parm.ib_summary then
	of_addband("summary",5,0)
end if

if ib_show_progress then
	of_set_yield(true)
end if

return li_ret
end function

public function integer of_analyse_dw (integer ai_percent_of_analyse);integer li_ret = 1
n_dwr_string lnvo_str_srv
string ls_objects
string ls_object[]
long ll_objectcount
long ll_i
string ls_bandname
n_dwr_band lnvo_band
long ll_change_progress_each
long ll_cur_change_progress
integer li_progress

if ib_nested then
	il_base_x = invo_nested_parm.il_nested_x
	il_base_y = invo_nested_parm.il_nested_y
end if

do

	if ib_show_progress and ( not ib_nested) then
		of_show_progress(0)
	end if

	ii_rows_per_detail = integer(of_describe("DataWindow.rows_per_detail"))

	if ((ii_rows_per_detail < 1) or (isnull(ii_rows_per_detail))) then
		ii_rows_per_detail = 1
	end if

	li_ret = of_addbands()

	if li_ret <> 1 then
		exit
	end if

	if ib_show_progress and ( not ib_nested) then
		of_show_progress(ai_percent_of_analyse)
	end if

loop until true

ib_defer_update_y = false
return li_ret
end function

private subroutine of_cache_metadata ();string ls_objects
string ls_object[]
string ls_bandname
string ls_type
long li_object
long li_used_object
n_dwr_string s

if il_objectcount >= 0 then
	return
end if

ls_objects = of_describe("DataWindow.Objects")
il_objectcount = s.of_parsetoarray(ls_objects,"~t",ls_object)
li_used_object = 0

for li_object = 1 to il_objectcount
	ls_bandname = of_describe(ls_object[li_object] + ".band")
	ls_type = of_describe(ls_object[li_object] + ".type")

	if ls_type = "report" then
		invo_parm.il_nested_instance_count ++
	end if

	if ls_bandname = "foreground" then

		if not invo_parm.ib_foreground then
			continue
		end if

		ls_bandname = "header"
	end if

	if ls_bandname = "background" then

		if not invo_parm.ib_background then
			continue
		end if

		ls_bandname = "header"
	end if

	li_used_object ++
	is_object[li_used_object] = ls_object[li_object]
	is_object_band[li_used_object] = ls_bandname
	il_object_nested_id[li_used_object] = invo_parm.il_nested_instance_count
next

il_objectcount = upperbound(is_object)
end subroutine

public function integer of_cancel ();integer li_i

ib_cancel = true

if ii_band_count > 0 then

	for li_i = 1 to ii_band_count
		invo_bands[li_i].of_cancel()
	next

end if

return 1
end function

public function integer of_close ();if (( not isnull(inv_book)) and isvalid(inv_book)) then
	inv_book.save(inv_book.handle)
end if

ib_multisheet = false
return 1
end function

public function long of_countnested ();long li_band
long li_bandn
long li_field
long li_fieldn
long li_nestedn
n_dwr_band lnv_band

li_bandn = upperbound(invo_bands)

for li_band = 1 to li_bandn
	lnv_band = invo_bands[li_band]
	li_fieldn = upperbound(lnv_band.invo_fields)

	for li_field = 1 to li_fieldn

		if lnv_band.invo_fields[li_field].ii_dwo_type = 4 then
			li_nestedn ++
		end if

	next

next

return li_nestedn
end function

public function integer of_create (powerobject apo_requestor,n_dwr_workbook anv_book,string as_filename);n_dwr_service_parm lnvo_parm
n_dwr_nested_service_parm lnvo_nested_parm

lnvo_parm = create n_dwr_service_parm
return of_create(apo_requestor,anv_book,as_filename,lnvo_parm,lnvo_nested_parm)
end function

public function integer of_create (powerobject apo_requestor,n_dwr_workbook anv_book,string as_filename,n_dwr_service_parm anvo_parm,n_dwr_nested_service_parm anvo_nested_parm);integer li_ret = 1
string ls_tmp_dir
boolean lb_null[]
n_dwr_band lnvo_null[]
long ll_error
integer li_processing

ipo_requestor = apo_requestor
of_reset_metadata_cache()

if not isnull(ipo_requestor) then

	if isvalid(ipo_requestor) then
		ipo_requestortype = ipo_requestor.typeof()

		choose case ipo_requestortype
			case datawindow!
				idw_requestor = ipo_requestor
			case datastore!
				ids_requestor = ipo_requestor
			case datawindowchild!
				idwc_requestor = ipo_requestor
			case else
				messagebox("Error","Object type is not supported",stopsign!)
				li_ret = -1
		end choose

		if li_ret = 1 then

			if of_describe("Datawindow.Syntax") = "" then
				messagebox("Error","Report is empty",stopsign!)
				li_ret = -1
			end if

		end if

	else
		messagebox("Error","Report is empty",stopsign!)
		li_ret = -1
	end if

else
	messagebox("Error","Report is empty",stopsign!)
	li_ret = -1
end if

if not isnull(anvo_nested_parm) then

	if isvalid(anvo_nested_parm) then
		ib_nested = true
	end if

end if

if li_ret = 1 then
	li_processing = integer(of_describe("Datawindow.Processing"))

	choose case li_processing
		case 0, 1
		case 2
			messagebox("Error","Label presentation style is not supported",stopsign!)
			li_ret = -1
		case 3
			messagebox("Error","Graph presentation style is not supported",stopsign!)
			li_ret = -1
		case 4
			of_modify("DataWindow.Crosstab.StaticMode=Yes")
		case 5
		case else
			messagebox("Error","This presentation style is not supported",stopsign!)
			li_ret = -1
	end choose

end if

if li_ret = 1 and ( not ib_nested) then
	il_rowcount = of_rowcount()

	if il_rowcount < 1 and li_processing <> 5 then
		messagebox("Error","Rows not found",stopsign!)
		li_ret = -1
	end if

end if

if li_ret = 1 then
	inv_book = anv_book
	ii_band_count = 0
	il_cur_writer_row = 0
	ib_show_progress = false
	ii_analyse_as_rowcount = 10
	ib_cancel = false
	ii_rows_per_detail = 1
	ib_group_newpage = lb_null
	invo_bands = lnvo_null
	invo_parm = anvo_parm
	ib_enable_merge_cells = invo_parm.ib_enable_merge_cells
	invo_nested_parm = anvo_nested_parm
	ii_units = integer(of_describe("Datawindow.Units"))
	invo_sub = create n_dwr_sub
	invo_sub.of_set_cur_units(ii_units)

	if ib_nested then
		invo_global_vgrid = anvo_nested_parm.invo_global_vgrid
		invo_colors = anvo_nested_parm.invo_colors
		inv_sheet = anvo_nested_parm.inv_sheet

		if isvalid(anvo_nested_parm.ipo_progress) then
			ib_show_progress = true
		else
			ib_show_progress = false
		end if

	else
		anvo_parm.il_nested_instance_count = 0
		invo_global_vgrid = create n_dwr_grid
		invo_global_vgrid.ii_round_ratio = invo_global_vgrid.ii_round_init_ratio * invo_sub.of_get_conv_x()

		if not ib_multisheet then
			ll_error = inv_book.of_create(anvo_parm.is_version,as_filename,true)

			if ll_error <> 0 then
				li_ret = -1
			else
				li_ret = 1
			end if

		end if

		if li_ret <> 1 then
			return li_ret
		end if

		inv_sheet = inv_book.of_addworksheet(invo_parm.is_sheet_name)
		inv_sheet.setalign(inv_sheet.handle,anvo_parm.id_min_width,anvo_parm.id_min_height)

		if ((( not ib_multisheet) or (isnull(invo_colors))) or ( not isvalid(invo_colors))) then
			invo_colors = create n_dwr_colors
		end if

	end if

	if ib_modemultisheet then
		ib_multisheet = true
	end if

end if

return li_ret
end function

private function n_dwr_band of_createband (string as_band_name,integer ai_band_type,integer ai_group_level,long al_subband_y);n_dwr_band lnvo_band
integer li_ret = 1
boolean lb_newpage = false

lnvo_band = create n_dwr_band

do
	lnvo_band.id_x_coef = invo_sub.of_get_cur_coef_x()
	lnvo_band.id_y_coef = invo_sub.of_get_cur_coef_y()
	lnvo_band.id_conv = invo_sub.of_get_conv_x()
	lnvo_band.ii_units = ii_units
	lnvo_band.ib_nested = ib_nested
	lnvo_band.ipo_progress = ipo_progress
	li_ret = lnvo_band.of_register(ipo_requestor,inv_book,inv_sheet,invo_parm,invo_colors,ii_rows_per_detail,il_base_x,0,al_subband_y)

	if li_ret <> 1 then
		exit
	end if

	if ai_group_level > 0 then
		lb_newpage = ib_group_newpage[ai_group_level]
	end if

	li_ret = lnvo_band.of_init(as_band_name,ai_band_type,ai_group_level,lb_newpage,invo_global_vgrid)

	if li_ret <> 1 then
		exit
	end if

	return lnvo_band
loop until true

setnull(lnvo_band)
return lnvo_band
end function

public function string of_describe (readonly string as_expr);choose case ipo_requestortype
	case datawindow!
		return idw_requestor.describe(as_expr)
	case datastore!
		return ids_requestor.describe(as_expr)
	case datawindowchild!
		return idwc_requestor.describe(as_expr)
	case else
		return "!"
end choose
end function

public function long of_describe_expr (string as_expr,long al_row,ref string as_prop_expr);string ls_val
long ll_pos
n_dwr_string lnvo_str

choose case ipo_requestortype
	case datawindow!
		ls_val = idw_requestor.describe(as_expr)
	case datastore!
		ls_val = ids_requestor.describe(as_expr)
	case datawindowchild!
		ls_val = idwc_requestor.describe(as_expr)
	case else
		return -1
end choose

ll_pos = pos(ls_val,"~t")

if ll_pos > 0 then
	ls_val = mid(ls_val,ll_pos + 1,len(ls_val) - ll_pos - 1)
	ls_val = lnvo_str.of_globalreplace(ls_val,"'","~~'")
	as_prop_expr = ls_val

	choose case ipo_requestortype
		case datawindow!
			ls_val = idw_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case datastore!
			ls_val = ids_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case datawindowchild!
			ls_val = idwc_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case else
			return -1
	end choose

	if isnumber(ls_val) then
		return long(ls_val)
	end if

else
	as_prop_expr = ""

	if isnumber(ls_val) then
		return long(ls_val)
	end if

end if

return -1
end function

public function string of_describe_str_expr (string as_expr,long al_row);string ls_val
long ll_pos

choose case ipo_requestortype
	case datawindow!
		ls_val = idw_requestor.describe(as_expr)
	case datastore!
		ls_val = ids_requestor.describe(as_expr)
	case datawindowchild!
		ls_val = idwc_requestor.describe(as_expr)
	case else
		return ""
end choose

ll_pos = pos(ls_val,"~t")

if ll_pos > 0 then
	ls_val = mid(ls_val,ll_pos + 1,len(ls_val) - ll_pos - 1)

	choose case ipo_requestortype
		case datawindow!
			ls_val = idw_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case datastore!
			ls_val = ids_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case datawindowchild!
			ls_val = idwc_requestor.describe("evaluate(~"" + ls_val + "~", " + string(al_row) + ")")
		case else
			return ""
	end choose

	return ls_val
else
	return ls_val
end if
end function

private function integer of_getband (string as_bandname,ref n_dwr_band anvo_band);long ll_i

if as_bandname = "foreground" then

	if not invo_parm.ib_foreground then
		return -1
	end if

	as_bandname = "header"
end if

if as_bandname = "background" then

	if not invo_parm.ib_background then
		return -1
	end if

	as_bandname = "header"
end if

for ll_i = 1 to ii_band_count

	if invo_bands[ll_i].is_band_name = as_bandname then
		anvo_band = invo_bands[ll_i]
		return 1
	end if

next

return -1
end function

private function integer of_groupcount ();integer li_i
integer li_cnt
string ls_bandname
string ls_syntax
long ll_pos_1
long ll_pos_2
string ls_group_syn
boolean lb_newpage = false

do

	if isnumber(of_describe("datawindow.header." + string(li_cnt + 1) + ".Height")) then
		li_cnt ++
	else
		exit
	end if

loop while true

if li_cnt > 0 then
	ls_syntax = of_describe("DataWindow.Syntax")

	for li_i = 1 to li_cnt
		lb_newpage = false
		ll_pos_1 = pos(ls_syntax,"group(level=" + string(li_i))

		if ll_pos_1 > 0 then
			ll_pos_2 = pos(ls_syntax,"by=(",ll_pos_1)

			if ll_pos_2 > 0 then
				ll_pos_2 = pos(ls_syntax,")",ll_pos_2 + 3)

				if ll_pos_2 > 0 then
					ll_pos_2 = pos(ls_syntax,")",ll_pos_2 + 1)
				end if

			end if

			if ll_pos_2 > 0 then
				ls_group_syn = lower(mid(ls_syntax,ll_pos_1,ll_pos_2 - ll_pos_1 + 1))

				if pos(ls_group_syn,"newpage=y") > 0 then
					lb_newpage = true
				end if

			end if

		end if

		ib_group_newpage[li_i] = lb_newpage
	next

end if

return li_cnt
end function

public function boolean of_is_newpage (long al_row);boolean lb_newpage = false
integer li_i

for li_i = 1 to ii_band_count

	if invo_bands[li_i].ii_band_type = 2 then

		if al_row = invo_bands[li_i].il_groupchangerow and al_row > 1 and invo_bands[li_i].ib_newpage then
			lb_newpage = true
		end if

	end if

next

return lb_newpage
end function

public function string of_modify (readonly string as_expr);choose case ipo_requestortype
	case datawindow!
		return idw_requestor.modify(as_expr)
	case datastore!
		return ids_requestor.modify(as_expr)
	case datawindowchild!
		return idwc_requestor.modify(as_expr)
	case else
		return "!"
end choose
end function

public function integer of_process ();integer li_ret = 1
w_n_dwr_service_progress w

if invo_parm.ib_show_progress then
	ib_show_progress = true
	ipo_progress = create n_dwr_progress
	ipo_progress.iw_progress = w
	openwithparm(ipo_progress.iw_progress,this)

	if ib_cancel then
		li_ret = -1
	end if

else
	li_ret = of_process_work()
end if

return li_ret
end function

public function integer of_process_work ();long ll_writer_row
long ll_new_writer_rows
long ll_obj_written
long ll_dw_row
long ll_dw_row_cnt
integer li_cur_band
integer li_ret = 1
integer li_progress
boolean lb_newpage = false
long ll_row_y
long li_celln
long li_cell

if ib_nested then
	of_register_dynamic(invo_nested_parm.ipo_dynamic_requestor)
	ipo_progress = invo_nested_parm.ipo_progress
	ib_defer_update_y = true
end if

il_rowcount = of_rowcount()
ll_dw_row_cnt = il_rowcount + 1

if not ib_nested then

	if ib_show_progress then
		ipo_progress.il_percent_of_analyse = 5

		if ib_modemultisheet then
			ipo_progress.iw_progress.st_title.text = "Sheet ~"" + invo_parm.is_sheet_name + "~""
		end if

	end if

	if ib_show_progress then
		li_ret = of_analyse_dw(ipo_progress.il_percent_of_analyse)
	else
		li_ret = of_analyse_dw(0)
	end if

	if li_ret <> 1 then
		return li_ret
	end if

	if ib_show_progress then
		ipo_progress.il_progress_rown = ll_dw_row_cnt + of_countnested() * il_nested_weight
		ipo_progress.il_percent_of_process = 70
		ipo_progress.il_change_progress_each = long(round(ipo_progress.il_progress_rown / ipo_progress.il_percent_of_process,0))
		ipo_progress.il_progress_row = 1
	end if

end if

ll_dw_row = 1
ll_row_y = il_base_y

do while ll_dw_row <= ll_dw_row_cnt
	lb_newpage = of_is_newpage(ll_dw_row)

	for li_cur_band = 1 to ii_band_count

		if ib_defer_update_y then
			inv_sheet.beginband(inv_sheet.handle)
		end if

		ll_obj_written = invo_bands[li_cur_band].of_check_process_row(ll_dw_row,ll_row_y,lb_newpage,ipo_progress)

		if ib_cancel then
			li_ret = -1
			exit
		end if

		if ib_defer_update_y then

			if ll_obj_written > 0 then
				ll_row_y = inv_sheet.endband(inv_sheet.handle,ii_units)
			else
				inv_sheet.endband(inv_sheet.handle,ii_units)
			end if

		else
			inv_sheet.updatey(inv_sheet.handle)
			ll_row_y = 0
		end if

	next

	if li_ret <> 1 then
		exit
	end if

	if ib_show_progress then
		ipo_progress.il_cur_change_progress ++

		if ipo_progress.il_cur_change_progress >= ipo_progress.il_change_progress_each then

			if ib_nested then
				li_progress = integer(round(((ipo_progress.il_progress_row + (ll_dw_row * il_nested_weight) / ll_dw_row_cnt) * ipo_progress.il_percent_of_process) / ipo_progress.il_progress_rown,0))
			else
				li_progress = integer(round((ipo_progress.il_progress_row * ipo_progress.il_percent_of_process) / ipo_progress.il_progress_rown,0))
			end if

			of_show_progress(ipo_progress.il_percent_of_analyse + li_progress)
			ipo_progress.il_cur_change_progress = 0
		end if

	end if

	ll_dw_row += ii_rows_per_detail

	if ib_nested then
	else

		if ib_show_progress then
			ipo_progress.il_progress_row += ii_rows_per_detail
		end if

	end if

	if ii_rows_per_detail > 1 then

		if ll_dw_row > ll_dw_row_cnt and ll_dw_row - ii_rows_per_detail < ll_dw_row_cnt then
			ll_dw_row = ll_dw_row_cnt
		end if

	end if

loop

if ( not ib_nested) and li_ret = 1 then
	inv_sheet.updatey(inv_sheet.handle)
	inv_sheet.updatex(inv_sheet.handle)
	li_celln = inv_sheet.getcellcount(inv_sheet.handle)

	if ib_show_progress then
		ipo_progress.il_progress_rown = li_celln
		ipo_progress.il_percent_of_process = 25
		ipo_progress.il_change_progress_each = max(1,long(round(ipo_progress.il_progress_rown / ipo_progress.il_percent_of_process,0)))
		ipo_progress.il_cur_change_progress = 0
		li_cell = 0

		do while li_cell < li_celln
			inv_sheet.writecells(inv_sheet.handle,li_cell,li_cell + ipo_progress.il_change_progress_each,0,ib_enable_merge_cells)
			li_progress = integer(round((li_cell * ipo_progress.il_percent_of_process) / ipo_progress.il_progress_rown,0))
			of_show_progress(5 + 70 + li_progress)
			ipo_progress.il_cur_change_progress = 0
			li_cell += ipo_progress.il_change_progress_each
		loop

	else
		inv_sheet.writecells(inv_sheet.handle,0,li_celln,0,ib_enable_merge_cells)
	end if

	if invo_parm.ib_hide_grid then
		inv_sheet.setprintgridlines(inv_sheet.handle,false)
		inv_sheet.setscreengridlines(inv_sheet.handle,false)
	end if

end if

if ib_show_progress and ( not ib_nested) then

	if ib_cancel then
		close(ipo_progress.iw_progress)
	else
		of_show_progress(100)
		close(ipo_progress.iw_progress)
	end if

	ib_show_progress = false
	setnull(ipo_progress.iw_progress)
end if

if ib_nested then
	invo_nested_parm.il_writer_row = ll_writer_row

	if ib_show_progress then
		ipo_progress.il_progress_row += il_nested_weight
	end if

end if

return li_ret
end function

public function integer of_register_dynamic (powerobject apo_requestor);long li_band

ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.typeof()

choose case ipo_requestortype
	case datawindow!
		idw_requestor = ipo_requestor
	case datastore!
		ids_requestor = ipo_requestor
	case datawindowchild!
		idwc_requestor = ipo_requestor
	case else
		return -1
end choose

for li_band = 1 to ii_band_count
	invo_bands[li_band].of_register_dynamic(ipo_requestor)
next

return 1
end function

protected subroutine of_reset_metadata_cache ();string ls_empty[]
long li_empty[]

is_object = ls_empty
is_object_band = ls_empty
il_object_nested_id = li_empty
il_objectcount = -1
end subroutine

public function long of_rowcount ();choose case ipo_requestortype
	case datawindow!
		return idw_requestor.rowcount()
	case datastore!
		return ids_requestor.rowcount()
	case datawindowchild!
		return idwc_requestor.rowcount()
	case else
		return 0
end choose
end function

public function integer of_set_col_width ();long ll_col_count
long ll_i
integer li_ret = 1

return li_ret
end function

private function integer of_set_yield (boolean ab_yield_status);integer li_i

if ii_band_count > 0 then

	for li_i = 1 to ii_band_count
		invo_bands[li_i].ib_yield_enable = ab_yield_status
	next

end if

return 1
end function

private function integer of_show_progress (integer ai_progress);if ib_show_progress then
	ipo_progress.iw_progress.event ue_show_progress(ai_progress)
end if

return 1
end function

private function integer of_splitband (string as_band_name,integer ai_band_type,integer ai_group_level);long li_object
long li_band_object
long li_y
long li_band
long li_ret
n_dwr_band lnvo_bands[]
n_dwr_field lnvo_field
long li_subband_y
datastore lds_sort
string ls_expr
n_dwr_band lnvo_band

of_cache_metadata()

if of_describe("datawindow." + as_band_name + ".height") = "0" then
	return 1
end if

lds_sort = create datastore
lds_sort.dataobject = "d_dw2xls_object_sort"
li_band_object = 0

for li_object = 1 to il_objectcount

	if is_object_band[li_object] <> as_band_name then
	else
		li_band_object ++
		lds_sort.insertrow(li_band_object)
		lds_sort.setitem(li_band_object,"index",li_object)
		li_y = of_describe_expr(is_object[li_object] + ".y",1,ls_expr)
		lds_sort.setitem(li_band_object,"sort_key",li_y)
	end if

next

lds_sort.setsort("sort_key a")
lds_sort.sort()
li_subband_y = 0
li_band = 1
lnvo_bands[li_band] = of_createband(as_band_name,ai_band_type,ai_group_level,li_subband_y)
li_band_object = 1

do while li_band_object <= lds_sort.rowcount()
	li_object = lds_sort.getitemdecimal(li_band_object,"index")
	setnull(lnvo_field)
	li_ret = lnvo_bands[li_band].of_add_field(is_object[li_object],il_object_nested_id[li_object],lnvo_field)

	choose case li_ret
		case 1
		case -3
			li_subband_y += lnvo_field.of_get_band_y1()
			lnvo_bands[li_band].ib_newpage = false
			li_band ++
			lnvo_bands[li_band] = of_createband(as_band_name,ai_band_type,ai_group_level,li_subband_y)
			lnvo_field.of_setsubbandy(li_subband_y)
			li_ret = lnvo_bands[li_band].of_add_field(is_object[li_object],il_object_nested_id[li_object],lnvo_field)
		case -2
			exit
		case -1
	end choose

	li_band_object ++
loop

destroy(lds_sort)

for li_band = 1 to upperbound(lnvo_bands)

	if upperbound(lnvo_bands[li_band].invo_fields) = 0 then
	else
		ii_band_count ++
		invo_bands[ii_band_count] = lnvo_bands[li_band]
	end if

next

return 1
end function

on n_dwr_service.create
call super::create;
end on

on n_dwr_service.destroy
call super::destroy;
end on

