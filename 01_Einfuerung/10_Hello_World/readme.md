<html>
    <b><h1>01 Einfuerung</h1></b>
    <b><h2>04 Hello World</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Ein Hello World mit Free-Vision.<br>
Der Text wird in einer Message-Box ausgegeben.<br>
<hr><br>
<pre><code><b><font color="0000BB">program</font></b> Project1;
<br>
<b><font color="0000BB">uses</font></b>
  App, MsgBox;
<b><font color="0000BB">var</font></b>
  MyApp: TApplication;
<br>
<b><font color="0000BB">begin</font></b>
  MyApp.Init;
  MessageBox(<font color="#FF0000">'Hello World !'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
  <i><font color="#FFFF00">// MyApp.Run;   // Wen es weiter gehen soll.</font></i>
  MyApp.Done;
<b><font color="0000BB">end</font></b>.</code></pre>
<br>
</html>
