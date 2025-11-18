$PBExportHeader$n_xls_workbook_v5.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_workbook_v5 from n_xls_workbook
end type
end forward

global type n_xls_workbook_v5 from n_xls_workbook
end type
global n_xls_workbook_v5 n_xls_workbook_v5

type variables
private olestorage istg_doc
private olestorage invo_olestorage
private boolean ib_fileclosed = true
public string is_sheetnames[]
private string is_sheetname = "Ëèñò"
public integer ii_selected
private integer ii_palette[4,56]
private uint iui_codepage = 1252
protected blob iblb_data
protected ulong il_datasize
protected ulong il_biffsize
protected uint iui_limit = 2080
protected boolean ib_1904 = false
public n_xls_format_v5 invo_tmp_format
public n_xls_format_v5 invo_url_format
public n_xls_data invo_data
end variables

forward prototypes
protected function blob of_add_continue (blob ablb_data)
public function n_xls_format of_add_format ()
public function n_xls_worksheet of_add_worksheet ()
public function n_xls_worksheet of_add_worksheet (string as_worksheetname)
protected function integer of_append (blob ablb_data)
protected function integer of_append (blob ablb_header,blob ablb_data)
protected function integer of_append (blob ablb_header,blob ablb_data,blob ablb_add_data)
protected function integer of_calc_sheet_offsets ()
public function integer of_close ()
public function integer of_create (string as_filename)
protected function boolean of_is_number (string as_str)
protected function boolean of_is_zero_started_number (string as_str)
public function integer of_set_codepage (uint aui_codepage)
public function integer of_set_custom_color (integer ai_index,integer ai_red,integer ai_green,integer ai_blue)
public function integer of_set_palette_xl97 ()
protected function integer of_store_1904 ()
protected function integer of_store_all_fonts ()
protected function integer of_store_all_num_formats ()
protected function integer of_store_all_styles ()
protected function integer of_store_all_xfs ()
protected function integer of_store_bof (integer ai_type)
protected function integer of_store_boundsheet (string as_sheetname,ulong al_offset)
protected function integer of_store_codepage ()
protected function integer of_store_eof ()
protected function integer of_store_externcount (uint ai_cxals)
protected function integer of_store_externs ()
protected function integer of_store_externsheet (string as_sheetname)
protected function integer of_store_name_long (uint ai_index,uint ai_type,uint ai_rowmin,uint ai_rowmax,uint ai_colmin,uint ai_colmax)
protected function integer of_store_name_short (uint ai_index,integer ai_type,uint ai_rowmin,uint ai_rowmax,integer ai_colmin,integer ai_colmax)
protected function integer of_store_names ()
protected function integer of_store_num_format (string as_format,uint ai_index)
protected function integer of_store_ole_file ()
protected function integer of_store_palette ()
protected function integer of_store_style ()
protected function integer of_store_window1 ()
protected function integer of_store_workbook ()
end prototypes

protected function blob of_add_continue (blob ablb_data);uint lui_record = 60
blob lblb_header
blob lblb_temp
long ll_len

lblb_temp = blobmid(ablb_data,1,iui_limit)
ablb_data = blobmid(ablb_data,iui_limit + 1,len(ablb_data) - iui_limit)
blobedit(lblb_temp,3,invo_sub.of_pack("v",iui_limit - 4))

do while len(ablb_data) > iui_limit
	lblb_header = invo_sub.of_pack("v",lui_record) + invo_sub.of_pack("v",iui_limit)
	lblb_temp = lblb_temp + lblb_header
	lblb_temp = lblb_temp + blobmid(ablb_data,1,iui_limit)
	ablb_data = blobmid(ablb_data,iui_limit + 1,len(ablb_data) - iui_limit)
loop

lblb_header = invo_sub.of_pack("v",lui_record) + invo_sub.of_pack("v",len(ablb_data))
lblb_temp = lblb_temp + lblb_header
lblb_temp = lblb_temp + ablb_data
return lblb_temp
end function

public function n_xls_format of_add_format ();n_xls_format_v5 lnvo_format

lnvo_format = create n_xls_format_v5
return lnvo_format
end function

public function n_xls_worksheet of_add_worksheet ();return of_add_worksheet("")
end function

public function n_xls_worksheet of_add_worksheet (string as_worksheetname);integer li_ret = 1
integer li_i
n_xls_worksheet_v5 lnvo_worksheet

do

	if len(as_worksheetname) > 31 then
		messagebox("Error","Length of Worksheet name must be less then 31 symbols",stopsign!)
		li_ret = -1
		exit
	end if

	if match(as_worksheetname,"[:*?/\]") then
		messagebox("Error","Invalid worksheet name",stopsign!)
		li_ret = -1
		exit
	end if

	if trim(as_worksheetname) = "" then
		as_worksheetname = is_sheetname + string(il_worksheetindex + 1)
	end if

	for li_i = 1 to il_worksheetindex

		if invo_worksheets[li_i].is_worksheetname = as_worksheetname then
			messagebox("Error","Duplicate worksheet name",stopsign!)
			li_ret = -1
			exit
		end if

	next

	if li_ret <> 1 then
		exit
	end if

	lnvo_worksheet = create n_xls_worksheet_v5
	lnvo_worksheet.invo_url_format = invo_url_format
	lnvo_worksheet.invo_workbook = this
	lnvo_worksheet.is_worksheetname = as_worksheetname
	il_worksheetindex ++
	lnvo_worksheet.ii_index = il_worksheetindex
	is_sheetnames[il_worksheetindex] = lnvo_worksheet.is_worksheetname
	invo_worksheets[il_worksheetindex] = lnvo_worksheet
loop until true

if li_ret <> 1 then

	if not isnull(lnvo_worksheet) then

		if isvalid(lnvo_worksheet) then
			destroy(lnvo_worksheet)
			setnull(lnvo_worksheet)
		end if

	end if

end if

return lnvo_worksheet
end function

protected function integer of_append (blob ablb_data);integer li_ret = 1

if len(ablb_data) > iui_limit then
	ablb_data = of_add_continue(ablb_data)
end if

il_datasize += len(ablb_data)
invo_data.of_append(ablb_data)
return li_ret
end function

protected function integer of_append (blob ablb_header,blob ablb_data);return of_append(ablb_header + ablb_data)
end function

protected function integer of_append (blob ablb_header,blob ablb_data,blob ablb_add_data);return of_append(ablb_header + ablb_data + ablb_add_data)
end function

protected function integer of_calc_sheet_offsets ();integer li_ret = 1
integer li_bof = 11
integer li_eof = 4
ulong ll_offset
long ll_i
n_xls_worksheet_v5 lnvo_sheet

ll_offset = il_datasize

for ll_i = 1 to il_worksheetindex
	ll_offset += (li_bof + len(invo_worksheets[ll_i].is_worksheetname))
next

ll_offset += li_eof

for ll_i = 1 to il_worksheetindex
	lnvo_sheet = invo_worksheets[ll_i]
	lnvo_sheet.il_offset = ll_offset
	ll_offset += lnvo_sheet.il_datasize
next

il_biffsize = ll_offset
return li_ret
end function

public function integer of_close ();integer li_ret = 1

if not ib_fileclosed then
	li_ret = of_store_workbook()
end if

return li_ret
end function

public function integer of_create (string as_filename);integer li_ret = 1

invo_tmp_format = create n_xls_format_v5
of_reg_format(invo_tmp_format)

if handle(getapplication()) <> 0 then
	open(w_dm_pb2xls)
end if

invo_url_format = of_add_format()
invo_url_format.of_set_color("blue")
invo_url_format.of_set_underline(1)
of_reg_format(invo_url_format)

if ((as_filename = "") or (isnull(as_filename))) then
	messagebox("Error","File name must be specified",stopsign!)
	li_ret = -1
end if

if li_ret = 1 then

	if not ib_fileclosed then
		messagebox("Error","Current workbook is not closed",stopsign!)
		li_ret = -1
	end if

end if

if li_ret = 1 then
	istg_doc = create olestorage
	li_ret = istg_doc.open(as_filename,stgreadwrite!,stgexclusive!)

	if li_ret < 0 then
		messagebox("Error","File sharing violation~r~n" + "Cannot open the file",stopsign!)
		destroy(istg_doc)
		li_ret = -1
	else
		ib_fileclosed = false
		li_ret = 1
	end if

end if

if li_ret = 1 then
	li_ret = of_set_palette_xl97()
end if

return li_ret
end function

protected function boolean of_is_number (string as_str);integer li_i
integer li_cnt
string ls_ch

as_str = trim(as_str)
li_cnt = len(as_str)

if li_cnt < 1 then
	return false
end if

for li_i = 1 to li_cnt
	ls_ch = mid(as_str,li_i,1)

	choose case ls_ch
		case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
			continue
		case else
			return false
	end choose

next

return true
end function

protected function boolean of_is_zero_started_number (string as_str);integer li_i
integer li_cnt
string ls_ch

as_str = trim(as_str)

if right(as_str,1) = "0" then
	li_cnt = len(as_str)

	if li_cnt < 2 then
		return false
	end if

	for li_i = 2 to li_cnt
		ls_ch = mid(as_str,li_i,1)

		choose case ls_ch
			case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
				continue
			case else
				return false
		end choose

	next

	return true
else
	return false
end if
end function

public function integer of_set_codepage (uint aui_codepage);iui_codepage = aui_codepage
return 1
end function

public function integer of_set_custom_color (integer ai_index,integer ai_red,integer ai_green,integer ai_blue);if ((ai_index < 8) or (ai_index > 64)) then
	messagebox("Error","Color index " + string(ai_index) + " outside range: 8 <= index <= 64")
	return -1
else

	if ((((((ai_red < 0) or (ai_red > 255)) or (ai_green < 0)) or (ai_green > 255)) or (ai_blue < 0)) or (ai_blue > 255)) then
		messagebox("Error","Color component outside range: 0 <= color <= 255")
		return -1
	else
		ai_index = ai_index - 7
		ii_palette[1,ai_index] = ai_red
		ii_palette[2,ai_index] = ai_green
		ii_palette[3,ai_index] = ai_blue
		ii_palette[4,ai_index] = 0
		return (ai_index + 7)
	end if

end if
end function

public function integer of_set_palette_xl97 ();ii_palette[] = {0,0,0,0,255,255,255,0,255,0,0,0,0,255,0,0,0,0,255,0,255,255,0,0,255,0,255,0,0,255,255,0,128,0,0,0,0,128,0,0,0,0,128,0,128,128,0,0,128,0,128,0,0,128,128,0,192,192,192,0,128,128,128,0,153,153,255,0,153,51,102,0,255,255,204,0,204,255,255,0,102,0,102,0,255,128,128,0,0,102,204,0,204,204,255,0,0,0,128,0,255,0,255,0,255,255,0,0,0,255,255,0,128,0,128,0,128,0,0,0,0,128,128,0,0,0,255,0,0,204,255,0,204,255,255,0,204,255,204,0,255,255,153,0,153,204,255,0,255,153,204,0,204,153,255,0,255,204,153,0,51,102,255,0,51,204,204,0,153,204,0,0,255,204,0,0,255,153,0,0,255,102,0,0,102,102,153,0,150,150,150,0,0,51,102,0,51,153,102,0,0,51,0,0,51,51,0,0,153,51,0,0,153,51,102,0,51,51,153,0,51,51,51,0}
return 1
end function

protected function integer of_store_1904 ();uint li_record = 34
uint li_length = 2
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)

if ib_1904 then
	lblb_data = invo_sub.of_pack("v",1)
else
	lblb_data = invo_sub.of_pack("v",0)
end if

li_ret = of_append(lblb_header,lblb_data)
return li_ret
end function

protected function integer of_store_all_fonts ();blob lb_font
string ls_key
string ls_font_keys[]
long ll_keys_cnt
long ll_format_cnt
long ll_i
long ll_j
long ll_key
integer li_ret = 1
n_xls_format_v5 lnvo_format

lb_font = invo_tmp_format.of_get_font()

for ll_i = 1 to 5
	of_append(lb_font)
next

ls_key = invo_tmp_format.of_get_font_key()
ll_keys_cnt ++
ls_font_keys[ll_keys_cnt] = ls_key
ll_format_cnt = upperbound(invo_formats)

for ll_i = 1 to ll_format_cnt
	lnvo_format = invo_formats[ll_i]
	ls_key = lnvo_format.of_get_font_key()
	ll_key = 0

	for ll_j = 1 to ll_keys_cnt

		if ls_font_keys[ll_j] = ls_key then
			ll_key = ll_j
			exit
		end if

	next

	if ll_key = 0 then
		ll_keys_cnt ++
		ls_font_keys[ll_keys_cnt] = ls_key
		ll_key = ll_keys_cnt
		lb_font = lnvo_format.of_get_font()
		of_append(lb_font)
	end if

	if ll_key > 1 then
		ll_key += 4
	else
		ll_key = 0
	end if

	lnvo_format.ii_font_index = ll_key
next

return li_ret
end function

protected function integer of_store_all_num_formats ();integer li_ret = 1
string ls_formats[]
long ll_formats_cnt
long ll_i
long ll_j
long ll_used_format
string ls_format
integer li_format
n_xls_format_v5 invo_format

for ll_i = 1 to il_formatindex
	invo_format = invo_formats[ll_i]
	ls_format = invo_format.is_num_format
	li_format = invo_format.ii_num_format

	if ((ls_format = "") or (isnull(ls_format))) then
	else
		ll_used_format = 0

		for ll_j = 1 to ll_formats_cnt

			if ls_formats[ll_j] = ls_format then
				ll_used_format = ll_j
				exit
			end if

		next

		if ll_used_format > 0 then
			invo_format.ii_num_format = ll_used_format + 164 - 1
		else
			ll_formats_cnt ++
			ls_formats[ll_formats_cnt] = ls_format
			invo_format.ii_num_format = ll_formats_cnt + 164 - 1
		end if

	end if

next

for ll_i = 1 to ll_formats_cnt
	of_store_num_format(ls_formats[ll_i],ll_i + 164 - 1)
next

return li_ret
end function

protected function integer of_store_all_styles ();integer li_ret

li_ret = of_store_style()
return li_ret
end function

protected function integer of_store_all_xfs ();integer li_ret = 1
blob lb_xf
long ll_i
n_xls_format_v5 lnvo_format

lb_xf = invo_tmp_format.of_get_xf("style")

for ll_i = 1 to 15
	of_append(lb_xf)
next

for ll_i = 1 to il_formatindex
	lnvo_format = invo_formats[ll_i]
	lb_xf = lnvo_format.of_get_xf("cell")
	of_append(lb_xf)
next

return li_ret
end function

protected function integer of_store_bof (integer ai_type);uint li_record = 2057
uint li_len = 8
uint li_build = 2412
uint li_year = 1993
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_len)
lblb_data = invo_sub.of_pack("v",ii_biff_version) + invo_sub.of_pack("v",ai_type) + invo_sub.of_pack("v",li_build) + invo_sub.of_pack("v",li_year)
of_append(lblb_header + lblb_data)
return 1
end function

protected function integer of_store_boundsheet (string as_sheetname,ulong al_offset);integer li_ret = 1
uint li_record = 133
uint li_length
uint li_grbit
uint li_cch
blob lb_header
blob lb_data

li_cch = len(as_sheetname)
li_length = 7 + li_cch
lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("V",al_offset) + invo_sub.of_pack("v",li_grbit) + invo_sub.of_pack("C",li_cch) + blob(as_sheetname)
of_append(lb_header,lb_data)
return li_ret
end function

protected function integer of_store_codepage ();uint li_record = 66
uint li_length = 2
blob lblb_header
blob lblb_data
integer li_ret

lblb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lblb_data = invo_sub.of_pack("v",iui_codepage)
li_ret = of_append(lblb_header,lblb_data)
return li_ret
end function

protected function integer of_store_eof ();integer li_ret = 1
uint li_record = 10
uint li_length
blob lb_header

lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
of_append(lb_header)
return li_ret
end function

protected function integer of_store_externcount (uint ai_cxals);integer li_ret = 1
uint li_record = 22
uint li_length = 2
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("v",ai_cxals)
of_append(lb_header,lb_data)
return li_ret
end function

protected function integer of_store_externs ();uint li_i
uint li_cnt

li_cnt = upperbound(is_sheetnames)
of_store_externcount(li_cnt)

for li_i = 1 to li_cnt
	of_store_externsheet(is_sheetnames[li_i])
next

return 1
end function

protected function integer of_store_externsheet (string as_sheetname);integer li_ret = 1
uint li_record = 23
uint li_length
blob lb_header
blob lb_data
uint li_cch
uint li_rgch = 3

li_length = 2 + len(as_sheetname)
li_cch = len(as_sheetname)
lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("C",li_cch) + invo_sub.of_pack("C",li_rgch)
lb_data = lb_data + blob(as_sheetname)
of_append(lb_header + lb_data)
return li_ret
end function

protected function integer of_store_name_long (uint ai_index,uint ai_type,uint ai_rowmin,uint ai_rowmax,uint ai_colmin,uint ai_colmax);integer li_ret = 1
uint li_record = 24
uint li_length = 61
blob lb_header
blob lb_data
uint li_grbit = 32
integer li_chkey
integer li_cch = 1
uint li_cce = 46
uint li_ixals
uint li_itab
integer li_cchcustmenu
integer li_cchdescription
integer li_cchhelptopic
integer li_cchstatustext
integer li_unknown01 = 41
uint li_unknown02 = 43
integer li_unknown03 = 59
uint li_unknown04
uint li_unknown05
uint li_unknown06
uint li_unknown07 = 4231
uint li_unknown08 = 32776

li_ixals = ai_index + 1
li_itab = li_ixals
li_unknown04 = 65535 - ai_index
lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("v",li_grbit) + invo_sub.of_pack("C",li_chkey) + invo_sub.of_pack("C",li_cch) + invo_sub.of_pack("v",li_cce) + invo_sub.of_pack("v",li_ixals) + invo_sub.of_pack("v",li_itab) + invo_sub.of_pack("C",li_cchcustmenu) + invo_sub.of_pack("C",li_cchdescription) + invo_sub.of_pack("C",li_cchhelptopic) + invo_sub.of_pack("C",li_cchstatustext) + invo_sub.of_pack("C",ai_type) + invo_sub.of_pack("C",li_unknown01) + invo_sub.of_pack("v",li_unknown02)
lb_data = lb_data + invo_sub.of_pack("C",li_unknown03) + invo_sub.of_pack("v",li_unknown04) + invo_sub.of_pack("v",li_unknown05) + invo_sub.of_pack("v",li_unknown06) + invo_sub.of_pack("v",li_unknown07) + invo_sub.of_pack("v",li_unknown08) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",0) + invo_sub.of_pack("v",16383) + invo_sub.of_pack("C",ai_colmin) + invo_sub.of_pack("C",ai_colmax)
lb_data = lb_data + invo_sub.of_pack("C",li_unknown03) + invo_sub.of_pack("v",li_unknown04) + invo_sub.of_pack("v",li_unknown05) + invo_sub.of_pack("v",li_unknown06) + invo_sub.of_pack("v",li_unknown07) + invo_sub.of_pack("v",li_unknown08) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",ai_rowmin) + invo_sub.of_pack("v",ai_rowmax) + invo_sub.of_pack("C",0) + invo_sub.of_pack("C",255)
lb_data = lb_data + invo_sub.of_pack("C",16)
of_append(lb_header + lb_data)
return li_ret
end function

protected function integer of_store_name_short (uint ai_index,integer ai_type,uint ai_rowmin,uint ai_rowmax,integer ai_colmin,integer ai_colmax);integer li_ret = 1
uint li_record = 24
uint li_length = 36
uint li_grbit = 32
integer li_chkey
integer li_cch = 1
uint li_cce = 21
uint li_ixals
uint li_itab
integer li_cchcustmenu
integer li_cchdescription
integer li_cchhelptopic
integer li_cchstatustext
integer li_rgch
integer li_unknown03 = 59
uint li_unknown04
uint li_unknown05
uint li_unknown06
uint li_unknown07 = 4231
uint li_unknown08 = 32773
blob lb_header
blob lb_data

li_ixals = ai_index + 1
li_itab = li_ixals
li_rgch = ai_type
li_unknown04 = 65535 - ai_index
lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("v",li_grbit) + invo_sub.of_pack("C",li_chkey) + invo_sub.of_pack("C",li_cch) + invo_sub.of_pack("v",li_cce) + invo_sub.of_pack("v",li_ixals) + invo_sub.of_pack("v",li_itab) + invo_sub.of_pack("C",li_cchcustmenu) + invo_sub.of_pack("C",li_cchdescription) + invo_sub.of_pack("C",li_cchhelptopic) + invo_sub.of_pack("C",li_cchstatustext) + invo_sub.of_pack("C",li_rgch) + invo_sub.of_pack("C",li_unknown03) + invo_sub.of_pack("v",li_unknown04) + invo_sub.of_pack("v",li_unknown05) + invo_sub.of_pack("v",li_unknown06) + invo_sub.of_pack("v",li_unknown07) + invo_sub.of_pack("v",li_unknown08) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("v",ai_rowmin) + invo_sub.of_pack("v",ai_rowmax) + invo_sub.of_pack("C",ai_colmin) + invo_sub.of_pack("C",ai_colmax)
of_append(lb_header,lb_data)
return li_ret
end function

protected function integer of_store_names ();integer li_ret = 1
long ll_i
n_xls_worksheet_v5 lnvo_sheet

for ll_i = 1 to il_worksheetindex
	lnvo_sheet = invo_worksheets[ll_i]

	if not isnull(lnvo_sheet.ii_print_rowmin) then
		of_store_name_short(ll_i - 1,6,lnvo_sheet.ii_print_rowmin,lnvo_sheet.ii_print_rowmax,lnvo_sheet.ii_print_colmin,lnvo_sheet.ii_print_colmax)
	end if

next

for ll_i = 1 to il_worksheetindex
	lnvo_sheet = invo_worksheets[ll_i]

	if (( not isnull(lnvo_sheet.ii_title_rowmin)) and ( not isnull(lnvo_sheet.ii_title_colmin))) then
		of_store_name_long(ll_i - 1,7,lnvo_sheet.ii_title_rowmin,lnvo_sheet.ii_title_rowmax,lnvo_sheet.ii_title_colmin,lnvo_sheet.ii_title_colmax)
	else

		if not isnull(lnvo_sheet.ii_title_rowmin) then
			of_store_name_short(ll_i - 1,7,lnvo_sheet.ii_title_rowmin,lnvo_sheet.ii_title_rowmax,0,255)
		else

			if not isnull(lnvo_sheet.ii_title_colmin) then
				of_store_name_short(ll_i - 1,7,0,16383,lnvo_sheet.ii_title_colmin,lnvo_sheet.ii_title_colmax)
				continue
			end if

		end if

	end if

next

return li_ret
end function

protected function integer of_store_num_format (string as_format,uint ai_index);integer li_ret = 1
uint li_record = 1054
uint li_length
integer li_len_format
blob lb_header
blob lb_data

li_len_format = len(as_format)
li_length = 3 + li_len_format
lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("v",ai_index) + invo_sub.of_pack("C",li_len_format)
of_append(lb_header,lb_data,blob(as_format))
return li_ret
end function

protected function integer of_store_ole_file ();integer li_ret = 1
integer li_i
olestream lstr_book
n_xls_worksheet_v5 lnvo_sheet

lstr_book = create olestream
li_ret = lstr_book.open(istg_doc,"Book",stgwrite!)

if li_ret < 0 then
	li_ret = -1
else
	li_ret = 1
end if

if li_ret = 1 then
	invo_data.of_write(lstr_book)
end if

if li_ret = 1 then

	for li_i = 1 to il_worksheetindex
		lnvo_sheet = invo_worksheets[li_i]
		lnvo_sheet.of_write_data(lstr_book)
	next

end if

if li_ret = 1 then
	lstr_book.close()
	istg_doc.close()
end if

return li_ret
end function

protected function integer of_store_palette ();integer li_ret = 1
uint li_record = 146
uint li_length
uint li_ccv
uint li_i
blob lb_header
blob lb_data
blob lb_data_item

li_ccv = 56
li_length = 2 + 4 * li_ccv

for li_i = 1 to li_ccv
	lb_data_item = invo_sub.of_pack("C",ii_palette[1,li_i]) + invo_sub.of_pack("C",ii_palette[2,li_i]) + invo_sub.of_pack("C",ii_palette[3,li_i]) + invo_sub.of_pack("C",ii_palette[4,li_i])

	if li_i = 1 then
		lb_data = lb_data_item
	else
		lb_data = lb_data + lb_data_item
	end if

next

lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length) + invo_sub.of_pack("v",li_ccv)
of_append(lb_header,lb_data)
return li_ret
end function

protected function integer of_store_style ();integer li_ret
uint li_record = 659
uint li_length = 4
uint li_ixfe = 32768
integer li_builtin
integer li_ilevel = 255
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lb_data = invo_sub.of_pack("v",li_ixfe) + invo_sub.of_pack("C",li_builtin) + invo_sub.of_pack("C",li_ilevel)
of_append(lb_header,lb_data)
return li_ret
end function

protected function integer of_store_window1 ();integer li_ret = 1
uint li_record = 61
uint li_length = 18
uint li_xwn
uint li_ywn
uint li_dxwn = 9660
uint li_dywn = 5490
uint li_grbit = 56
uint li_wtabratio = 600
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v",li_record) + invo_sub.of_pack("v",li_length)
lblb_data = invo_sub.of_pack("v",li_xwn) + invo_sub.of_pack("v",li_ywn) + invo_sub.of_pack("v",li_dxwn) + invo_sub.of_pack("v",li_dywn) + invo_sub.of_pack("v",li_grbit) + invo_sub.of_pack("v",ii_activesheet) + invo_sub.of_pack("v",ii_firstsheet) + invo_sub.of_pack("v",ii_selected) + invo_sub.of_pack("v",li_wtabratio)
of_append(lblb_header,lblb_data)
return li_ret
end function

protected function integer of_store_workbook ();long ll_i
n_xls_worksheet_v5 lnvo_sheet

if il_worksheetindex = 0 then
	of_add_worksheet()
end if

if ii_activesheet = 0 then
	lnvo_sheet = invo_worksheets[1]
	lnvo_sheet.ib_selected = true
end if

for ll_i = 1 to il_worksheetindex
	lnvo_sheet = invo_worksheets[ll_i]

	if lnvo_sheet.ib_selected then
		ii_selected ++
	end if

	lnvo_sheet.of_close()
next

of_store_bof(5)
of_store_codepage()
of_store_externs()
of_store_names()
of_store_window1()
of_store_1904()
of_store_all_fonts()
of_store_all_num_formats()
of_store_all_xfs()
of_store_all_styles()
of_store_palette()
of_calc_sheet_offsets()

for ll_i = 1 to il_worksheetindex
	lnvo_sheet = invo_worksheets[ll_i]
	of_store_boundsheet(lnvo_sheet.is_worksheetname,lnvo_sheet.il_offset)
next

of_store_eof()
return of_store_ole_file()
end function

event constructor;call super::constructor;

invo_data = create n_xls_data
return
end event

on n_xls_workbook_v5.create
triggerevent("constructor")
end on

on n_xls_workbook_v5.destroy
triggerevent("destructor")
end on

