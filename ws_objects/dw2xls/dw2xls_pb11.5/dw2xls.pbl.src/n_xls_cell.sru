$PBExportHeader$n_xls_cell.sru
forward
global type n_xls_cell from nonvisualobject
end type
end forward

global type n_xls_cell from nonvisualobject
end type
global n_xls_cell n_xls_cell

type variables
PUBLIC   BOOLEAN             ib_Empty =True 
PUBLIC 	UInt    				  Row
PUBLIC	Uint    				  Col
PUBLIC   UINT					  EndRow
public   uint 					  EndCol 
Public	uint                ii_xf  
PUBLIC	String  				  is_Value
PUBLIC	String              is_CellType ='S' 
pUBLIC 	n_xls_Format        invo_Format 
PUBLIC 	n_xls_WorkSheet     invo_WorkSheet 


end variables

forward prototypes
public function integer of_getdata (ref blob ab_data)
public function blob of_getformatonly (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col)
end prototypes

public function integer of_getdata (ref blob ab_data);integer li_ret = 1
ulong ll_sst_index

double ld_val
DateTime  ldt_dateTime 
time lt_time
integer li_hour
integer li_minute
integer li_second
Integer li_Pos 
Blob lb_unicode_value 



IF ii_xf<=0 Then
	ii_xf =invo_WorkSheet.invo_WorkBook.OF_Reg_Format(invo_Format)  //of_xf(ai_row, ai_col, lnvo_format)
	ii_xf=ii_xf +14       //加14 可能是因为在workbook的of_store_xfs中,有15个style类型格式
				    		    //具体原因需要进一步分析
END IF
						
				 
IF is_Value="" OR IsNull(is_Value) Then
	  ab_data = invo_WorkSheet.invo_sub.of_pack("v", row -1) + invo_WorkSheet.invo_sub.of_pack("v", col -1 ) + invo_WorkSheet.invo_sub.of_pack("v", ii_xf) 
     Return  li_ret
END IF 
	  
is_CellType=Upper(Trim(is_CellType)) 
IF is_CellType='S' Then
	  
	  
	  lb_unicode_value=invo_WorkSheet.invo_sub.to_unicode(invo_WorkSheet.invo_sub.of_str2xls(is_Value))
	  if isnull(lb_unicode_value) then	
	      lb_unicode_value = blob("")
     end if
     ll_sst_index = invo_WorkSheet.invo_workbook.event ue_add_unicode(lb_unicode_value)
     ab_data = invo_WorkSheet.invo_sub.of_pack("v", row -1 ) + invo_WorkSheet.invo_sub.of_pack("v", col  -1) + invo_WorkSheet.invo_sub.of_pack("v", ii_xf) + invo_WorkSheet.invo_sub.of_pack("V", ll_sst_index)
	  li_ret=2
	
ELSE
	    //IF row=10 and (col=9 or col=16) then
	   //	setprofilestring("ng.ini","database",string(col),is_value+"   "+string(ii_xf,"0000")+"   "+invo_format.of_get_format_key())
      //end if 
		
		IF is_CellType='N' Then
			
				ld_val=Double(is_Value) 
			
		ELSEIF is_CellType='DT' Then
	         
				//2004-11-17 
				//ldt_dateTime=DateTime(Blob(is_Value))       // 这条语句在pb6.5版本不能正常计算
				 //lt_time = time(ldt_dateTime)
				
				li_Pos=Pos(is_Value," ") 
				IF li_Pos>0 Then
					lt_Time=Time(Mid(is_Value ,li_Pos+1))
					is_Value = Left( is_Value ,li_Pos -1) 
				ELSE
					lt_Time=Time("00:00:00")
				END IF
				
				IF Not IsDate(is_Value) Then
					is_Value="1900-01-01"
				END IF
				
				li_hour = hour(lt_time)
				li_minute = minute(lt_time)
				li_second = second(lt_time)
				ld_val = daysafter(date("1899-12-30"), date(is_Value)) + (li_second + li_minute * 60 + li_hour * 3600) / ( 24 * 3600 ) 
	 

        ELSEIF is_CellType='D' Then
					ld_val = daysafter(date("1899-12-30"), Date(is_Value) )   //1899-12-30 是1900/01/01的前两天
		
	      ELSEIF is_CellType='T' Then 
				   lt_time = time(is_Value)
					li_hour = hour(lt_time)
					li_minute = minute(lt_time)
					li_second = second(lt_time)
					ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (  24 * 3600) 
   	    END IF 
				
			ab_data = invo_WorkSheet.invo_sub.of_pack("v", row -1 ) + invo_WorkSheet.invo_sub.of_pack("v", col -1 ) + invo_WorkSheet.invo_sub.of_pack("v", ii_xf) + invo_WorkSheet.invo_sub.of_pack("d",ld_val )
			li_ret=3 
END IF 
	

return li_ret



end function

public function blob of_getformatonly (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col);Return invo_WorkSheet.invo_sub.of_pack("v", ai_row -1) + invo_WorkSheet.invo_sub.of_pack("v", ai_col -1 ) + invo_WorkSheet.invo_sub.of_pack("v", ii_xf) 

end function

on n_xls_cell.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_cell.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_Format=Create n_xls_Format
end event

event destructor;Destroy invo_Format
end event

