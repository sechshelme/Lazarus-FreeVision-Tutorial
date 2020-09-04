//image image.png
(*
Wen man die Farbe des Hintergrundes änder will, ist ein wenig komplizierter als nur das Zeichen.
Dazu muss man beim Object <b>TBackground</b> die Funktion <b>GetPalette</b> überschreiben.

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

(*
Für das Object <b>TBackground</b> wird ein Nachkomme erzeugt, welcher eine neue <b>GetPalette</b> Funktion bekommt.
*)
//code+
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TBackGround)
    function GetPalette: PPalette; virtual; // neu GetPalette
  end;
//code-


  TMyApp = object(TApplication)
    constructor Init;                                  // Neuer Constructor

    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyOption;                                // neue Funktion für einen Dialog.
  end;

(*
In der neuen Funktion wird eine andere Palette zugeordnet.
*)
//code+
  function TMyBackground.GetPalette: PPalette;
  const
    P: string[1] = #74;
  begin
    Result := @P;
  end;
//code-

(*
Der Konstruktor sieht fast gleich aus wie beim Hintergrundzeichen.
Einziger Unterschied anstelle von <b>PBackGround</b> wird <b>PMyBackground</b> genommen.
*)
//code+
  constructor TMyApp.Init;
  var
    Rect:TRect;
  begin
    inherited Init;                                       // Vorfahre aufrufen
    GetExtent(Rect);

    DeskTop^.Insert(New(PMyBackground, Init(Rect, #3)));  // Hintergrund einfügen.
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

  procedure TMyApp.MyOption;
  var
    Dia: PDialog;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 35, 15);
    Rect.Move(23, 3);
    Dia := New(PDialog, Init(Rect, 'Parameter'));
    if ValidView(Dia) <> nil then begin // Prüfen ob genügend Speicher.
      Desktop^.ExecView(Dia);           // Dialog ausführen.
      Dispose(Dia, Done);               // Dialog und Speicher frei geben.
    end;
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
