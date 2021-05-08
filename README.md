# GraphQL
 GraphQL Query Constructor

```Pascal
with TGraphQuery.Create('query', 'query_name') do
  begin
    AddMethod('bonuses', 
      //Args
      TGraphArgList.Create
      .AddPair('limit', 1)
      .AddPair('offset', 0)
      .AddPair('filter', TGraphArgObject.Create
        .AddPair('branch_id', 1)
        .AddPair('type', ''))
      .AddPair('sort', TGraphArgObject.Create
        .AddPair('field', 'name')
        .AddPair('order', 'asc')),
      //Fields
      TGraphFields.Create
      .AddField(TGraphField.Create('result'))
      .AddField(TGraphField.Create('items')
        .AddSub(TGraphField.Create('id'))
        .AddSub(TGraphField.Create('date')))
      .AddField(TGraphField.Create('totalCount')));
    ShowMessage(ToString);
    Free;
  end;
  ```
