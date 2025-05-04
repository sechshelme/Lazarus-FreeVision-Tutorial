unit Params; {&Use32+}
{
    Handles command-line parameters; can also set default options.
    Copyright 1992,2000 by James M. Clark.
    See also: skel.pas, pardemo.pas, config.exe, config.doc

ver. 2, 7-14-92:
    Increased length of OptStr and ParStr to max (255 bytes).
ver. 3, 9-14-92:
    OptStr initially set := version / copyright notice.
ver. 4, 4-20-00:
    GetDouble added.
}

interface

uses Dos;

{
    The application must define procedures ShowUsage, SetOpt,
    DoFile, and AppDone, and set the following procedure variables
    so that the procedures can be used by the Params unit.
    For example:

        procedure ShowUsage; far;
        begin
            - - -
        end;

        begin
            PShowUsage:= ShowUsage;
            - - -
        end.
}

{$F+}   {needed to use procedure variables}

var
    PShowUsage: procedure;
    {Explains command-line usage}

    PSetOpt: procedure;
    {Sets option of OptChr to value of OptStr}

    PDoFile: procedure(FName: PathStr; Expdd: boolean);
    {Processes the file (or name) FName}

{
    The FName parameter of DoFile may or may not be a filename.
    To keep the filename counts correct, DoFile should use as
    appropriate:

        procedure IsFile;
        begin
            if not Expdd then begin
                inc(FileNo);  inc(FPars);
            end;
        end;
}

    PAppDone: procedure;
    {Prepares to exit application (but doesn't exit)}

function GetDefaults(DefOpts: string): string;
{Gets default option string DefOpts and}
{Strips any trailing '/' (padding) characters}

procedure RptError(Complaint, Name: string; Dispose: char);
{Displays error message: Complaint+': "'+Name+'".'
and halts/explains/ignores}

{Example message: Can not find file(s): "yourfile.ext".   }
{Dispose is one of these:   }
{   'i': Ignore             }
{   'u': show Usage & halt  }
{   'h': Halt               }
{Dispose mode 'u' calls user-defined ShowUsage procedure. }
{Modes 'u' and 'h' call AppDone BEFORE displaying message.}

function GetBool: boolean;
{Converts option string OptStr to a boolean value}

function GetInt: integer;
{Converts option string OptStr to an integer value.}

function GetLong: longint;
{Converts option string OptStr to a longint value.}

function GetDouble: double;
{Converts option string OptStr to a double value:}

procedure ChkFlg;
{Checks if extra characters after a simple flag.}
{For example, /fxy when /f was expected.}

procedure ParseOpts(ParStr: string);
{Scans parameter string ParStr and collect option data.}
{Options start with '/' and may run together, e.g.: /b+/c12/d-/eString }
{or may be separated by spaces, e.g.: /b+ /c12   /d- /eString }
{uses PSetOpt to define the options.}

function ExtendOpt: ExtStr;
{Extends the option name (OptChr) by taking one}
{character from the option value (OptStr) if available.  }
{If OptStr is '', then append '/' to OptChr instead.     }

procedure ScanPars;
{Scans the command line, processes according to syntax.}
{ Parameters starting with '/' are processed by ParseOpts.    }
{ Parameters with '*' or '?' are expanded per DOS convention  }
{   (by directory search) to possibly more than one file and  }
{   processed by PDoFile( , true) if MayExpand is true.       }
{ Other parameters are processed by PDoFile( , false); these  }
{   may or may not be filenames.                              }

function ExePath(ExeName: PathStr): PathStr;
{ Returns the pathname of the program file. }
{ ExeName is used to help find it for DosVer < 3.0 }

function ExeDir: DirStr;
{Gets directory of program file if possible, else ''.}

function ExeName: NameStr;
{Gets name of program file if possible, else ''.}

var
    {The procedure ParseOpts uses these variables to pass current   }
    {option data to procedures PSetOpt and ChkFlg, and to functions }
    {GetBool and GetInt (more efficient than call parameters):      }

    Option: ExtStr;     {e.g., the '/c' in '/c12'}
    OptChr: char;       {e.g., the 'c'  in '/c12'}
    OptStr: string;     {e.g., the '12' in '/c12'}

    {Alternatively, if PSetOpt uses Optn:= ExtendOpt instead of OptChr,}
    {then:  Option is the '/co' in '/co12'  or '/c' in '/c' }
    {       Optn   is the 'co'  in '/co12'  or 'c'  in '/c' }
    {       OptStr is the '12'  in '/co12'  or ''   in '/c' }

    {use these for more info on current file:}
    Dir:  DirStr;       {full pathname of directory}
    SRec: SearchRec;    {full details}

const
    {During operation of ScanPars, the user-defined SetOpt and DoFile}
    {procedures may use these to identify parameters and files; each }
    {count starts at 1, but prior to the operation of ScanPars, ParNo}
    { <= 0 may be used to indicate early stage(s) of initialization. }

    ParNo:  integer = -1;   {number of current parameter}
    FileNo: word    =  0;   {number of current file}
    FPars:  word    =  0;   {number of expanded parameters}

    MayExpand: boolean = true;  {enables filename expansion}
    AttrMask: word = AnyFile-Directory-VolumeID;    {file types to find}

    {error messages; used with RptError procedure:}
    sCantFind   = 'Can not find file(s)';
    sBadBool    = 'Option value should be ''+'' or ''-''';
    sBadInt     = 'Option value should be an integer';
    sBadVal     = 'Option value should be an number';
    sBadFlag    = 'Extra characters after option';

    {corresponding disposal modes; used with RptError procedure:}
    dCantFind:  char = 'i';     {used by ScanPars}
    dBadBool:   char = 'u';     {used by GetBool}
    dBadInt:    char = 'u';     {used by GetInt}
    dBadVal:    char = 'u';     {used by GetDouble}
    dBadFlag:   char = 'u';     {used by ChkFlg}

{-------------------------------------------------------------}

implementation

const CopyRight = 'PARAMS.TPU (c) 4-20-00 J. M. Clark';

{GetDefaults: get default option string:}
{strips any trailing '/' (padding) characters}

function GetDefaults(DefOpts: string): string;
var
    ChrPos: integer;

begin
    ChrPos:= Pos('//', DefOpts) - 1;
    if ChrPos < 0 then begin
        ChrPos:= Length(DefOpts);
        if DefOpts[ChrPos] = '/' then dec(ChrPos);
    end;
    GetDefaults:= Copy(DefOpts, 1, ChrPos);
end; {GetDefaults}

{RptError: display error message, and halt/explain/ignore:}
{example: Can not find file(s): "yourfile.ext". }
{Dispose is 'i', 'u', or 'h': see below:}

procedure RptError(Complaint, Name: string; Dispose: char);
begin
    if (Dispose = 'u') or (Dispose = 'h') then PAppDone;
    write(Complaint, ': "', Name, '".');
    case Dispose of
        'i': {Ignore} begin
            writeln(' (ignored)');
            exit;
        end;

        'u': {show Usage & halt} begin
            writeln;
            PShowUsage;
            Halt;
        end;

        'h': {Halt} begin
            writeln;
            Halt;
        end;
    end;
    writeln;    {ignore without saying so}
end; {RptError}

{GetBool: convert option string OptStr to a boolean value:}

function GetBool: boolean;
begin
    if (OptStr = '') or (OptStr = '+') then GetBool:= true
    else if              OptStr = '-'  then GetBool:= false
    else RptError(sBadBool, Option, dBadBool);
end; {GetBool}

{GetInt: convert option string OptStr to an integer value:}

function GetInt: integer;
var
    int, err: integer;

begin
    Val(OptStr, int, err);
    if err = 0 then GetInt:= int
    else RptError(sBadInt, Option, dBadInt);
end; {GetInt}

{GetLong: convert option string OptStr to an longint value:}

function GetLong: longint;
var
    int: longint;
    err: integer;
begin
    Val(OptStr, int, err);
    if err = 0 then GetLong:= int
    else RptError(sBadInt, Option, dBadInt);
end; {GetLong}

{GetDouble: convert option string OptStr to a double value:}

function GetDouble: double;
var
    dbl: double;
    err: integer;
begin
    Val(OptStr, dbl, err);
    if err = 0 then GetDouble:= dbl
    else RptError(sBadVal, Option, dBadVal);
end; {GetDouble}

{ChkFlg: check if extra characters after a simple flag:}
{for example, /fxy when /f was expected}

procedure ChkFlg;
begin
    if OptStr <> '' then RptError(sBadFlag, Option, dBadFlag);
end; {ChkFlg}

{ParseOpts: scan parameter string ParStr and collect option data:}
{options start with '/' and may run together, e.g.: /b+/c12/d-/eString }
{or may be separated by spaces, e.g.: /b+ /c12   /d- /eString }
{uses PSetOpt to define the options}

procedure ParseOpts(ParStr: string);
var
    ChrPos: integer; {search position in ParStr}

begin
    {we begin with the assumption that ParStr[1] = '/'}
    while Length(ParStr) > 1 do begin       {quit if ParStr end is '/'}
        OptChr:= ParStr[2];
        if OptChr = '/' then exit;          {quit if '//' is found}
        Option:= '/'+OptChr;

        {delete the '/' and OptChr from ParStr:}
        Delete(ParStr, 1, 2);
        ChrPos:= Pos(' ', ParStr);          {look for a space, else..}
        if ChrPos = 0
        then ChrPos:= Pos('/', ParStr);     {look for another '/'}

        {if no more '/', then OptStr is all remaining of ParStr:}
        if ChrPos = 0 then begin
            OptStr:= ParStr;
            PSetOpt;    {interpret OptChr and OptStr}
            exit;

        end else begin
            OptStr:= Copy(ParStr, 1, ChrPos-1);
            PSetOpt;    {interpret OptChr and OptStr}
            Delete(ParStr, 1, ChrPos-1);
            {now the next space or '/' is in ParStr[1]}
            ChrPos:= Pos('/', ParStr);      {look for next '/'}
            while (Length(ParStr) > 2) and (ParStr[1] = ' ')
                and ((ParStr[2] = '/') or (ParStr[2] = ' '))
            do Delete(ParStr, 1, 1);
        end;
    end; {while}
end; {ParseOpts}

{ExtendOpt: Extend the option name (OptChr) by taking one}
{character from the option value (OptStr) if available:  }
{If OptStr is '', then append '/' to OptChr instead.     }

function ExtendOpt: ExtStr;
begin
    if Length(OptStr) > 0 then begin
        Option:= Option + OptStr[1];
        ExtendOpt:= OptChr + OptStr[1];
        Delete(OptStr, 1, 1);
    end else begin
        ExtendOpt:= OptChr + '/';   {converts char to string}
    end;
end; {ExtendOpt}

{ScanPars: scan the command line, process according to syntax:}
{ Parameters starting with '/' are processed by ParseOpts.    }
{ Parameters with '*' or '?' are expanded per DOS convention  }
{   (by directory search) to possibly more than one file and  }
{   processed by PDoFile( , true) if MayExpand is true.       }
{ Other parameters are processed by PDoFile( , false); these  }
{   may or may not be filenames.                              }

procedure ScanPars;
var
    EFiles: word;
    ParStr: string;
    ParNo,
    ChrPos: integer;
    Path: PathStr;  {expanded pathname, may have wildcards}
                    {Path = Dir + Name + Ext}
    Name: NameStr;  {may have wildcards}
    Ext:  ExtStr;   {may have wildcards, includes '.'}

begin
    FileNo:= 0;
    FPars:= 0;
    for ParNo:= 1 to ParamCount do begin
        ParStr:= ParamStr(ParNo);
        if ParStr[1] = '/' then ParseOpts(ParStr)
        else begin

            if MayExpand and
                ((Pos('*',ParStr) > 0) or (Pos('?',ParStr) > 0))
            then begin
                EFiles:= 0;
                inc(FPars);         {count filename parameters}
                Path:= FExpand(ParStr);
                FSplit(Path, Dir, Name, Ext);

                {search the directory:}
                FindFirst(Path, AttrMask, SRec);
                while DosError = 0 do begin
                    inc(FileNo);    {count all files}
                    inc(EFiles);    {count exanded files for each ParStr}
                    PDoFile(Dir + Srec.Name, true);
                    FindNext(SRec);
                end;
                if EFiles = 0 then RptError(sCantFind, Path, dCantFind);

            end else begin
                {ParStr is not necessarily a filename:}
                {PDoFile may or may not inc FPars and FileNo:}
                PDoFile(ParStr, false);
            end;

        end; {if '/'}
    end; {for}
end; {ScanPars}

function ExePath(ExeName: PathStr): PathStr;
{ Returns the pathname of the program file. }
{ ExeName is used to help find it for DosVer < 3.0 }
var
    ExeFileName: PathStr;
begin
    ExeFileName:= ParamStr(0);
    if ExeFileName = '' { DosVer < 3.0 }
    then ExeFileName:= FSearch(ExeName, GetEnv('PATH'));
    ExePath:= FExpand(ExeFileName);
end;

function ExeDir: DirStr;
{ Gets directory of program file if possible, else ''. }
var
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
begin
    If Lo(DosVersion) >= 3 then begin
        FSplit(ParamStr(0), Dir, Name, Ext);
        ExeDir:= Dir;
    end else ExeDir:= '';
end; {ExeDir}

function ExeName: NameStr;
{ Returns the name of the program file if possible, else ''. }
var
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
begin
    If Lo(DosVersion) >= 3 then begin
        FSplit(ParamStr(0), Dir, Name, Ext);
        ExeName:= Name;
    end else ExeName:= '';
end; {ExeName}

begin
    FileNo:= 0;
    FPars:= 0;
    MayExpand:= true;
    ParNo:= -1;     {special value for initial ParseOpts}
    OptStr:= 'PARAMS.TPU  9-14-92 (C) James M. Clark';
end.
