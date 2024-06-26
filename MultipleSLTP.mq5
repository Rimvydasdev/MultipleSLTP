
#property copyright "rimvydasdev@gmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Multiple single-price Stop Loss and Take Profit, simultaneous for all orders"

#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

CTrade sTrade;

#define async sTrade.SetAsyncMode(true);
#define BtnStopLoss "Add SL"
#define BtnTakeProfit "Add TP"
#define TakeProfitInput "Take Profit Input"
#define StopLossInput "Stop Loss Input"

double takeSlValue;
double takeTPValue;

int OnInit()
{
  CreateInput(StopLossInput, "Add SL", 110, 120);
  CreateButton(BtnStopLoss, "Add SL", C'255, 102, 102', 110, 90);
  CreateButton(BtnTakeProfit, "Add TP", C'0, 102, 204', 110, 60);
  CreateInput(TakeProfitInput, "Add TP", 110, 30);
  
  ChartRedraw();
  return (INIT_SUCCEEDED);
}


void OnChartEvent(
    const int id,
    const long &lparam,
    const double &dparam,
    const string &sparam
)
{
  if (id == CHARTEVENT_OBJECT_CLICK)
  {
    HandleButtonClick(sparam);
  }
}

void HandleButtonClick(const string &buttonName)
{
  
  if (buttonName == BtnTakeProfit) {
      string takeTPString = ObjectGetString(0,TakeProfitInput ,OBJPROP_TEXT);
      takeTPValue = StringToDouble(takeTPString);
  async
    for(int i = PositionsTotal() -1; i >= 0; i--) {
        ulong posTicket = PositionGetTicket(i);
        if(PositionSelectByTicket(posTicket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                sTrade.PositionModify(posTicket,PositionGetDouble(POSITION_SL),takeTPValue);
                Print(" > Pos BUY #", posTicket, " was modified...", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added TP ", takeTPValue, " SL ", PositionGetDouble(POSITION_SL));
            } else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                sTrade.PositionModify(posTicket,PositionGetDouble(POSITION_SL),takeTPValue);
                 Print(" > Pos SELL #", posTicket, " was modified...", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added TP ", takeTPValue, " SL ", PositionGetDouble(POSITION_SL));
            }
        }
    }
    click(buttonName);
}

  else if (buttonName == BtnStopLoss){
  
      string takeSlString = ObjectGetString(0,StopLossInput ,OBJPROP_TEXT);
      takeSlValue = StringToDouble(takeSlString);
  async
    for(int i = PositionsTotal() -1; i >= 0; i--) {
        ulong posTicket = PositionGetTicket(i);
        if(PositionSelectByTicket(posTicket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                sTrade.PositionModify(posTicket,takeSlValue,PositionGetDouble(POSITION_TP));
                Print(" > Pos BUY #", posTicket, " was modified...", " price open ", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added SL ", takeSlValue, " TP ", PositionGetDouble(POSITION_TP));
            } else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                sTrade.PositionModify(posTicket,takeSlValue,PositionGetDouble(POSITION_TP));
                 Print(" > Pos SELL #", posTicket, " was modified...", " price open ", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added SL ", takeSlValue, " TP ", PositionGetDouble(POSITION_TP));
            } 
        }
    }
    click(buttonName);
}


   
}
// the function simulates a button click
void click(string buttonName) {
    ChartRedraw();
    ObjectSetInteger(0, buttonName, OBJPROP_COLOR, clrBlack);
    Sleep(100);
    ObjectSetInteger(0, buttonName, OBJPROP_STATE, false);
    ObjectSetInteger(0, buttonName, OBJPROP_COLOR, clrWhite);
    ChartRedraw();
}


void OnDeinit(const int reason){
    ObjectDelete(0, StopLossInput);
    ObjectDelete(0, BtnStopLoss);
    ObjectDelete(0, BtnTakeProfit);
    ObjectDelete(0, TakeProfitInput);
  }
  
void OnTick() {

  }
  

bool CreateButton(
    string objName,
    const string text,
    const color back_clr,
    int x,
    int y,
    const long chart_ID = 0,
    const int sub_window = 0,
    const int width = 80,
    const int height = 22,
    const ENUM_BASE_CORNER corner = CORNER_RIGHT_LOWER,
    const string font = "Arial",
    const int font_size = 10,
    const color clr = clrWhiteSmoke,
    const color border_clr = clrNONE,
    const bool back = false,
    const bool state = false,
    const bool selection = false,
    const bool hidden = false,
    const long z_order = 0)
{
  ResetLastError();
  if (!ObjectCreate(chart_ID, objName, OBJ_BUTTON, sub_window, 0, 0))
  {
    Print(__FUNCTION__,
          ": failed to create the button! Error code = ", GetLastError());
    return (false);
  }
  ObjectSetInteger(chart_ID, objName, OBJPROP_XDISTANCE, x);
  ObjectSetInteger(chart_ID, objName, OBJPROP_YDISTANCE, y);
  ObjectSetInteger(chart_ID, objName, OBJPROP_XSIZE, width);
  ObjectSetInteger(chart_ID, objName, OBJPROP_YSIZE, height);
  ObjectSetInteger(chart_ID, objName, OBJPROP_CORNER, corner);
  ObjectSetString(chart_ID, objName, OBJPROP_TEXT, text);
  ObjectSetString(chart_ID, objName, OBJPROP_FONT, font);
  ObjectSetInteger(chart_ID, objName, OBJPROP_FONTSIZE, font_size);
  ObjectSetInteger(chart_ID, objName, OBJPROP_COLOR, clr);
  ObjectSetInteger(chart_ID, objName, OBJPROP_BGCOLOR, back_clr);
  ObjectSetInteger(chart_ID, objName, OBJPROP_BORDER_COLOR, border_clr);
  ObjectSetInteger(chart_ID, objName, OBJPROP_BACK, back);
  ObjectSetInteger(chart_ID, objName, OBJPROP_STATE, state);
  ObjectSetInteger(chart_ID, objName, OBJPROP_SELECTABLE, selection);
  ObjectSetInteger(chart_ID, objName, OBJPROP_SELECTED, selection);
  ObjectSetInteger(chart_ID, objName, OBJPROP_HIDDEN, hidden);
  ObjectSetInteger(chart_ID, objName, OBJPROP_ZORDER, z_order);
  return (true);
}

bool CreateInput(
      string objName,
      const string description, 
      int x, 
      int y, 
      const ENUM_BASE_CORNER corner = CORNER_RIGHT_LOWER,
      const long chart_ID = 0)
{
    ResetLastError();
    
    if (!ObjectCreate(chart_ID, objName, OBJ_EDIT, 0, 0, 0))
    {
        Print("Failed to create input object! Error code: ", GetLastError());
        return false;
    }

    ObjectSetInteger(chart_ID, objName, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, objName, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(chart_ID, objName, OBJPROP_XSIZE, 80);
    ObjectSetInteger(chart_ID, objName, OBJPROP_YSIZE, 22);
    ObjectSetString(chart_ID, objName, OBJPROP_TEXT, description);
    ObjectSetInteger(chart_ID, objName, OBJPROP_COLOR, clrBlack);
    ObjectSetInteger(chart_ID, objName, OBJPROP_CORNER, corner);
    ObjectSetInteger(chart_ID, objName, OBJPROP_BGCOLOR, C'215, 219, 221');
    ObjectSetInteger(chart_ID, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   // ObjectSetInteger(chart_ID, objName, OBJPROP_FONT_SIZE, 10);
    ObjectSetInteger(chart_ID, objName, OBJPROP_BACK, true);
    ObjectSetInteger(chart_ID, objName, OBJPROP_BACK, false);
    return true;
}
