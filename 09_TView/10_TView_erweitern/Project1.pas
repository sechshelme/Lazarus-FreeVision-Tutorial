//image image.png
(*
<b>TView</b>, ist die unterste Ebene von allen Fenster, Dialog, Button, etc.
Au diesem Grund habe ich dieses kleine Beispiel von <b>TView</b> gemacht.
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
  Menus,
  MyView;

const
  cmNewWin = 1001;
  cmRefresh = 1002;
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    procedure NewWindows;
    procedure CloseAll;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Fenster erzeugen.
  end;

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(Rect);          // Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.
    Rect.A.Y := Rect.B.Y - 1; // Position der Statuszeile, auf unterste Zeile der App setzen.

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
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
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, nil)))))))))))), nil)))));

  end;

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.
Wen man bei den Fenster eine überlappend oder nebeneinader Darstellung will, muss man noch den Status <b>ofTileable</b> setzen.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PMyView;
    Rect: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Fenster
  begin
    Rect.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PMyView, Init(Rect));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
  //code-

(*
Da es im View keine <b>cmClose</b> Abarbeitung gibt, wird manuell in einer Schleife überprüft, ob es Fenster gibt, wen ja, löschen.
*)
//code+
procedure TMyApp.CloseAll;
var
  v: PView;
begin
  v := Desktop^.Current;   // Gibt es Fenster ?
  while v <> nil do begin
    Desktop^.Delete(v);    // Fenster löschen.
    v := Desktop^.Current;
  end;
end;
//code-

(*
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft im Hintergrund automatisch.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows;    // Fenster erzeugen.
        end;
        cmRefresh: begin
          ReDraw;        // Anwendung neu zeichnen.
        end;
        cmCloseAll: begin
          CloseAll;
        end;
        cmClose: begin
          if Desktop^.Current <> nil then  Desktop^.Delete(Desktop^.Current);
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben

//lineal
(*
<b>Unit mit dem neuen Dialog.</b>
<br>
Mit den 3 oberen Button, kann man das Farb-Schema des Dialoges ändern.
*)
//includepascal myview.pas head

(*
Hier sind 3 Event-Konstante hinzugekommen.
*)
//includepascal myview.pas type

(*
Das Bauen des Dialoges ist nichts besonderes.
*)
//includepascal myview.pas init

(*
Hier werden die Farb-Schemas mit Hilfe von <b>Palette := dpxxx</b> geändert.
Auch hier ist wichtig, das man <b>Draw</b> aufruft, diemal nicht für eine Komponente, sonder für den ganzen Dialog.
*)
//includepascal myview.pas handleevent

end.
