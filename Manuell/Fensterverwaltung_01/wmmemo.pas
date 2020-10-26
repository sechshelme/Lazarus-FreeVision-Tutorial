unit WMMemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMSystem,  WMView, WMButton, WMWindow;

type

  { TMemo }

  TMemo = class(TView)
  private
    sl: TStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure EventHandle(var Event: TEvent); override;
    procedure Draw; override;
  end;

implementation

{ TMemo }

constructor TMemo.Create;
begin
  inherited Create;
  Width := 75;
  Height := 25;
  sl := TStringList.Create;
  sl.SkipLastLineBreak:=True;
  Color:=clBlue;
  Bitmap.Canvas.Font.Color:=clYellow;
end;

destructor TMemo.Destroy;
begin
  sl.Free;
  inherited Destroy;
end;

procedure TMemo.EventHandle(var Event: TEvent);
var
  p: TPoint;
  x, y: PtrInt;
  ev: TEvent;
begin
  case Event.What of
    whMouse: begin
      p := calcOfs;
      x := Event.x;
      y := Event.y;
      case Event.MouseCommand of
        EvMouseDown: begin
        end;
        EvMouseUp: begin
        end;
        EvMouseMove: begin
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #0: begin
          case Event.DownKey of
            37: begin
            end;
            39: begin
            end;
          end;
        end;
        #13: begin
          sl.Add('');
          ev.What := whRepaint;
          EventHandle(ev);
        end;
         'A'..'z': begin
          sl.Text := sl.Text + Event.PressKey;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end else begin
    end;
  end;
  inherited EventHandle(Event);
end;

procedure TMemo.Draw;
var
  i: integer;
begin
  inherited Draw;
  for i := 0 to sl.Count - 1 do begin
    Bitmap.Canvas.TextOut(0, i * 20, sl[i]);
  end;
end;

end.
