unit HGM.GraphQL.Method;

interface

uses
  System.Generics.Collections, System.SysUtils, HGM.GraphQL.Types, HGM.GraphQL.Fields;

type
  TGraphMethod = class
  private
    FName: string;
    FFields: TGraphFields;
    FArgs: TGraphArgList;
    procedure SetArgs(const Value: TGraphArgList);
    procedure SetFields(const Value: TGraphFields);
    procedure SetName(const Value: string);
  public
    property Name: string read FName write SetName;
    property Args: TGraphArgList read FArgs write SetArgs;
    property Fields: TGraphFields read FFields write SetFields;
    function ToString: string; reintroduce;
    destructor Destroy; override;
  end;

  TGraphMethods = class(TObjectList<TGraphMethod>)
    constructor Create; reintroduce;
    function ToString: string; reintroduce;
  end;

implementation

{ TGraphMethod }

destructor TGraphMethod.Destroy;
begin
  if Assigned(FArgs) then
    FArgs.Free;
  if Assigned(FFields) then
    FFields.Free;
  inherited;
end;

procedure TGraphMethod.SetArgs(const Value: TGraphArgList);
begin
  FArgs := Value;
end;

procedure TGraphMethod.SetFields(const Value: TGraphFields);
begin
  FFields := Value;
end;

procedure TGraphMethod.SetName(const Value: string);
begin
  FName := Value;
end;

function TGraphMethod.ToString: string;
begin
  Result := FName + ' ';
  if Assigned(FArgs) then
    Result := Result + FArgs.ToString + ' ';
  if Assigned(FFields) then
    Result := Result + FFields.ToString + ' ';
end;

{ TGraphMethods }

constructor TGraphMethods.Create;
begin
  inherited Create;
end;

function TGraphMethods.ToString: string;
var
  i: Integer;
begin
  for i := 0 to Pred(Count) do
    Result := Result + Items[i].ToString + ', ';
  Result := '{' + Result.TrimRight([',', ' ']) + '}';
end;

end.

