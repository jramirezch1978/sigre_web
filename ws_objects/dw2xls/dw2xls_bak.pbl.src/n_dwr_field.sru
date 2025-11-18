$PBExportHeader$n_dwr_field.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_field from nonvisualobject
end type
end forward

shared variables
boolean ib_system_format_cached = false
string is_system_date_format
string is_system_shortdate_format
string is_system_longdate_format
string is_system_time_format
string is_system_currency_format
end variables

global type n_dwr_field from nonvisualobject
end type
global n_dwr_field n_dwr_field

type variables
public integer ii_dwo_type
public string is_dwo_name
public string is_coltype
public integer ii_colsize
public long il_xsplit_ind_from
public long il_xsplit_ind_to
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public long il_base_x
public long il_base_y
public long il_subband_y
private long il_cached_y1 = -1000000000
private string is_expr_y1 = "-"
private long il_cached_x1 = -1
private string is_expr_x1 = "-"
private long il_cached_height = -1
private string is_expr_height = "-"
private long il_cached_y2 = -1000000000
private string is_expr_y2 = "-"
private long il_cached_width = -1
private string is_expr_width = "-"
private long il_cached_x2 = -1
private string is_expr_x2 = "-"
public string is_text
public powerobject ipo_requestor
private object ipo_requestortype
private datawindow idw_requestor
private datastore ids_requestor
private datawindowchild idwc_requestor
private integer ii_column_display_type
public n_dwr_workbook inv_book
public n_dwr_colors invo_colors
public boolean ib_color_expr = false
public boolean ib_bg_color_expr = false
public boolean ib_format_expr = false
public boolean ib_font_face_expr = false
public boolean ib_font_height_expr = false
public boolean ib_font_italic_expr = false
public boolean ib_font_underline_expr = false
public boolean ib_font_weight_expr = false
public boolean ib_alignment_expr = false
public string is_text_expr = ""
public string is_color_expr = ""
public string is_bg_color_expr = ""
public string is_format_expr = ""
public string is_font_face_expr = ""
public string is_font_height_expr = ""
public string is_font_italic_expr = ""
public string is_font_underline_expr = ""
public string is_font_weight_expr = ""
public string is_alignment_expr = ""
public boolean ib_custom_format = false
public integer ii_row_in_detail = 1
public long il_dw_row_count
private boolean ib_usetrc = false
private n_dwr_service_base inv_nestedservice
private n_dwr_nested_service_parm inv_nested_service_parm
public n_dwr_service_parm inv_parm
private datastore ids_reportdata
private datawindowchild idwc_child_cache
private long il_child_cache_row = -1
public integer cdt_text = 1
public integer cdt_checkbox = 2
public integer cdt_dddw = 3
public integer cdt_ddlb = 4
public integer cdt_codetable = 5
public integer cdt_report = 6
public integer dt_column = 1
public integer dt_compute = 2
public integer dt_text = 3
public integer dt_report = 4
private boolean ib_disable_lookup_display = false
private long il_id
public string is_nested_dataobject = ""
public string is_nested_instance_id = ""
private n_dwr_psr inv_nested_data
private string is_nested_dddw_column_ids[]
private string is_parent_band_id
private string is_nested_processing = ""
public string band_detail = "1"
public string band_header = "2"
public string band_footer = "3"
public string band_summary = "4"
public string band_groupheader = "5"
public string band_grouptrailer = "6"
public boolean ib_autosize_height = false
public n_dwr_format inv_format
public long il_format_ix
end variables

forward prototypes
public subroutine of_cancel_nested ()
public function string of_change_format (ref string as_format,string as_type)
public function integer of_check_property (string as_property_name,ref boolean ab_is_expression,ref string as_expression,ref string as_value)
public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm,n_dwr_service_parm anvo_parm)
public function string of_descr_alignment ()
public function long of_descr_alignment2 ()
public function integer of_descr_bg_color ()
public function long of_descr_bg_color2 ()
public function integer of_descr_color ()
public function long of_descr_color2 ()
public function long of_descr_font_charset ()
public function string of_descr_font_face ()
public function long of_descr_font_family ()
public function long of_descr_font_height ()
public function boolean of_descr_font_italic ()
public function integer of_descr_font_underline ()
public function boolean of_descr_font_weight ()
public function integer of_descr_font_weight2 ()
public function string of_descr_numformat ()
public function string of_describe (readonly string as_expr)
public function long of_describe_expr (string as_expr,long al_row)
public function long of_describe_expr (string as_expr,long al_row,ref string as_prop_expr)
public function string of_describe_str_expr (string as_expr,long al_row)
public function string of_describe_str_expr (string as_expr,long al_row,ref string as_prop_expr)
private function datastore of_dwc2ds (datawindowchild adwc_src,boolean ab_copydata)
public function integer of_dynamic_horisontal_layout (long al_row,n_dwr_grid anvo_hgrid)
public function integer of_eval_alignment (long al_row)
public function integer of_eval_alignment (n_xls_format anvo_format,long al_row)
public function integer of_eval_bg_color (long al_row)
public function integer of_eval_bg_color (n_xls_format anvo_format,long al_row)
public function integer of_eval_color (long al_row)
public function integer of_eval_color (n_xls_format anvo_format,long al_row)
public function integer of_eval_font_face (long al_row)
public function integer of_eval_font_face (n_xls_format anvo_format,long al_row)
public function integer of_eval_font_height (long al_row)
public function integer of_eval_font_height (n_xls_format anvo_format,long al_row)
public function integer of_eval_font_italic (long al_row)
public function integer of_eval_font_italic (n_xls_format anvo_format,long al_row)
public function integer of_eval_font_underline (long al_row)
public function integer of_eval_font_underline (n_xls_format anvo_format,long al_row)
public function integer of_eval_font_weight (long al_row)
public function integer of_eval_font_weight (n_xls_format anvo_format,long al_row)
public function integer of_eval_numformat (long al_row)
public function integer of_eval_numformat (n_xls_format anvo_format,long al_row)
public function string of_evaluate_str0 (readonly string as_expr,long al_row)
public function long of_evaluate0 (readonly string as_expr,long al_row)
public function long of_get_band_y1 ()
public function long of_get_band_y2 ()
private function integer of_get_column_display_type ()
public function long of_get_format (long al_row)
public function long of_get_height (long al_row)
public function string of_get_item_coltype ()
public function string of_get_system_currency_format ()
public function integer of_get_visible (long al_row)
public function long of_get_width (long al_row)
public function long of_get_x1 ()
public function long of_get_x1 (long al_row)
public function long of_get_x2 ()
public function long of_get_x2 (readonly long al_row)
public function long of_get_y1 ()
public function long of_get_y1 (long al_row)
public function long of_get_y2 ()
public function long of_get_y2 (long al_row)
private function integer of_getdddwcolumnids (datawindowchild adw,ref string as_id[])
public function any of_getvalue (long al_row)
public function any of_getvalue_ds (long al_row)
public function any of_getvalue_dw (long al_row)
public function any of_getvalue_dwc (long al_row)
public function integer of_init (string as_dwo_name,integer ai_dwo_type)
public function long of_process_nested (long al_row,long al_writer_row,n_dwr_grid anvo_hgrid,n_dwr_progress apo_progress)
public function integer of_register (powerobject apo_requestor,n_dwr_workbook anv_book,n_dwr_colors anvo_colors,long al_base_x,long al_base_y,long al_subband_y)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_set_bg_color (n_xls_format a_format,long al_row)
public function integer of_set_color (n_xls_format a_format,long al_row)
public function integer of_setformat ()
public subroutine of_setsubbandy (long ai_subband_y)
private function string of_unquote (string as_str)
end prototypes

public subroutine of_cancel_nested ();if ii_dwo_type = 4 then
	inv_nestedservice.of_cancel()
end if
end subroutine

public function string of_change_format (ref string as_format,string as_type);long ll_pos
n_dwr_string lnvo_str
string ls_arr[]
string ls_emp[]
long ll_cnt
long ll_i
long ll_ret

if not ib_system_format_cached then
	ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sShortDate",regstring!,is_system_shortdate_format)

	if ll_ret <> 1 then
		is_system_shortdate_format = "dd.MM.yyyy"
	end if

	ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sLongDate",regstring!,is_system_longdate_format)

	if ll_ret <> 1 then
		is_system_longdate_format = "dd MMMM yyyy"
	end if

	ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sTimeFormat",regstring!,is_system_time_format)

	if ll_ret <> 1 then
		is_system_time_format = "HH:mm"
	end if

	is_system_date_format = is_system_shortdate_format
	is_system_currency_format = of_get_system_currency_format()
	ib_system_format_cached = true
end if

ll_pos = pos(as_format,"@")

if ll_pos > 0 then
	as_format = "[general]"
end if

if is_coltype = "d" then
	as_format = lnvo_str.of_globalreplace(as_format,"[general]","[shortdate]")
else

	if is_coltype = "dt" then
		as_format = lnvo_str.of_globalreplace(as_format,"[general]","[shortdate]")
	else

		if is_coltype = "t" then
			as_format = lnvo_str.of_globalreplace(as_format,"[general]","[time]")
		else
			as_format = lnvo_str.of_globalreplace(as_format,"[general]","@")
		end if

	end if

end if

as_format = lnvo_str.of_globalreplace(as_format,"[currency]",is_system_currency_format)
as_format = lnvo_str.of_globalreplace(as_format,"[shortdate]",is_system_shortdate_format)
as_format = lnvo_str.of_globalreplace(as_format,"[longdate]",is_system_longdate_format)
as_format = lnvo_str.of_globalreplace(as_format,"[date]",is_system_date_format)
as_format = lnvo_str.of_globalreplace(as_format,"[time]",is_system_time_format)

if pos(as_format,";") > 0 then
	ll_cnt = lnvo_str.of_parsetoarray(as_format,";",ls_arr)

	choose case as_type
		case "n"

			if ll_cnt > 3 then
				ll_cnt = 3
			end if

		case else

			if ll_cnt > 1 then
				ll_cnt = 1
			end if

	end choose

	for ll_i = 1 to ll_cnt
		ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_arr[ll_i],"'","~"")
		ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_emp[ll_i],"@","General")
	next

	lnvo_str.of_arraytostring(ls_emp,";",as_format)
end if

if ii_colsize > 255 then
	as_format = ""
end if

return as_format
end function

public function integer of_check_property (string as_property_name,ref boolean ab_is_expression,ref string as_expression,ref string as_value);integer li_ret
string ls_str
long ll_pos

choose case ipo_requestortype
	case datawindow!
		ls_str = idw_requestor.describe(is_dwo_name + "." + as_property_name)
	case datastore!
		ls_str = ids_requestor.describe(is_dwo_name + "." + as_property_name)
	case datawindowchild!
		ls_str = idwc_requestor.describe(is_dwo_name + "." + as_property_name)
	case else
		return -1
end choose

if ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
	ll_pos = pos(lower(ls_str),"~t")

	if ll_pos > 0 then
		as_expression = right(ls_str,len(ls_str) - ll_pos)

		if right(as_expression,1) = "~"" then
			as_expression = left(as_expression,len(as_expression) - 1)
		end if

		ab_is_expression = trim(as_expression) <> ""
		ls_str = left(ls_str,ll_pos - 1)

		if left(ls_str,1) = "~"" then
			ls_str = right(ls_str,len(ls_str) - 1)
		end if

	end if

	as_value = ls_str
	li_ret = 1
else
	li_ret = -1
end if

return li_ret
end function

public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm,n_dwr_service_parm anvo_parm);integer li_ret = -1
long ll_parent_rowcount
string ls_dwo = ""
blob lblob_1
environment e
string ls_tmpfile = "dw2xls_tmp.psr"
datawindowchild ldwc_nested

inv_nested_service_parm = anvo_nested_parm
inv_parm = anvo_parm
is_parent_band_id = inv_nested_service_parm.is_parent_band_id
ids_reportdata = create datastore

choose case ipo_requestortype
	case datawindow!
		ls_dwo = idw_requestor.dataobject
		ll_parent_rowcount = idw_requestor.rowcount()
	case datastore!
		ls_dwo = ids_requestor.dataobject
		ll_parent_rowcount = ids_requestor.rowcount()
	case else
		return -1
end choose

if ll_parent_rowcount = 0 then
	return -1
end if

if ls_dwo <> "" then
	ids_reportdata.dataobject = ls_dwo
end if

choose case ipo_requestortype
	case datawindow!, datastore!
		getenvironment(e)

		if e.pbmajorrevision < 6 then

			if ipo_requestor.dynamic saveas(ls_tmpfile,psreport!,true) <> 1 then
				return -1
			end if

			ids_reportdata.dataobject = ls_tmpfile
			filedelete(ls_tmpfile)
		else
			ipo_requestor.dynamic getfullstate(lblob_1)
			ids_reportdata.dynamic setfullstate(lblob_1)
		end if

		ids_reportdata.modify("Datawindow.Processing=5")
	case else
		return -1
end choose

li_ret = ids_reportdata.getchild(is_dwo_name,ldwc_nested)

if li_ret = 1 then
	il_child_cache_row = 1
	idwc_child_cache = ldwc_nested
	anvo_nested_parm.il_nested_x = of_get_x1()
	anvo_nested_parm.il_nested_y = of_get_y1()
	inv_nestedservice = create using "n_dwr_service"
	li_ret = inv_nestedservice.of_create(idwc_child_cache,inv_book,":not applicable:",anvo_parm,anvo_nested_parm)
end if

if li_ret = 1 then
	li_ret = inv_nestedservice.of_analyse_dw(0)
end if

return li_ret
end function

public function string of_descr_alignment ();integer li_ret
string ls_value = "-1"

li_ret = of_check_property("alignment",ib_alignment_expr,is_alignment_expr,ls_value)

if li_ret <> 1 then
	ls_value = "-1"
end if

choose case ls_value
	case "0"
		return "left"
	case "1"
		return "right"
	case "2"
		return "center"
	case "3"
		return "justified"
	case else

		if is_coltype = "n" then
			return "right"
		else
			return "left"
		end if

end choose
end function

public function long of_descr_alignment2 ();integer li_ret
string ls_value = "-1"

li_ret = of_check_property("alignment",ib_alignment_expr,is_alignment_expr,ls_value)

if li_ret <> 1 then

	if is_coltype = "n" then
		return 1
	else
		return 0
	end if

else
	return long(ls_value)
end if
end function

public function integer of_descr_bg_color ();integer li_ret
string ls_str
string ls_value
long ll_color

ls_str = of_describe(is_dwo_name + ".Background.Mode")

if ls_str <> "1" then
	li_ret = of_check_property("Background.Color",ib_bg_color_expr,is_bg_color_expr,ls_value)

	if li_ret = 1 then

		if isnumber(ls_value) then
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

public function long of_descr_bg_color2 ();integer li_ret
string ls_str
string ls_value
long ll_color

ll_color = 1073741824
ls_str = of_describe(is_dwo_name + ".Background.Mode")

if ls_str <> "1" then
	li_ret = of_check_property("Background.Color",ib_bg_color_expr,is_bg_color_expr,ls_value)

	if li_ret = 1 then

		if isnumber(ls_value) then
			ll_color = long(ls_value)
		end if

	end if

end if

return ll_color
end function

public function integer of_descr_color ();integer li_ret
string ls_value
long ll_color

li_ret = of_check_property("Color",ib_color_expr,is_color_expr,ls_value)

if li_ret = 1 then

	if isnumber(ls_value) then
		ll_color = invo_colors.of_get_color(long(ls_value))
		return invo_colors.of_get_custom_color_index(ll_color)
	else
		return -1
	end if

else
	return -1
end if
end function

public function long of_descr_color2 ();integer li_ret
string ls_value
long ll_color

li_ret = of_check_property("Color",ib_color_expr,is_color_expr,ls_value)

if li_ret = 1 then

	if isnumber(ls_value) then
		ll_color = long(ls_value)
		return ll_color
	else
		return 0
	end if

else
	return 0
end if
end function

public function long of_descr_font_charset ();integer li_ret

li_ret = long(of_describe(is_dwo_name + ".Font.Charset"))
return li_ret
end function

public function string of_descr_font_face ();integer li_ret
string ls_value

li_ret = of_check_property("Font.Face",ib_font_face_expr,is_font_face_expr,ls_value)

if li_ret = 1 then
	return ls_value
else
	return "Arial"
end if
end function

public function long of_descr_font_family ();integer li_ret

li_ret = long(of_describe(is_dwo_name + ".Font.Family"))
return li_ret
end function

public function long of_descr_font_height ();integer li_ret
string ls_value

li_ret = of_check_property("Font.Height",ib_font_height_expr,is_font_height_expr,ls_value)

if li_ret = 1 then

	if isnumber(ls_value) then
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

li_ret = of_check_property("Font.Italic",ib_font_italic_expr,is_font_italic_expr,ls_value)

if li_ret = 1 then
	return ((lower(ls_value) = "yes") or (ls_value = "1"))
else
	return false
end if
end function

public function integer of_descr_font_underline ();integer li_ret
string ls_value

li_ret = of_check_property("font.underline",ib_font_underline_expr,is_font_underline_expr,ls_value)

if li_ret = 1 then

	if ((lower(ls_value) = "yes") or (ls_value = "1")) then
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

li_ret = of_check_property("font.weight",ib_font_weight_expr,is_font_weight_expr,ls_value)

if li_ret = 1 then

	if isnumber(ls_value) then
		return abs(integer(ls_value)) = 700
	else
		return false
	end if

else
	return false
end if
end function

public function integer of_descr_font_weight2 ();integer li_ret
string ls_value

li_ret = of_check_property("font.weight",ib_font_weight_expr,is_font_weight_expr,ls_value)

if li_ret = 1 then

	if isnumber(ls_value) then
		return abs(integer(ls_value))
	else
		return 400
	end if

else
	return 400
end if
end function

public function string of_descr_numformat ();integer li_ret
string ls_value

li_ret = of_check_property("Format",ib_format_expr,is_format_expr,ls_value)

if li_ret = 1 then
	return ls_value
else
	return ""
end if
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

public function long of_describe_expr (string as_expr,long al_row);string ls_val
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

	if isnumber(ls_val) then
		return long(ls_val)
	end if

end if

return -1
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

public function string of_describe_str_expr (string as_expr,long al_row,ref string as_prop_expr);string ls_val
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
		return ""
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
			return ""
	end choose

	return ls_val
else
	as_prop_expr = ""
	return ls_val
end if
end function

private function datastore of_dwc2ds (datawindowchild adwc_src,boolean ab_copydata);datastore lds_res
boolean lb_copy_using_psr = false
string ls_tmpfile = "dw2xls_tmp.psr"

lds_res = create datastore
adwc_src.modify("DataWindow.Crosstab.StaticMode=Yes")

if not lb_copy_using_psr then
	lds_res.create(adwc_src.describe("Datawindow.Syntax"))

	if ab_copydata then
		adwc_src.rowscopy(1,adwc_src.rowcount(),primary!,lds_res,1,primary!)
		lds_res.groupcalc()
	end if

else

	if ab_copydata then
		filedelete(ls_tmpfile)

		if adwc_src.saveas(ls_tmpfile,psreport!,true) <> 1 then
			lds_res.create(adwc_src.describe("Datawindow.Syntax"))
			adwc_src.rowscopy(1,adwc_src.rowcount(),primary!,lds_res,1,primary!)
			lds_res.groupcalc()
		else
			lds_res.dataobject = ls_tmpfile
			filedelete(ls_tmpfile)
		end if

	else
		lds_res.create(adwc_src.describe("Datawindow.Syntax"))
	end if

end if

return lds_res
end function

public function integer of_dynamic_horisontal_layout (long al_row,n_dwr_grid anvo_hgrid);return 1
end function

public function integer of_eval_alignment (long al_row);long ll_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_value = long(trim(of_describe("evaluate(~"" + is_alignment_expr + "~", " + string(al_row) + ")")))
	inv_format.sethalign(inv_format.handle,ll_value)
	return 1
end if

return -1
end function

public function integer of_eval_alignment (n_xls_format anvo_format,long al_row);string ls_value
string ls_align

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = trim(of_describe("evaluate(~"" + is_alignment_expr + "~", " + string(al_row) + ")"))

	choose case ls_value
		case "0"
			ls_align = "left"
		case "1"
			ls_align = "right"
		case "2"
			ls_align = "center"
		case "3"
			ls_align = "justified"
		case else

			if is_coltype = "n" then
				ls_align = "right"
			else
				ls_align = "left"
			end if

	end choose

	anvo_format.of_set_align(ls_align)
	return 1
end if

return -1
end function

public function integer of_eval_bg_color (long al_row);integer li_color_index
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_color = long(of_describe("evaluate(~"" + is_bg_color_expr + "~", " + string(al_row) + ")"))
	inv_format.setbgcolor(inv_format.handle,ll_color)
	return 1
end if

return -1
end function

public function integer of_eval_bg_color (n_xls_format anvo_format,long al_row);integer li_color_index
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_bg_color_expr + "~", " + string(al_row) + ")")

	if isnumber(ls_value) then
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

public function integer of_eval_color (long al_row);integer li_color_index
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_color = long(of_describe("evaluate(~"" + is_color_expr + "~", " + string(al_row) + ")"))
	inv_format.setfgcolor(inv_format.handle,ll_color)
	return 1
end if

return -1
end function

public function integer of_eval_color (n_xls_format anvo_format,long al_row);integer li_color_index
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_color_expr + "~", " + string(al_row) + ")")

	if isnumber(ls_value) then
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

public function integer of_eval_font_face (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = trim(of_describe("evaluate(~"" + is_font_face_expr + "~", " + string(al_row) + ")"))

	if ls_value <> "" then
		inv_format.setfontname(inv_format.handle,ls_value)
		return 1
	end if

end if

return -1
end function

public function integer of_eval_font_face (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = trim(of_describe("evaluate(~"" + is_font_face_expr + "~", " + string(al_row) + ")"))

	if ls_value <> "" then
		anvo_format.of_set_font(ls_value)
		return 1
	end if

end if

return -1
end function

public function integer of_eval_font_height (long al_row);long ll_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_value = long(of_describe("evaluate(~"" + is_font_height_expr + "~", " + string(al_row) + ")"))
	inv_format.setfontsize(inv_format.handle,abs(ll_value))
	return 1
end if

return -1
end function

public function integer of_eval_font_height (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_height_expr + "~", " + string(al_row) + ")")

	if isnumber(ls_value) then
		anvo_format.of_set_size(abs(integer(ls_value)))
		return 1
	end if

end if

return -1
end function

public function integer of_eval_font_italic (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_italic_expr + "~", " + string(al_row) + ")")

	if ((lower(ls_value) = "yes") or (ls_value = "1")) then
		inv_format.setfontitalic(inv_format.handle,1)
	else
		inv_format.setfontitalic(inv_format.handle,0)
	end if

	return 1
end if

return -1
end function

public function integer of_eval_font_italic (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_italic_expr + "~", " + string(al_row) + ")")
	anvo_format.of_set_italic((lower(ls_value) = "yes") or (ls_value = "1"))
	return 1
end if

return -1
end function

public function integer of_eval_font_underline (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_underline_expr + "~", " + string(al_row) + ")")

	if ((lower(ls_value) = "yes") or (ls_value = "1")) then
		inv_format.setfontunderline(inv_format.handle,1)
	else
		inv_format.setfontunderline(inv_format.handle,0)
	end if

	return 1
end if

return -1
end function

public function integer of_eval_font_underline (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_underline_expr + "~", " + string(al_row) + ")")

	if ((lower(ls_value) = "yes") or (ls_value = "1")) then
		anvo_format.of_set_underline(1)
	else
		anvo_format.of_set_underline(0)
	end if

	return 1
end if

return -1
end function

public function integer of_eval_font_weight (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_weight_expr + "~", " + string(al_row) + ")")

	if isnumber(ls_value) then
		inv_format.setfontweight(inv_format.handle,abs(integer(ls_value)))
	else
		inv_format.setfontweight(inv_format.handle,400)
	end if

	return 1
end if

return -1
end function

public function integer of_eval_font_weight (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = of_describe("evaluate(~"" + is_font_weight_expr + "~", " + string(al_row) + ")")

	if isnumber(ls_value) then
		anvo_format.of_set_bold(abs(integer(ls_value)) = 700)
	else
		anvo_format.of_set_bold(false)
	end if

	return 1
end if

return -1
end function

public function integer of_eval_numformat (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = trim(of_describe("evaluate(~"" + is_format_expr + "~", " + string(al_row) + ")"))

	if ls_value = "" then
		ls_value = "[General]"
	end if

	ls_value = of_change_format(ls_value,is_coltype)
	inv_format.setnumformat(inv_format.handle,ls_value)
	return 1
end if

return -1
end function

public function integer of_eval_numformat (n_xls_format anvo_format,long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ls_value = trim(of_describe("evaluate(~"" + is_format_expr + "~", " + string(al_row) + ")"))

	if ls_value = "" then
		ls_value = "[General]"
	end if

	ls_value = of_change_format(ls_value,is_coltype)
	anvo_format.of_set_num_format(ls_value)
	return 1
end if

return -1
end function

public function string of_evaluate_str0 (readonly string as_expr,long al_row);string ls_val

choose case ipo_requestortype
	case datawindow!
		ls_val = idw_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case datastore!
		ls_val = ids_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case datawindowchild!
		ls_val = idwc_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case else
		return ""
end choose

return ls_val
end function

public function long of_evaluate0 (readonly string as_expr,long al_row);string ls_val

choose case ipo_requestortype
	case datawindow!
		ls_val = idw_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case datastore!
		ls_val = ids_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case datawindowchild!
		ls_val = idwc_requestor.describe("evaluate(~"" + as_expr + "~", " + string(al_row) + ")")
	case else
		return -1
end choose

if isnumber(ls_val) then
	return long(ls_val)
else
	return -1
end if
end function

public function long of_get_band_y1 ();if il_cached_y1 = -1000000000 then
	return (of_get_y1(1) - il_base_y)
else
	return il_cached_y1
end if
end function

public function long of_get_band_y2 ();if il_cached_y2 = -1000000000 then
	return (of_get_y2(1) - il_base_y)
else
	return il_cached_y2
end if
end function

private function integer of_get_column_display_type ();string ls_str

choose case ii_dwo_type
	case 1
		ls_str = of_describe(is_dwo_name + ".CheckBox.On")

		if ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
			return 2
		end if

		ls_str = of_describe(is_dwo_name + ".DDDW.Name")

		if ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
			return 3
		end if

		ls_str = of_describe(is_dwo_name + ".DDLB.Required")

		if ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
			return 4
		end if

		ls_str = of_describe(is_dwo_name + ".RadioButtons.Columns")

		if ls_str <> "0" and ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
			return 1
		end if

		ls_str = of_describe(is_dwo_name + ".Edit.CodeTable")

		if lower(ls_str) = "yes" then
			return 5
		end if

		return 1
	case 2, 3
		return 1
	case 4
		return 6
	case else
		return 1
end choose
end function

public function long of_get_format (long al_row);integer li_ret = 1
long ll_format_ix
n_xls_format lnvo_temp_format

if not ib_custom_format then
	return il_format_ix
end if

al_row = al_row + ii_row_in_detail - 1

if al_row > il_dw_row_count then
	return il_format_ix
end if

if ib_bg_color_expr then
	of_eval_bg_color(al_row)
end if

if ib_color_expr then
	of_eval_color(al_row)
end if

if ib_format_expr then
	of_eval_numformat(al_row)
end if

if ib_font_face_expr then
	of_eval_font_face(al_row)
end if

if ib_font_underline_expr then
	of_eval_font_underline(al_row)
end if

if ib_font_italic_expr then
	of_eval_font_italic(al_row)
end if

if ib_font_weight_expr then
	of_eval_font_weight(al_row)
end if

if ib_alignment_expr then
	of_eval_alignment(al_row)
end if

if ib_font_height_expr then
	of_eval_font_height(al_row)
end if

ll_format_ix = inv_book.of_addformat(inv_format)
return ll_format_ix
end function

public function long of_get_height (long al_row);long ll_ret

if is_expr_height = "" then
	ll_ret = il_cached_height
else

	if is_expr_height = "-" then
		il_cached_height = of_describe_expr(is_dwo_name + ".height",al_row,is_expr_height)
		ll_ret = il_cached_height
	else
		ll_ret = of_evaluate0(is_expr_height,al_row)
	end if

end if

return ll_ret
end function

public function string of_get_item_coltype ();string ls_coltype
long ll_pos
long ll_pos_dec

ls_coltype = trim(lower(of_describe(is_dwo_name + ".coltype")))
ll_pos = pos(ls_coltype,"(")

if ll_pos > 0 then
	ll_pos_dec = pos(ls_coltype,",",ll_pos)

	if ll_pos_dec <= 0 then
		ll_pos_dec = pos(ls_coltype,")",ll_pos)
	end if

	ii_colsize = integer(mid(ls_coltype,ll_pos + 1,ll_pos_dec - ll_pos - 1))
	ls_coltype = trim(left(ls_coltype,ll_pos - 1))
end if

choose case ls_coltype
	case "char", "string"
		ls_coltype = "s"
	case "decimal", "int"  , "long", "ulong"  , "number", "real"  , "integer"
		ls_coltype = "n"
	case "date"
		ls_coltype = "d"
	case "datetime", "timestamp"
		ls_coltype = "dt"
	case "time"
		ls_coltype = "t"
	case else
		ls_coltype = "-"
end choose

return ls_coltype
end function

public function string of_get_system_currency_format ();long ll_ret
long ll_mongrouping
string ls_scurrency
string ls_smondecimalsep
string ls_smonthousandsep
string ls_smongrouping
string ls_numformat
string ls_icurrency
string ls_inegcurr
string ls_positive
string ls_negative
n_dwr_string s

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sCurrency",regstring!,ls_scurrency)

if ll_ret <> 1 then
	ls_scurrency = "$"
end if

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","iCurrency",regstring!,ls_icurrency)

if ll_ret <> 1 then
	ls_icurrency = "0"
end if

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","iNegCurr",regstring!,ls_inegcurr)

if ll_ret <> 1 then
	ls_inegcurr = "0"
end if

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sMonDecimalSep",regstring!,ls_smondecimalsep)

if ll_ret <> 1 then
	ls_smondecimalsep = "."
end if

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sMonThousandSep",regstring!,ls_smonthousandsep)

if ll_ret <> 1 then
	ls_smonthousandsep = ","
end if

ll_ret = registryget("HKEY_CURRENT_USER\Control Panel\International","sMonGrouping",regstring!,ls_smongrouping)

if ll_ret <> 1 then
	ls_smongrouping = "3;0"
end if

choose case ls_icurrency
	case "0"
		ls_positive = "$n"
	case "1"
		ls_positive = "n$"
	case "2"
		ls_positive = "$ n"
	case "3"
		ls_positive = "n $"
	case else
		ls_positive = "$n"
end choose

choose case ls_inegcurr
	case "0"
		ls_negative = "($n)"
	case "1"
		ls_negative = "-$n"
	case "2"
		ls_negative = "$-n"
	case "3"
		ls_negative = "$n-"
	case "4"
		ls_negative = "(n$)"
	case "5"
		ls_negative = "-n$"
	case "6"
		ls_negative = "n-$"
	case "7"
		ls_negative = "n$-"
	case "8"
		ls_negative = "-n $"
	case "9"
		ls_negative = "-$ n"
	case "10"
		ls_negative = "n $-"
	case "11"
		ls_negative = "$ n-"
	case "12"
		ls_negative = "$ -n"
	case "13"
		ls_negative = "n- $"
	case "14"
		ls_negative = "($ n)"
	case "15"
		ls_negative = "(n $)"
	case else
		ls_negative = "-$n"
end choose

ll_ret = pos(ls_smongrouping,";")

if ll_ret > 0 then
	ls_smongrouping = left(ls_smongrouping,ll_ret - 1)
end if

ll_mongrouping = long(ls_smongrouping)

if ll_mongrouping <> 0 then
	ls_numformat = "#" + ls_smonthousandsep + fill("#",ll_mongrouping - 1) + "0.00"
else
	ls_numformat = "#0.00"
end if

ls_numformat = s.of_globalreplace(ls_positive + ";" + ls_negative,"n",ls_numformat)
ls_numformat = s.of_globalreplace(ls_numformat,"$",ls_scurrency)
return ls_numformat
end function

public function integer of_get_visible (long al_row);integer li_ret

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	li_ret = of_describe_expr(is_dwo_name + ".visible",al_row)
end if

return li_ret
end function

public function long of_get_width (long al_row);long ll_ret

if is_expr_width = "" then
	ll_ret = il_cached_width
else

	if is_expr_width = "-" then
		il_cached_width = of_describe_expr(is_dwo_name + ".width",al_row,is_expr_width)
		ll_ret = il_cached_width
	else
		ll_ret = of_evaluate0(is_expr_width,al_row)
	end if

end if

return ll_ret
end function

public function long of_get_x1 ();if il_cached_x1 = -1 then
	return of_get_x1(1)
else
	return (il_base_x + il_cached_x1)
end if
end function

public function long of_get_x1 (long al_row);long ll_ret

if is_expr_x1 = "" then
	ll_ret = il_base_x + il_cached_x1
else

	if is_expr_x1 = "-" then
		il_cached_x1 = of_describe_expr(is_dwo_name + ".x",al_row,is_expr_x1)
		ll_ret = il_base_x + il_cached_x1
	else
		ll_ret = il_base_x + of_evaluate0(is_expr_x1,al_row)
	end if

end if

return ll_ret
end function

public function long of_get_x2 ();if il_cached_x2 = -1 then
	return of_get_x2(1)
else
	return (il_base_x + il_cached_x2)
end if
end function

public function long of_get_x2 (readonly long al_row);long ll_ret

if is_expr_x2 = "" then
	ll_ret = il_base_x + il_cached_x2
else

	if is_expr_x2 = "-" then
		ll_ret = of_get_x1(al_row) + of_get_width(al_row)
		il_cached_x2 = ll_ret - il_base_x

		if ((is_expr_x1 <> "") or (is_expr_width <> "")) then
			is_expr_x2 = is_expr_x1 + " + " + is_expr_width
		else
			is_expr_x2 = ""
		end if

	else
		ll_ret = of_get_x1(al_row) + of_get_width(al_row)
	end if

end if

return ll_ret
end function

public function long of_get_y1 ();if il_cached_y1 = -1000000000 then
	return of_get_y1(1)
else
	return (il_base_y + il_cached_y1)
end if
end function

public function long of_get_y1 (long al_row);long ll_ret

al_row = al_row + ii_row_in_detail - 1

if al_row > il_dw_row_count then
	return 0
end if

if is_expr_y1 = "" then
	ll_ret = il_base_y + il_cached_y1
else

	if is_expr_y1 = "-" then
		il_cached_y1 = of_describe_expr(is_dwo_name + ".y",al_row,is_expr_y1) - il_subband_y
		ll_ret = il_base_y + il_cached_y1
	else
		ll_ret = il_base_y + of_evaluate0(is_expr_y1,al_row) - il_subband_y
	end if

end if

return ll_ret
end function

public function long of_get_y2 ();if il_cached_y2 = -1000000000 then
	return of_get_y2(1)
else
	return (il_base_y + il_cached_y2)
end if
end function

public function long of_get_y2 (long al_row);long ll_ret

al_row = al_row + ii_row_in_detail - 1

if al_row > il_dw_row_count then
	return 0
end if

if is_expr_y2 = "" then
	ll_ret = il_base_y + il_cached_y2
else

	if is_expr_y2 = "-" then
		ll_ret = of_get_y1(al_row) + of_get_height(al_row)
		il_cached_y2 = ll_ret - il_base_y

		if ((is_expr_y1 <> "") or (is_expr_height <> "")) then
			is_expr_y2 = "*"
		else
			is_expr_y2 = ""
		end if

	else
		ll_ret = of_get_y1(al_row) + of_get_height(al_row)
	end if

end if

return ll_ret
end function

private function integer of_getdddwcolumnids (datawindowchild adw,ref string as_id[]);string ls_empty[]
string ls_objects
string ls_object[]
string ls_str
string ls_id
n_dwr_string s
long ll_objectcount
long ll_i

as_id = ls_empty
ls_objects = adw.describe("DataWindow.Objects")
ll_objectcount = s.of_parsetoarray(ls_objects,"~t",ls_object)

for ll_i = 1 to ll_objectcount
	ls_id = adw.describe(ls_object[ll_i] + ".id")

	if long(ls_id) > 0 then
		ls_str = adw.describe(ls_object[ll_i] + ".DDDW.Name")

		if ls_str <> "!" and ls_str <> "?" and ls_str <> "" then
			as_id[upperbound(as_id) + 1] = ls_id
		end if

	end if

next

return 1
end function

public function any of_getvalue (long al_row);choose case ipo_requestortype
	case datawindow!
		return of_getvalue_dw(al_row)
	case datastore!
		return of_getvalue_ds(al_row)
	case datawindowchild!
		return of_getvalue_dwc(al_row)
end choose
end function

public function any of_getvalue_ds (long al_row);datastore lpo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val
integer li_id

lpo_requestor = ipo_requestor
setnull(la_val)
al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then

	choose case ii_dwo_type
		case 1, 2

			if ii_column_display_type = 1 then

				choose case is_coltype
					case "s"
						li_id = integer(lpo_requestor.describe(is_dwo_name + ".id"))

						if li_id > 0 then
							la_val = lpo_requestor.getitemstring(al_row,li_id)
						else
							la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						end if

					case "n"
						la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
					case "d"
						la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
					case "dt"
						la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
					case "t"
						la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
				end choose

			else

				if ii_column_display_type = 2 then

					choose case is_coltype
						case "s"
							la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
						case "n"
							la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
						case "d"
							la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
						case "dt"
							la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
						case "t"
							la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
					end choose

					if isnull(la_val) then
						la_val = ""
					end if

				else

					if ii_column_display_type = 3 then

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if ib_disable_lookup_display then

							if isnull(la_val) then
								la_val = ""
							end if

						else

							if not isnull(la_val) then
								la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
							else
								la_val = ""
							end if

						end if

					else

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if not isnull(la_val) then
							la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
						else
							la_val = ""
						end if

					end if

				end if

			end if

					case 3

			if is_text_expr <> "" then
				la_val = of_describe_str_expr(is_dwo_name + ".Text",al_row)
			else
				la_val = is_text
			end if

					case 4
			la_val = "{" + is_dwo_name + "}"
	end choose

end if

return la_val
end function

public function any of_getvalue_dw (long al_row);datawindow lpo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val
integer li_id

lpo_requestor = ipo_requestor
setnull(la_val)
al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then

	choose case ii_dwo_type
		case 1, 2

			if ii_column_display_type = 1 then

				choose case is_coltype
					case "s"
						li_id = integer(lpo_requestor.describe(is_dwo_name + ".id"))

						if li_id > 0 then
							la_val = lpo_requestor.getitemstring(al_row,li_id)
						else
							la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						end if

					case "n"
						la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
					case "d"
						la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
					case "dt"
						la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
					case "t"
						la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
				end choose

			else

				if ii_column_display_type = 2 then

					choose case is_coltype
						case "s"
							la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
						case "n"
							la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
						case "d"
							la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
						case "dt"
							la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
						case "t"
							la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
					end choose

					if isnull(la_val) then
						la_val = ""
					end if

				else

					if ii_column_display_type = 3 then

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if ib_disable_lookup_display then

							if isnull(la_val) then
								la_val = ""
							end if

						else

							if not isnull(la_val) then
								la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
							else
								la_val = ""
							end if

						end if

					else

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if not isnull(la_val) then
							la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
						else
							la_val = ""
						end if

					end if

				end if

			end if

					case 3

			if is_text_expr <> "" then
				la_val = of_describe_str_expr(is_dwo_name + ".Text",al_row)
			else
				la_val = is_text
			end if

					case 4
			la_val = "{" + is_dwo_name + "}"
	end choose

end if

return la_val
end function

public function any of_getvalue_dwc (long al_row);datawindowchild lpo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val
integer li_id

lpo_requestor = ipo_requestor
setnull(la_val)
al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then

	choose case ii_dwo_type
		case 1, 2

			if ii_column_display_type = 1 then

				choose case is_coltype
					case "s"
						li_id = integer(lpo_requestor.describe(is_dwo_name + ".id"))

						if li_id > 0 then
							la_val = lpo_requestor.getitemstring(al_row,li_id)
						else
							la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						end if

					case "n"
						la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
					case "d"
						la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
					case "dt"
						la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
					case "t"
						la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
				end choose

			else

				if ii_column_display_type = 2 then

					choose case is_coltype
						case "s"
							la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
						case "n"
							la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
						case "d"
							la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
						case "dt"
							la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
						case "t"
							la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
					end choose

					if isnull(la_val) then
						la_val = ""
					end if

				else

					if ii_column_display_type = 3 then

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if ib_disable_lookup_display then

							if isnull(la_val) then
								la_val = ""
							end if

						else

							if not isnull(la_val) then
								la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
							else
								la_val = ""
							end if

						end if

					else

						choose case is_coltype
							case "s"
								la_val = lpo_requestor.getitemstring(al_row,is_dwo_name)
							case "n"
								la_val = lpo_requestor.getitemdecimal(al_row,is_dwo_name)
							case "d"
								la_val = lpo_requestor.getitemdate(al_row,is_dwo_name)
							case "dt"
								la_val = lpo_requestor.getitemdatetime(al_row,is_dwo_name)
							case "t"
								la_val = lpo_requestor.getitemtime(al_row,is_dwo_name)
						end choose

						if not isnull(la_val) then
							la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
						else
							la_val = ""
						end if

					end if

				end if

			end if

					case 3

			if is_text_expr <> "" then
				la_val = of_describe_str_expr(is_dwo_name + ".Text",al_row)
			else
				la_val = is_text
			end if

					case 4
			la_val = "{" + is_dwo_name + "}"
	end choose

end if

return la_val
end function

public function integer of_init (string as_dwo_name,integer ai_dwo_type);integer li_ret = 1

is_dwo_name = as_dwo_name
ii_dwo_type = ai_dwo_type

choose case ii_dwo_type
	case 1
		is_coltype = of_get_item_coltype()
		il_id = long(of_describe(as_dwo_name + ".id"))

		if il_id > 0 and of_describe("#" + string(il_id) + ".name") <> as_dwo_name then
			ib_disable_lookup_display = true
		end if

	case 2
		is_coltype = of_get_item_coltype()
	case 3
		is_coltype = "s"
		is_text = of_describe(as_dwo_name + ".text")
		is_text = of_unquote(is_text)

		if pos(is_text,"~t") > 0 then
			is_text_expr = is_text
		end if

	case 4
		is_coltype = "r"
		is_nested_dataobject = of_describe(is_dwo_name + ".DataObject")
end choose

if li_ret = 1 then

	choose case ipo_requestortype
		case datawindow!
			il_dw_row_count = idw_requestor.rowcount()
		case datastore!
			il_dw_row_count = ids_requestor.rowcount()
		case datawindowchild!
			il_dw_row_count = idwc_requestor.rowcount()
		case else
			return -1
	end choose

	ib_autosize_height = of_describe(as_dwo_name + ".height.autosize") = "yes"
	ii_column_display_type = of_get_column_display_type()
	li_ret = of_setformat()
end if

return li_ret
end function

public function long of_process_nested (long al_row,long al_writer_row,n_dwr_grid anvo_hgrid,n_dwr_progress apo_progress);long ll_rown
long li_ret = 1

if ib_usetrc then
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
end if

if il_child_cache_row <> al_row then
	il_child_cache_row = -1

	if al_row > 1 then
		ids_reportdata.rowsmove(al_row,al_row,primary!,ids_reportdata,1,primary!)
	end if

	li_ret = ids_reportdata.getchild(is_dwo_name,idwc_child_cache)

	if li_ret <> 1 then
		return 0
	end if

	il_child_cache_row = al_row
end if

inv_nested_service_parm.il_writer_row = al_writer_row
inv_nested_service_parm.il_parent_row = al_row
inv_nested_service_parm.ipo_dynamic_requestor = idwc_child_cache
inv_nested_service_parm.invo_dynamic_hgrid = anvo_hgrid
inv_nested_service_parm.ipo_progress = apo_progress
li_ret = inv_nestedservice.of_process_work()

if li_ret = 1 then
	ll_rown = inv_nested_service_parm.il_writer_row - al_writer_row
end if

return ll_rown
end function

public function integer of_register (powerobject apo_requestor,n_dwr_workbook anv_book,n_dwr_colors anvo_colors,long al_base_x,long al_base_y,long al_subband_y);il_base_x = al_base_x
il_base_y = al_base_y
il_subband_y = al_subband_y
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

inv_book = anv_book
invo_colors = anvo_colors
return 1
end function

public function integer of_register_dynamic (powerobject apo_requestor);ipo_requestor = apo_requestor
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

return 1
end function

public function integer of_set_bg_color (n_xls_format a_format,long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_color = long(of_describe("evaluate(~"" + is_bg_color_expr + "~", " + string(al_row) + ")"))

	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color)

		if li_color_index > 0 then
			a_format.of_set_bg_color(li_color_index)
		end if

	end if

end if

return 1
end function

public function integer of_set_color (n_xls_format a_format,long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1

if al_row <= il_dw_row_count then
	ll_color = long(of_describe("evaluate(~"" + is_color_expr + "~", " + string(al_row) + ")"))

	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color)

		if li_color_index > 0 then
			a_format.of_set_color(li_color_index)
		end if

	end if

end if

return 1
end function

public function integer of_setformat ();integer li_ret = 1
string ls_format
integer li_color_index
long ll_color
string ls_border_style

inv_format = inv_book.of_createformat()

if li_ret = 1 then
	ls_format = of_descr_numformat()

	if ls_format = "" then
		ls_format = "[General]"
	end if

	ls_format = of_change_format(ls_format,is_coltype)
	inv_format.setnumformat(inv_format.handle,ls_format)
	inv_format.setfontname(inv_format.handle,of_descr_font_face())
	inv_format.setfontsize(inv_format.handle,of_descr_font_height())

	if of_descr_font_italic() then
		inv_format.setfontitalic(inv_format.handle,1)
	end if

	inv_format.setfontunderline(inv_format.handle,of_descr_font_underline())
	inv_format.setfontweight(inv_format.handle,of_descr_font_weight2())
	inv_format.sethalign(inv_format.handle,of_descr_alignment2())
	inv_format.setvalign(inv_format.handle,0)

	if is_coltype = "s" then
		inv_format.setwrap(inv_format.handle,1)
	end if

	ll_color = of_descr_color2()
	inv_format.setfgcolor(inv_format.handle,ll_color)
	ll_color = of_descr_bg_color2()
	inv_format.setbgcolor(inv_format.handle,ll_color)
	inv_format.setfontcharset(inv_format.handle,of_descr_font_charset())
	inv_format.setfontfamily(inv_format.handle,of_descr_font_family())
end if

if li_ret = 1 then
	ls_border_style = of_describe(is_dwo_name + ".Border")

	if isnumber(ls_border_style) and integer(ls_border_style) > 0 then
		inv_format.setborderstyle(inv_format.handle,1)
	else

		if integer(of_describe("Datawindow.Processing")) = 1 then
			inv_format.setborderstyle(inv_format.handle,7)
		end if

	end if

	ib_custom_format = ((((((((ib_color_expr) or (ib_bg_color_expr)) or (ib_alignment_expr)) or (ib_font_face_expr)) or (ib_font_height_expr)) or (ib_font_italic_expr)) or (ib_font_underline_expr)) or (ib_font_weight_expr)) or (ib_format_expr)

	if not ib_custom_format then
		il_format_ix = inv_book.of_addformat(inv_format)
	end if

end if

return li_ret
end function

public subroutine of_setsubbandy (long ai_subband_y);il_subband_y = ai_subband_y
il_cached_y1 = -1000000000
is_expr_y1 = "-"
il_cached_x1 = -1
is_expr_x1 = "-"
end subroutine

private function string of_unquote (string as_str);long ll_pos

if left(as_str,1) = "~"" and right(as_str,1) = "~"" then

	if ((pos(as_str,"~r") > 0) or (pos(as_str,"~n") > 0)) then
		as_str = mid(as_str,2,len(as_str) - 2)
	end if

end if

ll_pos = pos(as_str,"~~~"")

do while ll_pos > 0
	as_str = replace(as_str,ll_pos,2,"~"")
	ll_pos = pos(as_str,"~~~"")
loop

return as_str
end function

on n_dwr_field.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_field.destroy
triggerevent("destructor")
call super::destroy
end on

