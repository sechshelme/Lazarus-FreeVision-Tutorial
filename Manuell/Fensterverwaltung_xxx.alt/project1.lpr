program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  TMyForm = class(TForm)
  private
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

  TApplication = class(TObject)
  private
    Form: TMyForm;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

  { TApplication }

  constructor TApplication.Create;
  begin
    inherited Create;
    Form := TMyForm.Create(nil);
  end;

  destructor TApplication.Destroy;
  begin
    Form.Free;
    inherited Destroy;
  end;

  procedure TApplication.Run;
  begin
    Form.ShowModal;
  end;

  { TMyForm }

  procedure TMyForm.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  begin
    WriteLn(Key);
  end;

  procedure TMyForm.FormKeyPress(Sender: TObject; var Key: char);
  begin
    WriteLn(Key);
  end;

  constructor TMyForm.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    OnKeyDown := @FormKeyDown;
    OnKeyPress := @FormKeyPress;
  end;


var
  App: TApplication;

begin
  App := TApplication.Create;
  App.Run;
  App.Free;
end.
