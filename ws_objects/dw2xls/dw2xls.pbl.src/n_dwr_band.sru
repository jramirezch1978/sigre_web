$PBExportHeader$n_dwr_band.sru
forward
global type n_dwr_band from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_band from nonvisualobject
end type
global n_dwr_band n_dwr_band

type variables
public boolean ib_variable_band_height = false
public long il_row_cnt
public string is_band_name
public int ii_band_type
public int ii_group_level
public boolean ib_newpage = false
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public boolean ib_enabled = true

//public datawindow idw_dw
private powerobject ipo_requestor
private object ipo_requestortype
private DataWindow idw_requestor
private DataStore ids_requestor
private DataWindowChild idwc_requestor

public int ii_fields_count = 0

public long il_groupchangerow = 1
public long il_dw_row_count
private int ii_band_height
public boolean ib_yield_enable = false
public boolean ib_cancel = false
public double id_x_coef
public double id_y_coef
public double id_conv

public n_dwr_grid invo_hgrid;
public n_dwr_grid invo_parent_hgrid
public long il_band_y = 0

public n_dwr_grid invo_vgrid;

public n_dwr_field invo_fields[];

public n_xls_workbook invo_writer;

public n_xls_worksheet invo_cur_sheet;

public n_dwr_service_parm invo_parm;

public n_dwr_colors invo_colors;
private n_cst_hash_long invo_row_in_detail 
public integer ii_rows_per_detail = 1
public integer ii_dw_processing
private boolean ib_has_reports = false
public long il_base_x = 0
public long il_base_y = 0
public boolean ib_nested = false


end variables

forward prototypes
public function integer of_dynamic_horisontal_layout (long al_row)
public function integer of_process_row (long al_row, long al_writer_row)
private function integer of_set_row_height (long al_writer_row)
public subroutine of_find_row_in_detail ()
public function integer of_init (string as_band_name, integer ai_band_type, integer ai_group_level, boolean ab_newpage, n_dwr_grid anvo_vgrid)
public function integer of_check_process_row (long al_row, long al_writer_row, boolean ab_newpage)
public function string of_describe (readonly string as_expr)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_add_field (string as_name)
public function integer of_register (powerobject apo_requestor, n_xls_workbook anvo_writer, n_xls_worksheet anvo_sheet, n_dwr_service_parm anvo_parm, n_dwr_colors anvo_colors, integer ai_rows_per_detail, long al_base_x, long al_base_y)
private function integer of_sort_fields ()
end prototypes

public function integer of_dynamic_horisontal_layout (long al_row);integer li_ret = 1
integer li_i
//invo_hgrid = create n_dwr_grid
//invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv

if ib_variable_band_height and ii_band_type = 3 then
   ii_band_height = integer(of_describe("evaluate('rowheight()'," + string(al_row) + ')'))
else
   ii_band_height = integer(of_describe('datawindow.' + is_band_name + '.height'))
end if

if ii_band_height > 0 then
   if invo_parm.ib_keep_band_height then
      il_ysplit_ind_from = invo_hgrid.of_add_split(il_base_y + 0)
      il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)

	/*bug fix 15.04.2004*/	
	elseif (ii_dw_processing = 1) and (ib_variable_band_height) then  
		il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)
	/*bug fixed 15.04.2004*/	
   end if
	
   if ii_fields_count > 0 then
       for li_i = 1 to ii_fields_count
			 if invo_fields[li_i].ii_dwo_type = n_dwr_field.DT_REPORT then
				 continue
			 //bug fix 24.11.2003
		    elseif invo_fields[li_i].of_get_y1() <= (il_base_y + ii_band_height + invo_hgrid.ii_round_ratio) then 
             invo_fields[li_i].il_ysplit_ind_from = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y1(al_row) )
  			    //bug fix 17.03.2004
				 /*if (invo_fields[li_i].of_get_y2(al_row) >= il_base_y + ii_band_height - 10) and (integer(idw_dw.describe ( 'Datawindow.Processing' )) = 1) then*/
				 if (ii_dw_processing = 1) and (ib_variable_band_height) and ii_band_type = 3 then  //15.04.2004
	             invo_fields[li_i].il_ysplit_ind_to = il_ysplit_ind_to
  		       else
	             invo_fields[li_i].il_ysplit_ind_to = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y2(al_row) )
				 end if
  			    //bug fixed 17.03.2004
          end if
			 //bug fixed 24.11.2003
       next
   end if
//  il_row_cnt = invo_hgrid.of_get_split_count() - 1
//   if il_row_cnt < 0 then il_row_cnt = 0
end if

return li_ret

end function

public function integer of_process_row (long al_row, long al_writer_row);integer li_i
integer li_ret = 1
integer li_res = 1
long ll_band_row
integer li_merge_row
long ll_band_col
integer li_merge_col
any la_val
time lt_time
datetime ldt_dtime
date ld_date

long ll_nested_rows = 0, ll_nested_ret, ll_current_hsplit_values[]
boolean lb_row_height_set = false

if ib_variable_band_height Or ib_has_reports Or ib_nested then
	invo_hgrid = create n_dwr_grid
	invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv
	if ib_nested then
		invo_parent_hgrid.of_get_split_values(&
		  ll_current_hsplit_values[], &
		  il_band_y &
		)
		invo_hgrid.of_add_splits(&
			ll_current_hsplit_values[], &
			0 &
		)
   end if
   li_ret = of_dynamic_horisontal_layout(al_row)
end if

// for nested with 0 rows: skip invalid summary and footer
If al_row = 0 and il_dw_row_count = 0 And ib_nested Then
	Return il_row_cnt
End If


if ib_has_reports then
	for li_i = 1 to ii_fields_count
		if invo_fields[li_i].ii_dwo_type = n_dwr_field.DT_REPORT then
			ll_nested_ret = invo_fields[li_i].of_process_nested(al_row, al_writer_row, invo_hgrid)
			if ll_nested_ret > ll_nested_rows then
				ll_nested_rows = ll_nested_ret
			end if
			continue
		end if
	next
end if

il_row_cnt = 0 
for li_i = 1 to ii_fields_count
	if invo_fields[li_i].ii_dwo_type = n_dwr_field.DT_REPORT then
		continue
	end if
	//check visible
	if invo_fields[li_i].of_get_visible(al_row) <> 1 then continue
	
	//-- 10.09.2004 - recalculation size object for each row
	invo_fields[li_i].il_xsplit_ind_from = invo_vgrid.of_add_split( invo_fields[li_i].of_get_x1(al_row))
	invo_fields[li_i].il_xsplit_ind_to = invo_vgrid.of_add_split( invo_fields[li_i].of_get_x2(al_row) )
	//--
//	if ib_has_reports then
//		invo_fields[li_i].il_ysplit_ind_from = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y1())
//		invo_fields[li_i].il_ysplit_ind_to = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y2())
//	end if
	li_res = invo_vgrid.of_get_pos(invo_fields[li_i].il_xsplit_ind_from, invo_fields[li_i].il_xsplit_ind_to, ll_band_col, li_merge_col)
	if li_res <> 1 then continue
	li_res = invo_hgrid.of_get_pos(invo_fields[li_i].il_ysplit_ind_from, invo_fields[li_i].il_ysplit_ind_to, ll_band_row, li_merge_row)
	if li_res <> 1 then continue
	if il_row_cnt < ll_band_row + li_merge_row then
		il_row_cnt = ll_band_row + li_merge_row
	end if
 
	la_val = invo_fields[li_i].of_getvalue(al_row)   
	
	if ((li_merge_col > 0) or (li_merge_row > 0)) and invo_parm.ib_enable_merge_cells then
		CHOOSE CASE ClassName(la_val)
			CASE "integer", "decimal", "double", "number","real"
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  double(la_val), invo_fields[li_i].of_get_format(al_row))
			CASE "string","char"
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  string(la_val), invo_fields[li_i].of_get_format(al_row))
			CASE "date"
				  ld_date = la_val	  
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  ld_date, invo_fields[li_i].of_get_format(al_row))
			CASE "datetime"
				  ldt_dtime = la_val	  
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  ldt_dtime, invo_fields[li_i].of_get_format(al_row))
			CASE "time"
				  lt_time = la_val
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  lt_time, invo_fields[li_i].of_get_format(al_row))
			CASE ELSE
				  invo_cur_sheet.of_merge_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, &
														  al_writer_row + ll_band_row - 1 + li_merge_row, ll_band_col - 1 + li_merge_col, & 
														  invo_fields[li_i].of_get_format(al_row))
				
		END CHOOSE
	else
		CHOOSE CASE ClassName(la_val)
			CASE "integer", "decimal", "double", "number","real"
				  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, double(la_val), invo_fields[li_i].of_get_format(al_row))
			CASE "string","char"
				  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, string(la_val), invo_fields[li_i].of_get_format(al_row))
			CASE "date"
			  ld_date = la_val	  
			  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, ld_date, invo_fields[li_i].of_get_format(al_row))
			CASE "datetime"
			  ldt_dtime = la_val	  
			  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, ldt_dtime, invo_fields[li_i].of_get_format(al_row))
			CASE "time"
			  lt_time = la_val
			  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, lt_time, invo_fields[li_i].of_get_format(al_row))
			case else
			  invo_cur_sheet.of_write(al_writer_row + ll_band_row - 1, ll_band_col - 1, invo_fields[li_i].of_get_format(al_row))
				
		END CHOOSE
	end if
	if ib_yield_enable then 
	  Yield()
	end if
	if ib_cancel then
	  li_ret = -1
	  exit
	end if
next

if il_row_cnt < ll_nested_rows then
	il_row_cnt = ll_nested_rows
end if

if not ib_nested and not lb_row_height_set then
	if li_ret = 1 then
		of_set_row_height(al_writer_row)
		lb_row_height_set = true
	end if
end if

return il_row_cnt

end function

private function integer of_set_row_height (long al_writer_row);long  ll_i
integer li_ret = 1
for ll_i = 1 to il_row_cnt
   invo_cur_sheet.of_set_row_height(al_writer_row + ll_i - 1, &
   invo_hgrid.of_get_col_width(ll_i) / id_y_coef )
next

return li_ret



end function

public subroutine of_find_row_in_detail ();string ls_syntax
long ll_pos, ll_pos_end
long ll_start_pos = 1
string ls_column
string ls_name, ls_row_in_detail
integer li_row_in_detail
ls_syntax = of_describe("Datawindow.Syntax")
invo_row_in_detail = create n_cst_hash_long

do while ll_start_pos >= 0
  ll_pos = pos(ls_syntax, '~r~ncolumn(', ll_start_pos)
  if ll_pos > 0 then
     ll_pos_end = pos(ls_syntax, '~r~n', ll_pos + 7)
     if ll_pos_end > 0 then 
        ll_start_pos = ll_pos_end - 2 
     else 
        ll_start_pos = -1
        ll_pos_end = Len(ls_syntax) + 1
     end if
     ls_column = mid(ls_syntax, ll_pos, ll_pos_end - ll_pos)
     //find name
     ll_pos = pos(ls_column, 'name=')
     if ll_pos > 0 then
        ll_pos_end = pos(ls_column, ' ', ll_pos + 5)
        if ll_pos_end > 0 then
           ls_name = mid(ls_column, ll_pos + 5, ll_pos_end - ll_pos - 5)
           ll_pos = pos(ls_column, 'row_in_detail=')
           if ll_pos > 0 then
              ll_pos_end = pos(ls_column, ' ', ll_pos + 14)
              if ll_pos_end > 0 then
                 ls_row_in_detail = mid(ls_column, ll_pos + 14, ll_pos_end - ll_pos - 14)
                 li_row_in_detail = integer(ls_row_in_detail) 
                 invo_row_in_detail.of_set_value(ls_name, li_row_in_detail)
            end if
          end if
        end if
     end if
  else
     ll_start_pos = -1
  end if 
loop

end subroutine

public function integer of_init (string as_band_name, integer ai_band_type, integer ai_group_level, boolean ab_newpage, n_dwr_grid anvo_vgrid);integer li_ret = 1
boolean lb_vgrid_def = false

is_band_name = as_band_name
ii_band_type = ai_band_type
ii_group_level = ai_group_level
ib_newpage = ab_newpage

if ii_band_type = 3 /*Or ib_nested */then ib_variable_band_height = true

/*15.04.2004 added*/
ii_dw_processing = integer(of_describe ( 'Datawindow.Processing' ))
/*15.04.2004*/

if Not(isNull(ANVO_VGRID)) then
   if isValid(ANVO_VGRID) then lb_vgrid_def = true 
end if

if lb_vgrid_def then
   invo_vgrid = anvo_vgrid
else
   invo_vgrid = create n_dwr_grid
   invo_vgrid.ii_round_ratio = invo_vgrid.ii_round_init_ratio * id_conv
end if

if (ai_band_type = 3) and (ii_rows_per_detail > 1) then
	of_find_row_in_detail()
end if

if not(ib_variable_band_height) then
    invo_hgrid = create n_dwr_grid
    invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv
    
    ii_band_height = integer(of_describe('datawindow.' + is_band_name + '.height'))
    if ii_band_height > 0 then
       ib_enabled = true
       if invo_parm.ib_keep_band_height then
           il_ysplit_ind_from = invo_hgrid.of_add_split(0)
           il_ysplit_ind_to = invo_hgrid.of_add_split(ii_band_height)
       end if
       
       il_row_cnt = invo_hgrid.of_get_split_count() - 1
       
       if il_row_cnt < 0 then il_row_cnt = 0
       ib_enabled = true
    else
      ib_enabled = false
    end if
else
    ib_enabled = true
end if

of_sort_fields()

return li_ret

end function

public function integer of_check_process_row (long al_row, long al_writer_row, boolean ab_newpage);integer li_processed_row = 0
if not(ib_enabled) and not(ii_band_type=2 or ii_band_type = 3) then return 0

choose case ii_band_type
   case 1 //header
     //if (al_row = 1) or ((ab_newpage) and invo_parm.ib_group_pageheader) then
     if (al_row = 1) or ((ab_newpage) and invo_parm.ib_group_pageheader) then
        li_processed_row = of_process_row(al_row, al_writer_row)
     end if
   case 2 //group.header
     if ((al_row = il_groupchangerow) and (il_dw_row_count > 0)) or (ab_newpage) then
		  if ib_enabled then li_processed_row = of_process_row(al_row, al_writer_row)
		  if ((al_row = il_groupchangerow) and (il_dw_row_count > 0)) then
				Choose Case ipo_requestortype 
					Case DataWindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataStore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataWindowChild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case Else
						Return -1
				End Choose  
		  end if
     end if
   case 3 //detail
     if al_row <=  il_dw_row_count then
        li_processed_row = of_process_row(al_row, al_writer_row)
     end if
   case 4 //group.trailer
//  	  integer li_log
//	  string ls_line	 
//     li_log = FileOpen('c:\dw2xls.log', LineMode!, Write!, Shared!, Append!)
//     ls_line = 'Row=' + string(al_row) + ';Lev=' + string(ii_group_level) + ';RowCnt=' + string(il_dw_row_count) + ';il_GrChRow=' + string(il_groupchangerow) + ';' 
//     if al_row = il_groupchangerow then
//        ls_line +='GrCh=true;'
//        if al_row > 1 then
//            ls_line +='Proc=true;'
//            li_processed_row = of_process_row(al_row - 1, al_writer_row)
//        else
//            ls_line +='Proc=false;'
//       end if
//        il_groupchangerow = idw_dw.findgroupchange(il_groupchangerow + 1, ii_group_level)
//        if il_groupchangerow <= 0 then il_groupchangerow = il_dw_row_count + 1
//		  ls_line +='il_GrChNew=' + string(il_groupchangerow) + ';'
//     else
//        ls_line +='GrCh=false;'
//     end if
//	  
//  	  FileWrite(li_log, ls_line)
//	  FileClose(li_log)	 
		
     if (al_row = il_groupchangerow) or (ab_newpage) then	
		  if (al_row > 1) and (ib_enabled) then
            li_processed_row = of_process_row(al_row - 1, al_writer_row)
        end if
		//-- 06.09.2004
			if invo_parm.ib_group_pagebreak then
		      if (al_row > 1) and (al_row < il_dw_row_count) and (ab_newpage) then invo_cur_sheet.of_add_h_pagebreak(al_writer_row + li_processed_row)
			end if
		//-- 
		  
		  if al_row = il_groupchangerow then
				Choose Case ipo_requestortype 
					Case DataWindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataStore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataWindowChild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case Else
						Return 0
				End Choose  
	        if il_groupchangerow <= 0 then il_groupchangerow = il_dw_row_count + 1
   	  end if
		  
     end if
	  
   case 5 //summary
     if al_row =  (il_dw_row_count + 1) then
        li_processed_row = of_process_row(al_row - 1, al_writer_row)
     end if
	  
   case 6 //footer
     if ((al_row =  (il_dw_row_count + 1)) or (ab_newpage)) then
        li_processed_row = of_process_row(al_row - 1, al_writer_row)
     end if
end choose


return li_processed_row

end function

public function string of_describe (readonly string as_expr);Choose Case ipo_requestortype 
	Case DataWindow!
		Return idw_requestor.describe(as_expr)
	Case DataStore!
		Return ids_requestor.describe(as_expr)
	Case DataWindowChild!
		Return idwc_requestor.describe(as_expr)
	Case Else
		Return "!"
End Choose   

end function

public function integer of_register_dynamic (powerobject apo_requestor);ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.RowCount()
	Case DataStore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.RowCount()
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.RowCount()
	Case Else
		Return -1
End Choose  

Long li_i
For li_i = 1 To ii_fields_count
	invo_fields[li_i].of_register_dynamic (ipo_requestor)
Next

Return 1
end function

public function integer of_add_field (string as_name);string ls_field_class
string ls_coltype
integer li_ret = 1
integer li_row_in_detail
n_dwr_field lnvo_field
if not(ib_enabled) then return 1

if of_describe(as_name + '.visible') = '0' then return 1

ls_field_class = of_describe(as_name + '.type')
choose case ls_field_class
     case 'datawindow'
        li_ret = -1
     case 'bitmap'
        //to do 
        li_ret = -1
     case 'button'
        li_ret = -1
     case 'column'
        lnvo_field = create n_dwr_field
        lnvo_field.of_register(ipo_requestor, invo_writer, invo_colors, il_base_x, il_base_y)
        lnvo_field.of_init(as_name, n_dwr_field.DT_COLUMN)
     case 'compute'
        lnvo_field = create n_dwr_field
        lnvo_field.of_register(ipo_requestor, invo_writer, invo_colors, il_base_x, il_base_y)
        lnvo_field.of_init(as_name, n_dwr_field.DT_COMPUTE)
     case 'graph'
        li_ret = -1
     case 'groupbox'
        li_ret = -1
     case 'line'
        //to do 
        li_ret = -1
     case 'ole'
        li_ret = -1
     case 'ellipse'
        li_ret = -1
     case 'rectangle'
        //to do 
        li_ret = -1
     case 'report'
			if invo_parm.ib_nested then
				lnvo_field = create n_dwr_field
				lnvo_field.of_register(ipo_requestor, invo_writer, invo_colors, il_base_x, il_base_y)
				lnvo_field.of_init(as_name, n_dwr_field.DT_REPORT)
				  
				n_dwr_nested_service_parm lnvo_nested_parm
				lnvo_nested_parm = Create n_dwr_nested_service_parm
				lnvo_nested_parm.invo_global_vgrid = invo_vgrid
				lnvo_nested_parm.invo_cur_sheet = invo_cur_sheet
				lnvo_nested_parm.invo_colors = invo_colors
				li_ret = lnvo_field.of_CreateNestedService(lnvo_nested_parm, invo_parm)
				ib_has_reports = TRUE
			else
				li_ret = -1
			end if
	  case 'roundrectangle'
        li_ret = -1
     case 'tableblob'
        li_ret = -1
     case 'text'
        lnvo_field = create n_dwr_field
        lnvo_field.of_register(ipo_requestor, invo_writer, invo_colors, il_base_x, il_base_y)
        lnvo_field.of_init(as_name, n_dwr_field.DT_TEXT)
end choose

if li_ret = 1 And Not IsNull(invo_hgrid) And IsValid(invo_hgrid) then
	if lnvo_field.of_get_x2() - lnvo_field.of_get_x1() < invo_hgrid.ii_round_ratio then li_ret = -1
end if

if li_ret = 1 then
   if not(ib_variable_band_height) then
      if lnvo_field.of_get_band_y1() > (ii_band_height + invo_hgrid.ii_round_ratio) then li_ret = -1
      if li_ret = 1 then
         ii_fields_count ++
         invo_fields[ ii_fields_count ] = lnvo_field
         lnvo_field.il_xsplit_ind_from = invo_vgrid.of_add_split( lnvo_field.of_get_x1() )
         lnvo_field.il_xsplit_ind_to = invo_vgrid.of_add_split( lnvo_field.of_get_x2() )

         lnvo_field.il_ysplit_ind_from = invo_hgrid.of_add_split( lnvo_field.of_get_y1() )
         lnvo_field.il_ysplit_ind_to = invo_hgrid.of_add_split( lnvo_field.of_get_y2() )

         il_row_cnt = invo_hgrid.of_get_split_count() - 1
         if il_row_cnt < 0 then il_row_cnt = 0
      end if
   else
      ii_fields_count ++
      invo_fields[ ii_fields_count ] = lnvo_field
      lnvo_field.il_xsplit_ind_from = invo_vgrid.of_add_split( lnvo_field.of_get_x1() )
      lnvo_field.il_xsplit_ind_to = invo_vgrid.of_add_split( lnvo_field.of_get_x2() )
 
   end if
end if

if li_ret = 1 then
   if (ii_band_type = 3) and (ii_rows_per_detail > 1) then
		li_row_in_detail = invo_row_in_detail.of_get_value(as_name)
		if li_row_in_detail > 0 then
			lnvo_field.ii_row_in_detail = li_row_in_detail
		end if	
   end if 	
end if
	

return li_ret
end function

public function integer of_register (powerobject apo_requestor, n_xls_workbook anvo_writer, n_xls_worksheet anvo_sheet, n_dwr_service_parm anvo_parm, n_dwr_colors anvo_colors, integer ai_rows_per_detail, long al_base_x, long al_base_y);//idw_dw = adw_dw
il_base_x = al_base_x
il_base_y = al_base_y
ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.RowCount()
	Case DataStore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.RowCount()
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.RowCount()
	Case Else
		Return -1
End Choose  

invo_writer = anvo_writer
invo_cur_sheet = anvo_sheet
invo_parm = anvo_parm
invo_colors = anvo_colors
ii_rows_per_detail = ai_rows_per_detail
return 1
end function

private function integer of_sort_fields ();n_dwr_field lnv_col[]
n_dwr_field lnv_rep[]
int li_field, li_fieldn, li_base
For li_field = 1 To ii_fields_count
	If invo_fields[li_field].ii_dwo_type = n_dwr_field.DT_REPORT Then
		lnv_rep[UpperBound(lnv_rep[]) + 1] = invo_fields[li_field]
	Else
		lnv_rep[UpperBound(lnv_col[]) + 1] = invo_fields[li_field]
	End If
Next
li_fieldn = UpperBound(lnv_col[])
For li_field = 1 To li_fieldn
	invo_fields[li_field] = lnv_col[li_field]
Next
li_base = li_fieldn
li_fieldn = UpperBound(lnv_rep[])
For li_field = 1 To li_fieldn
	invo_fields[li_base + li_field] = lnv_rep[li_field]
Next
Return 1
end function

on n_dwr_band.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_band.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

