unit WMButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView;

type
  { TButton }

  TButton = class(TView)
  private
    FCommand: integer;
  public
    property Command: integer read FCommand write FCommand;
    constructor Create; override;
    procedure MouseDown(x, y: integer); override;
    procedure Draw; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

{ TButton }

constructor TButton.Create;
begin
  inherited Create;
  Color := clYellow;
end;

procedure TButton.MouseDown(x, y: integer);
var
  ev: TEvent;
begin
  inherited MouseDown(x, y);

  if isMouseDown then begin
//    Color := Random($FFFFFF);
//    ev.What := whRepaint;
//    EventHandle(ev);

    ev.What := wh;
    ev.Value0 := FCommand;
    EventHandle(ev);
  end;
end;

procedure TButton.Draw;
begin
  inherited Draw;
  Bitmap.Canvas.TextOut(3, 1, Caption);
end;

procedure TButton.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
end;

end.



