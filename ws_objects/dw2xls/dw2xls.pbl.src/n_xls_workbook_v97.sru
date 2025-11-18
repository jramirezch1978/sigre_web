$PBExportHeader$n_xls_workbook_v97.sru
forward
global type n_xls_workbook_v97 from n_xls_workbook
end type
end forward

shared variables

end variables

global type n_xls_workbook_v97 from n_xls_workbook
end type
global n_xls_workbook_v97 n_xls_workbook_v97

type variables
private olestorage istg_doc
private olestorage invo_olestorage
private boolean ib_fileclosed = true
public blob ib_sheetnames[]
private string is_sheetname = 'Лист'
public int ii_selected = 0
private int ii_palette[4,56]
private UInt iui_codepage = 1252
protected blob iblb_data
protected ulong il_datasize = 0
protected ulong il_biffsize = 0
protected UInt iui_limit = 8224
protected boolean ib_1904 = false

public n_xls_format_v97 invo_tmp_format;
public n_xls_format_v97 invo_url_format;
public n_xls_data invo_data;
public n_cst_sst invo_sst;

end variables

forward prototypes
public function integer of_create (string as_filename)
public function int of_close()
public function n_xls_worksheet of_add_worksheet()
public function n_xls_worksheet of_add_worksheet(blob AB_WORKSHEETNAME)
public function n_xls_worksheet of_add_worksheet(string AS_WORKSHEETNAME)
public function n_xls_format of_add_format ()
public function int of_set_custom_color(int AI_INDEX, int AI_RED, int AI_GREEN, int AI_BLUE)
protected function integer of_store_workbook ()
protected function int of_append(blob ABLB_HEADER, blob ABLB_DATA, blob ABLB_ADD_DATA)
protected function int of_append(blob ABLB_HEADER, blob ABLB_DATA)
protected function int of_append(blob ABLB_DATA)
protected function blob of_add_continue(blob ABLB_DATA)
protected function int of_store_bof(int AI_TYPE)
protected function int of_store_codepage()
protected function int of_store_supbook()
protected function int of_store_externs()
protected function int of_get_externs_size()
protected function integer of_store_names ()
protected function integer of_get_names_size ()
protected function integer of_store_window1 ()
protected function int of_store_1904()
protected function int of_store_all_fonts()
protected function boolean of_is_zero_started_number(string AS_STR)
protected function boolean of_is_number(string AS_STR)
protected function int of_store_all_num_formats()
protected function integer of_store_num_format (blob ab_format, unsignedinteger ai_index)
protected function integer of_store_all_xfs ()
protected function int of_store_all_styles()
protected function int of_store_style()
protected function int of_store_palette()
protected function integer of_calc_sheet_offsets ()
protected function integer of_store_boundsheet (blob ab_sheetname, unsignedlong al_offset)
protected function integer of_store_name_short (unsignedinteger ai_index, integer ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, integer ai_colmin, integer ai_colmax)
protected function int of_store_eof()
protected function integer of_store_externsheet ()
protected function integer of_store_ole_file ()
protected function integer of_store_name_long (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax)
public function int of_set_codepage(uint AUI_CODEPAGE)
public function int of_set_palette_xl97()
protected function integer of_store_sst (unsignedlong al_offset)
protected function integer of_store_extsst ()
end prototypes

public function integer of_create (string as_filename);integer li_ret = 1

invo_tmp_format = create n_xls_format_v97
of_reg_format(invo_tmp_format)




//invo_tmp_format = of_add_format()

//Add the default format for hyperlinks

invo_url_format = of_add_format()
invo_url_format.of_set_color('blue')
invo_url_format.of_set_underline(1) 
of_reg_format(invo_url_format)
//check filename
if as_filename = '' or isNull(as_filename) then
   	 
   	
      MessageBox('Error', 'File name must be specified', StopSign!)
   	
   li_ret = -1
end if

//check old file state
if li_ret = 1 then
  if not(ib_fileclosed) then
   	 
   	
      MessageBox('Error', 'Current workbook is not closed', StopSign!)
   	
      li_ret = -1
  end if
end if

//open file for write
if li_ret = 1 then
   istg_doc = create olestorage
   li_ret = istg_doc.open(as_filename, stgReadWrite! , stgExclusive!)
   if li_ret < 0 then
   	 
   	
      MessageBox('Error', 'File sharing violation~r~n' +&
      'Cannot open the file', StopSign!)
   	
      destroy istg_doc
      li_ret = -1
   else 
     ib_fileclosed = false
     li_ret = 1
   end if
end if

if li_ret = 1 then
   //set colour palette
   li_ret = of_set_palette_xl97()
end if

return li_ret

end function

public function int of_close();integer li_ret = 1

if not(ib_fileclosed) then
   li_ret = of_store_workbook()
end if

return li_ret
end function

public function n_xls_worksheet of_add_worksheet();return of_add_worksheet('')
end function

public function n_xls_worksheet of_add_worksheet(blob AB_WORKSHEETNAME);integer li_ret = 1
integer li_i
integer li_len
string ls_name
n_xls_worksheet_v97 lnvo_cursheet
n_xls_worksheet_v97 lnvo_worksheet
ls_name = invo_sub.to_ansi(ab_worksheetname, 0, '_')

do
  //check length of worksheet name
  li_len = len(ab_worksheetname)/2
  if li_len > 31 then
   	 
   	
      MessageBox('Error', 'Length of Worksheet name must be less then 31 symbols', StopSign!)
   	
     li_ret = -1
     exit
  end if
  
  //check symbols
  if Match(ls_name, "[:*?/\]") then
   	 
   	
     MessageBox('Error', 'Invalid worksheet name', StopSign!)
   	
     li_ret = -1
     exit
  end if
  
  
  if trim(ls_name) = '' then
     ab_worksheetname = invo_sub.to_unicode(is_sheetname + string(il_worksheetindex + 1)) 
     ls_name = invo_sub.to_ansi(ab_worksheetname, 0, '_')
  end if
  
  for li_i = 1 to il_worksheetindex
     lnvo_cursheet = invo_worksheets[li_i]
     if lnvo_cursheet.ib_worksheetname = ab_worksheetname then
      	 
      	
        MessageBox('Error', 'Duplicate worksheet name', StopSign!)
      	
         li_ret = -1
         exit
     end if
  next
  if li_ret <> 1 then exit
  
  lnvo_worksheet = create n_xls_worksheet_v97
  //some operations
  //for worksheet initialisation 

  lnvo_worksheet.invo_url_format = this.invo_url_format
  lnvo_worksheet.invo_workbook = this
  lnvo_worksheet.ib_worksheetname = ab_worksheetname
  lnvo_worksheet.is_worksheetname = ls_name
  
  // .....
  
  il_worksheetindex ++
  lnvo_worksheet.ii_index = il_worksheetindex
  ib_sheetnames[il_worksheetindex] = lnvo_worksheet.ib_worksheetname
  invo_worksheets[il_worksheetindex] = lnvo_worksheet
    
loop until true

if li_ret <> 1 then
   if Not(isNull(lnvo_worksheet)) then
      if isValid(lnvo_worksheet) then
         destroy lnvo_worksheet
         SetNull(lnvo_worksheet)
      end if
   end if
end if

return lnvo_worksheet 


end function

public function n_xls_worksheet of_add_worksheet(string AS_WORKSHEETNAME);
return of_add_worksheet(invo_sub.to_unicode(as_worksheetname))
end function

public function n_xls_format of_add_format ();n_xls_format_v97 lnvo_format
lnvo_format = create n_xls_format_v97

/*02.04.2004*/
//lnvo_format.ii_xf_index = ii_xf_index
//ii_xf_index ++
//il_formatindex ++
//
//invo_formats[il_formatindex] = lnvo_format

return lnvo_format


end function

public function int of_set_custom_color(int AI_INDEX, int AI_RED, int AI_GREEN, int AI_BLUE);
if (ai_index < 8) or (ai_index > 64) then
    MessageBox('Error', "Color index " + string(ai_index) + " outside range: 8 <= index <= 64")
    return -1
else
    // Check that the colour components are in the right range
    if ( (ai_red   < 0) or (ai_red   > 255) or &
         (ai_green < 0) or (ai_green > 255) or &
         (ai_blue  < 0) or (ai_blue  > 255)) then
       MessageBox('Error', "Color component outside range: 0 <= color <= 255")
       return -1
    else
      ai_index -= 7
      // Set the RGB value
      ii_palette[1, ai_index] = ai_red
      ii_palette[2, ai_index] = ai_green
      ii_palette[3, ai_index] = ai_blue
      ii_palette[4, ai_index] = 0
      
      return (ai_index + 7)
    end if
end if    

end function

protected function integer of_store_workbook ();long ll_i
n_xls_worksheet_v97 lnvo_sheet
//Ensure that at least one worksheet has been selected.
 if il_worksheetindex = 0 then
	 of_add_worksheet() 
 end if
  
 if ii_activesheet = 0 then
    lnvo_sheet = invo_worksheets[1]
    lnvo_sheet.ib_selected = true
 end if

//Calculate the number of selected worksheet tabs and call the finalization
// methods for each worksheet

for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]
    if lnvo_sheet.ib_selected then ii_selected ++
    lnvo_sheet.of_close()    
 next
 
 //Add Workbook globals
of_store_bof(5)  //0x0005
of_store_codepage()
of_store_window1()   
of_store_1904()   
of_store_all_fonts()   
of_store_all_num_formats()   
of_store_all_xfs()   
of_store_all_styles() 
of_store_palette()   
of_store_sst(il_datasize)
of_store_extsst()
of_calc_sheet_offsets()   
    
//Add BOUNDSHEET records
for ll_i = 1 to il_worksheetindex
    lnvo_sheet = invo_worksheets[ll_i]
    of_store_boundsheet(lnvo_sheet.ib_worksheetname, lnvo_sheet.il_offset)  
 next

of_store_externs()   
of_store_names()   

of_store_eof()    

return of_store_ole_file() //<---implement


end function

protected function int of_append(blob ABLB_HEADER, blob ABLB_DATA, blob ABLB_ADD_DATA);return of_append(ablb_header + ablb_data + ablb_add_data)
end function

protected function int of_append(blob ABLB_HEADER, blob ABLB_DATA);return of_append(ablb_header + ablb_data)
end function

protected function int of_append(blob ABLB_DATA);int li_ret = 1
if len(ablb_data) > iui_limit then
   ablb_data = of_add_continue(ablb_data)
end if
il_datasize += len(ablb_data)
invo_data.of_append(ablb_data)
return li_ret



end function

protected function blob of_add_continue(blob ABLB_DATA);uint lui_record = 60 //0x003C record identifier
blob lblb_header, lblb_temp
long ll_len   
    

lblb_temp = blobmid(ablb_data, 1, iui_limit)
ablb_data = blobmid(ablb_data, iui_limit + 1, len(ablb_data) - iui_limit)  
blobedit(lblb_temp, 3, invo_sub.of_pack('v', iui_limit - 4))
    
do while len(ablb_data) > iui_limit 
   lblb_header =  invo_sub.of_pack('v', lui_record) + &
                  invo_sub.of_pack('v', iui_limit)
   lblb_temp += lblb_header
   lblb_temp += blobmid(ablb_data, 1, iui_limit) 
   ablb_data = blobmid(ablb_data, iui_limit + 1, len(ablb_data) - iui_limit)  
loop
    
lblb_header =  invo_sub.of_pack('v', lui_record) + &
               invo_sub.of_pack('v', len(ablb_data))
lblb_temp += lblb_header
lblb_temp += ablb_data
    
return lblb_temp
end function

protected function int of_store_bof(int AI_TYPE);// Excel BOF record
// ai_type = 5 for workbook  
// ai_type = 61 for  worksheet 

uint li_record = 2057  //  0x0809  identifier
uint li_len = 16        //  0x0010  Number of bytes

uint li_build =  6319 //0x18AF;
uint li_year =   1997 //0x07CD
ulong ll_history_flag =   16449 //0x00004041  File history flags
ulong ll_lowest_version = 262   //0x00000106    //Lowest Excel version that can read all records in this file
blob lblb_header
blob lblb_data
    
lblb_header = invo_sub.of_pack('v', li_record) + &
              invo_sub.of_pack('v', li_len)
lblb_data =   invo_sub.of_pack('v', ii_biff_version) +&
              invo_sub.of_pack('v', ai_type) +&
              invo_sub.of_pack('v', li_build) +&
              invo_sub.of_pack('v', li_year) +&
              invo_sub.of_pack('V', ll_history_flag) +&
              invo_sub.of_pack('V', ll_lowest_version)
of_append(lblb_header + lblb_data)              

return 1
end function

protected function int of_store_codepage();uint li_record = 66 // 0x0042
uint li_length = 2  // 0x0002 
blob lblb_header
blob lblb_data    
integer li_ret
//The CODEPAGE record in BIFF8 always contains the code page 1200 (UTF-16, .2.3). Therefore it is not possible
//to obtain the encoding used for a protection password (it is not UTF-16).
lblb_header = invo_sub.of_pack('v', li_record) + &
              invo_sub.of_pack('v', li_length)
lblb_data = invo_sub.of_pack('v', 1200)
li_ret = of_append(lblb_header, lblb_data)

return li_ret

end function

protected function int of_store_supbook(); uint li_record = 430 // 0x01AE
uint li_length = 4  // 0x0004 
blob lblb_header
blob lblb_data    
integer li_ret

lblb_header = invo_sub.of_pack('v', li_record) + &
              invo_sub.of_pack('v', li_length)
lblb_data = invo_sub.of_pack('v', upperbound(ib_sheetnames)) +&
            invo_sub.of_pack('v', 1025) //0x0401
li_ret = of_append(lblb_header, lblb_data)
return li_ret

end function

protected function int of_store_externs();

of_store_supbook()
//Create EXTERNCOUNT with number of worksheets
//In BIFF8 this record is omitted because there
//occurs only one EXTERNSHEET record.
//of_store_externcount(li_cnt)   

//Create one EXTERNSHEET record
of_store_externsheet()  

return 1
end function

protected function int of_get_externs_size();
integer li_cnt
li_cnt = UpperBound(ib_sheetnames)
return 8 + 6 + 6 * li_cnt
end function

protected function integer of_store_names ();integer li_ret = 1
long ll_i
n_xls_worksheet_v97 lnvo_sheet
    
//Create the print area NAME records
for ll_i = 1 to il_worksheetindex
  lnvo_sheet = invo_worksheets[ll_i]
  //Write a Name record if the print area has been defined
  
  if not(isNull(lnvo_sheet.ii_print_rowmin)) then
     of_store_name_short( &
     ll_i - 1,                /* worksheet index*/&              
     6,                       /*0x06  NAME type*/&                
     lnvo_sheet.ii_print_rowmin, &
     lnvo_sheet.ii_print_rowmax, &
     lnvo_sheet.ii_print_colmin, &
     lnvo_sheet.ii_print_colmax)
  end if
next
        
//Create the print title NAME records
for ll_i = 1 to il_worksheetindex
  lnvo_sheet = invo_worksheets[ll_i]
  if Not(isNull(lnvo_sheet.ii_title_rowmin)) and &
     Not(isNull(lnvo_sheet.ii_title_colmin)) then
     of_store_name_long( &
       ll_i - 1, &
       7, &
       lnvo_sheet.ii_title_rowmin, &
       lnvo_sheet.ii_title_rowmax, &  
       lnvo_sheet.ii_title_colmin, &
       lnvo_sheet.ii_title_colmax)
  elseif Not(isNull(lnvo_sheet.ii_title_rowmin)) then
     of_store_name_short( &
       ll_i - 1, &
       7, &
       lnvo_sheet.ii_title_rowmin, &
       lnvo_sheet.ii_title_rowmax, &  
       0, &
       255)
  elseif Not(isNull(lnvo_sheet.ii_title_colmin)) then
     of_store_name_short( &
       ll_i - 1, &
       7, &
       0,           /*0x0000*/&      
       65535,       /*0xffff*/ &
       lnvo_sheet.ii_title_colmin, &
       lnvo_sheet.ii_title_colmax)
  else 
     //Print title hasn't been defined
  end if

next

return li_ret


end function

protected function integer of_get_names_size ();
integer li_ret = 0
long ll_i
n_xls_worksheet_v97 lnvo_sheet
    
//Get the size of print area NAME records
for ll_i = 1 to il_worksheetindex
  lnvo_sheet = invo_worksheets[ll_i]
  //Write a Name record if the print area has been defined
  if not(isNull(lnvo_sheet.ii_print_rowmin)) then li_ret += 31
next

//Create the print title NAME records
for ll_i = 1 to il_worksheetindex
  lnvo_sheet = invo_worksheets[ll_i]
  if Not(isNull(lnvo_sheet.ii_title_rowmin)) and &
     Not(isNull(lnvo_sheet.ii_title_colmin)) then
     li_ret += 46   
  elseif Not(isNull(lnvo_sheet.ii_title_rowmin)) then
     li_ret += 31
  elseif Not(isNull(lnvo_sheet.ii_title_colmin)) then
	  li_ret += 31
  else 
     //Print title hasn't been defined
  end if
next

return li_ret
end function

protected function integer of_store_window1 ();integer li_ret = 1
uint li_record   = 61  //0x003D record identifier
uint li_length   = 18  //0x0012 Number of bytes to follow

uint li_xWn      = 0      //0x0000 Horizontal position of window
uint li_yWn      = 0      //0x0000 Vertical position of window
uint li_dxWn     = 9660   //0x25BC Width of window
uint li_dyWn     = 5490   //0x1572 Height of window

uint li_grbit     = 56    //0x0038 Option flags
uint li_wTabRatio = 600   //0x0258 Tab to scrollbar ratio

blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack('v', li_record) + invo_sub.of_pack('v', li_length)

lblb_data =   invo_sub.of_pack('v', li_xWn) + &  
              invo_sub.of_pack('v', li_yWn) + &
              invo_sub.of_pack('v', li_dxWn) + &
              invo_sub.of_pack('v', li_dyWn) + &
              invo_sub.of_pack('v', li_grbit) + &
              invo_sub.of_pack('v', ii_activesheet) + &
              invo_sub.of_pack('v', ii_firstsheet) + &
              invo_sub.of_pack('v', ii_selected) + &
              invo_sub.of_pack('v', li_wTabRatio)
              
of_append(lblb_header, lblb_data)

return li_ret

end function

protected function int of_store_1904();uint li_record   = 34   //0x0022 record identifier
uint li_length   = 2    //0x0002 bytes to follow
integer li_ret 
blob lblb_header
blob lblb_data

lblb_header = invo_sub.of_pack('v', li_record) +&
              invo_sub.of_pack('v', li_length)

if ib_1904 then              
   lblb_data   = invo_sub.of_pack('v', 1)
else
   lblb_data   = invo_sub.of_pack('v', 0)
end if

li_ret = of_append(lblb_header, lblb_data)

return li_ret


end function

protected function int of_store_all_fonts();blob lb_font
string ls_key
string ls_font_keys[]
long ll_keys_cnt = 0
long ll_format_cnt
long ll_i
long ll_j
long ll_key
integer li_ret = 1
n_xls_format_v97 lnvo_format

 lb_font = invo_tmp_format.of_get_font()  
 //
 //
 //
 for ll_i = 1 to 5
     of_append(lb_font)          
 next
    
 ls_key = invo_tmp_format.of_get_font_key() 
 ll_keys_cnt ++
 ls_font_keys[ll_keys_cnt] = ls_key

 ll_format_cnt = UpperBound(invo_formats)     
 for ll_i = 1 to ll_format_cnt
     lnvo_format = invo_formats[ll_i]
     ls_key = lnvo_format.of_get_font_key() 
     ll_key = 0
     for ll_j = 1 to  ll_keys_cnt
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
     
     if ll_key > 1 then ll_key += 4 else ll_key = 0
     
     lnvo_format.ii_font_index = ll_key   
  next

return li_ret

end function

protected function boolean of_is_zero_started_number(string AS_STR);integer li_i, li_cnt
string ls_ch
 as_str = trim(as_str) 
 if right(as_str,1) = '0' then
    li_cnt = len(as_str) 
    if li_cnt < 2 then return false
    for li_i = 2 to li_cnt
        ls_ch = mid(as_str, li_i, 1)
        choose case ls_ch
          case '0','1','2','3','4','5','6','7','8','9'
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

protected function boolean of_is_number(string AS_STR);integer li_i, li_cnt
string ls_ch
 as_str = trim(as_str) 
 li_cnt = len(as_str) 
 if li_cnt < 1 then return false
 for li_i = 1 to li_cnt
   ls_ch = mid(as_str, li_i, 1)
   choose case ls_ch
     case '0','1','2','3','4','5','6','7','8','9'
       continue
     case else 
       return false
     end choose
 next
 return true

end function

protected function int of_store_all_num_formats();integer li_ret = 1
blob lb_formats[]
long ll_formats_cnt = 0
long ll_i
long ll_j
long ll_used_format
blob lb_format
int    li_format
n_xls_format_v97 invo_format

for ll_i = 1 to il_formatindex    
    
    invo_format = invo_formats[ll_i]
    lb_format = invo_format.ib_num_format
    li_format = invo_format.ii_num_format
    
    //Check if li_format is an index to a built-in format
    if (isNull(lb_format)) or (Len(lb_format) = 0) then continue
    
    ll_used_format = 0
    for ll_j = 1 to ll_formats_cnt
      if lb_formats[ll_j] = lb_format then
        // FORMAT has already been used
        ll_used_format = ll_j
        exit
      end if
    next
    
    if ll_used_format > 0 then
       invo_format.ii_num_format = ll_used_format + 164 - 1
    else
       ll_formats_cnt ++
       lb_formats[ll_formats_cnt] = lb_format
       invo_format.ii_num_format = ll_formats_cnt + 164 - 1
    end if
next

for ll_i = 1 to ll_formats_cnt
    of_store_num_format(lb_formats[ll_i], ll_i + 164 - 1);
next

return li_ret

end function

protected function integer of_store_num_format (blob ab_format, unsignedinteger ai_index);integer li_ret = 1
uint li_record = 1054 //0x041E
uint li_length 
uint li_len_format
blob lb_header
blob lb_data
int li_grbit = 1
int li_cch

li_cch = len(ab_format)/2
li_length  = 5 + li_cch * 2
lb_header = invo_sub.of_pack('v', li_record) + &
            invo_sub.of_pack('v', li_length)

lb_data = invo_sub.of_pack('v', ai_index) + &
          invo_sub.of_pack('v', li_cch) + &
          invo_sub.of_pack('C', li_grbit) + & 
          ab_format

of_append(lb_header, lb_data)   

return li_ret

end function

protected function integer of_store_all_xfs ();integer li_ret = 1
blob lb_xf
long ll_i    
n_xls_format_v97 lnvo_format
  
lb_xf = invo_tmp_format.of_get_xf('style')     
for ll_i = 1 to 15
    of_append(lb_xf)  
next  

//lb_xf = invo_tmp_format.of_get_xf('cell')     
//of_append(lb_xf)  

for ll_i = 1 to il_formatindex   
    lnvo_format = invo_formats[ll_i]
    lb_xf = lnvo_format.of_get_xf('cell')
    of_append(lb_xf)
next 

return li_ret

end function

protected function int of_store_all_styles();integer li_ret
li_ret = of_store_style()
return li_ret

end function

protected function int of_store_style();integer li_ret
uint li_record = 659    //0x0293
uint li_length = 4      //0x0004
uint li_ixfe   = 32768  //0x8000
integer li_BuiltIn = 0  //0x00
integer li_iLevel = 255 //0xff
blob lb_header
blob lb_data
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length)
lb_data   = invo_sub.of_pack('v', li_ixfe) +&
            invo_sub.of_pack('C', li_BuiltIn) +&
            invo_sub.of_pack('C', li_iLevel)
of_append(lb_header, lb_data)

return li_ret

end function

protected function int of_store_palette();integer li_ret = 1
uint li_record = 146     //0x0092
uint li_length

uint li_ccv
uint li_i

blob lb_header
blob lb_data
blob lb_data_item

li_ccv = UpperBound(ii_palette, 2)
li_length = 2 + 4 * li_ccv

for li_i = 1 to li_ccv
    lb_data_item = invo_sub.of_pack('C', ii_palette[1,li_i]) +&
                   invo_sub.of_pack('C', ii_palette[2,li_i]) +&
                   invo_sub.of_pack('C', ii_palette[3,li_i]) +&
                   invo_sub.of_pack('C', ii_palette[4,li_i])
    if li_i = 1 then
       lb_data = lb_data_item
    else
       lb_data += lb_data_item
    end if
next

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) +&
            invo_sub.of_pack('v', li_ccv) 

of_append(lb_header, lb_data)

return li_ret

end function

protected function integer of_calc_sheet_offsets ();integer li_ret = 1
integer li_BoundSheetHeader = 12
integer li_EOF = 4
ulong ll_offset
long ll_i
n_xls_worksheet_v97 lnvo_sheet

ll_offset = il_datasize

for ll_i = 1 to il_worksheetindex    
    lnvo_sheet = invo_worksheets[ll_i]
    ll_offset += li_BoundSheetHeader + len(lnvo_sheet.ib_worksheetname)    
next
ll_offset += of_get_externs_size()
ll_offset += of_get_names_size()
ll_offset += li_EOF

for ll_i = 1 to il_worksheetindex    
    lnvo_sheet = invo_worksheets[ll_i] 
    lnvo_sheet.il_offset = ll_offset
    ll_offset += lnvo_sheet.il_datasize  
next

il_biffsize = ll_offset

return li_ret

end function

protected function integer of_store_boundsheet (blob ab_sheetname, unsignedlong al_offset);integer li_ret = 1
uint li_record =  133       //0x0085
uint li_length       
uint li_grbit = 0   //0x0000 
uint li_cch

blob lb_header
blob lb_data

li_cch = len(ab_sheetname)/2
li_length = 8 + li_cch * 2

lb_header = invo_sub.of_pack('v', li_record) + &
            invo_sub.of_pack('v', li_length) 
lb_data =   invo_sub.of_pack('V', al_offset) + &
            invo_sub.of_pack('v', li_grbit) + &
            invo_sub.of_pack('C', li_cch) + &
            invo_sub.of_pack('C', 1) + &
				ab_sheetname 
of_append(lb_header, lb_data)

return li_ret

end function

protected function integer of_store_name_short (unsignedinteger ai_index, integer ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, integer ai_colmin, integer ai_colmax);integer li_ret = 1
uint    li_record          = 24  //0x0018   Record identifier
uint    li_length          = 27  //0x001B 
uint    li_grbit           = 32  //0x0020   Option flags
integer li_chKey           = 0   //0x00     Keyboard shortcut
integer li_cch             = 1   //0x01     Length of text name
uint    li_cce             = 11  //0x000B   Length of text definition
uint    li_ixals                 //ai_index + 1   Sheet index
uint    li_itab                  //Equal to ixals
integer li_cchCustMenu     = 0   //0x00     Length of cust menu text
integer li_cchDescription  = 0   //0x00     Length of description text
integer li_cchHelptopic    = 0   //0x00     Length of help topic text
integer li_cchStatustext   = 0   //0x00     Length of status bar text
integer li_rgch                  //ai_type  Built-in name type   

integer li_unknown03       = 59    //0x3B
uint    li_unknown04               // 65535 - ai_index

blob lb_header
blob lb_data


li_ixals = ai_index + 1
li_itab = li_ixals
li_rgch = ai_type
li_unknown04 = UpperBound(ib_sheetnames) - ai_index - 1

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length)
lb_data   = invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('C', li_chKey) +&
            invo_sub.of_pack('C', li_cch) +&
            invo_sub.of_pack('v', li_cce) +&
            invo_sub.of_pack('v', ai_index) +&
            invo_sub.of_pack('v', li_itab) +&
            invo_sub.of_pack('C', li_cchCustMenu) +&
            invo_sub.of_pack('C', li_cchDescription) +&
            invo_sub.of_pack('C', li_cchHelptopic) +&
            invo_sub.of_pack('C', li_cchStatustext) +&
            invo_sub.of_pack('C', 0) +&
            invo_sub.of_pack('C', li_rgch) +&
            invo_sub.of_pack('C', li_unknown03) +&
            invo_sub.of_pack('v', li_unknown04) +&
            invo_sub.of_pack('v', ai_rowmin) +&
            invo_sub.of_pack('v', ai_rowmax) +&
            invo_sub.of_pack('v', ai_colmin) +&
            invo_sub.of_pack('v', ai_colmax)
of_append(lb_header, lb_data)

return li_ret

end function

protected function int of_store_eof();int  li_ret = 1
uint li_record =  10   //0x000A Record identifier
uint li_length =   0   //0x0000 Number of bytes to follow
blob lb_header
lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 
of_append(lb_header)
return li_ret

end function

protected function integer of_store_externsheet ();
int  li_ret = 1
uint li_record =   23   //0x0017 Record identifier
uint li_length          // Number of bytes to follow
blob lb_header
blob lb_data

integer li_i, li_cnt

li_cnt = UpperBound(ib_sheetnames)
li_length = 2 + 6 * li_cnt

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length) 

lb_data   = invo_sub.of_pack('v', li_cnt)

for li_i = li_cnt - 1 to 0 step -1
    lb_data += invo_sub.of_pack('v', 0) +&
	            invo_sub.of_pack('v', li_i) +&
					invo_sub.of_pack('v', li_i) 
next	

of_append(lb_header + lb_data)


return li_ret

end function

protected function integer of_store_ole_file ();int li_ret = 1
int li_i 
OLEStream lstr_book

n_xls_worksheet_v97 lnvo_sheet
lstr_book = create OLEStream

li_ret = lstr_book.Open(istg_doc, "Workbook", stgWrite!)
if li_ret < 0 then li_ret = -1 else li_ret = 1

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

protected function integer of_store_name_long (unsignedinteger ai_index, unsignedinteger ai_type, unsignedinteger ai_rowmin, unsignedinteger ai_rowmax, unsignedinteger ai_colmin, unsignedinteger ai_colmax);integer li_ret = 1
uint    li_record          = 24  //0x0018   Record identifier
uint    li_length          = 42  //0x002A 
uint    li_grbit           = 32  //0x0020   Option flags
integer li_chKey           = 0   //0x00     Keyboard shortcut
integer li_cch             = 1   //0x01     Length of text name
uint    li_cce             = 26  //0x001A   Length of text definition
uint    li_ixals                 //ai_index + 1   Sheet index
uint    li_itab                  //Equal to ixals
integer li_cchCustMenu     = 0   //0x00     Length of cust menu text
integer li_cchDescription  = 0   //0x00     Length of description text
integer li_cchHelptopic    = 0   //0x00     Length of help topic text
integer li_cchStatustext   = 0   //0x00     Length of status bar text
integer li_rgch                  //ai_type  Built-in name type   

integer li_unknown03       = 41    //0x29
uint    li_unknown04       = 23    // 0x0017
integer li_unknown05       = 59    //0x3B

blob lb_header
blob lb_data
uint li_ext_ref

li_ixals = ai_index + 1
li_itab = li_ixals
li_rgch = ai_type

li_ext_ref = UpperBound(ib_sheetnames) - ai_index - 1

lb_header = invo_sub.of_pack('v', li_record) +&
            invo_sub.of_pack('v', li_length)
lb_data   = invo_sub.of_pack('v', li_grbit) +&
            invo_sub.of_pack('C', li_chKey) +&
            invo_sub.of_pack('C', li_cch) +&
            invo_sub.of_pack('v', li_cce) +&
            invo_sub.of_pack('v', ai_index) +&
            invo_sub.of_pack('v', li_itab) +&
            invo_sub.of_pack('C', li_cchCustMenu) +&
            invo_sub.of_pack('C', li_cchDescription) +&
            invo_sub.of_pack('C', li_cchHelptopic) +&
            invo_sub.of_pack('C', li_cchStatustext) +&
            invo_sub.of_pack('C', 0) +&
            invo_sub.of_pack('C', li_rgch) +&
				/*column deinition*/ &
            invo_sub.of_pack('C', li_unknown03) +&
            invo_sub.of_pack('v', li_unknown04) +&
            invo_sub.of_pack('C', li_unknown05) +&
            invo_sub.of_pack('v', li_ext_ref) +&
            invo_sub.of_pack('v', 0) +&
            invo_sub.of_pack('v', 65535) +&
            invo_sub.of_pack('v', ai_colmin) +&
            invo_sub.of_pack('v', ai_colmax) +&
				/*row deinition*/ &
            invo_sub.of_pack('C', li_unknown05) +&
            invo_sub.of_pack('v', li_ext_ref) +&
            invo_sub.of_pack('v', ai_rowmin) +& 
            invo_sub.of_pack('v', ai_rowmax) +& 
            invo_sub.of_pack('v', 0) +&
            invo_sub.of_pack('v', 255) +&
            invo_sub.of_pack('C', 16) 
				
of_append(lb_header, lb_data)

return li_ret


end function

public function int of_set_codepage(uint AUI_CODEPAGE);iui_codepage = aui_codepage
return 1
end function

public function int of_set_palette_xl97();ii_palette = {   0,   0,   0,   0,   /* 8*/ &  
               255, 255, 255,   0,   /* 9*/ &  
               255,   0,   0,   0,   /*10*/ &  
                 0, 255,   0,   0,   /*11*/ &  
                 0,   0, 255,   0,   /*12*/ &  
               255, 255,   0,   0,   /*13*/ &  
               255,   0, 255,   0,   /*14*/ &  
                 0, 255, 255,   0,   /*15*/ &  
               128,   0,   0,   0,   /*16*/ &  
                 0, 128,   0,   0,   /*17*/ &  
                 0,   0, 128,   0,   /*18*/ &  
               128, 128,   0,   0,   /*19*/ &  
               128,   0, 128,   0,   /*20*/ &  
                 0, 128, 128,   0,   /*21*/ &  
               192, 192, 192,   0,   /*22*/ &  
               128, 128, 128,   0,   /*23*/ &  
               153, 153, 255,   0,   /*24*/ &  
               153, 51,  102,   0,   /*25*/ &  
               255, 255, 204,   0,   /*26*/ &  
               204, 255, 255,   0,   /*27*/ &  
               102,   0, 102,   0,   /*28*/ &  
               255, 128, 128,   0,   /*29*/ &  
                 0, 102, 204,   0,   /*30*/ &  
               204, 204, 255,   0,   /*31*/ &  
                 0,   0, 128,   0,   /*32*/ &  
               255,   0, 255,   0,   /*33*/ &  
               255, 255,   0,   0,   /*34*/ &  
                 0, 255, 255,   0,   /*35*/ &  
               128,   0, 128,   0,   /*36*/ &  
               128,   0,   0,   0,   /*37*/ &  
                 0, 128, 128,   0,   /*38*/ &  
                 0,   0, 255,   0,   /*39*/ &  
                 0, 204, 255,   0,   /*40*/ &  
               204, 255, 255,   0,   /*41*/ &  
               204, 255, 204,   0,   /*42*/ &  
               255, 255, 153,   0,   /*43*/ &  
               153, 204, 255,   0,   /*44*/ &  
               255, 153, 204,   0,   /*45*/ &  
               204, 153, 255,   0,   /*46*/ &  
               255, 204, 153,   0,   /*47*/ &  
                51, 102, 255,   0,   /*48*/ &  
                51, 204, 204,   0,   /*49*/ &  
               153, 204,   0,   0,   /*50*/ &  
               255, 204,   0,   0,   /*51*/ &  
               255, 153,   0,   0,   /*52*/ &  
               255, 102,   0,   0,   /*53*/ &  
               102, 102, 153,   0,   /*54*/ &  
               150, 150, 150,   0,   /*55*/ &  
                 0,  51, 102,   0,   /*56*/ &  
                51, 153, 102,   0,   /*57*/ &  
                 0,  51,   0,   0,   /*58*/ &  
                51,  51,   0,   0,   /*59*/ &  
               153,  51,   0,   0,   /*60*/ &  
               153,  51, 102,   0,   /*61*/ &  
                51,  51, 153,   0,   /*62*/ &  
                51,  51,  51,   0}   /*63*/   
return 1
end function

protected function integer of_store_sst (unsignedlong al_offset);integer li_ret = 1
blob lblb_data
lblb_data = invo_sst.of_get_sst(al_offset)
il_datasize += len(lblb_data)
invo_data.of_append(lblb_data)
return li_ret
end function

protected function integer of_store_extsst ();integer li_ret = 1
blob lblb_data
lblb_data = invo_sst.of_get_extsst()

//--Tomikhin - 17.08.04
//il_datasize += len(lblb_data)
of_append(lblb_data)
//invo_data.of_append(lblb_data)
//--


return li_ret
end function

event constructor;call super::constructor;ii_biff_version = 1536 //$0600
invo_data = create n_xls_data
invo_sst = create n_cst_sst

end event

event destructor;call super::destructor;destroy invo_sst
end event

on n_xls_workbook_v97.create
TriggerEvent( this, "constructor" )
end on

on n_xls_workbook_v97.destroy
TriggerEvent( this, "destructor" )
end on

event ue_add_string;return invo_sst.of_add_string(as_value)
end event

event ue_add_unicode;return invo_sst.of_add_string(ab_string)
end event

