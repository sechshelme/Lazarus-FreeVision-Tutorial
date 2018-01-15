program TVEdit;
uses Objects, Drivers, Memory, Views, Menus, Dialogs,
  StdDlg, MsgBox, App, FVConsts, Editors;

type
  TEditorApp = object(TApplication)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure OutOfMemory; virtual;
  end;

var
  EditorApp: TEditorApp;

function OpenEditor(FileName: FNameStr; Visible: Boolean): PEditWindow;
var
  P: PWindow;
  R: TRect;
begin
  DeskTop^.GetExtent(R);
  P := New(PEditWindow, Init(R, FileName, wnNoNumber));
  if not Visible then P^.Hide;
  OpenEditor := PEditWindow(Application^.InsertWindow(P));
end;

constructor TEditorApp.Init;
begin
  inherited Init;
  EditorDialog := @StdEditorDialog;
end;

procedure TEditorApp.HandleEvent(var Event: TEvent);

procedure FileNew;
begin
  OpenEditor('', True);
end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      case Event.Command of
        cmNew: FileNew;
      else
        Exit;
      end;
  else
    Exit;
  end;
  ClearEvent(Event);
end;

procedure TEditorApp.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      StdFileMenuItems(
      nil)),
    NewSubMenu('~E~dit', hcNoContext, NewMenu(
      StdEditMenuItems(
      nil)),
    NewSubMenu('~S~earch', hcNoContext, NewMenu(
      NewItem('~F~ind...', '', kbNoKey, cmFind, hcNoContext,
      NewItem('~R~eplace...', '', kbNoKey, cmReplace, hcNoContext,
      NewItem('~S~earch again', '', kbNoKey, cmSearchAgain, hcNoContext,
      nil)))),
    NewSubMenu('~W~indows', hcNoContext, NewMenu(
      StdWindowMenuItems(
      nil)),
    nil)))))));
end;

procedure TEditorApp.OutOfMemory;
begin
  MessageBox('Not enough memory for this operation.',
    nil, mfError + mfOkButton);
end;

begin
  EditorApp.Init;
  EditorApp.Run;
  EditorApp.Done;
end.
