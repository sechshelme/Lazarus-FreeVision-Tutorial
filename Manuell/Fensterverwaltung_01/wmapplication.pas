unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  WMView, WMDesktop, WMButton;

type

  { TToolBar }

  TToolBar = class(TView)
    constructor Create; override;
  end;

{ TApplication }

type
  TApplication = class(TView)
  private
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;

    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

uses
  Unit1;  //????????????????????????????????????????????'''''

const
  rand = 40;

{ TToolBar }

constructor TToolBar.Create;
begin
  inherited Create;
  Color := clGray;

  //ToolBar := TToolBar.Create;
  Top := 0;
  Height := rand;
  Anchors := [akLeft, akRight, akTop];
  ////  ToolBar.Color := clGreen;
  Caption := 'ToolBar';
  //Insert(ToolBar);

end;


{ TApplication }

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Desktop := TDesktop.Create;
  Desktop.Top := rand;
  Desktop.Height := Height - 2 * rand;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  Insert(Desktop);

  ToolBar:=nil;

  //ToolBar := TToolBar.Create;
  //ToolBar.Top := 0;
  //ToolBar.Height := rand;
  //ToolBar.Anchors := [akLeft, akRight, akTop];
  ////  ToolBar.Color := clGreen;
  //ToolBar.Caption := 'ToolBar';
  //Insert(ToolBar);
end;

procedure TApplication.EventHandle(Event: TEvent);
var
  ev: TEvent;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Value0 of
        cmQuit: begin
          //        Delete(nil);
          Form1.Close;
          //        ev.What := whRepaint;
          //        EventHandle(ev);
        end;
        cmClose: begin
          Desktop.Delete(nil);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Panel1.Canvas);
    end;
  end;
  inherited EventHandle(Event);
end;

end.




