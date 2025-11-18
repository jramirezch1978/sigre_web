$PBExportHeader$n_dwr_band.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_band from nonvisualobject
end type
end forward

global type n_dwr_band from nonvisualobject
end type
global n_dwr_band n_dwr_band

type variables
public boolean ib_variable_band_height = false
public long il_row_cnt
public string is_band_name
public integer ii_band_type
public integer ii_group_level
public boolean ib_newpage = false
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public boolean ib_enabled = true
private powerobject ipo_requestor
private object ipo_requestortype
private datawindow idw_requestor
private datastore ids_requestor
private datawindowchild idwc_requestor
public integer ii_fields_count
public long il_groupchangerow = 1
public long il_dw_row_count
private integer ii_band_height
public boolean ib_yield_enable = false
public boolean ib_cancel = false
public double id_x_coef
public double id_y_coef
public double id_conv
public n_dwr_grid invo_hgrid
public n_dwr_grid invo_parent_hgrid
public long il_band_y
public n_dwr_grid invo_vgrid
public n_dwr_field invo_fields[]
public n_dwr_workbook inv_book
public n_dwr_worksheet inv_sheet
public n_dwr_service_parm invo_parm
public n_dwr_colors invo_colors
private n_cst_hash_long invo_row_in_detail
public integer ii_rows_per_detail = 1
public integer ii_dw_processing
private boolean ib_has_reports = false
public long il_base_x
public long il_base_y
public long il_subband_y
public boolean ib_nested = false
private string is_skip_key = "dw2xls=skip"
public string band_detail = "1"
public string band_header = "2"
public string band_footer = "3"
public string band_summary = "4"
public string band_groupheader = "5"
public string band_grouptrailer = "6"
private string is_band_id = "1"
public long il_x1 = -1
public long il_x2 = -1
public boolean ib_has_autosize_height_objects = false
public n_dwr_progress ipo_progress
public integer ii_units
end variables

forward prototypes
public function integer of_add_field (string as_name)
public function integer of_add_field (string as_name,long al_instance_id,ref n_dwr_field anvo_field)
public subroutine of_cancel ()
public function integer of_check_process_row (long al_row,long al_base_y,boolean ab_newpage,n_dwr_progress apo_progress)
public function string of_describe (readonly string as_expr)
public function integer of_dynamic_horisontal_layout (long al_row)
public subroutine of_find_row_in_detail ()
public function integer of_init (string as_band_name,integer ai_band_type,integer ai_group_level,boolean ab_newpage,n_dwr_grid anvo_vgrid)
public function integer of_process_row (long al_row,long al_base_y,n_dwr_progress apo_progress)
public function integer of_register (powerobject apo_requestor,n_dwr_workbook anv_book,n_dwr_worksheet anv_sheet,n_dwr_service_parm anvo_parm,n_dwr_colors anvo_colors,integer ai_rows_per_detail,long al_base_x,long al_base_y,long al_subband_y)
public function integer of_register_dynamic (powerobject apo_requestor)
private function integer of_set_row_height (long al_writer_row)
private function integer of_sort_fields ()
end prototypes

public function integer of_add_field (string as_name);n_dwr_field lnvo_field

setnull(lnvo_field)
return of_add_field(as_name,0,lnvo_field)
end function

public function integer of_add_field (string as_name,long al_instance_id,ref n_dwr_field anvo_field);string ls_field_class
string ls_coltype
integer li_ret = 1
integer li_row_in_detail
n_dwr_nested_service_parm lnvo_nested_parm

if not ib_enabled then
	return 1
end if

ls_field_class = of_describe(as_name + ".type")

if isnull(anvo_field) then

	if of_describe(as_name + ".visible") = "0" then
		return 1
	end if

	if of_describe(as_name + ".width") = "0" then
		return 1
	end if

	if pos(of_describe(as_name + ".tag"),is_skip_key) > 0 then
		return 1
	end if

	choose case ls_field_class
		case "datawindow"
			li_ret = -1
		case "bitmap"
			li_ret = -1
		case "button"
			li_ret = -1
		case "column"
			anvo_field = create n_dwr_field
			anvo_field.of_register(ipo_requestor,inv_book,invo_colors,il_base_x,il_base_y,il_subband_y)
			anvo_field.of_init(as_name,1)
		case "compute"
			anvo_field = create n_dwr_field
			anvo_field.of_register(ipo_requestor,inv_book,invo_colors,il_base_x,il_base_y,il_subband_y)
			anvo_field.of_init(as_name,2)
		case "graph"
			li_ret = -1
		case "groupbox"
			li_ret = -1
		case "line"
			li_ret = -1
		case "ole"
			li_ret = -1
		case "ellipse"
			li_ret = -1
		case "rectangle"
			li_ret = -1
		case "report"

			if invo_parm.ib_nested then
				anvo_field = create n_dwr_field
				anvo_field.of_register(ipo_requestor,inv_book,invo_colors,il_base_x,il_base_y,il_subband_y)
				anvo_field.of_init(as_name,4)
			else
				li_ret = -1
			end if

		case "roundrectangle"
			li_ret = -1
		case "tableblob"
			li_ret = -1
		case "text"
			anvo_field = create n_dwr_field
			anvo_field.of_register(ipo_requestor,inv_book,invo_colors,il_base_x,il_base_y,il_subband_y)
			anvo_field.of_init(as_name,3)
	end choose

	if ((li_ret = 1 and ( not isnull(invo_hgrid))) and isvalid(invo_hgrid)) then

		if anvo_field.of_get_x2() - anvo_field.of_get_x1() < invo_hgrid.ii_round_ratio then
			li_ret = -1
		end if

	end if

	if li_ret < 1 then
		return li_ret
	end if

	if ((anvo_field.of_get_x1() >= il_x2) or (anvo_field.of_get_x2() <= il_x1)) then
	else

		if ib_has_autosize_height_objects then
			return -3
		end if

	end if

end if

if anvo_field.ib_autosize_height and anvo_field.ii_dwo_type = 4 then

	if il_x1 = -1 then
		il_x1 = anvo_field.of_get_x1()
	else
		il_x1 = min(il_x1,anvo_field.of_get_x1())
	end if

	if il_x2 = -1 then
		il_x2 = anvo_field.of_get_x2()
	else
		il_x2 = min(il_x2,anvo_field.of_get_x2())
	end if

	ib_has_autosize_height_objects = true
end if

choose case ls_field_class
	case "column"
	case "compute"
	case "text"
	case "report"
		lnvo_nested_parm = create n_dwr_nested_service_parm
		lnvo_nested_parm.inv_sheet = inv_sheet
		lnvo_nested_parm.invo_colors = invo_colors
		lnvo_nested_parm.is_parent_band_id = is_band_id
		lnvo_nested_parm.ipo_progress = ipo_progress
		anvo_field.is_nested_instance_id = string(al_instance_id)
		li_ret = anvo_field.of_createnestedservice(lnvo_nested_parm,invo_parm)
	case else
		return -1
end choose

if li_ret = 1 then

	if not ib_variable_band_height then

		if anvo_field.of_get_band_y1() > ii_band_height + invo_hgrid.ii_round_ratio then
			li_ret = -1
		end if

		if li_ret = 1 then
			ii_fields_count ++
			invo_fields[ii_fields_count] = anvo_field
		end if

	else
		ii_fields_count ++
		invo_fields[ii_fields_count] = anvo_field
	end if

end if

if li_ret = 1 then

	if ii_band_type = 3 and ii_rows_per_detail > 1 then
		li_row_in_detail = invo_row_in_detail.of_get_value(as_name)

		if li_row_in_detail > 0 then
			anvo_field.ii_row_in_detail = li_row_in_detail
		end if

	end if

	if anvo_field.ii_dwo_type = 4 then
		ib_has_reports = true
	end if

end if

return li_ret
end function

public subroutine of_cancel ();long li_i

ib_cancel = true

for li_i = 1 to ii_fields_count

	if invo_fields[li_i].ii_dwo_type = 4 then
		invo_fields[li_i].of_cancel_nested()
	end if

next
end subroutine

public function integer of_check_process_row (long al_row,long al_base_y,boolean ab_newpage,n_dwr_progress apo_progress);long ll_obj_written

if (( not ib_enabled) and ( not ((ii_band_type = 2) or (ii_band_type = 3)))) then
	return 0
end if

choose case ii_band_type
	case 1

		if ((al_row = 1) or (ab_newpage and invo_parm.ib_group_pageheader)) then
			ll_obj_written = of_process_row(al_row,al_base_y,apo_progress)
		end if

	case 2

		if ((al_row = il_groupchangerow and il_dw_row_count > 0) or (ab_newpage)) then

			if ib_enabled then
				ll_obj_written = of_process_row(al_row,al_base_y,apo_progress)
			end if

			if al_row = il_groupchangerow and il_dw_row_count > 0 then

				choose case ipo_requestortype
					case datawindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case datastore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case datawindowchild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case else
						return -1
				end choose

				if il_groupchangerow <= 0 then
					il_groupchangerow = il_dw_row_count + 1
				end if

			end if

		end if

			case 3

		if al_row <= il_dw_row_count then
			ll_obj_written = of_process_row(al_row,al_base_y,apo_progress)
		end if

			case 4

		if ((al_row = il_groupchangerow) or (ab_newpage)) then

			if al_row > 1 and ib_enabled then
				ll_obj_written = of_process_row(al_row - 1,al_base_y,apo_progress)
			end if

			if invo_parm.ib_group_pagebreak and ib_newpage then

				if al_row > 1 and al_row <= il_dw_row_count + 1 and ab_newpage then
					inv_sheet.addhbreak(inv_sheet.handle,al_base_y,ii_units)
				end if

			end if

			if al_row = il_groupchangerow then

				choose case ipo_requestortype
					case datawindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case datastore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case datawindowchild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1,ii_group_level)
					case else
						return 0
				end choose

				if il_groupchangerow <= 0 then
					il_groupchangerow = il_dw_row_count + 1
				end if

			end if

		end if

			case 5

		if al_row = il_dw_row_count + 1 then
			ll_obj_written = of_process_row(al_row - 1,al_base_y,apo_progress)
		end if

			case 6

		if ((al_row = il_dw_row_count + 1) or (ab_newpage)) then
			ll_obj_written = of_process_row(al_row - 1,al_base_y,apo_progress)
		end if

end choose

return ll_obj_written
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

public function integer of_dynamic_horisontal_layout (long al_row);integer li_ret = 1
integer li_i

if ib_variable_band_height and ii_band_type = 3 then
	ii_band_height = integer(of_describe("evaluate('rowheight()'," + string(al_row) + ")"))
else
	ii_band_height = integer(of_describe("datawindow." + is_band_name + ".height"))
end if

if ii_band_height > 0 then

	if invo_parm.ib_keep_band_height then
		il_ysplit_ind_from = invo_hgrid.of_add_split(il_base_y + 0)
		il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)
	else

		if ii_dw_processing = 1 and ib_variable_band_height then
			il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)
		end if

	end if

	if ii_fields_count > 0 then

		for li_i = 1 to ii_fields_count

			if invo_fields[li_i].ii_dwo_type = 4 then
				continue
			else

				if invo_fields[li_i].of_get_y1() <= il_base_y + ii_band_height + invo_hgrid.ii_round_ratio then
					invo_fields[li_i].il_ysplit_ind_from = invo_hgrid.of_add_split(invo_fields[li_i].of_get_y1(al_row))

					if ii_dw_processing = 1 and ib_variable_band_height and ii_band_type = 3 then
						invo_fields[li_i].il_ysplit_ind_to = il_ysplit_ind_to
					else
						invo_fields[li_i].il_ysplit_ind_to = invo_hgrid.of_add_split(invo_fields[li_i].of_get_y2(al_row))
					end if

				end if

			end if

		next

	end if

end if

return li_ret
end function

public subroutine of_find_row_in_detail ();string ls_syntax
long ll_pos
long ll_pos_end
long ll_start_pos = 1
string ls_column
string ls_name
string ls_row_in_detail
integer li_row_in_detail

ls_syntax = of_describe("Datawindow.Syntax")
invo_row_in_detail = create n_cst_hash_long

do while ll_start_pos >= 0
	ll_pos = pos(ls_syntax,"~r~ncolumn(",ll_start_pos)

	if ll_pos > 0 then
		ll_pos_end = pos(ls_syntax,"~r~n",ll_pos + 7)

		if ll_pos_end > 0 then
			ll_start_pos = ll_pos_end - 2
		else
			ll_start_pos = -1
			ll_pos_end = len(ls_syntax) + 1
		end if

		ls_column = mid(ls_syntax,ll_pos,ll_pos_end - ll_pos)
		ll_pos = pos(ls_column,"name=")

		if ll_pos > 0 then
			ll_pos_end = pos(ls_column," ",ll_pos + 5)

			if ll_pos_end > 0 then
				ls_name = mid(ls_column,ll_pos + 5,ll_pos_end - ll_pos - 5)
				ll_pos = pos(ls_column,"row_in_detail=")

				if ll_pos > 0 then
					ll_pos_end = pos(ls_column," ",ll_pos + 14)

					if ll_pos_end > 0 then
						ls_row_in_detail = mid(ls_column,ll_pos + 14,ll_pos_end - ll_pos - 14)
						li_row_in_detail = integer(ls_row_in_detail)
						invo_row_in_detail.of_set_value(ls_name,li_row_in_detail)
					end if

				end if

			end if

		end if

	else
		ll_start_pos = -1
	end if

loop
end subroutine

public function integer of_init (string as_band_name,integer ai_band_type,integer ai_group_level,boolean ab_newpage,n_dwr_grid anvo_vgrid);integer li_ret = 1
boolean lb_vgrid_def = false

is_band_name = as_band_name
ii_band_type = ai_band_type
ii_group_level = ai_group_level
ib_newpage = ab_newpage

if ii_band_type = 3 then
	ib_variable_band_height = true
end if

ii_dw_processing = integer(of_describe("Datawindow.Processing"))

if not isnull(anvo_vgrid) then

	if isvalid(anvo_vgrid) then
		lb_vgrid_def = true
	end if

end if

if lb_vgrid_def then
	invo_vgrid = anvo_vgrid
else
	invo_vgrid = create n_dwr_grid
	invo_vgrid.ii_round_ratio = invo_vgrid.ii_round_init_ratio * id_conv
end if

if ai_band_type = 3 and ii_rows_per_detail > 1 then
	of_find_row_in_detail()
end if

if not ib_variable_band_height then
	invo_hgrid = create n_dwr_grid
	invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv
	ii_band_height = integer(of_describe("datawindow." + is_band_name + ".height"))

	if il_base_y < 0 then
		ii_band_height = ii_band_height + il_base_y
	end if

	if ii_band_height > 0 then
		ib_enabled = true

		if invo_parm.ib_keep_band_height then
			il_ysplit_ind_from = invo_hgrid.of_add_split(0)
			il_ysplit_ind_to = invo_hgrid.of_add_split(ii_band_height)
		end if

		il_row_cnt = invo_hgrid.of_get_split_count() - 1

		if il_row_cnt < 0 then
			il_row_cnt = 0
		end if

		ib_enabled = true
	else
		ib_enabled = false
	end if

else
	ib_enabled = true
end if

choose case ai_band_type
	case 1
		is_band_id = "2"
	case 2
		is_band_id = "5"
	case 3
		is_band_id = "1"
	case 4
		is_band_id = "6"
	case 5
		is_band_id = "4"
	case 6
		is_band_id = "3"
end choose

of_sort_fields()
return li_ret
end function

public function integer of_process_row (long al_row,long al_base_y,n_dwr_progress apo_progress);integer li_i
integer li_ret = 1
integer li_res = 1
long ll_band_row
long ll_obj_written
integer li_merge_row
long ll_band_col
integer li_merge_col
any la_val
time lt_time
datetime ldt_dtime
date ld_date
long ll_nested_rows
long ll_nested_ret
long ll_current_hsplit_values[]
boolean lb_row_height_set = false

if al_row = 0 and il_dw_row_count = 0 and ib_nested then
	return ll_obj_written
end if

if ib_has_reports then

	for li_i = 1 to ii_fields_count

		if invo_fields[li_i].ii_dwo_type = 4 then
			ll_nested_ret = invo_fields[li_i].of_process_nested(al_row,al_base_y,invo_hgrid,apo_progress)

			if ll_nested_ret > ll_nested_rows then
				ll_nested_rows = ll_nested_ret
			end if

			ll_obj_written ++
			continue
		end if

	next

end if

il_row_cnt = 0

for li_i = 1 to ii_fields_count

	if invo_fields[li_i].ii_dwo_type = 4 then
	else

		if invo_fields[li_i].of_get_visible(al_row) <> 1 then
		else
			ll_obj_written ++
			la_val = invo_fields[li_i].of_getvalue(al_row)

			choose case classname(la_val)
				case "integer", "decimal", "double"  , "number", "real"
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,double(la_val),invo_fields[li_i].of_get_format(al_row),ii_units)
				case "string", "char"
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,string(la_val),invo_fields[li_i].of_get_format(al_row),ii_units)
				case "date"
					ld_date = la_val
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,ld_date,invo_fields[li_i].of_get_format(al_row),ii_units)
				case "datetime"
					ldt_dtime = la_val
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,ldt_dtime,invo_fields[li_i].of_get_format(al_row),ii_units)
				case "time"
					lt_time = la_val
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,lt_time,invo_fields[li_i].of_get_format(al_row),ii_units)
				case else
					inv_sheet.of_create_cell(invo_fields[li_i].of_get_x1(al_row),invo_fields[li_i].of_get_x2(al_row),invo_fields[li_i].of_get_y1(al_row) + al_base_y,invo_fields[li_i].of_get_y2(al_row) + al_base_y,"",invo_fields[li_i].of_get_format(al_row),ii_units)
			end choose

			if ib_yield_enable then
				yield()
			end if

			if ib_cancel then
				li_ret = -1
				exit
			end if

		end if

	end if

next

return ll_obj_written
end function

public function integer of_register (powerobject apo_requestor,n_dwr_workbook anv_book,n_dwr_worksheet anv_sheet,n_dwr_service_parm anvo_parm,n_dwr_colors anvo_colors,integer ai_rows_per_detail,long al_base_x,long al_base_y,long al_subband_y);il_base_x = al_base_x
il_base_y = al_base_y
il_subband_y = al_subband_y
ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.typeof()

choose case ipo_requestortype
	case datawindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.rowcount()
	case datastore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.rowcount()
	case datawindowchild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.rowcount()
	case else
		return -1
end choose

inv_book = anv_book
inv_sheet = anv_sheet
invo_parm = anvo_parm
invo_colors = anvo_colors
ii_rows_per_detail = ai_rows_per_detail
return 1
end function

public function integer of_register_dynamic (powerobject apo_requestor);long li_i

ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.typeof()

choose case ipo_requestortype
	case datawindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.rowcount()
	case datastore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.rowcount()
	case datawindowchild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.rowcount()
	case else
		return -1
end choose

for li_i = 1 to ii_fields_count
	invo_fields[li_i].of_register_dynamic(ipo_requestor)
next

return 1
end function

private function integer of_set_row_height (long al_writer_row);long ll_i
integer li_ret = 1

return li_ret
end function

private function integer of_sort_fields ();n_dwr_field lnv_col[]
n_dwr_field lnv_rep[]
integer li_field
integer li_fieldn
integer li_base

for li_field = 1 to ii_fields_count

	if invo_fields[li_field].ii_dwo_type = 4 then
		lnv_rep[upperbound(lnv_rep) + 1] = invo_fields[li_field]
	else
		lnv_rep[upperbound(lnv_col) + 1] = invo_fields[li_field]
	end if

next

li_fieldn = upperbound(lnv_col)

for li_field = 1 to li_fieldn
	invo_fields[li_field] = lnv_col[li_field]
next

li_base = li_fieldn
li_fieldn = upperbound(lnv_rep)

for li_field = 1 to li_fieldn
	invo_fields[li_base + li_field] = lnv_rep[li_field]
next

return 1
end function

on n_dwr_band.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_band.destroy
triggerevent("destructor")
call super::destroy
end on

