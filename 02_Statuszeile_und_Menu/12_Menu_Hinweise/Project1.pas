//image image.png
(*
Hinweise in der Statuszeile der Menü-Punkte.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile

(*
Konstanten der einzelnen Hilfen.
Am besten mimmt man da hcxxx Namen.
*)
//code+
const
  cmList   = 1002;  // Datei Liste
  cmAbout  = 1001;  // About anzeigen

  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
//code-

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;

(*
Die Hint-Zeile muss vererbt werden.
*)
//code+
  PHintStatusLine = ^THintStatusLine;
  THintStatusLine = object(TStatusLine)
    function Hint(AHelpCtx : Word): ShortString; virtual;
  end;

  function THintStatusLine.Hint(AHelpCtx: Word): ShortString;
  begin
    case AHelpCtx of
      hcFile:   Hint := 'Dateien verwalten';
      hcClose:  Hint := 'Programm beenden';
      hcOption: Hint := 'Verschiedene Optionen';
      hcFormat: Hint := 'Format einstellen';
      hcEdit:   Hint := 'Editor Optionen';
      hcHelp:   Hint := 'Hilfe';
      hcAbout:  Hint := 'Entwickler Info';
    else
      Hint := '';
    end;
  end;
// code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PHintStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));
  end;
(*
Im Menü muss die hcxxx Konstante mitgegeben werden.
*)
//code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcFile, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),

      NewSubMenu('~O~ptionen', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~itor', '', kbNoKey, cmAbout, hcEdit, nil))),

      NewSubMenu('~H~ilfe', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))))));
  end;
//code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
