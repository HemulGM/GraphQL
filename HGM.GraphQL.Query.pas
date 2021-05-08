unit HGM.GraphQL.Query;

interface

uses
  HGM.GraphQL.Types, HGM.GraphQL.Fields, HGM.GraphQL.Method;

type
  TGraphQuery = class
  private
    FMethods: TGraphMethods;
    FName: string;
    FType: string;
    procedure SetMethods(const Value: TGraphMethods);
  public
    procedure AddMethod(const Name: string; Args: TGraphArgList; Fields: TGraphFields);
    property Methods: TGraphMethods read FMethods write SetMethods;
    property Name: string read FName;
    constructor Create(const AType, AName: string); reintroduce;
    destructor Destroy; override;
    function ToString: string; reintroduce;
    function Query: TGraphQuery;
  end;

implementation

{ TGraphQuery }

procedure TGraphQuery.AddMethod(const Name: string; Args: TGraphArgList; Fields: TGraphFields);
var
  Item: TGraphMethod;
begin
  Item := TGraphMethod.Create;
  Item.Name := Name;
  Item.Args := Args;
  Item.Fields := Fields;
  Methods.Add(Item);
end;

constructor TGraphQuery.Create(const AType, AName: string);
begin
  FMethods := TGraphMethods.Create;
  FType := AType;
  FName := AName;
end;

destructor TGraphQuery.Destroy;
begin
  FMethods.Free;
  FMethods := nil;
  inherited;
end;

function TGraphQuery.Query: TGraphQuery;
begin
  Result := Self;
end;

procedure TGraphQuery.SetMethods(const Value: TGraphMethods);
begin
  FMethods := Value;
end;

function TGraphQuery.ToString: string;
begin
  Result := FType + ' ' + FName + ' ' + FMethods.ToString;
end;

end.

