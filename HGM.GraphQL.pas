unit HGM.GraphQL;

interface

uses
  System.Classes, REST.Client, REST.Json.Types, System.StrUtils, REST.Types, System.SysUtils, System.JSON,
  HGM.GraphQL.Query;

type
  TGraphQLClient = class(TComponent)
  private
    FClient: TRESTClient;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Call(out Response: TJSONObject; Query: TGraphQuery; Variables: TJSONObject = nil): Integer; overload;
    function Call(out Response: TJSONObject; const OperationName, Query: string; Variables: TJSONObject = nil): Integer; overload;
    function Call(const OperationName, Query: string; Variables: TJSONObject = nil): Integer; overload;
    property Client: TRESTClient read FClient;
  end;

implementation

uses
  System.NetConsts;

{ TGraphQLClient }

function TGraphQLClient.Call(out Response: TJSONObject; const OperationName, Query: string; Variables: TJSONObject): Integer;
var
  Body: TJSONObject;
  Request: TRESTRequest;
begin
  Response := nil;
  Body := TJSONObject.Create;
  Body.AddPair('operationName', OperationName);
  Body.AddPair('query', Query);
  if Assigned(Variables) then
    Body.AddPair('variables', Variables);
  Request := TRESTRequest.Create(nil);
  Request.Client := Client;
  try
    //raise Exception.Create(Body.ToJSON);
    Request.AddBody(Body);
    Request.Method := TRESTRequestMethod.rmPOST;
    Request.Execute;
    with Request.Response do
    begin
      Response := TJSONObject(TJSONObject.ParseJSONValue(Content));
      Result := StatusCode;
    end;
  finally
    Request.Free;
    Body.Free;
  end;
end;

function TGraphQLClient.Call(const OperationName, Query: string; Variables: TJSONObject): Integer;
var
  Response: TJSONObject;
begin
  Result := Call(Response, OperationName, Query, Variables);
  if Assigned(Response) then
    Response.Free;
end;

function TGraphQLClient.Call(out Response: TJSONObject; Query: TGraphQuery; Variables: TJSONObject): Integer;
begin
  Result := Call(Response, Query.Name, Query.ToString, Variables);
end;

constructor TGraphQLClient.Create(AOwner: TComponent);
begin
  inherited;
  FClient := TRESTClient.Create(nil);
  FClient.RaiseExceptionOn500 := False;
  FClient.ContentType := CONTENTTYPE_APPLICATION_JSON;
end;

destructor TGraphQLClient.Destroy;
begin
  FClient.Free;
  inherited;
end;

end.

