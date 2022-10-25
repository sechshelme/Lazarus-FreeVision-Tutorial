# 12 - Editor
## 00 - Einfaches Editor-Fenster
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Das Fenster ist nun ein Text-Editor, das man diese Funktion erreicht, nimmt man ein <b>PEditWindow</b>.<br>
Die Verwaltung der Fenster ist gleich, wie bei einem <b>TWindow</b>.<br>
<hr><br>
Einfügen eines leeren Editorfensters.<br>
<pre><code=pascal>  procedure TMyApp.NewWindows;
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster</font>
  begin
    R.Assign(0, 0, 60, 20);</font>
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, '', WinCounter));</font>
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
  end;</code></pre>
<br>
