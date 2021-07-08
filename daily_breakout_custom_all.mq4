#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.02"
#property strict
//--- input parameters
input string   Scalping="Scalping Daily Breakout for GU, EU, AU, UJ, Gold, GJ, EJ";
input string   Lot="Default";
input double   Lot1=0.03;
input double   Lot2=0.01;
input double   Lot3=0.01;
input string   Stoploss="Pip - Goldx10";
input double   SL=5.0;
input string   TakeProfit="Pip - Goldx10";
input double   TP1=5.0;
input double   TP2=10.0;
input double   TP3=15.0;
input string   Magic="123456789";
datetime last;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }   
  
bool checkthuHai(){
   bool kq = false;
   if(DayOfWeek()==0)
      kq = true;
   return kq;
}                                         

void OnTick()
  {

   if(last != Time[0] && !checkthuHai()){
      Comment("High: "+(string)iHigh(Symbol(), PERIOD_D1, 1) + "\n" + "Low: "+(string)iLow(Symbol(), PERIOD_D1, 1) + "\n");
      ObjectsDeleteAll(0,"HLine");
      ObjectsDeleteAll(0,"LLine");   
      //Draw iHigh
      ObjectCreate("HLine", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_D1, 1));
      ObjectSet("HLine", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HLine", OBJPROP_COLOR, Purple);
      ObjectSet("HLine", OBJPROP_WIDTH, 0);
   
      //Draw iLow
      ObjectCreate("LLine", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_D1, 1));
        ObjectSet("LLine", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("LLine", OBJPROP_COLOR, Purple);
      ObjectSet("LLine", OBJPROP_WIDTH, 0);

      //Xoa lenh cu
      XoaLenhCu(Magic);
      
      //BUY
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_D1, 1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_D1, 1) + TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot2,
      iHigh(Symbol(), PERIOD_D1, 1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_D1, 1) + TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot3,
      iHigh(Symbol(), PERIOD_D1, 1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_D1, 1) + TP3*Point*10,
      Magic
      );
      
      //SELL
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_D1, 1) - TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot2,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_D1, 1) - TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot3,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_D1, 1) - TP3*Point*10,
      Magic
      );
      
      last = Time[0];
   }
   
  }
  
 void XoaLenhCu(string comm){
   for (int i=OrdersTotal()-1; i>=0; i--){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderComment() == Magic){
         OrderDelete(OrderTicket(), Red);
      }
   }
 }
 
