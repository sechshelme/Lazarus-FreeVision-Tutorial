program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  TMyForm = class(TForm)
  private
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

  { TMyForm }

  procedure TMyForm.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  begin
    WriteLn(Key);  // kommt immer 255
  end;

  procedure TMyForm.FormKeyPress(Sender: TObject; var Key: char);
  begin
    WriteLn(Key);  // geht
  end;

  constructor TMyForm.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    OnKeyDown := @FormKeyDown;
    OnKeyPress := @FormKeyPress;
  end;

var
  App: TMyForm;

begin
//  Application.Scaled:=True;
  Application.Initialize;
  App := TMyForm.Create(nil);
  App.ShowModal;
  App.Free;
end.
