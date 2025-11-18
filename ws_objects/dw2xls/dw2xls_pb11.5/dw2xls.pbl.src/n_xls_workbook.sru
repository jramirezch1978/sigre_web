$PBExportHeader$n_xls_workbook.sru
forward
global type n_xls_workbook from nonvisualobject
end type
end forward

global type n_xls_workbook from nonvisualobject
event type unsignedlong ue_add_string ( string as_value )
event type unsignedlong ue_add_unicode ( blob ab_string )
end type
global n_xls_workbook n_xls_workbook

type variables
PUBLIC STRING is_filename

PUBLIC LONG 	il_worksheetindex
PUBLIC INTEGER ii_activesheet

PUBLIC INTEGER ii_firstsheet
PUBLIC UINT    ii_biff_version = 1536

PUBLIC 		n_xls_worksheet  		 invo_worksheets[]
PUBLIC		n_xls_subroutines 			 invo_sub
Public  		n_xls_formats    			    invo_Formats
PUBLIC		n_xls_data 						 invo_data
PUBLIC 		n_cst_sst 						 invo_sst

PRIVATE		 olestorage 					 istg_doc
PRIVATE 	    olestorage 					 invo_olestorage
PUBLIC 		 n_xls_format		       invo_tmp_format
PUBLIC 		 n_xls_format 			 invo_url_format



PRIVATE	 		BOOLEAN 	ib_fileclosed = True 
PUBLIC		 	BLOB 		ib_sheetnames[]

PRIVATE 			STRING   is_sheetname = "Sheet"
PUBLIC 			INTEGER  ii_selected
PRIVATE 			INTEGER  ii_palette[4, 56]

PRIVATE	 		 UINT    iui_codepage = 1252
PROTECTED		 BLOB    iblb_data

PROTECTED 		ULONG    il_datasize
PROTECTED	   ULONG    il_biffsize

PROTECTED  		UINT     iui_limit = 8224
PROTECTED 		BOOLEAN  ib_1904
PROTECTED      BOOLEAN  ib_WindowProtect  


end variables

forward prototypes
public function integer of_create (string as_filename)
public function integer of_close ()
public function integer of_set_custom_color (integer ai_index, integer ai_red, integer ai_green, integer ai_blue)
public function integer of_set_temp_dir (string as_tempdir)
public function integer of_set_codepage (unsignedinteger aui_codepage)
public function integer of_set_palette_xl97 ()
public function long of_get_xf (ref n_xls_format anvo_format)
public function long of_reg_format (ref n_xls_format anvo_format)
public function unsignedinteger of_get_fomratindex (n_xls_format anvo_format)
public function blob of_add_continue (blob ablb_data)
public function integer of_append (blob ablb_data)
public function integer of_append (blob ablb_header, blob ablb_data)
public function integer of_append (blob ablb_header, blob ablb_data, blob ablb_add_data)
public function integer of_calc_sheet_offsets ()
public function integer of_get_externs_size ()
public function integer of_get_names_size ()
public function boolean of_is_number (string as_str)
public function boolean of_is_zero_started_number (string as_str)
public function integer of_store_1904 ()
public function integer of_store_all_fonts ()
public function integer of_store_all_num_formats ()
public function integer of_store_all_styles ()
public function integer of_store_all_xfs ()
public function integer of_store_bof (integer ai_type)
public function integer of_store_boundsheet (blob ab_sheetname, unsignedlong al_offset)
public function integer of_store_codepage ()
public function integer of_store_eof ()
public function integer of_store_externcount (unsignedinteger ai_cxals)
public function integer of_store_externs ()
public function integer of_store_externsheet ()
public function integer of_store_extsst ()
public function integer of_store_name_long (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax)
public function integer of_store_name_short (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax)
public function integer of_store_names ()
public function integer of_store_num_format (blob ab_format, unsignedinteger ai_index)
public function integer of_store_ole_file ()
public function integer of_store_palette ()
public function integer of_store_sst (unsignedlong al_offset)
public function integer of_store_style ()
public function integer of_store_supbook ()
public function integer of_store_window1 ()
public function integer of_store_workbook ()
public function n_xls_worksheet of_add_worksheet (blob ab_worksheetname)
public function n_xls_worksheet of_add_worksheet (string as_worksheetname)
public function n_xls_worksheet of_add_worksheet ()
public function n_xls_worksheet of_addworksheet ()
public function n_xls_worksheet of_addworksheet (blob ab_worksheetname)
public function n_xls_worksheet of_addworksheet (string as_worksheetname)
public function integer of_store_mms ()
public function integer of_store_interfacehdr ()
public function integer of_store_interfaceend ()
public function integer of_store_writeaccess ()
public function integer of_store_backup ()
public function integer of_store_dsf ()
public function integer of_store_tabid ()
public function integer of_store_bookbool ()
public function integer of_store_windowprotect ()
public function integer of_store_password ()
public function integer of_store_protect ()
public function integer of_store_system_num_format (unsignedinteger ai_index)
end prototypes

event type unsignedlong ue_add_string(string as_value);return invo_sst.of_add_string(as_value)
end event

event type unsignedlong ue_add_unicode(blob ab_string);return invo_sst.of_add_string(ab_string)
end event

public function integer of_create (string as_filename);integer li_ret = 1

invo_tmp_format = create n_xls_format
of_reg_format(invo_tmp_format)

invo_url_format = create n_xls_format
invo_url_format.of_set_color("blue")
invo_url_format.of_set_underline(1)
of_reg_format(invo_url_format)


if as_filename = "" or isnull(as_filename) then
    messagebox("提示", "必须指定文件名称!", stopsign!)
    li_ret = -1
end if


if li_ret = 1 then
   if not ib_fileclosed then
        messagebox("提示", "当前文件还没有被保存!", stopsign!)
        li_ret = -1
    end if
end if


if li_ret = 1 then
    istg_doc = create olestorage
    li_ret = istg_doc.open(as_filename, stgreadwrite!, stgexclusive!)

    if li_ret < 0 then
        messagebox("提示", "可能其它程序正在打开该文件!~r~n" + "打开文件失败!", stopsign!)
        
		  istg_doc.Close()
		  Destroy(istg_doc)
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

public function integer of_close ();integer li_ret = 1


if not ib_fileclosed then
    li_ret = of_store_workbook()
end if

return li_ret


end function

public function integer of_set_custom_color (integer ai_index, integer ai_red, integer ai_green, integer ai_blue);if ai_index < 8 or ai_index > 64 then
    messagebox("Error", "Color index " + string(ai_index) + " outside range: 8 <= index <= 64")
    return -1
elseif ai_red < 0 or ai_red > 255 or ai_green < 0 or ai_green > 255 or ai_blue < 0 or ai_blue > 255 then
    messagebox("Error", "Color component outside range: 0 <= color <= 255")
    return -1
else
    ai_index = ai_index - 7
    ii_palette[1, ai_index] = ai_red
    ii_palette[2, ai_index] = ai_green
    ii_palette[3, ai_index] = ai_blue
    ii_palette[4, ai_index] = 0
    return ai_index + 7
end if



end function

public function integer of_set_temp_dir (string as_tempdir);Return 1
end function

public function integer of_set_codepage (unsignedinteger aui_codepage);iui_codepage = aui_codepage

return 1
end function

public function integer of_set_palette_xl97 ();ii_palette[] = { 0, 0, 0, 0, 255, 255, 255, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0, 255, 255, 0, 0, 255, 0, 255, 0, 0, 255, 255, 0, 128, 0, 0, 0, 0, 128, 0, 0, 0, 0, 128, 0, 128, 128, 0, 0, 128, 0, 128, 0, 0, 128, 128, 0, 192, 192, 192, 0, 128, 128, 128, 0, 153, 153, 255, 0, 153, 51, 102, 0, 255, 255, 204, 0, 204, 255, 255, 0, 102, 0, 102, 0, 255, 128, 128, 0, 0, 102, 204, 0, 204, 204, 255, 0, 0, 0, 128, 0, 255, 0, 255, 0, 255, 255, 0, 0, 0, 255, 255, 0, 128, 0, 128, 0, 128, 0, 0, 0, 0, 128, 128, 0, 0, 0, 255, 0, 0, 204, 255, 0, 204, 255, 255, 0, 204, 255, 204, 0, 255, 255, 153, 0, 153, 204, 255, 0, 255, 153, 204, 0, 204, 153, 255, 0, 255, 204, 153, 0, 51, 102, 255, 0, 51, 204, 204, 0, 153, 204, 0, 0, 255, 204, 0, 0, 255, 153, 0, 0, 255, 102, 0, 0, 102, 102, 153, 0, 150, 150, 150, 0, 0, 51, 102, 0, 51, 153, 102, 0, 0, 51, 0, 0, 51, 51, 0, 0, 153, 51, 0, 0, 153, 51, 102, 0, 51, 51, 153, 0, 51, 51, 51, 0 }
return 1


end function

public function long of_get_xf (ref n_xls_format anvo_format);string ls_key
long li_ret


//if anvo_format.ii_xf_index > 0 then
//    return anvo_format.ii_xf_index
//end if

ls_key = anvo_format.of_get_format_key()

li_Ret= invo_Formats.OF_Format_Exist(ls_key) 
IF li_Ret<=0 Then
	li_Ret=15
END IF 

//if invo_xfs.of_key_exists(ls_key) then
//    li_ret = invo_xfs.of_get_value(ls_key)
//else
//    li_ret = 15
//end if

return li_ret


end function

public function long of_reg_format (ref n_xls_format anvo_format);Return invo_Formats.OF_Add(anvo_format)

end function

public function unsignedinteger of_get_fomratindex (n_xls_format anvo_format);
IF IsNull(anvo_format) OR Not IsValid(anvo_format) Then
	Return -1
END IF

Return invo_Formats.OF_Format_Exist(anvo_Format.OF_Get_Format_Key()) 
 

end function

public function blob of_add_continue (blob ablb_data);uint lui_record = 60
blob lblb_header
blob lblb_temp
long ll_len

lblb_temp = blobmid(ablb_data, 1, iui_limit)
ablb_data = blobmid(ablb_data, iui_limit + 1, len(ablb_data) - iui_limit)
blobedit(lblb_temp, 3, invo_sub.of_pack("v", iui_limit - 4))

do While len(ablb_data) > iui_limit
    lblb_header = invo_sub.of_pack("v", lui_record) + invo_sub.of_pack("v", iui_limit)
    lblb_temp = lblb_temp + lblb_header
    lblb_temp = lblb_temp + blobmid(ablb_data, 1, iui_limit)
    ablb_data = blobmid(ablb_data, iui_limit + 1, len(ablb_data) - iui_limit)
loop

lblb_header = invo_sub.of_pack("v", lui_record) + invo_sub.of_pack("v", len(ablb_data))
lblb_temp = lblb_temp + lblb_header
lblb_temp = lblb_temp + ablb_data
return lblb_temp


end function

public function integer of_append (blob ablb_data);integer li_ret = 1


if len(ablb_data) > iui_limit then
    ablb_data = of_add_continue(ablb_data)
end if

il_datasize += len(ablb_data)
invo_data.of_append(ablb_data)
return li_ret


end function

public function integer of_append (blob ablb_header, blob ablb_data);return of_append(ablb_header + ablb_data)
end function

public function integer of_append (blob ablb_header, blob ablb_data, blob ablb_add_data);return of_append(ablb_header + ablb_data + ablb_add_data)
end function

public function integer of_calc_sheet_offsets ();integer li_ret = 1
integer li_boundsheetheader = 12
integer li_eof = 4
ulong ll_offset
long ll_i
n_xls_worksheet lnvo_sheet

ll_offset = il_datasize

for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]
    ll_offset += li_boundsheetheader + len(lnvo_sheet.ib_worksheetname)
next

ll_offset += of_get_externs_size()
ll_offset += of_get_names_size()
ll_offset += li_eof

for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]
    lnvo_sheet.il_offset = ll_offset
    ll_offset += lnvo_sheet.il_datasize
next

il_biffsize = ll_offset
return li_ret


end function

public function integer of_get_externs_size ();integer li_cnt

li_cnt=upperbound(ib_sheetnames)
return 8 + 6 + 6 * li_cnt
end function

public function integer of_get_names_size ();integer li_ret
long ll_i
n_xls_worksheet lnvo_sheet


for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]

    if not isnull(lnvo_sheet.ii_print_rowmin) then
        li_ret = li_ret + 31
    end if

next


for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]

    if not isnull(lnvo_sheet.ii_title_rowmin) and not isnull(lnvo_sheet.ii_title_colmin) then
        li_ret = li_ret + 46
    elseif not isnull(lnvo_sheet.ii_title_rowmin) then
        li_ret = li_ret + 31
    elseif not isnull(lnvo_sheet.ii_title_colmin) then
        li_ret = li_ret + 31
    end if

next

return li_ret


end function

public function boolean of_is_number (string as_str);integer li_i
integer li_cnt
string ls_ch

as_str = trim(as_str)
li_cnt = len(as_str)

if li_cnt < 1 then
    return false
end if


for li_i = 1 to li_cnt
    ls_ch = mid(as_str, li_i, 1)

    choose case ls_ch
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
            continue
        case else
            return false
    end choose

next

return true


end function

public function boolean of_is_zero_started_number (string as_str);integer li_i
integer li_cnt
string ls_ch

as_str = trim(as_str)

if right(as_str, 1) = "0" then
    li_cnt = len(as_str)

    if li_cnt < 2 then
        return false
    end if


    for li_i = 2 to li_cnt
        ls_ch = mid(as_str, li_i, 1)

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

public function integer of_store_1904 ();uint li_record = 34
uint li_length = 2
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)

if ib_1904 then
    lblb_data = invo_sub.of_pack("v", 1)
else
    lblb_data = invo_sub.of_pack("v", 0)
end if

li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_all_fonts ();blob lb_font
string ls_key
string ls_font_keys[]
long ll_keys_cnt
long ll_format_cnt
long ll_i
long ll_j
long ll_key
integer li_ret = 1

lb_font = invo_tmp_format.of_get_font()

for ll_i = 1 to 5
    of_append(lb_font)
next

ll_j=upperbound(invo_formats.iblob_font)
for ll_i=1 to ll_j
 	of_append(invo_formats.iblob_font[ll_i])
next 



return li_ret


end function

public function integer of_store_all_num_formats ();Long	 li 
Long  li_COunt 
blob  lb_data 

li_COunt=UpperBound(invo_formats.is_num_format)
for li = 1 to li_COunt
	lb_data= invo_sub.to_unicode(invo_formats.is_num_format[li])
    of_store_num_format(lb_data, li + 164 -1  )  
next

return 1


end function

public function integer of_store_all_styles ();integer li_ret

li_ret = of_store_style()
return li_ret
end function

public function integer of_store_all_xfs ();blob lb_xf
long li,li_count 

lb_xf = invo_tmp_format.of_get_xf("style")

for li = 1 to 15
    of_append(lb_xf)
next

li_count=upperbound( invo_formats.iblob_xfs) 
for li=1 to li_count 
	of_append(invo_formats.iblob_xfs[li]) 
next 

return 1






end function

public function integer of_store_bof (integer ai_type);uint li_record = 2057
uint li_len = 16
uint li_build = 6319
uint li_year = 1997
ulong ll_history_flag = 16449
ulong ll_lowest_version = 262


blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_len)
lblb_data = invo_sub.of_pack("v", ii_biff_version) + invo_sub.of_pack("v", ai_type) + invo_sub.of_pack("v", li_build) + invo_sub.of_pack("v", li_year) + invo_sub.of_pack("V", ll_history_flag) + invo_sub.of_pack("V", ll_lowest_version)
of_append(lblb_header + lblb_data)
return 1


end function

public function integer of_store_boundsheet (blob ab_sheetname, unsignedlong al_offset);integer li_ret = 1
uint li_record = 133
uint li_length
uint li_grbit
uint li_cch
blob lb_header
blob lb_data

li_cch = len(ab_sheetname) / 2
li_length = 8 + li_cch * 2
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("V", al_offset) + invo_sub.of_pack("v", li_grbit) + invo_sub.of_pack("C", li_cch) + invo_sub.of_pack("C", 1) + ab_sheetname
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_codepage ();uint li_record = 66
uint li_length = 2
blob lblb_header
blob lblb_data
integer li_ret

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", 1200)
li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_eof ();integer li_ret = 1
uint li_record = 10
uint li_length
blob lb_header

lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
of_append(lb_header)
return li_ret


end function

public function integer of_store_externcount (unsignedinteger ai_cxals);integer li_ret = 1
uint li_record = 22
uint li_length = 2
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", ai_cxals)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_externs ();of_store_supbook()
of_store_externsheet()
return 1


end function

public function integer of_store_externsheet ();integer li_ret = 1
uint li_record = 23
uint li_length
blob lb_header
blob lb_data
integer li_i
integer li_cnt

li_cnt = upperbound(ib_sheetnames)
li_length = 2 + 6 * li_cnt
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", li_cnt)

for li_i = li_cnt - 1 to 0 step  -1 //65535
    lb_data = lb_data + invo_sub.of_pack("v", 0) + invo_sub.of_pack("v", li_i) + invo_sub.of_pack("v", li_i)
next

of_append(lb_header + lb_data)
return li_ret


end function

public function integer of_store_extsst ();integer li_ret = 1
blob lblb_data

lblb_data = invo_sst.of_get_extsst()
il_datasize += len(lblb_data)
invo_data.of_append(lblb_data)
return li_ret


end function

public function integer of_store_name_long (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax);integer li_ret = 1
uint li_record = 24
uint li_length = 42
uint li_grbit = 32
integer li_chkey
integer li_cch = 1
uint li_cce = 26
uint li_ixals
uint li_itab
integer li_cchcustmenu
integer li_cchdescription
integer li_cchhelptopic
integer li_cchstatustext
integer li_rgch
integer li_unknown03 = 41
uint li_unknown04 = 23
integer li_unknown05 = 59
blob lb_header
blob lb_data
uint li_ext_ref

li_ixals = ai_index + 1
li_itab = li_ixals
li_rgch = ai_type
li_ext_ref = upperbound(ib_sheetnames) - ai_index - 1
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", li_grbit) + invo_sub.of_pack("C", li_chkey) + invo_sub.of_pack("C", li_cch) + invo_sub.of_pack("v", li_cce) + invo_sub.of_pack("v", ai_index) + invo_sub.of_pack("v", li_itab) + invo_sub.of_pack("C", li_cchcustmenu) + invo_sub.of_pack("C", li_cchdescription) + invo_sub.of_pack("C", li_cchhelptopic) + invo_sub.of_pack("C", li_cchstatustext) + invo_sub.of_pack("C", 0) + invo_sub.of_pack("C", li_rgch) + invo_sub.of_pack("C", li_unknown03) + invo_sub.of_pack("v", li_unknown04) + invo_sub.of_pack("C", li_unknown05) + invo_sub.of_pack("v", li_ext_ref) + invo_sub.of_pack("v", 0) + invo_sub.of_pack("v", 65535) + invo_sub.of_pack("v", ai_colmin) + invo_sub.of_pack("v", ai_colmax) + invo_sub.of_pack("C", li_unknown05) + invo_sub.of_pack("v", li_ext_ref) + invo_sub.of_pack("v", ai_rowmin) + invo_sub.of_pack("v", ai_rowmax) + invo_sub.of_pack("v", 0) + invo_sub.of_pack("v", 255) + invo_sub.of_pack("C", 16)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_name_short (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax);integer li_ret = 1
uint li_record = 24
uint li_length = 27
uint li_grbit = 32
integer li_chkey
integer li_cch = 1
uint li_cce = 11
uint li_ixals
uint li_itab
integer li_cchcustmenu
integer li_cchdescription
integer li_cchhelptopic
integer li_cchstatustext
integer li_rgch
integer li_unknown03 = 59
uint li_unknown04
blob lb_header
blob lb_data

li_ixals = ai_index + 1
li_itab = li_ixals
li_rgch = ai_type
li_unknown04 = upperbound(ib_sheetnames) - ai_index - 1
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", li_grbit) + invo_sub.of_pack("C", li_chkey) + invo_sub.of_pack("C", li_cch) + invo_sub.of_pack("v", li_cce) + invo_sub.of_pack("v", ai_index) + invo_sub.of_pack("v", li_itab) + invo_sub.of_pack("C", li_cchcustmenu) + invo_sub.of_pack("C", li_cchdescription) + invo_sub.of_pack("C", li_cchhelptopic) + invo_sub.of_pack("C", li_cchstatustext) + invo_sub.of_pack("C", 0) + invo_sub.of_pack("C", li_rgch) + invo_sub.of_pack("C", li_unknown03) + invo_sub.of_pack("v", li_unknown04) + invo_sub.of_pack("v", ai_rowmin) + invo_sub.of_pack("v", ai_rowmax) + invo_sub.of_pack("v", ai_colmin) + invo_sub.of_pack("v", ai_colmax)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_names ();integer li_ret = 1
long ll_i
n_xls_worksheet lnvo_sheet


for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]

    if not isnull(lnvo_sheet.ii_print_rowmin) then
        of_store_name_short(ll_i - 1, 6, lnvo_sheet.ii_print_rowmin, lnvo_sheet.ii_print_rowmax, lnvo_sheet.ii_print_colmin, lnvo_sheet.ii_print_colmax)
    end if

next


for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]

    if not isnull(lnvo_sheet.ii_title_rowmin) and not isnull(lnvo_sheet.ii_title_colmin) then
        of_store_name_long(ll_i - 1, 7, lnvo_sheet.ii_title_rowmin, lnvo_sheet.ii_title_rowmax, lnvo_sheet.ii_title_colmin, lnvo_sheet.ii_title_colmax)
    elseif not isnull(lnvo_sheet.ii_title_rowmin) then
        of_store_name_short(ll_i - 1, 7, lnvo_sheet.ii_title_rowmin, lnvo_sheet.ii_title_rowmax, 0, 255)
    elseif not isnull(lnvo_sheet.ii_title_colmin) then
        of_store_name_short(ll_i - 1, 7, 0, 65535, lnvo_sheet.ii_title_colmin, lnvo_sheet.ii_title_colmax)
    end if

next

return li_ret


end function

public function integer of_store_num_format (blob ab_format, unsignedinteger ai_index);integer li_ret = 1
uint li_record = 1054
uint li_length
uint li_len_format
blob lb_header
blob lb_data
integer li_grbit = 1
integer li_cch

li_cch = len(ab_format) / 2
li_length = 5 + li_cch * 2
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", ai_index) + invo_sub.of_pack("v", li_cch) + invo_sub.of_pack("C", li_grbit) + ab_format
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_ole_file ();integer li_ret = 1
integer li_i
olestream lstr_book
n_xls_worksheet lnvo_sheet

lstr_book = create olestream
li_ret = lstr_book.open(istg_doc, "Workbook", stgwrite!)

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

public function integer of_store_palette ();integer li_ret = 1
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
    lb_data_item = invo_sub.of_pack("C", ii_palette[1, li_i]) + invo_sub.of_pack("C", ii_palette[2, li_i]) + invo_sub.of_pack("C", ii_palette[3, li_i]) + invo_sub.of_pack("C", ii_palette[4, li_i])

    if li_i = 1 then
        lb_data = lb_data_item
    else
        lb_data = lb_data + lb_data_item
    end if

next

lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length) + invo_sub.of_pack("v", li_ccv)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_sst (unsignedlong al_offset);integer li_ret = 1
blob lblb_data

lblb_data = invo_sst.of_get_sst(al_offset)
il_datasize += len(lblb_data)
invo_data.of_append(lblb_data)
return li_ret


end function

public function integer of_store_style ();integer li_ret
uint li_record = 659
uint li_length = 4
uint li_ixfe = 32768
integer li_builtin
integer li_ilevel = 255
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", li_ixfe) + invo_sub.of_pack("C", li_builtin) + invo_sub.of_pack("C", li_ilevel)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_supbook ();uint li_record = 430
uint li_length = 4
blob lblb_header
blob lblb_data
integer li_ret

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", upperbound(ib_sheetnames)) + invo_sub.of_pack("v", 1025)
li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_window1 ();integer li_ret = 1
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

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", li_xwn) + invo_sub.of_pack("v", li_ywn) + invo_sub.of_pack("v", li_dxwn) + invo_sub.of_pack("v", li_dywn) + invo_sub.of_pack("v", li_grbit) + invo_sub.of_pack("v", ii_activesheet) + invo_sub.of_pack("v", ii_firstsheet) + invo_sub.of_pack("v", ii_selected) + invo_sub.of_pack("v", li_wtabratio)
of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_workbook ();long ll_i
n_xls_worksheet lnvo_sheet


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

//新增的函数
//of_store_InterfaceHdr()
//of_store_MMS()
//of_store_interfaceEnd() 
//of_store_WriteAccess() 



//records.add( retval.createCodepage() );
//records.add( retval.createDSF() );
//records.add( retval.createTabId() );
//retval.records.setTabpos( records.size() - 1 );
//records.add( retval.createFnGroupCount() );
//records.add( retval.createWindowProtect() );
//records.add( retval.createProtect() );
//retval.records.setProtpos( records.size() - 1 );
//records.add( retval.createPassword() );
//records.add( retval.createProtectionRev4() );
//records.add( retval.createPasswordRev4() );
//records.add( retval.createWindowOne() );
//records.add( retval.createBackup() );
//retval.records.setBackuppos( records.size() - 1 );
//records.add( retval.createHideObj() );
//records.add( retval.createDateWindow1904() );
//records.add( retval.createPrecision() );
//records.add( retval.createRefreshAll() );
//records.add( retval.createBookBool() );
//records.add( retval.createFont() );
//records.add( retval.createFont() );
//records.add( retval.createFont() );
//records.add( retval.createFont() );
		  
of_store_codepage()

////NEW
//of_store_dsf()
//of_store_tabID()
//of_store_WindowProtect()
//of_store_password() 
//of_store_protect()


of_store_window1()
//of_store_backup() //NEW
of_store_1904()
//of_Store_BookBool() //NEW

of_store_all_fonts()

//for ll_i=1 to 8
//	of_store_system_num_format(ll_i) 
//Next

of_store_all_num_formats() //保存自定义格式

of_store_all_xfs()
of_store_all_styles()
of_store_palette()
of_store_sst(il_datasize)
of_store_extsst()
of_calc_sheet_offsets()

for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]
    of_store_boundsheet(lnvo_sheet.ib_worksheetname, lnvo_sheet.il_offset)
next



of_store_externs()
of_store_names()
of_store_eof()
return of_store_ole_file()



end function

public function n_xls_worksheet of_add_worksheet (blob ab_worksheetname);integer li_ret = 1
integer li_i
integer li_len
string ls_name
n_xls_worksheet lnvo_cursheet
n_xls_worksheet lnvo_worksheet

ls_name = invo_sub.to_ansi(ab_worksheetname, 0, "_")


do
    li_len = len(ab_worksheetname) / 2

    if li_len > 31 then
        messagebox("Error", "Length of Worksheet name must be less then 31 symbols", stopsign!)
        li_ret = -1
        exit
    end if


    if match(ls_name, "[:*?/\]") then
        messagebox("Error", "Invalid worksheet name", stopsign!)
        li_ret = -1
        exit
    end if


    if trim(ls_name) = "" then
        ab_worksheetname = invo_sub.to_unicode(is_sheetname + string(il_worksheetindex + 1))
        ls_name = invo_sub.to_ansi(ab_worksheetname, 0, "_")
    end if


    for li_i = 1 to il_worksheetindex
        lnvo_cursheet = invo_worksheets[li_i]

        if lnvo_cursheet.ib_worksheetname = ab_worksheetname then
            messagebox("Error", "Duplicate worksheet name", stopsign!)
            li_ret = -1
            exit
        end if

    next


    if li_ret <> 1 then
        exit
    end if

    lnvo_worksheet = create n_xls_worksheet
    lnvo_worksheet.invo_url_format = invo_url_format
    lnvo_worksheet.invo_workbook = this
    lnvo_worksheet.ib_worksheetname = ab_worksheetname
    lnvo_worksheet.is_worksheetname = ls_name
    il_worksheetindex ++
    lnvo_worksheet.ii_index = il_worksheetindex
    ib_sheetnames[il_worksheetindex] = lnvo_worksheet.ib_worksheetname
    invo_worksheets[il_worksheetindex] = lnvo_worksheet
	 
	 
loop Until true


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

public function n_xls_worksheet of_add_worksheet (string as_worksheetname);return of_add_worksheet(invo_sub.to_unicode(as_worksheetname))
end function

public function n_xls_worksheet of_add_worksheet ();return of_add_worksheet("")
end function

public function n_xls_worksheet of_addworksheet ();return of_add_worksheet()
end function

public function n_xls_worksheet of_addworksheet (blob ab_worksheetname);return of_add_worksheet(ab_worksheetname)
end function

public function n_xls_worksheet of_addworksheet (string as_worksheetname);return of_add_worksheet(as_worksheetname)
end function

public function integer of_store_mms ();uint li_record = 193 //0xC1
uint li_length = 2  
int li_addMenuCount=0
int li_delMenuCount = 0 
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("c", li_addMenuCount) + invo_sub.of_pack("c", li_delMenuCount)

li_ret = of_append(lblb_header,lblb_data)

return li_ret


end function

public function integer of_store_interfacehdr ();integer li_ret
uint li_record = 225  //0xE1
uint li_length = 2  
uint li_codepage = 1252  // 0x4b0 
blob lb_header
blob lb_data

lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", li_codepage)
of_append(lb_header, lb_data)
return li_ret


end function

public function integer of_store_interfaceend ();uint li_record = 226 // 0x e2 
integer li_ret
blob lblb_header

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", 0)
li_ret = of_append(lblb_header)
return li_ret


end function

public function integer of_store_writeaccess ();uint li_record = 92  //0x5c
uint li_length =112
String ls_username ='黄国酬' 
integer li_ret
blob lblb_header 
blob lblb_data
blob lb_username  
int li ,li_len 

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
ls_username = ls_username +Space(109 - Len(ls_username )) 
lb_username= invo_sub.to_unicode(ls_username,1252) 

li_len= len(lb_username)/2
for li=1 to li_len 
	lblb_data+= invo_sub.of_pack('c',asc(char(blobMid(lb_username , ( li -1 ) * 2+1, 2))))
next 
lblb_data = invo_sub.of_pack('v',3)+invo_sub.of_pack('C',0)+lblb_data
of_append( lblb_header,lblb_data) 

return li_ret


end function

public function integer of_store_backup ();uint li_record = 64 //0x40
uint li_length = 2
uint li_backup = 0 
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", li_backup)


li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_dsf ();uint li_record = 353 // 0x161 
uint li_length = 2
uint li_dsf=0

integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", li_dsf)


li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_tabid ();uint li_record = 317  //0X13d
uint li_length = 0
uint li_tabids = 0 
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
//lblb_data = invo_sub.of_pack("v", li_tabids)


li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_bookbool ();uint li_record = 218   //0xDA 
uint li_length = 2
uint li_save_link_values = 0

integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", li_save_link_values)


li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_windowprotect ();//uint li_record = 25 //0x19 
//uint li_length = 2
//integer li_ret
//blob lblb_header
//blob lblb_data
//
//lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
//
//if ib_WindowProtect then
//    lblb_data = invo_sub.of_pack("v", 1)
//else
//    lblb_data = invo_sub.of_pack("v", 0)
//end if
//
//li_ret = of_append(lblb_header, lblb_data)
//return li_ret

Return 1 
end function

public function integer of_store_password ();uint li_record = 19 //0x13 
uint li_length = 2
uint li_password 
integer li_ret
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lblb_data = invo_sub.of_pack("v", li_password)


li_ret = of_append(lblb_header, lblb_data)
return li_ret


end function

public function integer of_store_protect ();//uint li_record = 18 //0x12
//uint li_length = 2
//uint li_protect 
//integer li_ret
//blob lblb_header
//blob lblb_data
//
//lblb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
//lblb_data = invo_sub.of_pack("v", li_protect)
//li_ret = of_append(lblb_header, lblb_data)
//
//return li_ret

Return 1 


end function

public function integer of_store_system_num_format (unsignedinteger ai_index);integer li_ret = 1
uint li_record = 1054
uint li_length
uint li_len_format
blob lb_header
blob lb_data
integer li_grbit = 1
integer li_cch
String  ls_Format 
blob  lb_Format 


Choose Case ai_Index
		
	 Case 1
		   ls_Format= "$#,##0_);\($#,##0\)"
	   	ai_Index = 5 
			
	Case 2
	     ls_Format = "$#,##0_);[Red]\($#,##0\)"
		  ai_Index=6
	
	Case 3
	     ls_Format = "$#,##0.00_);\($#,##0.00\)"
		  ai_Index=7
		  
	Case 4
	     ls_Format = "$#,##0.00_);[Red]\($#,##0.00\)"
		  ai_Index=8
		  
	Case 5
	     ls_Format = "_($* #,##0_);_($* \(#,##0\);_($* -_);_(@_)"
		  ai_Index=40 //0x2a 
		  
	Case 6
	     ls_Format = "_(* #,##0_);_(* \(#,##0\);_(* -_);_(@_)"
		  ai_Index=41
		  
	Case 7
	     ls_Format = "_($* #,##0.00_);_($* \(#,##0.00\);_($* -??_);_(@_)"
		  ai_Index=58
		  
	Case 8
	     ls_Format = "_(* #,##0.00_);_(* \(#,##0.00\);_(* -??_);_(@_)"
		  ai_Index=31	
		  
END CHOOSE 



lb_format = invo_sub.to_unicode(ls_format) 
li_cch = len(ls_format) 
li_length = 5 + li_cch * 2
lb_header = invo_sub.of_pack("v", li_record) + invo_sub.of_pack("v", li_length)
lb_data = invo_sub.of_pack("v", ai_index) + invo_sub.of_pack("v", li_cch) + invo_sub.of_pack("C", li_grbit) + lb_Format
of_append(lb_header, lb_data)
return li_ret


end function

on n_xls_workbook.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_workbook.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_sub = create n_xls_subroutines
//invo_xfs = create n_cst_hash_long
invo_data = create n_xls_data
invo_sst = create n_cst_sst


invo_Formats=create n_xls_formats

end event

event destructor;int li
destroy(invo_sub)
destroy(invo_sst)
destroy invo_sub 
destroy invo_Formats
destroy invo_data
destroy istg_doc
destroy invo_olestorage
destroy invo_tmp_format
destroy invo_url_format

For li=1 To UpperBound( invo_worksheets) 
	 Destroy  invo_worksheets[li]
Next 
end event

