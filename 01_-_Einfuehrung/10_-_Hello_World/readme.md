# 01 - Einfuehrung
## 10 - Hello World

![image.png](image.png)

Ein Hello World mit Free-Vision.
Der Text wird in einer Message-Box ausgegeben.
---

```pascal
program Project1;

uses
  App, MsgBox;
var
  MyApp: TApplication;

begin
  MyApp.Init;
  MessageBox('Hello World !', nil, mfOKButton);
  // MyApp.Run;   // Wen es weiter gehen soll.
  MyApp.Done;
end.
```


