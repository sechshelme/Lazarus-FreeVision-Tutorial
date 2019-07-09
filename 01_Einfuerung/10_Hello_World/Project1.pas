//image image.png
(*
Ein Hello World mit Free-Vision.
Der Text wird in einer Message-Box ausgegeben.
*)
//lineal
//code+
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
//code-

