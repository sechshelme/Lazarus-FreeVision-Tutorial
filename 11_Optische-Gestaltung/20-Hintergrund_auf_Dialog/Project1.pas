//image image.png
(*
Bei Bedarf, kann man auch ein Hintergrund-Muster auf einen Dialog/Fenster legen.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  MsgBox,   // Messageboxen
  Dialogs;  // Dialoge

const
  cmOption = 1003;      // Parameter

type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TView)
    procedure Draw; virtual;
  end;

  TMyApp = object(TApplication)
    constructor Init;                                  // Neuer Constructor

    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyOption;                                // neue Funktion für einen Dialog.
  end;

  procedure TMyBackground.Draw;
  const
    b1 : array [0..3] of Byte = (196, 193, 196, 194); // obere Backsteinreihe.
    b2 : array [0..3] of Byte = (196, 194, 196, 193); // untere Backsteinreihe.

  var
    Buf1, Buf2: TDrawBuffer;
    i: integer;
  begin
    for i := 0 to Size.X - 1 do begin
      Buf1[i] := b1[i mod 4] + $46 shl 8;
      Buf2[i] := b2[i mod 4] + $46 shl 8;
    end;

    for i := 0 to Size.Y div 2 do begin
      WriteLine(0, i * 2 + 0, Size.X, i * 2 + 1, Buf1);
      WriteLine(0, i * 2 + 1, Size.X, i * 2 + 2, Buf2);
    end;
  end;

  constructor TMyApp.Init;
  var
    Rect: TRect;
  begin
    inherited Init;                                   // Vorfahre aufrufen
    GetExtent(Rect);

    DeskTop^.Insert(New(PMyBackground, Init(Rect)));  // Hintergrund einfügen.
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
      NewStatusKey('~F1~ About...', kbF1, cmOption, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~P~arameter...', '', kbF2, cmOption, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmOption: begin
          MyOption;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

(*
Hier wird der <b>PBackGround</b> auf einen Dialog gelegt, dies funktioniert genau gleich, wie auf dem Desktop.
Dies kann auch der benutzerdefiniert <b>PMyBackground</b> sein.
*)
//code+
  procedure TMyApp.MyOption;
  var
    Dia: PDialog;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 35, 15);
    Rect.Move(23, 3);
    Dia := New(PDialog, Init(Rect, 'Parameter'));

    with Dia^ do begin

      // BackGround
      GetExtent(Rect);
      Rect.Grow(-1, -1);
      Dia^.Insert(New(PBackGround, Init(Rect, #3)));  // Hintergrund einfügen.

      // Ok-Button
      Rect.Assign(20, 11, 30, 13);
      Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
    end;

    if ValidView(Dia) <> nil then begin
      Desktop^.ExecView(Dia);
      Dispose(Dia, Done);
    end;
  end;
//code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
