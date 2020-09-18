unit WMDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMWindow;

type

  { TDialog }

  TDialog = class(TWindow)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

constructor TDialog.Create;
begin
  inherited Create;
  FColor := clLtGray;
end;

destructor TDialog.Destroy;
begin
  inherited Destroy;
end;

procedure TDialog.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
end;

end.


