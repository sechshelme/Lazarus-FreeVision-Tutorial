//image image.png
(*
Das Fenster ist nun ein Text-Editor, das man diese Funktion erreicht, nimmt man ein <b>PEditWindow</b>.
Die Verwaltung der Fenster ist gleich, wie bei einem <b>TWindow</b>.
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
  Menus;    // Füe das eigene Fenster.

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
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

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
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));

  end;

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Einfügen eines leeren Editorfensters.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PEditWindow;
    Rect: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    Rect.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(Rect, '', WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
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

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
      cmNewWin: begin
        NewWindows;    // Fenster erzeugen.
      end;
      cmCloseAll:begin
        CloseAll;      // Schliesst alle Fenster.
      end;
      cmRefresh: begin
        ReDraw;        // Anwendung neu zeichnen.
      end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
