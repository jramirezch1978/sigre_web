$PBExportHeader$n_cst_dw2excel_grid.sru
forward
global type n_cst_dw2excel_grid from nonvisualobject
end type
end forward

global type n_cst_dw2excel_grid from nonvisualobject autoinstantiate
end type

type prototypes
Function Long RegisterF1() Library "ttf16.ocx" Alias For 'DllRegisterServer'
end prototypes

type variables
//Private:
	//用于连接F1
 OLEObject	xlapp
 OLEObject 	i_CellFormat 
 Datastore  ids_Column
 DataStore  ids_Objects
 datawindow      idw_Requestor       //数据窗口对象
 String is_OldBand
 Int    ii_MaxCol
 Int    ii_ColHeaderRow ,ii_DetailRow
 Boolean  ib_GridBorder
 Boolean  ib_OpenExcel =False    //在导出完成之后,是否提示用户打开Excel文件
 String   is_TipsWindow="w_tips"
 string   is_OpenParm

end variables

forward prototypes
private function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[])
public function integer of_dw2excel (datawindow adw, string as_filename)
public subroutine of_getobjects ()
protected function integer of_outdata (long ai_currow, string as_band, long ai_row)
public subroutine of_setgridborder (boolean ab_flag)
protected function string of_getdata (long ai_row, string as_objectname)
public function integer of_groupcount ()
public function string of_replaceall (string as_string1, string as_string2, string as_string3)
public subroutine of_openexcelfile (boolean ab_flag)
public function long of_outdata_detail (long ai_currow)
end prototypes

private function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ParseToArray
//
//	Access:  public
//
//	Arguments:
//	as_Source   The string to parse.
//	as_Delimiter   The delimeter string.
//	as_Array[]   The array to be filled with the parsed strings, passed by reference.
//
//	Returns:  long
//	The number of elements in the array.
//	If as_Source or as_Delimeter is NULL, function returns NULL.
//
//	Description:  Parse a string into array elements using a delimeter string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.02   Fixed problem when delimiter is last character of string.

//	   Ref array and return code gave incorrect results.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright ?1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long		ll_DelLen, ll_Pos, ll_Count, ll_Start, ll_Length
string 	ls_holder

//Check for NULL
IF IsNull(as_source) or IsNull(as_delimiter) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

//Check for at leat one entry
If Trim (as_source) = '' Then
	Return 0
End If

//Get the length of the delimeter
ll_DelLen = Len(as_Delimiter)

ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter))

//Only one entry was found
if ll_Pos = 0 then
	as_Array[1] = as_source
	return 1
end if

//More than one entry was found - loop to get all of them
ll_Count = 0
ll_Start = 1
Do While ll_Pos > 0
	
	//Set current entry
	ll_Length = ll_Pos - ll_Start
	ls_holder = Mid (as_source, ll_start, ll_length)

	// Update array and counter
	ll_Count ++
	as_Array[ll_Count] = ls_holder
	
	//Set the new starting position
	ll_Start = ll_Pos + ll_DelLen

	ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter), ll_Start)
Loop

//Set last entry
ls_holder = Mid (as_source, ll_start, Len (as_source))

// Update array and counter if necessary
if Len (ls_holder) > 0 then
	ll_count++
	as_Array[ll_Count] = ls_holder
end if

//Return the number of entries found
Return ll_Count

end function

public function integer of_dw2excel (datawindow adw, string as_filename);

Long li,lj,lk, li_row, li_col
long li_width,li_Height,li_alignment
Long li_CurRow,li_Count
Int li_GroupCount
string  ls_fontsize,ls_units
Boolean lb_TrailerFlag
Window lw 

IF Not IsValid(adw) THEN
	MessageBox("提示","数据窗口未指定或数据窗口已被关闭!",stopsign!)
	Return  -1
END IF
idw_Requestor=adw

//没有数据需要输出
IF idw_Requestor.RowCount()=0 Then 
	MessageBox("提示","报表没有数据,不能另存为Excel文件!",StopSign!)
	Return 0
END IF


//如果文件已存在,则先删除它,不然,EXCEL会显示提示信息
If FileExists (as_filename ) Then
  IF MessageBox("提示","文件 "+ as_filename+" 已经存在,是否继续?",Question!,YesNo!)=2 Then
	  Return 0
  ELSE  
		FileDelete(as_filename)
	END IF
END IF	

//检查给定的文件路径是否可以写入
li_row=FileOpen(as_filename+".tmp", StreamMode!,Write!,LockWrite!,Replace!)
FileClose(li_row)
filedelete(as_filename+".tmp")

IF li_row=-1  OR IsNull(li_row) THEN
	MessageBox("提示","指定的文件路径不能写入数据,请检查!",StopSign!)
	Return 0
END IF
	


xlApp = Create OLEObject


//  通过ole连接excel
li_row= xlApp.ConnectToNewObject("TTF161.F1BookView")

//尝试自注册ocx控件
IF li_row < 0  Then
	IF FileExists("ttf16.ocx") THen
		RegisterF1()
	END IF 
	li_row= xlApp.ConnectToNewObject("TTF161.F1BookView")
END IF

IF li_Row<0 Then
	MessageBox("提示","不能连接Formula One 控件,请检查系统是否已安装或已注册该控件!",StopSign!)
   Return -1
END IF

SetPointer(HourGlass! )
IF  Trim(is_TipsWindow)<>"" Then
	OpenWithParm(lw,is_OpenParm, is_TipsWindow)
END IF
SetPointer (HourGlass! )

i_CellFormat = Create OLEObject
i_CellFormat=xlApp.CreateNewCellFormat()


//读取对象列表并计算分组数目
idw_Requestor.AcceptText()
li_GroupCount=OF_GroupCount() 
IF li_GroupCount>0 Then
	idw_Requestor.GroupCalc()
END IF
OF_GetObjects()

/*----------------------------------- 以上代码屏蔽,否则如果系统安装了某些hp的打印机驱动的话，会导致writeex执行失败------------------*/
//OleObject objF1PageSetup
//objF1PageSetup=xlApp.GetPageSetup()
//objF1PageSetup.GridLines=False      //不打印表格线
//objF1PageSetup.BlackAndWhite=True   //单色打印
//objF1PageSetup.PaperSize=Integer(idw_Requestor.Describe("datawindow.print.page.size"))   //纸张大小
//objF1PageSetup.Header=""            //页眉
//
//objF1PageSetup.Footer=""            //页脚
//objF1PageSetup.RowHeadings=False    //不打印行号
//objF1PageSetup.TopMargin=Round(Long(idw_Requestor.Describe("datawindow.print.Margin.Top"))/384,2)        //上边界   注意,单位是英寸
//objF1PageSetup.BottomMargin=Round(Long(idw_Requestor.Describe("datawindow.print.Margin.Bottom"))/384,2)     //下边界
//objF1PageSetup.LeftMargin=Round(Long(idw_Requestor.Describe("datawindow.print.Margin.Left"))/384,2)
//objF1PageSetup.RightMargin=Round(Long(idw_Requestor.Describe("datawindow.print.Margin.Right"))/384,2)
//objF1PageSetup.HeaderMargin=0    //页眉的高度
//objF1PageSetup.FooterMargin=0 
//
//xlApp.SetPageSetup(objF1PageSetup) 
//Destroy objF1PageSetup 
/*----------------------------------------------------------------------------------------------------------------*/


//取得数据窗口的单位类型,不同的类型计算列宽的公式不同

ls_units=idw_Requestor.Describe("datawindow.units")
li_Height=long(idw_Requestor.Describe("datawindow.detail.height"))
Choose Case ls_units   //换算成 pb units
		
	Case "0"
		 
	Case "1"
		 li_Height *=4
	Case "2"
	    li_Height = (li_Height/0.26) *100
   Case "3"
      li_Height = (li_Height/0.66) *100
END Choose

//细节区有多少行
li_Row=Long(ids_Column.Describe("Evaluate('Max(EndRow)',1)"))
IF li_Row>1 Then
	li_Height=li_Height /li_Row
END IF

//设置默认的行高和列宽
xlApp.SetRowHeight(1,xlApp.MaxRow,li_Height*4,TRUE)
xlApp.SetColWidth(1,xlApp.MaxCol,4000,TRUE)
xlApp.VAlign=2

//设置细节区各列的列宽及文本格式

For li=1 To ids_Column.RowCount()
	  
	   li_col=ids_Column.Object.StartCol[li]
	   IF li_col>0 AND li>1 Then
		   IF ids_Column.Find("StartCol="+String(li_Col),1,li -1)>0 Then
				 Continue
			END IF
		END IF
		
		
	    xlApp.SetSelection(-1,li_col,-1,li_col)   //选择整列
		 //li_Width=long(idw_Requestor.Describe(ids_Column.Object.Name[li]+".width"))
		 li_Width=ids_Column.Object.Width[li]
		 
		 Choose Case ls_units
	            Case "0"   //?PowerBuilder units
						 li_width=UnitsToPixels(li_Width,XUnitsToPixels!)*0.026*1000
					 Case "1"   //Display pixels
				   
					    li_width=li_Width *0.026 *1000
					 Case "2"   //1/1000 of a logical inch
					     li_width=li_Width *2.54 
						
					  Case "3"  //1/1000 of a logical centimeter
			END CHOOSE
			IF li_Width<=0  Then
				li_Width=1000
			END IF
			
			xlApp.ColWidth[li_Col] =li_width *1.5
		 	xlApp.FontName=idw_Requestor.Describe(ids_Column.Object.Name[li]+".font.face")  //字体名称
			xlApp.FontColor=idw_Requestor.Describe(ids_Column.Object.Name[li]+".Color")
			ls_fontsize=idw_Requestor.Describe(ids_Column.Object.Name[li]+".font.height") //字体大小
			
			
			IF Mid(ls_fontsize,1,1)="-" Then
				ls_fontsize=Mid(ls_fontsize,2)
			END IF
			IF long(ls_fontsize)>0 Then
				  xlapp.FontSize=Long(ls_fontsize)
			END IF
			
			IF idw_Requestor.Describe(ids_Column.Object.Name[li]+".font.weight")="700" Then //是否粗体
				 xlApp.FontBold=True
			ELSE
				xlApp.FontBold=False
			END IF
			
			 IF idw_Requestor.Describe(ids_Column.Object.Name[li]+".font.italic")="1" Then //是否斜体
				 xlApp.FontItalic=TRUE
			ELSE
				xlApp.FontItalic=False
			END IF
				
			xlApp.Valign=2   //垂直对齐方式 居中
			li_alignment=long(idw_Requestor.Describe(ids_Column.Object.Name[li]+".alignment"))  //水平对齐方式
			
			Choose Case li_alignment 
					 
					Case 0    //左对齐
						xlApp.Halign=2
					
					Case 1   //右对齐
						xlApp.Halign=4
						
					Case 2   //中对齐
						xlApp.Halign=3
					
					 Case 3    //均匀对齐,调整为左对齐
						xlApp.Halign=6
					  
			END CHOOSE
			
			//格式
			IF ids_Column.Object.Format[li]<>"" Then
				xlApp.NumberFormat=ids_Column.Object.Format[li]
			END IF
			
NEXT 	




//输出数据
//输出表头区
li_CurRow=Of_OutData(0,"header",1)


//IF li_CurRow>0  Then   //设置标题行-----------------该设置不能正确反映到Excel文件中
//    	xlApp.PrintTitles="A1:"+xlApp.FormatRCNR(li_CurRow,256,False)
//END IF


//如果数据窗口没有分组,则调用OF_OutData_Detail函数,将可以提高转出到Excel的效率

IF li_GroupCount<=0 Then
	li_CurRow+=Of_OutData_Detail(li_CurRow)
ELSE
	
		li_Count=idw_Requestor.RowCount()
		FOR li_Row=1 To li_Count
			
			   lb_TrailerFlag=False
			  FOR lj=1 To li_GroupCount 
					 IF idw_Requestor.FindGroupChange(li_Row,lj)=li_Row Then    //分组的开始
							IF li_Row<>1 AND Not lb_TrailerFlag Then       //第一次,不用输出组的尾区
										 //组尾区的显示顺序,与组头区是倒过来的
										 lb_TrailerFlag=True 
										 For lk=li_GroupCount TO lj Step -1
											IF Long(idw_Requestor.Describe("datawindow.trailer."+String(lk)+".height"))>0 Then
												li_CurRow+=Of_OutData(li_CurRow,"trailer."+string(lk),li_Row -1)
											END IF
										Next
							END IF
							
							IF Long(idw_Requestor.Describe("datawindow.header."+String(lj)+".height"))>0 Then
								li_CurRow+=Of_OutData(li_CurRow,"header."+string(lj),li_Row )
							END IF
					 END IF
				NEXT
			  //输出当前记录
			  li_CurRow+=Of_OutData(li_CurRow,"detail",li_Row)
		NEXT 
END IF
	
//输出所有组的最后一组脚尾区

FOR lj=li_GroupCount To 1 Step -1 

   li_CurRow+=Of_OutData(li_CurRow,"trailer."+string(lj),idw_Requestor.RowCount())
NEXT 	

//输出汇总区
li_CurRow+=of_outdata(li_CurRow,"summary",idw_Requestor.rowcount())

//设置边线
IF ii_ColHeaderRow<=0 Then
	ii_ColHeaderRow=ii_DetailRow
END IF

IF ib_GridBOrder Then
	xlApp.SetSelection(ii_ColHeaderRow,1,li_CurRow,ii_MaxCol)
   xlApp.SetBorder(-1,1,1,1,1,0,-1,0,0,0,0)
	
	//不显示表格线
	xlApp.ShowGridLines=False
END IF

xlApp.WriteEx(as_filename,11)   //生成excel文件
xlApp.DisConnectObject()


IF isvalid(lw) Then
	Close(lw)
END IF

IF ib_OpenExcel Then
	IF MessageBox("提示","~r~n报表已成功导出到< "+as_FIleNAME+" >!~r~n~r~n~r~n你是否需要现在就打开这个Excel文件?~r~n~r~n",Question!,YesNo!,2)=1 Then
			li_row= xlApp.ConnectToNewObject( "Excel.Sheet" )
			IF li_row < 0  Then
				MessageBox("提示","不能运行Excel程序,请检查是否已安装Microsoft Excel软件!")
			 ELSE
				  XlApp.Application.Workbooks.Open(as_FileName)
				 xlApp.Application.ActiveWindow.WindowState= -4137   //最大化窗口
				 xlApp.Application.Visible = True
				 xlApp.DisConnectObject()

			 END IF
	 END IF
ELSE
    MessageBox("提示","报表已成功导出!文件路径为："+as_FIleNAME+"")
END IF


Destroy xlapp
Destroy i_CellFormat 
Destroy ids_Column
Destroy ids_Objects 



Return 1
end function

public subroutine of_getobjects ();IF Not IsValid(idw_Requestor) Then
	Return
END IF

String ls_Type,ls_Band
String ls_Objects[]   //,ls_BandName[]
String ls_Processing
String ls_Format,ls_ColType
int li,lj, lk,li_Row,li_Col, li_count
Long li_x,li_Y,li_x2, li_Height
Int li_ColCount 
Boolean lb_Flag 
Datastore lds_Temp


IF Not IsValid(idw_Requestor) Then
	 Return
END IF




SetPointer(HourGlass!)
ls_Processing=idw_Requestor.Describe("datawindow.Processing")
IF ls_Processing="4" Then
	idw_Requestor.Modify("DataWindow.Crosstab.StaticMode=Yes")
END IF

ls_Type=idw_Requestor.Describe("datawindow.objects")
li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)
ls_Type=""


lds_Temp=Create DataStore
lds_Temp.DataObject=idw_Requestor.DataObject 


ids_Column=Create Datastore
ids_Objects=Create DataStore
ids_Column.Dataobject="d_dw2xls_objects"
ids_objects.Dataobject="d_dw2xls_objects"


For li=1 To li_Count
	  
	  ls_Type=idw_Requestor.Describe(ls_Objects[li]+".Type")
	  
	  IF ls_Type<>"text" AND ls_Type<>"column" AND ls_Type<>"compute" Then
		  Continue
	  END IF
	
	  
	  
	  ls_Band=idw_Requestor.Describe(ls_Objects[li]+".Band")
	  IF ls_Band="?" OR ls_Band="!" Then
		  Continue
	  END IF
	  
	  
	  
	  
	  IF ls_Objects[li]="sys_back" AND ls_Band="foreground" Then   //报表标题的背景文本框
		  Continue
	  END IF
	  
	   IF ls_Objects[li]="sys_lastcol" AND ls_Band="detail" Then  //用于标识Grid形式报表的最后一列
			 Continue
		END IF
		
		
	  IF ls_Band="foreground" Then
		  ls_Band="header"
	  END IF
	  
	 
 	  
	 
	  //如果对象的Visible属性为False,不输出
	  IF idw_Requestor.Describe(ls_Objects[li]+".Visible")='0' Then
		  //如果数据窗口是否表格,而且对象在细节区,则需要把该列的其它对象给屏蔽掉
		   IF ls_Processing="1" AND ls_Band="detail" Then
						li_x=Long( lds_Temp.Describe(ls_Objects[li]+".x"))
						li_x2=li_x+Long( lds_Temp.Describe(ls_Objects[li]+".width"))
						 For lj=1 To li_Count
							  IF idw_Requestor.Describe(ls_Objects[lj]+".Band")<>"detail" Then
									  IF Long(lds_Temp.Describe(ls_Objects[lj]+".x"))>=li_x AND &
										  (Long(lds_Temp.Describe(ls_Objects[lj]+".x"))+Long(lds_Temp.Describe(ls_Objects[lj]+".Width")))<=li_x2 Then
										  
										  idw_Requestor.Modify(ls_Objects[lj]+".visible='0' ")
											 
										  li_Row=ids_Objects.Find("name='"+ls_Objects[lj]+"'",1,ids_Objects.RowCount())
										  IF li_Row>0 Then
												ids_Objects.DeleteRow(li_Row)
										  END IF
									END IF
							 END IF
								
						Next 
			END IF
			
			Continue
	  END IF
	
	
	
	  //如果带区的高度为0,不读入对象
	  li_Height=Long(idw_Requestor.Describe("datawindow."+ls_band+".height"))
	  IF li_Height<=10 Then
		   COntinue
	  END IF
	
	  //如果对象的Y值大于带区高度,也不读入
	  IF Long(idw_Requestor.Describe(ls_Objects[li]+".height"))> li_Height Then
		   Continue
	  END IF
	
	  ls_Format=Trim(idw_Requestor.Describe(ls_Objects[li]+".Format"))
	  IF ls_Format="?" Or ls_Format="!" OR Pos(ls_Format,"[")>0 OR Pos(ls_Format,"(")>0 OR Pos(ls_Format,"~t")>0 Then
		  ls_Format=""
	  END IF
		
		ls_ColType=idw_Requestor.Describe(ls_Objects[li]+".ColType")
		IF ls_ColType="?" OR ls_ColType="!" Then
			ls_ColType=""
		ELSE
			IF Left(ls_ColType,4)="char" Then
				ls_ColType="char"
				ls_Format=""
			END if
		END IF
	  
		IF ls_Band="detail" Then  
		  li_Row=ids_Column.InsertRow(0)
		  ids_Column.Object.Name[li_Row]=ls_Objects[li]
		  ids_Column.Object.Band[li_Row]=ls_Band
		  ids_Column.Object.Stype[li_Row]=ls_Type
		  ids_Column.Object.Coltype[li_Row]=ls_ColType
		  ids_Column.Object.Format[li_Row]=ls_Format
		  ids_Column.Object.X[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".x"))
	     ids_Column.Object.Y[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Y"))
		  ids_Column.Object.Width[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Width"))
	     ids_Column.Object.Height[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Height"))

     ELSE
	 		  li_Row=ids_Objects.InsertRow(0)
			  ids_Objects.Object.Name[li_Row]=ls_Objects[li]
			  ids_Objects.Object.Band[li_Row]=ls_Band
			  ids_Objects.Object.Stype[li_Row]=ls_Type
			  ids_Objects.Object.Coltype[li_Row]=ls_ColType
			  ids_Objects.Object.Format[li_Row]=ls_Format
			  ids_Objects.Object.X[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".x"))
			  ids_Objects.Object.Width[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Width"))
			  ids_Objects.Object.Y[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Y"))
			  ids_Objects.Object.Height[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Height"))
		END IF
Next 	

ids_Column.SetSort("x a , y A " )
ids_Column.Sort()
li_ColCount=ids_Column.RowCount()

IF li_ColCount>0 Then
		IF ls_Processing="1" Then
			For li=1 To li_ColCount
				ids_Column.Object.StartCol[li]=li 
				ids_Column.Object.EndCol[li]=li 
				ids_Column.Object.StartRow[li]=1 
				ids_Column.Object.EndRow[li]=1 
			Next
		ELSE
			
			 ids_Column.Object.StartCol[1]=1
			 ids_Column.Object.EndCol[1]=1
			 ids_Column.Object.StartRow[1]=1
			 ids_Column.Object.EndRow[1]=1
			 
			 
			 For li=2 To li_ColCount
				   //对象在垂直允许有点不对齐
				   li_Row=ids_Column.Find("(y+30) >= "+String(ids_Column.Object.Y[li])+" AND Y2<="+String(ids_Column.Object.Y2[li]+30) ,li -1 ,1)
					IF li_Row>0 Then
						 ids_Column.Object.StartCol[li]=ids_Column.Object.StartCol[li_Row]+1
						 ids_Column.Object.EndCol[li]= ids_Column.Object.StartCol[li]
						 ids_Column.Object.StartRow[li]= ids_Column.Object.StartRow[li_Row]
						 ids_Column.Object.EndRow[li]= ids_Column.Object.StartRow[li]
						 
						 //找到开始列
						 li_Row=ids_Column.Find(" x<="+String(ids_Column.Object.x[li]),li - 1 ,1)
						 IF li_Row>0 Then
							 	 ids_Column.Object.StartCol[li]=ids_Column.Object.EndCol[li_Row]+1
						       ids_Column.Object.EndCol[li]= ids_Column.Object.StartCol[li]
						END IF
					
						 
					ELSE
						
							li_Row=ids_Column.Find("y2<="+String(ids_Column.Object.Y[li]),li -1,1)
							IF li_Row<=0 Then
								li_Row=1
							END IF
							
							 ids_Column.Object.StartRow[li]= ids_Column.Object.StartRow[li_Row]+1
							 ids_Column.Object.EndRow[li]= ids_Column.Object.StartRow[li]
							 
							 li_Row=ids_Column.Find("x2<="+String(ids_Column.Object.x[li]),li -1,1)
							 IF li_Row>0 Then
								 ids_Column.Object.StartCol[li]=ids_Column.Object.EndCol[li_Row]+1
						    ELSE
								ids_Column.Object.StartCol[li]=1
							 END IF
							ids_Column.Object.EndCol[li]= ids_Column.Object.StartCol[li]
			
					END IF
			 Next
	END IF 
END IF


ids_Objects.SetSort(" x A  ")  //如果同一列有多个对象,则按上下位置排序
ids_Objects.Sort() 

ids_Column.SetSort("x A ")
ids_Column.Sort()

ii_MaxCol=Long(ids_Column.Describe("Evaluate('Max(EndCol)',1)"))

//判断对象在第几列
li_Count=ids_Objects.RowCount()
For li=1 To li_Count
   
	 IF ids_Objects.Object.Name[li]="report_title" Then
		 ids_Objects.Object.StartCol[li]=1
		 ids_Objects.Object.EndCol[li]=ii_MaxCol
		 Continue 
	 END IF
	
	 //如果是列标题,则保证与列对齐
	 lb_Flag=False
	 IF Left(ids_Objects.Object.Band[li],6)="header" AND Right(ids_Objects.Object.Name[li],2)="_t" Then
		 li_Row=ids_Column.Find("name='"+Left(ids_Objects.Object.Name[li],Len(String(ids_Objects.Object.Name[li])) -2)+"'",1,ids_Column.RowCount())
		 IF li_Row>0 Then
				 lb_Flag=True
				 ids_Objects.Object.StartCol[li]=ids_Column.Object.StartCol[li_Row]
				 ids_Objects.Object.EndCol[li]= ids_Objects.Object.StartCol[li] 
		 END IF
	 END IF
	 
	 //如果不是列标题,则根据对象的位置进行处理
	 IF Not lb_Flag Then
			 li_Row=ids_Column.Find("x2<="+String(ids_Objects.Object.x[li]),ids_Column.RowCount(),1)
			 IF li_Row>0 Then
				  ids_Objects.Object.StartCol[li]=ids_Column.Object.EndCol[li_Row]+1
				  ids_Objects.Object.EndCol[li]= ids_Objects.Object.StartCol[li] 
			 ELSE
				  ids_Objects.Object.StartCol[li]=1
				  ids_Objects.Object.EndCol[li]= ids_Objects.Object.StartCol[li] 
			 END IF
			 
			 //找到对象的结束列
			li_Row=ids_Column.Find("x>"+string(ids_Objects.Object.x2[li]) ,1,ids_Column.RowCount())
			if li_Row>1 then
				//li_Row=li_Row -1 
				ids_Objects.Object.EndCol[li]=ids_Column.Object.StartCol[li_Row] -1
				IF ids_Objects.Object.EndCol[li]<ids_Objects.Object.StartCol[li] Then
					ids_Objects.Object.EndCol[li]=ids_Objects.Object.StartCol[li]
				END IF
			ELSE
					li_Row=ids_Column.Find("x<="+string(ids_Objects.Object.x2[li]) ,ids_Column.RowCount(),1)
					IF li_Row>0 Then
						ids_Objects.Object.EndCol[li]=ids_Column.Object.EndCol[li_Row] 
						IF ids_Objects.Object.EndCol[li]<ids_Objects.Object.StartCol[li] Then
							ids_Objects.Object.EndCol[li]=ids_Objects.Object.StartCol[li]
						END IF
					END IF
			end if
		   
		   
		
	  END IF
		
	
		
Next 

//判断对象在第几行
ids_Objects.SetSort("y A ")  //如果同一列有多个对象,则按上下位置排序
ids_Objects.Sort() 
li_Count=ids_Objects.RowCount()
For li=1 To li_Count
	
 		//找到对象的开始行
		li_Row=ids_Objects.Find("y2<="+String(ids_Objects.Object.y[li])+" AND Band='"+ids_Objects.Object.Band[li]+"'",li -1 ,1 )
		IF li_Row>0 Then
			ids_Objects.Object.StartRow[li]=ids_Objects.Object.EndRow[li_Row] +1
			ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li]
		END IF
	   
		//找到对象的结束行
		li_Row=ids_Objects.Find("y>"+String(ids_Objects.Object.y2[li])+" AND Band='"+ids_Objects.Object.Band[li]+"'",1 ,lds_Temp.RowCount())
		IF li_Row>0 Then
			ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li_Row] -1
			IF ids_Objects.Object.EndRow[li]<ids_Objects.Object.StartRow[li] Then
				ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li]
			END IF
		END IF
Next 

//如果是交叉报表,需要进一步进行处理
IF ls_Processing="4" Then
	
	lb_Flag=False
	ids_Objects.SetFilter("band='header[1]' or band='header' ")   //加Header是因为有些对象在 foreGround
	ids_Objects.Filter()
	For li_Row=1 TO ids_Objects.RowCount()
		 
		IF ids_Objects.Object.Band[li_Row]="header" Then   //是否有定义了带区在ForeGround的对象
			 lb_Flag=True
			 Continue
		END IF
		
		ids_Objects.Object.Band[li_Row]="header"
		
	Next
	
	//计算出标题的行数
	IF lb_Flag Then
	     ii_ColHeaderRow=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
	END IF
	ii_ColHeaderRow=ii_ColHeaderRow+1
	
	li_Count=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
	li_Y=Long(idw_Requestor.Describe("datawindow.header[1].height"))
	li=2
	
	ls_Band="header["+String(li)+"]"
	Do While idw_Requestor.Describe("datawindow."+ls_Band+".height")<>"!"
		ids_Objects.SetFilter("band='"+ls_Band+"'")
		ids_Objects.Filter()
		For li_Row=1 TO ids_Objects.RowCount()
			 ids_Objects.Object.Band[li_Row]="header"
			 ids_Objects.Object.Y[li_Row]= ids_Objects.Object.Y[li_Row]+li_Y
			 ids_Objects.Object.StartRow[li_Row]=ids_Objects.Object.StartRow[li_Row]+li_Count
			 ids_Objects.Object.EndRow[li_Row]=ids_Objects.Object.EndRow[li_Row]+li_Count
		Next
		li++
		ls_Band="header["+String(li)+"]"
		li_Y+=Long(idw_Requestor.Describe("datawindow.header[1].height"))
		li_Count=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
	Loop
	
	ids_Objects.SetFilter("left(band,6)='header'")
	ids_Objects.Filter()
END IF





//li_ColCount=OF_ParseToArray(idw_Requestor.Describe("datawindow.bands"),"~t",ls_BandName)
//ids_Objects.SetSort(" x A , y A , x2 A ")
//
//For li=1 TO li_ColCount
//		 IF ls_BandName[li]="detail" Then
//			  Continue
//		 ELSEIF ls_BandName[li]="header[1]" Then
//			 ls_BandName[li]="header"
//		 ELSEIF Pos(ls_BandName[li],"header[")>0 Then
//			 Continue
//		 END IF
//		 
//		 ids_Objects.SetFilter("Band='"+ls_BandName[li]+"'")
//		 ids_Objects.Filter()
//		 ids_Objects.Sort()
//		 
//		 li_Count=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
//		 
//		  For lj=1 To ids_Objects.RowCount()
//				
//					li_Col=ids_Objects.Object.StartCol[lj]
//					IF ids_Objects.Object.EndRow[lj]<li_Count Then
//						  li_Row=ids_Objects.Find(" startcol<="+String(li_Col)+" and endcol>="+String(li_Col) +"and "+&
//														 " StartRow>"+string(ids_Objects.Object.EndRow[lj]),1,ids_Objects.RowCount())
//					
//						       IF  li_Row>0 Then
//									   li_Row=ids_Objects.Object.StartRow[li_Row]
//									   IF li_Row>0 Then
//												 ids_Objects.Object.EndRow[lj]=li_Row -1
//												 
//										 END IF
//									ELSE
//										 ids_Objects.Object.EndRow[lj]=li_Count
//								  END IF
//						ELSE
//									 li_Row=ids_Objects.Find(" startcol<="+String(li_Col)+" and endcol>="+String(li_Col) +" and "+&
//																	" EndRow<"+string(ids_Objects.Object.StartRow[lj]),1,ids_Objects.RowCount())
//																  
//									 IF li_Row>0 Then
//											 li_Row=ids_Objects.Object.EndRow[li_Row]
//											 IF li_Row>1 Then
//													 ids_Objects.Object.StartRow[lj]=li_Row -1
//											 END IF
//									ELSE
//											 ids_Objects.Object.StartRow[lj]=1
//									END IF
//					
//						END IF
//		Next
//Next
//ii_GroupCount=(ii_GroupCount -4)/2	
		 

//以下代码是避免不同的对象,同时写入Excel的同一单元
ids_Objects.SetSort("startcol A,StartRow A ")
ids_Objects.Sort() 
li_Count=ids_Objects.RowCount()
For li=2 To li_Count
	 IF ids_Objects.Object.Name[li]="report_title" OR Right(ids_Objects.Object.Name[li],2)="_t" Then
		 Continue
	 END IF
	 
	 li_Row=ids_Objects.Find("band='"+ids_objects.object.band[li]+"' and "+& 
	                         "startrow<="+String(ids_Objects.Object.StartRow[li])+ " and "+ &
	                         "endrow>="+String(ids_Objects.Object.EndRow[li])+" AND " + &
									 "endcol>="+String(ids_Objects.Object.StartCol[li]),li -1 ,1 )
	 IF li_Row>0 Then
		  IF ids_Objects.Object.EndCol[li]>ids_Objects.Object.EndCol[li_Row] Then
			  ids_Objects.Object.StartCol[li]=ids_Objects.Object.EndCol[li_Row]+1
		  ELSEIF ids_Objects.Object.StartCol[li]>ids_Objects.Object.StartCol[li_Row] Then
			   ids_Objects.Object.EndCol[li_Row]=ids_Objects.Object.StartCol[li] -1
		  END IF
		  	  
		 // MessageBox('a',string(ids_Objects.object.name[li]+"  "+ids_objects.object.name[li_row]) )
	 
	END IF
Next 



ids_Column.RowsCopy(1,ids_Column.RowCount(),Primary!,ids_Objects,1,Primary!)
ids_Objects.SetSort("StartRow A ,startcol A")
ids_Objects.Sort() 
ids_Column.SetSort(" StartCol A, StartRow A")
ids_Column.Sort() 

IF ls_Processing="4" OR ls_Processing="1" Then
	ib_GridBorder=True
END IF



Destroy lds_Temp 
SetPointer(Arrow!)


end subroutine

protected function integer of_outdata (long ai_currow, string as_band, long ai_row);/*-------------------------------------------------
    在EXCEL表中写入数据
	 
	 ai_CurRow      数据要写入到EXCEL中的行号
	 as_band        要转出那个带区的对象
	 aai_CurRow     要转出的数据窗口中那个行的记录
	 
	 
返回值：   在EXCEL中写入多少行数据
----------------------------------------------------------------------*/
Long   li_outlines
String ls_Value, ls_Name,ls_Type
Int li,lj,li_Count
Int li_StartRow,li_StartCol,li_EndRow,li_EndCol
Int li_CurRow
Int li_FontSize


IF is_OldBand<>as_Band Then
	ids_Objects.SetFilter("band='"+as_Band+"'")
   ids_Objects.Filter()
	is_OldBand=as_Band
	ids_Objects.Sort() 
END IF


li_Count=ids_Objects.RowCount()
FOR li=1 To li_Count   //{a}
	   ls_Name=ids_Objects.Object.Name[li]
		ls_Type=ids_Objects.Object.Stype[li]
    	li_StartRow=ids_Objects.Object.StartRow[li]
		li_StartCol=ids_Objects.Object.StartCol[li]
		li_EndRow=ids_Objects.Object.EndRow[li]
		li_EndCol=ids_Objects.Object.EndCol[li]

		IF li_StartRow<=0  OR li_StartCol<=0   OR li_StartCol>256 Then Continue   //行列没定义不输出 ,如果列大于256,也不输出,因为F1最多只支持256列
 	    
		 //需要检查参数,避免超出F1的范围
		  
	  
		//输出多少行数据
		IF li_EndRow >li_outlines THEN
			li_outlines=li_EndRow
		END IF
		
	   li_CurRow=li_StartRow+ai_CurRow
		xlApp.SetActiveCell(li_CurRow,li_StartCol)
		
		IF  ls_Type="compute" OR ls_Type="column" Then   //{b}
			ls_value=Of_GetData(ai_row,ls_Name)
			IF IsNull(ls_value) OR ls_Value="" Then
				Continue
			END IF
			
			IF ids_Objects.Object.ColType[li]="char" Then
				 xlApp.TextRC[li_CurRow,li_StartCol]=ls_value
			ELSE
		   	xlApp.EntryRC[li_CurRow,li_StartCol]=ls_value
			END IF
			
		ELSE
		   xlApp.TextRC[li_CurRow,li_StartCol]=idw_Requestor.Describe(ls_Name+".text")
		END IF                                                            //{b}
		
		  IF ii_ColHeaderRow<=0 Then
				  IF as_Band="header" AND Right(ls_Name,2)="_t"  Then
					  ii_ColHeaderRow=li_CurRow
				  END IF
		  END IF
		
		  
		  
	     IF as_Band="detail" AND ii_DetailRow<=0  Then
			   ii_DetailRow=li_CurRow
		  END IF
		
		  
				
		 IF as_band<>"detail" Then  
			  
		    IF li_StartRow<>li_EndRow OR li_StartCol<>li_EndCol Then  //合并单元
		         xlApp.SetSelection(li_CurRow,li_StartCol,li_EndRow+ai_CurRow,li_EndCol)
					i_CellFormat.Mergecells=True
                xlApp.SetCellFormat(i_CellFormat)
				END IF
				
				//如果输出的是报表标题，则设置行高
				IF ls_Name="report_title" Then
				   xlApp.SetRowHeight(li_CurRow,li_CurRow,800,False)
				END IF
				
				
		      //字体名称大小
				xlApp.Fontname=idw_Requestor.Describe(ls_Name+".font.face")
				
				li_FontSize=Abs(Long(idw_Requestor.Describe(ls_Name+".font.height")))
				IF li_FontSize>0 Then
					xlApp.FontSize=li_FontSize
				END IF
				
				
				xlApp.FontColor=Long(idw_Requestor.Describe(ls_Name+".color"))
				//xlApp.SetPattern(1,Long(idw_Requestor.Describe(is_object[i].name+".background.color")),Long(idw_Requestor.Describe(is_object[i].name+".background.color")))
			   xlApp.NumberFormatLocal=ids_Objects.Object.Format[li]
				
				
				//是否斜体
				IF idw_Requestor.Describe(ls_Name+".font.weight")="700" Then
			    	 xlApp.FontBold=True
			   ELSE
				     xlApp.FontBold=False
			   END IF
           
			   //是否斜体
			  IF idw_Requestor.Describe(ls_Name+".font.italic")="1" Then
				   xlApp.FontItalic=True
			  ELSE
			       xlApp.FontItalic=False
 			  END IF
			
			  //水平对齐方式
				  Choose Case idw_Requestor.describe(ls_Name+".alignment")
					 
				  Case "0"    //左对齐
				  
				      xlApp.HAlign=2
				
			      Case "1"   //右对齐
				    	xlApp.HAlign=4
					
		         Case "2"   //中对齐
				        xlApp.HAlign=3
				
			      Case "3"    //均匀对齐,调整为左对齐
				        xlApp.HAlign=6
			END CHOOSE
		END IF      //{c}
		//竖直对齐方式
Next     //{a}

Return li_outlines

end function

public subroutine of_setgridborder (boolean ab_flag);
//对于非Grid形式的数据窗口，需要在代码中指定是否需要设置报表单元的边框
//如果是Grid形式的数据窗口，不需要指定

ib_GridBorder=ab_Flag 
end subroutine

protected function string of_getdata (long ai_row, string as_objectname);
String ls_ColType,ls_ret,ls_format,ls_editstyle
ls_format=idw_Requestor.Describe(as_objectname+".format")
ls_ColType = lower(idw_Requestor.Describe(as_objectname+".ColType"))
ls_editstyle=lower(idw_Requestor.Describe(as_objectname+".edit.style"))

IF ls_editstyle="ddlb" OR ls_editstyle="dddw"  OR idw_Requestor.Describe(as_objectname+".edit.codetable")="yes" Then    
	ls_ret= idw_Requestor.Describe("Evaluate('LookUpDisplay("+as_objectname+") ', "	+string(ai_row)+ ")")
	
	IF ls_ret<>"!" Then
   	Return ls_ret
	END IF
	
END IF





//  对输入的内容进行格式转换的原因是避免输出的结果与报表的不一致
//  例如日期型数据，如果日期格式与控制面板中定义的日期格式不一致，输出的结果可能不正确
//  数值型不转换，因为数据型可能有多位小数，而报表中只显示一部份，为了把数据全部转出，不做转换
//  而在开始输出数据时定义列的格式.



Choose Case Mid(ls_ColType,1,4)
	Case "char"	    
		    ls_ret=idw_Requestor.GetItemString(ai_row,as_objectname)
			  
	Case "numb", "long","real","deci","int","inte"
		    ls_ret=String(idw_Requestor.GetItemNumber(ai_row,as_objectname))
		  
	Case "date"
		    IF ls_format="[general]" OR ls_format="?" OR ls_format="!" Then
             ls_format=""	
			 END IF

		    IF ls_ColType="datetime" Then
				
			      ls_ret=String(idw_Requestor.GetItemDateTime(ai_row,as_objectname),ls_format)
			 ELSE
				   ls_ret=String(idw_Requestor.GetItemDate(ai_row,as_objectname),ls_format)
			END IF
	Case "time"
		  
	     ls_ret=String(idw_Requestor.GetItemTime(ai_row,as_objectname),ls_format)
		
END CHOOSE


IF IsNull(ls_ret) OR Trim(ls_ret)="" Then
   Return ""
ELSE
	Return ls_ret
END IF

Return ""
end function

public function integer of_groupcount ();/*
   计算数据窗口有多少个分组
	
*/

string ls_Temp
int li_pos,li_groupcount

ls_Temp=lower(idw_Requestor.Describe("datawindow.bands"))
li_pos=1
Do While li_pos>0 
	li_pos=Pos(ls_Temp,"header.",li_pos)
	IF li_pos>0 Then
		  li_groupcount++
		 li_pos++
   END IF
Loop
Return li_groupcount
end function

public function string of_replaceall (string as_string1, string as_string2, string as_string3);long ll_Pos,ll_F,ll_R

ll_F=Len(as_String2)
ll_R=Len(as_String3)

ll_Pos=Pos(as_String1,as_String2)
DO WHILE ll_Pos<>0
	as_String1=Replace(as_String1,ll_Pos,ll_F,as_String3)
	ll_Pos=Pos(as_String1,as_String2,ll_Pos+ll_R)
LOOP

RETURN as_String1
end function

public subroutine of_openexcelfile (boolean ab_flag);ib_OpenExcel=ab_Flag
end subroutine

public function long of_outdata_detail (long ai_currow);///*-------------------------------------------------
//    在EXCEL表中写入数据
//	 
//	 ai_CurRow      数据要写入到EXCEL中的行号
//返回值：   在EXCEL中写入多少行数据
//----------------------------------------------------------------------*/


String ls_ColType,ls_ret,ls_format,ls_editstyle
Long   li_outlines
String ls_Value, ls_Name,ls_Type
Int li,lj,li_Count
Int li_StartRow,li_StartCol,li_EndRow,li_EndCol
Int li_CurRow
Int li_Row
Int li_FontSize


ids_Objects.SetFilter("band='detail'")
is_OldBand="detail"
ids_Objects.Filter()
ids_Objects.Sort()

li_Count=ids_Objects.RowCount()
li_outlines=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))

IF  ii_DetailRow<=0  Then
	ii_DetailRow=ai_CurRow
END IF
		  
FOR li=1 To li_Count   //{a}
	   ls_Name=ids_Objects.Object.Name[li]
		ls_Type=ids_Objects.Object.Stype[li]
    	li_StartRow=ids_Objects.Object.StartRow[li]
		li_StartCol=ids_Objects.Object.StartCol[li]
		li_EndRow=ids_Objects.Object.EndRow[li]
		li_EndCol=ids_Objects.Object.EndCol[li]

		IF li_StartRow<=0  OR li_StartCol<=0   OR li_StartCol>256 Then Continue   //行列没定义不输出 ,如果列大于256,也不输出,因为F1最多只支持256列
 	    
		 //需要检查参数,避免超出F1的范围
		
		ls_format=ids_Objects.Object.Format[li]
		ls_ColType = ids_Objects.Object.ColType[li]
		ls_editstyle=lower(idw_Requestor.Describe(ls_Name+".edit.style"))

		For li_Row=1 To idw_Requestor.RowCount()
					li_CurRow=li_StartRow+ai_CurRow+(li_Row -1 )*li_OutLines
					xlApp.SetActiveCell(li_CurRow,li_StartCol)
					
					IF  ls_Type="compute" OR ls_Type="column" Then   //{b}
							
							IF ls_editstyle="ddlb" OR ls_editstyle="dddw"  OR idw_Requestor.Describe(ls_Name+".edit.codetable")="yes" Then    
								 ls_value= idw_Requestor.Describe("Evaluate('LookUpDisplay("+ls_Name+") ', "	+string(li_row)+ ")")
							ELSE
								   Choose Case Mid(ls_ColType,1,4)
											  Case "char"	    
												 ls_value=idw_Requestor.GetItemString(li_Row,ls_Name)
												  
												Case "numb", "long","real","deci","int","inte"
														 ls_value=String(idw_Requestor.GetItemNumber(li_Row,ls_Name))
													  
												Case "date"
														 IF ls_format="[general]" OR ls_format="?" OR ls_format="!" Then
															 ls_format=""	
														 END IF
											
														 IF ls_ColType="datetime" Then
															
																ls_value=String(idw_Requestor.GetItemDateTime(li_Row,ls_Name),ls_format)
														 ELSE
																ls_value=String(idw_Requestor.GetItemDate(li_Row,ls_Name),ls_format)
														END IF
												Case "time"
													  
													  ls_value=String(idw_Requestor.GetItemTime(li_Row,ls_Name),ls_format)
											   END CHOOSE
							 END IF
							 
							IF IsNull(ls_value) OR ls_Value="" OR  ls_value ="!" OR ls_Value="?" Then
								Continue
							END IF
							
							IF ids_Objects.Object.ColType[li]="char" Then
								 xlApp.TextRC[li_CurRow,li_StartCol]=ls_value
							ELSE
								xlApp.EntryRC[li_CurRow,li_StartCol]=ls_value
							END IF
							
					ELSE
							xlApp.TextRC[li_CurRow,li_StartCol]=idw_Requestor.Describe(ls_Name+".text")
					END IF      
		 Next
				
Next    

Return li_outlines*idw_Requestor.RowCount() 


end function

on n_cst_dw2excel_grid.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_dw2excel_grid.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*---------------------------------------------------------
   把数据窗口转存为Excel文件
	
	如果是Grid形式的数据窗口,转存的效果较好,对于Free形式的数据窗口,
   要求对象按输出到Excel工作表单元格的先后顺序和上下位置进行排序,对位置的要求比较严格
	
	
	
	特殊对象命名： 
	
	   列标题  ：  							 列名称+_t      
		报表标题：  							 report_title   (可以没有,但报表标题必须单独一行)
		Grid报表的背景文本框对象：			 sys_Back       (可以没有)
		用于标识Grid报表最后一列的对象：  sys_lastcol    (可以没有)
		
		
		如果报表记录较多，输出的时间较长，所以需要在应用程序中定义一个窗口 w_Tips，用于在
		执行另存为Excel文件的过程中，显示等待信息。
		
		对象函数 ，功能和使用可参考示例：
		           OF_dw2Xls(Datawindow  adw,String as_FileName)
					  把指定的数据窗口的报表另存为Excel文件
					  
			        OF_SetGridBorder(Boolean ab_Flag) 
					  设置报表在另存为Excel文件时,是否需要自动加上单元的边框
					  
					  
					  OF_OpenExcelFile(Boolean ab_Flag) 
					  设置在完成导出后,是否提示用户打开该Excel文件
					  
					  
					  
			
		注意:		1.  如果程序出现 NumberFormatLocal属性错误的信息,请检查数据列和计算字段Format属性的设置
		             请使用一般的格式,不要使用Formula One不支持的数据格式
					
					2.  对于交叉报表,程序在导出数据的时候,会把报表的状态改变是"静态报表",此时如果需要
					    重新从数据库检索数据,应该要重新设置数据窗口控件的 DataObject 属性,或改变数据窗口
						 的状态为动态.
						
					3.  对于Free形式的报表,一定要注意对象的位置关系,否则会出现不同的对象,往同一个报表单元
					    输出数据的情况,导致先输出的数据被覆盖,如果出现这种情况,只要调整对象的位置就可以了.
						 或者在输出到Excel之前,先通过代码调置位置,输出完成后,再调整回来就可以了.
						 
						 新版本已增加代码,避免多个对象向同一个Excel单元输出数据的情况.
		
		
	         如果有什么意见或建议,可跟我联系    HuangGuoChou@163.Net 
		----------------------------------------------------------------------------------------------*/


end event

