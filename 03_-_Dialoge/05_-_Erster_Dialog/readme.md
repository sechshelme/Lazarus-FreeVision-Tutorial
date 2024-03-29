# 03 - Dialoge
## 05 - Erster Dialog

![image.png](image.png)

Abarbeiten der Events, der Statuszeile und des Menu.

---
Für Dialoge muss man noch die Unit **Dialogs** einfügen.

```pascal
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  Dialogs;  // Dialoge
```

Ein weiteres Kommando für den Aufruf des Dialoges.

```pascal
const
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
  cmPara = 1003;      // Parameter
```

Neue Funktionen kommen auch in die Klasse.
Hier ein Dialog für Paramtereingabe.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;
```

Das Menü wird um Parameter und Schliessen erweitert.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rechteck für die Menüzeilen-Position.

    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M0_3, M0_4, M0_5,
    M1_0: PMenuItem;                   // Einfache Menüpunkte

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

    M0_5 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_1 := NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext, M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
```

Hier wird mit dem Kommando **cmPara** ein Dialog geöffnet.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmList: begin
        end;
        cmPara: begin     // Parameter Dialog öffnen.
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```

Bauen eines leeren Dialoges.
Auch da wird **TRect** gebraucht für die Grösse.
Dies wird bei allen Komponenten gebraucht, egal ob Button, etc.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dlg := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.
    Desktop^.Insert(Dlg);                      // Dialog der App zuweisen.
  end;
```


