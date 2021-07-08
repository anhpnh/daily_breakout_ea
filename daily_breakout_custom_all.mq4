#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.02"
#property strict
//--- input parameters
input string   Scalping="Scalping D1, W1, MN1 Breakout for GU, EU, AU, UJ, Gold, GJ, EJ";
input bool D1=True;
input bool W1=False;
input bool MN1=False;
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
      veHighLow();

      //Xoa lenh cu
      XoaLenhCu(Magic);
      
      //Buy D1
      if(D1==True)
         buysellD1();
      if(W1==True)   
         buysellW1();
      if(MN1==True)   
         buysellMN1();
      
      
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
 
 void buysellD1(){
   //BUY D1
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
      
      //SELL D1
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
 }
 
 void buysellW1(){
   //BUY D1
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_W1, 1) + TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot2,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_W1, 1) + TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot3,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_W1, 1) + TP3*Point*10,
      Magic
      );
      
      //SELL D1
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_W1, 1) - TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot2,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_W1, 1) - TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot3,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_W1, 1) - TP3*Point*10,
      Magic
      );
 }
 
 void buysellMN1(){
   //BUY D1
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_MN1, 1) + TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot2,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_MN1, 1) + TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot3,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      iHigh(Symbol(), PERIOD_MN1, 1) + TP3*Point*10,
      Magic
      );
      
      //SELL D1
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_MN1, 1) - TP1*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot2,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_MN1, 1) - TP2*Point*10,
      Magic
      );
      
      OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot3,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      iLow(Symbol(), PERIOD_MN1, 1) - TP3*Point*10,
      Magic
      );
 }
 
 
 void veHighLow(){
   Comment("- High D1: "+(string)iHigh(Symbol(), PERIOD_D1, 1) + "\n" + "- Low D1: "+(string)iLow(Symbol(), PERIOD_D1, 1) + "\n"
   +       "- High W1: "+(string)iHigh(Symbol(), PERIOD_W1, 1) + "\n" + "- Low W1: "+(string)iLow(Symbol(), PERIOD_W1, 1) + "\n"
   +       "- High MN1: "+(string)iHigh(Symbol(), PERIOD_MN1, 1) + "\n" + "- Low MN1: "+(string)iLow(Symbol(), PERIOD_MN1, 1) + "\n"
   );
   ObjectsDeleteAll(0,"D1_H");
   ObjectsDeleteAll(0,"D1_L"); 
   ObjectsDeleteAll(0,"W1_H");
   ObjectsDeleteAll(0,"W1_L");
   ObjectsDeleteAll(0,"MN1_H");
   ObjectsDeleteAll(0,"MN1_L");
     
   //Draw D1 iHigh
   ObjectCreate("D1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_D1, 1));
   ObjectSet("D1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("D1_H", OBJPROP_COLOR, Purple);
   ObjectSet("D1_H", OBJPROP_WIDTH, 0);
   
   //Draw D1 iLow
   ObjectCreate("D1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_D1, 1));
   ObjectSet("D1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("D1_L", OBJPROP_COLOR, Purple);
   ObjectSet("D1_L", OBJPROP_WIDTH, 0);
   
   //Draw W1 iHigh
   ObjectCreate("W1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_W1, 1));
   ObjectSet("W1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("W1_H", OBJPROP_COLOR, Orange);
   ObjectSet("W1_H", OBJPROP_WIDTH, 0);
   
   //Draw W1 iLow
   ObjectCreate("W1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_W1, 1));
   ObjectSet("W1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("W1_L", OBJPROP_COLOR, Orange);
   ObjectSet("W1_L", OBJPROP_WIDTH, 0);
   
   //Draw MN1 iHigh
   ObjectCreate("MN1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_MN1, 1));
   ObjectSet("MN1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("MN1_H", OBJPROP_COLOR, Blue);
   ObjectSet("MN1_H", OBJPROP_WIDTH, 0);
   
   //Draw MN1 iLow
   ObjectCreate("MN1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_MN1, 1));
   ObjectSet("MN1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("MN1_L", OBJPROP_COLOR, Blue);
   ObjectSet("MN1_L", OBJPROP_WIDTH, 0);
}
