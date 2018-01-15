//image image.png
(*
Man kann auch eine Komponente modifzieren, in diesem Beispiel ist es ein Button.
Dazu muss man einen Nachkommen von TButton erstellen.
Der abgeänderte Button passt sich automatisch an die Länge des Titels an, auch wird er automatisch 2 Zeilen hoch.
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
  MyButton; // der neue Button

const
  cmPara = 1003;      // Parameter

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
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
        NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))), nil))));

  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmPara: begin
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

(*
Anstelle des normalen Button nehme ich jetzt den PMyButton.
Man sieht auch, das man anstelle von Rect, nur X und Y angibt.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    Rect.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(Rect, 'Parameter')); // Dialog erzeugen.
    with Dia^ do begin
      // oben
      Insert(new(PMyButton, Init(7, 8, 'sehr langer ~T~ext', cmValid, bfDefault)));

      // mitte
      Insert(new(PMyButton, Init(7, 4, '~k~urz', cmValid, bfDefault)));

      // Ok-Button
      Insert(new(PMyButton, Init(7, 12, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      Insert(new(PMyButton, Init(19, 12, '~A~bbruch', cmCancel, bfNormal)));
    end;
    Desktop^.ExecView(Dia);   // Dialog Modal öffnen.
    Dispose(Dia, Done);       // Dialog und Speicher frei geben.
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
<b>Unit mit dem neuen Button.</b>
<br>
Hier wird gezeigt, wie man einen Button abänder kann.
*)
//includepascal mybutton.pas head

(*
Deklaration des neuen Buttons.
Hier sieht man, das man den Konstruktor überschreiben muss.
*)
//includepascal mybutton.pas type

(*
Im Konstruktor sieht man, das aus <b>X</b> und <b>Y</b> ein <b>Rect</b> generiert wird.
<b>StringReplace</b> werden noch die ~ gelöscht, da diese sonst die Länge des Stringes verfälschen.
*)
//includepascal mybutton.pas init

end.
