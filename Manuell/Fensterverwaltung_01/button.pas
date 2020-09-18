unit Button;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,

  View;

type
  { TButton2 }

  TButton2 = class(TView)
  private
    FCommand: integer;
  public
    property Command: integer read FCommand write FCommand;
    constructor Create; override;
    function MouseDown(x, y: integer): boolean; override;
    procedure Draw; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

{ TButton }

constructor TButton2.Create;
begin
  inherited Create;
  Color := clYellow;
end;

function TButton2.MouseDown(x, y: integer): boolean;
var
  ev: TEvent;
begin
  Result := inherited MouseDown(x, y);
  if Result then begin
    Color := Random($FFFFFF);
    Panel.Repaint;

    ev.State := Mouse;
    ev.Command := FCommand;
    EventHandle(ev);
  end;
end;

procedure TButton2.Draw;
begin
  inherited Draw;
  Bitmap.Canvas.TextOut(3, 1, Caption);
end;

procedure TButton2.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
end;

end.


