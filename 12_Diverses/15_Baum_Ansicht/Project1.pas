//image image.png
(*
Baumartige Darstellung.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  Dialogs,  // Dialoge
  Outline;  // Baumansicht

const
  cmList = 1001;     // About anzeigen

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;

(*
Für die Baumartige Darstellung verwendet man die Komponente <b>POutline</b>.
*)

//code+
  PTreeWindow = ^TTreeWindow;
  TTreeWindow = object(TWindow)
    constructor Init(Rect: TRect);
  end;


  constructor TTreeWindow.Init(Rect: TRect);
  var
    Outline: POutline;
  begin
    inherited Init(Rect, 'Computer', wnNoNumber);
    Options := Options or ofTileable;
    GetExtent(Rect);
    Rect.Grow(-1, -1);
    Outline := New(POutline, Init(Rect, StandardScrollBar(sbHorizontal), StandardScrollBar(sbVertical),
      NewNode('Computer',
        NewNode('IBM',
          NewNode('XT', nil,
          NewNode('AT', nil,
          NewNode('PS2', nil, nil))),
        NewNode('Mac',
          NewNode('Lisa', nil,
          NewNode('iMac', nil, nil)),
        NewNode('Amiga',
          NewNode('500', nil,
          NewNode('1000', nil, nil)), nil))), nil)));
    Insert(Outline);
  end;
//code-


  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Baum', kbF2, cmList, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                       // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext,
        NewMenu(NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~B~aum', hcNoContext,
        NewMenu(NewItem('~A~nsicht...', '', kbNoKey, cmList, hcNoContext, nil)), nil)))));
  end;

(*
Hier wird das Fenster erzeugt, welches die Outline enthält.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    Rect:TRect;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmList: begin
          Rect.Assign(2, 2, 35, 17);
          InsertWindow(New(PTreeWindow, Init(Rect)));
        end
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
end.
