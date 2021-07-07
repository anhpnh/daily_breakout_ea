#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
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
      //Xoa lenh cu
      XoaLenhCu(Magic);
      
      //BUY
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_D1, 1) + 1*Point*10,
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_D1, 1) + TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot2,
      iHigh(Symbol(), PERIOD_D1, 1) + 1*Point*10,
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_D1, 1) + TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot3,
      iHigh(Symbol(), PERIOD_D1, 1) + 1*Point*10,
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
      iLow(Symbol(), PERIOD_D1, 1) - 1*Point*10,
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_D1, 1) - TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot2,
      iLow(Symbol(), PERIOD_D1, 1) - 1*Point*10,
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_D1, 1) - TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot3,
      iLow(Symbol(), PERIOD_D1, 1) - 1*Point*10,
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
 
