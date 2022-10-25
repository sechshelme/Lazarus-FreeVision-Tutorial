# 01 - Einfuehrung
## 10 - Hello World
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Ein Hello World mit Free-Vision.<br>
Der Text wird in einer Message-Box ausgegeben.<br>
<hr><br>
<pre><code=pascal>program Project1;
<br>
uses
  App, MsgBox;
var
  MyApp: TApplication;
<br>
begin
  MyApp.Init;
  MessageBox('Hello World !', nil, mfOKButton);</font>
  // MyApp.Run;   // Wen es weiter gehen soll.
  MyApp.Done;
end.</code></pre>
<br>
