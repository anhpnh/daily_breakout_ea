#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double   Lot1=0.03;
input double   Lot2=0.01;
input double   Lot3=0.01;
input string   Com="Your comment";
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
      XoaLenhCu(Com);
      
      //BUY
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.01,
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - 0.05,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.05,
      Com
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot2,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.01,
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - 0.05,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.1,
      Com
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot3,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.01,
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - 0.05,
      iHigh(Symbol(), PERIOD_D1, 1) + 0.15,
      Com
      );
      
      //SELL
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_D1, 1) - 0.01,
      0,
      iLow(Symbol(), PERIOD_D1, 1) + 0.05,
      iLow(Symbol(), PERIOD_D1, 1) - 0.05,
      Com
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot2,
      iLow(Symbol(), PERIOD_D1, 1) - 0.01,
      0,
      iLow(Symbol(), PERIOD_D1, 1) + 0.05,
      iLow(Symbol(), PERIOD_D1, 1) - 0.10,
      Com
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot3,
      iLow(Symbol(), PERIOD_D1, 1) - 0.01,
      0,
      iLow(Symbol(), PERIOD_D1, 1) + 0.05,
      iLow(Symbol(), PERIOD_D1, 1) - 0.15,
      Com
      );
      
      last = Time[0];
   }
   
  }
  
 void XoaLenhCu(string comm){
   for (int i=OrdersTotal()-1; i>=0; i--){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderComment() == Com){
         OrderDelete(OrderTicket(), Red);
      }
   }
 }

