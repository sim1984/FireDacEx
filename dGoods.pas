unit dGoods;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet,
  dMain;

type
  TProductRecord = record
    PRODUCT_ID: TIntegerField;
    NAME: TWideStringField;
    PRICE: TFloatField;
    DESCRIPTION: TFDWideMemoField;
  end;

  TdmGoods = class(TDataModule)
    qryGoods: TFDQuery;
    qryGoodsPRODUCT_ID: TIntegerField;
    qryGoodsNAME: TWideStringField;
    qryGoodsPRICE: TFloatField;
    qryGoodsDESCRIPTION: TFDWideMemoField;
    FDUpdateGoods: TFDUpdateSQL;
    trWrite: TFDTransaction;
    DataSource: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    FProduct: TProductRecord;
  public
    procedure Open;
    procedure Close;
    procedure Refresh;
    procedure Add;
    procedure Edit;
    procedure Delete;
    procedure Post;
    procedure Cancel;
    procedure Save;

    property Product: TProductRecord read FProduct;
  end;

var
  dmGoods: TdmGoods;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}
{ TdmGoods }

procedure TdmGoods.Add;
begin
  qryGoods.CachedUpdates := True;
  qryGoods.Insert;
end;

procedure TdmGoods.Cancel;
begin
  qryGoods.Cancel;
  qryGoods.CancelUpdates;
  qryGoods.CachedUpdates := False;
end;

procedure TdmGoods.Close;
begin
  qryGoods.Close;
end;

procedure TdmGoods.DataModuleCreate(Sender: TObject);
begin
  FProduct.PRODUCT_ID := qryGoodsPRODUCT_ID;
  FProduct.NAME := qryGoodsNAME;
  FProduct.PRICE := qryGoodsPRICE;
  FProduct.DESCRIPTION := qryGoodsDESCRIPTION;
end;

procedure TdmGoods.Delete;
begin
  qryGoods.CachedUpdates := True;
  qryGoods.Delete;
end;

procedure TdmGoods.Edit;
begin
  qryGoods.CachedUpdates := True;
  qryGoods.Edit;
end;

procedure TdmGoods.Open;
begin
  qryGoods.Open;
end;

procedure TdmGoods.Post;
begin
  qryGoods.Post;
end;

procedure TdmGoods.Refresh;
begin
  qryGoods.Refresh;
end;

procedure TdmGoods.Save;
begin
  try
    // We do everything in a short transaction
    // In CachedUpdates mode error does not stop running.
    // ApplyUpdates method returns the number of errors.
    // The error can be obtained from the property RowError
    trWrite.StartTransaction;
    if (qryGoods.ApplyUpdates = 0) then
    begin
      qryGoods.CommitUpdates;
      trWrite.Commit;
    end
    else
      raise Exception.Create(qryGoods.RowError.Message);
    qryGoods.CachedUpdates := False;
  except
    on E: Exception do
    begin
      if trWrite.Active then
        trWrite.Rollback;
      raise;
    end;
  end;
end;

end.
