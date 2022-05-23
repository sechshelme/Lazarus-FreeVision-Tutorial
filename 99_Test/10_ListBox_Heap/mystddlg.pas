unit MyStdDlg;

interface

uses
dos,  FVConsts, Objects, Drivers, Views, Dialogs, StdDlg;

type
  PFileList = ^TFileList;
  TFileList = object(TSortedListBox)
    constructor Init(var Bounds: TRect; AScrollBar: PScrollBar);
    destructor Done; virtual;
    function DataSize: Sw_Word; virtual;
    procedure FocusItem(Item: Sw_Integer); virtual;
    procedure GetData(var Rec); virtual;
    function GetText(Item,MaxLen: Sw_Integer): String; virtual;
    function GetKey(var S: String): Pointer; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure ReadDirectory(AWildCard: PathStr);
    procedure SetData(var Rec); virtual;
  end;





  PMyFileDialog = ^TMyFileDialog;

  TMyFileDialog = object(TDialog)
    FileName1: PButton;
    FileName2: PButton;
    FileHistory1: PButton;
    WildCard1: TWildStr;

    Directory: PString;


    FileList: PFileList;
    constructor Init;
    destructor Done; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  private
    procedure ReadDirectory;
  end;

  const
  ListSeparator=';';



implementation


constructor TFileList.Init(var Bounds: TRect; AScrollBar: PScrollBar);
begin
  TSortedListBox.Init(Bounds, 2, AScrollBar);
end;

destructor TFileList.Done;
begin
  if List <> nil then Dispose(List, Done);
  TListBox.Done;
end;

function TFileList.DataSize: Sw_Word;
begin
  DataSize := 0;
end;

procedure TFileList.FocusItem(Item: Sw_Integer);
begin
  TSortedListBox.FocusItem(Item);
  if (List^.Count > 0) then
    Message(Owner, evBroadcast, cmFileFocused, List^.At(Item));
end;

procedure TFileList.GetData(var Rec);
begin
end;

function TFileList.GetKey(var S: String): Pointer;
const
  SR: TSearchRec = ();

procedure UpStr(var S: String);
var
  I: Sw_Integer;
begin
  for I := 1 to Length(S) do S[I] := UpCase(S[I]);
end;

begin
  if (HandleDir{ShiftState and $03 <> 0}) or ((S <> '') and (S[1]='.')) then
    SR.Attr := Directory
  else SR.Attr := 0;
  SR.Name := S;
{$ifndef Unix}
  UpStr(SR.Name);
{$endif Unix}
  GetKey := @SR;
end;

function TFileList.GetText(Item,MaxLen: Sw_Integer): String;
var
  S: String;
  SR: PSearchRec;
begin
  SR := PSearchRec(List^.At(Item));
  S := SR^.Name;
  if SR^.Attr and Directory <> 0 then
  begin
    S[Length(S)+1] := DirSeparator;
    Inc(S[0]);
  end;
  GetText := S;
end;

procedure TFileList.HandleEvent(var Event: TEvent);
var
  S : String;
  K : pointer;
  Value : Sw_integer;
begin
  if (Event.What = evMouseDown) and (Event.Double) then
  begin
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  end
  else if (Event.What = evKeyDown) and (Event.CharCode='<') then
  begin
    { select '..' }
      S := '..';
      K := GetKey(S);
      If PSortedCollection(List)^.Search(K, Value) then
        FocusItem(Value);
  end
  else TSortedListBox.HandleEvent(Event);
end;

//////////// Ende FileList

procedure TFileList.ReadDirectory(AWildCard: PathStr);
const
  FindAttr = ReadOnly + Archive;
  PrevDir  = '..';
var
  S: SearchRec;
  P: PSearchRec;
  FileList: PFileCollection;
  NumFiles: Word;
  FindStr,
  WildName : string;
  Dir: DirStr;
  Ext: ExtStr;
  Name: NameStr;
  Event : TEvent;
  Tmp: PathStr;
begin
  NumFiles := 0;
  FileList := New(PFileCollection, Init(5, 5));
  AWildCard := FExpand(AWildCard);
  FSplit(AWildCard, Dir, Name, Ext);
  if pos(ListSeparator,AWildCard)>0 then
   begin
     WildName:=Copy(AWildCard,length(Dir)+1,255);
     FindStr:=Dir+AllFiles;
   end
  else
   begin
     WildName:=Name+Ext;
     FindStr:=AWildCard;
   end;
  FindFirst(FindStr, FindAttr, S);
  P := PSearchRec(@P);
  while assigned(P) and (DosError = 0) do
   begin
     if (S.Attr and Directory = 0) and
        False then
     begin
{       P := MemAlloc(SizeOf(P^));
       if assigned(P) then
       begin}
         new(P);
         P^.Attr:=S.Attr;
         P^.Time:=S.Time;
         P^.Size:=S.Size;
         P^.Name:=S.Name;
         FileList^.Insert(P);
{       end;}
     end;
     FindNext(S);
   end;
 {$ifdef fpc}
  FindClose(S);
 {$endif}

  Tmp := Dir + AllFiles;
  FindFirst(Tmp, Directory, S);
  while (P <> nil) and (DosError = 0) do
  begin
    if (S.Attr and Directory <> 0) and (S.Name <> '.') and (S.Name <> '..') then
    begin
{      P := MemAlloc(SizeOf(P^));
      if P <> nil then
      begin}
        new(p);
        P^.Attr:=S.Attr;
        P^.Time:=S.Time;
        P^.Size:=S.Size;
        P^.Name:=S.Name;
        FileList^.Insert(P);
{      end;}
    end;
    FindNext(S);
  end;
 {$ifdef fpc}
  FindClose(S);
 {$endif}
 {$ifndef Unix}
  if Length(Dir) > 4 then
 {$endif not Unix}
  begin
{
    P := MemAlloc(SizeOf(P^));
    if P <> nil then
    begin}
      new(p);
      FindFirst(Tmp, Directory, S);
      FindNext(S);
      if (DosError = 0) and (S.Name = PrevDir) then
       begin
         P^.Attr:=S.Attr;
         P^.Time:=S.Time;
         P^.Size:=S.Size;
         P^.Name:=S.Name;
       end
      else
       begin
         P^.Name := PrevDir;
         P^.Size := 0;
         P^.Time := $210000;
         P^.Attr := Directory;
       end;
      FileList^.Insert(PSearchRec(P));
     {$ifdef fpc}
      FindClose(S);
     {$endif}
{    end;}
  end;
//  if P = nil then
//    MessageBox(sTooManyFiles, nil, mfOkButton + mfWarning);
  NewList(FileList);
  if List^.Count > 0 then
  begin
    Event.What := evBroadcast;
    Event.Command := cmFileFocused;
    Event.InfoPtr := List^.At(0);
    Owner^.HandleEvent(Event);
  end;
end;

procedure TFileList.SetData(var Rec);
begin
  with PFileDialog(Owner)^ do
    Self.ReadDirectory(Directory^ + WildCard);
end;




constructor TMyFileDialog.Init;
var
  Control: PView;
  R: TRect;
begin
  R.Assign(15, 1, 64, 20);
  TDialog.Init(R, '1234567890');

  R.Assign(3, 3, 31, 4);
//  FileName := New(PFileInputLine, Init(R, 79));
//  Insert(FileName);
  R.Assign(31, 3, 34, 4);
//  FileHistory := New(PFileHistory, Init(R, FileName, HistoryId));
//  Insert(FileHistory);

  R.Assign(3, 14, 34, 15);
  Control := New(PScrollBar, Init(R));
  Insert(Control);
  R.Assign(3, 6, 34, 14);
  FileList := New(PFileList, Init(R, PScrollBar(Control)));
  Insert(FileList);

  R.Assign(35, 3, 46, 5);
  Insert(New(PButton, Init(R, slCancel, cmCancel, bfNormal)));

    ReadDirectory;
end;

destructor TMyFileDialog.Done;
begin
  DisposeStr(Directory);
  TDialog.Done;
end;

procedure TMyFileDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  exit;

  if (Event.What and evBroadcast <> 0) and (Event.Command = cmListItemSelected) then begin
    EndModal(cmFileOpen);
    ClearEvent(Event);
  end;
  TDialog.HandleEvent(Event);
  if Event.What = evCommand then begin
    case Event.Command of
      cmFileOpen, cmFileReplace, cmFileClear: begin
        EndModal(Event.Command);
        ClearEvent(Event);
      end;
    end;
  end;
end;

procedure TMyFileDialog.ReadDirectory;
begin
  FileList^.ReadDirectory('*');
//  FileHistory^.AdaptHistoryToDir(GetCurDir);
  Directory := NewStr(GetCurDir);
end;

begin
end.
