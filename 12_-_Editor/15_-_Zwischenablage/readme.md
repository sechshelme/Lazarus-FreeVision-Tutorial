# 12 - Editor
## 15 - Zwischenablage
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hier wurde ein Zwischenablage hinzugefügt, somit ist auch kopieren und einfügen im Editor möglich.<br>
Die Zwischeablage ist nicht anderes als ein Editor-Fenster welches die Daten bekommt, wen man kopieren wählt.<br>
Somit kann man dieses sogar sichbar machen.<br>
<hr><br>
Ein Kommando für das öffnen des Zwischenablagefenster.<br>
```pascal>const
  cmNewWin = 1001;
  cmRefresh = 1002;
  cmShowClip = 1003;```
Hier wird das Fenster für die Zwischenablage deklariert.<br>
Auch kann man bei <b>NewWindows</b> sagen, ob das Fenster nicht sichtbar ezeigt werden soll.<br>
```pascal>type
  TMyApp = object(TApplication)
    ClipWindow: PEditWindow;
<br>
    constructor Init;
<br>
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
<br>
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;
<br>
    function NewWindows(FileName: ShortString; Visible: Boolean = False): PEditWindow;
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;```
Im Menü sind die neuen Bearbeiten-Funktionen dazugekommen.<br>
```pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewItem('~O~effnen...', 'F3', kbF3, cmOpen, hcNoContext,
        NewItem('~S~peichern', 'F2', kbF2, cmSave, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('~A~lle speichern', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
      NewSubMenu('~B~earbeiten', hcNoContext, NewMenu(
        NewItem('~R~'#129'ckg'#132'ngig', '', kbAltBack, cmUndo, hcUndo,
        NewLine(
        NewItem('Aus~s~chneiden', 'Shift+Del', kbShiftDel, cmCut, hcCut,
        NewItem('~K~opieren', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
        NewItem('~E~inf'#129'gen', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
        NewItem('~L~'#148'schen', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
        NewLine(
        NewItem('~Z~wischenablage', '', kbNoKey, cmShowClip, hcCut, nil))))))))),
      NewSubMenu('~S~uchen', hcNoContext, NewMenu(
        NewItem('~S~uchen...', 'Ctrl+F', kbCtrlF, cmFind, hcNoContext,
        NewItem('~E~rsetzten...', 'Ctrl+H', kbCtrlH, cmReplace, hcNoContext,
        NewItem('Suche ~n~'#132'chstes', 'Ctrl+N', kbCtrlN, cmSearchAgain, hcNoContext, nil)))),
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
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, nil)))))))))))), nil)))))));
  end;```
Hier sieht man, wie man ein Fenster unsichbar erzeugen kann.<br>
```pascal>  function TMyApp.NewWindows(FileName: ShortString; Visible: Boolean = False) : PEditWindow;
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, FileName, WinCounter));
    if ValidView(Win) <> nil then begin
      if Visible then begin
        win^.Hide;        // Fenster verstecken.
      end;
      Result := PEditWindow(MyApp.InsertWindow(win));
    end else begin
      Dec(WinCounter);
    end;
  end;```
Hier sieht man, wie man das verborgene Zwischenablagefenster sichbar macht.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');
        end;
        cmOpen: begin
          OpenWindows;
        end;
        cmSaveAll: begin
          SaveAll;
        end;
        cmCloseAll: begin
          CloseAll;
        end;
        cmRefresh: begin
          ReDraw;
        end;
        cmShowClip: begin     // Clipboard anzeigen.
          ClipWindow^.Select;
          ClipWindow^.Show;
        end;
        else begin
          Exit;
        end;
      end;
    end;
  end;```
<br>
