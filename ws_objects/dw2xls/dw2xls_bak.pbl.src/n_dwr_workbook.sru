$PBExportHeader$n_dwr_workbook.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_workbook from nonvisualobject
end type
end forward

global type n_dwr_workbook from nonvisualobject
end type
global n_dwr_workbook n_dwr_workbook

type prototypes
public function ulong createworkbook (readonly string as_format,readonly string as_file,boolean ab_overwrite,ref long al_errorcode)  library "pb2xls.dll" alias for "g_createWorkbook"
public function ulong addworksheet (ulong wb,readonly string as_sheetname)  library "pb2xls.dll" alias for "wb_addWorksheet"
public function long save (ulong wb)  library "pb2xls.dll" alias for "wb_save"
public subroutine _destroy (ulong wb)  library "pb2xls.dll" alias for "wb_destroy"
public function ulong getmodulefilenamea (ulong hinstmodule,ref string lpszpath,ulong cchpath)  library "KERNEL32.DLL" alias for "GetModuleFileNameA"
public function ulong getmodulefilenamew (ulong hinstmodule,ref string lpszpath,ulong cchpath)  library "KERNEL32.DLL" alias for "GetModuleFileNameW"
public function ulong loadlibrarya (ref string lplibfilename)  library "KERNEL32.DLL" alias for "LoadLibraryA"
public function ulong loadlibraryw (ref string lplibfilename)  library "KERNEL32.DLL" alias for "LoadLibraryW"
public function boolean freelibrary (ulong hlibmodule)  library "KERNEL32.DLL" alias for "FreeLibrary"
public function ulong createformat (ulong wb)  library "pb2xls.dll" alias for "wb_createFormat"
public function ulong addformat (ulong wb,ulong format)  library "pb2xls.dll" alias for "wb_addFormat"
end prototypes

type variables
public ulong handle
public n_dwr_worksheet invo_worksheets[]
end variables

forward prototypes
public function long of_addformat (n_dwr_format anv_format)
public function n_dwr_worksheet of_addworksheet (readonly string as_sheetname)
public function long of_create (readonly string as_format,readonly string as_file,boolean ab_overwrite)
public function n_dwr_format of_createformat ()
private function string of_getexedir ()
public function boolean of_iswidepb ()
private function ulong of_loadlibrary (string as_dll)
end prototypes

public function long of_addformat (n_dwr_format anv_format);return addformat(handle,anv_format.handle)
end function

public function n_dwr_worksheet of_addworksheet (readonly string as_sheetname);n_dwr_worksheet lnv_sheet

lnv_sheet = create n_dwr_worksheet
lnv_sheet.handle = addworksheet(handle,as_sheetname)

if lnv_sheet.handle = 0 then
	setnull(lnv_sheet)
else
	invo_worksheets[upperbound(invo_worksheets) + 1] = lnv_sheet
	lnv_sheet.of_initunitconvertor()
end if

return lnv_sheet
end function

public function long of_create (readonly string as_format,readonly string as_file,boolean ab_overwrite);long ll_errorcode
ulong h

h = of_loadlibrary("pb2xls.dll")
handle = createworkbook(as_format,as_file,ab_overwrite,ll_errorcode)

if h > 0 then
	freelibrary(h)
end if

return ll_errorcode
end function

public function n_dwr_format of_createformat ();n_dwr_format lnv_format

lnv_format = create n_dwr_format
lnv_format.handle = createformat(handle)
return lnv_format
end function

private function string of_getexedir ();string ls_path
long li_max = 1024
long li_pos
classdefinition lcd

if handle(getapplication()) = 0 then
	//lcd = getclassdefinition()
	//ls_path = lcd.getlibraryname()
else
	ls_path = space(li_max)

	if of_iswidepb() then
		getmodulefilenamew(handle(getapplication()),ls_path,li_max)
	else
		getmodulefilenamea(handle(getapplication()),ls_path,li_max)
	end if

end if

li_pos = pos(reverse(ls_path),"\")

if li_pos > 0 then
	ls_path = left(ls_path,len(ls_path) - li_pos)
else
	ls_path = "."
end if

return ls_path
end function

public function boolean of_iswidepb ();return len(blob("*")) = 2
end function

private function ulong of_loadlibrary (string as_dll);string ls_dll

ls_dll = of_getexedir() + "\" + as_dll

if of_iswidepb() then
	return loadlibraryw(ls_dll)
else
	return loadlibrarya(ls_dll)
end if
end function

on n_dwr_workbook.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_workbook.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;_destroy(handle)
handle = 0
return
end event

