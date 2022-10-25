# 12 - Editor
## 05 - Speichern und oeffnen
<img src="image.png" alt="Selfhtml"><br><br>
Ein Editor wird erst brauchbar, wen Dateifunktionen dazu kommen, zB. öffnen und speichern.<br>
Das Öffnen ist ähnlich von wie ein leerses Fenster erzeugen.<br>
Einziger Unterschied, man gibt einen Dateinamen mit, welcher mit einem FileDialog ermittelt wird.<br>
Für das einfache speichern, muss man nicht viel machen. Man muss nur das Event <b>cmSave</b> aufrufen, zB. über das Menü.<br>
---
Hier ist noch OpenWindows und SaveAll dazu gekommen.<br>
```pascal>  TMyApp = object(TApplication)
    constructor Init;
<br>
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
<br>
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;
<br>
    procedure NewWindows(FileName: ShortString);
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;```
Der <b>Speichern unter</b>-Dialog ist schon fest verbaut, aber leider in Englisch.<br>
Daher wird diese Funktion auf eine eigene Routine umgeleitet.<br>
Auch habe ich die Maske <b>*.*</b> durch <b>*.txt</b> ersetzt.<br>
Für die restlichen Diloage, werden die original Routinen verwendet, dies geschieht mit <b>StdEditorDialog(...</b>.<br>
Die Deklaration von <b>MyApp</b> ist schon hier oben, weil sie hier schon gebraucht wird.<br>
<br>
Bei MyApp.Init werden noch die neuen Standard-Dialoge zugeordnet.<br>
```pascal>var
  MyApp: TMyApp;
<br>
  function MyStdEditorDialog(Dialog: Int16; Info: Pointer): Word;
  begin
    case Dialog of
      edSaveAs: begin                 // Neuer Dialog in Deutsch.
        Result := MyApp.ExecuteDialog(New(PFileDialog, Init('*.txt', 'Datei speichern unter', '~D~atei-Name', fdOkButton, 101)), Info);</font>
      end;
    else
      StdEditorDialog(Dialog, Info);  // Original Dialoge aufrufen.
    end;
  end;
<br>
  constructor TMyApp.Init;
  begin
    inherited Init;
    EditorDialog := @MyStdEditorDialog; // Die neue Dialog-Routine.
    DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear, cmUndo]);
    NewWindows('');                     // Leeres Fenster erzeugen.</font>
  end;```
Im Menü sind die neuen Datei-Funktionen dazugekommen.<br>
```pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(</font>
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,</font>
        NewItem('~O~effnen...', 'F3', kbF3, cmOpen, hcNoContext,</font>
        NewItem('~S~peichern', 'F2', kbF2, cmSave, hcNoContext,</font>
        NewItem('Speichern ~u~nter...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('~A~lle speichern', '', kbNoKey, cmSaveAll, hcNoContext,</font>
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),</font>
      NewSubMenu('~F~enster', hcNoContext, NewMenu(</font>
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,</font>
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,</font>
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,</font>
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,</font>
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));
<br>
  end;```
Einfügen eines Editorfensters.<br>
Wen der Dateiname '' ist, wird einfach ein leeres Fenster erzeugt.<br>
```pascal>  procedure TMyApp.NewWindows(FileName: ShortString);
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster</font>
  begin
    R.Assign(0, 0, 60, 20);</font>
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, FileName, WinCounter));
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
  end;```
Eine Datei öffnen und dies in ein Edit-Fenster laden.<br>
Dabei wird ein <b>FileDialog</b> aufgerufen, in dem man eine Datei auswählen kann.<br>
Um das laden der Datei in das Editor-Fenster  muss man sich nicht kümmeren, dies geschieht automatisch.<br>
```pascal>  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';</font>
    New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));</font>
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName); // Neues Fenster mit der ausgewählten Datei.
    end;
  end;```
Alle Dateien speichern, geschieht auf fast die gleiche Weise wie das alle schliessen.<br>
```pascal>  procedure TMyApp.SaveAll;
<br>
    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil); // Das Kommando speicherm mitgeben.
    end;
<br>
  begin
    Desktop^.ForEach(@SendSave);          // Auf alle Fenster anwenden.
  end;```
Die verschiednen Events abfangen und abarbeiten.<br>
Um <b>cmSave</b> und <b>cmSaveAs</b> muss man sich nicht kümmern, das erledigt <b>PEditWindow</b> automatisch für einem.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');   // Leeres Fenster erzeugen.</font>
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
  end;```
<br>
