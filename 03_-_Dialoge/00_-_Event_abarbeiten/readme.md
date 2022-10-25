# 03 - Dialoge
## 00 - Event abarbeiten
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Abarbeiten der Events, der Statuszeile und des Menu.<br>
<hr><br>
Kommmandos die abgearbeitet werden.<br>
<pre><code=pascal>const
  cmAbout = 1001;     // About anzeigen</font>
  cmList = 1002;      // Datei Liste</font></code></pre>
Der EventHandler ist auch ein Nachkommen.<br>
<pre><code=pascal>type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;</code></pre>
Abarbeiten der eigenen cmxxx Kommandos.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
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
  end;</code></pre>
<br>
