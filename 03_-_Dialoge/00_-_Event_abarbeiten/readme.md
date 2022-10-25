# 03 - Dialoge
## 00 - Event abarbeiten

<img src="image.png" alt="Selfhtml"><br><br>
Abarbeiten der Events, der Statuszeile und des Menu.

<hr><br>
Kommmandos die abgearbeitet werden.


```pascal
const
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
```

Der EventHandler ist auch ein Nachkommen.


```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;
```

Abarbeiten der eigenen cmxxx Kommandos.


```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin    // Mache was mit cmAbout.
        end;
        cmList: begin     // Mache was mit cmList.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


