//image image.png
(*
<b>TView</b>, ist die unterste Ebene von allen Fenster, Dialog, Button, etc.
Au diesem Grund habe ich dieses kleine Beispiel von <b>TView</b> gemacht.
An diesem View sind keinerlei Änderungen möglich, da noch keine Event, Steurerelemente vorhanden sind.
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
  Menus;

type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure OutOfMemory; virtual;

    procedure NewView;
  end;

(*
Im Konstructor wird das View erzeugt.
*)
//code+
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewView;          // View erzeugen.
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
      NewStatusKey('~F10~ Menu', kbF10, cmMenu, nil)), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)), nil))));
  end;

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Es wird ein einfaches View erzeugt, wie erwarte sieht man nicht viel, ausser eines grauen Rechteckes.
*)
  //code+
  procedure TMyApp.NewView;
  var
    Win: PView;
    Rect: TRect;
  begin
    Rect.Assign(10, 5, 60, 20);
    Win := New(PView, Init(Rect));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
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
