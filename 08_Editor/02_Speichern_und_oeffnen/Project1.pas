//image image.png
(*
Ein Editor wird erst brauchbar, wen Dateifunktionen dazu kommen, zB. öffnen und speichern.
Das Öffnen ist ähnlich von wie ein leerses Fenster erzeugen.
Einziger Unterschied, man gibt einen Dateinamen mit, welcher mit einem FileDialog ermittelt wird.
Für das einfache speichern, muss man nicht viel machen. Man muss nur das Event <b>cmSave</b> aufrufen, zB. über das Menü.
*)
//lineal
program Project1;

uses
  App,
  Objects,
  Drivers,
  Views,
  MsgBox,
  Editors,
  Dialogs,
  StdDlg,
  Menus;

const
  cmNewWin = 1001;
  cmRefresh = 1002;
type

(*
Hier ist noch OpenWindows und SaveAll dazu gekommen.
*)
//code+
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    procedure NewWindows(FileName: ShortString);
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;
//code-

(*
Der <b>Speichern unter</b>-Dialog ist schon fest verbaut, aber leider in Englisch.
Daher wird diese Funktion auf eine eigene Routine umgeleitet.
Auch habe ich die Maske <b>*.*</b> durch <b>*.txt</b> ersetzt.
Für die restlichen Diloage, werden die original Routinen verwendet, dies geschieht mit <b>StdEditorDialog(...</b>.
Die Deklaration von <b>MyApp</b> ist schon hier oben, weil sie hier schon gebraucht wird.

Bei MyApp.Init werden noch die neuen Standard-Dialoge zugeordnet.
*)
//code+
var
  MyApp: TMyApp;

  function MyStdEditorDialog(Dialog: Int16; Info: Pointer): Word;
  begin
    case Dialog of
      edSaveAs: begin                 // Neuer Dialog in Deutsch.
        Result := MyApp.ExecuteDialog(New(PFileDialog, Init('*.txt', 'Datei speichern unter', '~D~atei-Name', fdOkButton, 101)), Info);
      end;
    else
      StdEditorDialog(Dialog, Info);  // Original Dialoge aufrufen.
    end;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;
    EditorDialog := @MyStdEditorDialog; // Die neue Dialog-Routine.
    DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear, cmUndo]);
    NewWindows('');                     // Leeres Fenster erzeugen.
  end;
//code-

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Speichern', kbF2, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil)))), nil)));
  end;

(*
Im Menü sind die neuen Datei-Funktionen dazugekommen.
*)
//code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewItem('~O~effnen...', 'F3', kbF3, cmOpen, hcNoContext,
        NewItem('~S~peichern', 'F2', kbF2, cmSave, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('~A~lle speichern', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));

  end;
//code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Einfügen eines Editorfensters.
Wen der Dateiname '' ist, wird einfach ein leeres Fenster erzeugt.
*)
//code+
  procedure TMyApp.NewWindows(FileName: ShortString);
  var
    Win: PEditWindow;
    Rect: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    Rect.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(Rect, FileName, WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
  end;
//code-
(*
Eine Datei öffnen und dies in ein Edit-Fenster laden.
Dabei wird ein <b>FileDialog</b> aufgerufen, in dem man eine Datei auswählen kann.
Um das laden der Datei in das Editor-Fenster  muss man sich nicht kümmeren, dies geschieht automatisch.
*)
//code+
  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';
    New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName); // Neues Fenster mit der ausgewählten Datei.
    end;
  end;
//code-
(*
Alle Dateien speichern, geschieht auf fast die gleiche Weise wie das alle schliessen.
*)
//code+
  procedure TMyApp.SaveAll;

    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil); // Das Kommando speicherm mitgeben.
    end;

  begin
    Desktop^.ForEach(@SendSave);          // Auf alle Fenster anwenden.
  end;
//code-

  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;

(*
Die verschiednen Events abfangen und abarbeiten.
Um <b>cmSave</b> und <b>cmSaveAs</b> muss man sich nicht kümmern, das erledigt <b>PEditWindow</b> automatisch für einem.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');   // Leeres Fenster erzeugen.
        end;
        cmOpen: begin
          OpenWindows;      // Datei öffnen.
        end;
        cmSaveAll: begin
          SaveAll;          // Alle speichern.
        end;
        cmCloseAll:begin
          CloseAll;         // Schliesst alle Fenster.
        end;
        cmRefresh: begin
          ReDraw;           // Anwendung neu zeichnen.
        end;
        else begin
          Exit;
        end;
      end;
    end;
  end;
//code-

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
