unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  WMView, WMDesktop, WMButton, WMMenu;

type

  { TToolBar }

  TToolBar = class(TView)
    constructor Create; override;
    procedure AddButton(const ACaption: string; ACommand: integer);
  end;

{ TApplication }

type
  TApplication = class(TView)
  private
  protected
    procedure SetHeight(AValue: integer); override;
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;
    Menu: TMenuWindow;
    constructor Create; override;
    procedure EventHandle(var Event: TEvent); override;
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
  Top := rand;
  Height := rand;
  Anchors := [akLeft, akRight, akTop];
  Caption := 'ToolBar';
end;

procedure TToolBar.AddButton(const ACaption: string; ACommand: integer);
var
  btn: TButton;
begin
  btn := TButton.Create;
  btn.Top := BorderSize;
  btn.Left := Length(View) * 80 + BorderSize;
  btn.Caption := ACaption;
  btn.Command := ACommand;
  InsertView(btn);
end;


{ TApplication }

procedure TApplication.SetHeight(AValue: integer);
begin
  inherited SetHeight(AValue);
  if (Menu <> nil) and (ToolBar <> nil) and (Desktop <> nil) then begin
    ToolBar.Top := Menu.MenuBar.Height;
    Desktop.Top := Menu.MenuBar.Height + ToolBar.Height;
    Desktop.Height := Height - Menu.MenuBar.Height - ToolBar.Height;
  end;
end;

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Menu := TMenuWindow.Create;
  InsertView(Menu);

  ToolBar := TToolBar.Create;
//  ToolBar.Top := Menu.Height;
  InsertView(ToolBar);

  Desktop := TDesktop.Create;
//  Desktop.Top := Menu.Height + ToolBar.Height;
//  Desktop.Height := Height - 2 * rand;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  InsertView(Desktop);
end;

procedure TApplication.EventHandle(var Event: TEvent);
var
  ev: TEvent;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Command of
        cmQuit: begin
          Form1.Close;
        end;
        cmClose: begin
          Desktop.DeleteView(0);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #0: begin
          case Event.DownKey of
            121: begin   // F10
              if Event.shift = [] then begin
                FirstView(Menu);
                Menu.MenuBar.ShowCursor;
              end;
            end;
          end;
        end;
      end;
      ev.What := whRepaint;
      EventHandle(ev);
    end;
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Canvas);
    end;
    else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
