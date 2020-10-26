unit WMSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls;

const
  cmNone = 0;
  cmClose = 1;
  cmQuit = 2;

  cmTest0 = 100;
  cmTest1 = 101;
  cmTest2 = 102;
  cmTest3 = 103;
  cmopti0 = 104;
  cmopti1 = 105;
  cmopti2 = 106;

  EvMouseDown = 0;
  EvMouseUp = 1;
  EvMouseMove = 2;

const
  BorderSize = 7;
  TitelBarSize = BorderSize * 5;
  minWinSize = 50;

type

  TEvent = record
    What: (whNone, whMouse, whKeyPress, whcmCommand, whMenuCommand, whRepaint);
    case integer of
      whNone: (Value0, Value1, Value2, Value3: PtrInt);
      whMouse: (MouseCommand, x, y: PtrInt);
      whKeyPress: (PressKey: char;
        DownKey: byte;
        shift: TShiftState);
      whcmCommand: (Command: PtrInt);
      whMenuCommand: (Index, Left, Top: PtrInt;
        Sender: TObject);
      whRepaint: (was: (all, Windows));
  end;

  TEventHandle = procedure(var Event: TEvent) of object;

  { TSystem }

  TSystem = class(TForm)
  private
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
  public
    OnEventHandle: TEventHandle;
    constructor Create(TheOwner: TComponent); override;
  end;


implementation

{ TSystem }

constructor TSystem.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Application.Initialize;
//  Application.Scaled:=True;
  Position := poDesktopCenter;
  DoubleBuffered := True;
  OnPaint := @FormPaint;
  OnKeyDown := @FormKeyDown;
  OnKeyPress := @FormKeyPress;
  OnMouseDown := @FormMouseDown;
  OnMouseMove := @FormMouseMove;
  OnMouseUp := @FormMouseUp;
  OnEventHandle := nil;
end;

procedure TSystem.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    if Key in [33..46, 112..123] then begin
      ev.What := whKeyPress;
      ev.PressKey := #0;
      ev.DownKey := Key;
      ev.shift := Shift;
      OnEventHandle(ev);
    end;
  end;
end;

procedure TSystem.FormKeyPress(Sender: TObject; var Key: char);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    ev.What := whKeyPress;
    ev.PressKey := Key;
    OnEventHandle(ev);
  end;
  Key := #0;
end;

procedure TSystem.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    if ssLeft in Shift then begin
      ev.What := whMouse;
      ev.MouseCommand := EvMouseDown;
      ev.x := x;
      ev.y := y;
      OnEventHandle(ev);
    end;
  end;
end;

procedure TSystem.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    if ssLeft in Shift then begin
      ev.What := whMouse;
      ev.MouseCommand := EvMouseMove;
      ev.x := x;
      ev.y := y;
      OnEventHandle(ev);
    end;
  end;
end;

procedure TSystem.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    ev.What := whMouse;
    ev.MouseCommand := EvMouseUp;
    ev.x := x;
    ev.y := y;
    OnEventHandle(ev);
  end;
end;

procedure TSystem.FormPaint(Sender: TObject);
var
  ev: TEvent;
begin
  if OnEventHandle <> nil then begin
    ev.What := whRepaint;
    OnEventHandle(ev);
  end;
end;

end.
